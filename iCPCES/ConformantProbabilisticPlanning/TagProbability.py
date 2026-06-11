from ConformantProbabilisticPlanning.NNF_constraints_probabilistic import ProbabilisticObjectConstraints
from nnf import And, Or, Var, false, true
import nnf

class TagProbability:
    def __init__(self, problem, candidate_plan, action_map, contexts):
        self.problem = problem
        self.candidate_plan = candidate_plan
        self.action_map = action_map
        self.contexts = contexts
        self.constraint_object = ProbabilisticObjectConstraints(self.problem, self.candidate_plan, self.action_map,
                                                                self.contexts)
        self.probability_labels = dict()

    def get_probability(self, sample_tags):
        self.constraint_object.add_initial_statements()
        self.constraint_object.add_other_statements()
        tag_assert = self.get_tag_assert(sample_tags)
        probability_assert = self.get_probability_assert()
        self.constraint_object.constraints.append(tag_assert)
        self.constraint_object.constraints.append(probability_assert)
        sentence = And(self.constraint_object.constraints)
        sentence = sentence.to_CNF()
        dnnf, var_labels = nnf.dsharp.compile(sentence, './dsharp')
        return self.parse_dnnf(dnnf)



    def get_tag_assert(self, sample_tags):
        items = set()
        for tags in sample_tags:
            if tags is not None:
                for tag in tags:
                    sub_items = set()
                    for predicate in tag:
                        sub_items.add(self.constraint_object.to_smt(predicate, 0))
                    items.add(And(sub_items))
        tag_assert = Or(items)
        return tag_assert

    def get_probability_assert(self):
        '''
        这个地方，概率不是原始概率。比如有x1,x2,x3三个fact，概率分别为a,b,c，那么x1对应a，x2对应(not a) and b, x3对应(not a) and (not b)
        那么概率就要进行修改，因为c没有了。b = x2/(not a), c = x3/(not a * not b)
        :return:
        '''
        # probability_assert = ''
        items = set()
        initial_probability_groups = self.problem.initial_probability_groups
        for probabilities in initial_probability_groups:
            predicates = list(probabilities.keys())
            positive_probability_vars = list()
            negative_probability_vars = list()
            for index in range(len(predicates)):
                if index != len(predicates) - 1:
                    predicate = predicates[index]
                    probability = probabilities[predicate]
                    name = predicate.predicate + ''.join(predicate.args) + '-p'
                    denominator = 1
                    for i in range(index):
                        denominator *= (1 - probabilities[predicates[i]])
                    self.probability_labels[name] = probability / denominator
                    name = Var(name)
                    negative_probability_statement = Or({Or(positive_probability_vars), ~name})
                    positive_probability_statement = And({And(negative_probability_vars), name})
                    items.add(Or({self.constraint_object.to_smt(predicate, 0), negative_probability_statement}))
                    items.add(Or({~self.constraint_object.to_smt(predicate, 0), positive_probability_statement}))
                    positive_probability_vars.append(name)
                    negative_probability_vars.append(~name)
                else:
                    predicate = predicates[index]
                    negative_probability_statement = Or(positive_probability_vars)
                    positive_probability_statement = And(negative_probability_vars)
                    items.add(Or({self.constraint_object.to_smt(predicate, 0), negative_probability_statement}))
                    items.add(Or({~self.constraint_object.to_smt(predicate, 0), positive_probability_statement}))
        probability_assert = And(items)
        return probability_assert

    def parse_dnnf(self, dnnf):
        probability = None
        if isinstance(dnnf, Or):
            probability = 0
            for child_node in dnnf.children:
                child_probability = self.parse_or(child_node)
                if child_probability is not None:
                    probability += child_probability
        elif isinstance(dnnf, And):
            probability = 1
            for child_node in dnnf.children:
                child_probability = self.parse_and(child_node)
                if child_probability is not None:
                    probability *= child_probability
        return round(probability, 4)

    def parse_or(self, branch):
        probability = None
        if isinstance(branch, Or):
            probability = 0
            for child_node in branch.children:
                child_probability = self.parse_or(child_node)
                if child_probability is not None:
                    probability = probability + child_probability
        elif isinstance(branch, And):
            probability = 1
            for child_node in branch.children:
                child_probability = self.parse_and(child_node)
                if child_probability is not None:
                    probability = probability * child_probability
        elif isinstance(branch, Var):
            probability = self.parse_var(branch)
        if probability is not None:
            return probability



    def parse_and(self, branch):
        probability = None
        if isinstance(branch, Or):
            probability = 0
            for child_node in branch.children:
                child_probability = self.parse_or(child_node)
                if child_probability is not None:
                    probability = probability + child_probability
        elif isinstance(branch, And):
            probability = 1
            for child_node in branch.children:
                child_probability = self.parse_and(child_node)
                if child_probability is not None:
                    probability = probability * child_probability
        elif isinstance(branch, Var):
            probability = self.parse_var(branch)
        if probability is not None:
            return probability

    def parse_var(self, var):
        name = var.name
        bool = var.true
        if bool and name in self.probability_labels.keys():
            return round(self.probability_labels[name],4)
        if not bool and name in self.probability_labels.keys():
            return round(1 - self.probability_labels[name],4)
