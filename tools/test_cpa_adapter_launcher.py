#!/usr/bin/env python3

import json
import os
import subprocess
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path


PDDL = r"""
(define (domain comm)
  (:requirements :negative-preconditions :typing)
  (:types packet)
  (:predicates (read ?p - packet) (noisy ?p - packet) (ok ?p - packet))
  (:action certify
    :parameters (?p - packet)
    :precondition (read ?p)
    :effect (when (not (noisy ?p)) (ok ?p)))
  (:action reset
    :parameters (?p - packet)
    :effect (and (not (read ?p)) (not (noisy ?p)))))
(define (problem comm-one)
  (:domain comm)
  (:objects p0 - packet)
  (:init (and (read p0) (not (noisy p0)) (not (ok p0))))
  (:goal (ok p0)))
"""


class AdapterLauncherTest(unittest.TestCase):
    def test_stages_executable_wrapper_and_adapts_before_conversion(self):
        tools = Path(__file__).resolve().parent
        runner = tools / "run_cpa_family_cegis.py"

        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            runtime = root / "dnf_planner"
            work = root / "work"
            runtime.mkdir()
            work.mkdir()

            converter = runtime / "cpa.pddl2pl"
            converter.write_text(
                textwrap.dedent(
                    """\
                    #!/bin/sh
                    set -eu
                    grep -q 'igc-ce-cpa-' "$1"
                    grep -q '(oneof' "$1"
                    printf 'converted\\n' > pddl2pl.pl
                    """
                ),
                encoding="utf-8",
            )
            converter.chmod(0o700)

            binary = runtime / "dnf"
            binary.write_text("#!/bin/sh\nexit 0\n", encoding="utf-8")
            binary.chmod(0o700)
            (runtime / "mult5zsic.pl").write_text("% fake\n", encoding="utf-8")

            combined = work / "dp.pddl"
            combined.write_text(PDDL, encoding="utf-8")

            fake_plan = root / "fake-plan"
            fake_plan.write_text(
                textwrap.dedent(
                    """\
                    #!/bin/sh
                    set -eu
                    test "${IGC_CPA_ADAPTER_ACTIVE:-}" = 1
                    test -x "$IGC_DNF_DIR/cpa.pddl2pl"
                    cd "$(dirname "$1")"
                    "$IGC_DNF_DIR/cpa.pddl2pl" "$(basename "$1")"
                    test -s pddl2pl.pl
                    test -s cpa-pddl-adapter.json
                    """
                ),
                encoding="utf-8",
            )
            fake_plan.chmod(0o700)

            env = os.environ.copy()
            env["IGC_DNF_DIR"] = str(runtime)
            env["IGC_CPA_ADAPTER_PLAN_EXEC"] = str(fake_plan)
            completed = subprocess.run(
                [sys.executable, str(runner), "2", str(combined)],
                env=env,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False,
            )
            self.assertEqual(
                completed.returncode,
                0,
                msg=completed.stdout + "\n" + completed.stderr,
            )

            metadata = json.loads(
                (work / "cpa-pddl-adapter.json").read_text(encoding="utf-8")
            )
            self.assertEqual(metadata["projected_worlds"], 1)
            self.assertEqual(metadata["selector_worlds"], 2)
            self.assertEqual(metadata["encoded_atoms"], 3)


if __name__ == "__main__":
    unittest.main()
