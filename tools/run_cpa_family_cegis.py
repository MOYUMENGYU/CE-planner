#!/usr/bin/env python3
"""Launch a CPA-family candidate planner through CE-planner PDDL adaptation."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
from pathlib import Path
from typing import Dict, Tuple


def normalize_kind(value: str) -> str:
    aliases = {
        "1": "cnf",
        "2": "dnf",
        "3": "pip",
        "cnf": "cnf",
        "dnf": "dnf",
        "pip": "pip",
    }
    key = value.strip().lower()
    if key not in aliases:
        raise ValueError(f"unsupported CPA-family planner: {value}")
    return aliases[key]


def planner_config(kind: str, project_root: Path) -> Tuple[Path, str, str]:
    table: Dict[str, Tuple[str, str, str]] = {
        "cnf": ("IGC_CNF_DIR", "cnf_planner", "cnf"),
        "dnf": ("IGC_DNF_DIR", "dnf_planner", "dnf"),
        "pip": ("IGC_PIP_DIR", "pip_planner", "pip"),
    }
    env_name, default_dir, binary = table[kind]
    source = Path(os.environ.get(env_name, project_root / default_dir)).resolve()
    return source, env_name, binary


def require_file(path: Path, executable: bool = False) -> None:
    if not path.is_file():
        raise RuntimeError(f"missing required file: {path}")
    if executable and not os.access(path, os.X_OK):
        raise RuntimeError(f"required file is not executable: {path}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("planner")
    parser.add_argument("plan_args", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    kind = normalize_kind(args.planner)

    tools_dir = Path(__file__).resolve().parent
    project_root = Path(
        os.environ.get("IGC_CPA_ADAPTER_PROJECT_ROOT", tools_dir.parent)
    ).resolve()
    source_dir, env_name, binary_name = planner_config(kind, project_root)

    real_converter = source_dir / "cpa.pddl2pl"
    real_binary = source_dir / binary_name
    real_mult = source_dir / "mult5zsic.pl"
    adapter = Path(
        os.environ.get(
            "IGC_CPA_PDDL_ADAPTER", project_root / "tools/adapt_cpa_refined_pddl.py"
        )
    ).resolve()
    converter_wrapper = project_root / "tools/cpa_pddl2pl_adapter.sh"
    plan_exec = Path(
        os.environ.get("IGC_CPA_ADAPTER_PLAN_EXEC", project_root / "plan-cegis")
    ).resolve()

    require_file(real_converter, executable=True)
    require_file(real_binary, executable=True)
    require_file(real_mult)
    require_file(adapter)
    require_file(converter_wrapper)
    require_file(plan_exec, executable=True)

    runtime = Path(tempfile.mkdtemp(prefix=f"ce-planner-{kind}-adapter-"))
    try:
        (runtime / binary_name).symlink_to(real_binary)
        (runtime / "mult5zsic.pl").symlink_to(real_mult)
        (runtime / "cpa.pddl2pl").symlink_to(converter_wrapper)

        env = os.environ.copy()
        env["IGC_CANDIDATE_PLANNER"] = kind
        env["IGC_CPA_REAL_PDDL2PL"] = str(real_converter)
        env["IGC_CPA_PDDL_ADAPTER"] = str(adapter)
        env[env_name] = str(runtime)

        print(
            f"[CPA-PDDL-ADAPTER] planner={kind} "
            f"source_runtime={source_dir} adapter_runtime={runtime}"
        )
        completed = subprocess.run([str(plan_exec), *args.plan_args], env=env)
        return completed.returncode
    finally:
        shutil.rmtree(runtime, ignore_errors=True)


if __name__ == "__main__":
    raise SystemExit(main())
