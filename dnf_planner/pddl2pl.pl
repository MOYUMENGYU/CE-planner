
:- use_module(library(lists)).
:- dynamic executable/2.
:- dynamic cpa_executable/2.
:- dynamic causes/3.
:- dynamic cpa_causes/3.
:- dynamic cpa_initially/1.

%%%% Objects %%%%
cpa_bit(cpa_t).
cpa_bit(cpa_f).
cpa_bit(cpa_tmp1).
cpa_bit(cpa_tmp2).
cpa_bit(cpa_x1).
cpa_bit(cpa_y1).
cpa_bit(cpa_r1).
cpa_bit(cpa_z1).
cpa_bit(cpa_r2).
cpa_bit(cpa_z2).

%%%% Constants %%%%

%%%%  Types rules %%%%

%%%% Predicates %%%%
fluent(cpa_high(  B)):-
	cpa_bit( B).

fluent(cpa_low(  B)):-
	cpa_bit( B).

fluent(cpa_constant(  B)):-
	cpa_bit( B).

fluent(cpa_igc_ce_9e0cda3083_sel_0000).

fluent(cpa_igc_ce_9e0cda3083_sel_0001).

fluent(cpa_igc_ce_9e0cda3083_sel_0002).

fluent(cpa_igc_ce_9e0cda3083_sel_0003).


%%%% Actions %%%%
action(cpa_and_gate(  X,  Y,  Z)):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

action(cpa_or_gate(  X,  Y,  Z)):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

action(cpa_xor_gate(  X,  Y,  Z)):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

action(cpa_not_gate(  X,  Z)):-
	cpa_bit( X), cpa_bit( Z).


%%%% Preconditions %%%%
executable(cpa_and_gate(  X,  Y,  Z), [
cpa_and( cpa_and( cpa_and( cpa_and( neg(cpa_constant( Z))), neg(cpa_equal( X,  Y))), neg(cpa_equal( X,  Z))), neg(cpa_equal( Y,  Z))) ]):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

executable(cpa_or_gate(  X,  Y,  Z), [
cpa_and( cpa_and( cpa_and( cpa_and( neg(cpa_constant( Z))), neg(cpa_equal( X,  Y))), neg(cpa_equal( X,  Z))), neg(cpa_equal( Y,  Z))) ]):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

executable(cpa_xor_gate(  X,  Y,  Z), [
cpa_and( cpa_and( cpa_and( cpa_and( neg(cpa_constant( Z))), neg(cpa_equal( X,  Y))), neg(cpa_equal( X,  Z))), neg(cpa_equal( Y,  Z))) ]):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

executable(cpa_not_gate(  X,  Z), [
cpa_and( cpa_and( neg(cpa_constant( Z))), neg(cpa_equal( X,  Z))) ]):-
	cpa_bit( X), cpa_bit( Z).


%%%% Effects %%%%
causes(cpa_and_gate(  X,  Y,  Z), [
cpa_and( cpa_and( cpa_and( cpa_when( cpa_and( cpa_and( cpa_high( X)), cpa_high( Y)), cpa_and( neg(cpa_low( Z)), cpa_and( cpa_high( Z))))), cpa_when( cpa_low( X), cpa_and( neg(cpa_high( Z)), cpa_and( cpa_low( Z))))), cpa_when( cpa_low( Y), cpa_and( neg(cpa_high( Z)), cpa_and( cpa_low( Z))))) ], 
[]):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

causes(cpa_or_gate(  X,  Y,  Z), [
cpa_and( cpa_and( cpa_and( cpa_when( cpa_high( X), cpa_and( neg(cpa_low( Z)), cpa_and( cpa_high( Z))))), cpa_when( cpa_high( Y), cpa_and( neg(cpa_low( Z)), cpa_and( cpa_high( Z))))), cpa_when( cpa_and( cpa_and( cpa_low( X)), cpa_low( Y)), cpa_and( neg(cpa_high( Z)), cpa_and( cpa_low( Z))))) ], 
[]):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

causes(cpa_xor_gate(  X,  Y,  Z), [
cpa_and( cpa_and( cpa_and( cpa_and( cpa_when( cpa_and( cpa_and( cpa_high( X)), cpa_low( Y)), cpa_and( neg(cpa_low( Z)), cpa_and( cpa_high( Z))))), cpa_when( cpa_and( cpa_and( cpa_low( X)), cpa_high( Y)), cpa_and( neg(cpa_low( Z)), cpa_and( cpa_high( Z))))), cpa_when( cpa_and( cpa_and( cpa_low( X)), cpa_low( Y)), cpa_and( neg(cpa_high( Z)), cpa_and( cpa_low( Z))))), cpa_when( cpa_and( cpa_and( cpa_high( X)), cpa_high( Y)), cpa_and( neg(cpa_high( Z)), cpa_and( cpa_low( Z))))) ], 
[]):-
	cpa_bit( X), cpa_bit( Y), cpa_bit( Z).

