import re
from z3 import *
from ConformantProbabilisticPlanning.Z3_string_constraints_probabilistic import ProbabilisticStringConstraints



class ProbabilisticTagGenerator:
    def __init__(self, problem, candidate_plan, action_map, contexts):
        self.problem = problem
        self.candidate_plan = candidate_plan
        self.action_map = action_map
        self.contexts = contexts
        self.all_true_tags = self.initialize_tags() # 只记录fact为True的tag，false的不记录
        self.all_true_and_false_tags = self.initialize_tags() # 记录fact为True和False的tag
        self.constraint_object = ProbabilisticStringConstraints(self.problem, self.candidate_plan, self.action_map, self.contexts)
        self.constraint_list = list()


    def find_all_tags(self):
        all_tags = None
        first_true_tags, first_all_tags = self.get_initial_tags_from_counter_example()
        self.add_to_true_tags(first_true_tags)
        for tag_index in range(len(first_all_tags)):
            if all_tags is None:
                all_tags = first_all_tags
            temp_constraint_list = list()
            temp_constraint_list.extend(self.constraint_list)
            while True:
                tag_assert = self.get_tag_assert(all_tags, tag_index)
                temp_constraint_list.append(tag_assert)
                true_tags, all_tags = self.call_SMT(temp_constraint_list)
                if true_tags is None:
                    break
                self.add_to_true_tags(true_tags)
                self.add_to_true_and_false_tags(all_tags)
        print('all true', self.all_true_tags)
        print('all', self.all_true_and_false_tags)



    def get_tag_assert(self, tag_group, tag_index):
        res = '(assert (and '
        for i in range(len(tag_group)):
            tag = tag_group[i]
            if i == tag_index:
                res += '(not (and '
                for predicate in tag:
                    res += self.constraint_object.to_smt(predicate, 0) + ' '
                res += '))'
            else:
                res += '(and '
                for predicate in tag:
                    res += self.constraint_object.to_smt(predicate, 0) + ' '
                res += ')'
        res += '))\n'
        return res

    def initialize_tags(self):
        res = list()
        for context in self.contexts.contexts:
            res.append([])
        return res

    def add_to_true_tags(self, group_tags):
        for index in range(len(group_tags)):
            if group_tags[index] not in self.all_true_tags[index]:
                self.all_true_tags[index].append(group_tags[index])


    def add_to_true_and_false_tags(self, group_tags):
        for index in range(len(group_tags)):
            if group_tags[index] not in self.all_true_and_false_tags[index]:
                self.all_true_and_false_tags[index].append(group_tags[index])

    def get_initial_tags_from_counter_example(self):
        initial_assert = self.constraint_object.get_initial_assert()
        declare_assert = self.constraint_object.get_other_assert()
        self.constraint_list = [declare_assert, initial_assert]
        true_tags, all_tags = self.call_SMT(self.constraint_list)
        return true_tags, all_tags

    def call_SMT(self, constraint_list):
        solver = Solver()
        solver.from_string(' '.join(constraint_list))
        if solver.check() == sat:
            model = solver.model()
            true_tags, all_tags = self.extract_tags(model, self.constraint_object.predicates_to_atom, self.contexts.contexts)
            return true_tags, all_tags
        else:
            return None, None

    def extract_tags(self, model, predicate_to_atom, contexts):
        true_tags = list() # 仅储存为True的tag
        all_tags = list() # 储存True和False都有的tag
        true_items = set()
        false_items = set()
        model = model.sexpr()
        model = model.strip()
        pattern = '\(define-fun (.*) \(\) Bool\n  (.*)\)'
        results = re.findall(pattern, model)
        for item in results:
            if item[0].endswith('-0') and item[1] == 'true':
                item = item[0]
                item = predicate_to_atom[item]
                true_items.add(item)
            elif item[0].endswith('-0') and item[1] == 'false':
                item = item[0]
                item = predicate_to_atom[item]
                false_items.add(item)
        for context in contexts:
            true_tag = context & true_items
            true_tags.append(true_tag)
            false_tag = context & false_items
            all_tag = set()
            for predicate in false_tag:
                all_tag.add(predicate.negate())
            all_tag = all_tag | true_tag
            all_tags.append(all_tag)
        return true_tags, all_tags

