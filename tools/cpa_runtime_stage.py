#!/usr/bin/env python3
"""Runtime staging helpers for CE-planner's CPA-family adapters."""

import os
import shutil
from pathlib import Path


def stage_executable(source: Path, destination: Path) -> None:
    shutil.copyfile(source, destination)
    os.chmod(destination, 0o700)