causes(cpa_not_gate(  X,  Z), [
cpa_and( cpa_and( cpa_when( cpa_low( X), cpa_and( neg(cpa_low( Z)), cpa_and( cpa_high( Z))))), cpa_when( cpa_high( X), cpa_and( neg(cpa_high( Z)), cpa_and( cpa_low( Z))))) ], 
[]):-
	cpa_bit( X), cpa_bit( Z).


%%%% Inits %%%%
cpa_initially(cpa_high(cpa_t)).
cpa_initially(cpa_low(cpa_f)).
cpa_initially(cpa_low(cpa_r1)).
cpa_initially(cpa_low(cpa_r2)).
cpa_initially(cpa_low(cpa_z1)).
cpa_initially(cpa_low(cpa_z2)).
cpa_initially(cpa_constant(cpa_x1)).
cpa_initially(cpa_constant(cpa_y1)).
cpa_initially(neg(cpa_high(cpa_f))).
cpa_initially(neg(cpa_high(cpa_r1))).
cpa_initially(neg(cpa_high(cpa_r2))).
cpa_initially(neg(cpa_high(cpa_tmp1))).
cpa_initially(neg(cpa_high(cpa_tmp2))).
cpa_initially(neg(cpa_high(cpa_z1))).
cpa_initially(neg(cpa_high(cpa_z2))).
cpa_initially(neg(cpa_low(cpa_t))).
cpa_initially(neg(cpa_low(cpa_tmp1))).
cpa_initially(neg(cpa_low(cpa_tmp2))).
cpa_initially(cpa_oneof([cpa_igc_ce_9e0cda3083_sel_0000, cpa_igc_ce_9e0cda3083_sel_0001, cpa_igc_ce_9e0cda3083_sel_0002, cpa_igc_ce_9e0cda3083_sel_0003])).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0000)), cpa_high(cpa_x1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0000)), cpa_high(cpa_y1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0000)), neg(cpa_low(cpa_x1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0000)), neg(cpa_low(cpa_y1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0001)), cpa_high(cpa_x1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0001)), neg(cpa_high(cpa_y1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0001)), neg(cpa_low(cpa_x1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0001)), cpa_low(cpa_y1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0002)), neg(cpa_high(cpa_x1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0002)), neg(cpa_high(cpa_y1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0002)), cpa_low(cpa_x1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0002)), cpa_low(cpa_y1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0003)), neg(cpa_high(cpa_x1)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0003)), cpa_high(cpa_y1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0003)), cpa_low(cpa_x1))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_9e0cda3083_sel_0003)), neg(cpa_low(cpa_y1)))).
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
plan_goal(cpa_low(cpa_r1)).
plan_goal(cpa_or( cpa_or( cpa_low(cpa_z2)), cpa_high(cpa_r2))).
plan_goal(cpa_or( cpa_or( cpa_low(cpa_r2)), cpa_high(cpa_z2))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_low(cpa_r2)), cpa_high(cpa_x1)), cpa_high(cpa_y1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_low(cpa_r2)), cpa_high(cpa_x1)), cpa_high(cpa_r1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_low(cpa_r2)), cpa_high(cpa_y1)), cpa_high(cpa_r1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_low(cpa_x1)), cpa_low(cpa_y1)), cpa_high(cpa_r2))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_low(cpa_x1)), cpa_low(cpa_r1)), cpa_high(cpa_r2))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_low(cpa_y1)), cpa_low(cpa_r1)), cpa_high(cpa_r2))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_low(cpa_z1)), cpa_low(cpa_x1)), cpa_high(cpa_y1)), cpa_low(cpa_r1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_low(cpa_z1)), cpa_low(cpa_x1)), cpa_low(cpa_y1)), cpa_high(cpa_r1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_low(cpa_z1)), cpa_high(cpa_x1)), cpa_low(cpa_y1)), cpa_low(cpa_r1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_low(cpa_z1)), cpa_high(cpa_x1)), cpa_high(cpa_y1)), cpa_high(cpa_r1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_low(cpa_x1)), cpa_low(cpa_y1)), cpa_low(cpa_r1)), cpa_high(cpa_z1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_low(cpa_x1)), cpa_high(cpa_y1)), cpa_high(cpa_r1)), cpa_high(cpa_z1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_high(cpa_x1)), cpa_low(cpa_y1)), cpa_high(cpa_r1)), cpa_high(cpa_z1))).
plan_goal(cpa_or( cpa_or( cpa_or( cpa_or( cpa_high(cpa_x1)), cpa_high(cpa_y1)), cpa_low(cpa_r1)), cpa_high(cpa_z1))).
