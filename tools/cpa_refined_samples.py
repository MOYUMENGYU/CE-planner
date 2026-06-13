#!/usr/bin/env python3
"""Exact sample-set encoding for the native CNF/DNF/PIP PDDL front-end."""

from __future__ import annotations

import hashlib
import re
from typing import Dict, List, Optional, Set, Tuple

from cpa_pddl_sexpr import (
    PddlError,
    SExpr,
    atom_key,
    collect_dynamic_predicates,
    find_define,
    find_section,
    flat_render,
    head,
    literal_info,
    split_init,
)

SELECTOR_RE = re.compile(r"^igc-ce-[a-z0-9-]+-sel-[0-9]{4}$", re.I)
Assignment = Dict[Tuple[str, ...], bool]


class AdaptationError(PddlError):
    pass


def selector_atom(node: SExpr) -> Optional[str]:
    key = atom_key(node)
    if key is None or len(key) != 1:
        return None
    return key[0] if SELECTOR_RE.match(key[0]) else None


def selector_oneof(form: SExpr) -> Optional[List[str]]:
    if head(form) != "oneof" or not isinstance(form, list) or len(form) < 2:
        return None
    selectors: List[str] = []
    for child in form[1:]:
        selector = selector_atom(child)
        if selector is None:
            return None
        selectors.append(selector)
    return selectors


def selector_implication(
    form: SExpr,
) -> Optional[Tuple[str, Tuple[str, ...], bool]]:
    if head(form) != "or" or not isinstance(form, list) or len(form) != 3:
        return None
    for selector_index, literal_index in ((1, 2), (2, 1)):
        negated = form[selector_index]
        if (
            head(negated) != "not"
            or not isinstance(negated, list)
            or len(negated) != 2
        ):
            continue
        selector = selector_atom(negated[1])
        literal = literal_info(form[literal_index])
        if selector is not None and literal is not None:
            return selector, literal[0], literal[1]
    return None


def set_assignment(
    target: Assignment,
    key: Tuple[str, ...],
    value: bool,
    source: str,
) -> None:
    previous = target.get(key)
    if previous is not None and previous != value:
        raise AdaptationError(
            f"contradictory assignment for {' '.join(key)} from {source}"
        )
    target[key] = value


def signature(world: Assignment) -> Tuple[Tuple[Tuple[str, ...], bool], ...]:
    return tuple(sorted(world.items()))


def declared_predicates(predicates: List[SExpr]) -> Set[str]:
    result: Set[str] = set()
    for item in predicates[1:]:
        if isinstance(item, list) and item and isinstance(item[0], str):
            result.add(item[0].lower())
    return result


def new_selector_names(original: str, occupied: Set[str]) -> List[str]:
    digest = hashlib.sha1(original.encode("utf-8")).hexdigest()[:10]
    prefix = f"igc-ce-cpa-{digest}-sel-"
    result: List[str] = []
    candidate_index = 0
    while len(result) < 2:
        candidate = f"{prefix}{candidate_index:04d}"
        candidate_index += 1
        if candidate in occupied:
            continue
        occupied.add(candidate)
        result.append(candidate)
    return result


def parse_current_encoding(
    init_forms: List[SExpr], dynamic: Set[str]
) -> Tuple[List[SExpr], List[str], Assignment, Dict[str, Assignment], Dict[str, int]]:
    selectors: List[str] = []
    common: Assignment = {}
    per_selector: Dict[str, Assignment] = {}
    retained: List[SExpr] = []
    stats = {
        "removed_direct_dynamic_literals": 0,
        "removed_static_negative_literals": 0,
        "replaced_selector_constraints": 0,
    }

    for form in init_forms:
        group = selector_oneof(form)
        if group is not None:
            if selectors and selectors != group:
                raise AdaptationError("multiple incompatible selector ONEOF groups")
            selectors = group
            for selector in group:
                per_selector.setdefault(selector, {})
            stats["replaced_selector_constraints"] += 1
            continue

        implication = selector_implication(form)
        if implication is not None:
            selector, key, value = implication
            per_selector.setdefault(selector, {})
            set_assignment(
                per_selector[selector], key, value, "selector implication"
            )
            if selector not in selectors:
                selectors.append(selector)
            stats["replaced_selector_constraints"] += 1
            continue

        if head(form) in {"oneof", "or", "unknown"}:
            raise AdaptationError(
                "unexpected non-selector uncertainty form in refined CPA PDDL: "
                + flat_render(form)
            )

        literal = literal_info(form)
        if literal is not None:
            key, value = literal
            if key[0] in dynamic:
                set_assignment(common, key, value, "direct dynamic literal")
                stats["removed_direct_dynamic_literals"] += 1
                continue
            if not value:
                # The external front-end applies closed world to static atoms.
                stats["removed_static_negative_literals"] += 1
                continue

        retained.append(form)

    return retained, selectors, common, per_selector, stats


