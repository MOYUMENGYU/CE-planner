from z3 import *
import copy
from ConformantProbabilisticPlanning.Z3_string_constraints_probabilistic import ProbabilisticStringConstraints
from ConformantProbabilisticPlanning.TagProbability import TagProbability
import re


class SampleTagsGenerator:
    def __init__(self, problem, candidate_plan, action_map, contexts, tag_generator):
        self.problem = problem
        self.candidate_plan = candidate_plan
        self.action_map = action_map
        self.contexts = contexts
        self.tag_generator = tag_generator
        self.sample_tags = None


    def find_all_sample_tags(self, threshold=None):
        sample_tags = list()
        final_probability = 0
        constraint_object = ProbabilisticStringConstraints(self.problem, self.candidate_plan, self.action_map,
                                                           self.contexts)
        regression_assert = ''
        if self.candidate_plan is not None:
            constraint_object.regression(self.problem, self.candidate_plan, self.action_map)
            regression_assert = constraint_object.get_regression_assert()
        precondition_assert = constraint_object.get_true_precondition_assert()
        initial_assert = constraint_object.get_initial_assert()
        declare_assert = constraint_object.get_other_assert()
        constraint_string = [declare_assert, regression_assert, precondition_assert, initial_assert]
        all_true_and_false_tags = self.tag_generator.all_true_and_false_tags
        for tag_group in all_true_and_false_tags:
            group_sample_tags = list()
            for tag in tag_group:
                tag_assert = '(assert (and '
                for predicate in tag:
                    tag_assert += constraint_object.to_smt(predicate, 0) + ' '
                tag_assert += '))\n'
                constraint_string.append(tag_assert)
                solver = Solver()
                solver.from_string(' '.join(constraint_string))
                if solver.check() != sat:
                    group_sample_tags.append(tag)
                    if threshold is not None:
                        tp = TagProbability(self.problem, self.candidate_plan, self.action_map, self.contexts)
                        probability = self.compute_probability(sample_tags, group_sample_tags, tp)
                        final_probability = probability
                        if probability >= 1 - threshold:
                            sample_tags.append(group_sample_tags)
                            self.sample_tags = sample_tags
                            return sample_tags, probability
                constraint_string.pop()
            if len(group_sample_tags) == 0:
                sample_tags.append(None)
            else:
                sample_tags.append(group_sample_tags)
        print('没有足够多的tag')
        print(final_probability)
        return None, final_probability


    def is_empty_sample_tags(self, sample_tags):
        for group in sample_tags:
            if group is not None:
                return False
        return True

    def compute_probability(self, sample_tags, group_sample_tags, tp):
        temp_sample_tags = copy.deepcopy(sample_tags)
        temp_sample_tags.append(group_sample_tags)
        probability = tp.get_probability(temp_sample_tags)
        return probability

    def get_all_samples(self):
        samples = list()
        constraint_object = ProbabilisticStringConstraints(self.problem, self.candidate_plan, self.action_map,
                                             self.contexts)
        regression_assert = ''
        if self.candidate_plan is not None:
            constraint_object.regression(self.problem, self.candidate_plan, self.action_map)
            regression_assert = constraint_object.get_regression_assert()
        precondition_assert = constraint_object.get_precondition_assert()
        initial_assert = constraint_object.get_initial_assert()
        declare_assert = constraint_object.get_other_assert()
        tags_assert = constraint_object.get_sample_tags_assert(self.sample_tags)
        constraint_string = [declare_assert, regression_assert, precondition_assert, initial_assert, tags_assert]
        while True:
            solver = Solver()
            solver.from_string(' '.join(constraint_string))
            if solver.check() == sat:
                model = solver.model()
                sample = self.extract_counter_example_from_string(model, constraint_object)
                samples.append(sample)
                exception_sample_tag_assert = constraint_object.get_exception_sample_tag_assert(sample)
                constraint_string.append(exception_sample_tag_assert)
            else:
                break
        return samples


    def extract_counter_example_from_string(self, model, constraint_object):
        counter_example = set()
        model = model.sexpr()
        model = model.strip()
        pattern = '\(define-fun (.*) \(\) Bool\n  (.*)\)'
        results = re.findall(pattern, model)
        for item in results:
            if item[0].endswith('-0') and item[1] == 'true':
                counter_example.add(constraint_object.predicates_to_atom[item[0]])
            elif item[0].endswith('-0') and item[1] == 'false':
                counter_example.add(constraint_object.predicates_to_atom[item[0]].negate())
        return counter_example


