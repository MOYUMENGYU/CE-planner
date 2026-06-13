#!/usr/bin/env python3
"""Repair missing fluent declarations in generated CPA-family AL theories."""

from __future__ import annotations

import argparse
import os
import re
import sys
import tempfile
from pathlib import Path
from typing import Dict, Iterable, List, Set, Tuple

CPA_TERM = r"cpa_[A-Za-z0-9_]+(?:\([^()]*\))?"
TERM_RE = re.compile(r"(?<![A-Za-z0-9_])(-?" + CPA_TERM + r")")
DECL_RE = re.compile(r"^\s*fluent\s+(.+?)\s*;\s*$")


def canonical(term: str) -> str:
    compact = re.sub(r"\s+", "", term.strip())
    return compact[1:] if compact.startswith("-") else compact


def expression_parts(line: str) -> List[str]:
    text = line.strip()
    lowered = text.lower()
    if lowered.startswith("initially "):
        return [text[len("initially ") :].rsplit(";", 1)[0]]
    if lowered.startswith("goal "):
        return [text[len("goal ") :].rsplit(";", 1)[0]]
    if lowered.startswith("executable ") and " if " in text:
        return [text.split(" if ", 1)[1].rsplit(";", 1)[0]]
    if " causes " in text:
        rhs = text.split(" causes ", 1)[1].rsplit(";", 1)[0]
        if " if " in rhs:
            effect, condition = rhs.split(" if ", 1)
            return [effect, condition]
        return [rhs]
    return []


def referenced(lines: Iterable[str]) -> Set[str]:
    result: Set[str] = set()
    for line in lines:
        for expression in expression_parts(line):
            for match in TERM_RE.finditer(expression):
                result.add(canonical(match.group(1)))
    return result


def declared(lines: Iterable[str]) -> Set[str]:
    result: Set[str] = set()
    for line in lines:
        match = DECL_RE.match(line)
        if match:
            result.add(canonical(match.group(1)))
    return result


def initial_values(pddl2pl: Path) -> Dict[str, bool]:
    values: Dict[str, bool] = {}
    if not pddl2pl.is_file():
        return values
    compact = re.sub(
        r"\s+", "", pddl2pl.read_text(encoding="utf-8", errors="replace")
    )
    negative = re.compile(r"cpa_initially\(neg\((" + CPA_TERM + r")\)\)\.")
    positive = re.compile(r"cpa_initially\((" + CPA_TERM + r")\)\.")
    for match in negative.finditer(compact):
        values[canonical(match.group(1))] = False
    for match in positive.finditer(compact):
        values.setdefault(canonical(match.group(1)), True)
    return values


def atomic_write(path: Path, text: str) -> None:
    fd, temporary = tempfile.mkstemp(
        prefix=path.name + ".", suffix=".tmp", dir=str(path.parent)
    )
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
            stream.write(text)
        os.replace(temporary, path)
    except Exception:
        try:
            os.unlink(temporary)
        except OSError:
            pass
        raise


def repair(theory: Path, pddl2pl: Path) -> Tuple[List[str], List[str]]:
    original = theory.read_text(encoding="utf-8", errors="strict")
    lines = original.splitlines()
    missing = sorted(referenced(lines) - declared(lines))
    if not missing:
        return [], []

    last_declaration = max(
        (index for index, line in enumerate(lines) if DECL_RE.match(line)),
        default=-1,
    )
    lines[last_declaration + 1 : last_declaration + 1] = [
        f"fluent {fluent};" for fluent in missing
    ]

    values = initial_values(pddl2pl)
    restored: List[str] = []
    initial_lines: List[str] = []
    for fluent in missing:
        if fluent not in values:
            continue
        literal = fluent if values[fluent] else "-" + fluent
        restored.append(literal)
        initial_lines.append(f"initially {literal};")
    if initial_lines:
        goal_index = next(
            (i for i, line in enumerate(lines) if line.lstrip().startswith("goal ")),
            len(lines),
        )
        lines[goal_index:goal_index] = initial_lines

    repaired = "\n".join(lines) + ("\n" if original.endswith("\n") else "")
    atomic_write(theory, repaired)
    unresolved = sorted(referenced(repaired.splitlines()) - declared(repaired.splitlines()))
    if unresolved:
        raise RuntimeError("unresolved declarations: " + ", ".join(unresolved))
    return missing, restored


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("theories", nargs="+", type=Path)
    parser.add_argument("--pddl2pl", type=Path, default=Path("pddl2pl.pl"))
    args = parser.parse_args()

    for theory in args.theories:
        missing, restored = repair(theory, args.pddl2pl)
        if missing:
            print(
                "[CPA-THEORY-CLOSURE] repaired file={} missing={} fluents={}".format(
                    theory, len(missing), ",".join(missing)
                ),
                file=sys.stderr,
            )
            if restored:
                print(
                    "[CPA-THEORY-CLOSURE] restored_initial=" + ",".join(restored),
                    file=sys.stderr,
                )
        else:
            print(
                f"[CPA-THEORY-CLOSURE] file={theory} status=OK",
                file=sys.stderr,
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
