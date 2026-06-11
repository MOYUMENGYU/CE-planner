
:- use_module(library(lists)).
:- dynamic executable/2.
:- dynamic cpa_executable/2.
:- dynamic causes/3.
:- dynamic cpa_causes/3.
:- dynamic cpa_initially/1.

%%%% Objects %%%%

%%%% Constants %%%%
cpa_pos(cpa_p1).
cpa_pos(cpa_p2).
cpa_pos(cpa_p3).
cpa_pos(cpa_p4).
cpa_pos(cpa_p5).
cpa_pos(cpa_p6).
cpa_pos(cpa_p7).
cpa_pos(cpa_p8).
cpa_pos(cpa_p9).
cpa_pos(cpa_p10).
cpa_pos(cpa_p11).
cpa_pos(cpa_p12).
cpa_pos(cpa_p13).
cpa_pos(cpa_p14).
cpa_pos(cpa_p15).
cpa_pos(cpa_p16).
cpa_pos(cpa_p17).
cpa_pos(cpa_p18).
cpa_pos(cpa_p19).
cpa_pos(cpa_p20).
cpa_pos(cpa_p21).
cpa_pos(cpa_p22).
cpa_pos(cpa_p23).
cpa_pos(cpa_p24).
cpa_pos(cpa_p25).
cpa_pos(cpa_p26).
cpa_pos(cpa_p27).
cpa_pos(cpa_p28).
cpa_pos(cpa_p29).
cpa_pos(cpa_p30).
cpa_pos(cpa_p31).
cpa_pos(cpa_p32).
cpa_pos(cpa_p33).
cpa_pos(cpa_p34).
cpa_pos(cpa_p35).
cpa_pos(cpa_p36).
cpa_pos(cpa_p37).
cpa_pos(cpa_p38).
cpa_pos(cpa_p39).
cpa_pos(cpa_p40).
cpa_pos(cpa_p41).
cpa_pos(cpa_p42).
cpa_pos(cpa_p43).
cpa_pos(cpa_p44).
cpa_pos(cpa_p45).
cpa_pos(cpa_p46).
cpa_pos(cpa_p47).
cpa_pos(cpa_p48).
cpa_pos(cpa_p49).
cpa_pos(cpa_p50).
cpa_pos(cpa_p51).
cpa_pos(cpa_p52).

%%%%  Types rules %%%%

%%%% Predicates %%%%
fluent(cpa_x(  P)):-
	cpa_pos( P).

fluent(cpa_y(  P)):-
	cpa_pos( P).


%%%% Actions %%%%
action(cpa_right).

action(cpa_left).

action(cpa_down).

action(cpa_up).


%%%% Preconditions %%%%
executable(cpa_right, [
 ]).

executable(cpa_left, [
 ]).

executable(cpa_down, [
 ]).

executable(cpa_up, [
 ]).


