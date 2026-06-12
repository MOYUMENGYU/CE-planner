#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import pathlib
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import filter_cegis_groups as filter_groups_module


class FilterCegisGroupsTest(unittest.TestCase):
    def write_file(self, directory, name, text):
        path = pathlib.Path(directory) / name
        path.write_text(text, encoding="utf-8")
        return str(path)

    def test_derived_variables_are_removed(self):
        with tempfile.TemporaryDirectory() as directory:
            sas = """begin_variables
4
var0 2 -1
var1 2 0
var2 2 -1
var3 2 1
end_variables
"""
            groups = """begin_groups
4
group
1
0 0 low 1 x1
group
1
1 0 new-axiom@0 0
group
1
2 0 high 1 z2
group
1
3 0 new-axiom@1 0
end_groups
"""
            sas_path = self.write_file(directory, "output.sas", sas)
            groups_path = self.write_file(directory, "all.groups", groups)
            output_path = os.path.join(directory, "cegis.groups")

            stats = filter_groups_module.filter_groups(
                sas_path, groups_path, output_path)
            self.assertEqual(stats, (4, 2, 2, 2))

            result = pathlib.Path(output_path).read_text(encoding="utf-8")
            self.assertNotIn("new-axiom", result)
            self.assertNotIn("@", result)
            self.assertIn("low 1 x1", result)
            self.assertIn("high 1 z2", result)

    def test_unknown_variable_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            sas = """begin_variables
1
var0 2 -1
end_variables
"""
            groups = """begin_groups
1
group
1
7 0 unknown 0
end_groups
"""
            sas_path = self.write_file(directory, "output.sas", sas)
            groups_path = self.write_file(directory, "all.groups", groups)
            output_path = os.path.join(directory, "cegis.groups")

            with self.assertRaises(filter_groups_module.FormatError):
                filter_groups_module.filter_groups(
                    sas_path, groups_path, output_path)


if __name__ == "__main__":
    unittest.main()
