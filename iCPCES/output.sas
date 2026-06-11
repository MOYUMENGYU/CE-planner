begin_version
3
end_version
begin_metric
0
end_metric
10
begin_variable
var0
-1
2
Atom clear(a, inter1)
NegatedAtom clear(a, inter1)
end_variable
begin_variable
var1
-1
2
Atom clear(b, inter1)
NegatedAtom clear(b, inter1)
end_variable
begin_variable
var2
-1
2
Atom handempty(inter1)
NegatedAtom handempty(inter1)
end_variable
begin_variable
var3
-1
3
Atom holding(a, inter1)
Atom on(a, b, inter1)
Atom ontable(a, inter1)
end_variable
begin_variable
var4
-1
3
Atom holding(b, inter1)
Atom on(b, a, inter1)
Atom ontable(b, inter1)
end_variable
begin_variable
var5
-1
2
Atom clear(a, inter2)
NegatedAtom clear(a, inter2)
end_variable
begin_variable
var6
-1
2
Atom clear(b, inter2)
NegatedAtom clear(b, inter2)
end_variable
begin_variable
var7
-1
2
Atom handempty(inter2)
NegatedAtom handempty(inter2)
end_variable
begin_variable
var8
-1
3
Atom holding(a, inter2)
Atom on(a, b, inter2)
Atom ontable(a, inter2)
end_variable
begin_variable
var9
-1
3
Atom holding(b, inter2)
Atom on(b, a, inter2)
Atom ontable(b, inter2)
end_variable
0
begin_state
0
1
1
2
0
0
1
0
1
2
end_state
begin_goal
4
3 2
4 1
8 2
9 1
end_goal
8
begin_operator
pick-up a
0
6
2 7 0 8 2 5 -1 1
3 5 0 7 0 8 2 8 -1 0
2 0 0 3 2 2 -1 1
2 2 0 3 2 0 -1 1
2 5 0 8 2 7 -1 1
3 0 0 2 0 3 2 3 -1 0
1
end_operator
begin_operator
pick-up b
0
6
2 2 0 4 2 1 -1 1
3 6 0 7 0 9 2 9 -1 0
2 1 0 4 2 2 -1 1
2 7 0 9 2 6 -1 1
2 6 0 9 2 7 -1 1
3 1 0 2 0 4 2 4 -1 0
1
end_operator
begin_operator
put-down a
0
6
1 8 0 5 -1 0
1 3 0 3 -1 2
1 3 0 2 -1 0
1 8 0 8 -1 2
1 8 0 7 -1 0
1 3 0 0 -1 0
1
end_operator
begin_operator
put-down b
0
6
1 9 0 9 -1 2
1 4 0 4 -1 2
1 9 0 7 -1 0
1 4 0 2 -1 0
1 4 0 1 -1 0
1 9 0 6 -1 0
1
end_operator
begin_operator
stack a b
0
8
2 1 0 3 0 3 -1 1
1 8 0 6 -1 1
2 6 0 8 0 5 -1 0
2 1 0 3 0 0 -1 0
2 6 0 8 0 8 -1 1
2 6 0 8 0 7 -1 0
1 3 0 1 -1 1
2 1 0 3 0 2 -1 0
1
end_operator
begin_operator
stack b a
0
8
2 0 0 4 0 1 -1 0
1 4 0 0 -1 1
2 0 0 4 0 2 -1 0
2 5 0 9 0 9 -1 1
1 9 0 5 -1 1
2 0 0 4 0 4 -1 1
2 5 0 9 0 6 -1 0
2 5 0 9 0 7 -1 0
1
end_operator
begin_operator
unstack a b
0
8
3 0 0 2 0 3 1 3 -1 0
2 0 0 3 1 2 -1 1
2 7 0 8 1 5 -1 1
3 5 0 7 0 8 1 6 -1 0
3 0 0 2 0 3 1 1 -1 0
2 5 0 8 1 7 -1 1
2 2 0 3 1 0 -1 1
3 5 0 7 0 8 1 8 -1 0
1
end_operator
begin_operator
unstack b a
0
8
3 1 0 2 0 4 1 0 -1 0
3 6 0 7 0 9 1 5 -1 0
2 1 0 4 1 2 -1 1
2 2 0 4 1 1 -1 1
3 6 0 7 0 9 1 9 -1 0
2 7 0 9 1 6 -1 1
3 1 0 2 0 4 1 4 -1 0
2 6 0 9 1 7 -1 1
1
end_operator
0