%%%% Effects %%%%
causes(cpa_right, [
cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_when( cpa_x(cpa_p1), cpa_and( neg(cpa_x(cpa_p1)), cpa_and( cpa_x(cpa_p2))))), cpa_when( cpa_x(cpa_p2), cpa_and( neg(cpa_x(cpa_p2)), cpa_and( cpa_x(cpa_p3))))), cpa_when( cpa_x(cpa_p3), cpa_and( neg(cpa_x(cpa_p3)), cpa_and( cpa_x(cpa_p4))))), cpa_when( cpa_x(cpa_p4), cpa_and( neg(cpa_x(cpa_p4)), cpa_and( cpa_x(cpa_p5))))), cpa_when( cpa_x(cpa_p5), cpa_and( neg(cpa_x(cpa_p5)), cpa_and( cpa_x(cpa_p6))))), cpa_when( cpa_x(cpa_p6), cpa_and( neg(cpa_x(cpa_p6)), cpa_and( cpa_x(cpa_p7))))), cpa_when( cpa_x(cpa_p7), cpa_and( neg(cpa_x(cpa_p7)), cpa_and( cpa_x(cpa_p8))))), cpa_when( cpa_x(cpa_p8), cpa_and( neg(cpa_x(cpa_p8)), cpa_and( cpa_x(cpa_p9))))), cpa_when( cpa_x(cpa_p9), cpa_and( neg(cpa_x(cpa_p9)), cpa_and( cpa_x(cpa_p10))))), cpa_when( cpa_x(cpa_p10), cpa_and( neg(cpa_x(cpa_p10)), cpa_and( cpa_x(cpa_p11))))), cpa_when( cpa_x(cpa_p11), cpa_and( neg(cpa_x(cpa_p11)), cpa_and( cpa_x(cpa_p12))))), cpa_when( cpa_x(cpa_p12), cpa_and( neg(cpa_x(cpa_p12)), cpa_and( cpa_x(cpa_p13))))), cpa_when( cpa_x(cpa_p13), cpa_and( neg(cpa_x(cpa_p13)), cpa_and( cpa_x(cpa_p14))))), cpa_when( cpa_x(cpa_p14), cpa_and( neg(cpa_x(cpa_p14)), cpa_and( cpa_x(cpa_p15))))), cpa_when( cpa_x(cpa_p15), cpa_and( neg(cpa_x(cpa_p15)), cpa_and( cpa_x(cpa_p16))))), cpa_when( cpa_x(cpa_p16), cpa_and( neg(cpa_x(cpa_p16)), cpa_and( cpa_x(cpa_p17))))), cpa_when( cpa_x(cpa_p17), cpa_and( neg(cpa_x(cpa_p17)), cpa_and( cpa_x(cpa_p18))))), cpa_when( cpa_x(cpa_p18), cpa_and( neg(cpa_x(cpa_p18)), cpa_and( cpa_x(cpa_p19))))), cpa_when( cpa_x(cpa_p19), cpa_and( neg(cpa_x(cpa_p19)), cpa_and( cpa_x(cpa_p20))))), cpa_when( cpa_x(cpa_p20), cpa_and( neg(cpa_x(cpa_p20)), cpa_and( cpa_x(cpa_p21))))), cpa_when( cpa_x(cpa_p21), cpa_and( neg(cpa_x(cpa_p21)), cpa_and( cpa_x(cpa_p22))))), cpa_when( cpa_x(cpa_p22), cpa_and( neg(cpa_x(cpa_p22)), cpa_and( cpa_x(cpa_p23))))), cpa_when( cpa_x(cpa_p23), cpa_and( neg(cpa_x(cpa_p23)), cpa_and( cpa_x(cpa_p24))))), cpa_when( cpa_x(cpa_p24), cpa_and( neg(cpa_x(cpa_p24)), cpa_and( cpa_x(cpa_p25))))), cpa_when( cpa_x(cpa_p25), cpa_and( neg(cpa_x(cpa_p25)), cpa_and( cpa_x(cpa_p26))))), cpa_when( cpa_x(cpa_p26), cpa_and( neg(cpa_x(cpa_p26)), cpa_and( cpa_x(cpa_p27))))), cpa_when( cpa_x(cpa_p27), cpa_and( neg(cpa_x(cpa_p27)), cpa_and( cpa_x(cpa_p28))))), cpa_when( cpa_x(cpa_p28), cpa_and( neg(cpa_x(cpa_p28)), cpa_and( cpa_x(cpa_p29))))), cpa_when( cpa_x(cpa_p29), cpa_and( neg(cpa_x(cpa_p29)), cpa_and( cpa_x(cpa_p30))))), cpa_when( cpa_x(cpa_p30), cpa_and( neg(cpa_x(cpa_p30)), cpa_and( cpa_x(cpa_p31))))), cpa_when( cpa_x(cpa_p31), cpa_and( neg(cpa_x(cpa_p31)), cpa_and( cpa_x(cpa_p32))))), cpa_when( cpa_x(cpa_p32), cpa_and( neg(cpa_x(cpa_p32)), cpa_and( cpa_x(cpa_p33))))), cpa_when( cpa_x(cpa_p33), cpa_and( neg(cpa_x(cpa_p33)), cpa_and( cpa_x(cpa_p34))))), cpa_when( cpa_x(cpa_p34), cpa_and( neg(cpa_x(cpa_p34)), cpa_and( cpa_x(cpa_p35))))), cpa_when( cpa_x(cpa_p35), cpa_and( neg(cpa_x(cpa_p35)), cpa_and( cpa_x(cpa_p36))))), cpa_when( cpa_x(cpa_p36), cpa_and( neg(cpa_x(cpa_p36)), cpa_and( cpa_x(cpa_p37))))), cpa_when( cpa_x(cpa_p37), cpa_and( neg(cpa_x(cpa_p37)), cpa_and( cpa_x(cpa_p38))))), cpa_when( cpa_x(cpa_p38), cpa_and( neg(cpa_x(cpa_p38)), cpa_and( cpa_x(cpa_p39))))), cpa_when( cpa_x(cpa_p39), cpa_and( neg(cpa_x(cpa_p39)), cpa_and( cpa_x(cpa_p40))))), cpa_when( cpa_x(cpa_p40), cpa_and( neg(cpa_x(cpa_p40)), cpa_and( cpa_x(cpa_p41))))), cpa_when( cpa_x(cpa_p41), cpa_and( neg(cpa_x(cpa_p41)), cpa_and( cpa_x(cpa_p42))))), cpa_when( cpa_x(cpa_p42), cpa_and( neg(cpa_x(cpa_p42)), cpa_and( cpa_x(cpa_p43))))), cpa_when( cpa_x(cpa_p43), cpa_and( neg(cpa_x(cpa_p43)), cpa_and( cpa_x(cpa_p44))))), cpa_when( cpa_x(cpa_p44), cpa_and( neg(cpa_x(cpa_p44)), cpa_and( cpa_x(cpa_p45))))), cpa_when( cpa_x(cpa_p45), cpa_and( neg(cpa_x(cpa_p45)), cpa_and( cpa_x(cpa_p46))))), cpa_when( cpa_x(cpa_p46), cpa_and( neg(cpa_x(cpa_p46)), cpa_and( cpa_x(cpa_p47))))), cpa_when( cpa_x(cpa_p47), cpa_and( neg(cpa_x(cpa_p47)), cpa_and( cpa_x(cpa_p48))))), cpa_when( cpa_x(cpa_p48), cpa_and( neg(cpa_x(cpa_p48)), cpa_and( cpa_x(cpa_p49))))), cpa_when( cpa_x(cpa_p49), cpa_and( neg(cpa_x(cpa_p49)), cpa_and( cpa_x(cpa_p50))))), cpa_when( cpa_x(cpa_p50), cpa_and( neg(cpa_x(cpa_p50)), cpa_and( cpa_x(cpa_p51))))), cpa_when( cpa_x(cpa_p51), cpa_and( neg(cpa_x(cpa_p51)), cpa_and( cpa_x(cpa_p52))))) ], 
[]).

