#!/usr/bin/env python3
"""Apply the native/isolated candidate runtime-mode patch to CE-planner.

The transformation is intentionally strict: each reviewed anchor must occur
exactly once. The script prepares all edits in memory before writing either
file, so a mismatched source version cannot leave a partially patched tree.
"""
from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(
            f"{label}: expected exactly one anchor, found {count}. "
            "The source version may differ; no file was changed."
        )
    return text.replace(old, new, 1)


def patch_source(original: str) -> str:
    if '#include "cegis_native_runtime.inc"' in original:
        return original

    text = original
    text = replace_once(
        text,
        "};\n\nenum RefinedPddlProfile {",
        "};\n\n"
        "enum CandidateRuntimeMode {\n"
        "    CANDIDATE_RUNTIME_NATIVE = 0,\n"
        "    CANDIDATE_RUNTIME_ISOLATED = 1\n"
        "};\n\n"
        "static const char *candidate_runtime_mode_name(\n"
        "        CandidateRuntimeMode mode) {\n"
        "    return mode == CANDIDATE_RUNTIME_NATIVE\n"
        "        ? \"NATIVE\" : \"ISOLATED\";\n"
        "}\n\n"
        "enum RefinedPddlProfile {",
        "runtime-mode enum",
    )
    text = replace_once(
        text,
        "    explicit CandidatePlannerRunner(CandidatePlannerKind kind) : kind_(kind) {}",
        "    CandidatePlannerRunner(CandidatePlannerKind kind,\n"
        "                           CandidateRuntimeMode runtime_mode)\n"
        "        : kind_(kind), runtime_mode_(runtime_mode) {}",
        "runner constructor",
    )
    text = replace_once(
        text,
        "                   int timeout_seconds,\n"
        "                   std::string *result_path) const {\n"
        "        if (kind_ == CANDIDATE_PLANNER_T1)",
        "                   int timeout_seconds,\n"
        "                   std::string *result_path) const {\n"
        "        if (runtime_mode_ == CANDIDATE_RUNTIME_NATIVE)\n"
        "            return run_native(domain, problem, iter_dir,\n"
        "                              timeout_seconds, result_path);\n"
        "        if (kind_ == CANDIDATE_PLANNER_T1)",
        "runner mode dispatch",
    )
    text = replace_once(
        text,
        "    CandidatePlannerKind kind_;\n};",
        "#include \"cegis_native_runtime.inc\"\n\n"
        "    CandidatePlannerKind kind_;\n"
        "    CandidateRuntimeMode runtime_mode_;\n"
        "};",
        "native implementation include",
    )
    text = replace_once(
        text,
        "static int configured_planner_timeout(CandidatePlannerKind kind) {",
        "static StatusCode configured_candidate_runtime_mode(\n"
        "        CandidateRuntimeMode *mode) {\n"
        "    const std::string value = lower_ascii(trim(getenv_string(\n"
        "        \"IGC_CANDIDATE_RUNTIME_MODE\", \"native\")));\n"
        "    if (value == \"native\" || value == \"original\" ||\n"
        "        value == \"solver_dir\" || value == \"solver-dir\") {\n"
        "        *mode = CANDIDATE_RUNTIME_NATIVE;\n"
        "        return STATUS_OK;\n"
        "    }\n"
        "    if (value == \"isolated\" || value == \"workspace\" ||\n"
        "        value == \"debug\") {\n"
        "        *mode = CANDIDATE_RUNTIME_ISOLATED;\n"
        "        return STATUS_OK;\n"
        "    }\n"
        "    return STATUS_INPUT_ERROR;\n"
        "}\n\n"
        "static int configured_planner_timeout(CandidatePlannerKind kind) {",
        "runtime-mode parser",
    )
    text = replace_once(
        text,
        "    const std::string all_groups = absolute_path(getenv_string(\"IGC_ALL_GROUPS\", \"all.groups\"));",
        "    CandidateRuntimeMode runtime_mode = CANDIDATE_RUNTIME_NATIVE;\n"
        "    const StatusCode runtime_config =\n"
        "        configured_candidate_runtime_mode(&runtime_mode);\n"
        "    if (runtime_config != STATUS_OK) {\n"
        "        std::cerr << \"[IGC-CEGIS] invalid IGC_CANDIDATE_RUNTIME_MODE; \"\n"
        "                  << \"expected native|isolated.\" << std::endl;\n"
        "        return runtime_config;\n"
        "    }\n"
        "    const std::string all_groups = absolute_path(getenv_string(\"IGC_ALL_GROUPS\", \"all.groups\"));",
        "runtime-mode configuration",
    )
    text = replace_once(
        text,
        "    std::ostringstream default_run;\n"
        "    default_run << \"runs/run_\" << ::getpid();\n"
        "    const std::string run_dir = absolute_path(getenv_string(\"IGC_CEGIS_RUN_DIR\", default_run.str()));",
        "    std::string default_run;\n"
        "    if (runtime_mode == CANDIDATE_RUNTIME_NATIVE) {\n"
        "        default_run = \"runs/current\";\n"
        "    } else {\n"
        "        std::ostringstream isolated_run;\n"
        "        isolated_run << \"runs/run_\" << ::getpid();\n"
        "        default_run = isolated_run.str();\n"
        "    }\n"
        "    const std::string run_dir = absolute_path(getenv_string(\n"
        "        \"IGC_CEGIS_RUN_DIR\", default_run));",
        "run-directory selection",
    )
    text = replace_once(
        text,
        "    CandidatePlannerRunner runner(planner_kind);",
        "    CandidatePlannerRunner runner(planner_kind, runtime_mode);",
        "runner construction",
    )
    text = replace_once(
        text,
        "              << \" candidate_planner=\" << candidate_planner_display_name(planner_kind)\n"
        "              << \" planner_timeout=\" << timeout_seconds",
        "              << \" candidate_planner=\" << candidate_planner_display_name(planner_kind)\n"
        "              << \" runtime_mode=\" << candidate_runtime_mode_name(runtime_mode)\n"
        "              << \" planner_timeout=\" << timeout_seconds",
        "startup logging",
    )
    text = replace_once(
        text,
        "        const std::string idir = iteration_dir(run_dir, iteration);\n"
        "        if (!mkdirs(idir)) return STATUS_IO_ERROR;\n"
        "        st = store.dump_json(idir + \"/counterexamples.json\", iteration);\n"
        "        if (st != STATUS_OK) return st;\n"
        "        store.dump_json(run_dir + \"/counterexamples.json\", iteration);",
        "        const std::string idir =\n"
        "            runtime_mode == CANDIDATE_RUNTIME_NATIVE\n"
        "                ? run_dir : iteration_dir(run_dir, iteration);\n"
        "        if (!mkdirs(idir)) return STATUS_IO_ERROR;\n"
        "        st = store.dump_json(idir + \"/counterexamples.json\", iteration);\n"
        "        if (st != STATUS_OK) return st;\n"
        "        if (idir != run_dir)\n"
        "            store.dump_json(run_dir + \"/counterexamples.json\", iteration);",
        "per-iteration directory selection",
    )
    return text


