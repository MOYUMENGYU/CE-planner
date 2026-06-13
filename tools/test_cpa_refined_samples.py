#!/usr/bin/env python3

import unittest

from cpa_pddl_sexpr import (
    collect_dynamic_predicates,
    find_define,
    find_section,
    literal_info,
    parse_all,
    split_init,
)
from cpa_refined_samples import (
    AdaptationError,
    adapt_refined_samples,
    selector_implication,
    selector_oneof,
)

DOMAIN = r"""
(define (domain comm)
  (:requirements :negative-preconditions :typing :equality)
  (:types packet stage)
  (:constants s0 - stage)
  (:predicates
    (next-stage ?s ?t - stage)
    (current-stage ?s - stage)
    (in-channel ?p - packet)
    (seq-number ?p - packet ?s - stage)
    (read ?p - packet)
    (noisy ?p - packet)
    (bad ?p - packet)
    (ok ?p - packet))
  (:action advance
    :parameters (?s ?t - stage)
    :precondition (and (next-stage ?s ?t) (current-stage ?s))
    :effect (and (current-stage ?t) (not (current-stage ?s))))
  (:action obtain
    :parameters (?p - packet ?s - stage)
    :precondition (and (seq-number ?p ?s) (current-stage ?s))
    :effect (when (in-channel ?p) (and (not (in-channel ?p)) (read ?p))))
  (:action certify
    :parameters (?p - packet)
    :precondition (read ?p)
    :effect (and
      (when (noisy ?p) (bad ?p))
      (when (not (noisy ?p)) (ok ?p))))
  (:action request-copy
    :parameters (?p - packet ?s - stage)
    :precondition (current-stage ?s)
    :effect (when (bad ?p)
      (and (in-channel ?p) (not (read ?p))
           (not (noisy ?p)) (not (bad ?p)))))
)
"""

SINGLE = r"""
(define (problem comm-single)
  (:domain comm)
  (:objects s1 - stage p0 - packet)
  (:init (and
    (current-stage s0)
    (in-channel p0)
    (seq-number p0 s0)
    (next-stage s0 s1)
    (not (current-stage s1))
    (not (read p0))
    (not (noisy p0))
    (not (bad p0))
    (not (ok p0))))
  (:goal (ok p0))
)
"""

MULTI = r"""
(define (problem comm-multi)
  (:domain comm)
  (:objects s1 - stage p0 - packet)
  (:init (and
    (current-stage s0)
    (in-channel p0)
    (seq-number p0 s0)
    (next-stage s0 s1)
    (not (current-stage s1))
    (not (read p0))
    (not (bad p0))
    (not (ok p0))
    (oneof (igc-ce-demo-sel-0000) (igc-ce-demo-sel-0001))
    (or (not (igc-ce-demo-sel-0000)) (noisy p0))
    (or (not (igc-ce-demo-sel-0001)) (not (noisy p0)))))
  (:goal (ok p0))
)
"""


def inspect(forms):
    domain = find_define(forms, "domain")
    problem = find_define(forms, "problem")
    dynamic = collect_dynamic_predicates(domain)
    init = split_init(find_section(problem, ":init"))
    selectors = None
    implications = []
    direct_dynamic = []
    for form in init:
        group = selector_oneof(form)
        if group is not None:
            selectors = group
            continue
        implication = selector_implication(form)
        if implication is not None:
            implications.append(implication)
            continue
        literal = literal_info(form)
        if literal is not None and literal[0][0] in dynamic:
            direct_dynamic.append(literal)
    return selectors, implications, direct_dynamic


class RefinedSampleEncodingTest(unittest.TestCase):
    def test_single_world_uses_two_equivalent_selectors(self):
        text = DOMAIN + SINGLE
        forms = parse_all(text)
        metadata = adapt_refined_samples(forms, text)
        selectors, implications, direct_dynamic = inspect(forms)

        self.assertEqual(metadata["projected_worlds"], 1)
        self.assertEqual(metadata["selector_worlds"], 2)
        self.assertEqual(len(selectors), 2)
        self.assertEqual(direct_dynamic, [])
        self.assertEqual(
            len(implications), 2 * metadata["encoded_atoms"]
        )

        worlds = {selector: {} for selector in selectors}
        for selector, key, value in implications:
            worlds[selector][key] = value
        self.assertEqual(worlds[selectors[0]], worlds[selectors[1]])
        self.assertFalse(worlds[selectors[0]][("noisy", "p0")])
        self.assertTrue(worlds[selectors[0]][("current-stage", "s0")])

    def test_multi_world_encodes_common_and_varying_dynamic_atoms(self):
        domain = DOMAIN.replace(
            "(ok ?p - packet))",
            "(ok ?p - packet) (igc-ce-demo-sel-0000) "
            "(igc-ce-demo-sel-0001))",
        )
        text = domain + MULTI
        forms = parse_all(text)
        metadata = adapt_refined_samples(forms, text)
        selectors, implications, direct_dynamic = inspect(forms)

        self.assertEqual(metadata["projected_worlds"], 2)
        self.assertEqual(
            selectors,
            ["igc-ce-demo-sel-0000", "igc-ce-demo-sel-0001"],
        )
        self.assertEqual(direct_dynamic, [])
        self.assertEqual(
            len(implications), 2 * metadata["encoded_atoms"]
        )

        worlds = {selector: {} for selector in selectors}
        for selector, key, value in implications:
            worlds[selector][key] = value
        self.assertTrue(worlds[selectors[0]][("noisy", "p0")])
        self.assertFalse(worlds[selectors[1]][("noisy", "p0")])
        self.assertTrue(worlds[selectors[0]][("in-channel", "p0")])
        self.assertTrue(worlds[selectors[1]][("in-channel", "p0")])

    def test_rejects_non_selector_uncertainty(self):
        text = DOMAIN + SINGLE.replace(
            "(not (noisy p0))",
            "(oneof (noisy p0) (not (noisy p0)))",
        )
        with self.assertRaises(AdaptationError):
            adapt_refined_samples(parse_all(text), text)

    def test_effect_conditions_are_not_dynamic_effects(self):
        forms = parse_all(DOMAIN + SINGLE)
        dynamic = collect_dynamic_predicates(find_define(forms, "domain"))
        self.assertIn("ok", dynamic)
        self.assertIn("bad", dynamic)
        self.assertNotIn("next-stage", dynamic)
        self.assertNotIn("seq-number", dynamic)


if __name__ == "__main__":
    unittest.main()
