
:- use_module(library(lists)).
:- dynamic executable/2.
:- dynamic cpa_executable/2.
:- dynamic causes/3.
:- dynamic cpa_causes/3.
:- dynamic cpa_initially/1.

%%%% Objects %%%%
cpa_label(cpa_l1).
cpa_label(cpa_l2).

%%%% Constants %%%%
cpa_node(cpa_n0).
cpa_node(cpa_n1).
cpa_node(cpa_n2).

%%%%  Types rules %%%%

%%%% Predicates %%%%
fluent(cpa_visited(  N)):-
	cpa_node( N).

fluent(cpa_edge_label(  N1,  N2,  L)):-
	cpa_node( N1), cpa_node( N2), cpa_label( L).

fluent(cpa_at_node(  N)):-
	cpa_node( N).


%%%% Actions %%%%
action(cpa_follow_label(  LABEL)):-
	cpa_label( LABEL).


%%%% Preconditions %%%%
executable(cpa_follow_label(  LABEL), [
 ]):-
	cpa_label( LABEL).


%%%% Effects %%%%
causes(cpa_follow_label(  LABEL), [
cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_when( cpa_and( cpa_and( cpa_at_node(cpa_n0)), cpa_edge_label(cpa_n0, cpa_n1,  LABEL)), cpa_and( cpa_at_node(cpa_n1), cpa_and( cpa_and( neg(cpa_at_node(cpa_n0))), cpa_visited(cpa_n1))))), cpa_when( cpa_and( cpa_and( cpa_at_node(cpa_n0)), cpa_edge_label(cpa_n0, cpa_n2,  LABEL)), cpa_and( cpa_at_node(cpa_n2), cpa_and( cpa_and( neg(cpa_at_node(cpa_n0))), cpa_visited(cpa_n2))))), cpa_when( cpa_and( cpa_and( cpa_at_node(cpa_n1)), cpa_edge_label(cpa_n1, cpa_n2,  LABEL)), cpa_and( cpa_at_node(cpa_n2), cpa_and( cpa_and( neg(cpa_at_node(cpa_n1))), cpa_visited(cpa_n2))))), cpa_when( cpa_and( cpa_and( cpa_at_node(cpa_n1)), cpa_edge_label(cpa_n1, cpa_n0,  LABEL)), cpa_and( cpa_at_node(cpa_n0), cpa_and( cpa_and( neg(cpa_at_node(cpa_n1))), cpa_visited(cpa_n0))))), cpa_when( cpa_and( cpa_and( cpa_at_node(cpa_n2)), cpa_edge_label(cpa_n2, cpa_n0,  LABEL)), cpa_and( cpa_at_node(cpa_n0), cpa_and( cpa_and( neg(cpa_at_node(cpa_n2))), cpa_visited(cpa_n0))))), cpa_when( cpa_and( cpa_and( cpa_at_node(cpa_n2)), cpa_edge_label(cpa_n2, cpa_n1,  LABEL)), cpa_and( cpa_at_node(cpa_n1), cpa_and( cpa_and( neg(cpa_at_node(cpa_n2))), cpa_visited(cpa_n1))))) ], 
[]):-
	cpa_label( LABEL).


%%%% Inits %%%%
cpa_initially(cpa_oneof([[cpa_at_node(cpa_n0), cpa_visited(cpa_n0)], [cpa_at_node(cpa_n1), cpa_visited(cpa_n1)], [cpa_at_node(cpa_n2), cpa_visited(cpa_n2)]])).
cpa_initially(cpa_oneof([[cpa_edge_label(cpa_n0, cpa_n1, cpa_l1), cpa_edge_label(cpa_n0, cpa_n2, cpa_l2)], [cpa_edge_label(cpa_n0, cpa_n1, cpa_l2), cpa_edge_label(cpa_n0, cpa_n2, cpa_l1)]])).
cpa_initially(cpa_oneof([[cpa_edge_label(cpa_n1, cpa_n2, cpa_l1), cpa_edge_label(cpa_n1, cpa_n0, cpa_l2)], [cpa_edge_label(cpa_n1, cpa_n2, cpa_l2), cpa_edge_label(cpa_n1, cpa_n0, cpa_l1)]])).
cpa_initially(cpa_oneof([[cpa_edge_label(cpa_n2, cpa_n0, cpa_l1), cpa_edge_label(cpa_n2, cpa_n1, cpa_l2)], [cpa_edge_label(cpa_n2, cpa_n0, cpa_l2), cpa_edge_label(cpa_n2, cpa_n1, cpa_l1)]])).
cpa_initially(neg(X)) :- fluent(X), \+ cpa_initially(X), \+ unknown(X).
unknown(X):- fluent(X),
            findall(L, (cpa_initially(cpa_oneof(Y)), member(L,Y)), LUnk),
            member(X, LUnk).
unknown(X):- fluent(X), cpa_unknown(X).
unknown(X) :- fluent(X), (cpa_initially(cpa_or(Y)),in_or(Y,X);
          cpa_initially(cpa_or(Y,Z)), (in_or(Y,X);in_or(Z,X))), !.
unknown(X) :- fluent(X), cpa_initially(cpa_oneof(ListBig)), member(ListSmall,ListBig),
           member(X,ListSmall).
in_or(X,X) :- !.
in_or(neg(X),X) :- !.
in_or(cpa_or(Y),X) :- in_or(Y,X).
in_or(cpa_or(Y,Z),X) :- (in_or(Y,X);in_or(Z,X)).
cpa_unknown(nop).

%%%% Goals %%%%
plan_goal(cpa_visited(cpa_n0)).
plan_goal(cpa_visited(cpa_n1)).
plan_goal(cpa_visited(cpa_n2)).
