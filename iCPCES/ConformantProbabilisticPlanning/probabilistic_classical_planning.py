from translate.pddl.conditions import Truth
from translate.pddl.conditions import Atom
from translate.pddl.conditions import NegatedAtom
from translate.pddl.conditions import Conjunction


def predicates_can_be_merged(item, contexts):
    if isinstance(item, Atom):
        if item.predicate in contexts.all_predicate_name_in_contexts:
            return False
    elif isinstance(item, NegatedAtom):
        if item.negate().predicate in contexts.all_predicate_name_in_contexts:
            return False
    else:
        if isinstance(item, list):
            for i in item:
                if isinstance(i, Atom):
                    if i.predicate in contexts.all_predicate_name_in_contexts:
                        return False
                elif isinstance(i, NegatedAtom):
                    if i.negate().predicate in contexts.all_predicate_name_in_contexts:
                        return False
        else:
            for i in item.parts:
                if isinstance(i, Atom):
                    if i.predicate in contexts.all_predicate_name_in_contexts:
                        return False
                elif isinstance(i, NegatedAtom):
                    if i.negate().predicate in contexts.all_predicate_name_in_contexts:
                        return False
    return True

def write_classical_domain_file(problem, domain_file, contexts):
    res = '(define (domain ' + problem.domain_name + ')\n'
    res += '(:types  '
    for predicate_type in problem.types:
        res += predicate_type.name + ' - '
        if predicate_type.basetype_name is None:
            res += 'null '
        else:
            res += predicate_type.basetype_name + ' '
    res += 'interpretation - object )\n'
    res += '(:predicates (true) '
    for predicate in problem.predicates:
        if not str(predicate).startswith('='):
            predicate = str(predicate).replace('(', ' ').replace(':', ' -').replace(',', '').replace(')', '')
            if predicate.split(' ')[0] in contexts.all_predicate_name_in_contexts:
                res += '(' + predicate + ' ?x - interpretation)'
            else:
                res += '(' + predicate + ')'
    res += ')\n'
    for action in problem.actions:
        res += '(:action ' + action.name + '\n'
        res += ':parameters ('
        for parameter in action.parameters:
            parameter = str(parameter).replace(':', ' -')
            res += parameter + ' '
        res += ')\n'
        precondition = action.precondition
        precondition_can_be_merged = predicates_can_be_merged(precondition, contexts)
        if len(action.precondition.parts) != 0 or isinstance(action.precondition, Atom) or isinstance(
                action.precondition, NegatedAtom):
            if precondition_can_be_merged:
                res += ':precondition '
                res += action.precondition.get_merged_classical_problem_predicate(contexts)
                res += '\n'
            else:
                res += ':precondition (forall (?interpr - interpretation)'
                res += action.precondition.get_merged_classical_problem_predicate(contexts)
                res += ')\n'
        res += ':effect (and '
        effect_map = dict()
        truth_effect_list = list()
        for effect in action.effects:
            if type(effect.condition) != Truth:
                condition = effect.condition
                if condition in effect_map.keys():
                    effect_map[condition].append(effect.literal)
                else:
                    effect_map[condition] = [effect.literal]
            else:
                truth_effect_list.append(effect.literal)
        for effect in truth_effect_list:
            effect_can_be_merged = predicates_can_be_merged(effect, contexts)
            if effect_can_be_merged:
                res += effect.get_merged_classical_problem_predicate(contexts)
            else:
                res += '(forall (?interpr - interpretation) '
                res += effect.get_merged_classical_problem_predicate(contexts)
                res += ')'
        if len(effect_map) != 0:
            for condition, effects in effect_map.items():
                condition_can_be_merged = predicates_can_be_merged(condition, contexts)
                effect_can_be_merged = predicates_can_be_merged(effects, contexts)
                if condition_can_be_merged and effect_can_be_merged:
                    res += '(when '
                    res += condition.get_merged_classical_problem_predicate(contexts)
                    res += Conjunction(effects).get_merged_classical_problem_predicate(contexts)
                    res += ')'
                else:
                    res += '(forall (?interpr - interpretation) '
                    res += '(when '
                    res += condition.get_merged_classical_problem_predicate(contexts)
                    res += Conjunction(effects).get_merged_classical_problem_predicate(contexts)
                    res += '))'
        res += '))\n'
    res += ')'
    with open(domain_file, 'w') as f:
        f.write(res)

def write_classical_instance_file(counter_examples_records, counter_examples_history, problem, instance_file, contexts):
    res = '(define (problem ' + problem.task_name + ')(:domain ' + problem.domain_name + ')(:objects\n'
    for obj in problem.objects:
        obj = str(obj).split(': ')
        res += '  ' + obj[0] + ' - ' + obj[1] + '\n'
    for i in range(len(counter_examples_records)):
        res += '  int' + str(i) + ' - interpretation\n'
    res += ')\n'
    res += '(:init\n'
    for i in range(len(counter_examples_records)):
        counter_example_set = counter_examples_records[i]
        for counter_example in counter_example_set:
            if isinstance(counter_example, Atom):
                counter_example = counter_example.predicate + ' ' + ' '.join(counter_example.args)
                if counter_example.split(' ')[0] in contexts.all_predicate_name_in_contexts:
                    res += '  (' + counter_example + ' int' + str(i) + ')\n'
    for predicate in problem.initial_true:
        res += '  (' + predicate.predicate + ' ' + ' '.join(predicate.args) + ')\n'
    res += ')\n'
    res += '(:goal (and '
    for counter_examples in counter_examples_history:
        res += '(or '
        for index in counter_examples:
            res += problem.goal.get_classical_problem_predicate_with_timestamp(index)
        res += ')\n'
    res += ')))'
    # print(res)
    with open(instance_file, 'w') as f:
        f.write(res)

def write_domain_file(problem, domain_file, sample_list):
    write_classical_domain_file(problem, domain_file, sample_list)

def write_instance_file(counter_examples_records, counter_examples_history, problem, instance_file, contexts):
    write_classical_instance_file(counter_examples_records, counter_examples_history, problem, instance_file, contexts)