def build_worlds(
    selectors: List[str],
    common: Assignment,
    per_selector: Dict[str, Assignment],
) -> List[Assignment]:
    if not selectors:
        return [dict(common)]
    worlds: List[Assignment] = []
    for selector in selectors:
        world = dict(common)
        for key, value in per_selector.get(selector, {}).items():
            set_assignment(world, key, value, f"selector {selector}")
        worlds.append(world)
    return worlds


def verify_complete_worlds(worlds: List[Assignment]) -> Set[Tuple[str, ...]]:
    keys: Set[Tuple[str, ...]] = set()
    for world in worlds:
        keys.update(world)
    if not keys:
        raise AdaptationError("sample projection is empty")
    for index, world in enumerate(worlds):
        missing = sorted(keys - set(world))
        if missing:
            preview = ", ".join(" ".join(key) for key in missing[:5])
            raise AdaptationError(f"world {index} lacks assignments for: {preview}")
    return keys


def adapt_refined_samples(forms: List[SExpr], original: str) -> Dict[str, object]:
    domain = find_define(forms, "domain")
    problem = find_define(forms, "problem")
    predicates = find_section(domain, ":predicates")
    init = find_section(problem, ":init")
    dynamic = collect_dynamic_predicates(domain)

    retained, selectors, common, per_selector, stats = parse_current_encoding(
        split_init(init), dynamic
    )
    if not common and not per_selector:
        raise AdaptationError("refined problem contains no dynamic sample assignments")

    worlds = build_worlds(selectors, common, per_selector)
    keys = verify_complete_worlds(worlds)
    projected_world_count = len({signature(world) for world in worlds})

    declared = declared_predicates(predicates)
    occupied = set(declared)
    if not selectors:
        selectors = new_selector_names(original, occupied)
        # Two auxiliary selector states encode one projected original world.
        worlds = [dict(worlds[0]), dict(worlds[0])]
    elif len(selectors) == 1:
        extra = new_selector_names(original, occupied)
        selector = next(name for name in extra if name not in selectors)
        selectors.append(selector)
        worlds.append(dict(worlds[0]))

    if len(selectors) != len(worlds):
        raise AdaptationError("selector/world cardinality mismatch")

    for selector in selectors:
        if selector not in declared:
            predicates.append([selector])
            declared.add(selector)

    rebuilt: List[SExpr] = list(retained)
    rebuilt.append(["oneof", *[[selector] for selector in selectors]])
    for selector, world in zip(selectors, worlds):
        for key in sorted(keys):
            atom: List[SExpr] = list(key)
            literal: SExpr = atom if world[key] else ["not", atom]
            rebuilt.append(["or", ["not", [selector]], literal])
    init[:] = [":init", ["and", *rebuilt]]

    if len({signature(world) for world in worlds}) != projected_world_count:
        raise AdaptationError("projected sample set changed during adaptation")

    return {
        "schema_version": "ce-planner-cpa-pddl-adapter-v1",
        "dynamic_predicates": sorted(dynamic),
        "projected_worlds": projected_world_count,
        "selector_worlds": len(selectors),
        "selectors": selectors,
        "encoded_atoms": len(keys),
        "selector_implications": len(selectors) * len(keys),
        **stats,
    }