causes(cpa_left, [
cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_when( cpa_x(cpa_p2), cpa_and( neg(cpa_x(cpa_p2)), cpa_and( cpa_x(cpa_p1))))), cpa_when( cpa_x(cpa_p3), cpa_and( neg(cpa_x(cpa_p3)), cpa_and( cpa_x(cpa_p2))))), cpa_when( cpa_x(cpa_p4), cpa_and( neg(cpa_x(cpa_p4)), cpa_and( cpa_x(cpa_p3))))), cpa_when( cpa_x(cpa_p5), cpa_and( neg(cpa_x(cpa_p5)), cpa_and( cpa_x(cpa_p4))))), cpa_when( cpa_x(cpa_p6), cpa_and( neg(cpa_x(cpa_p6)), cpa_and( cpa_x(cpa_p5))))), cpa_when( cpa_x(cpa_p7), cpa_and( neg(cpa_x(cpa_p7)), cpa_and( cpa_x(cpa_p6))))), cpa_when( cpa_x(cpa_p8), cpa_and( neg(cpa_x(cpa_p8)), cpa_and( cpa_x(cpa_p7))))), cpa_when( cpa_x(cpa_p9), cpa_and( neg(cpa_x(cpa_p9)), cpa_and( cpa_x(cpa_p8))))), cpa_when( cpa_x(cpa_p10), cpa_and( neg(cpa_x(cpa_p10)), cpa_and( cpa_x(cpa_p9))))), cpa_when( cpa_x(cpa_p11), cpa_and( neg(cpa_x(cpa_p11)), cpa_and( cpa_x(cpa_p10))))), cpa_when( cpa_x(cpa_p12), cpa_and( neg(cpa_x(cpa_p12)), cpa_and( cpa_x(cpa_p11))))), cpa_when( cpa_x(cpa_p13), cpa_and( neg(cpa_x(cpa_p13)), cpa_and( cpa_x(cpa_p12))))), cpa_when( cpa_x(cpa_p14), cpa_and( neg(cpa_x(cpa_p14)), cpa_and( cpa_x(cpa_p13))))), cpa_when( cpa_x(cpa_p15), cpa_and( neg(cpa_x(cpa_p15)), cpa_and( cpa_x(cpa_p14))))), cpa_when( cpa_x(cpa_p16), cpa_and( neg(cpa_x(cpa_p16)), cpa_and( cpa_x(cpa_p15))))), cpa_when( cpa_x(cpa_p17), cpa_and( neg(cpa_x(cpa_p17)), cpa_and( cpa_x(cpa_p16))))), cpa_when( cpa_x(cpa_p18), cpa_and( neg(cpa_x(cpa_p18)), cpa_and( cpa_x(cpa_p17))))), cpa_when( cpa_x(cpa_p19), cpa_and( neg(cpa_x(cpa_p19)), cpa_and( cpa_x(cpa_p18))))), cpa_when( cpa_x(cpa_p20), cpa_and( neg(cpa_x(cpa_p20)), cpa_and( cpa_x(cpa_p19))))), cpa_when( cpa_x(cpa_p21), cpa_and( neg(cpa_x(cpa_p21)), cpa_and( cpa_x(cpa_p20))))), cpa_when( cpa_x(cpa_p22), cpa_and( neg(cpa_x(cpa_p22)), cpa_and( cpa_x(cpa_p21))))), cpa_when( cpa_x(cpa_p23), cpa_and( neg(cpa_x(cpa_p23)), cpa_and( cpa_x(cpa_p22))))), cpa_when( cpa_x(cpa_p24), cpa_and( neg(cpa_x(cpa_p24)), cpa_and( cpa_x(cpa_p23))))), cpa_when( cpa_x(cpa_p25), cpa_and( neg(cpa_x(cpa_p25)), cpa_and( cpa_x(cpa_p24))))), cpa_when( cpa_x(cpa_p26), cpa_and( neg(cpa_x(cpa_p26)), cpa_and( cpa_x(cpa_p25))))), cpa_when( cpa_x(cpa_p27), cpa_and( neg(cpa_x(cpa_p27)), cpa_and( cpa_x(cpa_p26))))), cpa_when( cpa_x(cpa_p28), cpa_and( neg(cpa_x(cpa_p28)), cpa_and( cpa_x(cpa_p27))))), cpa_when( cpa_x(cpa_p29), cpa_and( neg(cpa_x(cpa_p29)), cpa_and( cpa_x(cpa_p28))))), cpa_when( cpa_x(cpa_p30), cpa_and( neg(cpa_x(cpa_p30)), cpa_and( cpa_x(cpa_p29))))), cpa_when( cpa_x(cpa_p31), cpa_and( neg(cpa_x(cpa_p31)), cpa_and( cpa_x(cpa_p30))))), cpa_when( cpa_x(cpa_p32), cpa_and( neg(cpa_x(cpa_p32)), cpa_and( cpa_x(cpa_p31))))), cpa_when( cpa_x(cpa_p33), cpa_and( neg(cpa_x(cpa_p33)), cpa_and( cpa_x(cpa_p32))))), cpa_when( cpa_x(cpa_p34), cpa_and( neg(cpa_x(cpa_p34)), cpa_and( cpa_x(cpa_p33))))), cpa_when( cpa_x(cpa_p35), cpa_and( neg(cpa_x(cpa_p35)), cpa_and( cpa_x(cpa_p34))))), cpa_when( cpa_x(cpa_p36), cpa_and( neg(cpa_x(cpa_p36)), cpa_and( cpa_x(cpa_p35))))), cpa_when( cpa_x(cpa_p37), cpa_and( neg(cpa_x(cpa_p37)), cpa_and( cpa_x(cpa_p36))))), cpa_when( cpa_x(cpa_p38), cpa_and( neg(cpa_x(cpa_p38)), cpa_and( cpa_x(cpa_p37))))), cpa_when( cpa_x(cpa_p39), cpa_and( neg(cpa_x(cpa_p39)), cpa_and( cpa_x(cpa_p38))))), cpa_when( cpa_x(cpa_p40), cpa_and( neg(cpa_x(cpa_p40)), cpa_and( cpa_x(cpa_p39))))), cpa_when( cpa_x(cpa_p41), cpa_and( neg(cpa_x(cpa_p41)), cpa_and( cpa_x(cpa_p40))))), cpa_when( cpa_x(cpa_p42), cpa_and( neg(cpa_x(cpa_p42)), cpa_and( cpa_x(cpa_p41))))), cpa_when( cpa_x(cpa_p43), cpa_and( neg(cpa_x(cpa_p43)), cpa_and( cpa_x(cpa_p42))))), cpa_when( cpa_x(cpa_p44), cpa_and( neg(cpa_x(cpa_p44)), cpa_and( cpa_x(cpa_p43))))), cpa_when( cpa_x(cpa_p45), cpa_and( neg(cpa_x(cpa_p45)), cpa_and( cpa_x(cpa_p44))))), cpa_when( cpa_x(cpa_p46), cpa_and( neg(cpa_x(cpa_p46)), cpa_and( cpa_x(cpa_p45))))), cpa_when( cpa_x(cpa_p47), cpa_and( neg(cpa_x(cpa_p47)), cpa_and( cpa_x(cpa_p46))))), cpa_when( cpa_x(cpa_p48), cpa_and( neg(cpa_x(cpa_p48)), cpa_and( cpa_x(cpa_p47))))), cpa_when( cpa_x(cpa_p49), cpa_and( neg(cpa_x(cpa_p49)), cpa_and( cpa_x(cpa_p48))))), cpa_when( cpa_x(cpa_p50), cpa_and( neg(cpa_x(cpa_p50)), cpa_and( cpa_x(cpa_p49))))), cpa_when( cpa_x(cpa_p51), cpa_and( neg(cpa_x(cpa_p51)), cpa_and( cpa_x(cpa_p50))))), cpa_when( cpa_x(cpa_p52), cpa_and( neg(cpa_x(cpa_p52)), cpa_and( cpa_x(cpa_p51))))) ], 
[]).

