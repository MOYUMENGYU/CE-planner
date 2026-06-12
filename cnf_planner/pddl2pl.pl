
:- use_module(library(lists)).
:- dynamic executable/2.
:- dynamic cpa_executable/2.
:- dynamic causes/3.
:- dynamic cpa_causes/3.
:- dynamic cpa_initially/1.

%%%% Objects %%%%
cpa_block(cpa_a).
cpa_block(cpa_b).
cpa_block(cpa_c).

%%%% Constants %%%%

%%%%  Types rules %%%%

%%%% Predicates %%%%
fluent(cpa_on(  X,  Y)):-
	cpa_block( X), cpa_block( Y).

fluent(cpa_ontable(  X)):-
	cpa_block( X).

fluent(cpa_clear(  X)):-
	cpa_block( X).

fluent(cpa_handempty).

fluent(cpa_holding(  X)):-
	cpa_block( X).

fluent(cpa_igc_ce_69249b1276_sel_0000).

fluent(cpa_igc_ce_69249b1276_sel_0001).

fluent(cpa_igc_ce_69249b1276_sel_0002).

fluent(cpa_igc_ce_69249b1276_sel_0003).

fluent(cpa_igc_ce_69249b1276_sel_0004).

fluent(cpa_igc_ce_69249b1276_sel_0005).

fluent(cpa_igc_ce_69249b1276_sel_0006).


%%%% Actions %%%%
action(cpa_pick_up(  X)):-
	cpa_block( X).

action(cpa_put_down(  X)):-
	cpa_block( X).

action(cpa_stack(  X,  Y)):-
	cpa_block( X), cpa_block( Y).

action(cpa_unstack(  X,  Y)):-
	cpa_block( X), cpa_block( Y).


%%%% Preconditions %%%%
executable(cpa_pick_up(  X), [
 ]):-
	cpa_block( X).

executable(cpa_put_down(  X), [
 ]):-
	cpa_block( X).

executable(cpa_stack(  X,  Y), [
 ]):-
	cpa_block( X), cpa_block( Y).

executable(cpa_unstack(  X,  Y), [
 ]):-
	cpa_block( X), cpa_block( Y).


%%%% Effects %%%%
causes(cpa_pick_up(  X), [
cpa_when( cpa_and( cpa_and( cpa_and( cpa_handempty), cpa_clear( X)), cpa_ontable( X)), cpa_and( neg(cpa_ontable( X)), cpa_and( cpa_and( cpa_and( neg(cpa_clear( X))), neg(cpa_handempty)), cpa_holding( X)))) ], 
[]):-
	cpa_block( X).

causes(cpa_put_down(  X), [
cpa_when( cpa_holding( X), cpa_and( neg(cpa_holding( X)), cpa_and( cpa_and( cpa_and( cpa_clear( X)), cpa_handempty), cpa_ontable( X)))) ], 
[]):-
	cpa_block( X).

causes(cpa_stack(  X,  Y), [
cpa_when( cpa_and( cpa_and( cpa_holding( X)), cpa_clear( Y)), cpa_and( neg(cpa_holding( X)), cpa_and( cpa_and( cpa_and( cpa_and( neg(cpa_clear( Y))), cpa_clear( X)), cpa_handempty), cpa_on( X,  Y)))) ], 
[]):-
	cpa_block( X), cpa_block( Y).

causes(cpa_unstack(  X,  Y), [
cpa_when( cpa_and( cpa_and( cpa_and( cpa_handempty), cpa_on( X,  Y)), cpa_clear( X)), cpa_and( cpa_holding( X), cpa_and( cpa_and( cpa_and( cpa_and( cpa_clear( Y)), neg(cpa_clear( X))), neg(cpa_handempty)), neg(cpa_on( X,  Y))))) ], 
[]):-
	cpa_block( X), cpa_block( Y).


%%%% Inits %%%%
cpa_initially(neg(cpa_holding(cpa_a))).
cpa_initially(neg(cpa_on(cpa_a, cpa_a))).
cpa_initially(neg(cpa_on(cpa_b, cpa_b))).
cpa_initially(neg(cpa_on(cpa_c, cpa_c))).
cpa_initially(cpa_oneof([cpa_igc_ce_69249b1276_sel_0000, cpa_igc_ce_69249b1276_sel_0001, cpa_igc_ce_69249b1276_sel_0002, cpa_igc_ce_69249b1276_sel_0003, cpa_igc_ce_69249b1276_sel_0004, cpa_igc_ce_69249b1276_sel_0005, cpa_igc_ce_69249b1276_sel_0006])).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), cpa_clear(cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), cpa_clear(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_clear(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_handempty))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_holding(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), cpa_holding(cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_on(cpa_a, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_on(cpa_a, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_on(cpa_b, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_on(cpa_b, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_on(cpa_c, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_on(cpa_c, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), cpa_ontable(cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), cpa_ontable(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0000)), neg(cpa_ontable(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_clear(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_clear(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), cpa_clear(cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), cpa_handempty)).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_holding(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_holding(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), cpa_on(cpa_a, cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_on(cpa_a, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_on(cpa_b, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_on(cpa_b, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), cpa_on(cpa_c, cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_on(cpa_c, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_ontable(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), cpa_ontable(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0001)), neg(cpa_ontable(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), cpa_clear(cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_clear(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_clear(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), cpa_handempty)).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_holding(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_holding(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), cpa_on(cpa_a, cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_on(cpa_a, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_on(cpa_b, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), cpa_on(cpa_b, cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_on(cpa_c, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_on(cpa_c, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_ontable(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), neg(cpa_ontable(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0002)), cpa_ontable(cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_clear(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), cpa_clear(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_clear(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), cpa_handempty)).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_holding(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_holding(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_on(cpa_a, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_on(cpa_a, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_on(cpa_b, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), cpa_on(cpa_b, cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), cpa_on(cpa_c, cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_on(cpa_c, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), cpa_ontable(cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_ontable(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0003)), neg(cpa_ontable(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), cpa_clear(cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_clear(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_clear(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_handempty))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), cpa_holding(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_holding(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_on(cpa_a, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), cpa_on(cpa_a, cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_on(cpa_b, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_on(cpa_b, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_on(cpa_c, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_on(cpa_c, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_ontable(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), neg(cpa_ontable(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0004)), cpa_ontable(cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), cpa_clear(cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_clear(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_clear(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), cpa_handempty)).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_holding(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_holding(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_on(cpa_a, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), cpa_on(cpa_a, cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_on(cpa_b, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_on(cpa_b, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_on(cpa_c, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), cpa_on(cpa_c, cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_ontable(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), cpa_ontable(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0005)), neg(cpa_ontable(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_clear(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), cpa_clear(cpa_b))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_clear(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), cpa_handempty)).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_holding(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_holding(cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_on(cpa_a, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), cpa_on(cpa_a, cpa_c))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), cpa_on(cpa_b, cpa_a))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_on(cpa_b, cpa_c)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_on(cpa_c, cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_on(cpa_c, cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_ontable(cpa_a)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), neg(cpa_ontable(cpa_b)))).
cpa_initially(cpa_or( cpa_or( neg(cpa_igc_ce_69249b1276_sel_0006)), cpa_ontable(cpa_c))).
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
plan_goal(cpa_ontable(cpa_a)).
plan_goal(cpa_on(cpa_b, cpa_a)).
plan_goal(cpa_on(cpa_c, cpa_b)).
