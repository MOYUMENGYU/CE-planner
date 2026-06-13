#!/usr/bin/env python3

import tempfile
import unittest
from pathlib import Path

from normalize_cpa_theory import declared, referenced, repair


class TheoryClosureTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.pddl2pl = self.root / "pddl2pl.pl"

    def tearDown(self):
        self.temp.cleanup()

    def write_theory(self, text):
        path = self.root / "theory_0.al"
        path.write_text(text, encoding="utf-8")
        return path

    def test_repairs_negative_effect_only_fluent_and_initial_value(self):
        theory = self.write_theory(
            "fluent cpa_bad(cpa_p0);\n"
            "action cpa_copy(cpa_p0);\n"
            "cpa_copy(cpa_p0) causes -cpa_noisy(cpa_p0) "
            "if cpa_bad(cpa_p0);\n"
            "initially -cpa_bad(cpa_p0);\n"
            "goal -cpa_bad(cpa_p0);\n"
        )
        self.pddl2pl.write_text(
            "cpa_initially(neg(cpa_noisy(cpa_p0))).\n", encoding="utf-8"
        )

        missing, restored = repair(theory, self.pddl2pl)
        repaired = theory.read_text(encoding="utf-8")

        self.assertEqual(missing, ["cpa_noisy(cpa_p0)"])
        self.assertEqual(restored, ["-cpa_noisy(cpa_p0)"])
        self.assertIn("fluent cpa_noisy(cpa_p0);", repaired)
        self.assertIn("initially -cpa_noisy(cpa_p0);", repaired)
        self.assertEqual(
            referenced(repaired.splitlines()) - declared(repaired.splitlines()), set()
        )

    def test_repairs_negative_precondition_and_effect_condition(self):
        theory = self.write_theory(
            "fluent cpa_goal;\n"
            "action cpa_act;\n"
            "executable cpa_act if -cpa_guard;\n"
            "cpa_act causes cpa_goal if cpa_trigger;\n"
            "goal cpa_goal;\n"
        )
        self.pddl2pl.write_text("", encoding="utf-8")

        missing, restored = repair(theory, self.pddl2pl)

        self.assertEqual(missing, ["cpa_guard", "cpa_trigger"])
        self.assertEqual(restored, [])

    def test_closed_theory_is_unchanged(self):
        text = (
            "fluent cpa_ready;\n"
            "action cpa_act;\n"
            "executable cpa_act if cpa_ready;\n"
            "goal cpa_ready;\n"
        )
        theory = self.write_theory(text)
        self.pddl2pl.write_text("", encoding="utf-8")

        missing, restored = repair(theory, self.pddl2pl)

        self.assertEqual(missing, [])
        self.assertEqual(restored, [])
        self.assertEqual(theory.read_text(encoding="utf-8"), text)


if __name__ == "__main__":
    unittest.main()