causes(cpa_down, [
cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_when( cpa_y(cpa_p1), cpa_and( neg(cpa_y(cpa_p1)), cpa_and( cpa_y(cpa_p2))))), cpa_when( cpa_y(cpa_p2), cpa_and( neg(cpa_y(cpa_p2)), cpa_and( cpa_y(cpa_p3))))), cpa_when( cpa_y(cpa_p3), cpa_and( neg(cpa_y(cpa_p3)), cpa_and( cpa_y(cpa_p4))))), cpa_when( cpa_y(cpa_p4), cpa_and( neg(cpa_y(cpa_p4)), cpa_and( cpa_y(cpa_p5))))), cpa_when( cpa_y(cpa_p5), cpa_and( neg(cpa_y(cpa_p5)), cpa_and( cpa_y(cpa_p6))))), cpa_when( cpa_y(cpa_p6), cpa_and( neg(cpa_y(cpa_p6)), cpa_and( cpa_y(cpa_p7))))), cpa_when( cpa_y(cpa_p7), cpa_and( neg(cpa_y(cpa_p7)), cpa_and( cpa_y(cpa_p8))))), cpa_when( cpa_y(cpa_p8), cpa_and( neg(cpa_y(cpa_p8)), cpa_and( cpa_y(cpa_p9))))), cpa_when( cpa_y(cpa_p9), cpa_and( neg(cpa_y(cpa_p9)), cpa_and( cpa_y(cpa_p10))))), cpa_when( cpa_y(cpa_p10), cpa_and( neg(cpa_y(cpa_p10)), cpa_and( cpa_y(cpa_p11))))), cpa_when( cpa_y(cpa_p11), cpa_and( neg(cpa_y(cpa_p11)), cpa_and( cpa_y(cpa_p12))))), cpa_when( cpa_y(cpa_p12), cpa_and( neg(cpa_y(cpa_p12)), cpa_and( cpa_y(cpa_p13))))), cpa_when( cpa_y(cpa_p13), cpa_and( neg(cpa_y(cpa_p13)), cpa_and( cpa_y(cpa_p14))))), cpa_when( cpa_y(cpa_p14), cpa_and( neg(cpa_y(cpa_p14)), cpa_and( cpa_y(cpa_p15))))), cpa_when( cpa_y(cpa_p15), cpa_and( neg(cpa_y(cpa_p15)), cpa_and( cpa_y(cpa_p16))))), cpa_when( cpa_y(cpa_p16), cpa_and( neg(cpa_y(cpa_p16)), cpa_and( cpa_y(cpa_p17))))), cpa_when( cpa_y(cpa_p17), cpa_and( neg(cpa_y(cpa_p17)), cpa_and( cpa_y(cpa_p18))))), cpa_when( cpa_y(cpa_p18), cpa_and( neg(cpa_y(cpa_p18)), cpa_and( cpa_y(cpa_p19))))), cpa_when( cpa_y(cpa_p19), cpa_and( neg(cpa_y(cpa_p19)), cpa_and( cpa_y(cpa_p20))))), cpa_when( cpa_y(cpa_p20), cpa_and( neg(cpa_y(cpa_p20)), cpa_and( cpa_y(cpa_p21))))), cpa_when( cpa_y(cpa_p21), cpa_and( neg(cpa_y(cpa_p21)), cpa_and( cpa_y(cpa_p22))))), cpa_when( cpa_y(cpa_p22), cpa_and( neg(cpa_y(cpa_p22)), cpa_and( cpa_y(cpa_p23))))), cpa_when( cpa_y(cpa_p23), cpa_and( neg(cpa_y(cpa_p23)), cpa_and( cpa_y(cpa_p24))))), cpa_when( cpa_y(cpa_p24), cpa_and( neg(cpa_y(cpa_p24)), cpa_and( cpa_y(cpa_p25))))), cpa_when( cpa_y(cpa_p25), cpa_and( neg(cpa_y(cpa_p25)), cpa_and( cpa_y(cpa_p26))))), cpa_when( cpa_y(cpa_p26), cpa_and( neg(cpa_y(cpa_p26)), cpa_and( cpa_y(cpa_p27))))), cpa_when( cpa_y(cpa_p27), cpa_and( neg(cpa_y(cpa_p27)), cpa_and( cpa_y(cpa_p28))))), cpa_when( cpa_y(cpa_p28), cpa_and( neg(cpa_y(cpa_p28)), cpa_and( cpa_y(cpa_p29))))), cpa_when( cpa_y(cpa_p29), cpa_and( neg(cpa_y(cpa_p29)), cpa_and( cpa_y(cpa_p30))))), cpa_when( cpa_y(cpa_p30), cpa_and( neg(cpa_y(cpa_p30)), cpa_and( cpa_y(cpa_p31))))), cpa_when( cpa_y(cpa_p31), cpa_and( neg(cpa_y(cpa_p31)), cpa_and( cpa_y(cpa_p32))))), cpa_when( cpa_y(cpa_p32), cpa_and( neg(cpa_y(cpa_p32)), cpa_and( cpa_y(cpa_p33))))), cpa_when( cpa_y(cpa_p33), cpa_and( neg(cpa_y(cpa_p33)), cpa_and( cpa_y(cpa_p34))))), cpa_when( cpa_y(cpa_p34), cpa_and( neg(cpa_y(cpa_p34)), cpa_and( cpa_y(cpa_p35))))), cpa_when( cpa_y(cpa_p35), cpa_and( neg(cpa_y(cpa_p35)), cpa_and( cpa_y(cpa_p36))))), cpa_when( cpa_y(cpa_p36), cpa_and( neg(cpa_y(cpa_p36)), cpa_and( cpa_y(cpa_p37))))), cpa_when( cpa_y(cpa_p37), cpa_and( neg(cpa_y(cpa_p37)), cpa_and( cpa_y(cpa_p38))))), cpa_when( cpa_y(cpa_p38), cpa_and( neg(cpa_y(cpa_p38)), cpa_and( cpa_y(cpa_p39))))), cpa_when( cpa_y(cpa_p39), cpa_and( neg(cpa_y(cpa_p39)), cpa_and( cpa_y(cpa_p40))))), cpa_when( cpa_y(cpa_p40), cpa_and( neg(cpa_y(cpa_p40)), cpa_and( cpa_y(cpa_p41))))), cpa_when( cpa_y(cpa_p41), cpa_and( neg(cpa_y(cpa_p41)), cpa_and( cpa_y(cpa_p42))))), cpa_when( cpa_y(cpa_p42), cpa_and( neg(cpa_y(cpa_p42)), cpa_and( cpa_y(cpa_p43))))), cpa_when( cpa_y(cpa_p43), cpa_and( neg(cpa_y(cpa_p43)), cpa_and( cpa_y(cpa_p44))))), cpa_when( cpa_y(cpa_p44), cpa_and( neg(cpa_y(cpa_p44)), cpa_and( cpa_y(cpa_p45))))), cpa_when( cpa_y(cpa_p45), cpa_and( neg(cpa_y(cpa_p45)), cpa_and( cpa_y(cpa_p46))))), cpa_when( cpa_y(cpa_p46), cpa_and( neg(cpa_y(cpa_p46)), cpa_and( cpa_y(cpa_p47))))), cpa_when( cpa_y(cpa_p47), cpa_and( neg(cpa_y(cpa_p47)), cpa_and( cpa_y(cpa_p48))))), cpa_when( cpa_y(cpa_p48), cpa_and( neg(cpa_y(cpa_p48)), cpa_and( cpa_y(cpa_p49))))), cpa_when( cpa_y(cpa_p49), cpa_and( neg(cpa_y(cpa_p49)), cpa_and( cpa_y(cpa_p50))))), cpa_when( cpa_y(cpa_p50), cpa_and( neg(cpa_y(cpa_p50)), cpa_and( cpa_y(cpa_p51))))), cpa_when( cpa_y(cpa_p51), cpa_and( neg(cpa_y(cpa_p51)), cpa_and( cpa_y(cpa_p52))))) ], 
[]).

