#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import argparse
import os
import sys
import tempfile


class FormatError(Exception):
    pass


def _next_nonempty(lines, index, path):
    while index < len(lines):
        text = lines[index].strip()
        index += 1
        if text:
            return text, index
    raise FormatError("%s: unexpected end of file" % path)


def read_axiom_layers(sas_path):
    with open(sas_path, "r") as stream:
        lines = stream.readlines()

    index = 0
    while index < len(lines) and lines[index].strip() != "begin_variables":
        index += 1
    if index >= len(lines):
        raise FormatError("%s: begin_variables not found" % sas_path)
    index += 1

    count_text, index = _next_nonempty(lines, index, sas_path)
    try:
        variable_count = int(count_text)
    except ValueError:
        raise FormatError("%s: invalid variable count: %s" %
                          (sas_path, count_text))

    layers = {}
    for expected in range(variable_count):
        line, index = _next_nonempty(lines, index, sas_path)
        fields = line.split()
        if len(fields) != 3 or not fields[0].startswith("var"):
            raise FormatError("%s: malformed variable line: %s" %
                              (sas_path, line))
        try:
            var_id = int(fields[0][3:])
            int(fields[1])
            axiom_layer = int(fields[2])
        except ValueError:
            raise FormatError("%s: malformed variable line: %s" %
                              (sas_path, line))
        if var_id in layers:
            raise FormatError("%s: duplicate variable var%d" %
                              (sas_path, var_id))
        layers[var_id] = axiom_layer

    end_marker, index = _next_nonempty(lines, index, sas_path)
    if end_marker != "end_variables":
        raise FormatError("%s: expected end_variables, got %s" %
                          (sas_path, end_marker))

    if len(layers) != variable_count:
        raise FormatError("%s: variable count mismatch" % sas_path)
    return layers


def read_groups(groups_path):
    with open(groups_path, "r") as stream:
        lines = stream.readlines()

    index = 0
    marker, index = _next_nonempty(lines, index, groups_path)
    if marker != "begin_groups":
        raise FormatError("%s: expected begin_groups, got %s" %
                          (groups_path, marker))

    count_text, index = _next_nonempty(lines, index, groups_path)
    try:
        group_count = int(count_text)
    except ValueError:
        raise FormatError("%s: invalid group count: %s" %
                          (groups_path, count_text))

    groups = []
    for group_index in range(group_count):
        marker, index = _next_nonempty(lines, index, groups_path)
        if marker != "group":
            raise FormatError("%s: group %d: expected group, got %s" %
                              (groups_path, group_index, marker))

        count_text, index = _next_nonempty(lines, index, groups_path)
        try:
            fact_count = int(count_text)
        except ValueError:
            raise FormatError("%s: group %d: invalid fact count: %s" %
                              (groups_path, group_index, count_text))

        facts = []
        for fact_index in range(fact_count):
            line, index = _next_nonempty(lines, index, groups_path)
            fields = line.split()
            if len(fields) < 4:
                raise FormatError(
                    "%s: group %d fact %d: malformed line: %s" %
                    (groups_path, group_index, fact_index, line))
            try:
                var_id = int(fields[0])
                int(fields[1])
                arity = int(fields[3])
            except ValueError:
                raise FormatError(
                    "%s: group %d fact %d: malformed line: %s" %
                    (groups_path, group_index, fact_index, line))
            if arity < 0 or len(fields) != 4 + arity:
                raise FormatError(
                    "%s: group %d fact %d: arity mismatch: %s" %
                    (groups_path, group_index, fact_index, line))
            facts.append((var_id, line))

        groups.append(facts)

    marker, index = _next_nonempty(lines, index, groups_path)
    if marker != "end_groups":
        raise FormatError("%s: expected end_groups, got %s" %
                          (groups_path, marker))
    return groups


def write_atomic(path, groups):
    directory = os.path.dirname(os.path.abspath(path))
    if not os.path.isdir(directory):
        os.makedirs(directory)

    fd, temporary = tempfile.mkstemp(prefix=".cegis-groups-",
                                     dir=directory,
                                     text=True)
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write("begin_groups\n")
            stream.write("%d\n" % len(groups))
            for facts in groups:
                stream.write("group\n")
                stream.write("%d\n" % len(facts))
                for _, line in facts:
                    stream.write(line)
                    stream.write("\n")
            stream.write("end_groups\n")
        os.rename(temporary, path)
    except Exception:
        try:
            os.unlink(temporary)
        except OSError:
            pass
        raise


def filter_groups(sas_path, groups_path, output_path):
    layers = read_axiom_layers(sas_path)
    groups = read_groups(groups_path)

    output_groups = []
    kept_facts = 0
    skipped_derived_facts = 0

    for facts in groups:
        kept = []
        for var_id, line in facts:
            if var_id not in layers:
                raise FormatError(
                    "%s: variable %d from groups is absent from %s" %
                    (groups_path, var_id, sas_path))
            if layers[var_id] >= 0:
                skipped_derived_facts += 1
                continue
            kept.append((var_id, line))
            kept_facts += 1
        if kept:
            output_groups.append(kept)

    if not output_groups:
        raise FormatError(
            "filter removed every group; refusing to create an empty CEGIS map")

    write_atomic(output_path, output_groups)
    return (len(groups), len(output_groups),
            kept_facts, skipped_derived_facts)


def main(argv=None):
    parser = argparse.ArgumentParser(
        description=("Create a CEGIS SAS/PDDL fact map that excludes "
                     "axiom/derived SAS variables."))
    parser.add_argument("--sas", required=True,
                        help="translator output.sas")
    parser.add_argument("--groups", required=True,
                        help="complete all.groups")
    parser.add_argument("--output", required=True,
                        help="filtered CEGIS groups file")
    args = parser.parse_args(argv)

    try:
        source_groups, output_groups, kept, skipped = filter_groups(
            args.sas, args.groups, args.output)
    except (IOError, OSError, FormatError) as error:
        print("[IGC-GROUP-FILTER] ERROR: %s" % error, file=sys.stderr)
        return 1

    print("[IGC-GROUP-FILTER] source_groups=%d output_groups=%d "
          "kept_base_facts=%d skipped_derived_facts=%d output=%s" %
          (source_groups, output_groups, kept, skipped,
           os.path.abspath(args.output)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
