#!/usr/bin/env python3
"""Runtime staging helpers for CE-planner's CPA-family adapters."""

import os
import shutil
from pathlib import Path


def stage_executable(source: Path, destination: Path) -> None:
    # The adapter runtime is temporary. Run CE-planner in its per-run isolated
    # workspace so generated PDDL, Prolog and AL artifacts remain inspectable
    # after the temporary executable staging directory is removed.
    os.environ["IGC_CANDIDATE_RUNTIME_MODE"] = "isolated"
    shutil.copyfile(source, destination)
    os.chmod(destination, 0o700)