causes(cpa_up, [
cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_and( cpa_when( cpa_y(cpa_p2), cpa_and( neg(cpa_y(cpa_p2)), cpa_and( cpa_y(cpa_p1))))), cpa_when( cpa_y(cpa_p3), cpa_and( neg(cpa_y(cpa_p3)), cpa_and( cpa_y(cpa_p2))))), cpa_when( cpa_y(cpa_p4), cpa_and( neg(cpa_y(cpa_p4)), cpa_and( cpa_y(cpa_p3))))), cpa_when( cpa_y(cpa_p5), cpa_and( neg(cpa_y(cpa_p5)), cpa_and( cpa_y(cpa_p4))))), cpa_when( cpa_y(cpa_p6), cpa_and( neg(cpa_y(cpa_p6)), cpa_and( cpa_y(cpa_p5))))), cpa_when( cpa_y(cpa_p7), cpa_and( neg(cpa_y(cpa_p7)), cpa_and( cpa_y(cpa_p6))))), cpa_when( cpa_y(cpa_p8), cpa_and( neg(cpa_y(cpa_p8)), cpa_and( cpa_y(cpa_p7))))), cpa_when( cpa_y(cpa_p9), cpa_and( neg(cpa_y(cpa_p9)), cpa_and( cpa_y(cpa_p8))))), cpa_when( cpa_y(cpa_p10), cpa_and( neg(cpa_y(cpa_p10)), cpa_and( cpa_y(cpa_p9))))), cpa_when( cpa_y(cpa_p11), cpa_and( neg(cpa_y(cpa_p11)), cpa_and( cpa_y(cpa_p10))))), cpa_when( cpa_y(cpa_p12), cpa_and( neg(cpa_y(cpa_p12)), cpa_and( cpa_y(cpa_p11))))), cpa_when( cpa_y(cpa_p13), cpa_and( neg(cpa_y(cpa_p13)), cpa_and( cpa_y(cpa_p12))))), cpa_when( cpa_y(cpa_p14), cpa_and( neg(cpa_y(cpa_p14)), cpa_and( cpa_y(cpa_p13))))), cpa_when( cpa_y(cpa_p15), cpa_and( neg(cpa_y(cpa_p15)), cpa_and( cpa_y(cpa_p14))))), cpa_when( cpa_y(cpa_p16), cpa_and( neg(cpa_y(cpa_p16)), cpa_and( cpa_y(cpa_p15))))), cpa_when( cpa_y(cpa_p17), cpa_and( neg(cpa_y(cpa_p17)), cpa_and( cpa_y(cpa_p16))))), cpa_when( cpa_y(cpa_p18), cpa_and( neg(cpa_y(cpa_p18)), cpa_and( cpa_y(cpa_p17))))), cpa_when( cpa_y(cpa_p19), cpa_and( neg(cpa_y(cpa_p19)), cpa_and( cpa_y(cpa_p18))))), cpa_when( cpa_y(cpa_p20), cpa_and( neg(cpa_y(cpa_p20)), cpa_and( cpa_y(cpa_p19))))), cpa_when( cpa_y(cpa_p21), cpa_and( neg(cpa_y(cpa_p21)), cpa_and( cpa_y(cpa_p20))))), cpa_when( cpa_y(cpa_p22), cpa_and( neg(cpa_y(cpa_p22)), cpa_and( cpa_y(cpa_p21))))), cpa_when( cpa_y(cpa_p23), cpa_and( neg(cpa_y(cpa_p23)), cpa_and( cpa_y(cpa_p22))))), cpa_when( cpa_y(cpa_p24), cpa_and( neg(cpa_y(cpa_p24)), cpa_and( cpa_y(cpa_p23))))), cpa_when( cpa_y(cpa_p25), cpa_and( neg(cpa_y(cpa_p25)), cpa_and( cpa_y(cpa_p24))))), cpa_when( cpa_y(cpa_p26), cpa_and( neg(cpa_y(cpa_p26)), cpa_and( cpa_y(cpa_p25))))), cpa_when( cpa_y(cpa_p27), cpa_and( neg(cpa_y(cpa_p27)), cpa_and( cpa_y(cpa_p26))))), cpa_when( cpa_y(cpa_p28), cpa_and( neg(cpa_y(cpa_p28)), cpa_and( cpa_y(cpa_p27))))), cpa_when( cpa_y(cpa_p29), cpa_and( neg(cpa_y(cpa_p29)), cpa_and( cpa_y(cpa_p28))))), cpa_when( cpa_y(cpa_p30), cpa_and( neg(cpa_y(cpa_p30)), cpa_and( cpa_y(cpa_p29))))), cpa_when( cpa_y(cpa_p31), cpa_and( neg(cpa_y(cpa_p31)), cpa_and( cpa_y(cpa_p30))))), cpa_when( cpa_y(cpa_p32), cpa_and( neg(cpa_y(cpa_p32)), cpa_and( cpa_y(cpa_p31))))), cpa_when( cpa_y(cpa_p33), cpa_and( neg(cpa_y(cpa_p33)), cpa_and( cpa_y(cpa_p32))))), cpa_when( cpa_y(cpa_p34), cpa_and( neg(cpa_y(cpa_p34)), cpa_and( cpa_y(cpa_p33))))), cpa_when( cpa_y(cpa_p35), cpa_and( neg(cpa_y(cpa_p35)), cpa_and( cpa_y(cpa_p34))))), cpa_when( cpa_y(cpa_p36), cpa_and( neg(cpa_y(cpa_p36)), cpa_and( cpa_y(cpa_p35))))), cpa_when( cpa_y(cpa_p37), cpa_and( neg(cpa_y(cpa_p37)), cpa_and( cpa_y(cpa_p36))))), cpa_when( cpa_y(cpa_p38), cpa_and( neg(cpa_y(cpa_p38)), cpa_and( cpa_y(cpa_p37))))), cpa_when( cpa_y(cpa_p39), cpa_and( neg(cpa_y(cpa_p39)), cpa_and( cpa_y(cpa_p38))))), cpa_when( cpa_y(cpa_p40), cpa_and( neg(cpa_y(cpa_p40)), cpa_and( cpa_y(cpa_p39))))), cpa_when( cpa_y(cpa_p41), cpa_and( neg(cpa_y(cpa_p41)), cpa_and( cpa_y(cpa_p40))))), cpa_when( cpa_y(cpa_p42), cpa_and( neg(cpa_y(cpa_p42)), cpa_and( cpa_y(cpa_p41))))), cpa_when( cpa_y(cpa_p43), cpa_and( neg(cpa_y(cpa_p43)), cpa_and( cpa_y(cpa_p42))))), cpa_when( cpa_y(cpa_p44), cpa_and( neg(cpa_y(cpa_p44)), cpa_and( cpa_y(cpa_p43))))), cpa_when( cpa_y(cpa_p45), cpa_and( neg(cpa_y(cpa_p45)), cpa_and( cpa_y(cpa_p44))))), cpa_when( cpa_y(cpa_p46), cpa_and( neg(cpa_y(cpa_p46)), cpa_and( cpa_y(cpa_p45))))), cpa_when( cpa_y(cpa_p47), cpa_and( neg(cpa_y(cpa_p47)), cpa_and( cpa_y(cpa_p46))))), cpa_when( cpa_y(cpa_p48), cpa_and( neg(cpa_y(cpa_p48)), cpa_and( cpa_y(cpa_p47))))), cpa_when( cpa_y(cpa_p49), cpa_and( neg(cpa_y(cpa_p49)), cpa_and( cpa_y(cpa_p48))))), cpa_when( cpa_y(cpa_p50), cpa_and( neg(cpa_y(cpa_p50)), cpa_and( cpa_y(cpa_p49))))), cpa_when( cpa_y(cpa_p51), cpa_and( neg(cpa_y(cpa_p51)), cpa_and( cpa_y(cpa_p50))))), cpa_when( cpa_y(cpa_p52), cpa_and( neg(cpa_y(cpa_p52)), cpa_and( cpa_y(cpa_p51))))) ], 
[]).


