#!/usr/bin/env python3
"""Adapt CE-planner refined PDDL before CNF, DNF or PIP conversion.

Only the framework-generated combined PDDL is changed. The external planner,
its converter, its SICStus program and its executable remain untouched.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import tempfile
from pathlib import Path

from cpa_pddl_sexpr import parse_all, render
from cpa_refined_samples import adapt_refined_samples


def atomic_write(path: Path, text: str) -> None:
    descriptor, temporary = tempfile.mkstemp(
        prefix=path.name + ".", suffix=".tmp", dir=str(path.parent)
    )
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8", newline="\n") as stream:
            stream.write(text)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    except Exception:
        try:
            os.unlink(temporary)
        except OSError:
            pass
        raise


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("pddl", type=Path, help="combined domain and problem dp.pddl")
    args = parser.parse_args()

    original = args.pddl.read_text(encoding="utf-8")
    forms = parse_all(original)
    metadata = adapt_refined_samples(forms, original)
    adapted = "\n\n".join(render(form) for form in forms) + "\n"
    parse_all(adapted)

    backup = args.pddl.with_name(args.pddl.name + ".before-cpa-adapter")
    if not backup.exists():
        shutil.copy2(args.pddl, backup)
    atomic_write(args.pddl, adapted)
    atomic_write(
        args.pddl.with_name("cpa-pddl-adapter.json"),
        json.dumps(metadata, indent=2, sort_keys=True) + "\n",
    )
    print(
        "[CPA-PDDL-ADAPTER] projected_worlds={projected_worlds} "
        "selector_worlds={selector_worlds} encoded_atoms={encoded_atoms} "
        "implications={selector_implications}".format(**metadata)
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
