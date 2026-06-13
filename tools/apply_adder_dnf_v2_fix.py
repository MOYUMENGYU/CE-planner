#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function

import argparse
import hashlib
import os
import shutil
import sys


def replace_once(text, old, new, label):
    if new in text:
        return text, False
    count = text.count(old)
    if count == 0:
        raise RuntimeError("missing patch anchor: %s" % label)
    if count != 1:
        raise RuntimeError("ambiguous patch anchor %s: %d matches" % (label, count))
    return text.replace(old, new, 1), True


def write_backup(path):
    backup = path + ".bak-adder-dnf-v2"
    if not os.path.exists(backup):
        shutil.copy2(path, backup)
    return backup


def patch_framework(path):
    with open(path, "r", encoding="utf-8") as stream:
        text = stream.read()
    original = text

    old = '''                std::map<int, int>::const_iterator remap = original_to_current.find(var);\n                if (remap == original_to_current.end()) return STATUS_MAPPING_ERROR;\n                facts_[std::make_pair(remap->second, val)] = atom;'''
    new = '''                std::map<int, int>::const_iterator remap = original_to_current.find(var);\n                if (remap == original_to_current.end()) return STATUS_MAPPING_ERROR;\n                const int current_var = remap->second;\n                if (current_var >= 0 &&\n                    current_var < static_cast<int>(g_axiom_layers.size()) &&\n                    g_axiom_layers[current_var] >= 0) {\n                    // Derived/axiom SAS values are internal semantic facts.\n                    // They must never be emitted as ordinary PDDL fluents in\n                    // a refined external-planner problem.\n                    continue;\n                }\n                facts_[std::make_pair(current_var, val)] = atom;'''
    text, _ = replace_once(text, old, new, "defensive derived-variable filter")

    old = '''    static void print_common_diagnostics(const std::string &prefix,\n                                         const std::string &stdout_path,\n                                         const std::string &stderr_path,\n                                         const std::string &extra_path) {\n        const std::string planner_err = one_line_excerpt(stderr_path, 700);\n        const std::string planner_out = one_line_excerpt(stdout_path, 900);\n        const std::string extra = one_line_excerpt(extra_path, 700);\n        if (!planner_err.empty())\n            std::cout << prefix << " planner.stderr: " << planner_err << std::endl;\n        if (!extra.empty())\n            std::cout << prefix << " diagnostic: " << extra << std::endl;\n        if (!planner_out.empty())\n            std::cout << prefix << " planner.stdout: " << planner_out << std::endl;\n    }\n'''
    new = old + '''\n    static StatusCode prepare_cpa_sicstus_input(\n            const std::string &path, std::string *message) {\n        const std::string configured = trim(\n            getenv_string("IGC_CPA_SICSTUS_INPUT_FILE", ""));\n        std::string content;\n        if (!configured.empty()) {\n            const std::string source = absolute_path(configured);\n            if (!read_file(source, &content)) {\n                if (message)\n                    *message = std::string("cannot read configured input: ") + source;\n                return STATUS_IO_ERROR;\n            }\n        } else {\n            // The bundled CPA-family front-end expects two affirmative answers.\n            // Do not trust the mutable solver-directory input file: native mode\n            // may leave it stale or overwritten by a previous manual experiment.\n            content = "y\\ny\\n";\n        }\n\n        std::istringstream in(content);\n        std::string line;\n        int answers = 0;\n        while (std::getline(in, line)) {\n            const std::string answer = lower_ascii(trim(line));\n            if (answer.empty()) continue;\n            if (answer != "y" && answer != "yes" &&\n                answer != "n" && answer != "no") {\n                if (message) {\n                    std::ostringstream out;\n                    out << "invalid SICStus answer line " << (answers + 1)\n                        << ": " << line;\n                    *message = out.str();\n                }\n                return STATUS_INPUT_ERROR;\n            }\n            ++answers;\n        }\n        if (answers < 2) {\n            if (message)\n                *message = "SICStus control input must contain at least two answers";\n            return STATUS_INPUT_ERROR;\n        }\n        if (!write_file_atomic(path, content)) {\n            if (message) *message = std::string("cannot write input: ") + path;\n            return STATUS_IO_ERROR;\n        }\n        if (message) {\n            *message = configured.empty()\n                ? std::string("generated deterministic input at ") + path\n                : std::string("copied configured input to ") + path;\n        }\n        return STATUS_OK;\n    }\n'''
    text, _ = replace_once(text, old, new, "CPA SICStus input helper")

    old = '''        const Entry entries[] = {\n            {"cpa.pddl2pl", true},\n            {"mult5zsic.pl", false},\n            {"input", false}\n        };'''
    new = '''        const Entry entries[] = {\n            {"cpa.pddl2pl", true},\n            {"mult5zsic.pl", false}\n        };'''
    text, _ = replace_once(text, old, new, "remove mutable isolated input link")

    old = '''        const std::string binary = cpa_binary_name();\n        const std::string sicstus = getenv_string("IGC_SICSTUS_EXEC", "sicstus");\n        const std::string plan_result = workspace + "/plan-result";\n        ::unlink(stdout_path.c_str());'''
    new = '''        const std::string binary = cpa_binary_name();\n        const std::string sicstus = getenv_string("IGC_SICSTUS_EXEC", "sicstus");\n        const std::string plan_result = workspace + "/plan-result";\n        const std::string sicstus_input = workspace + "/sicstus.input";\n        std::string input_message;\n        st = prepare_cpa_sicstus_input(sicstus_input, &input_message);\n        if (st != STATUS_OK) {\n            std::cout << prefix << " SICStus input preparation failed: "\n                      << input_message << std::endl;\n            return st;\n        }\n        std::cout << prefix << " SICStus input=" << input_message << std::endl;\n        ::unlink(stdout_path.c_str());'''
    text, _ = replace_once(text, old, new, "isolated input preparation")

    old = '''                 << shell_quote(sicstus)\n                 << " -l new.pl --goal 'main,halt.' < input > trash && "'''
    new = '''                 << shell_quote(sicstus)\n                 << " -l new.pl --goal 'main,halt.' < "\n                 << shell_quote(absolute_path(sicstus_input))\n                 << " > trash && "'''
    text, _ = replace_once(text, old, new, "isolated deterministic input redirect")

    old = '''    const std::string all_groups = absolute_path(getenv_string("IGC_ALL_GROUPS", "all.groups"));\n    const std::string oneof_initial = absolute_path(getenv_string("IGC_ONEOF_INITIAL", "oneof_initial"));'''
    new = '''    const std::string all_groups = absolute_path(\n        getenv_string("IGC_ALL_GROUPS", "all.groups"));\n    const std::string cegis_fact_groups = absolute_path(\n        getenv_string("IGC_CEGIS_FACT_GROUPS", all_groups));\n    const std::string oneof_initial = absolute_path(\n        getenv_string("IGC_ONEOF_INITIAL", "oneof_initial"));'''
    text, _ = replace_once(text, old, new, "separate full and CEGIS groups")

    old = '''    copy_file(ctx.domain_path, original_dir + "/domain.pddl");\n    copy_file(ctx.problem_path, original_dir + "/problem.pddl");\n    copy_file(all_groups, original_dir + "/all.groups");\n    copy_file(oneof_initial, original_dir + "/oneof_initial");\n\n    SasPddlFactMap fact_map;\n    st = fact_map.load(all_groups, ctx.variable_names);\n    if (st != STATUS_OK) {\n        std::cerr << "[IGC-CEGIS] cannot load all.groups: " << status_name(st) << std::endl;\n        return st;\n    }'''
    new = '''    copy_file(ctx.domain_path, original_dir + "/domain.pddl");\n    copy_file(ctx.problem_path, original_dir + "/problem.pddl");\n    copy_file(all_groups, original_dir + "/all.groups");\n    copy_file(cegis_fact_groups, original_dir + "/cegis.groups");\n    copy_file(oneof_initial, original_dir + "/oneof_initial");\n\n    SasPddlFactMap fact_map;\n    st = fact_map.load(cegis_fact_groups, ctx.variable_names);\n    if (st != STATUS_OK) {\n        std::cerr << "[IGC-CEGIS] cannot load CEGIS fact groups: "\n                  << cegis_fact_groups << " status=" << status_name(st)\n                  << std::endl;\n        return st;\n    }'''
    text, _ = replace_once(text, old, new, "use filtered map while preserving full map")

    old = '''              << " planner_timeout=" << timeout_seconds\n              << " run_dir=" << run_dir << std::endl;'''
    new = '''              << " planner_timeout=" << timeout_seconds\n              << " run_dir=" << run_dir << std::endl;\n    std::cout << "[IGC-CEGIS] groups_full=" << all_groups\n              << " groups_cegis=" << cegis_fact_groups << std::endl;'''
    text, _ = replace_once(text, old, new, "group path logging")

    if text != original:
        write_backup(path)
        with open(path, "w", encoding="utf-8", newline="\n") as stream:
            stream.write(text)
        return True
    return False


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", default=".")
    args = parser.parse_args()
    repo = os.path.abspath(args.repo)
    framework = os.path.join(repo, "lama", "search", "cegis_framework.cc")
    if not os.path.isfile(framework):
        print("ERROR: missing %s" % framework, file=sys.stderr)
        return 1
    try:
        changed = patch_framework(framework)
    except Exception as exc:
        print("ERROR: %s" % exc, file=sys.stderr)
        return 1
    print(("UPDATED" if changed else "ALREADY UPDATED") + ": " + framework)
    return 0


if __name__ == "__main__":
    sys.exit(main())