%%%% Inits %%%%
cpa_initially(cpa_oneof([cpa_x(cpa_p1), cpa_x(cpa_p2), cpa_x(cpa_p3), cpa_x(cpa_p4), cpa_x(cpa_p5), cpa_x(cpa_p6), cpa_x(cpa_p7), cpa_x(cpa_p8), cpa_x(cpa_p9), cpa_x(cpa_p10), cpa_x(cpa_p11), cpa_x(cpa_p12), cpa_x(cpa_p13), cpa_x(cpa_p14), cpa_x(cpa_p15), cpa_x(cpa_p16), cpa_x(cpa_p17), cpa_x(cpa_p18), cpa_x(cpa_p19), cpa_x(cpa_p20), cpa_x(cpa_p21), cpa_x(cpa_p22), cpa_x(cpa_p23), cpa_x(cpa_p24), cpa_x(cpa_p25), cpa_x(cpa_p26), cpa_x(cpa_p27), cpa_x(cpa_p28), cpa_x(cpa_p29), cpa_x(cpa_p30), cpa_x(cpa_p31), cpa_x(cpa_p32), cpa_x(cpa_p33), cpa_x(cpa_p34), cpa_x(cpa_p35), cpa_x(cpa_p36), cpa_x(cpa_p37), cpa_x(cpa_p38), cpa_x(cpa_p39), cpa_x(cpa_p40), cpa_x(cpa_p41), cpa_x(cpa_p42), cpa_x(cpa_p43), cpa_x(cpa_p44), cpa_x(cpa_p45), cpa_x(cpa_p46), cpa_x(cpa_p47), cpa_x(cpa_p48), cpa_x(cpa_p49), cpa_x(cpa_p50), cpa_x(cpa_p51), cpa_x(cpa_p52)])).
cpa_initially(cpa_oneof([cpa_y(cpa_p1), cpa_y(cpa_p2), cpa_y(cpa_p3), cpa_y(cpa_p4), cpa_y(cpa_p5), cpa_y(cpa_p6), cpa_y(cpa_p7), cpa_y(cpa_p8), cpa_y(cpa_p9), cpa_y(cpa_p10), cpa_y(cpa_p11), cpa_y(cpa_p12), cpa_y(cpa_p13), cpa_y(cpa_p14), cpa_y(cpa_p15), cpa_y(cpa_p16), cpa_y(cpa_p17), cpa_y(cpa_p18), cpa_y(cpa_p19), cpa_y(cpa_p20), cpa_y(cpa_p21), cpa_y(cpa_p22), cpa_y(cpa_p23), cpa_y(cpa_p24), cpa_y(cpa_p25), cpa_y(cpa_p26), cpa_y(cpa_p27), cpa_y(cpa_p28), cpa_y(cpa_p29), cpa_y(cpa_p30), cpa_y(cpa_p31), cpa_y(cpa_p32), cpa_y(cpa_p33), cpa_y(cpa_p34), cpa_y(cpa_p35), cpa_y(cpa_p36), cpa_y(cpa_p37), cpa_y(cpa_p38), cpa_y(cpa_p39), cpa_y(cpa_p40), cpa_y(cpa_p41), cpa_y(cpa_p42), cpa_y(cpa_p43), cpa_y(cpa_p44), cpa_y(cpa_p45), cpa_y(cpa_p46), cpa_y(cpa_p47), cpa_y(cpa_p48), cpa_y(cpa_p49), cpa_y(cpa_p50), cpa_y(cpa_p51), cpa_y(cpa_p52)])).
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
plan_goal(cpa_x(cpa_p27)).
plan_goal(cpa_y(cpa_p27)).
