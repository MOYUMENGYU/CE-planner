#!/usr/bin/env python3
"""Small PDDL S-expression utilities used by CE-planner integration code."""

from __future__ import annotations

from typing import List, Optional, Sequence, Set, Tuple, Union

SExpr = Union[str, List["SExpr"]]
LOGICAL_HEADS = {
    "and", "or", "oneof", "not", "when", "forall", "exists", "imply",
    "=", "increase", "decrease", "assign", "scale-up", "scale-down",
}


class PddlError(RuntimeError):
    pass


def tokenize(text: str) -> List[str]:
    tokens: List[str] = []
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == ";":
            newline = text.find("\n", i)
            i = len(text) if newline < 0 else newline + 1
            continue
        if ch.isspace():
            i += 1
            continue
        if ch in "()":
            tokens.append(ch)
            i += 1
            continue
        j = i
        while j < len(text) and not text[j].isspace() and text[j] not in "();":
            j += 1
        tokens.append(text[i:j])
        i = j
    return tokens


def parse_all(text: str) -> List[SExpr]:
    tokens = tokenize(text)
    position = 0

    def parse_one() -> SExpr:
        nonlocal position
        if position >= len(tokens):
            raise PddlError("unexpected end of PDDL")
        token = tokens[position]
        position += 1
        if token != "(":
            if token == ")":
                raise PddlError("unexpected closing parenthesis")
            return token
        result: List[SExpr] = []
        while True:
            if position >= len(tokens):
                raise PddlError("unterminated PDDL form")
            if tokens[position] == ")":
                position += 1
                return result
            result.append(parse_one())

    forms: List[SExpr] = []
    while position < len(tokens):
        forms.append(parse_one())
    return forms


def head(node: SExpr) -> str:
    if not isinstance(node, list) or not node or not isinstance(node[0], str):
        return ""
    return node[0].lower()


def atom_key(node: SExpr) -> Optional[Tuple[str, ...]]:
    if not isinstance(node, list) or not node or not isinstance(node[0], str):
        return None
    if head(node) in LOGICAL_HEADS or node[0].startswith(":"):
        return None
    if not all(isinstance(item, str) for item in node):
        return None
    return tuple(str(item).lower() for item in node)


def literal_info(node: SExpr) -> Optional[Tuple[Tuple[str, ...], bool]]:
    key = atom_key(node)
    if key is not None:
        return key, True
    if head(node) == "not" and isinstance(node, list) and len(node) == 2:
        key = atom_key(node[1])
        if key is not None:
            return key, False
    return None


def find_define(forms: Sequence[SExpr], kind: str) -> List[SExpr]:
    for form in forms:
        if not isinstance(form, list) or head(form) != "define":
            continue
        if len(form) < 2 or not isinstance(form[1], list):
            continue
        if head(form[1]) == kind:
            return form
    raise PddlError(f"missing {kind} definition")


def find_section(container: List[SExpr], section_head: str) -> List[SExpr]:
    wanted = section_head.lower()
    for item in container:
        if isinstance(item, list) and head(item) == wanted:
            return item
    raise PddlError(f"missing {section_head} section")


def split_init(init_section: List[SExpr]) -> List[SExpr]:
    if len(init_section) == 2 and head(init_section[1]) == "and":
        assert isinstance(init_section[1], list)
        return list(init_section[1][1:])
    return list(init_section[1:])


def collect_effect_predicates(expr: SExpr, output: Set[str]) -> None:
    if not isinstance(expr, list) or not expr:
        return
    h = head(expr)
    if h == "and":
        for child in expr[1:]:
            collect_effect_predicates(child, output)
        return
    if h == "when":
        if len(expr) >= 3:
            collect_effect_predicates(expr[2], output)
        return
    if h in {"forall", "exists"}:
        if len(expr) >= 2:
            collect_effect_predicates(expr[-1], output)
        return
    if h == "not":
        if len(expr) == 2:
            key = atom_key(expr[1])
            if key is not None:
                output.add(key[0])
        return
    key = atom_key(expr)
    if key is not None:
        output.add(key[0])


def collect_dynamic_predicates(domain: List[SExpr]) -> Set[str]:
    dynamic: Set[str] = set()
    for item in domain:
        if not isinstance(item, list) or head(item) != ":action":
            continue
        for index, token in enumerate(item[:-1]):
            if isinstance(token, str) and token.lower() == ":effect":
                collect_effect_predicates(item[index + 1], dynamic)
                break
    if not dynamic:
        raise PddlError("domain contains no dynamic predicates")
    return dynamic


def flat_render(node: SExpr) -> str:
    if isinstance(node, str):
        return node
    return "(" + " ".join(flat_render(item) for item in node) + ")"


def render(node: SExpr, indent: int = 0) -> str:
    if isinstance(node, str):
        return node
    compact = flat_render(node)
    if len(compact) + indent <= 100 and all(
        not isinstance(item, list) for item in node[1:]
    ):
        return compact
    if not node:
        return "()"
    lines = ["(" + render(node[0], indent + 1)]
    for child in node[1:]:
        child_lines = render(child, indent + 2).splitlines()
        lines.append(" " * (indent + 2) + child_lines[0])
        for continuation in child_lines[1:]:
            lines.append(" " * (indent + 2) + continuation)
    lines[-1] += ")"
    return "\n".join(lines)