def patch_makefile(original: str) -> str:
    dependency_line = (
        "cegis_framework.o cegis_framework.profile.o "
        "cegis_framework.release.o: cegis_native_runtime.inc"
    )
    if dependency_line in original:
        return original
    return replace_once(
        original,
        "$(RELEASE_OBJECTS): %.release.o: %.cc\n"
        "\t$(CC) $(RELEASEOPT) -c $< -o obj/$@ \n\n",
        "$(RELEASE_OBJECTS): %.release.o: %.cc\n"
        "\t$(CC) $(RELEASEOPT) -c $< -o obj/$@ \n\n"
        "# cegis_framework.cc includes the native runtime implementation.\n"
        "cegis_framework.o cegis_framework.profile.o "
        "cegis_framework.release.o: cegis_native_runtime.inc\n\n",
        "native include dependency",
    )


def atomic_write(path: Path, text: str, suffix: str) -> None:
    temp = path.with_name(path.name + suffix)
    temp.write_text(text, encoding="utf-8")
    temp.replace(path)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--repo",
        default=".",
        help="CE-planner repository root (default: current directory)",
    )
    args = parser.parse_args()

    repo = Path(args.repo).resolve()
    source = repo / "lama/search/cegis_framework.cc"
    makefile = repo / "lama/search/Makefile"
    include_file = repo / "lama/search/cegis_native_runtime.inc"
    if not source.is_file():
        raise RuntimeError(f"missing source file: {source}")
    if not makefile.is_file():
        raise RuntimeError(f"missing Makefile: {makefile}")
    if not include_file.is_file():
        raise RuntimeError(
            f"missing native implementation: {include_file}. "
            "Copy the package's lama/search/cegis_native_runtime.inc first."
        )

    original_source = source.read_text(encoding="utf-8")
    original_makefile = makefile.read_text(encoding="utf-8")

    # Prepare both transformations before any write. A bad anchor aborts here.
    patched_source = patch_source(original_source)
    patched_makefile = patch_makefile(original_makefile)
    source_changed = patched_source != original_source
    makefile_changed = patched_makefile != original_makefile
    if not source_changed and not makefile_changed:
        print("candidate runtime-mode patch is already applied")
        return 0

    source_backup = source.with_name(source.name + ".bak-native-runtime")
    makefile_backup = makefile.with_name("Makefile.bak-native-runtime")
    if source_changed and not source_backup.exists():
        shutil.copy2(source, source_backup)
    if makefile_changed and not makefile_backup.exists():
        shutil.copy2(makefile, makefile_backup)

    if source_changed:
        atomic_write(source, patched_source, ".tmp-native-runtime")
    if makefile_changed:
        atomic_write(makefile, patched_makefile, ".tmp-native-runtime")

    if source_changed:
        print(f"patched: {source}")
        print(f"backup:  {source_backup}")
    if makefile_changed:
        print(f"patched: {makefile}")
        print(f"backup:  {makefile_backup}")
    print(
        "default mode: native; set IGC_CANDIDATE_RUNTIME_MODE=isolated "
        "to restore the old workflow"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
