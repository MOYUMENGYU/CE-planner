begin_metric
0
end_metric
begin_variables
36
var0 2 0
var1 2 0
var2 2 0
var3 2 -1
var4 2 -1
var5 2 0
var6 2 -1
var7 2 -1
var8 2 -1
var9 2 -1
var10 2 -1
var11 2 -1
var12 2 0
var13 2 0
var14 2 -1
var15 2 -1
var16 2 0
var17 2 0
var18 2 -1
var19 2 -1
var20 2 -1
var21 2 -1
var22 2 0
var23 2 -1
var24 2 0
var25 2 0
var26 2 0
var27 2 -1
var28 2 0
var29 2 0
var30 2 -1
var31 2 0
var32 2 -1
var33 2 0
var34 2 -1
var35 2 -1
end_variables
begin_state
1
1
1
0
1
1
0
0
1
1
1
1
1
1
1
1
1
1
1
0
0
0
1
1
1
1
1
1
1
1
0
1
1
1
1
0
end_state
begin_goal
17
0 0
1 0
2 0
5 0
12 0
13 0
16 0
17 0
19 0
22 0
24 0
25 0
26 0
28 0
29 0
31 0
33 0
end_goal
1800
begin_operator
not-gate f t
0
4
1 6 0 3 -1 0
1 18 0 3 -1 1
1 18 0 4 -1 0
1 6 0 4 -1 1
0
end_operator
begin_operator
not-gate t f
0
4
1 3 0 6 -1 0
1 4 0 6 -1 1
1 4 0 18 -1 0
1 3 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 f t
0
6
2 18 0 23 0 3 -1 0
1 6 0 3 -1 1
1 14 0 3 -1 1
1 6 0 4 -1 0
1 14 0 4 -1 0
2 18 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 t f
0
6
1 4 0 6 -1 0
1 14 0 6 -1 0
2 3 0 23 0 6 -1 1
2 3 0 23 0 18 -1 0
1 4 0 18 -1 1
1 14 0 18 -1 1
0
end_operator
begin_operator
and-gate t f tmp1
0
6
1 4 0 14 -1 0
1 6 0 14 -1 0
2 18 0 3 0 14 -1 1
2 18 0 3 0 23 -1 0
1 4 0 23 -1 1
1 6 0 23 -1 1
0
end_operator
begin_operator
and-gate f t tmp1
0
6
1 4 0 14 -1 0
1 6 0 14 -1 0
2 18 0 3 0 14 -1 1
2 18 0 3 0 23 -1 0
1 4 0 23 -1 1
1 6 0 23 -1 1
0
end_operator
begin_operator
and-gate t tmp1 f
0
6
1 4 0 6 -1 0
1 14 0 6 -1 0
2 3 0 23 0 6 -1 1
2 3 0 23 0 18 -1 0
1 4 0 18 -1 1
1 14 0 18 -1 1
0
end_operator
begin_operator
and-gate f tmp1 t
0
6
2 18 0 23 0 3 -1 0
1 6 0 3 -1 1
1 14 0 3 -1 1
1 6 0 4 -1 0
1 14 0 4 -1 0
2 18 0 23 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 f t
0
6
1 18 0 3 -1 0
1 23 0 3 -1 0
2 6 0 14 0 3 -1 1
2 6 0 14 0 4 -1 0
1 18 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 t f
0
6
2 4 0 14 0 6 -1 0
1 3 0 6 -1 1
1 23 0 6 -1 1
1 3 0 18 -1 0
1 23 0 18 -1 0
2 4 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate t f tmp1
0
6
2 4 0 6 0 14 -1 0
1 3 0 14 -1 1
1 18 0 14 -1 1
1 3 0 23 -1 0
1 18 0 23 -1 0
2 4 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate f t tmp1
0
6
2 4 0 6 0 14 -1 0
1 3 0 14 -1 1
1 18 0 14 -1 1
1 3 0 23 -1 0
1 18 0 23 -1 0
2 4 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate t tmp1 f
0
6
2 4 0 14 0 6 -1 0
1 3 0 6 -1 1
1 23 0 6 -1 1
1 3 0 18 -1 0
1 23 0 18 -1 0
2 4 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate f tmp1 t
0
6
1 18 0 3 -1 0
1 23 0 3 -1 0
2 14 0 6 0 3 -1 1
2 14 0 6 0 4 -1 0
1 18 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 f t
0
8
2 6 0 23 0 3 -1 0
2 18 0 14 0 3 -1 0
2 6 0 14 0 3 -1 1
2 18 0 23 0 3 -1 1
2 6 0 14 0 4 -1 0
2 18 0 23 0 4 -1 0
2 6 0 23 0 4 -1 1
2 18 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 t f
0
8
2 3 0 23 0 6 -1 0
2 4 0 14 0 6 -1 0
2 3 0 14 0 6 -1 1
2 4 0 23 0 6 -1 1
2 3 0 14 0 18 -1 0
2 4 0 23 0 18 -1 0
2 3 0 23 0 18 -1 1
2 4 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate t f tmp1
0
8
2 4 0 6 0 14 -1 0
2 18 0 3 0 14 -1 0
2 3 0 6 0 14 -1 1
2 18 0 4 0 14 -1 1
2 3 0 6 0 23 -1 0
2 18 0 4 0 23 -1 0
2 4 0 6 0 23 -1 1
2 18 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate f t tmp1
0
8
2 4 0 6 0 14 -1 0
2 18 0 3 0 14 -1 0
2 3 0 6 0 14 -1 1
2 18 0 4 0 14 -1 1
2 3 0 6 0 23 -1 0
2 18 0 4 0 23 -1 0
2 4 0 6 0 23 -1 1
2 18 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate t tmp1 f
0
8
2 3 0 23 0 6 -1 0
2 4 0 14 0 6 -1 0
2 3 0 14 0 6 -1 1
2 4 0 23 0 6 -1 1
2 3 0 14 0 18 -1 0
2 4 0 23 0 18 -1 0
2 3 0 23 0 18 -1 1
2 4 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate f tmp1 t
0
8
2 6 0 23 0 3 -1 0
2 18 0 14 0 3 -1 0
2 14 0 6 0 3 -1 1
2 18 0 23 0 3 -1 1
2 14 0 6 0 4 -1 0
2 18 0 23 0 4 -1 0
2 6 0 23 0 4 -1 1
2 18 0 14 0 4 -1 1
0
end_operator
begin_operator
not-gate tmp1 t
0
4
1 14 0 3 -1 0
1 23 0 3 -1 1
1 23 0 4 -1 0
1 14 0 4 -1 1
0
end_operator
begin_operator
not-gate tmp1 f
0
4
1 23 0 6 -1 0
1 14 0 6 -1 1
1 14 0 18 -1 0
1 23 0 18 -1 1
0
end_operator
begin_operator
not-gate t tmp1
0
4
1 3 0 14 -1 0
1 4 0 14 -1 1
1 4 0 23 -1 0
1 3 0 23 -1 1
0
end_operator
begin_operator
not-gate f tmp1
0
4
1 18 0 14 -1 0
1 6 0 14 -1 1
1 6 0 23 -1 0
1 18 0 23 -1 1
0
end_operator
begin_operator
and-gate tmp2 f t
0
6
2 32 0 18 0 3 -1 0
1 6 0 3 -1 1
1 15 0 3 -1 1
1 6 0 4 -1 0
1 15 0 4 -1 0
2 32 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 tmp1 t
0
6
2 32 0 23 0 3 -1 0
1 14 0 3 -1 1
1 15 0 3 -1 1
1 14 0 4 -1 0
1 15 0 4 -1 0
2 32 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 t f
0
6
1 4 0 6 -1 0
1 15 0 6 -1 0
2 32 0 3 0 6 -1 1
2 32 0 3 0 18 -1 0
1 4 0 18 -1 1
1 15 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 tmp1 f
0
6
1 14 0 6 -1 0
1 15 0 6 -1 0
2 32 0 23 0 6 -1 1
2 32 0 23 0 18 -1 0
1 14 0 18 -1 1
1 15 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 t tmp1
0
6
1 4 0 14 -1 0
1 15 0 14 -1 0
2 32 0 3 0 14 -1 1
2 32 0 3 0 23 -1 0
1 4 0 23 -1 1
1 15 0 23 -1 1
0
end_operator
begin_operator
and-gate tmp2 f tmp1
0
6
1 6 0 14 -1 0
1 15 0 14 -1 0
2 32 0 18 0 14 -1 1
2 32 0 18 0 23 -1 0
1 6 0 23 -1 1
1 15 0 23 -1 1
0
end_operator
begin_operator
and-gate t f tmp2
0
6
1 4 0 15 -1 0
1 6 0 15 -1 0
2 18 0 3 0 15 -1 1
2 18 0 3 0 32 -1 0
1 4 0 32 -1 1
1 6 0 32 -1 1
0
end_operator
begin_operator
and-gate t tmp1 tmp2
0
6
1 4 0 15 -1 0
1 14 0 15 -1 0
2 3 0 23 0 15 -1 1
2 3 0 23 0 32 -1 0
1 4 0 32 -1 1
1 14 0 32 -1 1
0
end_operator
begin_operator
and-gate f t tmp2
0
6
1 4 0 15 -1 0
1 6 0 15 -1 0
2 18 0 3 0 15 -1 1
2 18 0 3 0 32 -1 0
1 4 0 32 -1 1
1 6 0 32 -1 1
0
end_operator
begin_operator
and-gate f tmp1 tmp2
0
6
1 6 0 15 -1 0
1 14 0 15 -1 0
2 18 0 23 0 15 -1 1
2 18 0 23 0 32 -1 0
1 6 0 32 -1 1
1 14 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 t tmp2
0
6
1 4 0 15 -1 0
1 14 0 15 -1 0
2 3 0 23 0 15 -1 1
2 3 0 23 0 32 -1 0
1 4 0 32 -1 1
1 14 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 f tmp2
0
6
1 6 0 15 -1 0
1 14 0 15 -1 0
2 18 0 23 0 15 -1 1
2 18 0 23 0 32 -1 0
1 6 0 32 -1 1
1 14 0 32 -1 1
0
end_operator
begin_operator
and-gate t tmp2 f
0
6
1 4 0 6 -1 0
1 15 0 6 -1 0
2 32 0 3 0 6 -1 1
2 32 0 3 0 18 -1 0
1 4 0 18 -1 1
1 15 0 18 -1 1
0
end_operator
begin_operator
and-gate t tmp2 tmp1
0
6
1 4 0 14 -1 0
1 15 0 14 -1 0
2 32 0 3 0 14 -1 1
2 32 0 3 0 23 -1 0
1 4 0 23 -1 1
1 15 0 23 -1 1
0
end_operator
begin_operator
and-gate f tmp2 t
0
6
2 32 0 18 0 3 -1 0
1 6 0 3 -1 1
1 15 0 3 -1 1
1 6 0 4 -1 0
1 15 0 4 -1 0
2 32 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate f tmp2 tmp1
0
6
1 6 0 14 -1 0
1 15 0 14 -1 0
2 32 0 18 0 14 -1 1
2 32 0 18 0 23 -1 0
1 6 0 23 -1 1
1 15 0 23 -1 1
0
end_operator
begin_operator
and-gate tmp1 tmp2 t
0
6
2 32 0 23 0 3 -1 0
1 14 0 3 -1 1
1 15 0 3 -1 1
1 14 0 4 -1 0
1 15 0 4 -1 0
2 32 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 tmp2 f
0
6
1 14 0 6 -1 0
1 15 0 6 -1 0
2 32 0 23 0 6 -1 1
2 32 0 23 0 18 -1 0
1 14 0 18 -1 1
1 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 f t
0
6
1 18 0 3 -1 0
1 32 0 3 -1 0
2 6 0 15 0 3 -1 1
2 6 0 15 0 4 -1 0
1 18 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 tmp1 t
0
6
1 23 0 3 -1 0
1 32 0 3 -1 0
2 14 0 15 0 3 -1 1
2 14 0 15 0 4 -1 0
1 23 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 t f
0
6
2 4 0 15 0 6 -1 0
1 3 0 6 -1 1
1 32 0 6 -1 1
1 3 0 18 -1 0
1 32 0 18 -1 0
2 4 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 tmp1 f
0
6
2 14 0 15 0 6 -1 0
1 23 0 6 -1 1
1 32 0 6 -1 1
1 23 0 18 -1 0
1 32 0 18 -1 0
2 14 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 t tmp1
0
6
2 4 0 15 0 14 -1 0
1 3 0 14 -1 1
1 32 0 14 -1 1
1 3 0 23 -1 0
1 32 0 23 -1 0
2 4 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate tmp2 f tmp1
0
6
2 6 0 15 0 14 -1 0
1 18 0 14 -1 1
1 32 0 14 -1 1
1 18 0 23 -1 0
1 32 0 23 -1 0
2 6 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate t f tmp2
0
6
2 4 0 6 0 15 -1 0
1 3 0 15 -1 1
1 18 0 15 -1 1
1 3 0 32 -1 0
1 18 0 32 -1 0
2 4 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate t tmp1 tmp2
0
6
2 4 0 14 0 15 -1 0
1 3 0 15 -1 1
1 23 0 15 -1 1
1 3 0 32 -1 0
1 23 0 32 -1 0
2 4 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate f t tmp2
0
6
2 4 0 6 0 15 -1 0
1 3 0 15 -1 1
1 18 0 15 -1 1
1 3 0 32 -1 0
1 18 0 32 -1 0
2 4 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate f tmp1 tmp2
0
6
2 14 0 6 0 15 -1 0
1 18 0 15 -1 1
1 23 0 15 -1 1
1 18 0 32 -1 0
1 23 0 32 -1 0
2 14 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 t tmp2
0
6
2 4 0 14 0 15 -1 0
1 3 0 15 -1 1
1 23 0 15 -1 1
1 3 0 32 -1 0
1 23 0 32 -1 0
2 4 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 f tmp2
0
6
2 6 0 14 0 15 -1 0
1 18 0 15 -1 1
1 23 0 15 -1 1
1 18 0 32 -1 0
1 23 0 32 -1 0
2 6 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate t tmp2 f
0
6
2 4 0 15 0 6 -1 0
1 3 0 6 -1 1
1 32 0 6 -1 1
1 3 0 18 -1 0
1 32 0 18 -1 0
2 4 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate t tmp2 tmp1
0
6
2 4 0 15 0 14 -1 0
1 3 0 14 -1 1
1 32 0 14 -1 1
1 3 0 23 -1 0
1 32 0 23 -1 0
2 4 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate f tmp2 t
0
6
1 18 0 3 -1 0
1 32 0 3 -1 0
2 6 0 15 0 3 -1 1
2 6 0 15 0 4 -1 0
1 18 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate f tmp2 tmp1
0
6
2 6 0 15 0 14 -1 0
1 18 0 14 -1 1
1 32 0 14 -1 1
1 18 0 23 -1 0
1 32 0 23 -1 0
2 6 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate tmp1 tmp2 t
0
6
1 23 0 3 -1 0
1 32 0 3 -1 0
2 14 0 15 0 3 -1 1
2 14 0 15 0 4 -1 0
1 23 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 tmp2 f
0
6
2 14 0 15 0 6 -1 0
1 23 0 6 -1 1
1 32 0 6 -1 1
1 23 0 18 -1 0
1 32 0 18 -1 0
2 14 0 15 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 f t
0
8
2 18 0 15 0 3 -1 0
2 32 0 6 0 3 -1 0
2 6 0 15 0 3 -1 1
2 32 0 18 0 3 -1 1
2 6 0 15 0 4 -1 0
2 32 0 18 0 4 -1 0
2 18 0 15 0 4 -1 1
2 32 0 6 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 tmp1 t
0
8
2 23 0 15 0 3 -1 0
2 32 0 14 0 3 -1 0
2 14 0 15 0 3 -1 1
2 32 0 23 0 3 -1 1
2 14 0 15 0 4 -1 0
2 32 0 23 0 4 -1 0
2 23 0 15 0 4 -1 1
2 32 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 t f
0
8
2 4 0 15 0 6 -1 0
2 32 0 3 0 6 -1 0
2 3 0 15 0 6 -1 1
2 32 0 4 0 6 -1 1
2 3 0 15 0 18 -1 0
2 32 0 4 0 18 -1 0
2 4 0 15 0 18 -1 1
2 32 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 tmp1 f
0
8
2 14 0 15 0 6 -1 0
2 32 0 23 0 6 -1 0
2 23 0 15 0 6 -1 1
2 32 0 14 0 6 -1 1
2 23 0 15 0 18 -1 0
2 32 0 14 0 18 -1 0
2 14 0 15 0 18 -1 1
2 32 0 23 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 t tmp1
0
8
2 4 0 15 0 14 -1 0
2 32 0 3 0 14 -1 0
2 3 0 15 0 14 -1 1
2 32 0 4 0 14 -1 1
2 3 0 15 0 23 -1 0
2 32 0 4 0 23 -1 0
2 4 0 15 0 23 -1 1
2 32 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate tmp2 f tmp1
0
8
2 6 0 15 0 14 -1 0
2 32 0 18 0 14 -1 0
2 18 0 15 0 14 -1 1
2 32 0 6 0 14 -1 1
2 18 0 15 0 23 -1 0
2 32 0 6 0 23 -1 0
2 6 0 15 0 23 -1 1
2 32 0 18 0 23 -1 1
0
end_operator
begin_operator
xor-gate t f tmp2
0
8
2 4 0 6 0 15 -1 0
2 18 0 3 0 15 -1 0
2 3 0 6 0 15 -1 1
2 18 0 4 0 15 -1 1
2 3 0 6 0 32 -1 0
2 18 0 4 0 32 -1 0
2 4 0 6 0 32 -1 1
2 18 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate t tmp1 tmp2
0
8
2 3 0 23 0 15 -1 0
2 4 0 14 0 15 -1 0
2 3 0 14 0 15 -1 1
2 4 0 23 0 15 -1 1
2 3 0 14 0 32 -1 0
2 4 0 23 0 32 -1 0
2 3 0 23 0 32 -1 1
2 4 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate f t tmp2
0
8
2 4 0 6 0 15 -1 0
2 18 0 3 0 15 -1 0
2 3 0 6 0 15 -1 1
2 18 0 4 0 15 -1 1
2 3 0 6 0 32 -1 0
2 18 0 4 0 32 -1 0
2 4 0 6 0 32 -1 1
2 18 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate f tmp1 tmp2
0
8
2 14 0 6 0 15 -1 0
2 18 0 23 0 15 -1 0
2 6 0 23 0 15 -1 1
2 18 0 14 0 15 -1 1
2 6 0 23 0 32 -1 0
2 18 0 14 0 32 -1 0
2 14 0 6 0 32 -1 1
2 18 0 23 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 t tmp2
0
8
2 3 0 23 0 15 -1 0
2 4 0 14 0 15 -1 0
2 3 0 14 0 15 -1 1
2 4 0 23 0 15 -1 1
2 3 0 14 0 32 -1 0
2 4 0 23 0 32 -1 0
2 3 0 23 0 32 -1 1
2 4 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 f tmp2
0
8
2 6 0 14 0 15 -1 0
2 18 0 23 0 15 -1 0
2 6 0 23 0 15 -1 1
2 18 0 14 0 15 -1 1
2 6 0 23 0 32 -1 0
2 18 0 14 0 32 -1 0
2 6 0 14 0 32 -1 1
2 18 0 23 0 32 -1 1
0
end_operator
begin_operator
xor-gate t tmp2 f
0
8
2 4 0 15 0 6 -1 0
2 32 0 3 0 6 -1 0
2 3 0 15 0 6 -1 1
2 32 0 4 0 6 -1 1
2 3 0 15 0 18 -1 0
2 32 0 4 0 18 -1 0
2 4 0 15 0 18 -1 1
2 32 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate t tmp2 tmp1
0
8
2 4 0 15 0 14 -1 0
2 32 0 3 0 14 -1 0
2 3 0 15 0 14 -1 1
2 32 0 4 0 14 -1 1
2 3 0 15 0 23 -1 0
2 32 0 4 0 23 -1 0
2 4 0 15 0 23 -1 1
2 32 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate f tmp2 t
0
8
2 18 0 15 0 3 -1 0
2 32 0 6 0 3 -1 0
2 6 0 15 0 3 -1 1
2 32 0 18 0 3 -1 1
2 6 0 15 0 4 -1 0
2 32 0 18 0 4 -1 0
2 18 0 15 0 4 -1 1
2 32 0 6 0 4 -1 1
0
end_operator
begin_operator
xor-gate f tmp2 tmp1
0
8
2 6 0 15 0 14 -1 0
2 32 0 18 0 14 -1 0
2 18 0 15 0 14 -1 1
2 32 0 6 0 14 -1 1
2 18 0 15 0 23 -1 0
2 32 0 6 0 23 -1 0
2 6 0 15 0 23 -1 1
2 32 0 18 0 23 -1 1
0
end_operator
begin_operator
xor-gate tmp1 tmp2 t
0
8
2 15 0 23 0 3 -1 0
2 32 0 14 0 3 -1 0
2 14 0 15 0 3 -1 1
2 32 0 23 0 3 -1 1
2 14 0 15 0 4 -1 0
2 32 0 23 0 4 -1 0
2 15 0 23 0 4 -1 1
2 32 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 tmp2 f
0
8
2 14 0 15 0 6 -1 0
2 32 0 23 0 6 -1 0
2 15 0 23 0 6 -1 1
2 32 0 14 0 6 -1 1
2 15 0 23 0 18 -1 0
2 32 0 14 0 18 -1 0
2 14 0 15 0 18 -1 1
2 32 0 23 0 18 -1 1
0
end_operator
begin_operator
not-gate tmp2 t
0
4
1 15 0 3 -1 0
1 32 0 3 -1 1
1 32 0 4 -1 0
1 15 0 4 -1 1
0
end_operator
begin_operator
not-gate tmp2 f
0
4
1 32 0 6 -1 0
1 15 0 6 -1 1
1 15 0 18 -1 0
1 32 0 18 -1 1
0
end_operator
begin_operator
not-gate tmp2 tmp1
0
4
1 32 0 14 -1 0
1 15 0 14 -1 1
1 15 0 23 -1 0
1 32 0 23 -1 1
0
end_operator
begin_operator
not-gate t tmp2
0
4
1 3 0 15 -1 0
1 4 0 15 -1 1
1 4 0 32 -1 0
1 3 0 32 -1 1
0
end_operator
begin_operator
not-gate f tmp2
0
4
1 18 0 15 -1 0
1 6 0 15 -1 1
1 6 0 32 -1 0
1 18 0 32 -1 1
0
end_operator
begin_operator
not-gate tmp1 tmp2
0
4
1 23 0 15 -1 0
1 14 0 15 -1 1
1 14 0 32 -1 0
1 23 0 32 -1 1
0
end_operator
begin_operator
and-gate x1 f t
0
6
2 18 0 11 0 3 -1 0
1 6 0 3 -1 1
1 20 0 3 -1 1
1 6 0 4 -1 0
1 20 0 4 -1 0
2 18 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 t
0
6
2 11 0 23 0 3 -1 0
1 14 0 3 -1 1
1 20 0 3 -1 1
1 14 0 4 -1 0
1 20 0 4 -1 0
2 11 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 t
0
6
2 32 0 11 0 3 -1 0
1 15 0 3 -1 1
1 20 0 3 -1 1
1 15 0 4 -1 0
1 20 0 4 -1 0
2 32 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 t f
0
6
1 4 0 6 -1 0
1 20 0 6 -1 0
2 3 0 11 0 6 -1 1
2 3 0 11 0 18 -1 0
1 4 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 f
0
6
1 14 0 6 -1 0
1 20 0 6 -1 0
2 11 0 23 0 6 -1 1
2 11 0 23 0 18 -1 0
1 14 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 f
0
6
1 15 0 6 -1 0
1 20 0 6 -1 0
2 32 0 11 0 6 -1 1
2 32 0 11 0 18 -1 0
1 15 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 t tmp1
0
6
1 4 0 14 -1 0
1 20 0 14 -1 0
2 3 0 11 0 14 -1 1
2 3 0 11 0 23 -1 0
1 4 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 f tmp1
0
6
1 6 0 14 -1 0
1 20 0 14 -1 0
2 18 0 11 0 14 -1 1
2 18 0 11 0 23 -1 0
1 6 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 tmp1
0
6
1 15 0 14 -1 0
1 20 0 14 -1 0
2 32 0 11 0 14 -1 1
2 32 0 11 0 23 -1 0
1 15 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 t tmp2
0
6
1 4 0 15 -1 0
1 20 0 15 -1 0
2 3 0 11 0 15 -1 1
2 3 0 11 0 32 -1 0
1 4 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate x1 f tmp2
0
6
1 6 0 15 -1 0
1 20 0 15 -1 0
2 18 0 11 0 15 -1 1
2 18 0 11 0 32 -1 0
1 6 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 tmp2
0
6
1 14 0 15 -1 0
1 20 0 15 -1 0
2 11 0 23 0 15 -1 1
2 11 0 23 0 32 -1 0
1 14 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate t x1 f
0
6
1 4 0 6 -1 0
1 20 0 6 -1 0
2 11 0 3 0 6 -1 1
2 11 0 3 0 18 -1 0
1 4 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate t x1 tmp1
0
6
1 4 0 14 -1 0
1 20 0 14 -1 0
2 11 0 3 0 14 -1 1
2 11 0 3 0 23 -1 0
1 4 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate t x1 tmp2
0
6
1 4 0 15 -1 0
1 20 0 15 -1 0
2 11 0 3 0 15 -1 1
2 11 0 3 0 32 -1 0
1 4 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate f x1 t
0
6
2 18 0 11 0 3 -1 0
1 6 0 3 -1 1
1 20 0 3 -1 1
1 6 0 4 -1 0
1 20 0 4 -1 0
2 18 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate f x1 tmp1
0
6
1 6 0 14 -1 0
1 20 0 14 -1 0
2 18 0 11 0 14 -1 1
2 18 0 11 0 23 -1 0
1 6 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate f x1 tmp2
0
6
1 6 0 15 -1 0
1 20 0 15 -1 0
2 18 0 11 0 15 -1 1
2 18 0 11 0 32 -1 0
1 6 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 t
0
6
2 11 0 23 0 3 -1 0
1 14 0 3 -1 1
1 20 0 3 -1 1
1 14 0 4 -1 0
1 20 0 4 -1 0
2 11 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 f
0
6
1 14 0 6 -1 0
1 20 0 6 -1 0
2 11 0 23 0 6 -1 1
2 11 0 23 0 18 -1 0
1 14 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 tmp2
0
6
1 14 0 15 -1 0
1 20 0 15 -1 0
2 11 0 23 0 15 -1 1
2 11 0 23 0 32 -1 0
1 14 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 t
0
6
2 32 0 11 0 3 -1 0
1 15 0 3 -1 1
1 20 0 3 -1 1
1 15 0 4 -1 0
1 20 0 4 -1 0
2 32 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 f
0
6
1 15 0 6 -1 0
1 20 0 6 -1 0
2 32 0 11 0 6 -1 1
2 32 0 11 0 18 -1 0
1 15 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 tmp1
0
6
1 15 0 14 -1 0
1 20 0 14 -1 0
2 32 0 11 0 14 -1 1
2 32 0 11 0 23 -1 0
1 15 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 f t
0
6
1 11 0 3 -1 0
1 18 0 3 -1 0
2 20 0 6 0 3 -1 1
2 20 0 6 0 4 -1 0
1 11 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 t
0
6
1 11 0 3 -1 0
1 23 0 3 -1 0
2 20 0 14 0 3 -1 1
2 20 0 14 0 4 -1 0
1 11 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 t
0
6
1 11 0 3 -1 0
1 32 0 3 -1 0
2 20 0 15 0 3 -1 1
2 20 0 15 0 4 -1 0
1 11 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 t f
0
6
2 4 0 20 0 6 -1 0
1 3 0 6 -1 1
1 11 0 6 -1 1
1 3 0 18 -1 0
1 11 0 18 -1 0
2 4 0 20 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 f
0
6
2 20 0 14 0 6 -1 0
1 11 0 6 -1 1
1 23 0 6 -1 1
1 11 0 18 -1 0
1 23 0 18 -1 0
2 20 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 f
0
6
2 20 0 15 0 6 -1 0
1 11 0 6 -1 1
1 32 0 6 -1 1
1 11 0 18 -1 0
1 32 0 18 -1 0
2 20 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 t tmp1
0
6
2 4 0 20 0 14 -1 0
1 3 0 14 -1 1
1 11 0 14 -1 1
1 3 0 23 -1 0
1 11 0 23 -1 0
2 4 0 20 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 f tmp1
0
6
2 20 0 6 0 14 -1 0
1 11 0 14 -1 1
1 18 0 14 -1 1
1 11 0 23 -1 0
1 18 0 23 -1 0
2 20 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 tmp1
0
6
2 20 0 15 0 14 -1 0
1 11 0 14 -1 1
1 32 0 14 -1 1
1 11 0 23 -1 0
1 32 0 23 -1 0
2 20 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 t tmp2
0
6
2 4 0 20 0 15 -1 0
1 3 0 15 -1 1
1 11 0 15 -1 1
1 3 0 32 -1 0
1 11 0 32 -1 0
2 4 0 20 0 32 -1 1
0
end_operator
begin_operator
or-gate x1 f tmp2
0
6
2 20 0 6 0 15 -1 0
1 11 0 15 -1 1
1 18 0 15 -1 1
1 11 0 32 -1 0
1 18 0 32 -1 0
2 20 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 tmp2
0
6
2 20 0 14 0 15 -1 0
1 11 0 15 -1 1
1 23 0 15 -1 1
1 11 0 32 -1 0
1 23 0 32 -1 0
2 20 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate t x1 f
0
6
2 20 0 4 0 6 -1 0
1 3 0 6 -1 1
1 11 0 6 -1 1
1 3 0 18 -1 0
1 11 0 18 -1 0
2 20 0 4 0 18 -1 1
0
end_operator
begin_operator
or-gate t x1 tmp1
0
6
2 20 0 4 0 14 -1 0
1 3 0 14 -1 1
1 11 0 14 -1 1
1 3 0 23 -1 0
1 11 0 23 -1 0
2 20 0 4 0 23 -1 1
0
end_operator
begin_operator
or-gate t x1 tmp2
0
6
2 20 0 4 0 15 -1 0
1 3 0 15 -1 1
1 11 0 15 -1 1
1 3 0 32 -1 0
1 11 0 32 -1 0
2 20 0 4 0 32 -1 1
0
end_operator
begin_operator
or-gate f x1 t
0
6
1 11 0 3 -1 0
1 18 0 3 -1 0
2 20 0 6 0 3 -1 1
2 20 0 6 0 4 -1 0
1 11 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate f x1 tmp1
0
6
2 20 0 6 0 14 -1 0
1 11 0 14 -1 1
1 18 0 14 -1 1
1 11 0 23 -1 0
1 18 0 23 -1 0
2 20 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate f x1 tmp2
0
6
2 20 0 6 0 15 -1 0
1 11 0 15 -1 1
1 18 0 15 -1 1
1 11 0 32 -1 0
1 18 0 32 -1 0
2 20 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 t
0
6
1 11 0 3 -1 0
1 23 0 3 -1 0
2 20 0 14 0 3 -1 1
2 20 0 14 0 4 -1 0
1 11 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 f
0
6
2 20 0 14 0 6 -1 0
1 11 0 6 -1 1
1 23 0 6 -1 1
1 11 0 18 -1 0
1 23 0 18 -1 0
2 20 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 tmp2
0
6
2 20 0 14 0 15 -1 0
1 11 0 15 -1 1
1 23 0 15 -1 1
1 11 0 32 -1 0
1 23 0 32 -1 0
2 20 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 t
0
6
1 11 0 3 -1 0
1 32 0 3 -1 0
2 20 0 15 0 3 -1 1
2 20 0 15 0 4 -1 0
1 11 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 f
0
6
2 20 0 15 0 6 -1 0
1 11 0 6 -1 1
1 32 0 6 -1 1
1 11 0 18 -1 0
1 32 0 18 -1 0
2 20 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 tmp1
0
6
2 20 0 15 0 14 -1 0
1 11 0 14 -1 1
1 32 0 14 -1 1
1 11 0 23 -1 0
1 32 0 23 -1 0
2 20 0 15 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 f t
0
8
2 11 0 6 0 3 -1 0
2 18 0 20 0 3 -1 0
2 18 0 11 0 3 -1 1
2 20 0 6 0 3 -1 1
2 18 0 11 0 4 -1 0
2 20 0 6 0 4 -1 0
2 11 0 6 0 4 -1 1
2 18 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 t
0
8
2 11 0 14 0 3 -1 0
2 20 0 23 0 3 -1 0
2 11 0 23 0 3 -1 1
2 20 0 14 0 3 -1 1
2 11 0 23 0 4 -1 0
2 20 0 14 0 4 -1 0
2 11 0 14 0 4 -1 1
2 20 0 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 t
0
8
2 11 0 15 0 3 -1 0
2 32 0 20 0 3 -1 0
2 20 0 15 0 3 -1 1
2 32 0 11 0 3 -1 1
2 20 0 15 0 4 -1 0
2 32 0 11 0 4 -1 0
2 11 0 15 0 4 -1 1
2 32 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 t f
0
8
2 3 0 11 0 6 -1 0
2 4 0 20 0 6 -1 0
2 3 0 20 0 6 -1 1
2 11 0 4 0 6 -1 1
2 3 0 20 0 18 -1 0
2 11 0 4 0 18 -1 0
2 3 0 11 0 18 -1 1
2 4 0 20 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 f
0
8
2 11 0 23 0 6 -1 0
2 20 0 14 0 6 -1 0
2 11 0 14 0 6 -1 1
2 20 0 23 0 6 -1 1
2 11 0 14 0 18 -1 0
2 20 0 23 0 18 -1 0
2 11 0 23 0 18 -1 1
2 20 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 f
0
8
2 20 0 15 0 6 -1 0
2 32 0 11 0 6 -1 0
2 11 0 15 0 6 -1 1
2 32 0 20 0 6 -1 1
2 11 0 15 0 18 -1 0
2 32 0 20 0 18 -1 0
2 20 0 15 0 18 -1 1
2 32 0 11 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 t tmp1
0
8
2 3 0 11 0 14 -1 0
2 4 0 20 0 14 -1 0
2 3 0 20 0 14 -1 1
2 11 0 4 0 14 -1 1
2 3 0 20 0 23 -1 0
2 11 0 4 0 23 -1 0
2 3 0 11 0 23 -1 1
2 4 0 20 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 f tmp1
0
8
2 18 0 11 0 14 -1 0
2 20 0 6 0 14 -1 0
2 11 0 6 0 14 -1 1
2 18 0 20 0 14 -1 1
2 11 0 6 0 23 -1 0
2 18 0 20 0 23 -1 0
2 18 0 11 0 23 -1 1
2 20 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 tmp1
0
8
2 20 0 15 0 14 -1 0
2 32 0 11 0 14 -1 0
2 11 0 15 0 14 -1 1
2 32 0 20 0 14 -1 1
2 11 0 15 0 23 -1 0
2 32 0 20 0 23 -1 0
2 20 0 15 0 23 -1 1
2 32 0 11 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 t tmp2
0
8
2 3 0 11 0 15 -1 0
2 4 0 20 0 15 -1 0
2 3 0 20 0 15 -1 1
2 11 0 4 0 15 -1 1
2 3 0 20 0 32 -1 0
2 11 0 4 0 32 -1 0
2 3 0 11 0 32 -1 1
2 4 0 20 0 32 -1 1
0
end_operator
begin_operator
xor-gate x1 f tmp2
0
8
2 18 0 11 0 15 -1 0
2 20 0 6 0 15 -1 0
2 11 0 6 0 15 -1 1
2 18 0 20 0 15 -1 1
2 11 0 6 0 32 -1 0
2 18 0 20 0 32 -1 0
2 18 0 11 0 32 -1 1
2 20 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 tmp2
0
8
2 11 0 23 0 15 -1 0
2 20 0 14 0 15 -1 0
2 11 0 14 0 15 -1 1
2 20 0 23 0 15 -1 1
2 11 0 14 0 32 -1 0
2 20 0 23 0 32 -1 0
2 11 0 23 0 32 -1 1
2 20 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate t x1 f
0
8
2 11 0 3 0 6 -1 0
2 20 0 4 0 6 -1 0
2 3 0 20 0 6 -1 1
2 11 0 4 0 6 -1 1
2 3 0 20 0 18 -1 0
2 11 0 4 0 18 -1 0
2 11 0 3 0 18 -1 1
2 20 0 4 0 18 -1 1
0
end_operator
begin_operator
xor-gate t x1 tmp1
0
8
2 11 0 3 0 14 -1 0
2 20 0 4 0 14 -1 0
2 3 0 20 0 14 -1 1
2 11 0 4 0 14 -1 1
2 3 0 20 0 23 -1 0
2 11 0 4 0 23 -1 0
2 11 0 3 0 23 -1 1
2 20 0 4 0 23 -1 1
0
end_operator
begin_operator
xor-gate t x1 tmp2
0
8
2 11 0 3 0 15 -1 0
2 20 0 4 0 15 -1 0
2 3 0 20 0 15 -1 1
2 11 0 4 0 15 -1 1
2 3 0 20 0 32 -1 0
2 11 0 4 0 32 -1 0
2 11 0 3 0 32 -1 1
2 20 0 4 0 32 -1 1
0
end_operator
begin_operator
xor-gate f x1 t
0
8
2 11 0 6 0 3 -1 0
2 18 0 20 0 3 -1 0
2 18 0 11 0 3 -1 1
2 20 0 6 0 3 -1 1
2 18 0 11 0 4 -1 0
2 20 0 6 0 4 -1 0
2 11 0 6 0 4 -1 1
2 18 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate f x1 tmp1
0
8
2 18 0 11 0 14 -1 0
2 20 0 6 0 14 -1 0
2 11 0 6 0 14 -1 1
2 18 0 20 0 14 -1 1
2 11 0 6 0 23 -1 0
2 18 0 20 0 23 -1 0
2 18 0 11 0 23 -1 1
2 20 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate f x1 tmp2
0
8
2 18 0 11 0 15 -1 0
2 20 0 6 0 15 -1 0
2 11 0 6 0 15 -1 1
2 18 0 20 0 15 -1 1
2 11 0 6 0 32 -1 0
2 18 0 20 0 32 -1 0
2 18 0 11 0 32 -1 1
2 20 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 t
0
8
2 11 0 14 0 3 -1 0
2 20 0 23 0 3 -1 0
2 11 0 23 0 3 -1 1
2 20 0 14 0 3 -1 1
2 11 0 23 0 4 -1 0
2 20 0 14 0 4 -1 0
2 11 0 14 0 4 -1 1
2 20 0 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 f
0
8
2 11 0 23 0 6 -1 0
2 20 0 14 0 6 -1 0
2 11 0 14 0 6 -1 1
2 20 0 23 0 6 -1 1
2 11 0 14 0 18 -1 0
2 20 0 23 0 18 -1 0
2 11 0 23 0 18 -1 1
2 20 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 tmp2
0
8
2 11 0 23 0 15 -1 0
2 20 0 14 0 15 -1 0
2 11 0 14 0 15 -1 1
2 20 0 23 0 15 -1 1
2 11 0 14 0 32 -1 0
2 20 0 23 0 32 -1 0
2 11 0 23 0 32 -1 1
2 20 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 t
0
8
2 11 0 15 0 3 -1 0
2 32 0 20 0 3 -1 0
2 20 0 15 0 3 -1 1
2 32 0 11 0 3 -1 1
2 20 0 15 0 4 -1 0
2 32 0 11 0 4 -1 0
2 11 0 15 0 4 -1 1
2 32 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 f
0
8
2 20 0 15 0 6 -1 0
2 32 0 11 0 6 -1 0
2 11 0 15 0 6 -1 1
2 32 0 20 0 6 -1 1
2 11 0 15 0 18 -1 0
2 32 0 20 0 18 -1 0
2 20 0 15 0 18 -1 1
2 32 0 11 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 tmp1
0
8
2 20 0 15 0 14 -1 0
2 32 0 11 0 14 -1 0
2 11 0 15 0 14 -1 1
2 32 0 20 0 14 -1 1
2 11 0 15 0 23 -1 0
2 32 0 20 0 23 -1 0
2 20 0 15 0 23 -1 1
2 32 0 11 0 23 -1 1
0
end_operator
begin_operator
not-gate x1 t
0
4
1 20 0 3 -1 0
1 11 0 3 -1 1
1 11 0 4 -1 0
1 20 0 4 -1 1
0
end_operator
begin_operator
not-gate x1 f
0
4
1 11 0 6 -1 0
1 20 0 6 -1 1
1 20 0 18 -1 0
1 11 0 18 -1 1
0
end_operator
begin_operator
not-gate x1 tmp1
0
4
1 11 0 14 -1 0
1 20 0 14 -1 1
1 20 0 23 -1 0
1 11 0 23 -1 1
0
end_operator
begin_operator
not-gate x1 tmp2
0
4
1 11 0 15 -1 0
1 20 0 15 -1 1
1 20 0 32 -1 0
1 11 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 f t
0
6
2 9 0 18 0 3 -1 0
1 6 0 3 -1 1
1 35 0 3 -1 1
1 6 0 4 -1 0
1 35 0 4 -1 0
2 9 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 t
0
6
2 9 0 23 0 3 -1 0
1 14 0 3 -1 1
1 35 0 3 -1 1
1 14 0 4 -1 0
1 35 0 4 -1 0
2 9 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 t
0
6
2 32 0 9 0 3 -1 0
1 15 0 3 -1 1
1 35 0 3 -1 1
1 15 0 4 -1 0
1 35 0 4 -1 0
2 32 0 9 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 x1 t
0
6
2 9 0 11 0 3 -1 0
1 20 0 3 -1 1
1 35 0 3 -1 1
1 20 0 4 -1 0
1 35 0 4 -1 0
2 9 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 t f
0
6
1 4 0 6 -1 0
1 35 0 6 -1 0
2 9 0 3 0 6 -1 1
2 9 0 3 0 18 -1 0
1 4 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 f
0
6
1 14 0 6 -1 0
1 35 0 6 -1 0
2 9 0 23 0 6 -1 1
2 9 0 23 0 18 -1 0
1 14 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 f
0
6
1 15 0 6 -1 0
1 35 0 6 -1 0
2 32 0 9 0 6 -1 1
2 32 0 9 0 18 -1 0
1 15 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 x1 f
0
6
1 20 0 6 -1 0
1 35 0 6 -1 0
2 9 0 11 0 6 -1 1
2 9 0 11 0 18 -1 0
1 20 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 t tmp1
0
6
1 4 0 14 -1 0
1 35 0 14 -1 0
2 9 0 3 0 14 -1 1
2 9 0 3 0 23 -1 0
1 4 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 f tmp1
0
6
1 6 0 14 -1 0
1 35 0 14 -1 0
2 9 0 18 0 14 -1 1
2 9 0 18 0 23 -1 0
1 6 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 tmp1
0
6
1 15 0 14 -1 0
1 35 0 14 -1 0
2 32 0 9 0 14 -1 1
2 32 0 9 0 23 -1 0
1 15 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 x1 tmp1
0
6
1 20 0 14 -1 0
1 35 0 14 -1 0
2 9 0 11 0 14 -1 1
2 9 0 11 0 23 -1 0
1 20 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 t tmp2
0
6
1 4 0 15 -1 0
1 35 0 15 -1 0
2 9 0 3 0 15 -1 1
2 9 0 3 0 32 -1 0
1 4 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 f tmp2
0
6
1 6 0 15 -1 0
1 35 0 15 -1 0
2 9 0 18 0 15 -1 1
2 9 0 18 0 32 -1 0
1 6 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 tmp2
0
6
1 14 0 15 -1 0
1 35 0 15 -1 0
2 9 0 23 0 15 -1 1
2 9 0 23 0 32 -1 0
1 14 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 x1 tmp2
0
6
1 20 0 15 -1 0
1 35 0 15 -1 0
2 9 0 11 0 15 -1 1
2 9 0 11 0 32 -1 0
1 20 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate t y1 f
0
6
1 4 0 6 -1 0
1 35 0 6 -1 0
2 9 0 3 0 6 -1 1
2 9 0 3 0 18 -1 0
1 4 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate t y1 tmp1
0
6
1 4 0 14 -1 0
1 35 0 14 -1 0
2 9 0 3 0 14 -1 1
2 9 0 3 0 23 -1 0
1 4 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate t y1 tmp2
0
6
1 4 0 15 -1 0
1 35 0 15 -1 0
2 9 0 3 0 15 -1 1
2 9 0 3 0 32 -1 0
1 4 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate f y1 t
0
6
2 9 0 18 0 3 -1 0
1 6 0 3 -1 1
1 35 0 3 -1 1
1 6 0 4 -1 0
1 35 0 4 -1 0
2 9 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate f y1 tmp1
0
6
1 6 0 14 -1 0
1 35 0 14 -1 0
2 9 0 18 0 14 -1 1
2 9 0 18 0 23 -1 0
1 6 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate f y1 tmp2
0
6
1 6 0 15 -1 0
1 35 0 15 -1 0
2 9 0 18 0 15 -1 1
2 9 0 18 0 32 -1 0
1 6 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 t
0
6
2 9 0 23 0 3 -1 0
1 14 0 3 -1 1
1 35 0 3 -1 1
1 14 0 4 -1 0
1 35 0 4 -1 0
2 9 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 f
0
6
1 14 0 6 -1 0
1 35 0 6 -1 0
2 9 0 23 0 6 -1 1
2 9 0 23 0 18 -1 0
1 14 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 tmp2
0
6
1 14 0 15 -1 0
1 35 0 15 -1 0
2 9 0 23 0 15 -1 1
2 9 0 23 0 32 -1 0
1 14 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 t
0
6
2 32 0 9 0 3 -1 0
1 15 0 3 -1 1
1 35 0 3 -1 1
1 15 0 4 -1 0
1 35 0 4 -1 0
2 32 0 9 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 f
0
6
1 15 0 6 -1 0
1 35 0 6 -1 0
2 32 0 9 0 6 -1 1
2 32 0 9 0 18 -1 0
1 15 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 tmp1
0
6
1 15 0 14 -1 0
1 35 0 14 -1 0
2 32 0 9 0 14 -1 1
2 32 0 9 0 23 -1 0
1 15 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 y1 t
0
6
2 9 0 11 0 3 -1 0
1 20 0 3 -1 1
1 35 0 3 -1 1
1 20 0 4 -1 0
1 35 0 4 -1 0
2 9 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 y1 f
0
6
1 20 0 6 -1 0
1 35 0 6 -1 0
2 9 0 11 0 6 -1 1
2 9 0 11 0 18 -1 0
1 20 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 y1 tmp1
0
6
1 20 0 14 -1 0
1 35 0 14 -1 0
2 9 0 11 0 14 -1 1
2 9 0 11 0 23 -1 0
1 20 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 y1 tmp2
0
6
1 20 0 15 -1 0
1 35 0 15 -1 0
2 9 0 11 0 15 -1 1
2 9 0 11 0 32 -1 0
1 20 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 f t
0
6
1 9 0 3 -1 0
1 18 0 3 -1 0
2 35 0 6 0 3 -1 1
2 35 0 6 0 4 -1 0
1 9 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 t
0
6
1 9 0 3 -1 0
1 23 0 3 -1 0
2 35 0 14 0 3 -1 1
2 35 0 14 0 4 -1 0
1 9 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 t
0
6
1 9 0 3 -1 0
1 32 0 3 -1 0
2 35 0 15 0 3 -1 1
2 35 0 15 0 4 -1 0
1 9 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 x1 t
0
6
1 9 0 3 -1 0
1 11 0 3 -1 0
2 35 0 20 0 3 -1 1
2 35 0 20 0 4 -1 0
1 9 0 4 -1 1
1 11 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 t f
0
6
2 35 0 4 0 6 -1 0
1 3 0 6 -1 1
1 9 0 6 -1 1
1 3 0 18 -1 0
1 9 0 18 -1 0
2 35 0 4 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 f
0
6
2 35 0 14 0 6 -1 0
1 9 0 6 -1 1
1 23 0 6 -1 1
1 9 0 18 -1 0
1 23 0 18 -1 0
2 35 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 f
0
6
2 35 0 15 0 6 -1 0
1 9 0 6 -1 1
1 32 0 6 -1 1
1 9 0 18 -1 0
1 32 0 18 -1 0
2 35 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 x1 f
0
6
2 35 0 20 0 6 -1 0
1 9 0 6 -1 1
1 11 0 6 -1 1
1 9 0 18 -1 0
1 11 0 18 -1 0
2 35 0 20 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 t tmp1
0
6
2 35 0 4 0 14 -1 0
1 3 0 14 -1 1
1 9 0 14 -1 1
1 3 0 23 -1 0
1 9 0 23 -1 0
2 35 0 4 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 f tmp1
0
6
2 35 0 6 0 14 -1 0
1 9 0 14 -1 1
1 18 0 14 -1 1
1 9 0 23 -1 0
1 18 0 23 -1 0
2 35 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 tmp1
0
6
2 35 0 15 0 14 -1 0
1 9 0 14 -1 1
1 32 0 14 -1 1
1 9 0 23 -1 0
1 32 0 23 -1 0
2 35 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 x1 tmp1
0
6
2 35 0 20 0 14 -1 0
1 9 0 14 -1 1
1 11 0 14 -1 1
1 9 0 23 -1 0
1 11 0 23 -1 0
2 35 0 20 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 t tmp2
0
6
2 35 0 4 0 15 -1 0
1 3 0 15 -1 1
1 9 0 15 -1 1
1 3 0 32 -1 0
1 9 0 32 -1 0
2 35 0 4 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 f tmp2
0
6
2 35 0 6 0 15 -1 0
1 9 0 15 -1 1
1 18 0 15 -1 1
1 9 0 32 -1 0
1 18 0 32 -1 0
2 35 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 tmp2
0
6
2 35 0 14 0 15 -1 0
1 9 0 15 -1 1
1 23 0 15 -1 1
1 9 0 32 -1 0
1 23 0 32 -1 0
2 35 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 x1 tmp2
0
6
2 35 0 20 0 15 -1 0
1 9 0 15 -1 1
1 11 0 15 -1 1
1 9 0 32 -1 0
1 11 0 32 -1 0
2 35 0 20 0 32 -1 1
0
end_operator
begin_operator
or-gate t y1 f
0
6
2 35 0 4 0 6 -1 0
1 3 0 6 -1 1
1 9 0 6 -1 1
1 3 0 18 -1 0
1 9 0 18 -1 0
2 35 0 4 0 18 -1 1
0
end_operator
begin_operator
or-gate t y1 tmp1
0
6
2 35 0 4 0 14 -1 0
1 3 0 14 -1 1
1 9 0 14 -1 1
1 3 0 23 -1 0
1 9 0 23 -1 0
2 35 0 4 0 23 -1 1
0
end_operator
begin_operator
or-gate t y1 tmp2
0
6
2 35 0 4 0 15 -1 0
1 3 0 15 -1 1
1 9 0 15 -1 1
1 3 0 32 -1 0
1 9 0 32 -1 0
2 35 0 4 0 32 -1 1
0
end_operator
begin_operator
or-gate f y1 t
0
6
1 9 0 3 -1 0
1 18 0 3 -1 0
2 35 0 6 0 3 -1 1
2 35 0 6 0 4 -1 0
1 9 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate f y1 tmp1
0
6
2 35 0 6 0 14 -1 0
1 9 0 14 -1 1
1 18 0 14 -1 1
1 9 0 23 -1 0
1 18 0 23 -1 0
2 35 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate f y1 tmp2
0
6
2 35 0 6 0 15 -1 0
1 9 0 15 -1 1
1 18 0 15 -1 1
1 9 0 32 -1 0
1 18 0 32 -1 0
2 35 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 t
0
6
1 9 0 3 -1 0
1 23 0 3 -1 0
2 35 0 14 0 3 -1 1
2 35 0 14 0 4 -1 0
1 9 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 f
0
6
2 35 0 14 0 6 -1 0
1 9 0 6 -1 1
1 23 0 6 -1 1
1 9 0 18 -1 0
1 23 0 18 -1 0
2 35 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 tmp2
0
6
2 35 0 14 0 15 -1 0
1 9 0 15 -1 1
1 23 0 15 -1 1
1 9 0 32 -1 0
1 23 0 32 -1 0
2 35 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 t
0
6
1 9 0 3 -1 0
1 32 0 3 -1 0
2 35 0 15 0 3 -1 1
2 35 0 15 0 4 -1 0
1 9 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 f
0
6
2 35 0 15 0 6 -1 0
1 9 0 6 -1 1
1 32 0 6 -1 1
1 9 0 18 -1 0
1 32 0 18 -1 0
2 35 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 tmp1
0
6
2 35 0 15 0 14 -1 0
1 9 0 14 -1 1
1 32 0 14 -1 1
1 9 0 23 -1 0
1 32 0 23 -1 0
2 35 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 y1 t
0
6
1 9 0 3 -1 0
1 11 0 3 -1 0
2 35 0 20 0 3 -1 1
2 35 0 20 0 4 -1 0
1 9 0 4 -1 1
1 11 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 y1 f
0
6
2 35 0 20 0 6 -1 0
1 9 0 6 -1 1
1 11 0 6 -1 1
1 9 0 18 -1 0
1 11 0 18 -1 0
2 35 0 20 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 y1 tmp1
0
6
2 35 0 20 0 14 -1 0
1 9 0 14 -1 1
1 11 0 14 -1 1
1 9 0 23 -1 0
1 11 0 23 -1 0
2 35 0 20 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 y1 tmp2
0
6
2 35 0 20 0 15 -1 0
1 9 0 15 -1 1
1 11 0 15 -1 1
1 9 0 32 -1 0
1 11 0 32 -1 0
2 35 0 20 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 f t
0
8
2 9 0 6 0 3 -1 0
2 18 0 35 0 3 -1 0
2 9 0 18 0 3 -1 1
2 35 0 6 0 3 -1 1
2 9 0 18 0 4 -1 0
2 35 0 6 0 4 -1 0
2 9 0 6 0 4 -1 1
2 18 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 t
0
8
2 9 0 14 0 3 -1 0
2 35 0 23 0 3 -1 0
2 9 0 23 0 3 -1 1
2 35 0 14 0 3 -1 1
2 9 0 23 0 4 -1 0
2 35 0 14 0 4 -1 0
2 9 0 14 0 4 -1 1
2 35 0 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 t
0
8
2 9 0 15 0 3 -1 0
2 32 0 35 0 3 -1 0
2 32 0 9 0 3 -1 1
2 35 0 15 0 3 -1 1
2 32 0 9 0 4 -1 0
2 35 0 15 0 4 -1 0
2 9 0 15 0 4 -1 1
2 32 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 t
0
8
2 9 0 20 0 3 -1 0
2 11 0 35 0 3 -1 0
2 9 0 11 0 3 -1 1
2 35 0 20 0 3 -1 1
2 9 0 11 0 4 -1 0
2 35 0 20 0 4 -1 0
2 9 0 20 0 4 -1 1
2 11 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 t f
0
8
2 9 0 3 0 6 -1 0
2 35 0 4 0 6 -1 0
2 3 0 35 0 6 -1 1
2 9 0 4 0 6 -1 1
2 3 0 35 0 18 -1 0
2 9 0 4 0 18 -1 0
2 9 0 3 0 18 -1 1
2 35 0 4 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 f
0
8
2 9 0 23 0 6 -1 0
2 35 0 14 0 6 -1 0
2 9 0 14 0 6 -1 1
2 35 0 23 0 6 -1 1
2 9 0 14 0 18 -1 0
2 35 0 23 0 18 -1 0
2 9 0 23 0 18 -1 1
2 35 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 f
0
8
2 32 0 9 0 6 -1 0
2 35 0 15 0 6 -1 0
2 9 0 15 0 6 -1 1
2 32 0 35 0 6 -1 1
2 9 0 15 0 18 -1 0
2 32 0 35 0 18 -1 0
2 32 0 9 0 18 -1 1
2 35 0 15 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 f
0
8
2 9 0 11 0 6 -1 0
2 35 0 20 0 6 -1 0
2 9 0 20 0 6 -1 1
2 11 0 35 0 6 -1 1
2 9 0 20 0 18 -1 0
2 11 0 35 0 18 -1 0
2 9 0 11 0 18 -1 1
2 35 0 20 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 t tmp1
0
8
2 9 0 3 0 14 -1 0
2 35 0 4 0 14 -1 0
2 3 0 35 0 14 -1 1
2 9 0 4 0 14 -1 1
2 3 0 35 0 23 -1 0
2 9 0 4 0 23 -1 0
2 9 0 3 0 23 -1 1
2 35 0 4 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 f tmp1
0
8
2 9 0 18 0 14 -1 0
2 35 0 6 0 14 -1 0
2 9 0 6 0 14 -1 1
2 18 0 35 0 14 -1 1
2 9 0 6 0 23 -1 0
2 18 0 35 0 23 -1 0
2 9 0 18 0 23 -1 1
2 35 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 tmp1
0
8
2 32 0 9 0 14 -1 0
2 35 0 15 0 14 -1 0
2 9 0 15 0 14 -1 1
2 32 0 35 0 14 -1 1
2 9 0 15 0 23 -1 0
2 32 0 35 0 23 -1 0
2 32 0 9 0 23 -1 1
2 35 0 15 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 tmp1
0
8
2 9 0 11 0 14 -1 0
2 35 0 20 0 14 -1 0
2 9 0 20 0 14 -1 1
2 11 0 35 0 14 -1 1
2 9 0 20 0 23 -1 0
2 11 0 35 0 23 -1 0
2 9 0 11 0 23 -1 1
2 35 0 20 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 t tmp2
0
8
2 9 0 3 0 15 -1 0
2 35 0 4 0 15 -1 0
2 3 0 35 0 15 -1 1
2 9 0 4 0 15 -1 1
2 3 0 35 0 32 -1 0
2 9 0 4 0 32 -1 0
2 9 0 3 0 32 -1 1
2 35 0 4 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 f tmp2
0
8
2 9 0 18 0 15 -1 0
2 35 0 6 0 15 -1 0
2 9 0 6 0 15 -1 1
2 18 0 35 0 15 -1 1
2 9 0 6 0 32 -1 0
2 18 0 35 0 32 -1 0
2 9 0 18 0 32 -1 1
2 35 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 tmp2
0
8
2 9 0 23 0 15 -1 0
2 35 0 14 0 15 -1 0
2 9 0 14 0 15 -1 1
2 35 0 23 0 15 -1 1
2 9 0 14 0 32 -1 0
2 35 0 23 0 32 -1 0
2 9 0 23 0 32 -1 1
2 35 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 tmp2
0
8
2 9 0 11 0 15 -1 0
2 35 0 20 0 15 -1 0
2 9 0 20 0 15 -1 1
2 11 0 35 0 15 -1 1
2 9 0 20 0 32 -1 0
2 11 0 35 0 32 -1 0
2 9 0 11 0 32 -1 1
2 35 0 20 0 32 -1 1
0
end_operator
begin_operator
xor-gate t y1 f
0
8
2 9 0 3 0 6 -1 0
2 35 0 4 0 6 -1 0
2 9 0 4 0 6 -1 1
2 35 0 3 0 6 -1 1
2 9 0 4 0 18 -1 0
2 35 0 3 0 18 -1 0
2 9 0 3 0 18 -1 1
2 35 0 4 0 18 -1 1
0
end_operator
begin_operator
xor-gate t y1 tmp1
0
8
2 9 0 3 0 14 -1 0
2 35 0 4 0 14 -1 0
2 9 0 4 0 14 -1 1
2 35 0 3 0 14 -1 1
2 9 0 4 0 23 -1 0
2 35 0 3 0 23 -1 0
2 9 0 3 0 23 -1 1
2 35 0 4 0 23 -1 1
0
end_operator
begin_operator
xor-gate t y1 tmp2
0
8
2 9 0 3 0 15 -1 0
2 35 0 4 0 15 -1 0
2 9 0 4 0 15 -1 1
2 35 0 3 0 15 -1 1
2 9 0 4 0 32 -1 0
2 35 0 3 0 32 -1 0
2 9 0 3 0 32 -1 1
2 35 0 4 0 32 -1 1
0
end_operator
begin_operator
xor-gate f y1 t
0
8
2 9 0 6 0 3 -1 0
2 18 0 35 0 3 -1 0
2 9 0 18 0 3 -1 1
2 35 0 6 0 3 -1 1
2 9 0 18 0 4 -1 0
2 35 0 6 0 4 -1 0
2 9 0 6 0 4 -1 1
2 18 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate f y1 tmp1
0
8
2 9 0 18 0 14 -1 0
2 35 0 6 0 14 -1 0
2 9 0 6 0 14 -1 1
2 18 0 35 0 14 -1 1
2 9 0 6 0 23 -1 0
2 18 0 35 0 23 -1 0
2 9 0 18 0 23 -1 1
2 35 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate f y1 tmp2
0
8
2 9 0 18 0 15 -1 0
2 35 0 6 0 15 -1 0
2 9 0 6 0 15 -1 1
2 18 0 35 0 15 -1 1
2 9 0 6 0 32 -1 0
2 18 0 35 0 32 -1 0
2 9 0 18 0 32 -1 1
2 35 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 t
0
8
2 9 0 14 0 3 -1 0
2 35 0 23 0 3 -1 0
2 9 0 23 0 3 -1 1
2 35 0 14 0 3 -1 1
2 9 0 23 0 4 -1 0
2 35 0 14 0 4 -1 0
2 9 0 14 0 4 -1 1
2 35 0 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 f
0
8
2 9 0 23 0 6 -1 0
2 35 0 14 0 6 -1 0
2 9 0 14 0 6 -1 1
2 35 0 23 0 6 -1 1
2 9 0 14 0 18 -1 0
2 35 0 23 0 18 -1 0
2 9 0 23 0 18 -1 1
2 35 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 tmp2
0
8
2 9 0 23 0 15 -1 0
2 35 0 14 0 15 -1 0
2 9 0 14 0 15 -1 1
2 35 0 23 0 15 -1 1
2 9 0 14 0 32 -1 0
2 35 0 23 0 32 -1 0
2 9 0 23 0 32 -1 1
2 35 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 t
0
8
2 9 0 15 0 3 -1 0
2 32 0 35 0 3 -1 0
2 32 0 9 0 3 -1 1
2 35 0 15 0 3 -1 1
2 32 0 9 0 4 -1 0
2 35 0 15 0 4 -1 0
2 9 0 15 0 4 -1 1
2 32 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 f
0
8
2 32 0 9 0 6 -1 0
2 35 0 15 0 6 -1 0
2 9 0 15 0 6 -1 1
2 32 0 35 0 6 -1 1
2 9 0 15 0 18 -1 0
2 32 0 35 0 18 -1 0
2 32 0 9 0 18 -1 1
2 35 0 15 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 tmp1
0
8
2 32 0 9 0 14 -1 0
2 35 0 15 0 14 -1 0
2 9 0 15 0 14 -1 1
2 32 0 35 0 14 -1 1
2 9 0 15 0 23 -1 0
2 32 0 35 0 23 -1 0
2 32 0 9 0 23 -1 1
2 35 0 15 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 t
0
8
2 9 0 20 0 3 -1 0
2 35 0 11 0 3 -1 0
2 9 0 11 0 3 -1 1
2 35 0 20 0 3 -1 1
2 9 0 11 0 4 -1 0
2 35 0 20 0 4 -1 0
2 9 0 20 0 4 -1 1
2 35 0 11 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 f
0
8
2 9 0 11 0 6 -1 0
2 35 0 20 0 6 -1 0
2 9 0 20 0 6 -1 1
2 35 0 11 0 6 -1 1
2 9 0 20 0 18 -1 0
2 35 0 11 0 18 -1 0
2 9 0 11 0 18 -1 1
2 35 0 20 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 tmp1
0
8
2 9 0 11 0 14 -1 0
2 35 0 20 0 14 -1 0
2 9 0 20 0 14 -1 1
2 35 0 11 0 14 -1 1
2 9 0 20 0 23 -1 0
2 35 0 11 0 23 -1 0
2 9 0 11 0 23 -1 1
2 35 0 20 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 tmp2
0
8
2 9 0 11 0 15 -1 0
2 35 0 20 0 15 -1 0
2 9 0 20 0 15 -1 1
2 35 0 11 0 15 -1 1
2 9 0 20 0 32 -1 0
2 35 0 11 0 32 -1 0
2 9 0 11 0 32 -1 1
2 35 0 20 0 32 -1 1
0
end_operator
begin_operator
not-gate y1 t
0
4
1 35 0 3 -1 0
1 9 0 3 -1 1
1 9 0 4 -1 0
1 35 0 4 -1 1
0
end_operator
begin_operator
not-gate y1 f
0
4
1 9 0 6 -1 0
1 35 0 6 -1 1
1 35 0 18 -1 0
1 9 0 18 -1 1
0
end_operator
begin_operator
not-gate y1 tmp1
0
4
1 9 0 14 -1 0
1 35 0 14 -1 1
1 35 0 23 -1 0
1 9 0 23 -1 1
0
end_operator
begin_operator
not-gate y1 tmp2
0
4
1 9 0 15 -1 0
1 35 0 15 -1 1
1 35 0 32 -1 0
1 9 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 f t
0
6
2 18 0 27 0 3 -1 0
1 6 0 3 -1 1
1 19 0 3 -1 1
1 6 0 4 -1 0
1 19 0 4 -1 0
2 18 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 tmp1 t
0
6
2 27 0 23 0 3 -1 0
1 14 0 3 -1 1
1 19 0 3 -1 1
1 14 0 4 -1 0
1 19 0 4 -1 0
2 27 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 tmp2 t
0
6
2 32 0 27 0 3 -1 0
1 15 0 3 -1 1
1 19 0 3 -1 1
1 15 0 4 -1 0
1 19 0 4 -1 0
2 32 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 x1 t
0
6
2 11 0 27 0 3 -1 0
1 19 0 3 -1 1
1 20 0 3 -1 1
1 19 0 4 -1 0
1 20 0 4 -1 0
2 11 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 y1 t
0
6
2 9 0 27 0 3 -1 0
1 19 0 3 -1 1
1 35 0 3 -1 1
1 19 0 4 -1 0
1 35 0 4 -1 0
2 9 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 t f
0
6
1 4 0 6 -1 0
1 19 0 6 -1 0
2 3 0 27 0 6 -1 1
2 3 0 27 0 18 -1 0
1 4 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 tmp1 f
0
6
1 14 0 6 -1 0
1 19 0 6 -1 0
2 27 0 23 0 6 -1 1
2 27 0 23 0 18 -1 0
1 14 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 tmp2 f
0
6
1 15 0 6 -1 0
1 19 0 6 -1 0
2 32 0 27 0 6 -1 1
2 32 0 27 0 18 -1 0
1 15 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 x1 f
0
6
1 19 0 6 -1 0
1 20 0 6 -1 0
2 11 0 27 0 6 -1 1
2 11 0 27 0 18 -1 0
1 19 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 y1 f
0
6
1 19 0 6 -1 0
1 35 0 6 -1 0
2 9 0 27 0 6 -1 1
2 9 0 27 0 18 -1 0
1 19 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 t tmp1
0
6
1 4 0 14 -1 0
1 19 0 14 -1 0
2 3 0 27 0 14 -1 1
2 3 0 27 0 23 -1 0
1 4 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 f tmp1
0
6
1 6 0 14 -1 0
1 19 0 14 -1 0
2 18 0 27 0 14 -1 1
2 18 0 27 0 23 -1 0
1 6 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 tmp2 tmp1
0
6
1 15 0 14 -1 0
1 19 0 14 -1 0
2 32 0 27 0 14 -1 1
2 32 0 27 0 23 -1 0
1 15 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 x1 tmp1
0
6
1 19 0 14 -1 0
1 20 0 14 -1 0
2 11 0 27 0 14 -1 1
2 11 0 27 0 23 -1 0
1 19 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 y1 tmp1
0
6
1 19 0 14 -1 0
1 35 0 14 -1 0
2 9 0 27 0 14 -1 1
2 9 0 27 0 23 -1 0
1 19 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 t tmp2
0
6
1 4 0 15 -1 0
1 19 0 15 -1 0
2 3 0 27 0 15 -1 1
2 3 0 27 0 32 -1 0
1 4 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 f tmp2
0
6
1 6 0 15 -1 0
1 19 0 15 -1 0
2 18 0 27 0 15 -1 1
2 18 0 27 0 32 -1 0
1 6 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 tmp1 tmp2
0
6
1 14 0 15 -1 0
1 19 0 15 -1 0
2 27 0 23 0 15 -1 1
2 27 0 23 0 32 -1 0
1 14 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 x1 tmp2
0
6
1 19 0 15 -1 0
1 20 0 15 -1 0
2 11 0 27 0 15 -1 1
2 11 0 27 0 32 -1 0
1 19 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 y1 tmp2
0
6
1 19 0 15 -1 0
1 35 0 15 -1 0
2 9 0 27 0 15 -1 1
2 9 0 27 0 32 -1 0
1 19 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate t f r1
0
6
1 4 0 19 -1 0
1 6 0 19 -1 0
2 18 0 3 0 19 -1 1
2 18 0 3 0 27 -1 0
1 4 0 27 -1 1
1 6 0 27 -1 1
0
end_operator
begin_operator
and-gate t tmp1 r1
0
6
1 4 0 19 -1 0
1 14 0 19 -1 0
2 3 0 23 0 19 -1 1
2 3 0 23 0 27 -1 0
1 4 0 27 -1 1
1 14 0 27 -1 1
0
end_operator
begin_operator
and-gate t tmp2 r1
0
6
1 4 0 19 -1 0
1 15 0 19 -1 0
2 32 0 3 0 19 -1 1
2 32 0 3 0 27 -1 0
1 4 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate t x1 r1
0
6
1 4 0 19 -1 0
1 20 0 19 -1 0
2 11 0 3 0 19 -1 1
2 11 0 3 0 27 -1 0
1 4 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate t y1 r1
0
6
1 4 0 19 -1 0
1 35 0 19 -1 0
2 9 0 3 0 19 -1 1
2 9 0 3 0 27 -1 0
1 4 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate f t r1
0
6
1 4 0 19 -1 0
1 6 0 19 -1 0
2 18 0 3 0 19 -1 1
2 18 0 3 0 27 -1 0
1 4 0 27 -1 1
1 6 0 27 -1 1
0
end_operator
begin_operator
and-gate f tmp1 r1
0
6
1 6 0 19 -1 0
1 14 0 19 -1 0
2 18 0 23 0 19 -1 1
2 18 0 23 0 27 -1 0
1 6 0 27 -1 1
1 14 0 27 -1 1
0
end_operator
begin_operator
and-gate f tmp2 r1
0
6
1 6 0 19 -1 0
1 15 0 19 -1 0
2 32 0 18 0 19 -1 1
2 32 0 18 0 27 -1 0
1 6 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate f x1 r1
0
6
1 6 0 19 -1 0
1 20 0 19 -1 0
2 18 0 11 0 19 -1 1
2 18 0 11 0 27 -1 0
1 6 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate f y1 r1
0
6
1 6 0 19 -1 0
1 35 0 19 -1 0
2 9 0 18 0 19 -1 1
2 9 0 18 0 27 -1 0
1 6 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 t r1
0
6
1 4 0 19 -1 0
1 14 0 19 -1 0
2 3 0 23 0 19 -1 1
2 3 0 23 0 27 -1 0
1 4 0 27 -1 1
1 14 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 f r1
0
6
1 6 0 19 -1 0
1 14 0 19 -1 0
2 18 0 23 0 19 -1 1
2 18 0 23 0 27 -1 0
1 6 0 27 -1 1
1 14 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 tmp2 r1
0
6
1 14 0 19 -1 0
1 15 0 19 -1 0
2 32 0 23 0 19 -1 1
2 32 0 23 0 27 -1 0
1 14 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 r1
0
6
1 14 0 19 -1 0
1 20 0 19 -1 0
2 11 0 23 0 19 -1 1
2 11 0 23 0 27 -1 0
1 14 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 r1
0
6
1 14 0 19 -1 0
1 35 0 19 -1 0
2 9 0 23 0 19 -1 1
2 9 0 23 0 27 -1 0
1 14 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 t r1
0
6
1 4 0 19 -1 0
1 15 0 19 -1 0
2 32 0 3 0 19 -1 1
2 32 0 3 0 27 -1 0
1 4 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 f r1
0
6
1 6 0 19 -1 0
1 15 0 19 -1 0
2 32 0 18 0 19 -1 1
2 32 0 18 0 27 -1 0
1 6 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 tmp1 r1
0
6
1 14 0 19 -1 0
1 15 0 19 -1 0
2 32 0 23 0 19 -1 1
2 32 0 23 0 27 -1 0
1 14 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 r1
0
6
1 15 0 19 -1 0
1 20 0 19 -1 0
2 32 0 11 0 19 -1 1
2 32 0 11 0 27 -1 0
1 15 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 r1
0
6
1 15 0 19 -1 0
1 35 0 19 -1 0
2 32 0 9 0 19 -1 1
2 32 0 9 0 27 -1 0
1 15 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 t r1
0
6
1 4 0 19 -1 0
1 20 0 19 -1 0
2 3 0 11 0 19 -1 1
2 3 0 11 0 27 -1 0
1 4 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 f r1
0
6
1 6 0 19 -1 0
1 20 0 19 -1 0
2 18 0 11 0 19 -1 1
2 18 0 11 0 27 -1 0
1 6 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 r1
0
6
1 14 0 19 -1 0
1 20 0 19 -1 0
2 11 0 23 0 19 -1 1
2 11 0 23 0 27 -1 0
1 14 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 r1
0
6
1 15 0 19 -1 0
1 20 0 19 -1 0
2 32 0 11 0 19 -1 1
2 32 0 11 0 27 -1 0
1 15 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 y1 r1
0
6
1 20 0 19 -1 0
1 35 0 19 -1 0
2 9 0 11 0 19 -1 1
2 9 0 11 0 27 -1 0
1 20 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 t r1
0
6
1 4 0 19 -1 0
1 35 0 19 -1 0
2 9 0 3 0 19 -1 1
2 9 0 3 0 27 -1 0
1 4 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 f r1
0
6
1 6 0 19 -1 0
1 35 0 19 -1 0
2 9 0 18 0 19 -1 1
2 9 0 18 0 27 -1 0
1 6 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 r1
0
6
1 14 0 19 -1 0
1 35 0 19 -1 0
2 9 0 23 0 19 -1 1
2 9 0 23 0 27 -1 0
1 14 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 r1
0
6
1 15 0 19 -1 0
1 35 0 19 -1 0
2 32 0 9 0 19 -1 1
2 32 0 9 0 27 -1 0
1 15 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 x1 r1
0
6
1 20 0 19 -1 0
1 35 0 19 -1 0
2 9 0 11 0 19 -1 1
2 9 0 11 0 27 -1 0
1 20 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate t r1 f
0
6
1 4 0 6 -1 0
1 19 0 6 -1 0
2 27 0 3 0 6 -1 1
2 27 0 3 0 18 -1 0
1 4 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate t r1 tmp1
0
6
1 4 0 14 -1 0
1 19 0 14 -1 0
2 27 0 3 0 14 -1 1
2 27 0 3 0 23 -1 0
1 4 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate t r1 tmp2
0
6
1 4 0 15 -1 0
1 19 0 15 -1 0
2 27 0 3 0 15 -1 1
2 27 0 3 0 32 -1 0
1 4 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate f r1 t
0
6
2 18 0 27 0 3 -1 0
1 6 0 3 -1 1
1 19 0 3 -1 1
1 6 0 4 -1 0
1 19 0 4 -1 0
2 18 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate f r1 tmp1
0
6
1 6 0 14 -1 0
1 19 0 14 -1 0
2 18 0 27 0 14 -1 1
2 18 0 27 0 23 -1 0
1 6 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate f r1 tmp2
0
6
1 6 0 15 -1 0
1 19 0 15 -1 0
2 18 0 27 0 15 -1 1
2 18 0 27 0 32 -1 0
1 6 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 r1 t
0
6
2 27 0 23 0 3 -1 0
1 14 0 3 -1 1
1 19 0 3 -1 1
1 14 0 4 -1 0
1 19 0 4 -1 0
2 27 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 r1 f
0
6
1 14 0 6 -1 0
1 19 0 6 -1 0
2 27 0 23 0 6 -1 1
2 27 0 23 0 18 -1 0
1 14 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 r1 tmp2
0
6
1 14 0 15 -1 0
1 19 0 15 -1 0
2 27 0 23 0 15 -1 1
2 27 0 23 0 32 -1 0
1 14 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp2 r1 t
0
6
2 32 0 27 0 3 -1 0
1 15 0 3 -1 1
1 19 0 3 -1 1
1 15 0 4 -1 0
1 19 0 4 -1 0
2 32 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 r1 f
0
6
1 15 0 6 -1 0
1 19 0 6 -1 0
2 32 0 27 0 6 -1 1
2 32 0 27 0 18 -1 0
1 15 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 r1 tmp1
0
6
1 15 0 14 -1 0
1 19 0 14 -1 0
2 32 0 27 0 14 -1 1
2 32 0 27 0 23 -1 0
1 15 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 r1 t
0
6
2 27 0 11 0 3 -1 0
1 19 0 3 -1 1
1 20 0 3 -1 1
1 19 0 4 -1 0
1 20 0 4 -1 0
2 27 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 r1 f
0
6
1 19 0 6 -1 0
1 20 0 6 -1 0
2 27 0 11 0 6 -1 1
2 27 0 11 0 18 -1 0
1 19 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 r1 tmp1
0
6
1 19 0 14 -1 0
1 20 0 14 -1 0
2 27 0 11 0 14 -1 1
2 27 0 11 0 23 -1 0
1 19 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 r1 tmp2
0
6
1 19 0 15 -1 0
1 20 0 15 -1 0
2 27 0 11 0 15 -1 1
2 27 0 11 0 32 -1 0
1 19 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 r1 t
0
6
2 9 0 27 0 3 -1 0
1 19 0 3 -1 1
1 35 0 3 -1 1
1 19 0 4 -1 0
1 35 0 4 -1 0
2 9 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 r1 f
0
6
1 19 0 6 -1 0
1 35 0 6 -1 0
2 9 0 27 0 6 -1 1
2 9 0 27 0 18 -1 0
1 19 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 r1 tmp1
0
6
1 19 0 14 -1 0
1 35 0 14 -1 0
2 9 0 27 0 14 -1 1
2 9 0 27 0 23 -1 0
1 19 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 r1 tmp2
0
6
1 19 0 15 -1 0
1 35 0 15 -1 0
2 9 0 27 0 15 -1 1
2 9 0 27 0 32 -1 0
1 19 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 f t
0
6
1 18 0 3 -1 0
1 27 0 3 -1 0
2 19 0 6 0 3 -1 1
2 19 0 6 0 4 -1 0
1 18 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 tmp1 t
0
6
1 23 0 3 -1 0
1 27 0 3 -1 0
2 19 0 14 0 3 -1 1
2 19 0 14 0 4 -1 0
1 23 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 tmp2 t
0
6
1 27 0 3 -1 0
1 32 0 3 -1 0
2 19 0 15 0 3 -1 1
2 19 0 15 0 4 -1 0
1 27 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 x1 t
0
6
1 11 0 3 -1 0
1 27 0 3 -1 0
2 19 0 20 0 3 -1 1
2 19 0 20 0 4 -1 0
1 11 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 y1 t
0
6
1 9 0 3 -1 0
1 27 0 3 -1 0
2 35 0 19 0 3 -1 1
2 35 0 19 0 4 -1 0
1 9 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 t f
0
6
2 19 0 4 0 6 -1 0
1 3 0 6 -1 1
1 27 0 6 -1 1
1 3 0 18 -1 0
1 27 0 18 -1 0
2 19 0 4 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 tmp1 f
0
6
2 19 0 14 0 6 -1 0
1 23 0 6 -1 1
1 27 0 6 -1 1
1 23 0 18 -1 0
1 27 0 18 -1 0
2 19 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 tmp2 f
0
6
2 19 0 15 0 6 -1 0
1 27 0 6 -1 1
1 32 0 6 -1 1
1 27 0 18 -1 0
1 32 0 18 -1 0
2 19 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 x1 f
0
6
2 19 0 20 0 6 -1 0
1 11 0 6 -1 1
1 27 0 6 -1 1
1 11 0 18 -1 0
1 27 0 18 -1 0
2 19 0 20 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 y1 f
0
6
2 35 0 19 0 6 -1 0
1 9 0 6 -1 1
1 27 0 6 -1 1
1 9 0 18 -1 0
1 27 0 18 -1 0
2 35 0 19 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 t tmp1
0
6
2 19 0 4 0 14 -1 0
1 3 0 14 -1 1
1 27 0 14 -1 1
1 3 0 23 -1 0
1 27 0 23 -1 0
2 19 0 4 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 f tmp1
0
6
2 19 0 6 0 14 -1 0
1 18 0 14 -1 1
1 27 0 14 -1 1
1 18 0 23 -1 0
1 27 0 23 -1 0
2 19 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 tmp2 tmp1
0
6
2 19 0 15 0 14 -1 0
1 27 0 14 -1 1
1 32 0 14 -1 1
1 27 0 23 -1 0
1 32 0 23 -1 0
2 19 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 x1 tmp1
0
6
2 19 0 20 0 14 -1 0
1 11 0 14 -1 1
1 27 0 14 -1 1
1 11 0 23 -1 0
1 27 0 23 -1 0
2 19 0 20 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 y1 tmp1
0
6
2 35 0 19 0 14 -1 0
1 9 0 14 -1 1
1 27 0 14 -1 1
1 9 0 23 -1 0
1 27 0 23 -1 0
2 35 0 19 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 t tmp2
0
6
2 19 0 4 0 15 -1 0
1 3 0 15 -1 1
1 27 0 15 -1 1
1 3 0 32 -1 0
1 27 0 32 -1 0
2 19 0 4 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 f tmp2
0
6
2 19 0 6 0 15 -1 0
1 18 0 15 -1 1
1 27 0 15 -1 1
1 18 0 32 -1 0
1 27 0 32 -1 0
2 19 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 tmp1 tmp2
0
6
2 19 0 14 0 15 -1 0
1 23 0 15 -1 1
1 27 0 15 -1 1
1 23 0 32 -1 0
1 27 0 32 -1 0
2 19 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 x1 tmp2
0
6
2 19 0 20 0 15 -1 0
1 11 0 15 -1 1
1 27 0 15 -1 1
1 11 0 32 -1 0
1 27 0 32 -1 0
2 19 0 20 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 y1 tmp2
0
6
2 35 0 19 0 15 -1 0
1 9 0 15 -1 1
1 27 0 15 -1 1
1 9 0 32 -1 0
1 27 0 32 -1 0
2 35 0 19 0 32 -1 1
0
end_operator
begin_operator
or-gate t f r1
0
6
2 4 0 6 0 19 -1 0
1 3 0 19 -1 1
1 18 0 19 -1 1
1 3 0 27 -1 0
1 18 0 27 -1 0
2 4 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate t tmp1 r1
0
6
2 4 0 14 0 19 -1 0
1 3 0 19 -1 1
1 23 0 19 -1 1
1 3 0 27 -1 0
1 23 0 27 -1 0
2 4 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate t tmp2 r1
0
6
2 4 0 15 0 19 -1 0
1 3 0 19 -1 1
1 32 0 19 -1 1
1 3 0 27 -1 0
1 32 0 27 -1 0
2 4 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate t x1 r1
0
6
2 20 0 4 0 19 -1 0
1 3 0 19 -1 1
1 11 0 19 -1 1
1 3 0 27 -1 0
1 11 0 27 -1 0
2 20 0 4 0 27 -1 1
0
end_operator
begin_operator
or-gate t y1 r1
0
6
2 35 0 4 0 19 -1 0
1 3 0 19 -1 1
1 9 0 19 -1 1
1 3 0 27 -1 0
1 9 0 27 -1 0
2 35 0 4 0 27 -1 1
0
end_operator
begin_operator
or-gate f t r1
0
6
2 4 0 6 0 19 -1 0
1 3 0 19 -1 1
1 18 0 19 -1 1
1 3 0 27 -1 0
1 18 0 27 -1 0
2 4 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate f tmp1 r1
0
6
2 14 0 6 0 19 -1 0
1 18 0 19 -1 1
1 23 0 19 -1 1
1 18 0 27 -1 0
1 23 0 27 -1 0
2 14 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate f tmp2 r1
0
6
2 6 0 15 0 19 -1 0
1 18 0 19 -1 1
1 32 0 19 -1 1
1 18 0 27 -1 0
1 32 0 27 -1 0
2 6 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate f x1 r1
0
6
2 20 0 6 0 19 -1 0
1 11 0 19 -1 1
1 18 0 19 -1 1
1 11 0 27 -1 0
1 18 0 27 -1 0
2 20 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate f y1 r1
0
6
2 35 0 6 0 19 -1 0
1 9 0 19 -1 1
1 18 0 19 -1 1
1 9 0 27 -1 0
1 18 0 27 -1 0
2 35 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 t r1
0
6
2 4 0 14 0 19 -1 0
1 3 0 19 -1 1
1 23 0 19 -1 1
1 3 0 27 -1 0
1 23 0 27 -1 0
2 4 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 f r1
0
6
2 6 0 14 0 19 -1 0
1 18 0 19 -1 1
1 23 0 19 -1 1
1 18 0 27 -1 0
1 23 0 27 -1 0
2 6 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 tmp2 r1
0
6
2 14 0 15 0 19 -1 0
1 23 0 19 -1 1
1 32 0 19 -1 1
1 23 0 27 -1 0
1 32 0 27 -1 0
2 14 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 r1
0
6
2 20 0 14 0 19 -1 0
1 11 0 19 -1 1
1 23 0 19 -1 1
1 11 0 27 -1 0
1 23 0 27 -1 0
2 20 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 r1
0
6
2 35 0 14 0 19 -1 0
1 9 0 19 -1 1
1 23 0 19 -1 1
1 9 0 27 -1 0
1 23 0 27 -1 0
2 35 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 t r1
0
6
2 4 0 15 0 19 -1 0
1 3 0 19 -1 1
1 32 0 19 -1 1
1 3 0 27 -1 0
1 32 0 27 -1 0
2 4 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 f r1
0
6
2 6 0 15 0 19 -1 0
1 18 0 19 -1 1
1 32 0 19 -1 1
1 18 0 27 -1 0
1 32 0 27 -1 0
2 6 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 tmp1 r1
0
6
2 14 0 15 0 19 -1 0
1 23 0 19 -1 1
1 32 0 19 -1 1
1 23 0 27 -1 0
1 32 0 27 -1 0
2 14 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 r1
0
6
2 20 0 15 0 19 -1 0
1 11 0 19 -1 1
1 32 0 19 -1 1
1 11 0 27 -1 0
1 32 0 27 -1 0
2 20 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 r1
0
6
2 35 0 15 0 19 -1 0
1 9 0 19 -1 1
1 32 0 19 -1 1
1 9 0 27 -1 0
1 32 0 27 -1 0
2 35 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 t r1
0
6
2 4 0 20 0 19 -1 0
1 3 0 19 -1 1
1 11 0 19 -1 1
1 3 0 27 -1 0
1 11 0 27 -1 0
2 4 0 20 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 f r1
0
6
2 20 0 6 0 19 -1 0
1 11 0 19 -1 1
1 18 0 19 -1 1
1 11 0 27 -1 0
1 18 0 27 -1 0
2 20 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 r1
0
6
2 20 0 14 0 19 -1 0
1 11 0 19 -1 1
1 23 0 19 -1 1
1 11 0 27 -1 0
1 23 0 27 -1 0
2 20 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 r1
0
6
2 20 0 15 0 19 -1 0
1 11 0 19 -1 1
1 32 0 19 -1 1
1 11 0 27 -1 0
1 32 0 27 -1 0
2 20 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 y1 r1
0
6
2 35 0 20 0 19 -1 0
1 9 0 19 -1 1
1 11 0 19 -1 1
1 9 0 27 -1 0
1 11 0 27 -1 0
2 35 0 20 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 t r1
0
6
2 35 0 4 0 19 -1 0
1 3 0 19 -1 1
1 9 0 19 -1 1
1 3 0 27 -1 0
1 9 0 27 -1 0
2 35 0 4 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 f r1
0
6
2 35 0 6 0 19 -1 0
1 9 0 19 -1 1
1 18 0 19 -1 1
1 9 0 27 -1 0
1 18 0 27 -1 0
2 35 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 r1
0
6
2 35 0 14 0 19 -1 0
1 9 0 19 -1 1
1 23 0 19 -1 1
1 9 0 27 -1 0
1 23 0 27 -1 0
2 35 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 r1
0
6
2 35 0 15 0 19 -1 0
1 9 0 19 -1 1
1 32 0 19 -1 1
1 9 0 27 -1 0
1 32 0 27 -1 0
2 35 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 x1 r1
0
6
2 35 0 20 0 19 -1 0
1 9 0 19 -1 1
1 11 0 19 -1 1
1 9 0 27 -1 0
1 11 0 27 -1 0
2 35 0 20 0 27 -1 1
0
end_operator
begin_operator
or-gate t r1 f
0
6
2 19 0 4 0 6 -1 0
1 3 0 6 -1 1
1 27 0 6 -1 1
1 3 0 18 -1 0
1 27 0 18 -1 0
2 19 0 4 0 18 -1 1
0
end_operator
begin_operator
or-gate t r1 tmp1
0
6
2 19 0 4 0 14 -1 0
1 3 0 14 -1 1
1 27 0 14 -1 1
1 3 0 23 -1 0
1 27 0 23 -1 0
2 19 0 4 0 23 -1 1
0
end_operator
begin_operator
or-gate t r1 tmp2
0
6
2 19 0 4 0 15 -1 0
1 3 0 15 -1 1
1 27 0 15 -1 1
1 3 0 32 -1 0
1 27 0 32 -1 0
2 19 0 4 0 32 -1 1
0
end_operator
begin_operator
or-gate f r1 t
0
6
1 18 0 3 -1 0
1 27 0 3 -1 0
2 19 0 6 0 3 -1 1
2 19 0 6 0 4 -1 0
1 18 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate f r1 tmp1
0
6
2 19 0 6 0 14 -1 0
1 18 0 14 -1 1
1 27 0 14 -1 1
1 18 0 23 -1 0
1 27 0 23 -1 0
2 19 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate f r1 tmp2
0
6
2 19 0 6 0 15 -1 0
1 18 0 15 -1 1
1 27 0 15 -1 1
1 18 0 32 -1 0
1 27 0 32 -1 0
2 19 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 r1 t
0
6
1 23 0 3 -1 0
1 27 0 3 -1 0
2 19 0 14 0 3 -1 1
2 19 0 14 0 4 -1 0
1 23 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 r1 f
0
6
2 19 0 14 0 6 -1 0
1 23 0 6 -1 1
1 27 0 6 -1 1
1 23 0 18 -1 0
1 27 0 18 -1 0
2 19 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp1 r1 tmp2
0
6
2 19 0 14 0 15 -1 0
1 23 0 15 -1 1
1 27 0 15 -1 1
1 23 0 32 -1 0
1 27 0 32 -1 0
2 19 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp2 r1 t
0
6
1 27 0 3 -1 0
1 32 0 3 -1 0
2 19 0 15 0 3 -1 1
2 19 0 15 0 4 -1 0
1 27 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 r1 f
0
6
2 19 0 15 0 6 -1 0
1 27 0 6 -1 1
1 32 0 6 -1 1
1 27 0 18 -1 0
1 32 0 18 -1 0
2 19 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 r1 tmp1
0
6
2 19 0 15 0 14 -1 0
1 27 0 14 -1 1
1 32 0 14 -1 1
1 27 0 23 -1 0
1 32 0 23 -1 0
2 19 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 r1 t
0
6
1 11 0 3 -1 0
1 27 0 3 -1 0
2 19 0 20 0 3 -1 1
2 19 0 20 0 4 -1 0
1 11 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 r1 f
0
6
2 19 0 20 0 6 -1 0
1 11 0 6 -1 1
1 27 0 6 -1 1
1 11 0 18 -1 0
1 27 0 18 -1 0
2 19 0 20 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 r1 tmp1
0
6
2 19 0 20 0 14 -1 0
1 11 0 14 -1 1
1 27 0 14 -1 1
1 11 0 23 -1 0
1 27 0 23 -1 0
2 19 0 20 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 r1 tmp2
0
6
2 19 0 20 0 15 -1 0
1 11 0 15 -1 1
1 27 0 15 -1 1
1 11 0 32 -1 0
1 27 0 32 -1 0
2 19 0 20 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 r1 t
0
6
1 9 0 3 -1 0
1 27 0 3 -1 0
2 19 0 35 0 3 -1 1
2 19 0 35 0 4 -1 0
1 9 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 r1 f
0
6
2 19 0 35 0 6 -1 0
1 9 0 6 -1 1
1 27 0 6 -1 1
1 9 0 18 -1 0
1 27 0 18 -1 0
2 19 0 35 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 r1 tmp1
0
6
2 19 0 35 0 14 -1 0
1 9 0 14 -1 1
1 27 0 14 -1 1
1 9 0 23 -1 0
1 27 0 23 -1 0
2 19 0 35 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 r1 tmp2
0
6
2 19 0 35 0 15 -1 0
1 9 0 15 -1 1
1 27 0 15 -1 1
1 9 0 32 -1 0
1 27 0 32 -1 0
2 19 0 35 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 f t
0
8
2 18 0 19 0 3 -1 0
2 27 0 6 0 3 -1 0
2 18 0 27 0 3 -1 1
2 19 0 6 0 3 -1 1
2 18 0 27 0 4 -1 0
2 19 0 6 0 4 -1 0
2 18 0 19 0 4 -1 1
2 27 0 6 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp1 t
0
8
2 19 0 23 0 3 -1 0
2 27 0 14 0 3 -1 0
2 19 0 14 0 3 -1 1
2 27 0 23 0 3 -1 1
2 19 0 14 0 4 -1 0
2 27 0 23 0 4 -1 0
2 19 0 23 0 4 -1 1
2 27 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp2 t
0
8
2 27 0 15 0 3 -1 0
2 32 0 19 0 3 -1 0
2 19 0 15 0 3 -1 1
2 32 0 27 0 3 -1 1
2 19 0 15 0 4 -1 0
2 32 0 27 0 4 -1 0
2 27 0 15 0 4 -1 1
2 32 0 19 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 t
0
8
2 11 0 19 0 3 -1 0
2 27 0 20 0 3 -1 0
2 11 0 27 0 3 -1 1
2 19 0 20 0 3 -1 1
2 11 0 27 0 4 -1 0
2 19 0 20 0 4 -1 0
2 11 0 19 0 4 -1 1
2 27 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 t
0
8
2 9 0 19 0 3 -1 0
2 35 0 27 0 3 -1 0
2 9 0 27 0 3 -1 1
2 35 0 19 0 3 -1 1
2 9 0 27 0 4 -1 0
2 35 0 19 0 4 -1 0
2 9 0 19 0 4 -1 1
2 35 0 27 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 t f
0
8
2 3 0 27 0 6 -1 0
2 19 0 4 0 6 -1 0
2 3 0 19 0 6 -1 1
2 27 0 4 0 6 -1 1
2 3 0 19 0 18 -1 0
2 27 0 4 0 18 -1 0
2 3 0 27 0 18 -1 1
2 19 0 4 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp1 f
0
8
2 19 0 14 0 6 -1 0
2 27 0 23 0 6 -1 0
2 19 0 23 0 6 -1 1
2 27 0 14 0 6 -1 1
2 19 0 23 0 18 -1 0
2 27 0 14 0 18 -1 0
2 19 0 14 0 18 -1 1
2 27 0 23 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp2 f
0
8
2 19 0 15 0 6 -1 0
2 32 0 27 0 6 -1 0
2 27 0 15 0 6 -1 1
2 32 0 19 0 6 -1 1
2 27 0 15 0 18 -1 0
2 32 0 19 0 18 -1 0
2 19 0 15 0 18 -1 1
2 32 0 27 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 f
0
8
2 11 0 27 0 6 -1 0
2 19 0 20 0 6 -1 0
2 11 0 19 0 6 -1 1
2 27 0 20 0 6 -1 1
2 11 0 19 0 18 -1 0
2 27 0 20 0 18 -1 0
2 11 0 27 0 18 -1 1
2 19 0 20 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 f
0
8
2 9 0 27 0 6 -1 0
2 35 0 19 0 6 -1 0
2 9 0 19 0 6 -1 1
2 35 0 27 0 6 -1 1
2 9 0 19 0 18 -1 0
2 35 0 27 0 18 -1 0
2 9 0 27 0 18 -1 1
2 35 0 19 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 t tmp1
0
8
2 3 0 27 0 14 -1 0
2 19 0 4 0 14 -1 0
2 3 0 19 0 14 -1 1
2 27 0 4 0 14 -1 1
2 3 0 19 0 23 -1 0
2 27 0 4 0 23 -1 0
2 3 0 27 0 23 -1 1
2 19 0 4 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 f tmp1
0
8
2 18 0 27 0 14 -1 0
2 19 0 6 0 14 -1 0
2 18 0 19 0 14 -1 1
2 27 0 6 0 14 -1 1
2 18 0 19 0 23 -1 0
2 27 0 6 0 23 -1 0
2 18 0 27 0 23 -1 1
2 19 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp2 tmp1
0
8
2 19 0 15 0 14 -1 0
2 32 0 27 0 14 -1 0
2 27 0 15 0 14 -1 1
2 32 0 19 0 14 -1 1
2 27 0 15 0 23 -1 0
2 32 0 19 0 23 -1 0
2 19 0 15 0 23 -1 1
2 32 0 27 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 tmp1
0
8
2 11 0 27 0 14 -1 0
2 19 0 20 0 14 -1 0
2 11 0 19 0 14 -1 1
2 27 0 20 0 14 -1 1
2 11 0 19 0 23 -1 0
2 27 0 20 0 23 -1 0
2 11 0 27 0 23 -1 1
2 19 0 20 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 tmp1
0
8
2 9 0 27 0 14 -1 0
2 35 0 19 0 14 -1 0
2 9 0 19 0 14 -1 1
2 35 0 27 0 14 -1 1
2 9 0 19 0 23 -1 0
2 35 0 27 0 23 -1 0
2 9 0 27 0 23 -1 1
2 35 0 19 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 t tmp2
0
8
2 3 0 27 0 15 -1 0
2 19 0 4 0 15 -1 0
2 3 0 19 0 15 -1 1
2 27 0 4 0 15 -1 1
2 3 0 19 0 32 -1 0
2 27 0 4 0 32 -1 0
2 3 0 27 0 32 -1 1
2 19 0 4 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 f tmp2
0
8
2 18 0 27 0 15 -1 0
2 19 0 6 0 15 -1 0
2 18 0 19 0 15 -1 1
2 27 0 6 0 15 -1 1
2 18 0 19 0 32 -1 0
2 27 0 6 0 32 -1 0
2 18 0 27 0 32 -1 1
2 19 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp1 tmp2
0
8
2 19 0 14 0 15 -1 0
2 27 0 23 0 15 -1 0
2 19 0 23 0 15 -1 1
2 27 0 14 0 15 -1 1
2 19 0 23 0 32 -1 0
2 27 0 14 0 32 -1 0
2 19 0 14 0 32 -1 1
2 27 0 23 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 tmp2
0
8
2 11 0 27 0 15 -1 0
2 19 0 20 0 15 -1 0
2 11 0 19 0 15 -1 1
2 27 0 20 0 15 -1 1
2 11 0 19 0 32 -1 0
2 27 0 20 0 32 -1 0
2 11 0 27 0 32 -1 1
2 19 0 20 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 tmp2
0
8
2 9 0 27 0 15 -1 0
2 35 0 19 0 15 -1 0
2 9 0 19 0 15 -1 1
2 35 0 27 0 15 -1 1
2 9 0 19 0 32 -1 0
2 35 0 27 0 32 -1 0
2 9 0 27 0 32 -1 1
2 35 0 19 0 32 -1 1
0
end_operator
begin_operator
xor-gate t f r1
0
8
2 4 0 6 0 19 -1 0
2 18 0 3 0 19 -1 0
2 3 0 6 0 19 -1 1
2 18 0 4 0 19 -1 1
2 3 0 6 0 27 -1 0
2 18 0 4 0 27 -1 0
2 4 0 6 0 27 -1 1
2 18 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate t tmp1 r1
0
8
2 3 0 23 0 19 -1 0
2 4 0 14 0 19 -1 0
2 3 0 14 0 19 -1 1
2 4 0 23 0 19 -1 1
2 3 0 14 0 27 -1 0
2 4 0 23 0 27 -1 0
2 3 0 23 0 27 -1 1
2 4 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate t tmp2 r1
0
8
2 4 0 15 0 19 -1 0
2 32 0 3 0 19 -1 0
2 3 0 15 0 19 -1 1
2 32 0 4 0 19 -1 1
2 3 0 15 0 27 -1 0
2 32 0 4 0 27 -1 0
2 4 0 15 0 27 -1 1
2 32 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate t x1 r1
0
8
2 11 0 3 0 19 -1 0
2 20 0 4 0 19 -1 0
2 3 0 20 0 19 -1 1
2 11 0 4 0 19 -1 1
2 3 0 20 0 27 -1 0
2 11 0 4 0 27 -1 0
2 11 0 3 0 27 -1 1
2 20 0 4 0 27 -1 1
0
end_operator
begin_operator
xor-gate t y1 r1
0
8
2 9 0 3 0 19 -1 0
2 35 0 4 0 19 -1 0
2 9 0 4 0 19 -1 1
2 35 0 3 0 19 -1 1
2 9 0 4 0 27 -1 0
2 35 0 3 0 27 -1 0
2 9 0 3 0 27 -1 1
2 35 0 4 0 27 -1 1
0
end_operator
begin_operator
xor-gate f t r1
0
8
2 4 0 6 0 19 -1 0
2 18 0 3 0 19 -1 0
2 3 0 6 0 19 -1 1
2 18 0 4 0 19 -1 1
2 3 0 6 0 27 -1 0
2 18 0 4 0 27 -1 0
2 4 0 6 0 27 -1 1
2 18 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate f tmp1 r1
0
8
2 14 0 6 0 19 -1 0
2 18 0 23 0 19 -1 0
2 6 0 23 0 19 -1 1
2 18 0 14 0 19 -1 1
2 6 0 23 0 27 -1 0
2 18 0 14 0 27 -1 0
2 14 0 6 0 27 -1 1
2 18 0 23 0 27 -1 1
0
end_operator
begin_operator
xor-gate f tmp2 r1
0
8
2 6 0 15 0 19 -1 0
2 32 0 18 0 19 -1 0
2 18 0 15 0 19 -1 1
2 32 0 6 0 19 -1 1
2 18 0 15 0 27 -1 0
2 32 0 6 0 27 -1 0
2 6 0 15 0 27 -1 1
2 32 0 18 0 27 -1 1
0
end_operator
begin_operator
xor-gate f x1 r1
0
8
2 18 0 11 0 19 -1 0
2 20 0 6 0 19 -1 0
2 11 0 6 0 19 -1 1
2 18 0 20 0 19 -1 1
2 11 0 6 0 27 -1 0
2 18 0 20 0 27 -1 0
2 18 0 11 0 27 -1 1
2 20 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate f y1 r1
0
8
2 9 0 18 0 19 -1 0
2 35 0 6 0 19 -1 0
2 9 0 6 0 19 -1 1
2 18 0 35 0 19 -1 1
2 9 0 6 0 27 -1 0
2 18 0 35 0 27 -1 0
2 9 0 18 0 27 -1 1
2 35 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 t r1
0
8
2 3 0 23 0 19 -1 0
2 4 0 14 0 19 -1 0
2 3 0 14 0 19 -1 1
2 4 0 23 0 19 -1 1
2 3 0 14 0 27 -1 0
2 4 0 23 0 27 -1 0
2 3 0 23 0 27 -1 1
2 4 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 f r1
0
8
2 6 0 14 0 19 -1 0
2 18 0 23 0 19 -1 0
2 6 0 23 0 19 -1 1
2 18 0 14 0 19 -1 1
2 6 0 23 0 27 -1 0
2 18 0 14 0 27 -1 0
2 6 0 14 0 27 -1 1
2 18 0 23 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 tmp2 r1
0
8
2 14 0 15 0 19 -1 0
2 32 0 23 0 19 -1 0
2 15 0 23 0 19 -1 1
2 32 0 14 0 19 -1 1
2 15 0 23 0 27 -1 0
2 32 0 14 0 27 -1 0
2 14 0 15 0 27 -1 1
2 32 0 23 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 r1
0
8
2 11 0 23 0 19 -1 0
2 20 0 14 0 19 -1 0
2 11 0 14 0 19 -1 1
2 20 0 23 0 19 -1 1
2 11 0 14 0 27 -1 0
2 20 0 23 0 27 -1 0
2 11 0 23 0 27 -1 1
2 20 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 r1
0
8
2 9 0 23 0 19 -1 0
2 35 0 14 0 19 -1 0
2 9 0 14 0 19 -1 1
2 35 0 23 0 19 -1 1
2 9 0 14 0 27 -1 0
2 35 0 23 0 27 -1 0
2 9 0 23 0 27 -1 1
2 35 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 t r1
0
8
2 4 0 15 0 19 -1 0
2 32 0 3 0 19 -1 0
2 3 0 15 0 19 -1 1
2 32 0 4 0 19 -1 1
2 3 0 15 0 27 -1 0
2 32 0 4 0 27 -1 0
2 4 0 15 0 27 -1 1
2 32 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 f r1
0
8
2 6 0 15 0 19 -1 0
2 32 0 18 0 19 -1 0
2 18 0 15 0 19 -1 1
2 32 0 6 0 19 -1 1
2 18 0 15 0 27 -1 0
2 32 0 6 0 27 -1 0
2 6 0 15 0 27 -1 1
2 32 0 18 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 tmp1 r1
0
8
2 14 0 15 0 19 -1 0
2 32 0 23 0 19 -1 0
2 23 0 15 0 19 -1 1
2 32 0 14 0 19 -1 1
2 23 0 15 0 27 -1 0
2 32 0 14 0 27 -1 0
2 14 0 15 0 27 -1 1
2 32 0 23 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 r1
0
8
2 20 0 15 0 19 -1 0
2 32 0 11 0 19 -1 0
2 11 0 15 0 19 -1 1
2 32 0 20 0 19 -1 1
2 11 0 15 0 27 -1 0
2 32 0 20 0 27 -1 0
2 20 0 15 0 27 -1 1
2 32 0 11 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 r1
0
8
2 32 0 9 0 19 -1 0
2 35 0 15 0 19 -1 0
2 9 0 15 0 19 -1 1
2 32 0 35 0 19 -1 1
2 9 0 15 0 27 -1 0
2 32 0 35 0 27 -1 0
2 32 0 9 0 27 -1 1
2 35 0 15 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 t r1
0
8
2 3 0 11 0 19 -1 0
2 4 0 20 0 19 -1 0
2 3 0 20 0 19 -1 1
2 11 0 4 0 19 -1 1
2 3 0 20 0 27 -1 0
2 11 0 4 0 27 -1 0
2 3 0 11 0 27 -1 1
2 4 0 20 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 f r1
0
8
2 18 0 11 0 19 -1 0
2 20 0 6 0 19 -1 0
2 11 0 6 0 19 -1 1
2 18 0 20 0 19 -1 1
2 11 0 6 0 27 -1 0
2 18 0 20 0 27 -1 0
2 18 0 11 0 27 -1 1
2 20 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 r1
0
8
2 11 0 23 0 19 -1 0
2 20 0 14 0 19 -1 0
2 11 0 14 0 19 -1 1
2 20 0 23 0 19 -1 1
2 11 0 14 0 27 -1 0
2 20 0 23 0 27 -1 0
2 11 0 23 0 27 -1 1
2 20 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 r1
0
8
2 20 0 15 0 19 -1 0
2 32 0 11 0 19 -1 0
2 11 0 15 0 19 -1 1
2 32 0 20 0 19 -1 1
2 11 0 15 0 27 -1 0
2 32 0 20 0 27 -1 0
2 20 0 15 0 27 -1 1
2 32 0 11 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 r1
0
8
2 9 0 11 0 19 -1 0
2 35 0 20 0 19 -1 0
2 9 0 20 0 19 -1 1
2 35 0 11 0 19 -1 1
2 9 0 20 0 27 -1 0
2 35 0 11 0 27 -1 0
2 9 0 11 0 27 -1 1
2 35 0 20 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 t r1
0
8
2 9 0 3 0 19 -1 0
2 35 0 4 0 19 -1 0
2 3 0 35 0 19 -1 1
2 9 0 4 0 19 -1 1
2 3 0 35 0 27 -1 0
2 9 0 4 0 27 -1 0
2 9 0 3 0 27 -1 1
2 35 0 4 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 f r1
0
8
2 9 0 18 0 19 -1 0
2 35 0 6 0 19 -1 0
2 9 0 6 0 19 -1 1
2 18 0 35 0 19 -1 1
2 9 0 6 0 27 -1 0
2 18 0 35 0 27 -1 0
2 9 0 18 0 27 -1 1
2 35 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 r1
0
8
2 9 0 23 0 19 -1 0
2 35 0 14 0 19 -1 0
2 9 0 14 0 19 -1 1
2 35 0 23 0 19 -1 1
2 9 0 14 0 27 -1 0
2 35 0 23 0 27 -1 0
2 9 0 23 0 27 -1 1
2 35 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 r1
0
8
2 32 0 9 0 19 -1 0
2 35 0 15 0 19 -1 0
2 9 0 15 0 19 -1 1
2 32 0 35 0 19 -1 1
2 9 0 15 0 27 -1 0
2 32 0 35 0 27 -1 0
2 32 0 9 0 27 -1 1
2 35 0 15 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 r1
0
8
2 9 0 11 0 19 -1 0
2 35 0 20 0 19 -1 0
2 9 0 20 0 19 -1 1
2 11 0 35 0 19 -1 1
2 9 0 20 0 27 -1 0
2 11 0 35 0 27 -1 0
2 9 0 11 0 27 -1 1
2 35 0 20 0 27 -1 1
0
end_operator
begin_operator
xor-gate t r1 f
0
8
2 19 0 4 0 6 -1 0
2 27 0 3 0 6 -1 0
2 19 0 3 0 6 -1 1
2 27 0 4 0 6 -1 1
2 19 0 3 0 18 -1 0
2 27 0 4 0 18 -1 0
2 19 0 4 0 18 -1 1
2 27 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate t r1 tmp1
0
8
2 19 0 4 0 14 -1 0
2 27 0 3 0 14 -1 0
2 19 0 3 0 14 -1 1
2 27 0 4 0 14 -1 1
2 19 0 3 0 23 -1 0
2 27 0 4 0 23 -1 0
2 19 0 4 0 23 -1 1
2 27 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate t r1 tmp2
0
8
2 19 0 4 0 15 -1 0
2 27 0 3 0 15 -1 0
2 19 0 3 0 15 -1 1
2 27 0 4 0 15 -1 1
2 19 0 3 0 32 -1 0
2 27 0 4 0 32 -1 0
2 19 0 4 0 32 -1 1
2 27 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate f r1 t
0
8
2 18 0 19 0 3 -1 0
2 27 0 6 0 3 -1 0
2 18 0 27 0 3 -1 1
2 19 0 6 0 3 -1 1
2 18 0 27 0 4 -1 0
2 19 0 6 0 4 -1 0
2 18 0 19 0 4 -1 1
2 27 0 6 0 4 -1 1
0
end_operator
begin_operator
xor-gate f r1 tmp1
0
8
2 18 0 27 0 14 -1 0
2 19 0 6 0 14 -1 0
2 18 0 19 0 14 -1 1
2 27 0 6 0 14 -1 1
2 18 0 19 0 23 -1 0
2 27 0 6 0 23 -1 0
2 18 0 27 0 23 -1 1
2 19 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate f r1 tmp2
0
8
2 18 0 27 0 15 -1 0
2 19 0 6 0 15 -1 0
2 18 0 19 0 15 -1 1
2 27 0 6 0 15 -1 1
2 18 0 19 0 32 -1 0
2 27 0 6 0 32 -1 0
2 18 0 27 0 32 -1 1
2 19 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r1 t
0
8
2 19 0 23 0 3 -1 0
2 27 0 14 0 3 -1 0
2 19 0 14 0 3 -1 1
2 27 0 23 0 3 -1 1
2 19 0 14 0 4 -1 0
2 27 0 23 0 4 -1 0
2 19 0 23 0 4 -1 1
2 27 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r1 f
0
8
2 19 0 14 0 6 -1 0
2 27 0 23 0 6 -1 0
2 19 0 23 0 6 -1 1
2 27 0 14 0 6 -1 1
2 19 0 23 0 18 -1 0
2 27 0 14 0 18 -1 0
2 19 0 14 0 18 -1 1
2 27 0 23 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r1 tmp2
0
8
2 19 0 14 0 15 -1 0
2 27 0 23 0 15 -1 0
2 19 0 23 0 15 -1 1
2 27 0 14 0 15 -1 1
2 19 0 23 0 32 -1 0
2 27 0 14 0 32 -1 0
2 19 0 14 0 32 -1 1
2 27 0 23 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r1 t
0
8
2 27 0 15 0 3 -1 0
2 32 0 19 0 3 -1 0
2 19 0 15 0 3 -1 1
2 32 0 27 0 3 -1 1
2 19 0 15 0 4 -1 0
2 32 0 27 0 4 -1 0
2 27 0 15 0 4 -1 1
2 32 0 19 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r1 f
0
8
2 19 0 15 0 6 -1 0
2 32 0 27 0 6 -1 0
2 27 0 15 0 6 -1 1
2 32 0 19 0 6 -1 1
2 27 0 15 0 18 -1 0
2 32 0 19 0 18 -1 0
2 19 0 15 0 18 -1 1
2 32 0 27 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r1 tmp1
0
8
2 19 0 15 0 14 -1 0
2 32 0 27 0 14 -1 0
2 27 0 15 0 14 -1 1
2 32 0 19 0 14 -1 1
2 27 0 15 0 23 -1 0
2 32 0 19 0 23 -1 0
2 19 0 15 0 23 -1 1
2 32 0 27 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 t
0
8
2 19 0 11 0 3 -1 0
2 27 0 20 0 3 -1 0
2 19 0 20 0 3 -1 1
2 27 0 11 0 3 -1 1
2 19 0 20 0 4 -1 0
2 27 0 11 0 4 -1 0
2 19 0 11 0 4 -1 1
2 27 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 f
0
8
2 19 0 20 0 6 -1 0
2 27 0 11 0 6 -1 0
2 19 0 11 0 6 -1 1
2 27 0 20 0 6 -1 1
2 19 0 11 0 18 -1 0
2 27 0 20 0 18 -1 0
2 19 0 20 0 18 -1 1
2 27 0 11 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 tmp1
0
8
2 19 0 20 0 14 -1 0
2 27 0 11 0 14 -1 0
2 19 0 11 0 14 -1 1
2 27 0 20 0 14 -1 1
2 19 0 11 0 23 -1 0
2 27 0 20 0 23 -1 0
2 19 0 20 0 23 -1 1
2 27 0 11 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 tmp2
0
8
2 19 0 20 0 15 -1 0
2 27 0 11 0 15 -1 0
2 19 0 11 0 15 -1 1
2 27 0 20 0 15 -1 1
2 19 0 11 0 32 -1 0
2 27 0 20 0 32 -1 0
2 19 0 20 0 32 -1 1
2 27 0 11 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 t
0
8
2 9 0 19 0 3 -1 0
2 27 0 35 0 3 -1 0
2 9 0 27 0 3 -1 1
2 19 0 35 0 3 -1 1
2 9 0 27 0 4 -1 0
2 19 0 35 0 4 -1 0
2 9 0 19 0 4 -1 1
2 27 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 f
0
8
2 9 0 27 0 6 -1 0
2 19 0 35 0 6 -1 0
2 9 0 19 0 6 -1 1
2 27 0 35 0 6 -1 1
2 9 0 19 0 18 -1 0
2 27 0 35 0 18 -1 0
2 9 0 27 0 18 -1 1
2 19 0 35 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 tmp1
0
8
2 9 0 27 0 14 -1 0
2 19 0 35 0 14 -1 0
2 9 0 19 0 14 -1 1
2 27 0 35 0 14 -1 1
2 9 0 19 0 23 -1 0
2 27 0 35 0 23 -1 0
2 9 0 27 0 23 -1 1
2 19 0 35 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 tmp2
0
8
2 9 0 27 0 15 -1 0
2 19 0 35 0 15 -1 0
2 9 0 19 0 15 -1 1
2 27 0 35 0 15 -1 1
2 9 0 19 0 32 -1 0
2 27 0 35 0 32 -1 0
2 9 0 27 0 32 -1 1
2 19 0 35 0 32 -1 1
0
end_operator
begin_operator
not-gate r1 t
0
4
1 19 0 3 -1 0
1 27 0 3 -1 1
1 27 0 4 -1 0
1 19 0 4 -1 1
0
end_operator
begin_operator
not-gate r1 f
0
4
1 27 0 6 -1 0
1 19 0 6 -1 1
1 19 0 18 -1 0
1 27 0 18 -1 1
0
end_operator
begin_operator
not-gate r1 tmp1
0
4
1 27 0 14 -1 0
1 19 0 14 -1 1
1 19 0 23 -1 0
1 27 0 23 -1 1
0
end_operator
begin_operator
not-gate r1 tmp2
0
4
1 27 0 15 -1 0
1 19 0 15 -1 1
1 19 0 32 -1 0
1 27 0 32 -1 1
0
end_operator
begin_operator
not-gate t r1
0
4
1 3 0 19 -1 0
1 4 0 19 -1 1
1 4 0 27 -1 0
1 3 0 27 -1 1
0
end_operator
begin_operator
not-gate f r1
0
4
1 18 0 19 -1 0
1 6 0 19 -1 1
1 6 0 27 -1 0
1 18 0 27 -1 1
0
end_operator
begin_operator
not-gate tmp1 r1
0
4
1 23 0 19 -1 0
1 14 0 19 -1 1
1 14 0 27 -1 0
1 23 0 27 -1 1
0
end_operator
begin_operator
not-gate tmp2 r1
0
4
1 32 0 19 -1 0
1 15 0 19 -1 1
1 15 0 27 -1 0
1 32 0 27 -1 1
0
end_operator
begin_operator
not-gate x1 r1
0
4
1 11 0 19 -1 0
1 20 0 19 -1 1
1 20 0 27 -1 0
1 11 0 27 -1 1
0
end_operator
begin_operator
not-gate y1 r1
0
4
1 9 0 19 -1 0
1 35 0 19 -1 1
1 35 0 27 -1 0
1 9 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 f t
0
6
2 8 0 18 0 3 -1 0
1 6 0 3 -1 1
1 7 0 3 -1 1
1 6 0 4 -1 0
1 7 0 4 -1 0
2 8 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 tmp1 t
0
6
2 8 0 23 0 3 -1 0
1 7 0 3 -1 1
1 14 0 3 -1 1
1 7 0 4 -1 0
1 14 0 4 -1 0
2 8 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 tmp2 t
0
6
2 8 0 32 0 3 -1 0
1 7 0 3 -1 1
1 15 0 3 -1 1
1 7 0 4 -1 0
1 15 0 4 -1 0
2 8 0 32 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 x1 t
0
6
2 8 0 11 0 3 -1 0
1 7 0 3 -1 1
1 20 0 3 -1 1
1 7 0 4 -1 0
1 20 0 4 -1 0
2 8 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 y1 t
0
6
2 8 0 9 0 3 -1 0
1 7 0 3 -1 1
1 35 0 3 -1 1
1 7 0 4 -1 0
1 35 0 4 -1 0
2 8 0 9 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 r1 t
0
6
2 8 0 27 0 3 -1 0
1 7 0 3 -1 1
1 19 0 3 -1 1
1 7 0 4 -1 0
1 19 0 4 -1 0
2 8 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 t f
0
6
1 4 0 6 -1 0
1 7 0 6 -1 0
2 8 0 3 0 6 -1 1
2 8 0 3 0 18 -1 0
1 4 0 18 -1 1
1 7 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 tmp1 f
0
6
1 7 0 6 -1 0
1 14 0 6 -1 0
2 8 0 23 0 6 -1 1
2 8 0 23 0 18 -1 0
1 7 0 18 -1 1
1 14 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 tmp2 f
0
6
1 7 0 6 -1 0
1 15 0 6 -1 0
2 8 0 32 0 6 -1 1
2 8 0 32 0 18 -1 0
1 7 0 18 -1 1
1 15 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 x1 f
0
6
1 7 0 6 -1 0
1 20 0 6 -1 0
2 8 0 11 0 6 -1 1
2 8 0 11 0 18 -1 0
1 7 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 y1 f
0
6
1 7 0 6 -1 0
1 35 0 6 -1 0
2 8 0 9 0 6 -1 1
2 8 0 9 0 18 -1 0
1 7 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 r1 f
0
6
1 7 0 6 -1 0
1 19 0 6 -1 0
2 8 0 27 0 6 -1 1
2 8 0 27 0 18 -1 0
1 7 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 t tmp1
0
6
1 4 0 14 -1 0
1 7 0 14 -1 0
2 8 0 3 0 14 -1 1
2 8 0 3 0 23 -1 0
1 4 0 23 -1 1
1 7 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 f tmp1
0
6
1 6 0 14 -1 0
1 7 0 14 -1 0
2 8 0 18 0 14 -1 1
2 8 0 18 0 23 -1 0
1 6 0 23 -1 1
1 7 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 tmp2 tmp1
0
6
1 7 0 14 -1 0
1 15 0 14 -1 0
2 8 0 32 0 14 -1 1
2 8 0 32 0 23 -1 0
1 7 0 23 -1 1
1 15 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 x1 tmp1
0
6
1 7 0 14 -1 0
1 20 0 14 -1 0
2 8 0 11 0 14 -1 1
2 8 0 11 0 23 -1 0
1 7 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 y1 tmp1
0
6
1 7 0 14 -1 0
1 35 0 14 -1 0
2 8 0 9 0 14 -1 1
2 8 0 9 0 23 -1 0
1 7 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 r1 tmp1
0
6
1 7 0 14 -1 0
1 19 0 14 -1 0
2 8 0 27 0 14 -1 1
2 8 0 27 0 23 -1 0
1 7 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 t tmp2
0
6
1 4 0 15 -1 0
1 7 0 15 -1 0
2 8 0 3 0 15 -1 1
2 8 0 3 0 32 -1 0
1 4 0 32 -1 1
1 7 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 f tmp2
0
6
1 6 0 15 -1 0
1 7 0 15 -1 0
2 8 0 18 0 15 -1 1
2 8 0 18 0 32 -1 0
1 6 0 32 -1 1
1 7 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 tmp1 tmp2
0
6
1 7 0 15 -1 0
1 14 0 15 -1 0
2 8 0 23 0 15 -1 1
2 8 0 23 0 32 -1 0
1 7 0 32 -1 1
1 14 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 x1 tmp2
0
6
1 7 0 15 -1 0
1 20 0 15 -1 0
2 8 0 11 0 15 -1 1
2 8 0 11 0 32 -1 0
1 7 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 y1 tmp2
0
6
1 7 0 15 -1 0
1 35 0 15 -1 0
2 8 0 9 0 15 -1 1
2 8 0 9 0 32 -1 0
1 7 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 r1 tmp2
0
6
1 7 0 15 -1 0
1 19 0 15 -1 0
2 8 0 27 0 15 -1 1
2 8 0 27 0 32 -1 0
1 7 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 t r1
0
6
1 4 0 19 -1 0
1 7 0 19 -1 0
2 8 0 3 0 19 -1 1
2 8 0 3 0 27 -1 0
1 4 0 27 -1 1
1 7 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 f r1
0
6
1 6 0 19 -1 0
1 7 0 19 -1 0
2 8 0 18 0 19 -1 1
2 8 0 18 0 27 -1 0
1 6 0 27 -1 1
1 7 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 tmp1 r1
0
6
1 7 0 19 -1 0
1 14 0 19 -1 0
2 8 0 23 0 19 -1 1
2 8 0 23 0 27 -1 0
1 7 0 27 -1 1
1 14 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 tmp2 r1
0
6
1 7 0 19 -1 0
1 15 0 19 -1 0
2 8 0 32 0 19 -1 1
2 8 0 32 0 27 -1 0
1 7 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 x1 r1
0
6
1 7 0 19 -1 0
1 20 0 19 -1 0
2 8 0 11 0 19 -1 1
2 8 0 11 0 27 -1 0
1 7 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 y1 r1
0
6
1 7 0 19 -1 0
1 35 0 19 -1 0
2 8 0 9 0 19 -1 1
2 8 0 9 0 27 -1 0
1 7 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate t f z1
0
6
1 4 0 7 -1 0
1 6 0 7 -1 0
2 18 0 3 0 7 -1 1
2 18 0 3 0 8 -1 0
1 4 0 8 -1 1
1 6 0 8 -1 1
0
end_operator
begin_operator
and-gate t tmp1 z1
0
6
1 4 0 7 -1 0
1 14 0 7 -1 0
2 3 0 23 0 7 -1 1
2 3 0 23 0 8 -1 0
1 4 0 8 -1 1
1 14 0 8 -1 1
0
end_operator
begin_operator
and-gate t tmp2 z1
0
6
1 4 0 7 -1 0
1 15 0 7 -1 0
2 32 0 3 0 7 -1 1
2 32 0 3 0 8 -1 0
1 4 0 8 -1 1
1 15 0 8 -1 1
0
end_operator
begin_operator
and-gate t x1 z1
0
6
1 4 0 7 -1 0
1 20 0 7 -1 0
2 11 0 3 0 7 -1 1
2 11 0 3 0 8 -1 0
1 4 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate t y1 z1
0
6
1 4 0 7 -1 0
1 35 0 7 -1 0
2 9 0 3 0 7 -1 1
2 9 0 3 0 8 -1 0
1 4 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate t r1 z1
0
6
1 4 0 7 -1 0
1 19 0 7 -1 0
2 27 0 3 0 7 -1 1
2 27 0 3 0 8 -1 0
1 4 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate f t z1
0
6
1 4 0 7 -1 0
1 6 0 7 -1 0
2 18 0 3 0 7 -1 1
2 18 0 3 0 8 -1 0
1 4 0 8 -1 1
1 6 0 8 -1 1
0
end_operator
begin_operator
and-gate f tmp1 z1
0
6
1 6 0 7 -1 0
1 14 0 7 -1 0
2 18 0 23 0 7 -1 1
2 18 0 23 0 8 -1 0
1 6 0 8 -1 1
1 14 0 8 -1 1
0
end_operator
begin_operator
and-gate f tmp2 z1
0
6
1 6 0 7 -1 0
1 15 0 7 -1 0
2 32 0 18 0 7 -1 1
2 32 0 18 0 8 -1 0
1 6 0 8 -1 1
1 15 0 8 -1 1
0
end_operator
begin_operator
and-gate f x1 z1
0
6
1 6 0 7 -1 0
1 20 0 7 -1 0
2 18 0 11 0 7 -1 1
2 18 0 11 0 8 -1 0
1 6 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate f y1 z1
0
6
1 6 0 7 -1 0
1 35 0 7 -1 0
2 9 0 18 0 7 -1 1
2 9 0 18 0 8 -1 0
1 6 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate f r1 z1
0
6
1 6 0 7 -1 0
1 19 0 7 -1 0
2 18 0 27 0 7 -1 1
2 18 0 27 0 8 -1 0
1 6 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 t z1
0
6
1 4 0 7 -1 0
1 14 0 7 -1 0
2 3 0 23 0 7 -1 1
2 3 0 23 0 8 -1 0
1 4 0 8 -1 1
1 14 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 f z1
0
6
1 6 0 7 -1 0
1 14 0 7 -1 0
2 18 0 23 0 7 -1 1
2 18 0 23 0 8 -1 0
1 6 0 8 -1 1
1 14 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 tmp2 z1
0
6
1 14 0 7 -1 0
1 15 0 7 -1 0
2 32 0 23 0 7 -1 1
2 32 0 23 0 8 -1 0
1 14 0 8 -1 1
1 15 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 z1
0
6
1 14 0 7 -1 0
1 20 0 7 -1 0
2 11 0 23 0 7 -1 1
2 11 0 23 0 8 -1 0
1 14 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 z1
0
6
1 14 0 7 -1 0
1 35 0 7 -1 0
2 9 0 23 0 7 -1 1
2 9 0 23 0 8 -1 0
1 14 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 r1 z1
0
6
1 14 0 7 -1 0
1 19 0 7 -1 0
2 27 0 23 0 7 -1 1
2 27 0 23 0 8 -1 0
1 14 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 t z1
0
6
1 4 0 7 -1 0
1 15 0 7 -1 0
2 32 0 3 0 7 -1 1
2 32 0 3 0 8 -1 0
1 4 0 8 -1 1
1 15 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 f z1
0
6
1 6 0 7 -1 0
1 15 0 7 -1 0
2 32 0 18 0 7 -1 1
2 32 0 18 0 8 -1 0
1 6 0 8 -1 1
1 15 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 tmp1 z1
0
6
1 14 0 7 -1 0
1 15 0 7 -1 0
2 32 0 23 0 7 -1 1
2 32 0 23 0 8 -1 0
1 14 0 8 -1 1
1 15 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 z1
0
6
1 15 0 7 -1 0
1 20 0 7 -1 0
2 32 0 11 0 7 -1 1
2 32 0 11 0 8 -1 0
1 15 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 z1
0
6
1 15 0 7 -1 0
1 35 0 7 -1 0
2 32 0 9 0 7 -1 1
2 32 0 9 0 8 -1 0
1 15 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 r1 z1
0
6
1 15 0 7 -1 0
1 19 0 7 -1 0
2 32 0 27 0 7 -1 1
2 32 0 27 0 8 -1 0
1 15 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 t z1
0
6
1 4 0 7 -1 0
1 20 0 7 -1 0
2 3 0 11 0 7 -1 1
2 3 0 11 0 8 -1 0
1 4 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 f z1
0
6
1 6 0 7 -1 0
1 20 0 7 -1 0
2 18 0 11 0 7 -1 1
2 18 0 11 0 8 -1 0
1 6 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 z1
0
6
1 14 0 7 -1 0
1 20 0 7 -1 0
2 11 0 23 0 7 -1 1
2 11 0 23 0 8 -1 0
1 14 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 z1
0
6
1 15 0 7 -1 0
1 20 0 7 -1 0
2 32 0 11 0 7 -1 1
2 32 0 11 0 8 -1 0
1 15 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 y1 z1
0
6
1 20 0 7 -1 0
1 35 0 7 -1 0
2 9 0 11 0 7 -1 1
2 9 0 11 0 8 -1 0
1 20 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 r1 z1
0
6
1 19 0 7 -1 0
1 20 0 7 -1 0
2 27 0 11 0 7 -1 1
2 27 0 11 0 8 -1 0
1 19 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 t z1
0
6
1 4 0 7 -1 0
1 35 0 7 -1 0
2 9 0 3 0 7 -1 1
2 9 0 3 0 8 -1 0
1 4 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 f z1
0
6
1 6 0 7 -1 0
1 35 0 7 -1 0
2 9 0 18 0 7 -1 1
2 9 0 18 0 8 -1 0
1 6 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 z1
0
6
1 14 0 7 -1 0
1 35 0 7 -1 0
2 9 0 23 0 7 -1 1
2 9 0 23 0 8 -1 0
1 14 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 z1
0
6
1 15 0 7 -1 0
1 35 0 7 -1 0
2 32 0 9 0 7 -1 1
2 32 0 9 0 8 -1 0
1 15 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 x1 z1
0
6
1 20 0 7 -1 0
1 35 0 7 -1 0
2 9 0 11 0 7 -1 1
2 9 0 11 0 8 -1 0
1 20 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 r1 z1
0
6
1 19 0 7 -1 0
1 35 0 7 -1 0
2 9 0 27 0 7 -1 1
2 9 0 27 0 8 -1 0
1 19 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 t z1
0
6
1 4 0 7 -1 0
1 19 0 7 -1 0
2 3 0 27 0 7 -1 1
2 3 0 27 0 8 -1 0
1 4 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 f z1
0
6
1 6 0 7 -1 0
1 19 0 7 -1 0
2 18 0 27 0 7 -1 1
2 18 0 27 0 8 -1 0
1 6 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 tmp1 z1
0
6
1 14 0 7 -1 0
1 19 0 7 -1 0
2 27 0 23 0 7 -1 1
2 27 0 23 0 8 -1 0
1 14 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 tmp2 z1
0
6
1 15 0 7 -1 0
1 19 0 7 -1 0
2 32 0 27 0 7 -1 1
2 32 0 27 0 8 -1 0
1 15 0 8 -1 1
1 19 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 x1 z1
0
6
1 19 0 7 -1 0
1 20 0 7 -1 0
2 11 0 27 0 7 -1 1
2 11 0 27 0 8 -1 0
1 19 0 8 -1 1
1 20 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 y1 z1
0
6
1 19 0 7 -1 0
1 35 0 7 -1 0
2 9 0 27 0 7 -1 1
2 9 0 27 0 8 -1 0
1 19 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate t z1 f
0
6
1 4 0 6 -1 0
1 7 0 6 -1 0
2 8 0 3 0 6 -1 1
2 8 0 3 0 18 -1 0
1 4 0 18 -1 1
1 7 0 18 -1 1
0
end_operator
begin_operator
and-gate t z1 tmp1
0
6
1 4 0 14 -1 0
1 7 0 14 -1 0
2 8 0 3 0 14 -1 1
2 8 0 3 0 23 -1 0
1 4 0 23 -1 1
1 7 0 23 -1 1
0
end_operator
begin_operator
and-gate t z1 tmp2
0
6
1 4 0 15 -1 0
1 7 0 15 -1 0
2 8 0 3 0 15 -1 1
2 8 0 3 0 32 -1 0
1 4 0 32 -1 1
1 7 0 32 -1 1
0
end_operator
begin_operator
and-gate t z1 r1
0
6
1 4 0 19 -1 0
1 7 0 19 -1 0
2 8 0 3 0 19 -1 1
2 8 0 3 0 27 -1 0
1 4 0 27 -1 1
1 7 0 27 -1 1
0
end_operator
begin_operator
and-gate f z1 t
0
6
2 8 0 18 0 3 -1 0
1 6 0 3 -1 1
1 7 0 3 -1 1
1 6 0 4 -1 0
1 7 0 4 -1 0
2 8 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate f z1 tmp1
0
6
1 6 0 14 -1 0
1 7 0 14 -1 0
2 8 0 18 0 14 -1 1
2 8 0 18 0 23 -1 0
1 6 0 23 -1 1
1 7 0 23 -1 1
0
end_operator
begin_operator
and-gate f z1 tmp2
0
6
1 6 0 15 -1 0
1 7 0 15 -1 0
2 8 0 18 0 15 -1 1
2 8 0 18 0 32 -1 0
1 6 0 32 -1 1
1 7 0 32 -1 1
0
end_operator
begin_operator
and-gate f z1 r1
0
6
1 6 0 19 -1 0
1 7 0 19 -1 0
2 8 0 18 0 19 -1 1
2 8 0 18 0 27 -1 0
1 6 0 27 -1 1
1 7 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 z1 t
0
6
2 8 0 23 0 3 -1 0
1 7 0 3 -1 1
1 14 0 3 -1 1
1 7 0 4 -1 0
1 14 0 4 -1 0
2 8 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 z1 f
0
6
1 7 0 6 -1 0
1 14 0 6 -1 0
2 8 0 23 0 6 -1 1
2 8 0 23 0 18 -1 0
1 7 0 18 -1 1
1 14 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 z1 tmp2
0
6
1 7 0 15 -1 0
1 14 0 15 -1 0
2 8 0 23 0 15 -1 1
2 8 0 23 0 32 -1 0
1 7 0 32 -1 1
1 14 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 z1 r1
0
6
1 7 0 19 -1 0
1 14 0 19 -1 0
2 8 0 23 0 19 -1 1
2 8 0 23 0 27 -1 0
1 7 0 27 -1 1
1 14 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 z1 t
0
6
2 32 0 8 0 3 -1 0
1 7 0 3 -1 1
1 15 0 3 -1 1
1 7 0 4 -1 0
1 15 0 4 -1 0
2 32 0 8 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 z1 f
0
6
1 7 0 6 -1 0
1 15 0 6 -1 0
2 32 0 8 0 6 -1 1
2 32 0 8 0 18 -1 0
1 7 0 18 -1 1
1 15 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 z1 tmp1
0
6
1 7 0 14 -1 0
1 15 0 14 -1 0
2 32 0 8 0 14 -1 1
2 32 0 8 0 23 -1 0
1 7 0 23 -1 1
1 15 0 23 -1 1
0
end_operator
begin_operator
and-gate tmp2 z1 r1
0
6
1 7 0 19 -1 0
1 15 0 19 -1 0
2 32 0 8 0 19 -1 1
2 32 0 8 0 27 -1 0
1 7 0 27 -1 1
1 15 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 z1 t
0
6
2 8 0 11 0 3 -1 0
1 7 0 3 -1 1
1 20 0 3 -1 1
1 7 0 4 -1 0
1 20 0 4 -1 0
2 8 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 z1 f
0
6
1 7 0 6 -1 0
1 20 0 6 -1 0
2 8 0 11 0 6 -1 1
2 8 0 11 0 18 -1 0
1 7 0 18 -1 1
1 20 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 z1 tmp1
0
6
1 7 0 14 -1 0
1 20 0 14 -1 0
2 8 0 11 0 14 -1 1
2 8 0 11 0 23 -1 0
1 7 0 23 -1 1
1 20 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 z1 tmp2
0
6
1 7 0 15 -1 0
1 20 0 15 -1 0
2 8 0 11 0 15 -1 1
2 8 0 11 0 32 -1 0
1 7 0 32 -1 1
1 20 0 32 -1 1
0
end_operator
begin_operator
and-gate x1 z1 r1
0
6
1 7 0 19 -1 0
1 20 0 19 -1 0
2 8 0 11 0 19 -1 1
2 8 0 11 0 27 -1 0
1 7 0 27 -1 1
1 20 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 z1 t
0
6
2 8 0 9 0 3 -1 0
1 7 0 3 -1 1
1 35 0 3 -1 1
1 7 0 4 -1 0
1 35 0 4 -1 0
2 8 0 9 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 z1 f
0
6
1 7 0 6 -1 0
1 35 0 6 -1 0
2 8 0 9 0 6 -1 1
2 8 0 9 0 18 -1 0
1 7 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 z1 tmp1
0
6
1 7 0 14 -1 0
1 35 0 14 -1 0
2 8 0 9 0 14 -1 1
2 8 0 9 0 23 -1 0
1 7 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 z1 tmp2
0
6
1 7 0 15 -1 0
1 35 0 15 -1 0
2 8 0 9 0 15 -1 1
2 8 0 9 0 32 -1 0
1 7 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 z1 r1
0
6
1 7 0 19 -1 0
1 35 0 19 -1 0
2 8 0 9 0 19 -1 1
2 8 0 9 0 27 -1 0
1 7 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate r1 z1 t
0
6
2 8 0 27 0 3 -1 0
1 7 0 3 -1 1
1 19 0 3 -1 1
1 7 0 4 -1 0
1 19 0 4 -1 0
2 8 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 z1 f
0
6
1 7 0 6 -1 0
1 19 0 6 -1 0
2 8 0 27 0 6 -1 1
2 8 0 27 0 18 -1 0
1 7 0 18 -1 1
1 19 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 z1 tmp1
0
6
1 7 0 14 -1 0
1 19 0 14 -1 0
2 8 0 27 0 14 -1 1
2 8 0 27 0 23 -1 0
1 7 0 23 -1 1
1 19 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 z1 tmp2
0
6
1 7 0 15 -1 0
1 19 0 15 -1 0
2 8 0 27 0 15 -1 1
2 8 0 27 0 32 -1 0
1 7 0 32 -1 1
1 19 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 f t
0
6
1 8 0 3 -1 0
1 18 0 3 -1 0
2 6 0 7 0 3 -1 1
2 6 0 7 0 4 -1 0
1 8 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 tmp1 t
0
6
1 8 0 3 -1 0
1 23 0 3 -1 0
2 14 0 7 0 3 -1 1
2 14 0 7 0 4 -1 0
1 8 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 tmp2 t
0
6
1 8 0 3 -1 0
1 32 0 3 -1 0
2 15 0 7 0 3 -1 1
2 15 0 7 0 4 -1 0
1 8 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 x1 t
0
6
1 8 0 3 -1 0
1 11 0 3 -1 0
2 20 0 7 0 3 -1 1
2 20 0 7 0 4 -1 0
1 8 0 4 -1 1
1 11 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 y1 t
0
6
1 8 0 3 -1 0
1 9 0 3 -1 0
2 35 0 7 0 3 -1 1
2 35 0 7 0 4 -1 0
1 8 0 4 -1 1
1 9 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 r1 t
0
6
1 8 0 3 -1 0
1 27 0 3 -1 0
2 19 0 7 0 3 -1 1
2 19 0 7 0 4 -1 0
1 8 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 t f
0
6
2 4 0 7 0 6 -1 0
1 3 0 6 -1 1
1 8 0 6 -1 1
1 3 0 18 -1 0
1 8 0 18 -1 0
2 4 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 tmp1 f
0
6
2 14 0 7 0 6 -1 0
1 8 0 6 -1 1
1 23 0 6 -1 1
1 8 0 18 -1 0
1 23 0 18 -1 0
2 14 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 tmp2 f
0
6
2 15 0 7 0 6 -1 0
1 8 0 6 -1 1
1 32 0 6 -1 1
1 8 0 18 -1 0
1 32 0 18 -1 0
2 15 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 x1 f
0
6
2 20 0 7 0 6 -1 0
1 8 0 6 -1 1
1 11 0 6 -1 1
1 8 0 18 -1 0
1 11 0 18 -1 0
2 20 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 y1 f
0
6
2 35 0 7 0 6 -1 0
1 8 0 6 -1 1
1 9 0 6 -1 1
1 8 0 18 -1 0
1 9 0 18 -1 0
2 35 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 r1 f
0
6
2 19 0 7 0 6 -1 0
1 8 0 6 -1 1
1 27 0 6 -1 1
1 8 0 18 -1 0
1 27 0 18 -1 0
2 19 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 t tmp1
0
6
2 4 0 7 0 14 -1 0
1 3 0 14 -1 1
1 8 0 14 -1 1
1 3 0 23 -1 0
1 8 0 23 -1 0
2 4 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 f tmp1
0
6
2 6 0 7 0 14 -1 0
1 8 0 14 -1 1
1 18 0 14 -1 1
1 8 0 23 -1 0
1 18 0 23 -1 0
2 6 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 tmp2 tmp1
0
6
2 15 0 7 0 14 -1 0
1 8 0 14 -1 1
1 32 0 14 -1 1
1 8 0 23 -1 0
1 32 0 23 -1 0
2 15 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 x1 tmp1
0
6
2 20 0 7 0 14 -1 0
1 8 0 14 -1 1
1 11 0 14 -1 1
1 8 0 23 -1 0
1 11 0 23 -1 0
2 20 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 y1 tmp1
0
6
2 35 0 7 0 14 -1 0
1 8 0 14 -1 1
1 9 0 14 -1 1
1 8 0 23 -1 0
1 9 0 23 -1 0
2 35 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 r1 tmp1
0
6
2 19 0 7 0 14 -1 0
1 8 0 14 -1 1
1 27 0 14 -1 1
1 8 0 23 -1 0
1 27 0 23 -1 0
2 19 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 t tmp2
0
6
2 4 0 7 0 15 -1 0
1 3 0 15 -1 1
1 8 0 15 -1 1
1 3 0 32 -1 0
1 8 0 32 -1 0
2 4 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 f tmp2
0
6
2 6 0 7 0 15 -1 0
1 8 0 15 -1 1
1 18 0 15 -1 1
1 8 0 32 -1 0
1 18 0 32 -1 0
2 6 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 tmp1 tmp2
0
6
2 14 0 7 0 15 -1 0
1 8 0 15 -1 1
1 23 0 15 -1 1
1 8 0 32 -1 0
1 23 0 32 -1 0
2 14 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 x1 tmp2
0
6
2 20 0 7 0 15 -1 0
1 8 0 15 -1 1
1 11 0 15 -1 1
1 8 0 32 -1 0
1 11 0 32 -1 0
2 20 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 y1 tmp2
0
6
2 35 0 7 0 15 -1 0
1 8 0 15 -1 1
1 9 0 15 -1 1
1 8 0 32 -1 0
1 9 0 32 -1 0
2 35 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 r1 tmp2
0
6
2 19 0 7 0 15 -1 0
1 8 0 15 -1 1
1 27 0 15 -1 1
1 8 0 32 -1 0
1 27 0 32 -1 0
2 19 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 t r1
0
6
2 4 0 7 0 19 -1 0
1 3 0 19 -1 1
1 8 0 19 -1 1
1 3 0 27 -1 0
1 8 0 27 -1 0
2 4 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z1 f r1
0
6
2 6 0 7 0 19 -1 0
1 8 0 19 -1 1
1 18 0 19 -1 1
1 8 0 27 -1 0
1 18 0 27 -1 0
2 6 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z1 tmp1 r1
0
6
2 14 0 7 0 19 -1 0
1 8 0 19 -1 1
1 23 0 19 -1 1
1 8 0 27 -1 0
1 23 0 27 -1 0
2 14 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z1 tmp2 r1
0
6
2 15 0 7 0 19 -1 0
1 8 0 19 -1 1
1 32 0 19 -1 1
1 8 0 27 -1 0
1 32 0 27 -1 0
2 15 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z1 x1 r1
0
6
2 20 0 7 0 19 -1 0
1 8 0 19 -1 1
1 11 0 19 -1 1
1 8 0 27 -1 0
1 11 0 27 -1 0
2 20 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z1 y1 r1
0
6
2 35 0 7 0 19 -1 0
1 8 0 19 -1 1
1 9 0 19 -1 1
1 8 0 27 -1 0
1 9 0 27 -1 0
2 35 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate t f z1
0
6
2 4 0 6 0 7 -1 0
1 3 0 7 -1 1
1 18 0 7 -1 1
1 3 0 8 -1 0
1 18 0 8 -1 0
2 4 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate t tmp1 z1
0
6
2 4 0 14 0 7 -1 0
1 3 0 7 -1 1
1 23 0 7 -1 1
1 3 0 8 -1 0
1 23 0 8 -1 0
2 4 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate t tmp2 z1
0
6
2 4 0 15 0 7 -1 0
1 3 0 7 -1 1
1 32 0 7 -1 1
1 3 0 8 -1 0
1 32 0 8 -1 0
2 4 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate t x1 z1
0
6
2 20 0 4 0 7 -1 0
1 3 0 7 -1 1
1 11 0 7 -1 1
1 3 0 8 -1 0
1 11 0 8 -1 0
2 20 0 4 0 8 -1 1
0
end_operator
begin_operator
or-gate t y1 z1
0
6
2 35 0 4 0 7 -1 0
1 3 0 7 -1 1
1 9 0 7 -1 1
1 3 0 8 -1 0
1 9 0 8 -1 0
2 35 0 4 0 8 -1 1
0
end_operator
begin_operator
or-gate t r1 z1
0
6
2 19 0 4 0 7 -1 0
1 3 0 7 -1 1
1 27 0 7 -1 1
1 3 0 8 -1 0
1 27 0 8 -1 0
2 19 0 4 0 8 -1 1
0
end_operator
begin_operator
or-gate f t z1
0
6
2 4 0 6 0 7 -1 0
1 3 0 7 -1 1
1 18 0 7 -1 1
1 3 0 8 -1 0
1 18 0 8 -1 0
2 4 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate f tmp1 z1
0
6
2 14 0 6 0 7 -1 0
1 18 0 7 -1 1
1 23 0 7 -1 1
1 18 0 8 -1 0
1 23 0 8 -1 0
2 14 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate f tmp2 z1
0
6
2 6 0 15 0 7 -1 0
1 18 0 7 -1 1
1 32 0 7 -1 1
1 18 0 8 -1 0
1 32 0 8 -1 0
2 6 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate f x1 z1
0
6
2 20 0 6 0 7 -1 0
1 11 0 7 -1 1
1 18 0 7 -1 1
1 11 0 8 -1 0
1 18 0 8 -1 0
2 20 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate f y1 z1
0
6
2 35 0 6 0 7 -1 0
1 9 0 7 -1 1
1 18 0 7 -1 1
1 9 0 8 -1 0
1 18 0 8 -1 0
2 35 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate f r1 z1
0
6
2 19 0 6 0 7 -1 0
1 18 0 7 -1 1
1 27 0 7 -1 1
1 18 0 8 -1 0
1 27 0 8 -1 0
2 19 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 t z1
0
6
2 4 0 14 0 7 -1 0
1 3 0 7 -1 1
1 23 0 7 -1 1
1 3 0 8 -1 0
1 23 0 8 -1 0
2 4 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 f z1
0
6
2 6 0 14 0 7 -1 0
1 18 0 7 -1 1
1 23 0 7 -1 1
1 18 0 8 -1 0
1 23 0 8 -1 0
2 6 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 tmp2 z1
0
6
2 14 0 15 0 7 -1 0
1 23 0 7 -1 1
1 32 0 7 -1 1
1 23 0 8 -1 0
1 32 0 8 -1 0
2 14 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 z1
0
6
2 20 0 14 0 7 -1 0
1 11 0 7 -1 1
1 23 0 7 -1 1
1 11 0 8 -1 0
1 23 0 8 -1 0
2 20 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 z1
0
6
2 35 0 14 0 7 -1 0
1 9 0 7 -1 1
1 23 0 7 -1 1
1 9 0 8 -1 0
1 23 0 8 -1 0
2 35 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 r1 z1
0
6
2 19 0 14 0 7 -1 0
1 23 0 7 -1 1
1 27 0 7 -1 1
1 23 0 8 -1 0
1 27 0 8 -1 0
2 19 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 t z1
0
6
2 4 0 15 0 7 -1 0
1 3 0 7 -1 1
1 32 0 7 -1 1
1 3 0 8 -1 0
1 32 0 8 -1 0
2 4 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 f z1
0
6
2 6 0 15 0 7 -1 0
1 18 0 7 -1 1
1 32 0 7 -1 1
1 18 0 8 -1 0
1 32 0 8 -1 0
2 6 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 tmp1 z1
0
6
2 14 0 15 0 7 -1 0
1 23 0 7 -1 1
1 32 0 7 -1 1
1 23 0 8 -1 0
1 32 0 8 -1 0
2 14 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 z1
0
6
2 20 0 15 0 7 -1 0
1 11 0 7 -1 1
1 32 0 7 -1 1
1 11 0 8 -1 0
1 32 0 8 -1 0
2 20 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 z1
0
6
2 35 0 15 0 7 -1 0
1 9 0 7 -1 1
1 32 0 7 -1 1
1 9 0 8 -1 0
1 32 0 8 -1 0
2 35 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 r1 z1
0
6
2 19 0 15 0 7 -1 0
1 27 0 7 -1 1
1 32 0 7 -1 1
1 27 0 8 -1 0
1 32 0 8 -1 0
2 19 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 t z1
0
6
2 4 0 20 0 7 -1 0
1 3 0 7 -1 1
1 11 0 7 -1 1
1 3 0 8 -1 0
1 11 0 8 -1 0
2 4 0 20 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 f z1
0
6
2 20 0 6 0 7 -1 0
1 11 0 7 -1 1
1 18 0 7 -1 1
1 11 0 8 -1 0
1 18 0 8 -1 0
2 20 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 z1
0
6
2 20 0 14 0 7 -1 0
1 11 0 7 -1 1
1 23 0 7 -1 1
1 11 0 8 -1 0
1 23 0 8 -1 0
2 20 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 z1
0
6
2 20 0 15 0 7 -1 0
1 11 0 7 -1 1
1 32 0 7 -1 1
1 11 0 8 -1 0
1 32 0 8 -1 0
2 20 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 y1 z1
0
6
2 35 0 20 0 7 -1 0
1 9 0 7 -1 1
1 11 0 7 -1 1
1 9 0 8 -1 0
1 11 0 8 -1 0
2 35 0 20 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 r1 z1
0
6
2 19 0 20 0 7 -1 0
1 11 0 7 -1 1
1 27 0 7 -1 1
1 11 0 8 -1 0
1 27 0 8 -1 0
2 19 0 20 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 t z1
0
6
2 35 0 4 0 7 -1 0
1 3 0 7 -1 1
1 9 0 7 -1 1
1 3 0 8 -1 0
1 9 0 8 -1 0
2 35 0 4 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 f z1
0
6
2 35 0 6 0 7 -1 0
1 9 0 7 -1 1
1 18 0 7 -1 1
1 9 0 8 -1 0
1 18 0 8 -1 0
2 35 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 z1
0
6
2 35 0 14 0 7 -1 0
1 9 0 7 -1 1
1 23 0 7 -1 1
1 9 0 8 -1 0
1 23 0 8 -1 0
2 35 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 z1
0
6
2 35 0 15 0 7 -1 0
1 9 0 7 -1 1
1 32 0 7 -1 1
1 9 0 8 -1 0
1 32 0 8 -1 0
2 35 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 x1 z1
0
6
2 35 0 20 0 7 -1 0
1 9 0 7 -1 1
1 11 0 7 -1 1
1 9 0 8 -1 0
1 11 0 8 -1 0
2 35 0 20 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 r1 z1
0
6
2 19 0 35 0 7 -1 0
1 9 0 7 -1 1
1 27 0 7 -1 1
1 9 0 8 -1 0
1 27 0 8 -1 0
2 19 0 35 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 t z1
0
6
2 19 0 4 0 7 -1 0
1 3 0 7 -1 1
1 27 0 7 -1 1
1 3 0 8 -1 0
1 27 0 8 -1 0
2 19 0 4 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 f z1
0
6
2 19 0 6 0 7 -1 0
1 18 0 7 -1 1
1 27 0 7 -1 1
1 18 0 8 -1 0
1 27 0 8 -1 0
2 19 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 tmp1 z1
0
6
2 19 0 14 0 7 -1 0
1 23 0 7 -1 1
1 27 0 7 -1 1
1 23 0 8 -1 0
1 27 0 8 -1 0
2 19 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 tmp2 z1
0
6
2 19 0 15 0 7 -1 0
1 27 0 7 -1 1
1 32 0 7 -1 1
1 27 0 8 -1 0
1 32 0 8 -1 0
2 19 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 x1 z1
0
6
2 19 0 20 0 7 -1 0
1 11 0 7 -1 1
1 27 0 7 -1 1
1 11 0 8 -1 0
1 27 0 8 -1 0
2 19 0 20 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 y1 z1
0
6
2 35 0 19 0 7 -1 0
1 9 0 7 -1 1
1 27 0 7 -1 1
1 9 0 8 -1 0
1 27 0 8 -1 0
2 35 0 19 0 8 -1 1
0
end_operator
begin_operator
or-gate t z1 f
0
6
2 4 0 7 0 6 -1 0
1 3 0 6 -1 1
1 8 0 6 -1 1
1 3 0 18 -1 0
1 8 0 18 -1 0
2 4 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate t z1 tmp1
0
6
2 4 0 7 0 14 -1 0
1 3 0 14 -1 1
1 8 0 14 -1 1
1 3 0 23 -1 0
1 8 0 23 -1 0
2 4 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate t z1 tmp2
0
6
2 4 0 7 0 15 -1 0
1 3 0 15 -1 1
1 8 0 15 -1 1
1 3 0 32 -1 0
1 8 0 32 -1 0
2 4 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate t z1 r1
0
6
2 4 0 7 0 19 -1 0
1 3 0 19 -1 1
1 8 0 19 -1 1
1 3 0 27 -1 0
1 8 0 27 -1 0
2 4 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate f z1 t
0
6
1 8 0 3 -1 0
1 18 0 3 -1 0
2 6 0 7 0 3 -1 1
2 6 0 7 0 4 -1 0
1 8 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate f z1 tmp1
0
6
2 6 0 7 0 14 -1 0
1 8 0 14 -1 1
1 18 0 14 -1 1
1 8 0 23 -1 0
1 18 0 23 -1 0
2 6 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate f z1 tmp2
0
6
2 6 0 7 0 15 -1 0
1 8 0 15 -1 1
1 18 0 15 -1 1
1 8 0 32 -1 0
1 18 0 32 -1 0
2 6 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate f z1 r1
0
6
2 6 0 7 0 19 -1 0
1 8 0 19 -1 1
1 18 0 19 -1 1
1 8 0 27 -1 0
1 18 0 27 -1 0
2 6 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 z1 t
0
6
1 8 0 3 -1 0
1 23 0 3 -1 0
2 14 0 7 0 3 -1 1
2 14 0 7 0 4 -1 0
1 8 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 z1 f
0
6
2 14 0 7 0 6 -1 0
1 8 0 6 -1 1
1 23 0 6 -1 1
1 8 0 18 -1 0
1 23 0 18 -1 0
2 14 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp1 z1 tmp2
0
6
2 14 0 7 0 15 -1 0
1 8 0 15 -1 1
1 23 0 15 -1 1
1 8 0 32 -1 0
1 23 0 32 -1 0
2 14 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 z1 r1
0
6
2 14 0 7 0 19 -1 0
1 8 0 19 -1 1
1 23 0 19 -1 1
1 8 0 27 -1 0
1 23 0 27 -1 0
2 14 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 z1 t
0
6
1 8 0 3 -1 0
1 32 0 3 -1 0
2 7 0 15 0 3 -1 1
2 7 0 15 0 4 -1 0
1 8 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 z1 f
0
6
2 7 0 15 0 6 -1 0
1 8 0 6 -1 1
1 32 0 6 -1 1
1 8 0 18 -1 0
1 32 0 18 -1 0
2 7 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 z1 tmp1
0
6
2 7 0 15 0 14 -1 0
1 8 0 14 -1 1
1 32 0 14 -1 1
1 8 0 23 -1 0
1 32 0 23 -1 0
2 7 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate tmp2 z1 r1
0
6
2 7 0 15 0 19 -1 0
1 8 0 19 -1 1
1 32 0 19 -1 1
1 8 0 27 -1 0
1 32 0 27 -1 0
2 7 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 z1 t
0
6
1 8 0 3 -1 0
1 11 0 3 -1 0
2 20 0 7 0 3 -1 1
2 20 0 7 0 4 -1 0
1 8 0 4 -1 1
1 11 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 z1 f
0
6
2 20 0 7 0 6 -1 0
1 8 0 6 -1 1
1 11 0 6 -1 1
1 8 0 18 -1 0
1 11 0 18 -1 0
2 20 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 z1 tmp1
0
6
2 20 0 7 0 14 -1 0
1 8 0 14 -1 1
1 11 0 14 -1 1
1 8 0 23 -1 0
1 11 0 23 -1 0
2 20 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 z1 tmp2
0
6
2 20 0 7 0 15 -1 0
1 8 0 15 -1 1
1 11 0 15 -1 1
1 8 0 32 -1 0
1 11 0 32 -1 0
2 20 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate x1 z1 r1
0
6
2 20 0 7 0 19 -1 0
1 8 0 19 -1 1
1 11 0 19 -1 1
1 8 0 27 -1 0
1 11 0 27 -1 0
2 20 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 z1 t
0
6
1 8 0 3 -1 0
1 9 0 3 -1 0
2 35 0 7 0 3 -1 1
2 35 0 7 0 4 -1 0
1 8 0 4 -1 1
1 9 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 z1 f
0
6
2 35 0 7 0 6 -1 0
1 8 0 6 -1 1
1 9 0 6 -1 1
1 8 0 18 -1 0
1 9 0 18 -1 0
2 35 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 z1 tmp1
0
6
2 35 0 7 0 14 -1 0
1 8 0 14 -1 1
1 9 0 14 -1 1
1 8 0 23 -1 0
1 9 0 23 -1 0
2 35 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 z1 tmp2
0
6
2 35 0 7 0 15 -1 0
1 8 0 15 -1 1
1 9 0 15 -1 1
1 8 0 32 -1 0
1 9 0 32 -1 0
2 35 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 z1 r1
0
6
2 35 0 7 0 19 -1 0
1 8 0 19 -1 1
1 9 0 19 -1 1
1 8 0 27 -1 0
1 9 0 27 -1 0
2 35 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate r1 z1 t
0
6
1 8 0 3 -1 0
1 27 0 3 -1 0
2 19 0 7 0 3 -1 1
2 19 0 7 0 4 -1 0
1 8 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 z1 f
0
6
2 19 0 7 0 6 -1 0
1 8 0 6 -1 1
1 27 0 6 -1 1
1 8 0 18 -1 0
1 27 0 18 -1 0
2 19 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 z1 tmp1
0
6
2 19 0 7 0 14 -1 0
1 8 0 14 -1 1
1 27 0 14 -1 1
1 8 0 23 -1 0
1 27 0 23 -1 0
2 19 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 z1 tmp2
0
6
2 19 0 7 0 15 -1 0
1 8 0 15 -1 1
1 27 0 15 -1 1
1 8 0 32 -1 0
1 27 0 32 -1 0
2 19 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 f t
0
8
2 8 0 6 0 3 -1 0
2 18 0 7 0 3 -1 0
2 6 0 7 0 3 -1 1
2 8 0 18 0 3 -1 1
2 6 0 7 0 4 -1 0
2 8 0 18 0 4 -1 0
2 8 0 6 0 4 -1 1
2 18 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp1 t
0
8
2 8 0 14 0 3 -1 0
2 23 0 7 0 3 -1 0
2 8 0 23 0 3 -1 1
2 14 0 7 0 3 -1 1
2 8 0 23 0 4 -1 0
2 14 0 7 0 4 -1 0
2 8 0 14 0 4 -1 1
2 23 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp2 t
0
8
2 8 0 15 0 3 -1 0
2 32 0 7 0 3 -1 0
2 8 0 32 0 3 -1 1
2 15 0 7 0 3 -1 1
2 8 0 32 0 4 -1 0
2 15 0 7 0 4 -1 0
2 8 0 15 0 4 -1 1
2 32 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 t
0
8
2 8 0 20 0 3 -1 0
2 11 0 7 0 3 -1 0
2 8 0 11 0 3 -1 1
2 20 0 7 0 3 -1 1
2 8 0 11 0 4 -1 0
2 20 0 7 0 4 -1 0
2 8 0 20 0 4 -1 1
2 11 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 t
0
8
2 8 0 35 0 3 -1 0
2 9 0 7 0 3 -1 0
2 8 0 9 0 3 -1 1
2 35 0 7 0 3 -1 1
2 8 0 9 0 4 -1 0
2 35 0 7 0 4 -1 0
2 8 0 35 0 4 -1 1
2 9 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 r1 t
0
8
2 8 0 19 0 3 -1 0
2 27 0 7 0 3 -1 0
2 8 0 27 0 3 -1 1
2 19 0 7 0 3 -1 1
2 8 0 27 0 4 -1 0
2 19 0 7 0 4 -1 0
2 8 0 19 0 4 -1 1
2 27 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 t f
0
8
2 4 0 7 0 6 -1 0
2 8 0 3 0 6 -1 0
2 3 0 7 0 6 -1 1
2 8 0 4 0 6 -1 1
2 3 0 7 0 18 -1 0
2 8 0 4 0 18 -1 0
2 4 0 7 0 18 -1 1
2 8 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp1 f
0
8
2 8 0 23 0 6 -1 0
2 14 0 7 0 6 -1 0
2 8 0 14 0 6 -1 1
2 23 0 7 0 6 -1 1
2 8 0 14 0 18 -1 0
2 23 0 7 0 18 -1 0
2 8 0 23 0 18 -1 1
2 14 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp2 f
0
8
2 8 0 32 0 6 -1 0
2 15 0 7 0 6 -1 0
2 8 0 15 0 6 -1 1
2 32 0 7 0 6 -1 1
2 8 0 15 0 18 -1 0
2 32 0 7 0 18 -1 0
2 8 0 32 0 18 -1 1
2 15 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 f
0
8
2 8 0 11 0 6 -1 0
2 20 0 7 0 6 -1 0
2 8 0 20 0 6 -1 1
2 11 0 7 0 6 -1 1
2 8 0 20 0 18 -1 0
2 11 0 7 0 18 -1 0
2 8 0 11 0 18 -1 1
2 20 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 f
0
8
2 8 0 9 0 6 -1 0
2 35 0 7 0 6 -1 0
2 8 0 35 0 6 -1 1
2 9 0 7 0 6 -1 1
2 8 0 35 0 18 -1 0
2 9 0 7 0 18 -1 0
2 8 0 9 0 18 -1 1
2 35 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 r1 f
0
8
2 8 0 27 0 6 -1 0
2 19 0 7 0 6 -1 0
2 8 0 19 0 6 -1 1
2 27 0 7 0 6 -1 1
2 8 0 19 0 18 -1 0
2 27 0 7 0 18 -1 0
2 8 0 27 0 18 -1 1
2 19 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 t tmp1
0
8
2 4 0 7 0 14 -1 0
2 8 0 3 0 14 -1 0
2 3 0 7 0 14 -1 1
2 8 0 4 0 14 -1 1
2 3 0 7 0 23 -1 0
2 8 0 4 0 23 -1 0
2 4 0 7 0 23 -1 1
2 8 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 f tmp1
0
8
2 6 0 7 0 14 -1 0
2 8 0 18 0 14 -1 0
2 8 0 6 0 14 -1 1
2 18 0 7 0 14 -1 1
2 8 0 6 0 23 -1 0
2 18 0 7 0 23 -1 0
2 6 0 7 0 23 -1 1
2 8 0 18 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp2 tmp1
0
8
2 8 0 32 0 14 -1 0
2 15 0 7 0 14 -1 0
2 8 0 15 0 14 -1 1
2 32 0 7 0 14 -1 1
2 8 0 15 0 23 -1 0
2 32 0 7 0 23 -1 0
2 8 0 32 0 23 -1 1
2 15 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 tmp1
0
8
2 8 0 11 0 14 -1 0
2 20 0 7 0 14 -1 0
2 8 0 20 0 14 -1 1
2 11 0 7 0 14 -1 1
2 8 0 20 0 23 -1 0
2 11 0 7 0 23 -1 0
2 8 0 11 0 23 -1 1
2 20 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 tmp1
0
8
2 8 0 9 0 14 -1 0
2 35 0 7 0 14 -1 0
2 8 0 35 0 14 -1 1
2 9 0 7 0 14 -1 1
2 8 0 35 0 23 -1 0
2 9 0 7 0 23 -1 0
2 8 0 9 0 23 -1 1
2 35 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 r1 tmp1
0
8
2 8 0 27 0 14 -1 0
2 19 0 7 0 14 -1 0
2 8 0 19 0 14 -1 1
2 27 0 7 0 14 -1 1
2 8 0 19 0 23 -1 0
2 27 0 7 0 23 -1 0
2 8 0 27 0 23 -1 1
2 19 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 t tmp2
0
8
2 4 0 7 0 15 -1 0
2 8 0 3 0 15 -1 0
2 3 0 7 0 15 -1 1
2 8 0 4 0 15 -1 1
2 3 0 7 0 32 -1 0
2 8 0 4 0 32 -1 0
2 4 0 7 0 32 -1 1
2 8 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 f tmp2
0
8
2 6 0 7 0 15 -1 0
2 8 0 18 0 15 -1 0
2 8 0 6 0 15 -1 1
2 18 0 7 0 15 -1 1
2 8 0 6 0 32 -1 0
2 18 0 7 0 32 -1 0
2 6 0 7 0 32 -1 1
2 8 0 18 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp1 tmp2
0
8
2 8 0 23 0 15 -1 0
2 14 0 7 0 15 -1 0
2 8 0 14 0 15 -1 1
2 23 0 7 0 15 -1 1
2 8 0 14 0 32 -1 0
2 23 0 7 0 32 -1 0
2 8 0 23 0 32 -1 1
2 14 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 tmp2
0
8
2 8 0 11 0 15 -1 0
2 20 0 7 0 15 -1 0
2 8 0 20 0 15 -1 1
2 11 0 7 0 15 -1 1
2 8 0 20 0 32 -1 0
2 11 0 7 0 32 -1 0
2 8 0 11 0 32 -1 1
2 20 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 tmp2
0
8
2 8 0 9 0 15 -1 0
2 35 0 7 0 15 -1 0
2 8 0 35 0 15 -1 1
2 9 0 7 0 15 -1 1
2 8 0 35 0 32 -1 0
2 9 0 7 0 32 -1 0
2 8 0 9 0 32 -1 1
2 35 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 r1 tmp2
0
8
2 8 0 27 0 15 -1 0
2 19 0 7 0 15 -1 0
2 8 0 19 0 15 -1 1
2 27 0 7 0 15 -1 1
2 8 0 19 0 32 -1 0
2 27 0 7 0 32 -1 0
2 8 0 27 0 32 -1 1
2 19 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 t r1
0
8
2 4 0 7 0 19 -1 0
2 8 0 3 0 19 -1 0
2 3 0 7 0 19 -1 1
2 8 0 4 0 19 -1 1
2 3 0 7 0 27 -1 0
2 8 0 4 0 27 -1 0
2 4 0 7 0 27 -1 1
2 8 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate z1 f r1
0
8
2 6 0 7 0 19 -1 0
2 8 0 18 0 19 -1 0
2 8 0 6 0 19 -1 1
2 18 0 7 0 19 -1 1
2 8 0 6 0 27 -1 0
2 18 0 7 0 27 -1 0
2 6 0 7 0 27 -1 1
2 8 0 18 0 27 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp1 r1
0
8
2 8 0 23 0 19 -1 0
2 14 0 7 0 19 -1 0
2 8 0 14 0 19 -1 1
2 23 0 7 0 19 -1 1
2 8 0 14 0 27 -1 0
2 23 0 7 0 27 -1 0
2 8 0 23 0 27 -1 1
2 14 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp2 r1
0
8
2 8 0 32 0 19 -1 0
2 15 0 7 0 19 -1 0
2 8 0 15 0 19 -1 1
2 32 0 7 0 19 -1 1
2 8 0 15 0 27 -1 0
2 32 0 7 0 27 -1 0
2 8 0 32 0 27 -1 1
2 15 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 r1
0
8
2 8 0 11 0 19 -1 0
2 20 0 7 0 19 -1 0
2 8 0 20 0 19 -1 1
2 11 0 7 0 19 -1 1
2 8 0 20 0 27 -1 0
2 11 0 7 0 27 -1 0
2 8 0 11 0 27 -1 1
2 20 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 r1
0
8
2 8 0 9 0 19 -1 0
2 35 0 7 0 19 -1 0
2 8 0 35 0 19 -1 1
2 9 0 7 0 19 -1 1
2 8 0 35 0 27 -1 0
2 9 0 7 0 27 -1 0
2 8 0 9 0 27 -1 1
2 35 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate t f z1
0
8
2 4 0 6 0 7 -1 0
2 18 0 3 0 7 -1 0
2 3 0 6 0 7 -1 1
2 18 0 4 0 7 -1 1
2 3 0 6 0 8 -1 0
2 18 0 4 0 8 -1 0
2 4 0 6 0 8 -1 1
2 18 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate t tmp1 z1
0
8
2 3 0 23 0 7 -1 0
2 4 0 14 0 7 -1 0
2 3 0 14 0 7 -1 1
2 4 0 23 0 7 -1 1
2 3 0 14 0 8 -1 0
2 4 0 23 0 8 -1 0
2 3 0 23 0 8 -1 1
2 4 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate t tmp2 z1
0
8
2 4 0 15 0 7 -1 0
2 32 0 3 0 7 -1 0
2 3 0 15 0 7 -1 1
2 32 0 4 0 7 -1 1
2 3 0 15 0 8 -1 0
2 32 0 4 0 8 -1 0
2 4 0 15 0 8 -1 1
2 32 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate t x1 z1
0
8
2 11 0 3 0 7 -1 0
2 20 0 4 0 7 -1 0
2 3 0 20 0 7 -1 1
2 11 0 4 0 7 -1 1
2 3 0 20 0 8 -1 0
2 11 0 4 0 8 -1 0
2 11 0 3 0 8 -1 1
2 20 0 4 0 8 -1 1
0
end_operator
begin_operator
xor-gate t y1 z1
0
8
2 9 0 3 0 7 -1 0
2 35 0 4 0 7 -1 0
2 9 0 4 0 7 -1 1
2 35 0 3 0 7 -1 1
2 9 0 4 0 8 -1 0
2 35 0 3 0 8 -1 0
2 9 0 3 0 8 -1 1
2 35 0 4 0 8 -1 1
0
end_operator
begin_operator
xor-gate t r1 z1
0
8
2 19 0 4 0 7 -1 0
2 27 0 3 0 7 -1 0
2 19 0 3 0 7 -1 1
2 27 0 4 0 7 -1 1
2 19 0 3 0 8 -1 0
2 27 0 4 0 8 -1 0
2 19 0 4 0 8 -1 1
2 27 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate f t z1
0
8
2 4 0 6 0 7 -1 0
2 18 0 3 0 7 -1 0
2 3 0 6 0 7 -1 1
2 18 0 4 0 7 -1 1
2 3 0 6 0 8 -1 0
2 18 0 4 0 8 -1 0
2 4 0 6 0 8 -1 1
2 18 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate f tmp1 z1
0
8
2 14 0 6 0 7 -1 0
2 18 0 23 0 7 -1 0
2 6 0 23 0 7 -1 1
2 18 0 14 0 7 -1 1
2 6 0 23 0 8 -1 0
2 18 0 14 0 8 -1 0
2 14 0 6 0 8 -1 1
2 18 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate f tmp2 z1
0
8
2 6 0 15 0 7 -1 0
2 32 0 18 0 7 -1 0
2 18 0 15 0 7 -1 1
2 32 0 6 0 7 -1 1
2 18 0 15 0 8 -1 0
2 32 0 6 0 8 -1 0
2 6 0 15 0 8 -1 1
2 32 0 18 0 8 -1 1
0
end_operator
begin_operator
xor-gate f x1 z1
0
8
2 18 0 11 0 7 -1 0
2 20 0 6 0 7 -1 0
2 11 0 6 0 7 -1 1
2 18 0 20 0 7 -1 1
2 11 0 6 0 8 -1 0
2 18 0 20 0 8 -1 0
2 18 0 11 0 8 -1 1
2 20 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate f y1 z1
0
8
2 9 0 18 0 7 -1 0
2 35 0 6 0 7 -1 0
2 9 0 6 0 7 -1 1
2 18 0 35 0 7 -1 1
2 9 0 6 0 8 -1 0
2 18 0 35 0 8 -1 0
2 9 0 18 0 8 -1 1
2 35 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate f r1 z1
0
8
2 18 0 27 0 7 -1 0
2 19 0 6 0 7 -1 0
2 18 0 19 0 7 -1 1
2 27 0 6 0 7 -1 1
2 18 0 19 0 8 -1 0
2 27 0 6 0 8 -1 0
2 18 0 27 0 8 -1 1
2 19 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 t z1
0
8
2 3 0 23 0 7 -1 0
2 4 0 14 0 7 -1 0
2 3 0 14 0 7 -1 1
2 4 0 23 0 7 -1 1
2 3 0 14 0 8 -1 0
2 4 0 23 0 8 -1 0
2 3 0 23 0 8 -1 1
2 4 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 f z1
0
8
2 6 0 14 0 7 -1 0
2 18 0 23 0 7 -1 0
2 6 0 23 0 7 -1 1
2 18 0 14 0 7 -1 1
2 6 0 23 0 8 -1 0
2 18 0 14 0 8 -1 0
2 6 0 14 0 8 -1 1
2 18 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 tmp2 z1
0
8
2 14 0 15 0 7 -1 0
2 32 0 23 0 7 -1 0
2 15 0 23 0 7 -1 1
2 32 0 14 0 7 -1 1
2 15 0 23 0 8 -1 0
2 32 0 14 0 8 -1 0
2 14 0 15 0 8 -1 1
2 32 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 z1
0
8
2 11 0 23 0 7 -1 0
2 20 0 14 0 7 -1 0
2 11 0 14 0 7 -1 1
2 20 0 23 0 7 -1 1
2 11 0 14 0 8 -1 0
2 20 0 23 0 8 -1 0
2 11 0 23 0 8 -1 1
2 20 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 z1
0
8
2 9 0 23 0 7 -1 0
2 35 0 14 0 7 -1 0
2 9 0 14 0 7 -1 1
2 35 0 23 0 7 -1 1
2 9 0 14 0 8 -1 0
2 35 0 23 0 8 -1 0
2 9 0 23 0 8 -1 1
2 35 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r1 z1
0
8
2 19 0 14 0 7 -1 0
2 27 0 23 0 7 -1 0
2 19 0 23 0 7 -1 1
2 27 0 14 0 7 -1 1
2 19 0 23 0 8 -1 0
2 27 0 14 0 8 -1 0
2 19 0 14 0 8 -1 1
2 27 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 t z1
0
8
2 4 0 15 0 7 -1 0
2 32 0 3 0 7 -1 0
2 3 0 15 0 7 -1 1
2 32 0 4 0 7 -1 1
2 3 0 15 0 8 -1 0
2 32 0 4 0 8 -1 0
2 4 0 15 0 8 -1 1
2 32 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 f z1
0
8
2 6 0 15 0 7 -1 0
2 32 0 18 0 7 -1 0
2 18 0 15 0 7 -1 1
2 32 0 6 0 7 -1 1
2 18 0 15 0 8 -1 0
2 32 0 6 0 8 -1 0
2 6 0 15 0 8 -1 1
2 32 0 18 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 tmp1 z1
0
8
2 14 0 15 0 7 -1 0
2 32 0 23 0 7 -1 0
2 23 0 15 0 7 -1 1
2 32 0 14 0 7 -1 1
2 23 0 15 0 8 -1 0
2 32 0 14 0 8 -1 0
2 14 0 15 0 8 -1 1
2 32 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 z1
0
8
2 20 0 15 0 7 -1 0
2 32 0 11 0 7 -1 0
2 11 0 15 0 7 -1 1
2 32 0 20 0 7 -1 1
2 11 0 15 0 8 -1 0
2 32 0 20 0 8 -1 0
2 20 0 15 0 8 -1 1
2 32 0 11 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 z1
0
8
2 32 0 9 0 7 -1 0
2 35 0 15 0 7 -1 0
2 9 0 15 0 7 -1 1
2 32 0 35 0 7 -1 1
2 9 0 15 0 8 -1 0
2 32 0 35 0 8 -1 0
2 32 0 9 0 8 -1 1
2 35 0 15 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r1 z1
0
8
2 19 0 15 0 7 -1 0
2 32 0 27 0 7 -1 0
2 27 0 15 0 7 -1 1
2 32 0 19 0 7 -1 1
2 27 0 15 0 8 -1 0
2 32 0 19 0 8 -1 0
2 19 0 15 0 8 -1 1
2 32 0 27 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 t z1
0
8
2 3 0 11 0 7 -1 0
2 4 0 20 0 7 -1 0
2 3 0 20 0 7 -1 1
2 11 0 4 0 7 -1 1
2 3 0 20 0 8 -1 0
2 11 0 4 0 8 -1 0
2 3 0 11 0 8 -1 1
2 4 0 20 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 f z1
0
8
2 18 0 11 0 7 -1 0
2 20 0 6 0 7 -1 0
2 11 0 6 0 7 -1 1
2 18 0 20 0 7 -1 1
2 11 0 6 0 8 -1 0
2 18 0 20 0 8 -1 0
2 18 0 11 0 8 -1 1
2 20 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 z1
0
8
2 11 0 23 0 7 -1 0
2 20 0 14 0 7 -1 0
2 11 0 14 0 7 -1 1
2 20 0 23 0 7 -1 1
2 11 0 14 0 8 -1 0
2 20 0 23 0 8 -1 0
2 11 0 23 0 8 -1 1
2 20 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 z1
0
8
2 20 0 15 0 7 -1 0
2 32 0 11 0 7 -1 0
2 11 0 15 0 7 -1 1
2 32 0 20 0 7 -1 1
2 11 0 15 0 8 -1 0
2 32 0 20 0 8 -1 0
2 20 0 15 0 8 -1 1
2 32 0 11 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 z1
0
8
2 9 0 11 0 7 -1 0
2 35 0 20 0 7 -1 0
2 9 0 20 0 7 -1 1
2 35 0 11 0 7 -1 1
2 9 0 20 0 8 -1 0
2 35 0 11 0 8 -1 0
2 9 0 11 0 8 -1 1
2 35 0 20 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 z1
0
8
2 19 0 20 0 7 -1 0
2 27 0 11 0 7 -1 0
2 19 0 11 0 7 -1 1
2 27 0 20 0 7 -1 1
2 19 0 11 0 8 -1 0
2 27 0 20 0 8 -1 0
2 19 0 20 0 8 -1 1
2 27 0 11 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 t z1
0
8
2 9 0 3 0 7 -1 0
2 35 0 4 0 7 -1 0
2 3 0 35 0 7 -1 1
2 9 0 4 0 7 -1 1
2 3 0 35 0 8 -1 0
2 9 0 4 0 8 -1 0
2 9 0 3 0 8 -1 1
2 35 0 4 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 f z1
0
8
2 9 0 18 0 7 -1 0
2 35 0 6 0 7 -1 0
2 9 0 6 0 7 -1 1
2 18 0 35 0 7 -1 1
2 9 0 6 0 8 -1 0
2 18 0 35 0 8 -1 0
2 9 0 18 0 8 -1 1
2 35 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 z1
0
8
2 9 0 23 0 7 -1 0
2 35 0 14 0 7 -1 0
2 9 0 14 0 7 -1 1
2 35 0 23 0 7 -1 1
2 9 0 14 0 8 -1 0
2 35 0 23 0 8 -1 0
2 9 0 23 0 8 -1 1
2 35 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 z1
0
8
2 32 0 9 0 7 -1 0
2 35 0 15 0 7 -1 0
2 9 0 15 0 7 -1 1
2 32 0 35 0 7 -1 1
2 9 0 15 0 8 -1 0
2 32 0 35 0 8 -1 0
2 32 0 9 0 8 -1 1
2 35 0 15 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 z1
0
8
2 9 0 11 0 7 -1 0
2 35 0 20 0 7 -1 0
2 9 0 20 0 7 -1 1
2 11 0 35 0 7 -1 1
2 9 0 20 0 8 -1 0
2 11 0 35 0 8 -1 0
2 9 0 11 0 8 -1 1
2 35 0 20 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 z1
0
8
2 9 0 27 0 7 -1 0
2 19 0 35 0 7 -1 0
2 9 0 19 0 7 -1 1
2 27 0 35 0 7 -1 1
2 9 0 19 0 8 -1 0
2 27 0 35 0 8 -1 0
2 9 0 27 0 8 -1 1
2 19 0 35 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 t z1
0
8
2 3 0 27 0 7 -1 0
2 19 0 4 0 7 -1 0
2 3 0 19 0 7 -1 1
2 27 0 4 0 7 -1 1
2 3 0 19 0 8 -1 0
2 27 0 4 0 8 -1 0
2 3 0 27 0 8 -1 1
2 19 0 4 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 f z1
0
8
2 18 0 27 0 7 -1 0
2 19 0 6 0 7 -1 0
2 18 0 19 0 7 -1 1
2 27 0 6 0 7 -1 1
2 18 0 19 0 8 -1 0
2 27 0 6 0 8 -1 0
2 18 0 27 0 8 -1 1
2 19 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp1 z1
0
8
2 19 0 14 0 7 -1 0
2 27 0 23 0 7 -1 0
2 19 0 23 0 7 -1 1
2 27 0 14 0 7 -1 1
2 19 0 23 0 8 -1 0
2 27 0 14 0 8 -1 0
2 19 0 14 0 8 -1 1
2 27 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp2 z1
0
8
2 19 0 15 0 7 -1 0
2 32 0 27 0 7 -1 0
2 27 0 15 0 7 -1 1
2 32 0 19 0 7 -1 1
2 27 0 15 0 8 -1 0
2 32 0 19 0 8 -1 0
2 19 0 15 0 8 -1 1
2 32 0 27 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 z1
0
8
2 11 0 27 0 7 -1 0
2 19 0 20 0 7 -1 0
2 11 0 19 0 7 -1 1
2 27 0 20 0 7 -1 1
2 11 0 19 0 8 -1 0
2 27 0 20 0 8 -1 0
2 11 0 27 0 8 -1 1
2 19 0 20 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 z1
0
8
2 9 0 27 0 7 -1 0
2 35 0 19 0 7 -1 0
2 9 0 19 0 7 -1 1
2 35 0 27 0 7 -1 1
2 9 0 19 0 8 -1 0
2 35 0 27 0 8 -1 0
2 9 0 27 0 8 -1 1
2 35 0 19 0 8 -1 1
0
end_operator
begin_operator
xor-gate t z1 f
0
8
2 4 0 7 0 6 -1 0
2 8 0 3 0 6 -1 0
2 3 0 7 0 6 -1 1
2 8 0 4 0 6 -1 1
2 3 0 7 0 18 -1 0
2 8 0 4 0 18 -1 0
2 4 0 7 0 18 -1 1
2 8 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate t z1 tmp1
0
8
2 4 0 7 0 14 -1 0
2 8 0 3 0 14 -1 0
2 3 0 7 0 14 -1 1
2 8 0 4 0 14 -1 1
2 3 0 7 0 23 -1 0
2 8 0 4 0 23 -1 0
2 4 0 7 0 23 -1 1
2 8 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate t z1 tmp2
0
8
2 4 0 7 0 15 -1 0
2 8 0 3 0 15 -1 0
2 3 0 7 0 15 -1 1
2 8 0 4 0 15 -1 1
2 3 0 7 0 32 -1 0
2 8 0 4 0 32 -1 0
2 4 0 7 0 32 -1 1
2 8 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate t z1 r1
0
8
2 4 0 7 0 19 -1 0
2 8 0 3 0 19 -1 0
2 3 0 7 0 19 -1 1
2 8 0 4 0 19 -1 1
2 3 0 7 0 27 -1 0
2 8 0 4 0 27 -1 0
2 4 0 7 0 27 -1 1
2 8 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate f z1 t
0
8
2 8 0 6 0 3 -1 0
2 18 0 7 0 3 -1 0
2 6 0 7 0 3 -1 1
2 8 0 18 0 3 -1 1
2 6 0 7 0 4 -1 0
2 8 0 18 0 4 -1 0
2 8 0 6 0 4 -1 1
2 18 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate f z1 tmp1
0
8
2 6 0 7 0 14 -1 0
2 8 0 18 0 14 -1 0
2 8 0 6 0 14 -1 1
2 18 0 7 0 14 -1 1
2 8 0 6 0 23 -1 0
2 18 0 7 0 23 -1 0
2 6 0 7 0 23 -1 1
2 8 0 18 0 23 -1 1
0
end_operator
begin_operator
xor-gate f z1 tmp2
0
8
2 6 0 7 0 15 -1 0
2 8 0 18 0 15 -1 0
2 8 0 6 0 15 -1 1
2 18 0 7 0 15 -1 1
2 8 0 6 0 32 -1 0
2 18 0 7 0 32 -1 0
2 6 0 7 0 32 -1 1
2 8 0 18 0 32 -1 1
0
end_operator
begin_operator
xor-gate f z1 r1
0
8
2 6 0 7 0 19 -1 0
2 8 0 18 0 19 -1 0
2 8 0 6 0 19 -1 1
2 18 0 7 0 19 -1 1
2 8 0 6 0 27 -1 0
2 18 0 7 0 27 -1 0
2 6 0 7 0 27 -1 1
2 8 0 18 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z1 t
0
8
2 7 0 23 0 3 -1 0
2 8 0 14 0 3 -1 0
2 8 0 23 0 3 -1 1
2 14 0 7 0 3 -1 1
2 8 0 23 0 4 -1 0
2 14 0 7 0 4 -1 0
2 7 0 23 0 4 -1 1
2 8 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z1 f
0
8
2 8 0 23 0 6 -1 0
2 14 0 7 0 6 -1 0
2 7 0 23 0 6 -1 1
2 8 0 14 0 6 -1 1
2 7 0 23 0 18 -1 0
2 8 0 14 0 18 -1 0
2 8 0 23 0 18 -1 1
2 14 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z1 tmp2
0
8
2 8 0 23 0 15 -1 0
2 14 0 7 0 15 -1 0
2 7 0 23 0 15 -1 1
2 8 0 14 0 15 -1 1
2 7 0 23 0 32 -1 0
2 8 0 14 0 32 -1 0
2 8 0 23 0 32 -1 1
2 14 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z1 r1
0
8
2 8 0 23 0 19 -1 0
2 14 0 7 0 19 -1 0
2 7 0 23 0 19 -1 1
2 8 0 14 0 19 -1 1
2 7 0 23 0 27 -1 0
2 8 0 14 0 27 -1 0
2 8 0 23 0 27 -1 1
2 14 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z1 t
0
8
2 8 0 15 0 3 -1 0
2 32 0 7 0 3 -1 0
2 7 0 15 0 3 -1 1
2 32 0 8 0 3 -1 1
2 7 0 15 0 4 -1 0
2 32 0 8 0 4 -1 0
2 8 0 15 0 4 -1 1
2 32 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z1 f
0
8
2 7 0 15 0 6 -1 0
2 32 0 8 0 6 -1 0
2 8 0 15 0 6 -1 1
2 32 0 7 0 6 -1 1
2 8 0 15 0 18 -1 0
2 32 0 7 0 18 -1 0
2 7 0 15 0 18 -1 1
2 32 0 8 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z1 tmp1
0
8
2 7 0 15 0 14 -1 0
2 32 0 8 0 14 -1 0
2 8 0 15 0 14 -1 1
2 32 0 7 0 14 -1 1
2 8 0 15 0 23 -1 0
2 32 0 7 0 23 -1 0
2 7 0 15 0 23 -1 1
2 32 0 8 0 23 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z1 r1
0
8
2 7 0 15 0 19 -1 0
2 32 0 8 0 19 -1 0
2 8 0 15 0 19 -1 1
2 32 0 7 0 19 -1 1
2 8 0 15 0 27 -1 0
2 32 0 7 0 27 -1 0
2 7 0 15 0 27 -1 1
2 32 0 8 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 t
0
8
2 8 0 20 0 3 -1 0
2 11 0 7 0 3 -1 0
2 8 0 11 0 3 -1 1
2 20 0 7 0 3 -1 1
2 8 0 11 0 4 -1 0
2 20 0 7 0 4 -1 0
2 8 0 20 0 4 -1 1
2 11 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 f
0
8
2 8 0 11 0 6 -1 0
2 20 0 7 0 6 -1 0
2 8 0 20 0 6 -1 1
2 11 0 7 0 6 -1 1
2 8 0 20 0 18 -1 0
2 11 0 7 0 18 -1 0
2 8 0 11 0 18 -1 1
2 20 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 tmp1
0
8
2 8 0 11 0 14 -1 0
2 20 0 7 0 14 -1 0
2 8 0 20 0 14 -1 1
2 11 0 7 0 14 -1 1
2 8 0 20 0 23 -1 0
2 11 0 7 0 23 -1 0
2 8 0 11 0 23 -1 1
2 20 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 tmp2
0
8
2 8 0 11 0 15 -1 0
2 20 0 7 0 15 -1 0
2 8 0 20 0 15 -1 1
2 11 0 7 0 15 -1 1
2 8 0 20 0 32 -1 0
2 11 0 7 0 32 -1 0
2 8 0 11 0 32 -1 1
2 20 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 r1
0
8
2 8 0 11 0 19 -1 0
2 20 0 7 0 19 -1 0
2 8 0 20 0 19 -1 1
2 11 0 7 0 19 -1 1
2 8 0 20 0 27 -1 0
2 11 0 7 0 27 -1 0
2 8 0 11 0 27 -1 1
2 20 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 t
0
8
2 8 0 35 0 3 -1 0
2 9 0 7 0 3 -1 0
2 8 0 9 0 3 -1 1
2 35 0 7 0 3 -1 1
2 8 0 9 0 4 -1 0
2 35 0 7 0 4 -1 0
2 8 0 35 0 4 -1 1
2 9 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 f
0
8
2 8 0 9 0 6 -1 0
2 35 0 7 0 6 -1 0
2 8 0 35 0 6 -1 1
2 9 0 7 0 6 -1 1
2 8 0 35 0 18 -1 0
2 9 0 7 0 18 -1 0
2 8 0 9 0 18 -1 1
2 35 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 tmp1
0
8
2 8 0 9 0 14 -1 0
2 35 0 7 0 14 -1 0
2 8 0 35 0 14 -1 1
2 9 0 7 0 14 -1 1
2 8 0 35 0 23 -1 0
2 9 0 7 0 23 -1 0
2 8 0 9 0 23 -1 1
2 35 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 tmp2
0
8
2 8 0 9 0 15 -1 0
2 35 0 7 0 15 -1 0
2 8 0 35 0 15 -1 1
2 9 0 7 0 15 -1 1
2 8 0 35 0 32 -1 0
2 9 0 7 0 32 -1 0
2 8 0 9 0 32 -1 1
2 35 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 r1
0
8
2 8 0 9 0 19 -1 0
2 35 0 7 0 19 -1 0
2 8 0 35 0 19 -1 1
2 9 0 7 0 19 -1 1
2 8 0 35 0 27 -1 0
2 9 0 7 0 27 -1 0
2 8 0 9 0 27 -1 1
2 35 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate r1 z1 t
0
8
2 8 0 19 0 3 -1 0
2 27 0 7 0 3 -1 0
2 8 0 27 0 3 -1 1
2 19 0 7 0 3 -1 1
2 8 0 27 0 4 -1 0
2 19 0 7 0 4 -1 0
2 8 0 19 0 4 -1 1
2 27 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 z1 f
0
8
2 8 0 27 0 6 -1 0
2 19 0 7 0 6 -1 0
2 8 0 19 0 6 -1 1
2 27 0 7 0 6 -1 1
2 8 0 19 0 18 -1 0
2 27 0 7 0 18 -1 0
2 8 0 27 0 18 -1 1
2 19 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 z1 tmp1
0
8
2 8 0 27 0 14 -1 0
2 19 0 7 0 14 -1 0
2 8 0 19 0 14 -1 1
2 27 0 7 0 14 -1 1
2 8 0 19 0 23 -1 0
2 27 0 7 0 23 -1 0
2 8 0 27 0 23 -1 1
2 19 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 z1 tmp2
0
8
2 8 0 27 0 15 -1 0
2 19 0 7 0 15 -1 0
2 8 0 19 0 15 -1 1
2 27 0 7 0 15 -1 1
2 8 0 19 0 32 -1 0
2 27 0 7 0 32 -1 0
2 8 0 27 0 32 -1 1
2 19 0 7 0 32 -1 1
0
end_operator
begin_operator
not-gate z1 t
0
4
1 7 0 3 -1 0
1 8 0 3 -1 1
1 8 0 4 -1 0
1 7 0 4 -1 1
0
end_operator
begin_operator
not-gate z1 f
0
4
1 8 0 6 -1 0
1 7 0 6 -1 1
1 7 0 18 -1 0
1 8 0 18 -1 1
0
end_operator
begin_operator
not-gate z1 tmp1
0
4
1 8 0 14 -1 0
1 7 0 14 -1 1
1 7 0 23 -1 0
1 8 0 23 -1 1
0
end_operator
begin_operator
not-gate z1 tmp2
0
4
1 8 0 15 -1 0
1 7 0 15 -1 1
1 7 0 32 -1 0
1 8 0 32 -1 1
0
end_operator
begin_operator
not-gate z1 r1
0
4
1 8 0 19 -1 0
1 7 0 19 -1 1
1 7 0 27 -1 0
1 8 0 27 -1 1
0
end_operator
begin_operator
not-gate t z1
0
4
1 3 0 7 -1 0
1 4 0 7 -1 1
1 4 0 8 -1 0
1 3 0 8 -1 1
0
end_operator
begin_operator
not-gate f z1
0
4
1 18 0 7 -1 0
1 6 0 7 -1 1
1 6 0 8 -1 0
1 18 0 8 -1 1
0
end_operator
begin_operator
not-gate tmp1 z1
0
4
1 23 0 7 -1 0
1 14 0 7 -1 1
1 14 0 8 -1 0
1 23 0 8 -1 1
0
end_operator
begin_operator
not-gate tmp2 z1
0
4
1 32 0 7 -1 0
1 15 0 7 -1 1
1 15 0 8 -1 0
1 32 0 8 -1 1
0
end_operator
begin_operator
not-gate x1 z1
0
4
1 11 0 7 -1 0
1 20 0 7 -1 1
1 20 0 8 -1 0
1 11 0 8 -1 1
0
end_operator
begin_operator
not-gate y1 z1
0
4
1 9 0 7 -1 0
1 35 0 7 -1 1
1 35 0 8 -1 0
1 9 0 8 -1 1
0
end_operator
begin_operator
not-gate r1 z1
0
4
1 27 0 7 -1 0
1 19 0 7 -1 1
1 19 0 8 -1 0
1 27 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 f t
0
6
2 34 0 18 0 3 -1 0
1 6 0 3 -1 1
1 30 0 3 -1 1
1 6 0 4 -1 0
1 30 0 4 -1 0
2 34 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 tmp1 t
0
6
2 34 0 23 0 3 -1 0
1 14 0 3 -1 1
1 30 0 3 -1 1
1 14 0 4 -1 0
1 30 0 4 -1 0
2 34 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 tmp2 t
0
6
2 32 0 34 0 3 -1 0
1 15 0 3 -1 1
1 30 0 3 -1 1
1 15 0 4 -1 0
1 30 0 4 -1 0
2 32 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 x1 t
0
6
2 34 0 11 0 3 -1 0
1 20 0 3 -1 1
1 30 0 3 -1 1
1 20 0 4 -1 0
1 30 0 4 -1 0
2 34 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 y1 t
0
6
2 9 0 34 0 3 -1 0
1 30 0 3 -1 1
1 35 0 3 -1 1
1 30 0 4 -1 0
1 35 0 4 -1 0
2 9 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 r1 t
0
6
2 34 0 27 0 3 -1 0
1 19 0 3 -1 1
1 30 0 3 -1 1
1 19 0 4 -1 0
1 30 0 4 -1 0
2 34 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 z1 t
0
6
2 8 0 34 0 3 -1 0
1 7 0 3 -1 1
1 30 0 3 -1 1
1 7 0 4 -1 0
1 30 0 4 -1 0
2 8 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 t f
0
6
1 4 0 6 -1 0
1 30 0 6 -1 0
2 34 0 3 0 6 -1 1
2 34 0 3 0 18 -1 0
1 4 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 tmp1 f
0
6
1 14 0 6 -1 0
1 30 0 6 -1 0
2 34 0 23 0 6 -1 1
2 34 0 23 0 18 -1 0
1 14 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 tmp2 f
0
6
1 15 0 6 -1 0
1 30 0 6 -1 0
2 32 0 34 0 6 -1 1
2 32 0 34 0 18 -1 0
1 15 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 x1 f
0
6
1 20 0 6 -1 0
1 30 0 6 -1 0
2 34 0 11 0 6 -1 1
2 34 0 11 0 18 -1 0
1 20 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 y1 f
0
6
1 30 0 6 -1 0
1 35 0 6 -1 0
2 9 0 34 0 6 -1 1
2 9 0 34 0 18 -1 0
1 30 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 r1 f
0
6
1 19 0 6 -1 0
1 30 0 6 -1 0
2 34 0 27 0 6 -1 1
2 34 0 27 0 18 -1 0
1 19 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 z1 f
0
6
1 7 0 6 -1 0
1 30 0 6 -1 0
2 8 0 34 0 6 -1 1
2 8 0 34 0 18 -1 0
1 7 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 t tmp1
0
6
1 4 0 14 -1 0
1 30 0 14 -1 0
2 34 0 3 0 14 -1 1
2 34 0 3 0 23 -1 0
1 4 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 f tmp1
0
6
1 6 0 14 -1 0
1 30 0 14 -1 0
2 34 0 18 0 14 -1 1
2 34 0 18 0 23 -1 0
1 6 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 tmp2 tmp1
0
6
1 15 0 14 -1 0
1 30 0 14 -1 0
2 32 0 34 0 14 -1 1
2 32 0 34 0 23 -1 0
1 15 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 x1 tmp1
0
6
1 20 0 14 -1 0
1 30 0 14 -1 0
2 34 0 11 0 14 -1 1
2 34 0 11 0 23 -1 0
1 20 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 y1 tmp1
0
6
1 30 0 14 -1 0
1 35 0 14 -1 0
2 9 0 34 0 14 -1 1
2 9 0 34 0 23 -1 0
1 30 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 r1 tmp1
0
6
1 19 0 14 -1 0
1 30 0 14 -1 0
2 34 0 27 0 14 -1 1
2 34 0 27 0 23 -1 0
1 19 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 z1 tmp1
0
6
1 7 0 14 -1 0
1 30 0 14 -1 0
2 8 0 34 0 14 -1 1
2 8 0 34 0 23 -1 0
1 7 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 t tmp2
0
6
1 4 0 15 -1 0
1 30 0 15 -1 0
2 34 0 3 0 15 -1 1
2 34 0 3 0 32 -1 0
1 4 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 f tmp2
0
6
1 6 0 15 -1 0
1 30 0 15 -1 0
2 34 0 18 0 15 -1 1
2 34 0 18 0 32 -1 0
1 6 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 tmp1 tmp2
0
6
1 14 0 15 -1 0
1 30 0 15 -1 0
2 34 0 23 0 15 -1 1
2 34 0 23 0 32 -1 0
1 14 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 x1 tmp2
0
6
1 20 0 15 -1 0
1 30 0 15 -1 0
2 34 0 11 0 15 -1 1
2 34 0 11 0 32 -1 0
1 20 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 y1 tmp2
0
6
1 30 0 15 -1 0
1 35 0 15 -1 0
2 9 0 34 0 15 -1 1
2 9 0 34 0 32 -1 0
1 30 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 r1 tmp2
0
6
1 19 0 15 -1 0
1 30 0 15 -1 0
2 34 0 27 0 15 -1 1
2 34 0 27 0 32 -1 0
1 19 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 z1 tmp2
0
6
1 7 0 15 -1 0
1 30 0 15 -1 0
2 8 0 34 0 15 -1 1
2 8 0 34 0 32 -1 0
1 7 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 t r1
0
6
1 4 0 19 -1 0
1 30 0 19 -1 0
2 34 0 3 0 19 -1 1
2 34 0 3 0 27 -1 0
1 4 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 f r1
0
6
1 6 0 19 -1 0
1 30 0 19 -1 0
2 34 0 18 0 19 -1 1
2 34 0 18 0 27 -1 0
1 6 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 tmp1 r1
0
6
1 14 0 19 -1 0
1 30 0 19 -1 0
2 34 0 23 0 19 -1 1
2 34 0 23 0 27 -1 0
1 14 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 tmp2 r1
0
6
1 15 0 19 -1 0
1 30 0 19 -1 0
2 32 0 34 0 19 -1 1
2 32 0 34 0 27 -1 0
1 15 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 x1 r1
0
6
1 20 0 19 -1 0
1 30 0 19 -1 0
2 34 0 11 0 19 -1 1
2 34 0 11 0 27 -1 0
1 20 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 y1 r1
0
6
1 30 0 19 -1 0
1 35 0 19 -1 0
2 9 0 34 0 19 -1 1
2 9 0 34 0 27 -1 0
1 30 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 z1 r1
0
6
1 7 0 19 -1 0
1 30 0 19 -1 0
2 8 0 34 0 19 -1 1
2 8 0 34 0 27 -1 0
1 7 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 t z1
0
6
1 4 0 7 -1 0
1 30 0 7 -1 0
2 34 0 3 0 7 -1 1
2 34 0 3 0 8 -1 0
1 4 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 f z1
0
6
1 6 0 7 -1 0
1 30 0 7 -1 0
2 34 0 18 0 7 -1 1
2 34 0 18 0 8 -1 0
1 6 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 tmp1 z1
0
6
1 14 0 7 -1 0
1 30 0 7 -1 0
2 34 0 23 0 7 -1 1
2 34 0 23 0 8 -1 0
1 14 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 tmp2 z1
0
6
1 15 0 7 -1 0
1 30 0 7 -1 0
2 32 0 34 0 7 -1 1
2 32 0 34 0 8 -1 0
1 15 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 x1 z1
0
6
1 20 0 7 -1 0
1 30 0 7 -1 0
2 34 0 11 0 7 -1 1
2 34 0 11 0 8 -1 0
1 20 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 y1 z1
0
6
1 30 0 7 -1 0
1 35 0 7 -1 0
2 9 0 34 0 7 -1 1
2 9 0 34 0 8 -1 0
1 30 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate r2 r1 z1
0
6
1 19 0 7 -1 0
1 30 0 7 -1 0
2 34 0 27 0 7 -1 1
2 34 0 27 0 8 -1 0
1 19 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate t f r2
0
6
1 4 0 30 -1 0
1 6 0 30 -1 0
2 18 0 3 0 30 -1 1
2 18 0 3 0 34 -1 0
1 4 0 34 -1 1
1 6 0 34 -1 1
0
end_operator
begin_operator
and-gate t tmp1 r2
0
6
1 4 0 30 -1 0
1 14 0 30 -1 0
2 3 0 23 0 30 -1 1
2 3 0 23 0 34 -1 0
1 4 0 34 -1 1
1 14 0 34 -1 1
0
end_operator
begin_operator
and-gate t tmp2 r2
0
6
1 4 0 30 -1 0
1 15 0 30 -1 0
2 32 0 3 0 30 -1 1
2 32 0 3 0 34 -1 0
1 4 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate t x1 r2
0
6
1 4 0 30 -1 0
1 20 0 30 -1 0
2 11 0 3 0 30 -1 1
2 11 0 3 0 34 -1 0
1 4 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate t y1 r2
0
6
1 4 0 30 -1 0
1 35 0 30 -1 0
2 9 0 3 0 30 -1 1
2 9 0 3 0 34 -1 0
1 4 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate t r1 r2
0
6
1 4 0 30 -1 0
1 19 0 30 -1 0
2 27 0 3 0 30 -1 1
2 27 0 3 0 34 -1 0
1 4 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate t z1 r2
0
6
1 4 0 30 -1 0
1 7 0 30 -1 0
2 8 0 3 0 30 -1 1
2 8 0 3 0 34 -1 0
1 4 0 34 -1 1
1 7 0 34 -1 1
0
end_operator
begin_operator
and-gate f t r2
0
6
1 4 0 30 -1 0
1 6 0 30 -1 0
2 18 0 3 0 30 -1 1
2 18 0 3 0 34 -1 0
1 4 0 34 -1 1
1 6 0 34 -1 1
0
end_operator
begin_operator
and-gate f tmp1 r2
0
6
1 6 0 30 -1 0
1 14 0 30 -1 0
2 18 0 23 0 30 -1 1
2 18 0 23 0 34 -1 0
1 6 0 34 -1 1
1 14 0 34 -1 1
0
end_operator
begin_operator
and-gate f tmp2 r2
0
6
1 6 0 30 -1 0
1 15 0 30 -1 0
2 32 0 18 0 30 -1 1
2 32 0 18 0 34 -1 0
1 6 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate f x1 r2
0
6
1 6 0 30 -1 0
1 20 0 30 -1 0
2 18 0 11 0 30 -1 1
2 18 0 11 0 34 -1 0
1 6 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate f y1 r2
0
6
1 6 0 30 -1 0
1 35 0 30 -1 0
2 9 0 18 0 30 -1 1
2 9 0 18 0 34 -1 0
1 6 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate f r1 r2
0
6
1 6 0 30 -1 0
1 19 0 30 -1 0
2 18 0 27 0 30 -1 1
2 18 0 27 0 34 -1 0
1 6 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate f z1 r2
0
6
1 6 0 30 -1 0
1 7 0 30 -1 0
2 8 0 18 0 30 -1 1
2 8 0 18 0 34 -1 0
1 6 0 34 -1 1
1 7 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 t r2
0
6
1 4 0 30 -1 0
1 14 0 30 -1 0
2 3 0 23 0 30 -1 1
2 3 0 23 0 34 -1 0
1 4 0 34 -1 1
1 14 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 f r2
0
6
1 6 0 30 -1 0
1 14 0 30 -1 0
2 18 0 23 0 30 -1 1
2 18 0 23 0 34 -1 0
1 6 0 34 -1 1
1 14 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 tmp2 r2
0
6
1 14 0 30 -1 0
1 15 0 30 -1 0
2 32 0 23 0 30 -1 1
2 32 0 23 0 34 -1 0
1 14 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 r2
0
6
1 14 0 30 -1 0
1 20 0 30 -1 0
2 11 0 23 0 30 -1 1
2 11 0 23 0 34 -1 0
1 14 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 r2
0
6
1 14 0 30 -1 0
1 35 0 30 -1 0
2 9 0 23 0 30 -1 1
2 9 0 23 0 34 -1 0
1 14 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 r1 r2
0
6
1 14 0 30 -1 0
1 19 0 30 -1 0
2 27 0 23 0 30 -1 1
2 27 0 23 0 34 -1 0
1 14 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 z1 r2
0
6
1 7 0 30 -1 0
1 14 0 30 -1 0
2 8 0 23 0 30 -1 1
2 8 0 23 0 34 -1 0
1 7 0 34 -1 1
1 14 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 t r2
0
6
1 4 0 30 -1 0
1 15 0 30 -1 0
2 32 0 3 0 30 -1 1
2 32 0 3 0 34 -1 0
1 4 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 f r2
0
6
1 6 0 30 -1 0
1 15 0 30 -1 0
2 32 0 18 0 30 -1 1
2 32 0 18 0 34 -1 0
1 6 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 tmp1 r2
0
6
1 14 0 30 -1 0
1 15 0 30 -1 0
2 32 0 23 0 30 -1 1
2 32 0 23 0 34 -1 0
1 14 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 r2
0
6
1 15 0 30 -1 0
1 20 0 30 -1 0
2 32 0 11 0 30 -1 1
2 32 0 11 0 34 -1 0
1 15 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 r2
0
6
1 15 0 30 -1 0
1 35 0 30 -1 0
2 32 0 9 0 30 -1 1
2 32 0 9 0 34 -1 0
1 15 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 r1 r2
0
6
1 15 0 30 -1 0
1 19 0 30 -1 0
2 32 0 27 0 30 -1 1
2 32 0 27 0 34 -1 0
1 15 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 z1 r2
0
6
1 7 0 30 -1 0
1 15 0 30 -1 0
2 32 0 8 0 30 -1 1
2 32 0 8 0 34 -1 0
1 7 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 t r2
0
6
1 4 0 30 -1 0
1 20 0 30 -1 0
2 3 0 11 0 30 -1 1
2 3 0 11 0 34 -1 0
1 4 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 f r2
0
6
1 6 0 30 -1 0
1 20 0 30 -1 0
2 18 0 11 0 30 -1 1
2 18 0 11 0 34 -1 0
1 6 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 r2
0
6
1 14 0 30 -1 0
1 20 0 30 -1 0
2 11 0 23 0 30 -1 1
2 11 0 23 0 34 -1 0
1 14 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 r2
0
6
1 15 0 30 -1 0
1 20 0 30 -1 0
2 32 0 11 0 30 -1 1
2 32 0 11 0 34 -1 0
1 15 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 y1 r2
0
6
1 20 0 30 -1 0
1 35 0 30 -1 0
2 9 0 11 0 30 -1 1
2 9 0 11 0 34 -1 0
1 20 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 r1 r2
0
6
1 19 0 30 -1 0
1 20 0 30 -1 0
2 27 0 11 0 30 -1 1
2 27 0 11 0 34 -1 0
1 19 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 z1 r2
0
6
1 7 0 30 -1 0
1 20 0 30 -1 0
2 8 0 11 0 30 -1 1
2 8 0 11 0 34 -1 0
1 7 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 t r2
0
6
1 4 0 30 -1 0
1 35 0 30 -1 0
2 9 0 3 0 30 -1 1
2 9 0 3 0 34 -1 0
1 4 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 f r2
0
6
1 6 0 30 -1 0
1 35 0 30 -1 0
2 9 0 18 0 30 -1 1
2 9 0 18 0 34 -1 0
1 6 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 r2
0
6
1 14 0 30 -1 0
1 35 0 30 -1 0
2 9 0 23 0 30 -1 1
2 9 0 23 0 34 -1 0
1 14 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 r2
0
6
1 15 0 30 -1 0
1 35 0 30 -1 0
2 32 0 9 0 30 -1 1
2 32 0 9 0 34 -1 0
1 15 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 x1 r2
0
6
1 20 0 30 -1 0
1 35 0 30 -1 0
2 9 0 11 0 30 -1 1
2 9 0 11 0 34 -1 0
1 20 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 r1 r2
0
6
1 19 0 30 -1 0
1 35 0 30 -1 0
2 9 0 27 0 30 -1 1
2 9 0 27 0 34 -1 0
1 19 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 z1 r2
0
6
1 7 0 30 -1 0
1 35 0 30 -1 0
2 8 0 9 0 30 -1 1
2 8 0 9 0 34 -1 0
1 7 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 t r2
0
6
1 4 0 30 -1 0
1 19 0 30 -1 0
2 3 0 27 0 30 -1 1
2 3 0 27 0 34 -1 0
1 4 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 f r2
0
6
1 6 0 30 -1 0
1 19 0 30 -1 0
2 18 0 27 0 30 -1 1
2 18 0 27 0 34 -1 0
1 6 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 tmp1 r2
0
6
1 14 0 30 -1 0
1 19 0 30 -1 0
2 27 0 23 0 30 -1 1
2 27 0 23 0 34 -1 0
1 14 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 tmp2 r2
0
6
1 15 0 30 -1 0
1 19 0 30 -1 0
2 32 0 27 0 30 -1 1
2 32 0 27 0 34 -1 0
1 15 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 x1 r2
0
6
1 19 0 30 -1 0
1 20 0 30 -1 0
2 11 0 27 0 30 -1 1
2 11 0 27 0 34 -1 0
1 19 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 y1 r2
0
6
1 19 0 30 -1 0
1 35 0 30 -1 0
2 9 0 27 0 30 -1 1
2 9 0 27 0 34 -1 0
1 19 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 z1 r2
0
6
1 7 0 30 -1 0
1 19 0 30 -1 0
2 8 0 27 0 30 -1 1
2 8 0 27 0 34 -1 0
1 7 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 t r2
0
6
1 4 0 30 -1 0
1 7 0 30 -1 0
2 8 0 3 0 30 -1 1
2 8 0 3 0 34 -1 0
1 4 0 34 -1 1
1 7 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 f r2
0
6
1 6 0 30 -1 0
1 7 0 30 -1 0
2 8 0 18 0 30 -1 1
2 8 0 18 0 34 -1 0
1 6 0 34 -1 1
1 7 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 tmp1 r2
0
6
1 7 0 30 -1 0
1 14 0 30 -1 0
2 8 0 23 0 30 -1 1
2 8 0 23 0 34 -1 0
1 7 0 34 -1 1
1 14 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 tmp2 r2
0
6
1 7 0 30 -1 0
1 15 0 30 -1 0
2 8 0 32 0 30 -1 1
2 8 0 32 0 34 -1 0
1 7 0 34 -1 1
1 15 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 x1 r2
0
6
1 7 0 30 -1 0
1 20 0 30 -1 0
2 8 0 11 0 30 -1 1
2 8 0 11 0 34 -1 0
1 7 0 34 -1 1
1 20 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 y1 r2
0
6
1 7 0 30 -1 0
1 35 0 30 -1 0
2 8 0 9 0 30 -1 1
2 8 0 9 0 34 -1 0
1 7 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 r1 r2
0
6
1 7 0 30 -1 0
1 19 0 30 -1 0
2 8 0 27 0 30 -1 1
2 8 0 27 0 34 -1 0
1 7 0 34 -1 1
1 19 0 34 -1 1
0
end_operator
begin_operator
and-gate t r2 f
0
6
1 4 0 6 -1 0
1 30 0 6 -1 0
2 34 0 3 0 6 -1 1
2 34 0 3 0 18 -1 0
1 4 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate t r2 tmp1
0
6
1 4 0 14 -1 0
1 30 0 14 -1 0
2 34 0 3 0 14 -1 1
2 34 0 3 0 23 -1 0
1 4 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate t r2 tmp2
0
6
1 4 0 15 -1 0
1 30 0 15 -1 0
2 34 0 3 0 15 -1 1
2 34 0 3 0 32 -1 0
1 4 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate t r2 r1
0
6
1 4 0 19 -1 0
1 30 0 19 -1 0
2 34 0 3 0 19 -1 1
2 34 0 3 0 27 -1 0
1 4 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate t r2 z1
0
6
1 4 0 7 -1 0
1 30 0 7 -1 0
2 34 0 3 0 7 -1 1
2 34 0 3 0 8 -1 0
1 4 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate f r2 t
0
6
2 18 0 34 0 3 -1 0
1 6 0 3 -1 1
1 30 0 3 -1 1
1 6 0 4 -1 0
1 30 0 4 -1 0
2 18 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate f r2 tmp1
0
6
1 6 0 14 -1 0
1 30 0 14 -1 0
2 18 0 34 0 14 -1 1
2 18 0 34 0 23 -1 0
1 6 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate f r2 tmp2
0
6
1 6 0 15 -1 0
1 30 0 15 -1 0
2 18 0 34 0 15 -1 1
2 18 0 34 0 32 -1 0
1 6 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate f r2 r1
0
6
1 6 0 19 -1 0
1 30 0 19 -1 0
2 18 0 34 0 19 -1 1
2 18 0 34 0 27 -1 0
1 6 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate f r2 z1
0
6
1 6 0 7 -1 0
1 30 0 7 -1 0
2 18 0 34 0 7 -1 1
2 18 0 34 0 8 -1 0
1 6 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 r2 t
0
6
2 34 0 23 0 3 -1 0
1 14 0 3 -1 1
1 30 0 3 -1 1
1 14 0 4 -1 0
1 30 0 4 -1 0
2 34 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 r2 f
0
6
1 14 0 6 -1 0
1 30 0 6 -1 0
2 34 0 23 0 6 -1 1
2 34 0 23 0 18 -1 0
1 14 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 r2 tmp2
0
6
1 14 0 15 -1 0
1 30 0 15 -1 0
2 34 0 23 0 15 -1 1
2 34 0 23 0 32 -1 0
1 14 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 r2 r1
0
6
1 14 0 19 -1 0
1 30 0 19 -1 0
2 34 0 23 0 19 -1 1
2 34 0 23 0 27 -1 0
1 14 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 r2 z1
0
6
1 14 0 7 -1 0
1 30 0 7 -1 0
2 34 0 23 0 7 -1 1
2 34 0 23 0 8 -1 0
1 14 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 r2 t
0
6
2 32 0 34 0 3 -1 0
1 15 0 3 -1 1
1 30 0 3 -1 1
1 15 0 4 -1 0
1 30 0 4 -1 0
2 32 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 r2 f
0
6
1 15 0 6 -1 0
1 30 0 6 -1 0
2 32 0 34 0 6 -1 1
2 32 0 34 0 18 -1 0
1 15 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 r2 tmp1
0
6
1 15 0 14 -1 0
1 30 0 14 -1 0
2 32 0 34 0 14 -1 1
2 32 0 34 0 23 -1 0
1 15 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate tmp2 r2 r1
0
6
1 15 0 19 -1 0
1 30 0 19 -1 0
2 32 0 34 0 19 -1 1
2 32 0 34 0 27 -1 0
1 15 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 r2 z1
0
6
1 15 0 7 -1 0
1 30 0 7 -1 0
2 32 0 34 0 7 -1 1
2 32 0 34 0 8 -1 0
1 15 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 r2 t
0
6
2 34 0 11 0 3 -1 0
1 20 0 3 -1 1
1 30 0 3 -1 1
1 20 0 4 -1 0
1 30 0 4 -1 0
2 34 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 r2 f
0
6
1 20 0 6 -1 0
1 30 0 6 -1 0
2 34 0 11 0 6 -1 1
2 34 0 11 0 18 -1 0
1 20 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 r2 tmp1
0
6
1 20 0 14 -1 0
1 30 0 14 -1 0
2 34 0 11 0 14 -1 1
2 34 0 11 0 23 -1 0
1 20 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 r2 tmp2
0
6
1 20 0 15 -1 0
1 30 0 15 -1 0
2 34 0 11 0 15 -1 1
2 34 0 11 0 32 -1 0
1 20 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate x1 r2 r1
0
6
1 20 0 19 -1 0
1 30 0 19 -1 0
2 34 0 11 0 19 -1 1
2 34 0 11 0 27 -1 0
1 20 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 r2 z1
0
6
1 20 0 7 -1 0
1 30 0 7 -1 0
2 34 0 11 0 7 -1 1
2 34 0 11 0 8 -1 0
1 20 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 r2 t
0
6
2 9 0 34 0 3 -1 0
1 30 0 3 -1 1
1 35 0 3 -1 1
1 30 0 4 -1 0
1 35 0 4 -1 0
2 9 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 r2 f
0
6
1 30 0 6 -1 0
1 35 0 6 -1 0
2 9 0 34 0 6 -1 1
2 9 0 34 0 18 -1 0
1 30 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 r2 tmp1
0
6
1 30 0 14 -1 0
1 35 0 14 -1 0
2 9 0 34 0 14 -1 1
2 9 0 34 0 23 -1 0
1 30 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 r2 tmp2
0
6
1 30 0 15 -1 0
1 35 0 15 -1 0
2 9 0 34 0 15 -1 1
2 9 0 34 0 32 -1 0
1 30 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 r2 r1
0
6
1 30 0 19 -1 0
1 35 0 19 -1 0
2 9 0 34 0 19 -1 1
2 9 0 34 0 27 -1 0
1 30 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 r2 z1
0
6
1 30 0 7 -1 0
1 35 0 7 -1 0
2 9 0 34 0 7 -1 1
2 9 0 34 0 8 -1 0
1 30 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 r2 t
0
6
2 34 0 27 0 3 -1 0
1 19 0 3 -1 1
1 30 0 3 -1 1
1 19 0 4 -1 0
1 30 0 4 -1 0
2 34 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 r2 f
0
6
1 19 0 6 -1 0
1 30 0 6 -1 0
2 34 0 27 0 6 -1 1
2 34 0 27 0 18 -1 0
1 19 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 r2 tmp1
0
6
1 19 0 14 -1 0
1 30 0 14 -1 0
2 34 0 27 0 14 -1 1
2 34 0 27 0 23 -1 0
1 19 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 r2 tmp2
0
6
1 19 0 15 -1 0
1 30 0 15 -1 0
2 34 0 27 0 15 -1 1
2 34 0 27 0 32 -1 0
1 19 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 r2 z1
0
6
1 19 0 7 -1 0
1 30 0 7 -1 0
2 34 0 27 0 7 -1 1
2 34 0 27 0 8 -1 0
1 19 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate z1 r2 t
0
6
2 8 0 34 0 3 -1 0
1 7 0 3 -1 1
1 30 0 3 -1 1
1 7 0 4 -1 0
1 30 0 4 -1 0
2 8 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 r2 f
0
6
1 7 0 6 -1 0
1 30 0 6 -1 0
2 8 0 34 0 6 -1 1
2 8 0 34 0 18 -1 0
1 7 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 r2 tmp1
0
6
1 7 0 14 -1 0
1 30 0 14 -1 0
2 8 0 34 0 14 -1 1
2 8 0 34 0 23 -1 0
1 7 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 r2 tmp2
0
6
1 7 0 15 -1 0
1 30 0 15 -1 0
2 8 0 34 0 15 -1 1
2 8 0 34 0 32 -1 0
1 7 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 r2 r1
0
6
1 7 0 19 -1 0
1 30 0 19 -1 0
2 8 0 34 0 19 -1 1
2 8 0 34 0 27 -1 0
1 7 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 f t
0
6
1 18 0 3 -1 0
1 34 0 3 -1 0
2 6 0 30 0 3 -1 1
2 6 0 30 0 4 -1 0
1 18 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 tmp1 t
0
6
1 23 0 3 -1 0
1 34 0 3 -1 0
2 14 0 30 0 3 -1 1
2 14 0 30 0 4 -1 0
1 23 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 tmp2 t
0
6
1 32 0 3 -1 0
1 34 0 3 -1 0
2 30 0 15 0 3 -1 1
2 30 0 15 0 4 -1 0
1 32 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 x1 t
0
6
1 11 0 3 -1 0
1 34 0 3 -1 0
2 20 0 30 0 3 -1 1
2 20 0 30 0 4 -1 0
1 11 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 y1 t
0
6
1 9 0 3 -1 0
1 34 0 3 -1 0
2 35 0 30 0 3 -1 1
2 35 0 30 0 4 -1 0
1 9 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 r1 t
0
6
1 27 0 3 -1 0
1 34 0 3 -1 0
2 19 0 30 0 3 -1 1
2 19 0 30 0 4 -1 0
1 27 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 z1 t
0
6
1 8 0 3 -1 0
1 34 0 3 -1 0
2 30 0 7 0 3 -1 1
2 30 0 7 0 4 -1 0
1 8 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 t f
0
6
2 4 0 30 0 6 -1 0
1 3 0 6 -1 1
1 34 0 6 -1 1
1 3 0 18 -1 0
1 34 0 18 -1 0
2 4 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 tmp1 f
0
6
2 14 0 30 0 6 -1 0
1 23 0 6 -1 1
1 34 0 6 -1 1
1 23 0 18 -1 0
1 34 0 18 -1 0
2 14 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 tmp2 f
0
6
2 30 0 15 0 6 -1 0
1 32 0 6 -1 1
1 34 0 6 -1 1
1 32 0 18 -1 0
1 34 0 18 -1 0
2 30 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 x1 f
0
6
2 20 0 30 0 6 -1 0
1 11 0 6 -1 1
1 34 0 6 -1 1
1 11 0 18 -1 0
1 34 0 18 -1 0
2 20 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 y1 f
0
6
2 35 0 30 0 6 -1 0
1 9 0 6 -1 1
1 34 0 6 -1 1
1 9 0 18 -1 0
1 34 0 18 -1 0
2 35 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 r1 f
0
6
2 19 0 30 0 6 -1 0
1 27 0 6 -1 1
1 34 0 6 -1 1
1 27 0 18 -1 0
1 34 0 18 -1 0
2 19 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 z1 f
0
6
2 30 0 7 0 6 -1 0
1 8 0 6 -1 1
1 34 0 6 -1 1
1 8 0 18 -1 0
1 34 0 18 -1 0
2 30 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 t tmp1
0
6
2 4 0 30 0 14 -1 0
1 3 0 14 -1 1
1 34 0 14 -1 1
1 3 0 23 -1 0
1 34 0 23 -1 0
2 4 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 f tmp1
0
6
2 6 0 30 0 14 -1 0
1 18 0 14 -1 1
1 34 0 14 -1 1
1 18 0 23 -1 0
1 34 0 23 -1 0
2 6 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 tmp2 tmp1
0
6
2 30 0 15 0 14 -1 0
1 32 0 14 -1 1
1 34 0 14 -1 1
1 32 0 23 -1 0
1 34 0 23 -1 0
2 30 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 x1 tmp1
0
6
2 20 0 30 0 14 -1 0
1 11 0 14 -1 1
1 34 0 14 -1 1
1 11 0 23 -1 0
1 34 0 23 -1 0
2 20 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 y1 tmp1
0
6
2 35 0 30 0 14 -1 0
1 9 0 14 -1 1
1 34 0 14 -1 1
1 9 0 23 -1 0
1 34 0 23 -1 0
2 35 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 r1 tmp1
0
6
2 19 0 30 0 14 -1 0
1 27 0 14 -1 1
1 34 0 14 -1 1
1 27 0 23 -1 0
1 34 0 23 -1 0
2 19 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 z1 tmp1
0
6
2 30 0 7 0 14 -1 0
1 8 0 14 -1 1
1 34 0 14 -1 1
1 8 0 23 -1 0
1 34 0 23 -1 0
2 30 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 t tmp2
0
6
2 4 0 30 0 15 -1 0
1 3 0 15 -1 1
1 34 0 15 -1 1
1 3 0 32 -1 0
1 34 0 32 -1 0
2 4 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 f tmp2
0
6
2 6 0 30 0 15 -1 0
1 18 0 15 -1 1
1 34 0 15 -1 1
1 18 0 32 -1 0
1 34 0 32 -1 0
2 6 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 tmp1 tmp2
0
6
2 14 0 30 0 15 -1 0
1 23 0 15 -1 1
1 34 0 15 -1 1
1 23 0 32 -1 0
1 34 0 32 -1 0
2 14 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 x1 tmp2
0
6
2 20 0 30 0 15 -1 0
1 11 0 15 -1 1
1 34 0 15 -1 1
1 11 0 32 -1 0
1 34 0 32 -1 0
2 20 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 y1 tmp2
0
6
2 35 0 30 0 15 -1 0
1 9 0 15 -1 1
1 34 0 15 -1 1
1 9 0 32 -1 0
1 34 0 32 -1 0
2 35 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 r1 tmp2
0
6
2 19 0 30 0 15 -1 0
1 27 0 15 -1 1
1 34 0 15 -1 1
1 27 0 32 -1 0
1 34 0 32 -1 0
2 19 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 z1 tmp2
0
6
2 30 0 7 0 15 -1 0
1 8 0 15 -1 1
1 34 0 15 -1 1
1 8 0 32 -1 0
1 34 0 32 -1 0
2 30 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 t r1
0
6
2 4 0 30 0 19 -1 0
1 3 0 19 -1 1
1 34 0 19 -1 1
1 3 0 27 -1 0
1 34 0 27 -1 0
2 4 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 f r1
0
6
2 6 0 30 0 19 -1 0
1 18 0 19 -1 1
1 34 0 19 -1 1
1 18 0 27 -1 0
1 34 0 27 -1 0
2 6 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 tmp1 r1
0
6
2 14 0 30 0 19 -1 0
1 23 0 19 -1 1
1 34 0 19 -1 1
1 23 0 27 -1 0
1 34 0 27 -1 0
2 14 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 tmp2 r1
0
6
2 30 0 15 0 19 -1 0
1 32 0 19 -1 1
1 34 0 19 -1 1
1 32 0 27 -1 0
1 34 0 27 -1 0
2 30 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 x1 r1
0
6
2 20 0 30 0 19 -1 0
1 11 0 19 -1 1
1 34 0 19 -1 1
1 11 0 27 -1 0
1 34 0 27 -1 0
2 20 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 y1 r1
0
6
2 35 0 30 0 19 -1 0
1 9 0 19 -1 1
1 34 0 19 -1 1
1 9 0 27 -1 0
1 34 0 27 -1 0
2 35 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 z1 r1
0
6
2 30 0 7 0 19 -1 0
1 8 0 19 -1 1
1 34 0 19 -1 1
1 8 0 27 -1 0
1 34 0 27 -1 0
2 30 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 t z1
0
6
2 4 0 30 0 7 -1 0
1 3 0 7 -1 1
1 34 0 7 -1 1
1 3 0 8 -1 0
1 34 0 8 -1 0
2 4 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate r2 f z1
0
6
2 6 0 30 0 7 -1 0
1 18 0 7 -1 1
1 34 0 7 -1 1
1 18 0 8 -1 0
1 34 0 8 -1 0
2 6 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate r2 tmp1 z1
0
6
2 14 0 30 0 7 -1 0
1 23 0 7 -1 1
1 34 0 7 -1 1
1 23 0 8 -1 0
1 34 0 8 -1 0
2 14 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate r2 tmp2 z1
0
6
2 30 0 15 0 7 -1 0
1 32 0 7 -1 1
1 34 0 7 -1 1
1 32 0 8 -1 0
1 34 0 8 -1 0
2 30 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate r2 x1 z1
0
6
2 20 0 30 0 7 -1 0
1 11 0 7 -1 1
1 34 0 7 -1 1
1 11 0 8 -1 0
1 34 0 8 -1 0
2 20 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate r2 y1 z1
0
6
2 35 0 30 0 7 -1 0
1 9 0 7 -1 1
1 34 0 7 -1 1
1 9 0 8 -1 0
1 34 0 8 -1 0
2 35 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate r2 r1 z1
0
6
2 19 0 30 0 7 -1 0
1 27 0 7 -1 1
1 34 0 7 -1 1
1 27 0 8 -1 0
1 34 0 8 -1 0
2 19 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate t f r2
0
6
2 4 0 6 0 30 -1 0
1 3 0 30 -1 1
1 18 0 30 -1 1
1 3 0 34 -1 0
1 18 0 34 -1 0
2 4 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate t tmp1 r2
0
6
2 4 0 14 0 30 -1 0
1 3 0 30 -1 1
1 23 0 30 -1 1
1 3 0 34 -1 0
1 23 0 34 -1 0
2 4 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate t tmp2 r2
0
6
2 4 0 15 0 30 -1 0
1 3 0 30 -1 1
1 32 0 30 -1 1
1 3 0 34 -1 0
1 32 0 34 -1 0
2 4 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate t x1 r2
0
6
2 20 0 4 0 30 -1 0
1 3 0 30 -1 1
1 11 0 30 -1 1
1 3 0 34 -1 0
1 11 0 34 -1 0
2 20 0 4 0 34 -1 1
0
end_operator
begin_operator
or-gate t y1 r2
0
6
2 35 0 4 0 30 -1 0
1 3 0 30 -1 1
1 9 0 30 -1 1
1 3 0 34 -1 0
1 9 0 34 -1 0
2 35 0 4 0 34 -1 1
0
end_operator
begin_operator
or-gate t r1 r2
0
6
2 19 0 4 0 30 -1 0
1 3 0 30 -1 1
1 27 0 30 -1 1
1 3 0 34 -1 0
1 27 0 34 -1 0
2 19 0 4 0 34 -1 1
0
end_operator
begin_operator
or-gate t z1 r2
0
6
2 4 0 7 0 30 -1 0
1 3 0 30 -1 1
1 8 0 30 -1 1
1 3 0 34 -1 0
1 8 0 34 -1 0
2 4 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate f t r2
0
6
2 4 0 6 0 30 -1 0
1 3 0 30 -1 1
1 18 0 30 -1 1
1 3 0 34 -1 0
1 18 0 34 -1 0
2 4 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate f tmp1 r2
0
6
2 14 0 6 0 30 -1 0
1 18 0 30 -1 1
1 23 0 30 -1 1
1 18 0 34 -1 0
1 23 0 34 -1 0
2 14 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate f tmp2 r2
0
6
2 6 0 15 0 30 -1 0
1 18 0 30 -1 1
1 32 0 30 -1 1
1 18 0 34 -1 0
1 32 0 34 -1 0
2 6 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate f x1 r2
0
6
2 20 0 6 0 30 -1 0
1 11 0 30 -1 1
1 18 0 30 -1 1
1 11 0 34 -1 0
1 18 0 34 -1 0
2 20 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate f y1 r2
0
6
2 35 0 6 0 30 -1 0
1 9 0 30 -1 1
1 18 0 30 -1 1
1 9 0 34 -1 0
1 18 0 34 -1 0
2 35 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate f r1 r2
0
6
2 19 0 6 0 30 -1 0
1 18 0 30 -1 1
1 27 0 30 -1 1
1 18 0 34 -1 0
1 27 0 34 -1 0
2 19 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate f z1 r2
0
6
2 6 0 7 0 30 -1 0
1 8 0 30 -1 1
1 18 0 30 -1 1
1 8 0 34 -1 0
1 18 0 34 -1 0
2 6 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 t r2
0
6
2 4 0 14 0 30 -1 0
1 3 0 30 -1 1
1 23 0 30 -1 1
1 3 0 34 -1 0
1 23 0 34 -1 0
2 4 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 f r2
0
6
2 6 0 14 0 30 -1 0
1 18 0 30 -1 1
1 23 0 30 -1 1
1 18 0 34 -1 0
1 23 0 34 -1 0
2 6 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 tmp2 r2
0
6
2 14 0 15 0 30 -1 0
1 23 0 30 -1 1
1 32 0 30 -1 1
1 23 0 34 -1 0
1 32 0 34 -1 0
2 14 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 r2
0
6
2 20 0 14 0 30 -1 0
1 11 0 30 -1 1
1 23 0 30 -1 1
1 11 0 34 -1 0
1 23 0 34 -1 0
2 20 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 r2
0
6
2 35 0 14 0 30 -1 0
1 9 0 30 -1 1
1 23 0 30 -1 1
1 9 0 34 -1 0
1 23 0 34 -1 0
2 35 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 r1 r2
0
6
2 19 0 14 0 30 -1 0
1 23 0 30 -1 1
1 27 0 30 -1 1
1 23 0 34 -1 0
1 27 0 34 -1 0
2 19 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 z1 r2
0
6
2 14 0 7 0 30 -1 0
1 8 0 30 -1 1
1 23 0 30 -1 1
1 8 0 34 -1 0
1 23 0 34 -1 0
2 14 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 t r2
0
6
2 4 0 15 0 30 -1 0
1 3 0 30 -1 1
1 32 0 30 -1 1
1 3 0 34 -1 0
1 32 0 34 -1 0
2 4 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 f r2
0
6
2 6 0 15 0 30 -1 0
1 18 0 30 -1 1
1 32 0 30 -1 1
1 18 0 34 -1 0
1 32 0 34 -1 0
2 6 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 tmp1 r2
0
6
2 14 0 15 0 30 -1 0
1 23 0 30 -1 1
1 32 0 30 -1 1
1 23 0 34 -1 0
1 32 0 34 -1 0
2 14 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 r2
0
6
2 20 0 15 0 30 -1 0
1 11 0 30 -1 1
1 32 0 30 -1 1
1 11 0 34 -1 0
1 32 0 34 -1 0
2 20 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 r2
0
6
2 35 0 15 0 30 -1 0
1 9 0 30 -1 1
1 32 0 30 -1 1
1 9 0 34 -1 0
1 32 0 34 -1 0
2 35 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 r1 r2
0
6
2 19 0 15 0 30 -1 0
1 27 0 30 -1 1
1 32 0 30 -1 1
1 27 0 34 -1 0
1 32 0 34 -1 0
2 19 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 z1 r2
0
6
2 7 0 15 0 30 -1 0
1 8 0 30 -1 1
1 32 0 30 -1 1
1 8 0 34 -1 0
1 32 0 34 -1 0
2 7 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 t r2
0
6
2 4 0 20 0 30 -1 0
1 3 0 30 -1 1
1 11 0 30 -1 1
1 3 0 34 -1 0
1 11 0 34 -1 0
2 4 0 20 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 f r2
0
6
2 20 0 6 0 30 -1 0
1 11 0 30 -1 1
1 18 0 30 -1 1
1 11 0 34 -1 0
1 18 0 34 -1 0
2 20 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 r2
0
6
2 20 0 14 0 30 -1 0
1 11 0 30 -1 1
1 23 0 30 -1 1
1 11 0 34 -1 0
1 23 0 34 -1 0
2 20 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 r2
0
6
2 20 0 15 0 30 -1 0
1 11 0 30 -1 1
1 32 0 30 -1 1
1 11 0 34 -1 0
1 32 0 34 -1 0
2 20 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 y1 r2
0
6
2 35 0 20 0 30 -1 0
1 9 0 30 -1 1
1 11 0 30 -1 1
1 9 0 34 -1 0
1 11 0 34 -1 0
2 35 0 20 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 r1 r2
0
6
2 19 0 20 0 30 -1 0
1 11 0 30 -1 1
1 27 0 30 -1 1
1 11 0 34 -1 0
1 27 0 34 -1 0
2 19 0 20 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 z1 r2
0
6
2 20 0 7 0 30 -1 0
1 8 0 30 -1 1
1 11 0 30 -1 1
1 8 0 34 -1 0
1 11 0 34 -1 0
2 20 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 t r2
0
6
2 35 0 4 0 30 -1 0
1 3 0 30 -1 1
1 9 0 30 -1 1
1 3 0 34 -1 0
1 9 0 34 -1 0
2 35 0 4 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 f r2
0
6
2 35 0 6 0 30 -1 0
1 9 0 30 -1 1
1 18 0 30 -1 1
1 9 0 34 -1 0
1 18 0 34 -1 0
2 35 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 r2
0
6
2 35 0 14 0 30 -1 0
1 9 0 30 -1 1
1 23 0 30 -1 1
1 9 0 34 -1 0
1 23 0 34 -1 0
2 35 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 r2
0
6
2 35 0 15 0 30 -1 0
1 9 0 30 -1 1
1 32 0 30 -1 1
1 9 0 34 -1 0
1 32 0 34 -1 0
2 35 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 x1 r2
0
6
2 35 0 20 0 30 -1 0
1 9 0 30 -1 1
1 11 0 30 -1 1
1 9 0 34 -1 0
1 11 0 34 -1 0
2 35 0 20 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 r1 r2
0
6
2 19 0 35 0 30 -1 0
1 9 0 30 -1 1
1 27 0 30 -1 1
1 9 0 34 -1 0
1 27 0 34 -1 0
2 19 0 35 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 z1 r2
0
6
2 35 0 7 0 30 -1 0
1 8 0 30 -1 1
1 9 0 30 -1 1
1 8 0 34 -1 0
1 9 0 34 -1 0
2 35 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 t r2
0
6
2 19 0 4 0 30 -1 0
1 3 0 30 -1 1
1 27 0 30 -1 1
1 3 0 34 -1 0
1 27 0 34 -1 0
2 19 0 4 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 f r2
0
6
2 19 0 6 0 30 -1 0
1 18 0 30 -1 1
1 27 0 30 -1 1
1 18 0 34 -1 0
1 27 0 34 -1 0
2 19 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 tmp1 r2
0
6
2 19 0 14 0 30 -1 0
1 23 0 30 -1 1
1 27 0 30 -1 1
1 23 0 34 -1 0
1 27 0 34 -1 0
2 19 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 tmp2 r2
0
6
2 19 0 15 0 30 -1 0
1 27 0 30 -1 1
1 32 0 30 -1 1
1 27 0 34 -1 0
1 32 0 34 -1 0
2 19 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 x1 r2
0
6
2 19 0 20 0 30 -1 0
1 11 0 30 -1 1
1 27 0 30 -1 1
1 11 0 34 -1 0
1 27 0 34 -1 0
2 19 0 20 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 y1 r2
0
6
2 35 0 19 0 30 -1 0
1 9 0 30 -1 1
1 27 0 30 -1 1
1 9 0 34 -1 0
1 27 0 34 -1 0
2 35 0 19 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 z1 r2
0
6
2 19 0 7 0 30 -1 0
1 8 0 30 -1 1
1 27 0 30 -1 1
1 8 0 34 -1 0
1 27 0 34 -1 0
2 19 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 t r2
0
6
2 4 0 7 0 30 -1 0
1 3 0 30 -1 1
1 8 0 30 -1 1
1 3 0 34 -1 0
1 8 0 34 -1 0
2 4 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 f r2
0
6
2 6 0 7 0 30 -1 0
1 8 0 30 -1 1
1 18 0 30 -1 1
1 8 0 34 -1 0
1 18 0 34 -1 0
2 6 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 tmp1 r2
0
6
2 14 0 7 0 30 -1 0
1 8 0 30 -1 1
1 23 0 30 -1 1
1 8 0 34 -1 0
1 23 0 34 -1 0
2 14 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 tmp2 r2
0
6
2 15 0 7 0 30 -1 0
1 8 0 30 -1 1
1 32 0 30 -1 1
1 8 0 34 -1 0
1 32 0 34 -1 0
2 15 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 x1 r2
0
6
2 20 0 7 0 30 -1 0
1 8 0 30 -1 1
1 11 0 30 -1 1
1 8 0 34 -1 0
1 11 0 34 -1 0
2 20 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 y1 r2
0
6
2 35 0 7 0 30 -1 0
1 8 0 30 -1 1
1 9 0 30 -1 1
1 8 0 34 -1 0
1 9 0 34 -1 0
2 35 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 r1 r2
0
6
2 19 0 7 0 30 -1 0
1 8 0 30 -1 1
1 27 0 30 -1 1
1 8 0 34 -1 0
1 27 0 34 -1 0
2 19 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate t r2 f
0
6
2 4 0 30 0 6 -1 0
1 3 0 6 -1 1
1 34 0 6 -1 1
1 3 0 18 -1 0
1 34 0 18 -1 0
2 4 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate t r2 tmp1
0
6
2 4 0 30 0 14 -1 0
1 3 0 14 -1 1
1 34 0 14 -1 1
1 3 0 23 -1 0
1 34 0 23 -1 0
2 4 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate t r2 tmp2
0
6
2 4 0 30 0 15 -1 0
1 3 0 15 -1 1
1 34 0 15 -1 1
1 3 0 32 -1 0
1 34 0 32 -1 0
2 4 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate t r2 r1
0
6
2 4 0 30 0 19 -1 0
1 3 0 19 -1 1
1 34 0 19 -1 1
1 3 0 27 -1 0
1 34 0 27 -1 0
2 4 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate t r2 z1
0
6
2 4 0 30 0 7 -1 0
1 3 0 7 -1 1
1 34 0 7 -1 1
1 3 0 8 -1 0
1 34 0 8 -1 0
2 4 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate f r2 t
0
6
1 18 0 3 -1 0
1 34 0 3 -1 0
2 30 0 6 0 3 -1 1
2 30 0 6 0 4 -1 0
1 18 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate f r2 tmp1
0
6
2 30 0 6 0 14 -1 0
1 18 0 14 -1 1
1 34 0 14 -1 1
1 18 0 23 -1 0
1 34 0 23 -1 0
2 30 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate f r2 tmp2
0
6
2 30 0 6 0 15 -1 0
1 18 0 15 -1 1
1 34 0 15 -1 1
1 18 0 32 -1 0
1 34 0 32 -1 0
2 30 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate f r2 r1
0
6
2 30 0 6 0 19 -1 0
1 18 0 19 -1 1
1 34 0 19 -1 1
1 18 0 27 -1 0
1 34 0 27 -1 0
2 30 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate f r2 z1
0
6
2 30 0 6 0 7 -1 0
1 18 0 7 -1 1
1 34 0 7 -1 1
1 18 0 8 -1 0
1 34 0 8 -1 0
2 30 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 r2 t
0
6
1 23 0 3 -1 0
1 34 0 3 -1 0
2 30 0 14 0 3 -1 1
2 30 0 14 0 4 -1 0
1 23 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 r2 f
0
6
2 30 0 14 0 6 -1 0
1 23 0 6 -1 1
1 34 0 6 -1 1
1 23 0 18 -1 0
1 34 0 18 -1 0
2 30 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp1 r2 tmp2
0
6
2 30 0 14 0 15 -1 0
1 23 0 15 -1 1
1 34 0 15 -1 1
1 23 0 32 -1 0
1 34 0 32 -1 0
2 30 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 r2 r1
0
6
2 30 0 14 0 19 -1 0
1 23 0 19 -1 1
1 34 0 19 -1 1
1 23 0 27 -1 0
1 34 0 27 -1 0
2 30 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 r2 z1
0
6
2 30 0 14 0 7 -1 0
1 23 0 7 -1 1
1 34 0 7 -1 1
1 23 0 8 -1 0
1 34 0 8 -1 0
2 30 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 r2 t
0
6
1 32 0 3 -1 0
1 34 0 3 -1 0
2 30 0 15 0 3 -1 1
2 30 0 15 0 4 -1 0
1 32 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 r2 f
0
6
2 30 0 15 0 6 -1 0
1 32 0 6 -1 1
1 34 0 6 -1 1
1 32 0 18 -1 0
1 34 0 18 -1 0
2 30 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 r2 tmp1
0
6
2 30 0 15 0 14 -1 0
1 32 0 14 -1 1
1 34 0 14 -1 1
1 32 0 23 -1 0
1 34 0 23 -1 0
2 30 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate tmp2 r2 r1
0
6
2 30 0 15 0 19 -1 0
1 32 0 19 -1 1
1 34 0 19 -1 1
1 32 0 27 -1 0
1 34 0 27 -1 0
2 30 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 r2 z1
0
6
2 30 0 15 0 7 -1 0
1 32 0 7 -1 1
1 34 0 7 -1 1
1 32 0 8 -1 0
1 34 0 8 -1 0
2 30 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 r2 t
0
6
1 11 0 3 -1 0
1 34 0 3 -1 0
2 20 0 30 0 3 -1 1
2 20 0 30 0 4 -1 0
1 11 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 r2 f
0
6
2 20 0 30 0 6 -1 0
1 11 0 6 -1 1
1 34 0 6 -1 1
1 11 0 18 -1 0
1 34 0 18 -1 0
2 20 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 r2 tmp1
0
6
2 20 0 30 0 14 -1 0
1 11 0 14 -1 1
1 34 0 14 -1 1
1 11 0 23 -1 0
1 34 0 23 -1 0
2 20 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 r2 tmp2
0
6
2 20 0 30 0 15 -1 0
1 11 0 15 -1 1
1 34 0 15 -1 1
1 11 0 32 -1 0
1 34 0 32 -1 0
2 20 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate x1 r2 r1
0
6
2 20 0 30 0 19 -1 0
1 11 0 19 -1 1
1 34 0 19 -1 1
1 11 0 27 -1 0
1 34 0 27 -1 0
2 20 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 r2 z1
0
6
2 20 0 30 0 7 -1 0
1 11 0 7 -1 1
1 34 0 7 -1 1
1 11 0 8 -1 0
1 34 0 8 -1 0
2 20 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 r2 t
0
6
1 9 0 3 -1 0
1 34 0 3 -1 0
2 35 0 30 0 3 -1 1
2 35 0 30 0 4 -1 0
1 9 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 r2 f
0
6
2 35 0 30 0 6 -1 0
1 9 0 6 -1 1
1 34 0 6 -1 1
1 9 0 18 -1 0
1 34 0 18 -1 0
2 35 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 r2 tmp1
0
6
2 35 0 30 0 14 -1 0
1 9 0 14 -1 1
1 34 0 14 -1 1
1 9 0 23 -1 0
1 34 0 23 -1 0
2 35 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 r2 tmp2
0
6
2 35 0 30 0 15 -1 0
1 9 0 15 -1 1
1 34 0 15 -1 1
1 9 0 32 -1 0
1 34 0 32 -1 0
2 35 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 r2 r1
0
6
2 35 0 30 0 19 -1 0
1 9 0 19 -1 1
1 34 0 19 -1 1
1 9 0 27 -1 0
1 34 0 27 -1 0
2 35 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 r2 z1
0
6
2 35 0 30 0 7 -1 0
1 9 0 7 -1 1
1 34 0 7 -1 1
1 9 0 8 -1 0
1 34 0 8 -1 0
2 35 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 r2 t
0
6
1 27 0 3 -1 0
1 34 0 3 -1 0
2 19 0 30 0 3 -1 1
2 19 0 30 0 4 -1 0
1 27 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 r2 f
0
6
2 19 0 30 0 6 -1 0
1 27 0 6 -1 1
1 34 0 6 -1 1
1 27 0 18 -1 0
1 34 0 18 -1 0
2 19 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 r2 tmp1
0
6
2 19 0 30 0 14 -1 0
1 27 0 14 -1 1
1 34 0 14 -1 1
1 27 0 23 -1 0
1 34 0 23 -1 0
2 19 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 r2 tmp2
0
6
2 19 0 30 0 15 -1 0
1 27 0 15 -1 1
1 34 0 15 -1 1
1 27 0 32 -1 0
1 34 0 32 -1 0
2 19 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 r2 z1
0
6
2 19 0 30 0 7 -1 0
1 27 0 7 -1 1
1 34 0 7 -1 1
1 27 0 8 -1 0
1 34 0 8 -1 0
2 19 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate z1 r2 t
0
6
1 8 0 3 -1 0
1 34 0 3 -1 0
2 30 0 7 0 3 -1 1
2 30 0 7 0 4 -1 0
1 8 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 r2 f
0
6
2 30 0 7 0 6 -1 0
1 8 0 6 -1 1
1 34 0 6 -1 1
1 8 0 18 -1 0
1 34 0 18 -1 0
2 30 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 r2 tmp1
0
6
2 30 0 7 0 14 -1 0
1 8 0 14 -1 1
1 34 0 14 -1 1
1 8 0 23 -1 0
1 34 0 23 -1 0
2 30 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 r2 tmp2
0
6
2 30 0 7 0 15 -1 0
1 8 0 15 -1 1
1 34 0 15 -1 1
1 8 0 32 -1 0
1 34 0 32 -1 0
2 30 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 r2 r1
0
6
2 30 0 7 0 19 -1 0
1 8 0 19 -1 1
1 34 0 19 -1 1
1 8 0 27 -1 0
1 34 0 27 -1 0
2 30 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 f t
0
8
2 18 0 30 0 3 -1 0
2 34 0 6 0 3 -1 0
2 6 0 30 0 3 -1 1
2 34 0 18 0 3 -1 1
2 6 0 30 0 4 -1 0
2 34 0 18 0 4 -1 0
2 18 0 30 0 4 -1 1
2 34 0 6 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp1 t
0
8
2 30 0 23 0 3 -1 0
2 34 0 14 0 3 -1 0
2 14 0 30 0 3 -1 1
2 34 0 23 0 3 -1 1
2 14 0 30 0 4 -1 0
2 34 0 23 0 4 -1 0
2 30 0 23 0 4 -1 1
2 34 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp2 t
0
8
2 32 0 30 0 3 -1 0
2 34 0 15 0 3 -1 0
2 30 0 15 0 3 -1 1
2 32 0 34 0 3 -1 1
2 30 0 15 0 4 -1 0
2 32 0 34 0 4 -1 0
2 32 0 30 0 4 -1 1
2 34 0 15 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 t
0
8
2 11 0 30 0 3 -1 0
2 34 0 20 0 3 -1 0
2 20 0 30 0 3 -1 1
2 34 0 11 0 3 -1 1
2 20 0 30 0 4 -1 0
2 34 0 11 0 4 -1 0
2 11 0 30 0 4 -1 1
2 34 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 t
0
8
2 9 0 30 0 3 -1 0
2 34 0 35 0 3 -1 0
2 9 0 34 0 3 -1 1
2 35 0 30 0 3 -1 1
2 9 0 34 0 4 -1 0
2 35 0 30 0 4 -1 0
2 9 0 30 0 4 -1 1
2 34 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 r1 t
0
8
2 27 0 30 0 3 -1 0
2 34 0 19 0 3 -1 0
2 19 0 30 0 3 -1 1
2 34 0 27 0 3 -1 1
2 19 0 30 0 4 -1 0
2 34 0 27 0 4 -1 0
2 27 0 30 0 4 -1 1
2 34 0 19 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 z1 t
0
8
2 8 0 30 0 3 -1 0
2 34 0 7 0 3 -1 0
2 8 0 34 0 3 -1 1
2 30 0 7 0 3 -1 1
2 8 0 34 0 4 -1 0
2 30 0 7 0 4 -1 0
2 8 0 30 0 4 -1 1
2 34 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 t f
0
8
2 4 0 30 0 6 -1 0
2 34 0 3 0 6 -1 0
2 3 0 30 0 6 -1 1
2 34 0 4 0 6 -1 1
2 3 0 30 0 18 -1 0
2 34 0 4 0 18 -1 0
2 4 0 30 0 18 -1 1
2 34 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp1 f
0
8
2 14 0 30 0 6 -1 0
2 34 0 23 0 6 -1 0
2 30 0 23 0 6 -1 1
2 34 0 14 0 6 -1 1
2 30 0 23 0 18 -1 0
2 34 0 14 0 18 -1 0
2 14 0 30 0 18 -1 1
2 34 0 23 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp2 f
0
8
2 30 0 15 0 6 -1 0
2 32 0 34 0 6 -1 0
2 32 0 30 0 6 -1 1
2 34 0 15 0 6 -1 1
2 32 0 30 0 18 -1 0
2 34 0 15 0 18 -1 0
2 30 0 15 0 18 -1 1
2 32 0 34 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 f
0
8
2 20 0 30 0 6 -1 0
2 34 0 11 0 6 -1 0
2 11 0 30 0 6 -1 1
2 34 0 20 0 6 -1 1
2 11 0 30 0 18 -1 0
2 34 0 20 0 18 -1 0
2 20 0 30 0 18 -1 1
2 34 0 11 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 f
0
8
2 9 0 34 0 6 -1 0
2 35 0 30 0 6 -1 0
2 9 0 30 0 6 -1 1
2 34 0 35 0 6 -1 1
2 9 0 30 0 18 -1 0
2 34 0 35 0 18 -1 0
2 9 0 34 0 18 -1 1
2 35 0 30 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 r1 f
0
8
2 19 0 30 0 6 -1 0
2 34 0 27 0 6 -1 0
2 27 0 30 0 6 -1 1
2 34 0 19 0 6 -1 1
2 27 0 30 0 18 -1 0
2 34 0 19 0 18 -1 0
2 19 0 30 0 18 -1 1
2 34 0 27 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 z1 f
0
8
2 8 0 34 0 6 -1 0
2 30 0 7 0 6 -1 0
2 8 0 30 0 6 -1 1
2 34 0 7 0 6 -1 1
2 8 0 30 0 18 -1 0
2 34 0 7 0 18 -1 0
2 8 0 34 0 18 -1 1
2 30 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 t tmp1
0
8
2 4 0 30 0 14 -1 0
2 34 0 3 0 14 -1 0
2 3 0 30 0 14 -1 1
2 34 0 4 0 14 -1 1
2 3 0 30 0 23 -1 0
2 34 0 4 0 23 -1 0
2 4 0 30 0 23 -1 1
2 34 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 f tmp1
0
8
2 6 0 30 0 14 -1 0
2 34 0 18 0 14 -1 0
2 18 0 30 0 14 -1 1
2 34 0 6 0 14 -1 1
2 18 0 30 0 23 -1 0
2 34 0 6 0 23 -1 0
2 6 0 30 0 23 -1 1
2 34 0 18 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp2 tmp1
0
8
2 30 0 15 0 14 -1 0
2 32 0 34 0 14 -1 0
2 32 0 30 0 14 -1 1
2 34 0 15 0 14 -1 1
2 32 0 30 0 23 -1 0
2 34 0 15 0 23 -1 0
2 30 0 15 0 23 -1 1
2 32 0 34 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 tmp1
0
8
2 20 0 30 0 14 -1 0
2 34 0 11 0 14 -1 0
2 11 0 30 0 14 -1 1
2 34 0 20 0 14 -1 1
2 11 0 30 0 23 -1 0
2 34 0 20 0 23 -1 0
2 20 0 30 0 23 -1 1
2 34 0 11 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 tmp1
0
8
2 9 0 34 0 14 -1 0
2 35 0 30 0 14 -1 0
2 9 0 30 0 14 -1 1
2 34 0 35 0 14 -1 1
2 9 0 30 0 23 -1 0
2 34 0 35 0 23 -1 0
2 9 0 34 0 23 -1 1
2 35 0 30 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 r1 tmp1
0
8
2 19 0 30 0 14 -1 0
2 34 0 27 0 14 -1 0
2 27 0 30 0 14 -1 1
2 34 0 19 0 14 -1 1
2 27 0 30 0 23 -1 0
2 34 0 19 0 23 -1 0
2 19 0 30 0 23 -1 1
2 34 0 27 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 z1 tmp1
0
8
2 8 0 34 0 14 -1 0
2 30 0 7 0 14 -1 0
2 8 0 30 0 14 -1 1
2 34 0 7 0 14 -1 1
2 8 0 30 0 23 -1 0
2 34 0 7 0 23 -1 0
2 8 0 34 0 23 -1 1
2 30 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 t tmp2
0
8
2 4 0 30 0 15 -1 0
2 34 0 3 0 15 -1 0
2 3 0 30 0 15 -1 1
2 34 0 4 0 15 -1 1
2 3 0 30 0 32 -1 0
2 34 0 4 0 32 -1 0
2 4 0 30 0 32 -1 1
2 34 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 f tmp2
0
8
2 6 0 30 0 15 -1 0
2 34 0 18 0 15 -1 0
2 18 0 30 0 15 -1 1
2 34 0 6 0 15 -1 1
2 18 0 30 0 32 -1 0
2 34 0 6 0 32 -1 0
2 6 0 30 0 32 -1 1
2 34 0 18 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp1 tmp2
0
8
2 14 0 30 0 15 -1 0
2 34 0 23 0 15 -1 0
2 30 0 23 0 15 -1 1
2 34 0 14 0 15 -1 1
2 30 0 23 0 32 -1 0
2 34 0 14 0 32 -1 0
2 14 0 30 0 32 -1 1
2 34 0 23 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 tmp2
0
8
2 20 0 30 0 15 -1 0
2 34 0 11 0 15 -1 0
2 11 0 30 0 15 -1 1
2 34 0 20 0 15 -1 1
2 11 0 30 0 32 -1 0
2 34 0 20 0 32 -1 0
2 20 0 30 0 32 -1 1
2 34 0 11 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 tmp2
0
8
2 9 0 34 0 15 -1 0
2 35 0 30 0 15 -1 0
2 9 0 30 0 15 -1 1
2 34 0 35 0 15 -1 1
2 9 0 30 0 32 -1 0
2 34 0 35 0 32 -1 0
2 9 0 34 0 32 -1 1
2 35 0 30 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 r1 tmp2
0
8
2 19 0 30 0 15 -1 0
2 34 0 27 0 15 -1 0
2 27 0 30 0 15 -1 1
2 34 0 19 0 15 -1 1
2 27 0 30 0 32 -1 0
2 34 0 19 0 32 -1 0
2 19 0 30 0 32 -1 1
2 34 0 27 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 z1 tmp2
0
8
2 8 0 34 0 15 -1 0
2 30 0 7 0 15 -1 0
2 8 0 30 0 15 -1 1
2 34 0 7 0 15 -1 1
2 8 0 30 0 32 -1 0
2 34 0 7 0 32 -1 0
2 8 0 34 0 32 -1 1
2 30 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 t r1
0
8
2 4 0 30 0 19 -1 0
2 34 0 3 0 19 -1 0
2 3 0 30 0 19 -1 1
2 34 0 4 0 19 -1 1
2 3 0 30 0 27 -1 0
2 34 0 4 0 27 -1 0
2 4 0 30 0 27 -1 1
2 34 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 f r1
0
8
2 6 0 30 0 19 -1 0
2 34 0 18 0 19 -1 0
2 18 0 30 0 19 -1 1
2 34 0 6 0 19 -1 1
2 18 0 30 0 27 -1 0
2 34 0 6 0 27 -1 0
2 6 0 30 0 27 -1 1
2 34 0 18 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp1 r1
0
8
2 14 0 30 0 19 -1 0
2 34 0 23 0 19 -1 0
2 30 0 23 0 19 -1 1
2 34 0 14 0 19 -1 1
2 30 0 23 0 27 -1 0
2 34 0 14 0 27 -1 0
2 14 0 30 0 27 -1 1
2 34 0 23 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp2 r1
0
8
2 30 0 15 0 19 -1 0
2 32 0 34 0 19 -1 0
2 32 0 30 0 19 -1 1
2 34 0 15 0 19 -1 1
2 32 0 30 0 27 -1 0
2 34 0 15 0 27 -1 0
2 30 0 15 0 27 -1 1
2 32 0 34 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 r1
0
8
2 20 0 30 0 19 -1 0
2 34 0 11 0 19 -1 0
2 11 0 30 0 19 -1 1
2 34 0 20 0 19 -1 1
2 11 0 30 0 27 -1 0
2 34 0 20 0 27 -1 0
2 20 0 30 0 27 -1 1
2 34 0 11 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 r1
0
8
2 9 0 34 0 19 -1 0
2 35 0 30 0 19 -1 0
2 9 0 30 0 19 -1 1
2 34 0 35 0 19 -1 1
2 9 0 30 0 27 -1 0
2 34 0 35 0 27 -1 0
2 9 0 34 0 27 -1 1
2 35 0 30 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 z1 r1
0
8
2 8 0 34 0 19 -1 0
2 30 0 7 0 19 -1 0
2 8 0 30 0 19 -1 1
2 34 0 7 0 19 -1 1
2 8 0 30 0 27 -1 0
2 34 0 7 0 27 -1 0
2 8 0 34 0 27 -1 1
2 30 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 t z1
0
8
2 4 0 30 0 7 -1 0
2 34 0 3 0 7 -1 0
2 3 0 30 0 7 -1 1
2 34 0 4 0 7 -1 1
2 3 0 30 0 8 -1 0
2 34 0 4 0 8 -1 0
2 4 0 30 0 8 -1 1
2 34 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate r2 f z1
0
8
2 6 0 30 0 7 -1 0
2 34 0 18 0 7 -1 0
2 18 0 30 0 7 -1 1
2 34 0 6 0 7 -1 1
2 18 0 30 0 8 -1 0
2 34 0 6 0 8 -1 0
2 6 0 30 0 8 -1 1
2 34 0 18 0 8 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp1 z1
0
8
2 14 0 30 0 7 -1 0
2 34 0 23 0 7 -1 0
2 30 0 23 0 7 -1 1
2 34 0 14 0 7 -1 1
2 30 0 23 0 8 -1 0
2 34 0 14 0 8 -1 0
2 14 0 30 0 8 -1 1
2 34 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp2 z1
0
8
2 30 0 15 0 7 -1 0
2 32 0 34 0 7 -1 0
2 32 0 30 0 7 -1 1
2 34 0 15 0 7 -1 1
2 32 0 30 0 8 -1 0
2 34 0 15 0 8 -1 0
2 30 0 15 0 8 -1 1
2 32 0 34 0 8 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 z1
0
8
2 20 0 30 0 7 -1 0
2 34 0 11 0 7 -1 0
2 11 0 30 0 7 -1 1
2 34 0 20 0 7 -1 1
2 11 0 30 0 8 -1 0
2 34 0 20 0 8 -1 0
2 20 0 30 0 8 -1 1
2 34 0 11 0 8 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 z1
0
8
2 9 0 34 0 7 -1 0
2 35 0 30 0 7 -1 0
2 9 0 30 0 7 -1 1
2 34 0 35 0 7 -1 1
2 9 0 30 0 8 -1 0
2 34 0 35 0 8 -1 0
2 9 0 34 0 8 -1 1
2 35 0 30 0 8 -1 1
0
end_operator
begin_operator
xor-gate r2 r1 z1
0
8
2 19 0 30 0 7 -1 0
2 34 0 27 0 7 -1 0
2 27 0 30 0 7 -1 1
2 34 0 19 0 7 -1 1
2 27 0 30 0 8 -1 0
2 34 0 19 0 8 -1 0
2 19 0 30 0 8 -1 1
2 34 0 27 0 8 -1 1
0
end_operator
begin_operator
xor-gate t f r2
0
8
2 4 0 6 0 30 -1 0
2 18 0 3 0 30 -1 0
2 3 0 6 0 30 -1 1
2 18 0 4 0 30 -1 1
2 3 0 6 0 34 -1 0
2 18 0 4 0 34 -1 0
2 4 0 6 0 34 -1 1
2 18 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate t tmp1 r2
0
8
2 3 0 23 0 30 -1 0
2 4 0 14 0 30 -1 0
2 3 0 14 0 30 -1 1
2 4 0 23 0 30 -1 1
2 3 0 14 0 34 -1 0
2 4 0 23 0 34 -1 0
2 3 0 23 0 34 -1 1
2 4 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate t tmp2 r2
0
8
2 4 0 15 0 30 -1 0
2 32 0 3 0 30 -1 0
2 3 0 15 0 30 -1 1
2 32 0 4 0 30 -1 1
2 3 0 15 0 34 -1 0
2 32 0 4 0 34 -1 0
2 4 0 15 0 34 -1 1
2 32 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate t x1 r2
0
8
2 11 0 3 0 30 -1 0
2 20 0 4 0 30 -1 0
2 3 0 20 0 30 -1 1
2 11 0 4 0 30 -1 1
2 3 0 20 0 34 -1 0
2 11 0 4 0 34 -1 0
2 11 0 3 0 34 -1 1
2 20 0 4 0 34 -1 1
0
end_operator
begin_operator
xor-gate t y1 r2
0
8
2 9 0 3 0 30 -1 0
2 35 0 4 0 30 -1 0
2 9 0 4 0 30 -1 1
2 35 0 3 0 30 -1 1
2 9 0 4 0 34 -1 0
2 35 0 3 0 34 -1 0
2 9 0 3 0 34 -1 1
2 35 0 4 0 34 -1 1
0
end_operator
begin_operator
xor-gate t r1 r2
0
8
2 19 0 4 0 30 -1 0
2 27 0 3 0 30 -1 0
2 19 0 3 0 30 -1 1
2 27 0 4 0 30 -1 1
2 19 0 3 0 34 -1 0
2 27 0 4 0 34 -1 0
2 19 0 4 0 34 -1 1
2 27 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate t z1 r2
0
8
2 4 0 7 0 30 -1 0
2 8 0 3 0 30 -1 0
2 3 0 7 0 30 -1 1
2 8 0 4 0 30 -1 1
2 3 0 7 0 34 -1 0
2 8 0 4 0 34 -1 0
2 4 0 7 0 34 -1 1
2 8 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate f t r2
0
8
2 4 0 6 0 30 -1 0
2 18 0 3 0 30 -1 0
2 3 0 6 0 30 -1 1
2 18 0 4 0 30 -1 1
2 3 0 6 0 34 -1 0
2 18 0 4 0 34 -1 0
2 4 0 6 0 34 -1 1
2 18 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate f tmp1 r2
0
8
2 14 0 6 0 30 -1 0
2 18 0 23 0 30 -1 0
2 6 0 23 0 30 -1 1
2 18 0 14 0 30 -1 1
2 6 0 23 0 34 -1 0
2 18 0 14 0 34 -1 0
2 14 0 6 0 34 -1 1
2 18 0 23 0 34 -1 1
0
end_operator
begin_operator
xor-gate f tmp2 r2
0
8
2 6 0 15 0 30 -1 0
2 32 0 18 0 30 -1 0
2 18 0 15 0 30 -1 1
2 32 0 6 0 30 -1 1
2 18 0 15 0 34 -1 0
2 32 0 6 0 34 -1 0
2 6 0 15 0 34 -1 1
2 32 0 18 0 34 -1 1
0
end_operator
begin_operator
xor-gate f x1 r2
0
8
2 18 0 11 0 30 -1 0
2 20 0 6 0 30 -1 0
2 11 0 6 0 30 -1 1
2 18 0 20 0 30 -1 1
2 11 0 6 0 34 -1 0
2 18 0 20 0 34 -1 0
2 18 0 11 0 34 -1 1
2 20 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate f y1 r2
0
8
2 9 0 18 0 30 -1 0
2 35 0 6 0 30 -1 0
2 9 0 6 0 30 -1 1
2 18 0 35 0 30 -1 1
2 9 0 6 0 34 -1 0
2 18 0 35 0 34 -1 0
2 9 0 18 0 34 -1 1
2 35 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate f r1 r2
0
8
2 18 0 27 0 30 -1 0
2 19 0 6 0 30 -1 0
2 18 0 19 0 30 -1 1
2 27 0 6 0 30 -1 1
2 18 0 19 0 34 -1 0
2 27 0 6 0 34 -1 0
2 18 0 27 0 34 -1 1
2 19 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate f z1 r2
0
8
2 6 0 7 0 30 -1 0
2 8 0 18 0 30 -1 0
2 8 0 6 0 30 -1 1
2 18 0 7 0 30 -1 1
2 8 0 6 0 34 -1 0
2 18 0 7 0 34 -1 0
2 6 0 7 0 34 -1 1
2 8 0 18 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 t r2
0
8
2 3 0 23 0 30 -1 0
2 4 0 14 0 30 -1 0
2 3 0 14 0 30 -1 1
2 4 0 23 0 30 -1 1
2 3 0 14 0 34 -1 0
2 4 0 23 0 34 -1 0
2 3 0 23 0 34 -1 1
2 4 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 f r2
0
8
2 6 0 14 0 30 -1 0
2 18 0 23 0 30 -1 0
2 6 0 23 0 30 -1 1
2 18 0 14 0 30 -1 1
2 6 0 23 0 34 -1 0
2 18 0 14 0 34 -1 0
2 6 0 14 0 34 -1 1
2 18 0 23 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 tmp2 r2
0
8
2 14 0 15 0 30 -1 0
2 32 0 23 0 30 -1 0
2 15 0 23 0 30 -1 1
2 32 0 14 0 30 -1 1
2 15 0 23 0 34 -1 0
2 32 0 14 0 34 -1 0
2 14 0 15 0 34 -1 1
2 32 0 23 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 r2
0
8
2 11 0 23 0 30 -1 0
2 20 0 14 0 30 -1 0
2 11 0 14 0 30 -1 1
2 20 0 23 0 30 -1 1
2 11 0 14 0 34 -1 0
2 20 0 23 0 34 -1 0
2 11 0 23 0 34 -1 1
2 20 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 r2
0
8
2 9 0 23 0 30 -1 0
2 35 0 14 0 30 -1 0
2 9 0 14 0 30 -1 1
2 35 0 23 0 30 -1 1
2 9 0 14 0 34 -1 0
2 35 0 23 0 34 -1 0
2 9 0 23 0 34 -1 1
2 35 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r1 r2
0
8
2 19 0 14 0 30 -1 0
2 27 0 23 0 30 -1 0
2 19 0 23 0 30 -1 1
2 27 0 14 0 30 -1 1
2 19 0 23 0 34 -1 0
2 27 0 14 0 34 -1 0
2 19 0 14 0 34 -1 1
2 27 0 23 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z1 r2
0
8
2 8 0 23 0 30 -1 0
2 14 0 7 0 30 -1 0
2 7 0 23 0 30 -1 1
2 8 0 14 0 30 -1 1
2 7 0 23 0 34 -1 0
2 8 0 14 0 34 -1 0
2 8 0 23 0 34 -1 1
2 14 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 t r2
0
8
2 4 0 15 0 30 -1 0
2 32 0 3 0 30 -1 0
2 3 0 15 0 30 -1 1
2 32 0 4 0 30 -1 1
2 3 0 15 0 34 -1 0
2 32 0 4 0 34 -1 0
2 4 0 15 0 34 -1 1
2 32 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 f r2
0
8
2 6 0 15 0 30 -1 0
2 32 0 18 0 30 -1 0
2 18 0 15 0 30 -1 1
2 32 0 6 0 30 -1 1
2 18 0 15 0 34 -1 0
2 32 0 6 0 34 -1 0
2 6 0 15 0 34 -1 1
2 32 0 18 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 tmp1 r2
0
8
2 14 0 15 0 30 -1 0
2 32 0 23 0 30 -1 0
2 23 0 15 0 30 -1 1
2 32 0 14 0 30 -1 1
2 23 0 15 0 34 -1 0
2 32 0 14 0 34 -1 0
2 14 0 15 0 34 -1 1
2 32 0 23 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 r2
0
8
2 20 0 15 0 30 -1 0
2 32 0 11 0 30 -1 0
2 11 0 15 0 30 -1 1
2 32 0 20 0 30 -1 1
2 11 0 15 0 34 -1 0
2 32 0 20 0 34 -1 0
2 20 0 15 0 34 -1 1
2 32 0 11 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 r2
0
8
2 32 0 9 0 30 -1 0
2 35 0 15 0 30 -1 0
2 9 0 15 0 30 -1 1
2 32 0 35 0 30 -1 1
2 9 0 15 0 34 -1 0
2 32 0 35 0 34 -1 0
2 32 0 9 0 34 -1 1
2 35 0 15 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r1 r2
0
8
2 19 0 15 0 30 -1 0
2 32 0 27 0 30 -1 0
2 27 0 15 0 30 -1 1
2 32 0 19 0 30 -1 1
2 27 0 15 0 34 -1 0
2 32 0 19 0 34 -1 0
2 19 0 15 0 34 -1 1
2 32 0 27 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z1 r2
0
8
2 7 0 15 0 30 -1 0
2 32 0 8 0 30 -1 0
2 8 0 15 0 30 -1 1
2 32 0 7 0 30 -1 1
2 8 0 15 0 34 -1 0
2 32 0 7 0 34 -1 0
2 7 0 15 0 34 -1 1
2 32 0 8 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 t r2
0
8
2 3 0 11 0 30 -1 0
2 4 0 20 0 30 -1 0
2 3 0 20 0 30 -1 1
2 11 0 4 0 30 -1 1
2 3 0 20 0 34 -1 0
2 11 0 4 0 34 -1 0
2 3 0 11 0 34 -1 1
2 4 0 20 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 f r2
0
8
2 18 0 11 0 30 -1 0
2 20 0 6 0 30 -1 0
2 11 0 6 0 30 -1 1
2 18 0 20 0 30 -1 1
2 11 0 6 0 34 -1 0
2 18 0 20 0 34 -1 0
2 18 0 11 0 34 -1 1
2 20 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 r2
0
8
2 11 0 23 0 30 -1 0
2 20 0 14 0 30 -1 0
2 11 0 14 0 30 -1 1
2 20 0 23 0 30 -1 1
2 11 0 14 0 34 -1 0
2 20 0 23 0 34 -1 0
2 11 0 23 0 34 -1 1
2 20 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 r2
0
8
2 20 0 15 0 30 -1 0
2 32 0 11 0 30 -1 0
2 11 0 15 0 30 -1 1
2 32 0 20 0 30 -1 1
2 11 0 15 0 34 -1 0
2 32 0 20 0 34 -1 0
2 20 0 15 0 34 -1 1
2 32 0 11 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 r2
0
8
2 9 0 11 0 30 -1 0
2 35 0 20 0 30 -1 0
2 9 0 20 0 30 -1 1
2 35 0 11 0 30 -1 1
2 9 0 20 0 34 -1 0
2 35 0 11 0 34 -1 0
2 9 0 11 0 34 -1 1
2 35 0 20 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 r2
0
8
2 19 0 20 0 30 -1 0
2 27 0 11 0 30 -1 0
2 19 0 11 0 30 -1 1
2 27 0 20 0 30 -1 1
2 19 0 11 0 34 -1 0
2 27 0 20 0 34 -1 0
2 19 0 20 0 34 -1 1
2 27 0 11 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 r2
0
8
2 8 0 11 0 30 -1 0
2 20 0 7 0 30 -1 0
2 8 0 20 0 30 -1 1
2 11 0 7 0 30 -1 1
2 8 0 20 0 34 -1 0
2 11 0 7 0 34 -1 0
2 8 0 11 0 34 -1 1
2 20 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 t r2
0
8
2 9 0 3 0 30 -1 0
2 35 0 4 0 30 -1 0
2 3 0 35 0 30 -1 1
2 9 0 4 0 30 -1 1
2 3 0 35 0 34 -1 0
2 9 0 4 0 34 -1 0
2 9 0 3 0 34 -1 1
2 35 0 4 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 f r2
0
8
2 9 0 18 0 30 -1 0
2 35 0 6 0 30 -1 0
2 9 0 6 0 30 -1 1
2 18 0 35 0 30 -1 1
2 9 0 6 0 34 -1 0
2 18 0 35 0 34 -1 0
2 9 0 18 0 34 -1 1
2 35 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 r2
0
8
2 9 0 23 0 30 -1 0
2 35 0 14 0 30 -1 0
2 9 0 14 0 30 -1 1
2 35 0 23 0 30 -1 1
2 9 0 14 0 34 -1 0
2 35 0 23 0 34 -1 0
2 9 0 23 0 34 -1 1
2 35 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 r2
0
8
2 32 0 9 0 30 -1 0
2 35 0 15 0 30 -1 0
2 9 0 15 0 30 -1 1
2 32 0 35 0 30 -1 1
2 9 0 15 0 34 -1 0
2 32 0 35 0 34 -1 0
2 32 0 9 0 34 -1 1
2 35 0 15 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 r2
0
8
2 9 0 11 0 30 -1 0
2 35 0 20 0 30 -1 0
2 9 0 20 0 30 -1 1
2 11 0 35 0 30 -1 1
2 9 0 20 0 34 -1 0
2 11 0 35 0 34 -1 0
2 9 0 11 0 34 -1 1
2 35 0 20 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 r2
0
8
2 9 0 27 0 30 -1 0
2 19 0 35 0 30 -1 0
2 9 0 19 0 30 -1 1
2 27 0 35 0 30 -1 1
2 9 0 19 0 34 -1 0
2 27 0 35 0 34 -1 0
2 9 0 27 0 34 -1 1
2 19 0 35 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 r2
0
8
2 8 0 9 0 30 -1 0
2 35 0 7 0 30 -1 0
2 8 0 35 0 30 -1 1
2 9 0 7 0 30 -1 1
2 8 0 35 0 34 -1 0
2 9 0 7 0 34 -1 0
2 8 0 9 0 34 -1 1
2 35 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 t r2
0
8
2 3 0 27 0 30 -1 0
2 19 0 4 0 30 -1 0
2 3 0 19 0 30 -1 1
2 27 0 4 0 30 -1 1
2 3 0 19 0 34 -1 0
2 27 0 4 0 34 -1 0
2 3 0 27 0 34 -1 1
2 19 0 4 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 f r2
0
8
2 18 0 27 0 30 -1 0
2 19 0 6 0 30 -1 0
2 18 0 19 0 30 -1 1
2 27 0 6 0 30 -1 1
2 18 0 19 0 34 -1 0
2 27 0 6 0 34 -1 0
2 18 0 27 0 34 -1 1
2 19 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp1 r2
0
8
2 19 0 14 0 30 -1 0
2 27 0 23 0 30 -1 0
2 19 0 23 0 30 -1 1
2 27 0 14 0 30 -1 1
2 19 0 23 0 34 -1 0
2 27 0 14 0 34 -1 0
2 19 0 14 0 34 -1 1
2 27 0 23 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp2 r2
0
8
2 19 0 15 0 30 -1 0
2 32 0 27 0 30 -1 0
2 27 0 15 0 30 -1 1
2 32 0 19 0 30 -1 1
2 27 0 15 0 34 -1 0
2 32 0 19 0 34 -1 0
2 19 0 15 0 34 -1 1
2 32 0 27 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 r2
0
8
2 11 0 27 0 30 -1 0
2 19 0 20 0 30 -1 0
2 11 0 19 0 30 -1 1
2 27 0 20 0 30 -1 1
2 11 0 19 0 34 -1 0
2 27 0 20 0 34 -1 0
2 11 0 27 0 34 -1 1
2 19 0 20 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 r2
0
8
2 9 0 27 0 30 -1 0
2 35 0 19 0 30 -1 0
2 9 0 19 0 30 -1 1
2 35 0 27 0 30 -1 1
2 9 0 19 0 34 -1 0
2 35 0 27 0 34 -1 0
2 9 0 27 0 34 -1 1
2 35 0 19 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 z1 r2
0
8
2 8 0 27 0 30 -1 0
2 19 0 7 0 30 -1 0
2 8 0 19 0 30 -1 1
2 27 0 7 0 30 -1 1
2 8 0 19 0 34 -1 0
2 27 0 7 0 34 -1 0
2 8 0 27 0 34 -1 1
2 19 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 t r2
0
8
2 4 0 7 0 30 -1 0
2 8 0 3 0 30 -1 0
2 3 0 7 0 30 -1 1
2 8 0 4 0 30 -1 1
2 3 0 7 0 34 -1 0
2 8 0 4 0 34 -1 0
2 4 0 7 0 34 -1 1
2 8 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 f r2
0
8
2 6 0 7 0 30 -1 0
2 8 0 18 0 30 -1 0
2 8 0 6 0 30 -1 1
2 18 0 7 0 30 -1 1
2 8 0 6 0 34 -1 0
2 18 0 7 0 34 -1 0
2 6 0 7 0 34 -1 1
2 8 0 18 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp1 r2
0
8
2 8 0 23 0 30 -1 0
2 14 0 7 0 30 -1 0
2 8 0 14 0 30 -1 1
2 23 0 7 0 30 -1 1
2 8 0 14 0 34 -1 0
2 23 0 7 0 34 -1 0
2 8 0 23 0 34 -1 1
2 14 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp2 r2
0
8
2 8 0 32 0 30 -1 0
2 15 0 7 0 30 -1 0
2 8 0 15 0 30 -1 1
2 32 0 7 0 30 -1 1
2 8 0 15 0 34 -1 0
2 32 0 7 0 34 -1 0
2 8 0 32 0 34 -1 1
2 15 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 r2
0
8
2 8 0 11 0 30 -1 0
2 20 0 7 0 30 -1 0
2 8 0 20 0 30 -1 1
2 11 0 7 0 30 -1 1
2 8 0 20 0 34 -1 0
2 11 0 7 0 34 -1 0
2 8 0 11 0 34 -1 1
2 20 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 r2
0
8
2 8 0 9 0 30 -1 0
2 35 0 7 0 30 -1 0
2 8 0 35 0 30 -1 1
2 9 0 7 0 30 -1 1
2 8 0 35 0 34 -1 0
2 9 0 7 0 34 -1 0
2 8 0 9 0 34 -1 1
2 35 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 r1 r2
0
8
2 8 0 27 0 30 -1 0
2 19 0 7 0 30 -1 0
2 8 0 19 0 30 -1 1
2 27 0 7 0 30 -1 1
2 8 0 19 0 34 -1 0
2 27 0 7 0 34 -1 0
2 8 0 27 0 34 -1 1
2 19 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate t r2 f
0
8
2 4 0 30 0 6 -1 0
2 34 0 3 0 6 -1 0
2 3 0 30 0 6 -1 1
2 34 0 4 0 6 -1 1
2 3 0 30 0 18 -1 0
2 34 0 4 0 18 -1 0
2 4 0 30 0 18 -1 1
2 34 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate t r2 tmp1
0
8
2 4 0 30 0 14 -1 0
2 34 0 3 0 14 -1 0
2 3 0 30 0 14 -1 1
2 34 0 4 0 14 -1 1
2 3 0 30 0 23 -1 0
2 34 0 4 0 23 -1 0
2 4 0 30 0 23 -1 1
2 34 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate t r2 tmp2
0
8
2 4 0 30 0 15 -1 0
2 34 0 3 0 15 -1 0
2 3 0 30 0 15 -1 1
2 34 0 4 0 15 -1 1
2 3 0 30 0 32 -1 0
2 34 0 4 0 32 -1 0
2 4 0 30 0 32 -1 1
2 34 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate t r2 r1
0
8
2 4 0 30 0 19 -1 0
2 34 0 3 0 19 -1 0
2 3 0 30 0 19 -1 1
2 34 0 4 0 19 -1 1
2 3 0 30 0 27 -1 0
2 34 0 4 0 27 -1 0
2 4 0 30 0 27 -1 1
2 34 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate t r2 z1
0
8
2 4 0 30 0 7 -1 0
2 34 0 3 0 7 -1 0
2 3 0 30 0 7 -1 1
2 34 0 4 0 7 -1 1
2 3 0 30 0 8 -1 0
2 34 0 4 0 8 -1 0
2 4 0 30 0 8 -1 1
2 34 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate f r2 t
0
8
2 18 0 30 0 3 -1 0
2 34 0 6 0 3 -1 0
2 18 0 34 0 3 -1 1
2 30 0 6 0 3 -1 1
2 18 0 34 0 4 -1 0
2 30 0 6 0 4 -1 0
2 18 0 30 0 4 -1 1
2 34 0 6 0 4 -1 1
0
end_operator
begin_operator
xor-gate f r2 tmp1
0
8
2 18 0 34 0 14 -1 0
2 30 0 6 0 14 -1 0
2 18 0 30 0 14 -1 1
2 34 0 6 0 14 -1 1
2 18 0 30 0 23 -1 0
2 34 0 6 0 23 -1 0
2 18 0 34 0 23 -1 1
2 30 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate f r2 tmp2
0
8
2 18 0 34 0 15 -1 0
2 30 0 6 0 15 -1 0
2 18 0 30 0 15 -1 1
2 34 0 6 0 15 -1 1
2 18 0 30 0 32 -1 0
2 34 0 6 0 32 -1 0
2 18 0 34 0 32 -1 1
2 30 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate f r2 r1
0
8
2 18 0 34 0 19 -1 0
2 30 0 6 0 19 -1 0
2 18 0 30 0 19 -1 1
2 34 0 6 0 19 -1 1
2 18 0 30 0 27 -1 0
2 34 0 6 0 27 -1 0
2 18 0 34 0 27 -1 1
2 30 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate f r2 z1
0
8
2 18 0 34 0 7 -1 0
2 30 0 6 0 7 -1 0
2 18 0 30 0 7 -1 1
2 34 0 6 0 7 -1 1
2 18 0 30 0 8 -1 0
2 34 0 6 0 8 -1 0
2 18 0 34 0 8 -1 1
2 30 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r2 t
0
8
2 30 0 23 0 3 -1 0
2 34 0 14 0 3 -1 0
2 30 0 14 0 3 -1 1
2 34 0 23 0 3 -1 1
2 30 0 14 0 4 -1 0
2 34 0 23 0 4 -1 0
2 30 0 23 0 4 -1 1
2 34 0 14 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r2 f
0
8
2 30 0 14 0 6 -1 0
2 34 0 23 0 6 -1 0
2 30 0 23 0 6 -1 1
2 34 0 14 0 6 -1 1
2 30 0 23 0 18 -1 0
2 34 0 14 0 18 -1 0
2 30 0 14 0 18 -1 1
2 34 0 23 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r2 tmp2
0
8
2 30 0 14 0 15 -1 0
2 34 0 23 0 15 -1 0
2 30 0 23 0 15 -1 1
2 34 0 14 0 15 -1 1
2 30 0 23 0 32 -1 0
2 34 0 14 0 32 -1 0
2 30 0 14 0 32 -1 1
2 34 0 23 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r2 r1
0
8
2 30 0 14 0 19 -1 0
2 34 0 23 0 19 -1 0
2 30 0 23 0 19 -1 1
2 34 0 14 0 19 -1 1
2 30 0 23 0 27 -1 0
2 34 0 14 0 27 -1 0
2 30 0 14 0 27 -1 1
2 34 0 23 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r2 z1
0
8
2 30 0 14 0 7 -1 0
2 34 0 23 0 7 -1 0
2 30 0 23 0 7 -1 1
2 34 0 14 0 7 -1 1
2 30 0 23 0 8 -1 0
2 34 0 14 0 8 -1 0
2 30 0 14 0 8 -1 1
2 34 0 23 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r2 t
0
8
2 32 0 30 0 3 -1 0
2 34 0 15 0 3 -1 0
2 30 0 15 0 3 -1 1
2 32 0 34 0 3 -1 1
2 30 0 15 0 4 -1 0
2 32 0 34 0 4 -1 0
2 32 0 30 0 4 -1 1
2 34 0 15 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r2 f
0
8
2 30 0 15 0 6 -1 0
2 32 0 34 0 6 -1 0
2 32 0 30 0 6 -1 1
2 34 0 15 0 6 -1 1
2 32 0 30 0 18 -1 0
2 34 0 15 0 18 -1 0
2 30 0 15 0 18 -1 1
2 32 0 34 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r2 tmp1
0
8
2 30 0 15 0 14 -1 0
2 32 0 34 0 14 -1 0
2 32 0 30 0 14 -1 1
2 34 0 15 0 14 -1 1
2 32 0 30 0 23 -1 0
2 34 0 15 0 23 -1 0
2 30 0 15 0 23 -1 1
2 32 0 34 0 23 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r2 r1
0
8
2 30 0 15 0 19 -1 0
2 32 0 34 0 19 -1 0
2 32 0 30 0 19 -1 1
2 34 0 15 0 19 -1 1
2 32 0 30 0 27 -1 0
2 34 0 15 0 27 -1 0
2 30 0 15 0 27 -1 1
2 32 0 34 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r2 z1
0
8
2 30 0 15 0 7 -1 0
2 32 0 34 0 7 -1 0
2 32 0 30 0 7 -1 1
2 34 0 15 0 7 -1 1
2 32 0 30 0 8 -1 0
2 34 0 15 0 8 -1 0
2 30 0 15 0 8 -1 1
2 32 0 34 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 t
0
8
2 11 0 30 0 3 -1 0
2 34 0 20 0 3 -1 0
2 20 0 30 0 3 -1 1
2 34 0 11 0 3 -1 1
2 20 0 30 0 4 -1 0
2 34 0 11 0 4 -1 0
2 11 0 30 0 4 -1 1
2 34 0 20 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 f
0
8
2 20 0 30 0 6 -1 0
2 34 0 11 0 6 -1 0
2 11 0 30 0 6 -1 1
2 34 0 20 0 6 -1 1
2 11 0 30 0 18 -1 0
2 34 0 20 0 18 -1 0
2 20 0 30 0 18 -1 1
2 34 0 11 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 tmp1
0
8
2 20 0 30 0 14 -1 0
2 34 0 11 0 14 -1 0
2 11 0 30 0 14 -1 1
2 34 0 20 0 14 -1 1
2 11 0 30 0 23 -1 0
2 34 0 20 0 23 -1 0
2 20 0 30 0 23 -1 1
2 34 0 11 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 tmp2
0
8
2 20 0 30 0 15 -1 0
2 34 0 11 0 15 -1 0
2 11 0 30 0 15 -1 1
2 34 0 20 0 15 -1 1
2 11 0 30 0 32 -1 0
2 34 0 20 0 32 -1 0
2 20 0 30 0 32 -1 1
2 34 0 11 0 32 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 r1
0
8
2 20 0 30 0 19 -1 0
2 34 0 11 0 19 -1 0
2 11 0 30 0 19 -1 1
2 34 0 20 0 19 -1 1
2 11 0 30 0 27 -1 0
2 34 0 20 0 27 -1 0
2 20 0 30 0 27 -1 1
2 34 0 11 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 z1
0
8
2 20 0 30 0 7 -1 0
2 34 0 11 0 7 -1 0
2 11 0 30 0 7 -1 1
2 34 0 20 0 7 -1 1
2 11 0 30 0 8 -1 0
2 34 0 20 0 8 -1 0
2 20 0 30 0 8 -1 1
2 34 0 11 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 t
0
8
2 9 0 30 0 3 -1 0
2 34 0 35 0 3 -1 0
2 9 0 34 0 3 -1 1
2 35 0 30 0 3 -1 1
2 9 0 34 0 4 -1 0
2 35 0 30 0 4 -1 0
2 9 0 30 0 4 -1 1
2 34 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 f
0
8
2 9 0 34 0 6 -1 0
2 35 0 30 0 6 -1 0
2 9 0 30 0 6 -1 1
2 34 0 35 0 6 -1 1
2 9 0 30 0 18 -1 0
2 34 0 35 0 18 -1 0
2 9 0 34 0 18 -1 1
2 35 0 30 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 tmp1
0
8
2 9 0 34 0 14 -1 0
2 35 0 30 0 14 -1 0
2 9 0 30 0 14 -1 1
2 34 0 35 0 14 -1 1
2 9 0 30 0 23 -1 0
2 34 0 35 0 23 -1 0
2 9 0 34 0 23 -1 1
2 35 0 30 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 tmp2
0
8
2 9 0 34 0 15 -1 0
2 35 0 30 0 15 -1 0
2 9 0 30 0 15 -1 1
2 34 0 35 0 15 -1 1
2 9 0 30 0 32 -1 0
2 34 0 35 0 32 -1 0
2 9 0 34 0 32 -1 1
2 35 0 30 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 r1
0
8
2 9 0 34 0 19 -1 0
2 35 0 30 0 19 -1 0
2 9 0 30 0 19 -1 1
2 34 0 35 0 19 -1 1
2 9 0 30 0 27 -1 0
2 34 0 35 0 27 -1 0
2 9 0 34 0 27 -1 1
2 35 0 30 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 z1
0
8
2 9 0 34 0 7 -1 0
2 35 0 30 0 7 -1 0
2 9 0 30 0 7 -1 1
2 34 0 35 0 7 -1 1
2 9 0 30 0 8 -1 0
2 34 0 35 0 8 -1 0
2 9 0 34 0 8 -1 1
2 35 0 30 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 r2 t
0
8
2 27 0 30 0 3 -1 0
2 34 0 19 0 3 -1 0
2 19 0 30 0 3 -1 1
2 34 0 27 0 3 -1 1
2 19 0 30 0 4 -1 0
2 34 0 27 0 4 -1 0
2 27 0 30 0 4 -1 1
2 34 0 19 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 r2 f
0
8
2 19 0 30 0 6 -1 0
2 34 0 27 0 6 -1 0
2 27 0 30 0 6 -1 1
2 34 0 19 0 6 -1 1
2 27 0 30 0 18 -1 0
2 34 0 19 0 18 -1 0
2 19 0 30 0 18 -1 1
2 34 0 27 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 r2 tmp1
0
8
2 19 0 30 0 14 -1 0
2 34 0 27 0 14 -1 0
2 27 0 30 0 14 -1 1
2 34 0 19 0 14 -1 1
2 27 0 30 0 23 -1 0
2 34 0 19 0 23 -1 0
2 19 0 30 0 23 -1 1
2 34 0 27 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 r2 tmp2
0
8
2 19 0 30 0 15 -1 0
2 34 0 27 0 15 -1 0
2 27 0 30 0 15 -1 1
2 34 0 19 0 15 -1 1
2 27 0 30 0 32 -1 0
2 34 0 19 0 32 -1 0
2 19 0 30 0 32 -1 1
2 34 0 27 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 r2 z1
0
8
2 19 0 30 0 7 -1 0
2 34 0 27 0 7 -1 0
2 27 0 30 0 7 -1 1
2 34 0 19 0 7 -1 1
2 27 0 30 0 8 -1 0
2 34 0 19 0 8 -1 0
2 19 0 30 0 8 -1 1
2 34 0 27 0 8 -1 1
0
end_operator
begin_operator
xor-gate z1 r2 t
0
8
2 8 0 30 0 3 -1 0
2 34 0 7 0 3 -1 0
2 8 0 34 0 3 -1 1
2 30 0 7 0 3 -1 1
2 8 0 34 0 4 -1 0
2 30 0 7 0 4 -1 0
2 8 0 30 0 4 -1 1
2 34 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 r2 f
0
8
2 8 0 34 0 6 -1 0
2 30 0 7 0 6 -1 0
2 8 0 30 0 6 -1 1
2 34 0 7 0 6 -1 1
2 8 0 30 0 18 -1 0
2 34 0 7 0 18 -1 0
2 8 0 34 0 18 -1 1
2 30 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 r2 tmp1
0
8
2 8 0 34 0 14 -1 0
2 30 0 7 0 14 -1 0
2 8 0 30 0 14 -1 1
2 34 0 7 0 14 -1 1
2 8 0 30 0 23 -1 0
2 34 0 7 0 23 -1 0
2 8 0 34 0 23 -1 1
2 30 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 r2 tmp2
0
8
2 8 0 34 0 15 -1 0
2 30 0 7 0 15 -1 0
2 8 0 30 0 15 -1 1
2 34 0 7 0 15 -1 1
2 8 0 30 0 32 -1 0
2 34 0 7 0 32 -1 0
2 8 0 34 0 32 -1 1
2 30 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 r2 r1
0
8
2 8 0 34 0 19 -1 0
2 30 0 7 0 19 -1 0
2 8 0 30 0 19 -1 1
2 34 0 7 0 19 -1 1
2 8 0 30 0 27 -1 0
2 34 0 7 0 27 -1 0
2 8 0 34 0 27 -1 1
2 30 0 7 0 27 -1 1
0
end_operator
begin_operator
not-gate r2 t
0
4
1 30 0 3 -1 0
1 34 0 3 -1 1
1 34 0 4 -1 0
1 30 0 4 -1 1
0
end_operator
begin_operator
not-gate r2 f
0
4
1 34 0 6 -1 0
1 30 0 6 -1 1
1 30 0 18 -1 0
1 34 0 18 -1 1
0
end_operator
begin_operator
not-gate r2 tmp1
0
4
1 34 0 14 -1 0
1 30 0 14 -1 1
1 30 0 23 -1 0
1 34 0 23 -1 1
0
end_operator
begin_operator
not-gate r2 tmp2
0
4
1 34 0 15 -1 0
1 30 0 15 -1 1
1 30 0 32 -1 0
1 34 0 32 -1 1
0
end_operator
begin_operator
not-gate r2 r1
0
4
1 34 0 19 -1 0
1 30 0 19 -1 1
1 30 0 27 -1 0
1 34 0 27 -1 1
0
end_operator
begin_operator
not-gate r2 z1
0
4
1 34 0 7 -1 0
1 30 0 7 -1 1
1 30 0 8 -1 0
1 34 0 8 -1 1
0
end_operator
begin_operator
not-gate t r2
0
4
1 3 0 30 -1 0
1 4 0 30 -1 1
1 4 0 34 -1 0
1 3 0 34 -1 1
0
end_operator
begin_operator
not-gate f r2
0
4
1 18 0 30 -1 0
1 6 0 30 -1 1
1 6 0 34 -1 0
1 18 0 34 -1 1
0
end_operator
begin_operator
not-gate tmp1 r2
0
4
1 23 0 30 -1 0
1 14 0 30 -1 1
1 14 0 34 -1 0
1 23 0 34 -1 1
0
end_operator
begin_operator
not-gate tmp2 r2
0
4
1 32 0 30 -1 0
1 15 0 30 -1 1
1 15 0 34 -1 0
1 32 0 34 -1 1
0
end_operator
begin_operator
not-gate x1 r2
0
4
1 11 0 30 -1 0
1 20 0 30 -1 1
1 20 0 34 -1 0
1 11 0 34 -1 1
0
end_operator
begin_operator
not-gate y1 r2
0
4
1 9 0 30 -1 0
1 35 0 30 -1 1
1 35 0 34 -1 0
1 9 0 34 -1 1
0
end_operator
begin_operator
not-gate r1 r2
0
4
1 27 0 30 -1 0
1 19 0 30 -1 1
1 19 0 34 -1 0
1 27 0 34 -1 1
0
end_operator
begin_operator
not-gate z1 r2
0
4
1 8 0 30 -1 0
1 7 0 30 -1 1
1 7 0 34 -1 0
1 8 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 f t
0
6
2 10 0 18 0 3 -1 0
1 6 0 3 -1 1
1 21 0 3 -1 1
1 6 0 4 -1 0
1 21 0 4 -1 0
2 10 0 18 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 tmp1 t
0
6
2 10 0 23 0 3 -1 0
1 14 0 3 -1 1
1 21 0 3 -1 1
1 14 0 4 -1 0
1 21 0 4 -1 0
2 10 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 tmp2 t
0
6
2 32 0 10 0 3 -1 0
1 15 0 3 -1 1
1 21 0 3 -1 1
1 15 0 4 -1 0
1 21 0 4 -1 0
2 32 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 x1 t
0
6
2 10 0 11 0 3 -1 0
1 20 0 3 -1 1
1 21 0 3 -1 1
1 20 0 4 -1 0
1 21 0 4 -1 0
2 10 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 y1 t
0
6
2 9 0 10 0 3 -1 0
1 21 0 3 -1 1
1 35 0 3 -1 1
1 21 0 4 -1 0
1 35 0 4 -1 0
2 9 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 r1 t
0
6
2 10 0 27 0 3 -1 0
1 19 0 3 -1 1
1 21 0 3 -1 1
1 19 0 4 -1 0
1 21 0 4 -1 0
2 10 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 z1 t
0
6
2 8 0 10 0 3 -1 0
1 7 0 3 -1 1
1 21 0 3 -1 1
1 7 0 4 -1 0
1 21 0 4 -1 0
2 8 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 r2 t
0
6
2 10 0 34 0 3 -1 0
1 21 0 3 -1 1
1 30 0 3 -1 1
1 21 0 4 -1 0
1 30 0 4 -1 0
2 10 0 34 0 4 -1 1
0
end_operator
begin_operator
and-gate z2 t f
0
6
1 4 0 6 -1 0
1 21 0 6 -1 0
2 10 0 3 0 6 -1 1
2 10 0 3 0 18 -1 0
1 4 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 tmp1 f
0
6
1 14 0 6 -1 0
1 21 0 6 -1 0
2 10 0 23 0 6 -1 1
2 10 0 23 0 18 -1 0
1 14 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 tmp2 f
0
6
1 15 0 6 -1 0
1 21 0 6 -1 0
2 32 0 10 0 6 -1 1
2 32 0 10 0 18 -1 0
1 15 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 x1 f
0
6
1 20 0 6 -1 0
1 21 0 6 -1 0
2 10 0 11 0 6 -1 1
2 10 0 11 0 18 -1 0
1 20 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 y1 f
0
6
1 21 0 6 -1 0
1 35 0 6 -1 0
2 9 0 10 0 6 -1 1
2 9 0 10 0 18 -1 0
1 21 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 r1 f
0
6
1 19 0 6 -1 0
1 21 0 6 -1 0
2 10 0 27 0 6 -1 1
2 10 0 27 0 18 -1 0
1 19 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 z1 f
0
6
1 7 0 6 -1 0
1 21 0 6 -1 0
2 8 0 10 0 6 -1 1
2 8 0 10 0 18 -1 0
1 7 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 r2 f
0
6
1 21 0 6 -1 0
1 30 0 6 -1 0
2 10 0 34 0 6 -1 1
2 10 0 34 0 18 -1 0
1 21 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate z2 t tmp1
0
6
1 4 0 14 -1 0
1 21 0 14 -1 0
2 10 0 3 0 14 -1 1
2 10 0 3 0 23 -1 0
1 4 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 f tmp1
0
6
1 6 0 14 -1 0
1 21 0 14 -1 0
2 10 0 18 0 14 -1 1
2 10 0 18 0 23 -1 0
1 6 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 tmp2 tmp1
0
6
1 15 0 14 -1 0
1 21 0 14 -1 0
2 32 0 10 0 14 -1 1
2 32 0 10 0 23 -1 0
1 15 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 x1 tmp1
0
6
1 20 0 14 -1 0
1 21 0 14 -1 0
2 10 0 11 0 14 -1 1
2 10 0 11 0 23 -1 0
1 20 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 y1 tmp1
0
6
1 21 0 14 -1 0
1 35 0 14 -1 0
2 9 0 10 0 14 -1 1
2 9 0 10 0 23 -1 0
1 21 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 r1 tmp1
0
6
1 19 0 14 -1 0
1 21 0 14 -1 0
2 10 0 27 0 14 -1 1
2 10 0 27 0 23 -1 0
1 19 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 z1 tmp1
0
6
1 7 0 14 -1 0
1 21 0 14 -1 0
2 8 0 10 0 14 -1 1
2 8 0 10 0 23 -1 0
1 7 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 r2 tmp1
0
6
1 21 0 14 -1 0
1 30 0 14 -1 0
2 10 0 34 0 14 -1 1
2 10 0 34 0 23 -1 0
1 21 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate z2 t tmp2
0
6
1 4 0 15 -1 0
1 21 0 15 -1 0
2 10 0 3 0 15 -1 1
2 10 0 3 0 32 -1 0
1 4 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 f tmp2
0
6
1 6 0 15 -1 0
1 21 0 15 -1 0
2 10 0 18 0 15 -1 1
2 10 0 18 0 32 -1 0
1 6 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 tmp1 tmp2
0
6
1 14 0 15 -1 0
1 21 0 15 -1 0
2 10 0 23 0 15 -1 1
2 10 0 23 0 32 -1 0
1 14 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 x1 tmp2
0
6
1 20 0 15 -1 0
1 21 0 15 -1 0
2 10 0 11 0 15 -1 1
2 10 0 11 0 32 -1 0
1 20 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 y1 tmp2
0
6
1 21 0 15 -1 0
1 35 0 15 -1 0
2 9 0 10 0 15 -1 1
2 9 0 10 0 32 -1 0
1 21 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 r1 tmp2
0
6
1 19 0 15 -1 0
1 21 0 15 -1 0
2 10 0 27 0 15 -1 1
2 10 0 27 0 32 -1 0
1 19 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 z1 tmp2
0
6
1 7 0 15 -1 0
1 21 0 15 -1 0
2 8 0 10 0 15 -1 1
2 8 0 10 0 32 -1 0
1 7 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 r2 tmp2
0
6
1 21 0 15 -1 0
1 30 0 15 -1 0
2 10 0 34 0 15 -1 1
2 10 0 34 0 32 -1 0
1 21 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate z2 t r1
0
6
1 4 0 19 -1 0
1 21 0 19 -1 0
2 10 0 3 0 19 -1 1
2 10 0 3 0 27 -1 0
1 4 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 f r1
0
6
1 6 0 19 -1 0
1 21 0 19 -1 0
2 10 0 18 0 19 -1 1
2 10 0 18 0 27 -1 0
1 6 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 tmp1 r1
0
6
1 14 0 19 -1 0
1 21 0 19 -1 0
2 10 0 23 0 19 -1 1
2 10 0 23 0 27 -1 0
1 14 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 tmp2 r1
0
6
1 15 0 19 -1 0
1 21 0 19 -1 0
2 32 0 10 0 19 -1 1
2 32 0 10 0 27 -1 0
1 15 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 x1 r1
0
6
1 20 0 19 -1 0
1 21 0 19 -1 0
2 10 0 11 0 19 -1 1
2 10 0 11 0 27 -1 0
1 20 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 y1 r1
0
6
1 21 0 19 -1 0
1 35 0 19 -1 0
2 9 0 10 0 19 -1 1
2 9 0 10 0 27 -1 0
1 21 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 z1 r1
0
6
1 7 0 19 -1 0
1 21 0 19 -1 0
2 8 0 10 0 19 -1 1
2 8 0 10 0 27 -1 0
1 7 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 r2 r1
0
6
1 21 0 19 -1 0
1 30 0 19 -1 0
2 10 0 34 0 19 -1 1
2 10 0 34 0 27 -1 0
1 21 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate z2 t z1
0
6
1 4 0 7 -1 0
1 21 0 7 -1 0
2 10 0 3 0 7 -1 1
2 10 0 3 0 8 -1 0
1 4 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 f z1
0
6
1 6 0 7 -1 0
1 21 0 7 -1 0
2 10 0 18 0 7 -1 1
2 10 0 18 0 8 -1 0
1 6 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 tmp1 z1
0
6
1 14 0 7 -1 0
1 21 0 7 -1 0
2 10 0 23 0 7 -1 1
2 10 0 23 0 8 -1 0
1 14 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 tmp2 z1
0
6
1 15 0 7 -1 0
1 21 0 7 -1 0
2 32 0 10 0 7 -1 1
2 32 0 10 0 8 -1 0
1 15 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 x1 z1
0
6
1 20 0 7 -1 0
1 21 0 7 -1 0
2 10 0 11 0 7 -1 1
2 10 0 11 0 8 -1 0
1 20 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 y1 z1
0
6
1 21 0 7 -1 0
1 35 0 7 -1 0
2 9 0 10 0 7 -1 1
2 9 0 10 0 8 -1 0
1 21 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 r1 z1
0
6
1 19 0 7 -1 0
1 21 0 7 -1 0
2 10 0 27 0 7 -1 1
2 10 0 27 0 8 -1 0
1 19 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 r2 z1
0
6
1 21 0 7 -1 0
1 30 0 7 -1 0
2 10 0 34 0 7 -1 1
2 10 0 34 0 8 -1 0
1 21 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
and-gate z2 t r2
0
6
1 4 0 30 -1 0
1 21 0 30 -1 0
2 10 0 3 0 30 -1 1
2 10 0 3 0 34 -1 0
1 4 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 f r2
0
6
1 6 0 30 -1 0
1 21 0 30 -1 0
2 10 0 18 0 30 -1 1
2 10 0 18 0 34 -1 0
1 6 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 tmp1 r2
0
6
1 14 0 30 -1 0
1 21 0 30 -1 0
2 10 0 23 0 30 -1 1
2 10 0 23 0 34 -1 0
1 14 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 tmp2 r2
0
6
1 15 0 30 -1 0
1 21 0 30 -1 0
2 32 0 10 0 30 -1 1
2 32 0 10 0 34 -1 0
1 15 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 x1 r2
0
6
1 20 0 30 -1 0
1 21 0 30 -1 0
2 10 0 11 0 30 -1 1
2 10 0 11 0 34 -1 0
1 20 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 y1 r2
0
6
1 21 0 30 -1 0
1 35 0 30 -1 0
2 9 0 10 0 30 -1 1
2 9 0 10 0 34 -1 0
1 21 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 r1 r2
0
6
1 19 0 30 -1 0
1 21 0 30 -1 0
2 10 0 27 0 30 -1 1
2 10 0 27 0 34 -1 0
1 19 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z2 z1 r2
0
6
1 7 0 30 -1 0
1 21 0 30 -1 0
2 8 0 10 0 30 -1 1
2 8 0 10 0 34 -1 0
1 7 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate t f z2
0
6
2 18 0 3 0 10 -1 0
1 4 0 10 -1 1
1 6 0 10 -1 1
1 4 0 21 -1 0
1 6 0 21 -1 0
2 18 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate t tmp1 z2
0
6
2 3 0 23 0 10 -1 0
1 4 0 10 -1 1
1 14 0 10 -1 1
1 4 0 21 -1 0
1 14 0 21 -1 0
2 3 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate t tmp2 z2
0
6
2 32 0 3 0 10 -1 0
1 4 0 10 -1 1
1 15 0 10 -1 1
1 4 0 21 -1 0
1 15 0 21 -1 0
2 32 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate t x1 z2
0
6
2 11 0 3 0 10 -1 0
1 4 0 10 -1 1
1 20 0 10 -1 1
1 4 0 21 -1 0
1 20 0 21 -1 0
2 11 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate t y1 z2
0
6
2 9 0 3 0 10 -1 0
1 4 0 10 -1 1
1 35 0 10 -1 1
1 4 0 21 -1 0
1 35 0 21 -1 0
2 9 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate t r1 z2
0
6
2 27 0 3 0 10 -1 0
1 4 0 10 -1 1
1 19 0 10 -1 1
1 4 0 21 -1 0
1 19 0 21 -1 0
2 27 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate t z1 z2
0
6
2 8 0 3 0 10 -1 0
1 4 0 10 -1 1
1 7 0 10 -1 1
1 4 0 21 -1 0
1 7 0 21 -1 0
2 8 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate t r2 z2
0
6
2 34 0 3 0 10 -1 0
1 4 0 10 -1 1
1 30 0 10 -1 1
1 4 0 21 -1 0
1 30 0 21 -1 0
2 34 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate f t z2
0
6
2 18 0 3 0 10 -1 0
1 4 0 10 -1 1
1 6 0 10 -1 1
1 4 0 21 -1 0
1 6 0 21 -1 0
2 18 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate f tmp1 z2
0
6
2 18 0 23 0 10 -1 0
1 6 0 10 -1 1
1 14 0 10 -1 1
1 6 0 21 -1 0
1 14 0 21 -1 0
2 18 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate f tmp2 z2
0
6
2 32 0 18 0 10 -1 0
1 6 0 10 -1 1
1 15 0 10 -1 1
1 6 0 21 -1 0
1 15 0 21 -1 0
2 32 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate f x1 z2
0
6
2 18 0 11 0 10 -1 0
1 6 0 10 -1 1
1 20 0 10 -1 1
1 6 0 21 -1 0
1 20 0 21 -1 0
2 18 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate f y1 z2
0
6
2 9 0 18 0 10 -1 0
1 6 0 10 -1 1
1 35 0 10 -1 1
1 6 0 21 -1 0
1 35 0 21 -1 0
2 9 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate f r1 z2
0
6
2 18 0 27 0 10 -1 0
1 6 0 10 -1 1
1 19 0 10 -1 1
1 6 0 21 -1 0
1 19 0 21 -1 0
2 18 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate f z1 z2
0
6
2 8 0 18 0 10 -1 0
1 6 0 10 -1 1
1 7 0 10 -1 1
1 6 0 21 -1 0
1 7 0 21 -1 0
2 8 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate f r2 z2
0
6
2 18 0 34 0 10 -1 0
1 6 0 10 -1 1
1 30 0 10 -1 1
1 6 0 21 -1 0
1 30 0 21 -1 0
2 18 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 t z2
0
6
2 3 0 23 0 10 -1 0
1 4 0 10 -1 1
1 14 0 10 -1 1
1 4 0 21 -1 0
1 14 0 21 -1 0
2 3 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 f z2
0
6
2 18 0 23 0 10 -1 0
1 6 0 10 -1 1
1 14 0 10 -1 1
1 6 0 21 -1 0
1 14 0 21 -1 0
2 18 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 tmp2 z2
0
6
2 32 0 23 0 10 -1 0
1 14 0 10 -1 1
1 15 0 10 -1 1
1 14 0 21 -1 0
1 15 0 21 -1 0
2 32 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 x1 z2
0
6
2 11 0 23 0 10 -1 0
1 14 0 10 -1 1
1 20 0 10 -1 1
1 14 0 21 -1 0
1 20 0 21 -1 0
2 11 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 y1 z2
0
6
2 9 0 23 0 10 -1 0
1 14 0 10 -1 1
1 35 0 10 -1 1
1 14 0 21 -1 0
1 35 0 21 -1 0
2 9 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 r1 z2
0
6
2 27 0 23 0 10 -1 0
1 14 0 10 -1 1
1 19 0 10 -1 1
1 14 0 21 -1 0
1 19 0 21 -1 0
2 27 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 z1 z2
0
6
2 8 0 23 0 10 -1 0
1 7 0 10 -1 1
1 14 0 10 -1 1
1 7 0 21 -1 0
1 14 0 21 -1 0
2 8 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp1 r2 z2
0
6
2 34 0 23 0 10 -1 0
1 14 0 10 -1 1
1 30 0 10 -1 1
1 14 0 21 -1 0
1 30 0 21 -1 0
2 34 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 t z2
0
6
2 32 0 3 0 10 -1 0
1 4 0 10 -1 1
1 15 0 10 -1 1
1 4 0 21 -1 0
1 15 0 21 -1 0
2 32 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 f z2
0
6
2 32 0 18 0 10 -1 0
1 6 0 10 -1 1
1 15 0 10 -1 1
1 6 0 21 -1 0
1 15 0 21 -1 0
2 32 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 tmp1 z2
0
6
2 32 0 23 0 10 -1 0
1 14 0 10 -1 1
1 15 0 10 -1 1
1 14 0 21 -1 0
1 15 0 21 -1 0
2 32 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 x1 z2
0
6
2 32 0 11 0 10 -1 0
1 15 0 10 -1 1
1 20 0 10 -1 1
1 15 0 21 -1 0
1 20 0 21 -1 0
2 32 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 y1 z2
0
6
2 32 0 9 0 10 -1 0
1 15 0 10 -1 1
1 35 0 10 -1 1
1 15 0 21 -1 0
1 35 0 21 -1 0
2 32 0 9 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 r1 z2
0
6
2 32 0 27 0 10 -1 0
1 15 0 10 -1 1
1 19 0 10 -1 1
1 15 0 21 -1 0
1 19 0 21 -1 0
2 32 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 z1 z2
0
6
2 32 0 8 0 10 -1 0
1 7 0 10 -1 1
1 15 0 10 -1 1
1 7 0 21 -1 0
1 15 0 21 -1 0
2 32 0 8 0 21 -1 1
0
end_operator
begin_operator
and-gate tmp2 r2 z2
0
6
2 32 0 34 0 10 -1 0
1 15 0 10 -1 1
1 30 0 10 -1 1
1 15 0 21 -1 0
1 30 0 21 -1 0
2 32 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 t z2
0
6
2 3 0 11 0 10 -1 0
1 4 0 10 -1 1
1 20 0 10 -1 1
1 4 0 21 -1 0
1 20 0 21 -1 0
2 3 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 f z2
0
6
2 18 0 11 0 10 -1 0
1 6 0 10 -1 1
1 20 0 10 -1 1
1 6 0 21 -1 0
1 20 0 21 -1 0
2 18 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 tmp1 z2
0
6
2 11 0 23 0 10 -1 0
1 14 0 10 -1 1
1 20 0 10 -1 1
1 14 0 21 -1 0
1 20 0 21 -1 0
2 11 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 tmp2 z2
0
6
2 32 0 11 0 10 -1 0
1 15 0 10 -1 1
1 20 0 10 -1 1
1 15 0 21 -1 0
1 20 0 21 -1 0
2 32 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 y1 z2
0
6
2 9 0 11 0 10 -1 0
1 20 0 10 -1 1
1 35 0 10 -1 1
1 20 0 21 -1 0
1 35 0 21 -1 0
2 9 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 r1 z2
0
6
2 27 0 11 0 10 -1 0
1 19 0 10 -1 1
1 20 0 10 -1 1
1 19 0 21 -1 0
1 20 0 21 -1 0
2 27 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 z1 z2
0
6
2 8 0 11 0 10 -1 0
1 7 0 10 -1 1
1 20 0 10 -1 1
1 7 0 21 -1 0
1 20 0 21 -1 0
2 8 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate x1 r2 z2
0
6
2 34 0 11 0 10 -1 0
1 20 0 10 -1 1
1 30 0 10 -1 1
1 20 0 21 -1 0
1 30 0 21 -1 0
2 34 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 t z2
0
6
2 9 0 3 0 10 -1 0
1 4 0 10 -1 1
1 35 0 10 -1 1
1 4 0 21 -1 0
1 35 0 21 -1 0
2 9 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 f z2
0
6
2 9 0 18 0 10 -1 0
1 6 0 10 -1 1
1 35 0 10 -1 1
1 6 0 21 -1 0
1 35 0 21 -1 0
2 9 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 tmp1 z2
0
6
2 9 0 23 0 10 -1 0
1 14 0 10 -1 1
1 35 0 10 -1 1
1 14 0 21 -1 0
1 35 0 21 -1 0
2 9 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 tmp2 z2
0
6
2 32 0 9 0 10 -1 0
1 15 0 10 -1 1
1 35 0 10 -1 1
1 15 0 21 -1 0
1 35 0 21 -1 0
2 32 0 9 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 x1 z2
0
6
2 9 0 11 0 10 -1 0
1 20 0 10 -1 1
1 35 0 10 -1 1
1 20 0 21 -1 0
1 35 0 21 -1 0
2 9 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 r1 z2
0
6
2 9 0 27 0 10 -1 0
1 19 0 10 -1 1
1 35 0 10 -1 1
1 19 0 21 -1 0
1 35 0 21 -1 0
2 9 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 z1 z2
0
6
2 8 0 9 0 10 -1 0
1 7 0 10 -1 1
1 35 0 10 -1 1
1 7 0 21 -1 0
1 35 0 21 -1 0
2 8 0 9 0 21 -1 1
0
end_operator
begin_operator
and-gate y1 r2 z2
0
6
2 9 0 34 0 10 -1 0
1 30 0 10 -1 1
1 35 0 10 -1 1
1 30 0 21 -1 0
1 35 0 21 -1 0
2 9 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 t z2
0
6
2 3 0 27 0 10 -1 0
1 4 0 10 -1 1
1 19 0 10 -1 1
1 4 0 21 -1 0
1 19 0 21 -1 0
2 3 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 f z2
0
6
2 18 0 27 0 10 -1 0
1 6 0 10 -1 1
1 19 0 10 -1 1
1 6 0 21 -1 0
1 19 0 21 -1 0
2 18 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 tmp1 z2
0
6
2 27 0 23 0 10 -1 0
1 14 0 10 -1 1
1 19 0 10 -1 1
1 14 0 21 -1 0
1 19 0 21 -1 0
2 27 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 tmp2 z2
0
6
2 32 0 27 0 10 -1 0
1 15 0 10 -1 1
1 19 0 10 -1 1
1 15 0 21 -1 0
1 19 0 21 -1 0
2 32 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 x1 z2
0
6
2 11 0 27 0 10 -1 0
1 19 0 10 -1 1
1 20 0 10 -1 1
1 19 0 21 -1 0
1 20 0 21 -1 0
2 11 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 y1 z2
0
6
2 9 0 27 0 10 -1 0
1 19 0 10 -1 1
1 35 0 10 -1 1
1 19 0 21 -1 0
1 35 0 21 -1 0
2 9 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 z1 z2
0
6
2 8 0 27 0 10 -1 0
1 7 0 10 -1 1
1 19 0 10 -1 1
1 7 0 21 -1 0
1 19 0 21 -1 0
2 8 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r1 r2 z2
0
6
2 34 0 27 0 10 -1 0
1 19 0 10 -1 1
1 30 0 10 -1 1
1 19 0 21 -1 0
1 30 0 21 -1 0
2 34 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 t z2
0
6
2 8 0 3 0 10 -1 0
1 4 0 10 -1 1
1 7 0 10 -1 1
1 4 0 21 -1 0
1 7 0 21 -1 0
2 8 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 f z2
0
6
2 8 0 18 0 10 -1 0
1 6 0 10 -1 1
1 7 0 10 -1 1
1 6 0 21 -1 0
1 7 0 21 -1 0
2 8 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 tmp1 z2
0
6
2 8 0 23 0 10 -1 0
1 7 0 10 -1 1
1 14 0 10 -1 1
1 7 0 21 -1 0
1 14 0 21 -1 0
2 8 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 tmp2 z2
0
6
2 8 0 32 0 10 -1 0
1 7 0 10 -1 1
1 15 0 10 -1 1
1 7 0 21 -1 0
1 15 0 21 -1 0
2 8 0 32 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 x1 z2
0
6
2 8 0 11 0 10 -1 0
1 7 0 10 -1 1
1 20 0 10 -1 1
1 7 0 21 -1 0
1 20 0 21 -1 0
2 8 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 y1 z2
0
6
2 8 0 9 0 10 -1 0
1 7 0 10 -1 1
1 35 0 10 -1 1
1 7 0 21 -1 0
1 35 0 21 -1 0
2 8 0 9 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 r1 z2
0
6
2 8 0 27 0 10 -1 0
1 7 0 10 -1 1
1 19 0 10 -1 1
1 7 0 21 -1 0
1 19 0 21 -1 0
2 8 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate z1 r2 z2
0
6
2 8 0 34 0 10 -1 0
1 7 0 10 -1 1
1 30 0 10 -1 1
1 7 0 21 -1 0
1 30 0 21 -1 0
2 8 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 t z2
0
6
2 34 0 3 0 10 -1 0
1 4 0 10 -1 1
1 30 0 10 -1 1
1 4 0 21 -1 0
1 30 0 21 -1 0
2 34 0 3 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 f z2
0
6
2 34 0 18 0 10 -1 0
1 6 0 10 -1 1
1 30 0 10 -1 1
1 6 0 21 -1 0
1 30 0 21 -1 0
2 34 0 18 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 tmp1 z2
0
6
2 34 0 23 0 10 -1 0
1 14 0 10 -1 1
1 30 0 10 -1 1
1 14 0 21 -1 0
1 30 0 21 -1 0
2 34 0 23 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 tmp2 z2
0
6
2 32 0 34 0 10 -1 0
1 15 0 10 -1 1
1 30 0 10 -1 1
1 15 0 21 -1 0
1 30 0 21 -1 0
2 32 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 x1 z2
0
6
2 34 0 11 0 10 -1 0
1 20 0 10 -1 1
1 30 0 10 -1 1
1 20 0 21 -1 0
1 30 0 21 -1 0
2 34 0 11 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 y1 z2
0
6
2 9 0 34 0 10 -1 0
1 30 0 10 -1 1
1 35 0 10 -1 1
1 30 0 21 -1 0
1 35 0 21 -1 0
2 9 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 r1 z2
0
6
2 34 0 27 0 10 -1 0
1 19 0 10 -1 1
1 30 0 10 -1 1
1 19 0 21 -1 0
1 30 0 21 -1 0
2 34 0 27 0 21 -1 1
0
end_operator
begin_operator
and-gate r2 z1 z2
0
6
2 8 0 34 0 10 -1 0
1 7 0 10 -1 1
1 30 0 10 -1 1
1 7 0 21 -1 0
1 30 0 21 -1 0
2 8 0 34 0 21 -1 1
0
end_operator
begin_operator
and-gate t z2 f
0
6
1 4 0 6 -1 0
1 21 0 6 -1 0
2 10 0 3 0 6 -1 1
2 10 0 3 0 18 -1 0
1 4 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate t z2 tmp1
0
6
1 4 0 14 -1 0
1 21 0 14 -1 0
2 10 0 3 0 14 -1 1
2 10 0 3 0 23 -1 0
1 4 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate t z2 tmp2
0
6
1 4 0 15 -1 0
1 21 0 15 -1 0
2 10 0 3 0 15 -1 1
2 10 0 3 0 32 -1 0
1 4 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate t z2 r1
0
6
1 4 0 19 -1 0
1 21 0 19 -1 0
2 10 0 3 0 19 -1 1
2 10 0 3 0 27 -1 0
1 4 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate t z2 z1
0
6
1 4 0 7 -1 0
1 21 0 7 -1 0
2 10 0 3 0 7 -1 1
2 10 0 3 0 8 -1 0
1 4 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate t z2 r2
0
6
1 4 0 30 -1 0
1 21 0 30 -1 0
2 10 0 3 0 30 -1 1
2 10 0 3 0 34 -1 0
1 4 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate f z2 t
0
6
2 18 0 10 0 3 -1 0
1 6 0 3 -1 1
1 21 0 3 -1 1
1 6 0 4 -1 0
1 21 0 4 -1 0
2 18 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate f z2 tmp1
0
6
1 6 0 14 -1 0
1 21 0 14 -1 0
2 18 0 10 0 14 -1 1
2 18 0 10 0 23 -1 0
1 6 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate f z2 tmp2
0
6
1 6 0 15 -1 0
1 21 0 15 -1 0
2 18 0 10 0 15 -1 1
2 18 0 10 0 32 -1 0
1 6 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate f z2 r1
0
6
1 6 0 19 -1 0
1 21 0 19 -1 0
2 18 0 10 0 19 -1 1
2 18 0 10 0 27 -1 0
1 6 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate f z2 z1
0
6
1 6 0 7 -1 0
1 21 0 7 -1 0
2 18 0 10 0 7 -1 1
2 18 0 10 0 8 -1 0
1 6 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate f z2 r2
0
6
1 6 0 30 -1 0
1 21 0 30 -1 0
2 18 0 10 0 30 -1 1
2 18 0 10 0 34 -1 0
1 6 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp1 z2 t
0
6
2 10 0 23 0 3 -1 0
1 14 0 3 -1 1
1 21 0 3 -1 1
1 14 0 4 -1 0
1 21 0 4 -1 0
2 10 0 23 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp1 z2 f
0
6
1 14 0 6 -1 0
1 21 0 6 -1 0
2 10 0 23 0 6 -1 1
2 10 0 23 0 18 -1 0
1 14 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp1 z2 tmp2
0
6
1 14 0 15 -1 0
1 21 0 15 -1 0
2 10 0 23 0 15 -1 1
2 10 0 23 0 32 -1 0
1 14 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate tmp1 z2 r1
0
6
1 14 0 19 -1 0
1 21 0 19 -1 0
2 10 0 23 0 19 -1 1
2 10 0 23 0 27 -1 0
1 14 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp1 z2 z1
0
6
1 14 0 7 -1 0
1 21 0 7 -1 0
2 10 0 23 0 7 -1 1
2 10 0 23 0 8 -1 0
1 14 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp1 z2 r2
0
6
1 14 0 30 -1 0
1 21 0 30 -1 0
2 10 0 23 0 30 -1 1
2 10 0 23 0 34 -1 0
1 14 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate tmp2 z2 t
0
6
2 32 0 10 0 3 -1 0
1 15 0 3 -1 1
1 21 0 3 -1 1
1 15 0 4 -1 0
1 21 0 4 -1 0
2 32 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate tmp2 z2 f
0
6
1 15 0 6 -1 0
1 21 0 6 -1 0
2 32 0 10 0 6 -1 1
2 32 0 10 0 18 -1 0
1 15 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate tmp2 z2 tmp1
0
6
1 15 0 14 -1 0
1 21 0 14 -1 0
2 32 0 10 0 14 -1 1
2 32 0 10 0 23 -1 0
1 15 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate tmp2 z2 r1
0
6
1 15 0 19 -1 0
1 21 0 19 -1 0
2 32 0 10 0 19 -1 1
2 32 0 10 0 27 -1 0
1 15 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate tmp2 z2 z1
0
6
1 15 0 7 -1 0
1 21 0 7 -1 0
2 32 0 10 0 7 -1 1
2 32 0 10 0 8 -1 0
1 15 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate tmp2 z2 r2
0
6
1 15 0 30 -1 0
1 21 0 30 -1 0
2 32 0 10 0 30 -1 1
2 32 0 10 0 34 -1 0
1 15 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate x1 z2 t
0
6
2 10 0 11 0 3 -1 0
1 20 0 3 -1 1
1 21 0 3 -1 1
1 20 0 4 -1 0
1 21 0 4 -1 0
2 10 0 11 0 4 -1 1
0
end_operator
begin_operator
and-gate x1 z2 f
0
6
1 20 0 6 -1 0
1 21 0 6 -1 0
2 10 0 11 0 6 -1 1
2 10 0 11 0 18 -1 0
1 20 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate x1 z2 tmp1
0
6
1 20 0 14 -1 0
1 21 0 14 -1 0
2 10 0 11 0 14 -1 1
2 10 0 11 0 23 -1 0
1 20 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate x1 z2 tmp2
0
6
1 20 0 15 -1 0
1 21 0 15 -1 0
2 10 0 11 0 15 -1 1
2 10 0 11 0 32 -1 0
1 20 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate x1 z2 r1
0
6
1 20 0 19 -1 0
1 21 0 19 -1 0
2 10 0 11 0 19 -1 1
2 10 0 11 0 27 -1 0
1 20 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate x1 z2 z1
0
6
1 20 0 7 -1 0
1 21 0 7 -1 0
2 10 0 11 0 7 -1 1
2 10 0 11 0 8 -1 0
1 20 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate x1 z2 r2
0
6
1 20 0 30 -1 0
1 21 0 30 -1 0
2 10 0 11 0 30 -1 1
2 10 0 11 0 34 -1 0
1 20 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate y1 z2 t
0
6
2 9 0 10 0 3 -1 0
1 21 0 3 -1 1
1 35 0 3 -1 1
1 21 0 4 -1 0
1 35 0 4 -1 0
2 9 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate y1 z2 f
0
6
1 21 0 6 -1 0
1 35 0 6 -1 0
2 9 0 10 0 6 -1 1
2 9 0 10 0 18 -1 0
1 21 0 18 -1 1
1 35 0 18 -1 1
0
end_operator
begin_operator
and-gate y1 z2 tmp1
0
6
1 21 0 14 -1 0
1 35 0 14 -1 0
2 9 0 10 0 14 -1 1
2 9 0 10 0 23 -1 0
1 21 0 23 -1 1
1 35 0 23 -1 1
0
end_operator
begin_operator
and-gate y1 z2 tmp2
0
6
1 21 0 15 -1 0
1 35 0 15 -1 0
2 9 0 10 0 15 -1 1
2 9 0 10 0 32 -1 0
1 21 0 32 -1 1
1 35 0 32 -1 1
0
end_operator
begin_operator
and-gate y1 z2 r1
0
6
1 21 0 19 -1 0
1 35 0 19 -1 0
2 9 0 10 0 19 -1 1
2 9 0 10 0 27 -1 0
1 21 0 27 -1 1
1 35 0 27 -1 1
0
end_operator
begin_operator
and-gate y1 z2 z1
0
6
1 21 0 7 -1 0
1 35 0 7 -1 0
2 9 0 10 0 7 -1 1
2 9 0 10 0 8 -1 0
1 21 0 8 -1 1
1 35 0 8 -1 1
0
end_operator
begin_operator
and-gate y1 z2 r2
0
6
1 21 0 30 -1 0
1 35 0 30 -1 0
2 9 0 10 0 30 -1 1
2 9 0 10 0 34 -1 0
1 21 0 34 -1 1
1 35 0 34 -1 1
0
end_operator
begin_operator
and-gate r1 z2 t
0
6
2 10 0 27 0 3 -1 0
1 19 0 3 -1 1
1 21 0 3 -1 1
1 19 0 4 -1 0
1 21 0 4 -1 0
2 10 0 27 0 4 -1 1
0
end_operator
begin_operator
and-gate r1 z2 f
0
6
1 19 0 6 -1 0
1 21 0 6 -1 0
2 10 0 27 0 6 -1 1
2 10 0 27 0 18 -1 0
1 19 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate r1 z2 tmp1
0
6
1 19 0 14 -1 0
1 21 0 14 -1 0
2 10 0 27 0 14 -1 1
2 10 0 27 0 23 -1 0
1 19 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate r1 z2 tmp2
0
6
1 19 0 15 -1 0
1 21 0 15 -1 0
2 10 0 27 0 15 -1 1
2 10 0 27 0 32 -1 0
1 19 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate r1 z2 z1
0
6
1 19 0 7 -1 0
1 21 0 7 -1 0
2 10 0 27 0 7 -1 1
2 10 0 27 0 8 -1 0
1 19 0 8 -1 1
1 21 0 8 -1 1
0
end_operator
begin_operator
and-gate r1 z2 r2
0
6
1 19 0 30 -1 0
1 21 0 30 -1 0
2 10 0 27 0 30 -1 1
2 10 0 27 0 34 -1 0
1 19 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate z1 z2 t
0
6
2 8 0 10 0 3 -1 0
1 7 0 3 -1 1
1 21 0 3 -1 1
1 7 0 4 -1 0
1 21 0 4 -1 0
2 8 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate z1 z2 f
0
6
1 7 0 6 -1 0
1 21 0 6 -1 0
2 8 0 10 0 6 -1 1
2 8 0 10 0 18 -1 0
1 7 0 18 -1 1
1 21 0 18 -1 1
0
end_operator
begin_operator
and-gate z1 z2 tmp1
0
6
1 7 0 14 -1 0
1 21 0 14 -1 0
2 8 0 10 0 14 -1 1
2 8 0 10 0 23 -1 0
1 7 0 23 -1 1
1 21 0 23 -1 1
0
end_operator
begin_operator
and-gate z1 z2 tmp2
0
6
1 7 0 15 -1 0
1 21 0 15 -1 0
2 8 0 10 0 15 -1 1
2 8 0 10 0 32 -1 0
1 7 0 32 -1 1
1 21 0 32 -1 1
0
end_operator
begin_operator
and-gate z1 z2 r1
0
6
1 7 0 19 -1 0
1 21 0 19 -1 0
2 8 0 10 0 19 -1 1
2 8 0 10 0 27 -1 0
1 7 0 27 -1 1
1 21 0 27 -1 1
0
end_operator
begin_operator
and-gate z1 z2 r2
0
6
1 7 0 30 -1 0
1 21 0 30 -1 0
2 8 0 10 0 30 -1 1
2 8 0 10 0 34 -1 0
1 7 0 34 -1 1
1 21 0 34 -1 1
0
end_operator
begin_operator
and-gate r2 z2 t
0
6
2 34 0 10 0 3 -1 0
1 21 0 3 -1 1
1 30 0 3 -1 1
1 21 0 4 -1 0
1 30 0 4 -1 0
2 34 0 10 0 4 -1 1
0
end_operator
begin_operator
and-gate r2 z2 f
0
6
1 21 0 6 -1 0
1 30 0 6 -1 0
2 34 0 10 0 6 -1 1
2 34 0 10 0 18 -1 0
1 21 0 18 -1 1
1 30 0 18 -1 1
0
end_operator
begin_operator
and-gate r2 z2 tmp1
0
6
1 21 0 14 -1 0
1 30 0 14 -1 0
2 34 0 10 0 14 -1 1
2 34 0 10 0 23 -1 0
1 21 0 23 -1 1
1 30 0 23 -1 1
0
end_operator
begin_operator
and-gate r2 z2 tmp2
0
6
1 21 0 15 -1 0
1 30 0 15 -1 0
2 34 0 10 0 15 -1 1
2 34 0 10 0 32 -1 0
1 21 0 32 -1 1
1 30 0 32 -1 1
0
end_operator
begin_operator
and-gate r2 z2 r1
0
6
1 21 0 19 -1 0
1 30 0 19 -1 0
2 34 0 10 0 19 -1 1
2 34 0 10 0 27 -1 0
1 21 0 27 -1 1
1 30 0 27 -1 1
0
end_operator
begin_operator
and-gate r2 z2 z1
0
6
1 21 0 7 -1 0
1 30 0 7 -1 0
2 34 0 10 0 7 -1 1
2 34 0 10 0 8 -1 0
1 21 0 8 -1 1
1 30 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 f t
0
6
1 10 0 3 -1 0
1 18 0 3 -1 0
2 21 0 6 0 3 -1 1
2 21 0 6 0 4 -1 0
1 10 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 tmp1 t
0
6
1 10 0 3 -1 0
1 23 0 3 -1 0
2 21 0 14 0 3 -1 1
2 21 0 14 0 4 -1 0
1 10 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 tmp2 t
0
6
1 10 0 3 -1 0
1 32 0 3 -1 0
2 21 0 15 0 3 -1 1
2 21 0 15 0 4 -1 0
1 10 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 x1 t
0
6
1 10 0 3 -1 0
1 11 0 3 -1 0
2 20 0 21 0 3 -1 1
2 20 0 21 0 4 -1 0
1 10 0 4 -1 1
1 11 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 y1 t
0
6
1 9 0 3 -1 0
1 10 0 3 -1 0
2 35 0 21 0 3 -1 1
2 35 0 21 0 4 -1 0
1 9 0 4 -1 1
1 10 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 r1 t
0
6
1 10 0 3 -1 0
1 27 0 3 -1 0
2 19 0 21 0 3 -1 1
2 19 0 21 0 4 -1 0
1 10 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 z1 t
0
6
1 8 0 3 -1 0
1 10 0 3 -1 0
2 21 0 7 0 3 -1 1
2 21 0 7 0 4 -1 0
1 8 0 4 -1 1
1 10 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 r2 t
0
6
1 10 0 3 -1 0
1 34 0 3 -1 0
2 21 0 30 0 3 -1 1
2 21 0 30 0 4 -1 0
1 10 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate z2 t f
0
6
2 4 0 21 0 6 -1 0
1 3 0 6 -1 1
1 10 0 6 -1 1
1 3 0 18 -1 0
1 10 0 18 -1 0
2 4 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 tmp1 f
0
6
2 21 0 14 0 6 -1 0
1 10 0 6 -1 1
1 23 0 6 -1 1
1 10 0 18 -1 0
1 23 0 18 -1 0
2 21 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 tmp2 f
0
6
2 21 0 15 0 6 -1 0
1 10 0 6 -1 1
1 32 0 6 -1 1
1 10 0 18 -1 0
1 32 0 18 -1 0
2 21 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 x1 f
0
6
2 20 0 21 0 6 -1 0
1 10 0 6 -1 1
1 11 0 6 -1 1
1 10 0 18 -1 0
1 11 0 18 -1 0
2 20 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 y1 f
0
6
2 35 0 21 0 6 -1 0
1 9 0 6 -1 1
1 10 0 6 -1 1
1 9 0 18 -1 0
1 10 0 18 -1 0
2 35 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 r1 f
0
6
2 19 0 21 0 6 -1 0
1 10 0 6 -1 1
1 27 0 6 -1 1
1 10 0 18 -1 0
1 27 0 18 -1 0
2 19 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 z1 f
0
6
2 21 0 7 0 6 -1 0
1 8 0 6 -1 1
1 10 0 6 -1 1
1 8 0 18 -1 0
1 10 0 18 -1 0
2 21 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 r2 f
0
6
2 21 0 30 0 6 -1 0
1 10 0 6 -1 1
1 34 0 6 -1 1
1 10 0 18 -1 0
1 34 0 18 -1 0
2 21 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate z2 t tmp1
0
6
2 4 0 21 0 14 -1 0
1 3 0 14 -1 1
1 10 0 14 -1 1
1 3 0 23 -1 0
1 10 0 23 -1 0
2 4 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 f tmp1
0
6
2 21 0 6 0 14 -1 0
1 10 0 14 -1 1
1 18 0 14 -1 1
1 10 0 23 -1 0
1 18 0 23 -1 0
2 21 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 tmp2 tmp1
0
6
2 21 0 15 0 14 -1 0
1 10 0 14 -1 1
1 32 0 14 -1 1
1 10 0 23 -1 0
1 32 0 23 -1 0
2 21 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 x1 tmp1
0
6
2 20 0 21 0 14 -1 0
1 10 0 14 -1 1
1 11 0 14 -1 1
1 10 0 23 -1 0
1 11 0 23 -1 0
2 20 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 y1 tmp1
0
6
2 35 0 21 0 14 -1 0
1 9 0 14 -1 1
1 10 0 14 -1 1
1 9 0 23 -1 0
1 10 0 23 -1 0
2 35 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 r1 tmp1
0
6
2 19 0 21 0 14 -1 0
1 10 0 14 -1 1
1 27 0 14 -1 1
1 10 0 23 -1 0
1 27 0 23 -1 0
2 19 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 z1 tmp1
0
6
2 21 0 7 0 14 -1 0
1 8 0 14 -1 1
1 10 0 14 -1 1
1 8 0 23 -1 0
1 10 0 23 -1 0
2 21 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 r2 tmp1
0
6
2 21 0 30 0 14 -1 0
1 10 0 14 -1 1
1 34 0 14 -1 1
1 10 0 23 -1 0
1 34 0 23 -1 0
2 21 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate z2 t tmp2
0
6
2 4 0 21 0 15 -1 0
1 3 0 15 -1 1
1 10 0 15 -1 1
1 3 0 32 -1 0
1 10 0 32 -1 0
2 4 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 f tmp2
0
6
2 21 0 6 0 15 -1 0
1 10 0 15 -1 1
1 18 0 15 -1 1
1 10 0 32 -1 0
1 18 0 32 -1 0
2 21 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 tmp1 tmp2
0
6
2 21 0 14 0 15 -1 0
1 10 0 15 -1 1
1 23 0 15 -1 1
1 10 0 32 -1 0
1 23 0 32 -1 0
2 21 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 x1 tmp2
0
6
2 20 0 21 0 15 -1 0
1 10 0 15 -1 1
1 11 0 15 -1 1
1 10 0 32 -1 0
1 11 0 32 -1 0
2 20 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 y1 tmp2
0
6
2 35 0 21 0 15 -1 0
1 9 0 15 -1 1
1 10 0 15 -1 1
1 9 0 32 -1 0
1 10 0 32 -1 0
2 35 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 r1 tmp2
0
6
2 19 0 21 0 15 -1 0
1 10 0 15 -1 1
1 27 0 15 -1 1
1 10 0 32 -1 0
1 27 0 32 -1 0
2 19 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 z1 tmp2
0
6
2 21 0 7 0 15 -1 0
1 8 0 15 -1 1
1 10 0 15 -1 1
1 8 0 32 -1 0
1 10 0 32 -1 0
2 21 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 r2 tmp2
0
6
2 21 0 30 0 15 -1 0
1 10 0 15 -1 1
1 34 0 15 -1 1
1 10 0 32 -1 0
1 34 0 32 -1 0
2 21 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate z2 t r1
0
6
2 4 0 21 0 19 -1 0
1 3 0 19 -1 1
1 10 0 19 -1 1
1 3 0 27 -1 0
1 10 0 27 -1 0
2 4 0 21 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 f r1
0
6
2 21 0 6 0 19 -1 0
1 10 0 19 -1 1
1 18 0 19 -1 1
1 10 0 27 -1 0
1 18 0 27 -1 0
2 21 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 tmp1 r1
0
6
2 21 0 14 0 19 -1 0
1 10 0 19 -1 1
1 23 0 19 -1 1
1 10 0 27 -1 0
1 23 0 27 -1 0
2 21 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 tmp2 r1
0
6
2 21 0 15 0 19 -1 0
1 10 0 19 -1 1
1 32 0 19 -1 1
1 10 0 27 -1 0
1 32 0 27 -1 0
2 21 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 x1 r1
0
6
2 20 0 21 0 19 -1 0
1 10 0 19 -1 1
1 11 0 19 -1 1
1 10 0 27 -1 0
1 11 0 27 -1 0
2 20 0 21 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 y1 r1
0
6
2 35 0 21 0 19 -1 0
1 9 0 19 -1 1
1 10 0 19 -1 1
1 9 0 27 -1 0
1 10 0 27 -1 0
2 35 0 21 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 z1 r1
0
6
2 21 0 7 0 19 -1 0
1 8 0 19 -1 1
1 10 0 19 -1 1
1 8 0 27 -1 0
1 10 0 27 -1 0
2 21 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 r2 r1
0
6
2 21 0 30 0 19 -1 0
1 10 0 19 -1 1
1 34 0 19 -1 1
1 10 0 27 -1 0
1 34 0 27 -1 0
2 21 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate z2 t z1
0
6
2 4 0 21 0 7 -1 0
1 3 0 7 -1 1
1 10 0 7 -1 1
1 3 0 8 -1 0
1 10 0 8 -1 0
2 4 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 f z1
0
6
2 21 0 6 0 7 -1 0
1 10 0 7 -1 1
1 18 0 7 -1 1
1 10 0 8 -1 0
1 18 0 8 -1 0
2 21 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 tmp1 z1
0
6
2 21 0 14 0 7 -1 0
1 10 0 7 -1 1
1 23 0 7 -1 1
1 10 0 8 -1 0
1 23 0 8 -1 0
2 21 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 tmp2 z1
0
6
2 21 0 15 0 7 -1 0
1 10 0 7 -1 1
1 32 0 7 -1 1
1 10 0 8 -1 0
1 32 0 8 -1 0
2 21 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 x1 z1
0
6
2 20 0 21 0 7 -1 0
1 10 0 7 -1 1
1 11 0 7 -1 1
1 10 0 8 -1 0
1 11 0 8 -1 0
2 20 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 y1 z1
0
6
2 35 0 21 0 7 -1 0
1 9 0 7 -1 1
1 10 0 7 -1 1
1 9 0 8 -1 0
1 10 0 8 -1 0
2 35 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 r1 z1
0
6
2 19 0 21 0 7 -1 0
1 10 0 7 -1 1
1 27 0 7 -1 1
1 10 0 8 -1 0
1 27 0 8 -1 0
2 19 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 r2 z1
0
6
2 21 0 30 0 7 -1 0
1 10 0 7 -1 1
1 34 0 7 -1 1
1 10 0 8 -1 0
1 34 0 8 -1 0
2 21 0 30 0 8 -1 1
0
end_operator
begin_operator
or-gate z2 t r2
0
6
2 4 0 21 0 30 -1 0
1 3 0 30 -1 1
1 10 0 30 -1 1
1 3 0 34 -1 0
1 10 0 34 -1 0
2 4 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 f r2
0
6
2 21 0 6 0 30 -1 0
1 10 0 30 -1 1
1 18 0 30 -1 1
1 10 0 34 -1 0
1 18 0 34 -1 0
2 21 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 tmp1 r2
0
6
2 21 0 14 0 30 -1 0
1 10 0 30 -1 1
1 23 0 30 -1 1
1 10 0 34 -1 0
1 23 0 34 -1 0
2 21 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 tmp2 r2
0
6
2 21 0 15 0 30 -1 0
1 10 0 30 -1 1
1 32 0 30 -1 1
1 10 0 34 -1 0
1 32 0 34 -1 0
2 21 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 x1 r2
0
6
2 20 0 21 0 30 -1 0
1 10 0 30 -1 1
1 11 0 30 -1 1
1 10 0 34 -1 0
1 11 0 34 -1 0
2 20 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 y1 r2
0
6
2 35 0 21 0 30 -1 0
1 9 0 30 -1 1
1 10 0 30 -1 1
1 9 0 34 -1 0
1 10 0 34 -1 0
2 35 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 r1 r2
0
6
2 19 0 21 0 30 -1 0
1 10 0 30 -1 1
1 27 0 30 -1 1
1 10 0 34 -1 0
1 27 0 34 -1 0
2 19 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate z2 z1 r2
0
6
2 21 0 7 0 30 -1 0
1 8 0 30 -1 1
1 10 0 30 -1 1
1 8 0 34 -1 0
1 10 0 34 -1 0
2 21 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate t f z2
0
6
1 3 0 10 -1 0
1 18 0 10 -1 0
2 4 0 6 0 10 -1 1
2 4 0 6 0 21 -1 0
1 3 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate t tmp1 z2
0
6
1 3 0 10 -1 0
1 23 0 10 -1 0
2 4 0 14 0 10 -1 1
2 4 0 14 0 21 -1 0
1 3 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate t tmp2 z2
0
6
1 3 0 10 -1 0
1 32 0 10 -1 0
2 4 0 15 0 10 -1 1
2 4 0 15 0 21 -1 0
1 3 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate t x1 z2
0
6
1 3 0 10 -1 0
1 11 0 10 -1 0
2 20 0 4 0 10 -1 1
2 20 0 4 0 21 -1 0
1 3 0 21 -1 1
1 11 0 21 -1 1
0
end_operator
begin_operator
or-gate t y1 z2
0
6
1 3 0 10 -1 0
1 9 0 10 -1 0
2 35 0 4 0 10 -1 1
2 35 0 4 0 21 -1 0
1 3 0 21 -1 1
1 9 0 21 -1 1
0
end_operator
begin_operator
or-gate t r1 z2
0
6
1 3 0 10 -1 0
1 27 0 10 -1 0
2 19 0 4 0 10 -1 1
2 19 0 4 0 21 -1 0
1 3 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate t z1 z2
0
6
1 3 0 10 -1 0
1 8 0 10 -1 0
2 4 0 7 0 10 -1 1
2 4 0 7 0 21 -1 0
1 3 0 21 -1 1
1 8 0 21 -1 1
0
end_operator
begin_operator
or-gate t r2 z2
0
6
1 3 0 10 -1 0
1 34 0 10 -1 0
2 4 0 30 0 10 -1 1
2 4 0 30 0 21 -1 0
1 3 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate f t z2
0
6
1 3 0 10 -1 0
1 18 0 10 -1 0
2 4 0 6 0 10 -1 1
2 4 0 6 0 21 -1 0
1 3 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate f tmp1 z2
0
6
1 18 0 10 -1 0
1 23 0 10 -1 0
2 14 0 6 0 10 -1 1
2 14 0 6 0 21 -1 0
1 18 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate f tmp2 z2
0
6
1 18 0 10 -1 0
1 32 0 10 -1 0
2 6 0 15 0 10 -1 1
2 6 0 15 0 21 -1 0
1 18 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate f x1 z2
0
6
1 11 0 10 -1 0
1 18 0 10 -1 0
2 20 0 6 0 10 -1 1
2 20 0 6 0 21 -1 0
1 11 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate f y1 z2
0
6
1 9 0 10 -1 0
1 18 0 10 -1 0
2 35 0 6 0 10 -1 1
2 35 0 6 0 21 -1 0
1 9 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate f r1 z2
0
6
1 18 0 10 -1 0
1 27 0 10 -1 0
2 19 0 6 0 10 -1 1
2 19 0 6 0 21 -1 0
1 18 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate f z1 z2
0
6
1 8 0 10 -1 0
1 18 0 10 -1 0
2 6 0 7 0 10 -1 1
2 6 0 7 0 21 -1 0
1 8 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate f r2 z2
0
6
1 18 0 10 -1 0
1 34 0 10 -1 0
2 30 0 6 0 10 -1 1
2 30 0 6 0 21 -1 0
1 18 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 t z2
0
6
1 3 0 10 -1 0
1 23 0 10 -1 0
2 4 0 14 0 10 -1 1
2 4 0 14 0 21 -1 0
1 3 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 f z2
0
6
1 18 0 10 -1 0
1 23 0 10 -1 0
2 6 0 14 0 10 -1 1
2 6 0 14 0 21 -1 0
1 18 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 tmp2 z2
0
6
1 23 0 10 -1 0
1 32 0 10 -1 0
2 14 0 15 0 10 -1 1
2 14 0 15 0 21 -1 0
1 23 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 x1 z2
0
6
1 11 0 10 -1 0
1 23 0 10 -1 0
2 20 0 14 0 10 -1 1
2 20 0 14 0 21 -1 0
1 11 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 y1 z2
0
6
1 9 0 10 -1 0
1 23 0 10 -1 0
2 35 0 14 0 10 -1 1
2 35 0 14 0 21 -1 0
1 9 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 r1 z2
0
6
1 23 0 10 -1 0
1 27 0 10 -1 0
2 19 0 14 0 10 -1 1
2 19 0 14 0 21 -1 0
1 23 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 z1 z2
0
6
1 8 0 10 -1 0
1 23 0 10 -1 0
2 14 0 7 0 10 -1 1
2 14 0 7 0 21 -1 0
1 8 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp1 r2 z2
0
6
1 23 0 10 -1 0
1 34 0 10 -1 0
2 30 0 14 0 10 -1 1
2 30 0 14 0 21 -1 0
1 23 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 t z2
0
6
1 3 0 10 -1 0
1 32 0 10 -1 0
2 4 0 15 0 10 -1 1
2 4 0 15 0 21 -1 0
1 3 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 f z2
0
6
1 18 0 10 -1 0
1 32 0 10 -1 0
2 6 0 15 0 10 -1 1
2 6 0 15 0 21 -1 0
1 18 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 tmp1 z2
0
6
1 23 0 10 -1 0
1 32 0 10 -1 0
2 14 0 15 0 10 -1 1
2 14 0 15 0 21 -1 0
1 23 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 x1 z2
0
6
1 11 0 10 -1 0
1 32 0 10 -1 0
2 20 0 15 0 10 -1 1
2 20 0 15 0 21 -1 0
1 11 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 y1 z2
0
6
1 9 0 10 -1 0
1 32 0 10 -1 0
2 35 0 15 0 10 -1 1
2 35 0 15 0 21 -1 0
1 9 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 r1 z2
0
6
1 27 0 10 -1 0
1 32 0 10 -1 0
2 19 0 15 0 10 -1 1
2 19 0 15 0 21 -1 0
1 27 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 z1 z2
0
6
1 8 0 10 -1 0
1 32 0 10 -1 0
2 7 0 15 0 10 -1 1
2 7 0 15 0 21 -1 0
1 8 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate tmp2 r2 z2
0
6
1 32 0 10 -1 0
1 34 0 10 -1 0
2 30 0 15 0 10 -1 1
2 30 0 15 0 21 -1 0
1 32 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 t z2
0
6
1 3 0 10 -1 0
1 11 0 10 -1 0
2 4 0 20 0 10 -1 1
2 4 0 20 0 21 -1 0
1 3 0 21 -1 1
1 11 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 f z2
0
6
1 11 0 10 -1 0
1 18 0 10 -1 0
2 20 0 6 0 10 -1 1
2 20 0 6 0 21 -1 0
1 11 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 tmp1 z2
0
6
1 11 0 10 -1 0
1 23 0 10 -1 0
2 20 0 14 0 10 -1 1
2 20 0 14 0 21 -1 0
1 11 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 tmp2 z2
0
6
1 11 0 10 -1 0
1 32 0 10 -1 0
2 20 0 15 0 10 -1 1
2 20 0 15 0 21 -1 0
1 11 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 y1 z2
0
6
1 9 0 10 -1 0
1 11 0 10 -1 0
2 35 0 20 0 10 -1 1
2 35 0 20 0 21 -1 0
1 9 0 21 -1 1
1 11 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 r1 z2
0
6
1 11 0 10 -1 0
1 27 0 10 -1 0
2 19 0 20 0 10 -1 1
2 19 0 20 0 21 -1 0
1 11 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 z1 z2
0
6
1 8 0 10 -1 0
1 11 0 10 -1 0
2 20 0 7 0 10 -1 1
2 20 0 7 0 21 -1 0
1 8 0 21 -1 1
1 11 0 21 -1 1
0
end_operator
begin_operator
or-gate x1 r2 z2
0
6
1 11 0 10 -1 0
1 34 0 10 -1 0
2 20 0 30 0 10 -1 1
2 20 0 30 0 21 -1 0
1 11 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 t z2
0
6
1 3 0 10 -1 0
1 9 0 10 -1 0
2 35 0 4 0 10 -1 1
2 35 0 4 0 21 -1 0
1 3 0 21 -1 1
1 9 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 f z2
0
6
1 9 0 10 -1 0
1 18 0 10 -1 0
2 35 0 6 0 10 -1 1
2 35 0 6 0 21 -1 0
1 9 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 tmp1 z2
0
6
1 9 0 10 -1 0
1 23 0 10 -1 0
2 35 0 14 0 10 -1 1
2 35 0 14 0 21 -1 0
1 9 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 tmp2 z2
0
6
1 9 0 10 -1 0
1 32 0 10 -1 0
2 35 0 15 0 10 -1 1
2 35 0 15 0 21 -1 0
1 9 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 x1 z2
0
6
1 9 0 10 -1 0
1 11 0 10 -1 0
2 35 0 20 0 10 -1 1
2 35 0 20 0 21 -1 0
1 9 0 21 -1 1
1 11 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 r1 z2
0
6
1 9 0 10 -1 0
1 27 0 10 -1 0
2 19 0 35 0 10 -1 1
2 19 0 35 0 21 -1 0
1 9 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 z1 z2
0
6
1 8 0 10 -1 0
1 9 0 10 -1 0
2 35 0 7 0 10 -1 1
2 35 0 7 0 21 -1 0
1 8 0 21 -1 1
1 9 0 21 -1 1
0
end_operator
begin_operator
or-gate y1 r2 z2
0
6
1 9 0 10 -1 0
1 34 0 10 -1 0
2 35 0 30 0 10 -1 1
2 35 0 30 0 21 -1 0
1 9 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 t z2
0
6
1 3 0 10 -1 0
1 27 0 10 -1 0
2 19 0 4 0 10 -1 1
2 19 0 4 0 21 -1 0
1 3 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 f z2
0
6
1 18 0 10 -1 0
1 27 0 10 -1 0
2 19 0 6 0 10 -1 1
2 19 0 6 0 21 -1 0
1 18 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 tmp1 z2
0
6
1 23 0 10 -1 0
1 27 0 10 -1 0
2 19 0 14 0 10 -1 1
2 19 0 14 0 21 -1 0
1 23 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 tmp2 z2
0
6
1 27 0 10 -1 0
1 32 0 10 -1 0
2 19 0 15 0 10 -1 1
2 19 0 15 0 21 -1 0
1 27 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 x1 z2
0
6
1 11 0 10 -1 0
1 27 0 10 -1 0
2 19 0 20 0 10 -1 1
2 19 0 20 0 21 -1 0
1 11 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 y1 z2
0
6
1 9 0 10 -1 0
1 27 0 10 -1 0
2 35 0 19 0 10 -1 1
2 35 0 19 0 21 -1 0
1 9 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 z1 z2
0
6
1 8 0 10 -1 0
1 27 0 10 -1 0
2 19 0 7 0 10 -1 1
2 19 0 7 0 21 -1 0
1 8 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate r1 r2 z2
0
6
1 27 0 10 -1 0
1 34 0 10 -1 0
2 19 0 30 0 10 -1 1
2 19 0 30 0 21 -1 0
1 27 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 t z2
0
6
1 3 0 10 -1 0
1 8 0 10 -1 0
2 4 0 7 0 10 -1 1
2 4 0 7 0 21 -1 0
1 3 0 21 -1 1
1 8 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 f z2
0
6
1 8 0 10 -1 0
1 18 0 10 -1 0
2 6 0 7 0 10 -1 1
2 6 0 7 0 21 -1 0
1 8 0 21 -1 1
1 18 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 tmp1 z2
0
6
1 8 0 10 -1 0
1 23 0 10 -1 0
2 14 0 7 0 10 -1 1
2 14 0 7 0 21 -1 0
1 8 0 21 -1 1
1 23 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 tmp2 z2
0
6
1 8 0 10 -1 0
1 32 0 10 -1 0
2 15 0 7 0 10 -1 1
2 15 0 7 0 21 -1 0
1 8 0 21 -1 1
1 32 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 x1 z2
0
6
1 8 0 10 -1 0
1 11 0 10 -1 0
2 20 0 7 0 10 -1 1
2 20 0 7 0 21 -1 0
1 8 0 21 -1 1
1 11 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 y1 z2
0
6
1 8 0 10 -1 0
1 9 0 10 -1 0
2 35 0 7 0 10 -1 1
2 35 0 7 0 21 -1 0
1 8 0 21 -1 1
1 9 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 r1 z2
0
6
1 8 0 10 -1 0
1 27 0 10 -1 0
2 19 0 7 0 10 -1 1
2 19 0 7 0 21 -1 0
1 8 0 21 -1 1
1 27 0 21 -1 1
0
end_operator
begin_operator
or-gate z1 r2 z2
0
6
1 8 0 10 -1 0
1 34 0 10 -1 0
2 30 0 7 0 10 -1 1
2 30 0 7 0 21 -1 0
1 8 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 t z2
0
6
1 3 0 10 -1 0
1 34 0 10 -1 0
2 4 0 30 0 10 -1 1
2 4 0 30 0 21 -1 0
1 3 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 f z2
0
6
1 18 0 10 -1 0
1 34 0 10 -1 0
2 6 0 30 0 10 -1 1
2 6 0 30 0 21 -1 0
1 18 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 tmp1 z2
0
6
1 23 0 10 -1 0
1 34 0 10 -1 0
2 14 0 30 0 10 -1 1
2 14 0 30 0 21 -1 0
1 23 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 tmp2 z2
0
6
1 32 0 10 -1 0
1 34 0 10 -1 0
2 30 0 15 0 10 -1 1
2 30 0 15 0 21 -1 0
1 32 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 x1 z2
0
6
1 11 0 10 -1 0
1 34 0 10 -1 0
2 20 0 30 0 10 -1 1
2 20 0 30 0 21 -1 0
1 11 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 y1 z2
0
6
1 9 0 10 -1 0
1 34 0 10 -1 0
2 35 0 30 0 10 -1 1
2 35 0 30 0 21 -1 0
1 9 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 r1 z2
0
6
1 27 0 10 -1 0
1 34 0 10 -1 0
2 19 0 30 0 10 -1 1
2 19 0 30 0 21 -1 0
1 27 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate r2 z1 z2
0
6
1 8 0 10 -1 0
1 34 0 10 -1 0
2 30 0 7 0 10 -1 1
2 30 0 7 0 21 -1 0
1 8 0 21 -1 1
1 34 0 21 -1 1
0
end_operator
begin_operator
or-gate t z2 f
0
6
2 4 0 21 0 6 -1 0
1 3 0 6 -1 1
1 10 0 6 -1 1
1 3 0 18 -1 0
1 10 0 18 -1 0
2 4 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate t z2 tmp1
0
6
2 4 0 21 0 14 -1 0
1 3 0 14 -1 1
1 10 0 14 -1 1
1 3 0 23 -1 0
1 10 0 23 -1 0
2 4 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate t z2 tmp2
0
6
2 4 0 21 0 15 -1 0
1 3 0 15 -1 1
1 10 0 15 -1 1
1 3 0 32 -1 0
1 10 0 32 -1 0
2 4 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate t z2 r1
0
6
2 4 0 21 0 19 -1 0
1 3 0 19 -1 1
1 10 0 19 -1 1
1 3 0 27 -1 0
1 10 0 27 -1 0
2 4 0 21 0 27 -1 1
0
end_operator
begin_operator
or-gate t z2 z1
0
6
2 4 0 21 0 7 -1 0
1 3 0 7 -1 1
1 10 0 7 -1 1
1 3 0 8 -1 0
1 10 0 8 -1 0
2 4 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate t z2 r2
0
6
2 4 0 21 0 30 -1 0
1 3 0 30 -1 1
1 10 0 30 -1 1
1 3 0 34 -1 0
1 10 0 34 -1 0
2 4 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate f z2 t
0
6
1 10 0 3 -1 0
1 18 0 3 -1 0
2 21 0 6 0 3 -1 1
2 21 0 6 0 4 -1 0
1 10 0 4 -1 1
1 18 0 4 -1 1
0
end_operator
begin_operator
or-gate f z2 tmp1
0
6
2 21 0 6 0 14 -1 0
1 10 0 14 -1 1
1 18 0 14 -1 1
1 10 0 23 -1 0
1 18 0 23 -1 0
2 21 0 6 0 23 -1 1
0
end_operator
begin_operator
or-gate f z2 tmp2
0
6
2 21 0 6 0 15 -1 0
1 10 0 15 -1 1
1 18 0 15 -1 1
1 10 0 32 -1 0
1 18 0 32 -1 0
2 21 0 6 0 32 -1 1
0
end_operator
begin_operator
or-gate f z2 r1
0
6
2 21 0 6 0 19 -1 0
1 10 0 19 -1 1
1 18 0 19 -1 1
1 10 0 27 -1 0
1 18 0 27 -1 0
2 21 0 6 0 27 -1 1
0
end_operator
begin_operator
or-gate f z2 z1
0
6
2 21 0 6 0 7 -1 0
1 10 0 7 -1 1
1 18 0 7 -1 1
1 10 0 8 -1 0
1 18 0 8 -1 0
2 21 0 6 0 8 -1 1
0
end_operator
begin_operator
or-gate f z2 r2
0
6
2 21 0 6 0 30 -1 0
1 10 0 30 -1 1
1 18 0 30 -1 1
1 10 0 34 -1 0
1 18 0 34 -1 0
2 21 0 6 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp1 z2 t
0
6
1 10 0 3 -1 0
1 23 0 3 -1 0
2 21 0 14 0 3 -1 1
2 21 0 14 0 4 -1 0
1 10 0 4 -1 1
1 23 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp1 z2 f
0
6
2 21 0 14 0 6 -1 0
1 10 0 6 -1 1
1 23 0 6 -1 1
1 10 0 18 -1 0
1 23 0 18 -1 0
2 21 0 14 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp1 z2 tmp2
0
6
2 21 0 14 0 15 -1 0
1 10 0 15 -1 1
1 23 0 15 -1 1
1 10 0 32 -1 0
1 23 0 32 -1 0
2 21 0 14 0 32 -1 1
0
end_operator
begin_operator
or-gate tmp1 z2 r1
0
6
2 21 0 14 0 19 -1 0
1 10 0 19 -1 1
1 23 0 19 -1 1
1 10 0 27 -1 0
1 23 0 27 -1 0
2 21 0 14 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp1 z2 z1
0
6
2 21 0 14 0 7 -1 0
1 10 0 7 -1 1
1 23 0 7 -1 1
1 10 0 8 -1 0
1 23 0 8 -1 0
2 21 0 14 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp1 z2 r2
0
6
2 21 0 14 0 30 -1 0
1 10 0 30 -1 1
1 23 0 30 -1 1
1 10 0 34 -1 0
1 23 0 34 -1 0
2 21 0 14 0 34 -1 1
0
end_operator
begin_operator
or-gate tmp2 z2 t
0
6
1 10 0 3 -1 0
1 32 0 3 -1 0
2 21 0 15 0 3 -1 1
2 21 0 15 0 4 -1 0
1 10 0 4 -1 1
1 32 0 4 -1 1
0
end_operator
begin_operator
or-gate tmp2 z2 f
0
6
2 21 0 15 0 6 -1 0
1 10 0 6 -1 1
1 32 0 6 -1 1
1 10 0 18 -1 0
1 32 0 18 -1 0
2 21 0 15 0 18 -1 1
0
end_operator
begin_operator
or-gate tmp2 z2 tmp1
0
6
2 21 0 15 0 14 -1 0
1 10 0 14 -1 1
1 32 0 14 -1 1
1 10 0 23 -1 0
1 32 0 23 -1 0
2 21 0 15 0 23 -1 1
0
end_operator
begin_operator
or-gate tmp2 z2 r1
0
6
2 21 0 15 0 19 -1 0
1 10 0 19 -1 1
1 32 0 19 -1 1
1 10 0 27 -1 0
1 32 0 27 -1 0
2 21 0 15 0 27 -1 1
0
end_operator
begin_operator
or-gate tmp2 z2 z1
0
6
2 21 0 15 0 7 -1 0
1 10 0 7 -1 1
1 32 0 7 -1 1
1 10 0 8 -1 0
1 32 0 8 -1 0
2 21 0 15 0 8 -1 1
0
end_operator
begin_operator
or-gate tmp2 z2 r2
0
6
2 21 0 15 0 30 -1 0
1 10 0 30 -1 1
1 32 0 30 -1 1
1 10 0 34 -1 0
1 32 0 34 -1 0
2 21 0 15 0 34 -1 1
0
end_operator
begin_operator
or-gate x1 z2 t
0
6
1 10 0 3 -1 0
1 11 0 3 -1 0
2 20 0 21 0 3 -1 1
2 20 0 21 0 4 -1 0
1 10 0 4 -1 1
1 11 0 4 -1 1
0
end_operator
begin_operator
or-gate x1 z2 f
0
6
2 20 0 21 0 6 -1 0
1 10 0 6 -1 1
1 11 0 6 -1 1
1 10 0 18 -1 0
1 11 0 18 -1 0
2 20 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate x1 z2 tmp1
0
6
2 20 0 21 0 14 -1 0
1 10 0 14 -1 1
1 11 0 14 -1 1
1 10 0 23 -1 0
1 11 0 23 -1 0
2 20 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate x1 z2 tmp2
0
6
2 20 0 21 0 15 -1 0
1 10 0 15 -1 1
1 11 0 15 -1 1
1 10 0 32 -1 0
1 11 0 32 -1 0
2 20 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate x1 z2 r1
0
6
2 20 0 21 0 19 -1 0
1 10 0 19 -1 1
1 11 0 19 -1 1
1 10 0 27 -1 0
1 11 0 27 -1 0
2 20 0 21 0 27 -1 1
0
end_operator
begin_operator
or-gate x1 z2 z1
0
6
2 20 0 21 0 7 -1 0
1 10 0 7 -1 1
1 11 0 7 -1 1
1 10 0 8 -1 0
1 11 0 8 -1 0
2 20 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate x1 z2 r2
0
6
2 20 0 21 0 30 -1 0
1 10 0 30 -1 1
1 11 0 30 -1 1
1 10 0 34 -1 0
1 11 0 34 -1 0
2 20 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate y1 z2 t
0
6
1 9 0 3 -1 0
1 10 0 3 -1 0
2 35 0 21 0 3 -1 1
2 35 0 21 0 4 -1 0
1 9 0 4 -1 1
1 10 0 4 -1 1
0
end_operator
begin_operator
or-gate y1 z2 f
0
6
2 35 0 21 0 6 -1 0
1 9 0 6 -1 1
1 10 0 6 -1 1
1 9 0 18 -1 0
1 10 0 18 -1 0
2 35 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate y1 z2 tmp1
0
6
2 35 0 21 0 14 -1 0
1 9 0 14 -1 1
1 10 0 14 -1 1
1 9 0 23 -1 0
1 10 0 23 -1 0
2 35 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate y1 z2 tmp2
0
6
2 35 0 21 0 15 -1 0
1 9 0 15 -1 1
1 10 0 15 -1 1
1 9 0 32 -1 0
1 10 0 32 -1 0
2 35 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate y1 z2 r1
0
6
2 35 0 21 0 19 -1 0
1 9 0 19 -1 1
1 10 0 19 -1 1
1 9 0 27 -1 0
1 10 0 27 -1 0
2 35 0 21 0 27 -1 1
0
end_operator
begin_operator
or-gate y1 z2 z1
0
6
2 35 0 21 0 7 -1 0
1 9 0 7 -1 1
1 10 0 7 -1 1
1 9 0 8 -1 0
1 10 0 8 -1 0
2 35 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate y1 z2 r2
0
6
2 35 0 21 0 30 -1 0
1 9 0 30 -1 1
1 10 0 30 -1 1
1 9 0 34 -1 0
1 10 0 34 -1 0
2 35 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate r1 z2 t
0
6
1 10 0 3 -1 0
1 27 0 3 -1 0
2 19 0 21 0 3 -1 1
2 19 0 21 0 4 -1 0
1 10 0 4 -1 1
1 27 0 4 -1 1
0
end_operator
begin_operator
or-gate r1 z2 f
0
6
2 19 0 21 0 6 -1 0
1 10 0 6 -1 1
1 27 0 6 -1 1
1 10 0 18 -1 0
1 27 0 18 -1 0
2 19 0 21 0 18 -1 1
0
end_operator
begin_operator
or-gate r1 z2 tmp1
0
6
2 19 0 21 0 14 -1 0
1 10 0 14 -1 1
1 27 0 14 -1 1
1 10 0 23 -1 0
1 27 0 23 -1 0
2 19 0 21 0 23 -1 1
0
end_operator
begin_operator
or-gate r1 z2 tmp2
0
6
2 19 0 21 0 15 -1 0
1 10 0 15 -1 1
1 27 0 15 -1 1
1 10 0 32 -1 0
1 27 0 32 -1 0
2 19 0 21 0 32 -1 1
0
end_operator
begin_operator
or-gate r1 z2 z1
0
6
2 19 0 21 0 7 -1 0
1 10 0 7 -1 1
1 27 0 7 -1 1
1 10 0 8 -1 0
1 27 0 8 -1 0
2 19 0 21 0 8 -1 1
0
end_operator
begin_operator
or-gate r1 z2 r2
0
6
2 19 0 21 0 30 -1 0
1 10 0 30 -1 1
1 27 0 30 -1 1
1 10 0 34 -1 0
1 27 0 34 -1 0
2 19 0 21 0 34 -1 1
0
end_operator
begin_operator
or-gate z1 z2 t
0
6
1 8 0 3 -1 0
1 10 0 3 -1 0
2 21 0 7 0 3 -1 1
2 21 0 7 0 4 -1 0
1 8 0 4 -1 1
1 10 0 4 -1 1
0
end_operator
begin_operator
or-gate z1 z2 f
0
6
2 21 0 7 0 6 -1 0
1 8 0 6 -1 1
1 10 0 6 -1 1
1 8 0 18 -1 0
1 10 0 18 -1 0
2 21 0 7 0 18 -1 1
0
end_operator
begin_operator
or-gate z1 z2 tmp1
0
6
2 21 0 7 0 14 -1 0
1 8 0 14 -1 1
1 10 0 14 -1 1
1 8 0 23 -1 0
1 10 0 23 -1 0
2 21 0 7 0 23 -1 1
0
end_operator
begin_operator
or-gate z1 z2 tmp2
0
6
2 21 0 7 0 15 -1 0
1 8 0 15 -1 1
1 10 0 15 -1 1
1 8 0 32 -1 0
1 10 0 32 -1 0
2 21 0 7 0 32 -1 1
0
end_operator
begin_operator
or-gate z1 z2 r1
0
6
2 21 0 7 0 19 -1 0
1 8 0 19 -1 1
1 10 0 19 -1 1
1 8 0 27 -1 0
1 10 0 27 -1 0
2 21 0 7 0 27 -1 1
0
end_operator
begin_operator
or-gate z1 z2 r2
0
6
2 21 0 7 0 30 -1 0
1 8 0 30 -1 1
1 10 0 30 -1 1
1 8 0 34 -1 0
1 10 0 34 -1 0
2 21 0 7 0 34 -1 1
0
end_operator
begin_operator
or-gate r2 z2 t
0
6
1 10 0 3 -1 0
1 34 0 3 -1 0
2 21 0 30 0 3 -1 1
2 21 0 30 0 4 -1 0
1 10 0 4 -1 1
1 34 0 4 -1 1
0
end_operator
begin_operator
or-gate r2 z2 f
0
6
2 21 0 30 0 6 -1 0
1 10 0 6 -1 1
1 34 0 6 -1 1
1 10 0 18 -1 0
1 34 0 18 -1 0
2 21 0 30 0 18 -1 1
0
end_operator
begin_operator
or-gate r2 z2 tmp1
0
6
2 21 0 30 0 14 -1 0
1 10 0 14 -1 1
1 34 0 14 -1 1
1 10 0 23 -1 0
1 34 0 23 -1 0
2 21 0 30 0 23 -1 1
0
end_operator
begin_operator
or-gate r2 z2 tmp2
0
6
2 21 0 30 0 15 -1 0
1 10 0 15 -1 1
1 34 0 15 -1 1
1 10 0 32 -1 0
1 34 0 32 -1 0
2 21 0 30 0 32 -1 1
0
end_operator
begin_operator
or-gate r2 z2 r1
0
6
2 21 0 30 0 19 -1 0
1 10 0 19 -1 1
1 34 0 19 -1 1
1 10 0 27 -1 0
1 34 0 27 -1 0
2 21 0 30 0 27 -1 1
0
end_operator
begin_operator
or-gate r2 z2 z1
0
6
2 21 0 30 0 7 -1 0
1 10 0 7 -1 1
1 34 0 7 -1 1
1 10 0 8 -1 0
1 34 0 8 -1 0
2 21 0 30 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 f t
0
8
2 10 0 6 0 3 -1 0
2 18 0 21 0 3 -1 0
2 10 0 18 0 3 -1 1
2 21 0 6 0 3 -1 1
2 10 0 18 0 4 -1 0
2 21 0 6 0 4 -1 0
2 10 0 6 0 4 -1 1
2 18 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp1 t
0
8
2 10 0 14 0 3 -1 0
2 21 0 23 0 3 -1 0
2 10 0 23 0 3 -1 1
2 21 0 14 0 3 -1 1
2 10 0 23 0 4 -1 0
2 21 0 14 0 4 -1 0
2 10 0 14 0 4 -1 1
2 21 0 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp2 t
0
8
2 10 0 15 0 3 -1 0
2 32 0 21 0 3 -1 0
2 21 0 15 0 3 -1 1
2 32 0 10 0 3 -1 1
2 21 0 15 0 4 -1 0
2 32 0 10 0 4 -1 0
2 10 0 15 0 4 -1 1
2 32 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 t
0
8
2 10 0 20 0 3 -1 0
2 11 0 21 0 3 -1 0
2 10 0 11 0 3 -1 1
2 20 0 21 0 3 -1 1
2 10 0 11 0 4 -1 0
2 20 0 21 0 4 -1 0
2 10 0 20 0 4 -1 1
2 11 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 t
0
8
2 9 0 21 0 3 -1 0
2 10 0 35 0 3 -1 0
2 9 0 10 0 3 -1 1
2 35 0 21 0 3 -1 1
2 9 0 10 0 4 -1 0
2 35 0 21 0 4 -1 0
2 9 0 21 0 4 -1 1
2 10 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 r1 t
0
8
2 10 0 19 0 3 -1 0
2 27 0 21 0 3 -1 0
2 10 0 27 0 3 -1 1
2 19 0 21 0 3 -1 1
2 10 0 27 0 4 -1 0
2 19 0 21 0 4 -1 0
2 10 0 19 0 4 -1 1
2 27 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 z1 t
0
8
2 8 0 21 0 3 -1 0
2 10 0 7 0 3 -1 0
2 8 0 10 0 3 -1 1
2 21 0 7 0 3 -1 1
2 8 0 10 0 4 -1 0
2 21 0 7 0 4 -1 0
2 8 0 21 0 4 -1 1
2 10 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 r2 t
0
8
2 10 0 30 0 3 -1 0
2 34 0 21 0 3 -1 0
2 10 0 34 0 3 -1 1
2 21 0 30 0 3 -1 1
2 10 0 34 0 4 -1 0
2 21 0 30 0 4 -1 0
2 10 0 30 0 4 -1 1
2 34 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate z2 t f
0
8
2 4 0 21 0 6 -1 0
2 10 0 3 0 6 -1 0
2 3 0 21 0 6 -1 1
2 10 0 4 0 6 -1 1
2 3 0 21 0 18 -1 0
2 10 0 4 0 18 -1 0
2 4 0 21 0 18 -1 1
2 10 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp1 f
0
8
2 10 0 23 0 6 -1 0
2 21 0 14 0 6 -1 0
2 10 0 14 0 6 -1 1
2 21 0 23 0 6 -1 1
2 10 0 14 0 18 -1 0
2 21 0 23 0 18 -1 0
2 10 0 23 0 18 -1 1
2 21 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp2 f
0
8
2 21 0 15 0 6 -1 0
2 32 0 10 0 6 -1 0
2 10 0 15 0 6 -1 1
2 32 0 21 0 6 -1 1
2 10 0 15 0 18 -1 0
2 32 0 21 0 18 -1 0
2 21 0 15 0 18 -1 1
2 32 0 10 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 f
0
8
2 10 0 11 0 6 -1 0
2 20 0 21 0 6 -1 0
2 10 0 20 0 6 -1 1
2 11 0 21 0 6 -1 1
2 10 0 20 0 18 -1 0
2 11 0 21 0 18 -1 0
2 10 0 11 0 18 -1 1
2 20 0 21 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 f
0
8
2 9 0 10 0 6 -1 0
2 35 0 21 0 6 -1 0
2 9 0 21 0 6 -1 1
2 10 0 35 0 6 -1 1
2 9 0 21 0 18 -1 0
2 10 0 35 0 18 -1 0
2 9 0 10 0 18 -1 1
2 35 0 21 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 r1 f
0
8
2 10 0 27 0 6 -1 0
2 19 0 21 0 6 -1 0
2 10 0 19 0 6 -1 1
2 27 0 21 0 6 -1 1
2 10 0 19 0 18 -1 0
2 27 0 21 0 18 -1 0
2 10 0 27 0 18 -1 1
2 19 0 21 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 z1 f
0
8
2 8 0 10 0 6 -1 0
2 21 0 7 0 6 -1 0
2 8 0 21 0 6 -1 1
2 10 0 7 0 6 -1 1
2 8 0 21 0 18 -1 0
2 10 0 7 0 18 -1 0
2 8 0 10 0 18 -1 1
2 21 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 r2 f
0
8
2 10 0 34 0 6 -1 0
2 21 0 30 0 6 -1 0
2 10 0 30 0 6 -1 1
2 34 0 21 0 6 -1 1
2 10 0 30 0 18 -1 0
2 34 0 21 0 18 -1 0
2 10 0 34 0 18 -1 1
2 21 0 30 0 18 -1 1
0
end_operator
begin_operator
xor-gate z2 t tmp1
0
8
2 4 0 21 0 14 -1 0
2 10 0 3 0 14 -1 0
2 3 0 21 0 14 -1 1
2 10 0 4 0 14 -1 1
2 3 0 21 0 23 -1 0
2 10 0 4 0 23 -1 0
2 4 0 21 0 23 -1 1
2 10 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 f tmp1
0
8
2 10 0 18 0 14 -1 0
2 21 0 6 0 14 -1 0
2 10 0 6 0 14 -1 1
2 18 0 21 0 14 -1 1
2 10 0 6 0 23 -1 0
2 18 0 21 0 23 -1 0
2 10 0 18 0 23 -1 1
2 21 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp2 tmp1
0
8
2 21 0 15 0 14 -1 0
2 32 0 10 0 14 -1 0
2 10 0 15 0 14 -1 1
2 32 0 21 0 14 -1 1
2 10 0 15 0 23 -1 0
2 32 0 21 0 23 -1 0
2 21 0 15 0 23 -1 1
2 32 0 10 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 tmp1
0
8
2 10 0 11 0 14 -1 0
2 20 0 21 0 14 -1 0
2 10 0 20 0 14 -1 1
2 11 0 21 0 14 -1 1
2 10 0 20 0 23 -1 0
2 11 0 21 0 23 -1 0
2 10 0 11 0 23 -1 1
2 20 0 21 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 tmp1
0
8
2 9 0 10 0 14 -1 0
2 35 0 21 0 14 -1 0
2 9 0 21 0 14 -1 1
2 10 0 35 0 14 -1 1
2 9 0 21 0 23 -1 0
2 10 0 35 0 23 -1 0
2 9 0 10 0 23 -1 1
2 35 0 21 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 r1 tmp1
0
8
2 10 0 27 0 14 -1 0
2 19 0 21 0 14 -1 0
2 10 0 19 0 14 -1 1
2 27 0 21 0 14 -1 1
2 10 0 19 0 23 -1 0
2 27 0 21 0 23 -1 0
2 10 0 27 0 23 -1 1
2 19 0 21 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 z1 tmp1
0
8
2 8 0 10 0 14 -1 0
2 21 0 7 0 14 -1 0
2 8 0 21 0 14 -1 1
2 10 0 7 0 14 -1 1
2 8 0 21 0 23 -1 0
2 10 0 7 0 23 -1 0
2 8 0 10 0 23 -1 1
2 21 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 r2 tmp1
0
8
2 10 0 34 0 14 -1 0
2 21 0 30 0 14 -1 0
2 10 0 30 0 14 -1 1
2 34 0 21 0 14 -1 1
2 10 0 30 0 23 -1 0
2 34 0 21 0 23 -1 0
2 10 0 34 0 23 -1 1
2 21 0 30 0 23 -1 1
0
end_operator
begin_operator
xor-gate z2 t tmp2
0
8
2 4 0 21 0 15 -1 0
2 10 0 3 0 15 -1 0
2 3 0 21 0 15 -1 1
2 10 0 4 0 15 -1 1
2 3 0 21 0 32 -1 0
2 10 0 4 0 32 -1 0
2 4 0 21 0 32 -1 1
2 10 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 f tmp2
0
8
2 10 0 18 0 15 -1 0
2 21 0 6 0 15 -1 0
2 10 0 6 0 15 -1 1
2 18 0 21 0 15 -1 1
2 10 0 6 0 32 -1 0
2 18 0 21 0 32 -1 0
2 10 0 18 0 32 -1 1
2 21 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp1 tmp2
0
8
2 10 0 23 0 15 -1 0
2 21 0 14 0 15 -1 0
2 10 0 14 0 15 -1 1
2 21 0 23 0 15 -1 1
2 10 0 14 0 32 -1 0
2 21 0 23 0 32 -1 0
2 10 0 23 0 32 -1 1
2 21 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 tmp2
0
8
2 10 0 11 0 15 -1 0
2 20 0 21 0 15 -1 0
2 10 0 20 0 15 -1 1
2 11 0 21 0 15 -1 1
2 10 0 20 0 32 -1 0
2 11 0 21 0 32 -1 0
2 10 0 11 0 32 -1 1
2 20 0 21 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 tmp2
0
8
2 9 0 10 0 15 -1 0
2 35 0 21 0 15 -1 0
2 9 0 21 0 15 -1 1
2 10 0 35 0 15 -1 1
2 9 0 21 0 32 -1 0
2 10 0 35 0 32 -1 0
2 9 0 10 0 32 -1 1
2 35 0 21 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 r1 tmp2
0
8
2 10 0 27 0 15 -1 0
2 19 0 21 0 15 -1 0
2 10 0 19 0 15 -1 1
2 27 0 21 0 15 -1 1
2 10 0 19 0 32 -1 0
2 27 0 21 0 32 -1 0
2 10 0 27 0 32 -1 1
2 19 0 21 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 z1 tmp2
0
8
2 8 0 10 0 15 -1 0
2 21 0 7 0 15 -1 0
2 8 0 21 0 15 -1 1
2 10 0 7 0 15 -1 1
2 8 0 21 0 32 -1 0
2 10 0 7 0 32 -1 0
2 8 0 10 0 32 -1 1
2 21 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 r2 tmp2
0
8
2 10 0 34 0 15 -1 0
2 21 0 30 0 15 -1 0
2 10 0 30 0 15 -1 1
2 34 0 21 0 15 -1 1
2 10 0 30 0 32 -1 0
2 34 0 21 0 32 -1 0
2 10 0 34 0 32 -1 1
2 21 0 30 0 32 -1 1
0
end_operator
begin_operator
xor-gate z2 t r1
0
8
2 4 0 21 0 19 -1 0
2 10 0 3 0 19 -1 0
2 3 0 21 0 19 -1 1
2 10 0 4 0 19 -1 1
2 3 0 21 0 27 -1 0
2 10 0 4 0 27 -1 0
2 4 0 21 0 27 -1 1
2 10 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 f r1
0
8
2 10 0 18 0 19 -1 0
2 21 0 6 0 19 -1 0
2 10 0 6 0 19 -1 1
2 18 0 21 0 19 -1 1
2 10 0 6 0 27 -1 0
2 18 0 21 0 27 -1 0
2 10 0 18 0 27 -1 1
2 21 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp1 r1
0
8
2 10 0 23 0 19 -1 0
2 21 0 14 0 19 -1 0
2 10 0 14 0 19 -1 1
2 21 0 23 0 19 -1 1
2 10 0 14 0 27 -1 0
2 21 0 23 0 27 -1 0
2 10 0 23 0 27 -1 1
2 21 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp2 r1
0
8
2 21 0 15 0 19 -1 0
2 32 0 10 0 19 -1 0
2 10 0 15 0 19 -1 1
2 32 0 21 0 19 -1 1
2 10 0 15 0 27 -1 0
2 32 0 21 0 27 -1 0
2 21 0 15 0 27 -1 1
2 32 0 10 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 r1
0
8
2 10 0 11 0 19 -1 0
2 20 0 21 0 19 -1 0
2 10 0 20 0 19 -1 1
2 11 0 21 0 19 -1 1
2 10 0 20 0 27 -1 0
2 11 0 21 0 27 -1 0
2 10 0 11 0 27 -1 1
2 20 0 21 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 r1
0
8
2 9 0 10 0 19 -1 0
2 35 0 21 0 19 -1 0
2 9 0 21 0 19 -1 1
2 10 0 35 0 19 -1 1
2 9 0 21 0 27 -1 0
2 10 0 35 0 27 -1 0
2 9 0 10 0 27 -1 1
2 35 0 21 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 z1 r1
0
8
2 8 0 10 0 19 -1 0
2 21 0 7 0 19 -1 0
2 8 0 21 0 19 -1 1
2 10 0 7 0 19 -1 1
2 8 0 21 0 27 -1 0
2 10 0 7 0 27 -1 0
2 8 0 10 0 27 -1 1
2 21 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 r2 r1
0
8
2 10 0 34 0 19 -1 0
2 21 0 30 0 19 -1 0
2 10 0 30 0 19 -1 1
2 34 0 21 0 19 -1 1
2 10 0 30 0 27 -1 0
2 34 0 21 0 27 -1 0
2 10 0 34 0 27 -1 1
2 21 0 30 0 27 -1 1
0
end_operator
begin_operator
xor-gate z2 t z1
0
8
2 4 0 21 0 7 -1 0
2 10 0 3 0 7 -1 0
2 3 0 21 0 7 -1 1
2 10 0 4 0 7 -1 1
2 3 0 21 0 8 -1 0
2 10 0 4 0 8 -1 0
2 4 0 21 0 8 -1 1
2 10 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 f z1
0
8
2 10 0 18 0 7 -1 0
2 21 0 6 0 7 -1 0
2 10 0 6 0 7 -1 1
2 18 0 21 0 7 -1 1
2 10 0 6 0 8 -1 0
2 18 0 21 0 8 -1 0
2 10 0 18 0 8 -1 1
2 21 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp1 z1
0
8
2 10 0 23 0 7 -1 0
2 21 0 14 0 7 -1 0
2 10 0 14 0 7 -1 1
2 21 0 23 0 7 -1 1
2 10 0 14 0 8 -1 0
2 21 0 23 0 8 -1 0
2 10 0 23 0 8 -1 1
2 21 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp2 z1
0
8
2 21 0 15 0 7 -1 0
2 32 0 10 0 7 -1 0
2 10 0 15 0 7 -1 1
2 32 0 21 0 7 -1 1
2 10 0 15 0 8 -1 0
2 32 0 21 0 8 -1 0
2 21 0 15 0 8 -1 1
2 32 0 10 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 z1
0
8
2 10 0 11 0 7 -1 0
2 20 0 21 0 7 -1 0
2 10 0 20 0 7 -1 1
2 11 0 21 0 7 -1 1
2 10 0 20 0 8 -1 0
2 11 0 21 0 8 -1 0
2 10 0 11 0 8 -1 1
2 20 0 21 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 z1
0
8
2 9 0 10 0 7 -1 0
2 35 0 21 0 7 -1 0
2 9 0 21 0 7 -1 1
2 10 0 35 0 7 -1 1
2 9 0 21 0 8 -1 0
2 10 0 35 0 8 -1 0
2 9 0 10 0 8 -1 1
2 35 0 21 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 r1 z1
0
8
2 10 0 27 0 7 -1 0
2 19 0 21 0 7 -1 0
2 10 0 19 0 7 -1 1
2 27 0 21 0 7 -1 1
2 10 0 19 0 8 -1 0
2 27 0 21 0 8 -1 0
2 10 0 27 0 8 -1 1
2 19 0 21 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 r2 z1
0
8
2 10 0 34 0 7 -1 0
2 21 0 30 0 7 -1 0
2 10 0 30 0 7 -1 1
2 34 0 21 0 7 -1 1
2 10 0 30 0 8 -1 0
2 34 0 21 0 8 -1 0
2 10 0 34 0 8 -1 1
2 21 0 30 0 8 -1 1
0
end_operator
begin_operator
xor-gate z2 t r2
0
8
2 4 0 21 0 30 -1 0
2 10 0 3 0 30 -1 0
2 3 0 21 0 30 -1 1
2 10 0 4 0 30 -1 1
2 3 0 21 0 34 -1 0
2 10 0 4 0 34 -1 0
2 4 0 21 0 34 -1 1
2 10 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 f r2
0
8
2 10 0 18 0 30 -1 0
2 21 0 6 0 30 -1 0
2 10 0 6 0 30 -1 1
2 18 0 21 0 30 -1 1
2 10 0 6 0 34 -1 0
2 18 0 21 0 34 -1 0
2 10 0 18 0 34 -1 1
2 21 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp1 r2
0
8
2 10 0 23 0 30 -1 0
2 21 0 14 0 30 -1 0
2 10 0 14 0 30 -1 1
2 21 0 23 0 30 -1 1
2 10 0 14 0 34 -1 0
2 21 0 23 0 34 -1 0
2 10 0 23 0 34 -1 1
2 21 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 tmp2 r2
0
8
2 21 0 15 0 30 -1 0
2 32 0 10 0 30 -1 0
2 10 0 15 0 30 -1 1
2 32 0 21 0 30 -1 1
2 10 0 15 0 34 -1 0
2 32 0 21 0 34 -1 0
2 21 0 15 0 34 -1 1
2 32 0 10 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 x1 r2
0
8
2 10 0 11 0 30 -1 0
2 20 0 21 0 30 -1 0
2 10 0 20 0 30 -1 1
2 11 0 21 0 30 -1 1
2 10 0 20 0 34 -1 0
2 11 0 21 0 34 -1 0
2 10 0 11 0 34 -1 1
2 20 0 21 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 y1 r2
0
8
2 9 0 10 0 30 -1 0
2 35 0 21 0 30 -1 0
2 9 0 21 0 30 -1 1
2 10 0 35 0 30 -1 1
2 9 0 21 0 34 -1 0
2 10 0 35 0 34 -1 0
2 9 0 10 0 34 -1 1
2 35 0 21 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 r1 r2
0
8
2 10 0 27 0 30 -1 0
2 19 0 21 0 30 -1 0
2 10 0 19 0 30 -1 1
2 27 0 21 0 30 -1 1
2 10 0 19 0 34 -1 0
2 27 0 21 0 34 -1 0
2 10 0 27 0 34 -1 1
2 19 0 21 0 34 -1 1
0
end_operator
begin_operator
xor-gate z2 z1 r2
0
8
2 8 0 10 0 30 -1 0
2 21 0 7 0 30 -1 0
2 8 0 21 0 30 -1 1
2 10 0 7 0 30 -1 1
2 8 0 21 0 34 -1 0
2 10 0 7 0 34 -1 0
2 8 0 10 0 34 -1 1
2 21 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate t f z2
0
8
2 3 0 6 0 10 -1 0
2 18 0 4 0 10 -1 0
2 4 0 6 0 10 -1 1
2 18 0 3 0 10 -1 1
2 4 0 6 0 21 -1 0
2 18 0 3 0 21 -1 0
2 3 0 6 0 21 -1 1
2 18 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate t tmp1 z2
0
8
2 3 0 14 0 10 -1 0
2 4 0 23 0 10 -1 0
2 3 0 23 0 10 -1 1
2 4 0 14 0 10 -1 1
2 3 0 23 0 21 -1 0
2 4 0 14 0 21 -1 0
2 3 0 14 0 21 -1 1
2 4 0 23 0 21 -1 1
0
end_operator
begin_operator
xor-gate t tmp2 z2
0
8
2 3 0 15 0 10 -1 0
2 32 0 4 0 10 -1 0
2 4 0 15 0 10 -1 1
2 32 0 3 0 10 -1 1
2 4 0 15 0 21 -1 0
2 32 0 3 0 21 -1 0
2 3 0 15 0 21 -1 1
2 32 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate t x1 z2
0
8
2 3 0 20 0 10 -1 0
2 11 0 4 0 10 -1 0
2 11 0 3 0 10 -1 1
2 20 0 4 0 10 -1 1
2 11 0 3 0 21 -1 0
2 20 0 4 0 21 -1 0
2 3 0 20 0 21 -1 1
2 11 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate t y1 z2
0
8
2 9 0 4 0 10 -1 0
2 35 0 3 0 10 -1 0
2 9 0 3 0 10 -1 1
2 35 0 4 0 10 -1 1
2 9 0 3 0 21 -1 0
2 35 0 4 0 21 -1 0
2 9 0 4 0 21 -1 1
2 35 0 3 0 21 -1 1
0
end_operator
begin_operator
xor-gate t r1 z2
0
8
2 19 0 3 0 10 -1 0
2 27 0 4 0 10 -1 0
2 19 0 4 0 10 -1 1
2 27 0 3 0 10 -1 1
2 19 0 4 0 21 -1 0
2 27 0 3 0 21 -1 0
2 19 0 3 0 21 -1 1
2 27 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate t z1 z2
0
8
2 3 0 7 0 10 -1 0
2 8 0 4 0 10 -1 0
2 4 0 7 0 10 -1 1
2 8 0 3 0 10 -1 1
2 4 0 7 0 21 -1 0
2 8 0 3 0 21 -1 0
2 3 0 7 0 21 -1 1
2 8 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate t r2 z2
0
8
2 3 0 30 0 10 -1 0
2 34 0 4 0 10 -1 0
2 4 0 30 0 10 -1 1
2 34 0 3 0 10 -1 1
2 4 0 30 0 21 -1 0
2 34 0 3 0 21 -1 0
2 3 0 30 0 21 -1 1
2 34 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate f t z2
0
8
2 3 0 6 0 10 -1 0
2 18 0 4 0 10 -1 0
2 4 0 6 0 10 -1 1
2 18 0 3 0 10 -1 1
2 4 0 6 0 21 -1 0
2 18 0 3 0 21 -1 0
2 3 0 6 0 21 -1 1
2 18 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate f tmp1 z2
0
8
2 6 0 23 0 10 -1 0
2 18 0 14 0 10 -1 0
2 14 0 6 0 10 -1 1
2 18 0 23 0 10 -1 1
2 14 0 6 0 21 -1 0
2 18 0 23 0 21 -1 0
2 6 0 23 0 21 -1 1
2 18 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate f tmp2 z2
0
8
2 18 0 15 0 10 -1 0
2 32 0 6 0 10 -1 0
2 6 0 15 0 10 -1 1
2 32 0 18 0 10 -1 1
2 6 0 15 0 21 -1 0
2 32 0 18 0 21 -1 0
2 18 0 15 0 21 -1 1
2 32 0 6 0 21 -1 1
0
end_operator
begin_operator
xor-gate f x1 z2
0
8
2 11 0 6 0 10 -1 0
2 18 0 20 0 10 -1 0
2 18 0 11 0 10 -1 1
2 20 0 6 0 10 -1 1
2 18 0 11 0 21 -1 0
2 20 0 6 0 21 -1 0
2 11 0 6 0 21 -1 1
2 18 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate f y1 z2
0
8
2 9 0 6 0 10 -1 0
2 18 0 35 0 10 -1 0
2 9 0 18 0 10 -1 1
2 35 0 6 0 10 -1 1
2 9 0 18 0 21 -1 0
2 35 0 6 0 21 -1 0
2 9 0 6 0 21 -1 1
2 18 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate f r1 z2
0
8
2 18 0 19 0 10 -1 0
2 27 0 6 0 10 -1 0
2 18 0 27 0 10 -1 1
2 19 0 6 0 10 -1 1
2 18 0 27 0 21 -1 0
2 19 0 6 0 21 -1 0
2 18 0 19 0 21 -1 1
2 27 0 6 0 21 -1 1
0
end_operator
begin_operator
xor-gate f z1 z2
0
8
2 8 0 6 0 10 -1 0
2 18 0 7 0 10 -1 0
2 6 0 7 0 10 -1 1
2 8 0 18 0 10 -1 1
2 6 0 7 0 21 -1 0
2 8 0 18 0 21 -1 0
2 8 0 6 0 21 -1 1
2 18 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate f r2 z2
0
8
2 18 0 30 0 10 -1 0
2 34 0 6 0 10 -1 0
2 18 0 34 0 10 -1 1
2 30 0 6 0 10 -1 1
2 18 0 34 0 21 -1 0
2 30 0 6 0 21 -1 0
2 18 0 30 0 21 -1 1
2 34 0 6 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 t z2
0
8
2 3 0 14 0 10 -1 0
2 4 0 23 0 10 -1 0
2 3 0 23 0 10 -1 1
2 4 0 14 0 10 -1 1
2 3 0 23 0 21 -1 0
2 4 0 14 0 21 -1 0
2 3 0 14 0 21 -1 1
2 4 0 23 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 f z2
0
8
2 6 0 23 0 10 -1 0
2 18 0 14 0 10 -1 0
2 6 0 14 0 10 -1 1
2 18 0 23 0 10 -1 1
2 6 0 14 0 21 -1 0
2 18 0 23 0 21 -1 0
2 6 0 23 0 21 -1 1
2 18 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 tmp2 z2
0
8
2 15 0 23 0 10 -1 0
2 32 0 14 0 10 -1 0
2 14 0 15 0 10 -1 1
2 32 0 23 0 10 -1 1
2 14 0 15 0 21 -1 0
2 32 0 23 0 21 -1 0
2 15 0 23 0 21 -1 1
2 32 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 x1 z2
0
8
2 11 0 14 0 10 -1 0
2 20 0 23 0 10 -1 0
2 11 0 23 0 10 -1 1
2 20 0 14 0 10 -1 1
2 11 0 23 0 21 -1 0
2 20 0 14 0 21 -1 0
2 11 0 14 0 21 -1 1
2 20 0 23 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 y1 z2
0
8
2 9 0 14 0 10 -1 0
2 35 0 23 0 10 -1 0
2 9 0 23 0 10 -1 1
2 35 0 14 0 10 -1 1
2 9 0 23 0 21 -1 0
2 35 0 14 0 21 -1 0
2 9 0 14 0 21 -1 1
2 35 0 23 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r1 z2
0
8
2 19 0 23 0 10 -1 0
2 27 0 14 0 10 -1 0
2 19 0 14 0 10 -1 1
2 27 0 23 0 10 -1 1
2 19 0 14 0 21 -1 0
2 27 0 23 0 21 -1 0
2 19 0 23 0 21 -1 1
2 27 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z1 z2
0
8
2 7 0 23 0 10 -1 0
2 8 0 14 0 10 -1 0
2 8 0 23 0 10 -1 1
2 14 0 7 0 10 -1 1
2 8 0 23 0 21 -1 0
2 14 0 7 0 21 -1 0
2 7 0 23 0 21 -1 1
2 8 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp1 r2 z2
0
8
2 30 0 23 0 10 -1 0
2 34 0 14 0 10 -1 0
2 30 0 14 0 10 -1 1
2 34 0 23 0 10 -1 1
2 30 0 14 0 21 -1 0
2 34 0 23 0 21 -1 0
2 30 0 23 0 21 -1 1
2 34 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 t z2
0
8
2 3 0 15 0 10 -1 0
2 32 0 4 0 10 -1 0
2 4 0 15 0 10 -1 1
2 32 0 3 0 10 -1 1
2 4 0 15 0 21 -1 0
2 32 0 3 0 21 -1 0
2 3 0 15 0 21 -1 1
2 32 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 f z2
0
8
2 18 0 15 0 10 -1 0
2 32 0 6 0 10 -1 0
2 6 0 15 0 10 -1 1
2 32 0 18 0 10 -1 1
2 6 0 15 0 21 -1 0
2 32 0 18 0 21 -1 0
2 18 0 15 0 21 -1 1
2 32 0 6 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 tmp1 z2
0
8
2 23 0 15 0 10 -1 0
2 32 0 14 0 10 -1 0
2 14 0 15 0 10 -1 1
2 32 0 23 0 10 -1 1
2 14 0 15 0 21 -1 0
2 32 0 23 0 21 -1 0
2 23 0 15 0 21 -1 1
2 32 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 x1 z2
0
8
2 11 0 15 0 10 -1 0
2 32 0 20 0 10 -1 0
2 20 0 15 0 10 -1 1
2 32 0 11 0 10 -1 1
2 20 0 15 0 21 -1 0
2 32 0 11 0 21 -1 0
2 11 0 15 0 21 -1 1
2 32 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 y1 z2
0
8
2 9 0 15 0 10 -1 0
2 32 0 35 0 10 -1 0
2 32 0 9 0 10 -1 1
2 35 0 15 0 10 -1 1
2 32 0 9 0 21 -1 0
2 35 0 15 0 21 -1 0
2 9 0 15 0 21 -1 1
2 32 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r1 z2
0
8
2 27 0 15 0 10 -1 0
2 32 0 19 0 10 -1 0
2 19 0 15 0 10 -1 1
2 32 0 27 0 10 -1 1
2 19 0 15 0 21 -1 0
2 32 0 27 0 21 -1 0
2 27 0 15 0 21 -1 1
2 32 0 19 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z1 z2
0
8
2 8 0 15 0 10 -1 0
2 32 0 7 0 10 -1 0
2 7 0 15 0 10 -1 1
2 32 0 8 0 10 -1 1
2 7 0 15 0 21 -1 0
2 32 0 8 0 21 -1 0
2 8 0 15 0 21 -1 1
2 32 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate tmp2 r2 z2
0
8
2 32 0 30 0 10 -1 0
2 34 0 15 0 10 -1 0
2 30 0 15 0 10 -1 1
2 32 0 34 0 10 -1 1
2 30 0 15 0 21 -1 0
2 32 0 34 0 21 -1 0
2 32 0 30 0 21 -1 1
2 34 0 15 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 t z2
0
8
2 3 0 20 0 10 -1 0
2 11 0 4 0 10 -1 0
2 3 0 11 0 10 -1 1
2 4 0 20 0 10 -1 1
2 3 0 11 0 21 -1 0
2 4 0 20 0 21 -1 0
2 3 0 20 0 21 -1 1
2 11 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 f z2
0
8
2 11 0 6 0 10 -1 0
2 18 0 20 0 10 -1 0
2 18 0 11 0 10 -1 1
2 20 0 6 0 10 -1 1
2 18 0 11 0 21 -1 0
2 20 0 6 0 21 -1 0
2 11 0 6 0 21 -1 1
2 18 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp1 z2
0
8
2 11 0 14 0 10 -1 0
2 20 0 23 0 10 -1 0
2 11 0 23 0 10 -1 1
2 20 0 14 0 10 -1 1
2 11 0 23 0 21 -1 0
2 20 0 14 0 21 -1 0
2 11 0 14 0 21 -1 1
2 20 0 23 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 tmp2 z2
0
8
2 11 0 15 0 10 -1 0
2 32 0 20 0 10 -1 0
2 20 0 15 0 10 -1 1
2 32 0 11 0 10 -1 1
2 20 0 15 0 21 -1 0
2 32 0 11 0 21 -1 0
2 11 0 15 0 21 -1 1
2 32 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 y1 z2
0
8
2 9 0 20 0 10 -1 0
2 35 0 11 0 10 -1 0
2 9 0 11 0 10 -1 1
2 35 0 20 0 10 -1 1
2 9 0 11 0 21 -1 0
2 35 0 20 0 21 -1 0
2 9 0 20 0 21 -1 1
2 35 0 11 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 r1 z2
0
8
2 19 0 11 0 10 -1 0
2 27 0 20 0 10 -1 0
2 19 0 20 0 10 -1 1
2 27 0 11 0 10 -1 1
2 19 0 20 0 21 -1 0
2 27 0 11 0 21 -1 0
2 19 0 11 0 21 -1 1
2 27 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 z1 z2
0
8
2 8 0 20 0 10 -1 0
2 11 0 7 0 10 -1 0
2 8 0 11 0 10 -1 1
2 20 0 7 0 10 -1 1
2 8 0 11 0 21 -1 0
2 20 0 7 0 21 -1 0
2 8 0 20 0 21 -1 1
2 11 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate x1 r2 z2
0
8
2 11 0 30 0 10 -1 0
2 34 0 20 0 10 -1 0
2 20 0 30 0 10 -1 1
2 34 0 11 0 10 -1 1
2 20 0 30 0 21 -1 0
2 34 0 11 0 21 -1 0
2 11 0 30 0 21 -1 1
2 34 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 t z2
0
8
2 3 0 35 0 10 -1 0
2 9 0 4 0 10 -1 0
2 9 0 3 0 10 -1 1
2 35 0 4 0 10 -1 1
2 9 0 3 0 21 -1 0
2 35 0 4 0 21 -1 0
2 3 0 35 0 21 -1 1
2 9 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 f z2
0
8
2 9 0 6 0 10 -1 0
2 18 0 35 0 10 -1 0
2 9 0 18 0 10 -1 1
2 35 0 6 0 10 -1 1
2 9 0 18 0 21 -1 0
2 35 0 6 0 21 -1 0
2 9 0 6 0 21 -1 1
2 18 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp1 z2
0
8
2 9 0 14 0 10 -1 0
2 35 0 23 0 10 -1 0
2 9 0 23 0 10 -1 1
2 35 0 14 0 10 -1 1
2 9 0 23 0 21 -1 0
2 35 0 14 0 21 -1 0
2 9 0 14 0 21 -1 1
2 35 0 23 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 tmp2 z2
0
8
2 9 0 15 0 10 -1 0
2 32 0 35 0 10 -1 0
2 32 0 9 0 10 -1 1
2 35 0 15 0 10 -1 1
2 32 0 9 0 21 -1 0
2 35 0 15 0 21 -1 0
2 9 0 15 0 21 -1 1
2 32 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 x1 z2
0
8
2 9 0 20 0 10 -1 0
2 11 0 35 0 10 -1 0
2 9 0 11 0 10 -1 1
2 35 0 20 0 10 -1 1
2 9 0 11 0 21 -1 0
2 35 0 20 0 21 -1 0
2 9 0 20 0 21 -1 1
2 11 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 r1 z2
0
8
2 9 0 19 0 10 -1 0
2 27 0 35 0 10 -1 0
2 9 0 27 0 10 -1 1
2 19 0 35 0 10 -1 1
2 9 0 27 0 21 -1 0
2 19 0 35 0 21 -1 0
2 9 0 19 0 21 -1 1
2 27 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 z1 z2
0
8
2 8 0 35 0 10 -1 0
2 9 0 7 0 10 -1 0
2 8 0 9 0 10 -1 1
2 35 0 7 0 10 -1 1
2 8 0 9 0 21 -1 0
2 35 0 7 0 21 -1 0
2 8 0 35 0 21 -1 1
2 9 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate y1 r2 z2
0
8
2 9 0 30 0 10 -1 0
2 34 0 35 0 10 -1 0
2 9 0 34 0 10 -1 1
2 35 0 30 0 10 -1 1
2 9 0 34 0 21 -1 0
2 35 0 30 0 21 -1 0
2 9 0 30 0 21 -1 1
2 34 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 t z2
0
8
2 3 0 19 0 10 -1 0
2 27 0 4 0 10 -1 0
2 3 0 27 0 10 -1 1
2 19 0 4 0 10 -1 1
2 3 0 27 0 21 -1 0
2 19 0 4 0 21 -1 0
2 3 0 19 0 21 -1 1
2 27 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 f z2
0
8
2 18 0 19 0 10 -1 0
2 27 0 6 0 10 -1 0
2 18 0 27 0 10 -1 1
2 19 0 6 0 10 -1 1
2 18 0 27 0 21 -1 0
2 19 0 6 0 21 -1 0
2 18 0 19 0 21 -1 1
2 27 0 6 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp1 z2
0
8
2 19 0 23 0 10 -1 0
2 27 0 14 0 10 -1 0
2 19 0 14 0 10 -1 1
2 27 0 23 0 10 -1 1
2 19 0 14 0 21 -1 0
2 27 0 23 0 21 -1 0
2 19 0 23 0 21 -1 1
2 27 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 tmp2 z2
0
8
2 27 0 15 0 10 -1 0
2 32 0 19 0 10 -1 0
2 19 0 15 0 10 -1 1
2 32 0 27 0 10 -1 1
2 19 0 15 0 21 -1 0
2 32 0 27 0 21 -1 0
2 27 0 15 0 21 -1 1
2 32 0 19 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 x1 z2
0
8
2 11 0 19 0 10 -1 0
2 27 0 20 0 10 -1 0
2 11 0 27 0 10 -1 1
2 19 0 20 0 10 -1 1
2 11 0 27 0 21 -1 0
2 19 0 20 0 21 -1 0
2 11 0 19 0 21 -1 1
2 27 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 y1 z2
0
8
2 9 0 19 0 10 -1 0
2 35 0 27 0 10 -1 0
2 9 0 27 0 10 -1 1
2 35 0 19 0 10 -1 1
2 9 0 27 0 21 -1 0
2 35 0 19 0 21 -1 0
2 9 0 19 0 21 -1 1
2 35 0 27 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 z1 z2
0
8
2 8 0 19 0 10 -1 0
2 27 0 7 0 10 -1 0
2 8 0 27 0 10 -1 1
2 19 0 7 0 10 -1 1
2 8 0 27 0 21 -1 0
2 19 0 7 0 21 -1 0
2 8 0 19 0 21 -1 1
2 27 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate r1 r2 z2
0
8
2 27 0 30 0 10 -1 0
2 34 0 19 0 10 -1 0
2 19 0 30 0 10 -1 1
2 34 0 27 0 10 -1 1
2 19 0 30 0 21 -1 0
2 34 0 27 0 21 -1 0
2 27 0 30 0 21 -1 1
2 34 0 19 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 t z2
0
8
2 3 0 7 0 10 -1 0
2 8 0 4 0 10 -1 0
2 4 0 7 0 10 -1 1
2 8 0 3 0 10 -1 1
2 4 0 7 0 21 -1 0
2 8 0 3 0 21 -1 0
2 3 0 7 0 21 -1 1
2 8 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 f z2
0
8
2 8 0 6 0 10 -1 0
2 18 0 7 0 10 -1 0
2 6 0 7 0 10 -1 1
2 8 0 18 0 10 -1 1
2 6 0 7 0 21 -1 0
2 8 0 18 0 21 -1 0
2 8 0 6 0 21 -1 1
2 18 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp1 z2
0
8
2 8 0 14 0 10 -1 0
2 23 0 7 0 10 -1 0
2 8 0 23 0 10 -1 1
2 14 0 7 0 10 -1 1
2 8 0 23 0 21 -1 0
2 14 0 7 0 21 -1 0
2 8 0 14 0 21 -1 1
2 23 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 tmp2 z2
0
8
2 8 0 15 0 10 -1 0
2 32 0 7 0 10 -1 0
2 8 0 32 0 10 -1 1
2 15 0 7 0 10 -1 1
2 8 0 32 0 21 -1 0
2 15 0 7 0 21 -1 0
2 8 0 15 0 21 -1 1
2 32 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 x1 z2
0
8
2 8 0 20 0 10 -1 0
2 11 0 7 0 10 -1 0
2 8 0 11 0 10 -1 1
2 20 0 7 0 10 -1 1
2 8 0 11 0 21 -1 0
2 20 0 7 0 21 -1 0
2 8 0 20 0 21 -1 1
2 11 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 y1 z2
0
8
2 8 0 35 0 10 -1 0
2 9 0 7 0 10 -1 0
2 8 0 9 0 10 -1 1
2 35 0 7 0 10 -1 1
2 8 0 9 0 21 -1 0
2 35 0 7 0 21 -1 0
2 8 0 35 0 21 -1 1
2 9 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 r1 z2
0
8
2 8 0 19 0 10 -1 0
2 27 0 7 0 10 -1 0
2 8 0 27 0 10 -1 1
2 19 0 7 0 10 -1 1
2 8 0 27 0 21 -1 0
2 19 0 7 0 21 -1 0
2 8 0 19 0 21 -1 1
2 27 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate z1 r2 z2
0
8
2 8 0 30 0 10 -1 0
2 34 0 7 0 10 -1 0
2 8 0 34 0 10 -1 1
2 30 0 7 0 10 -1 1
2 8 0 34 0 21 -1 0
2 30 0 7 0 21 -1 0
2 8 0 30 0 21 -1 1
2 34 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 t z2
0
8
2 3 0 30 0 10 -1 0
2 34 0 4 0 10 -1 0
2 4 0 30 0 10 -1 1
2 34 0 3 0 10 -1 1
2 4 0 30 0 21 -1 0
2 34 0 3 0 21 -1 0
2 3 0 30 0 21 -1 1
2 34 0 4 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 f z2
0
8
2 18 0 30 0 10 -1 0
2 34 0 6 0 10 -1 0
2 6 0 30 0 10 -1 1
2 34 0 18 0 10 -1 1
2 6 0 30 0 21 -1 0
2 34 0 18 0 21 -1 0
2 18 0 30 0 21 -1 1
2 34 0 6 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp1 z2
0
8
2 30 0 23 0 10 -1 0
2 34 0 14 0 10 -1 0
2 14 0 30 0 10 -1 1
2 34 0 23 0 10 -1 1
2 14 0 30 0 21 -1 0
2 34 0 23 0 21 -1 0
2 30 0 23 0 21 -1 1
2 34 0 14 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 tmp2 z2
0
8
2 32 0 30 0 10 -1 0
2 34 0 15 0 10 -1 0
2 30 0 15 0 10 -1 1
2 32 0 34 0 10 -1 1
2 30 0 15 0 21 -1 0
2 32 0 34 0 21 -1 0
2 32 0 30 0 21 -1 1
2 34 0 15 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 x1 z2
0
8
2 11 0 30 0 10 -1 0
2 34 0 20 0 10 -1 0
2 20 0 30 0 10 -1 1
2 34 0 11 0 10 -1 1
2 20 0 30 0 21 -1 0
2 34 0 11 0 21 -1 0
2 11 0 30 0 21 -1 1
2 34 0 20 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 y1 z2
0
8
2 9 0 30 0 10 -1 0
2 34 0 35 0 10 -1 0
2 9 0 34 0 10 -1 1
2 35 0 30 0 10 -1 1
2 9 0 34 0 21 -1 0
2 35 0 30 0 21 -1 0
2 9 0 30 0 21 -1 1
2 34 0 35 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 r1 z2
0
8
2 27 0 30 0 10 -1 0
2 34 0 19 0 10 -1 0
2 19 0 30 0 10 -1 1
2 34 0 27 0 10 -1 1
2 19 0 30 0 21 -1 0
2 34 0 27 0 21 -1 0
2 27 0 30 0 21 -1 1
2 34 0 19 0 21 -1 1
0
end_operator
begin_operator
xor-gate r2 z1 z2
0
8
2 8 0 30 0 10 -1 0
2 34 0 7 0 10 -1 0
2 8 0 34 0 10 -1 1
2 30 0 7 0 10 -1 1
2 8 0 34 0 21 -1 0
2 30 0 7 0 21 -1 0
2 8 0 30 0 21 -1 1
2 34 0 7 0 21 -1 1
0
end_operator
begin_operator
xor-gate t z2 f
0
8
2 4 0 21 0 6 -1 0
2 10 0 3 0 6 -1 0
2 3 0 21 0 6 -1 1
2 10 0 4 0 6 -1 1
2 3 0 21 0 18 -1 0
2 10 0 4 0 18 -1 0
2 4 0 21 0 18 -1 1
2 10 0 3 0 18 -1 1
0
end_operator
begin_operator
xor-gate t z2 tmp1
0
8
2 4 0 21 0 14 -1 0
2 10 0 3 0 14 -1 0
2 3 0 21 0 14 -1 1
2 10 0 4 0 14 -1 1
2 3 0 21 0 23 -1 0
2 10 0 4 0 23 -1 0
2 4 0 21 0 23 -1 1
2 10 0 3 0 23 -1 1
0
end_operator
begin_operator
xor-gate t z2 tmp2
0
8
2 4 0 21 0 15 -1 0
2 10 0 3 0 15 -1 0
2 3 0 21 0 15 -1 1
2 10 0 4 0 15 -1 1
2 3 0 21 0 32 -1 0
2 10 0 4 0 32 -1 0
2 4 0 21 0 32 -1 1
2 10 0 3 0 32 -1 1
0
end_operator
begin_operator
xor-gate t z2 r1
0
8
2 4 0 21 0 19 -1 0
2 10 0 3 0 19 -1 0
2 3 0 21 0 19 -1 1
2 10 0 4 0 19 -1 1
2 3 0 21 0 27 -1 0
2 10 0 4 0 27 -1 0
2 4 0 21 0 27 -1 1
2 10 0 3 0 27 -1 1
0
end_operator
begin_operator
xor-gate t z2 z1
0
8
2 4 0 21 0 7 -1 0
2 10 0 3 0 7 -1 0
2 3 0 21 0 7 -1 1
2 10 0 4 0 7 -1 1
2 3 0 21 0 8 -1 0
2 10 0 4 0 8 -1 0
2 4 0 21 0 8 -1 1
2 10 0 3 0 8 -1 1
0
end_operator
begin_operator
xor-gate t z2 r2
0
8
2 4 0 21 0 30 -1 0
2 10 0 3 0 30 -1 0
2 3 0 21 0 30 -1 1
2 10 0 4 0 30 -1 1
2 3 0 21 0 34 -1 0
2 10 0 4 0 34 -1 0
2 4 0 21 0 34 -1 1
2 10 0 3 0 34 -1 1
0
end_operator
begin_operator
xor-gate f z2 t
0
8
2 10 0 6 0 3 -1 0
2 18 0 21 0 3 -1 0
2 18 0 10 0 3 -1 1
2 21 0 6 0 3 -1 1
2 18 0 10 0 4 -1 0
2 21 0 6 0 4 -1 0
2 10 0 6 0 4 -1 1
2 18 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate f z2 tmp1
0
8
2 18 0 10 0 14 -1 0
2 21 0 6 0 14 -1 0
2 10 0 6 0 14 -1 1
2 18 0 21 0 14 -1 1
2 10 0 6 0 23 -1 0
2 18 0 21 0 23 -1 0
2 18 0 10 0 23 -1 1
2 21 0 6 0 23 -1 1
0
end_operator
begin_operator
xor-gate f z2 tmp2
0
8
2 18 0 10 0 15 -1 0
2 21 0 6 0 15 -1 0
2 10 0 6 0 15 -1 1
2 18 0 21 0 15 -1 1
2 10 0 6 0 32 -1 0
2 18 0 21 0 32 -1 0
2 18 0 10 0 32 -1 1
2 21 0 6 0 32 -1 1
0
end_operator
begin_operator
xor-gate f z2 r1
0
8
2 18 0 10 0 19 -1 0
2 21 0 6 0 19 -1 0
2 10 0 6 0 19 -1 1
2 18 0 21 0 19 -1 1
2 10 0 6 0 27 -1 0
2 18 0 21 0 27 -1 0
2 18 0 10 0 27 -1 1
2 21 0 6 0 27 -1 1
0
end_operator
begin_operator
xor-gate f z2 z1
0
8
2 18 0 10 0 7 -1 0
2 21 0 6 0 7 -1 0
2 10 0 6 0 7 -1 1
2 18 0 21 0 7 -1 1
2 10 0 6 0 8 -1 0
2 18 0 21 0 8 -1 0
2 18 0 10 0 8 -1 1
2 21 0 6 0 8 -1 1
0
end_operator
begin_operator
xor-gate f z2 r2
0
8
2 18 0 10 0 30 -1 0
2 21 0 6 0 30 -1 0
2 10 0 6 0 30 -1 1
2 18 0 21 0 30 -1 1
2 10 0 6 0 34 -1 0
2 18 0 21 0 34 -1 0
2 18 0 10 0 34 -1 1
2 21 0 6 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z2 t
0
8
2 10 0 14 0 3 -1 0
2 21 0 23 0 3 -1 0
2 10 0 23 0 3 -1 1
2 21 0 14 0 3 -1 1
2 10 0 23 0 4 -1 0
2 21 0 14 0 4 -1 0
2 10 0 14 0 4 -1 1
2 21 0 23 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z2 f
0
8
2 10 0 23 0 6 -1 0
2 21 0 14 0 6 -1 0
2 10 0 14 0 6 -1 1
2 21 0 23 0 6 -1 1
2 10 0 14 0 18 -1 0
2 21 0 23 0 18 -1 0
2 10 0 23 0 18 -1 1
2 21 0 14 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z2 tmp2
0
8
2 10 0 23 0 15 -1 0
2 21 0 14 0 15 -1 0
2 10 0 14 0 15 -1 1
2 21 0 23 0 15 -1 1
2 10 0 14 0 32 -1 0
2 21 0 23 0 32 -1 0
2 10 0 23 0 32 -1 1
2 21 0 14 0 32 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z2 r1
0
8
2 10 0 23 0 19 -1 0
2 21 0 14 0 19 -1 0
2 10 0 14 0 19 -1 1
2 21 0 23 0 19 -1 1
2 10 0 14 0 27 -1 0
2 21 0 23 0 27 -1 0
2 10 0 23 0 27 -1 1
2 21 0 14 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z2 z1
0
8
2 10 0 23 0 7 -1 0
2 21 0 14 0 7 -1 0
2 10 0 14 0 7 -1 1
2 21 0 23 0 7 -1 1
2 10 0 14 0 8 -1 0
2 21 0 23 0 8 -1 0
2 10 0 23 0 8 -1 1
2 21 0 14 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp1 z2 r2
0
8
2 10 0 23 0 30 -1 0
2 21 0 14 0 30 -1 0
2 10 0 14 0 30 -1 1
2 21 0 23 0 30 -1 1
2 10 0 14 0 34 -1 0
2 21 0 23 0 34 -1 0
2 10 0 23 0 34 -1 1
2 21 0 14 0 34 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z2 t
0
8
2 10 0 15 0 3 -1 0
2 32 0 21 0 3 -1 0
2 21 0 15 0 3 -1 1
2 32 0 10 0 3 -1 1
2 21 0 15 0 4 -1 0
2 32 0 10 0 4 -1 0
2 10 0 15 0 4 -1 1
2 32 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z2 f
0
8
2 21 0 15 0 6 -1 0
2 32 0 10 0 6 -1 0
2 10 0 15 0 6 -1 1
2 32 0 21 0 6 -1 1
2 10 0 15 0 18 -1 0
2 32 0 21 0 18 -1 0
2 21 0 15 0 18 -1 1
2 32 0 10 0 18 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z2 tmp1
0
8
2 21 0 15 0 14 -1 0
2 32 0 10 0 14 -1 0
2 10 0 15 0 14 -1 1
2 32 0 21 0 14 -1 1
2 10 0 15 0 23 -1 0
2 32 0 21 0 23 -1 0
2 21 0 15 0 23 -1 1
2 32 0 10 0 23 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z2 r1
0
8
2 21 0 15 0 19 -1 0
2 32 0 10 0 19 -1 0
2 10 0 15 0 19 -1 1
2 32 0 21 0 19 -1 1
2 10 0 15 0 27 -1 0
2 32 0 21 0 27 -1 0
2 21 0 15 0 27 -1 1
2 32 0 10 0 27 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z2 z1
0
8
2 21 0 15 0 7 -1 0
2 32 0 10 0 7 -1 0
2 10 0 15 0 7 -1 1
2 32 0 21 0 7 -1 1
2 10 0 15 0 8 -1 0
2 32 0 21 0 8 -1 0
2 21 0 15 0 8 -1 1
2 32 0 10 0 8 -1 1
0
end_operator
begin_operator
xor-gate tmp2 z2 r2
0
8
2 21 0 15 0 30 -1 0
2 32 0 10 0 30 -1 0
2 10 0 15 0 30 -1 1
2 32 0 21 0 30 -1 1
2 10 0 15 0 34 -1 0
2 32 0 21 0 34 -1 0
2 21 0 15 0 34 -1 1
2 32 0 10 0 34 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 t
0
8
2 10 0 20 0 3 -1 0
2 11 0 21 0 3 -1 0
2 10 0 11 0 3 -1 1
2 20 0 21 0 3 -1 1
2 10 0 11 0 4 -1 0
2 20 0 21 0 4 -1 0
2 10 0 20 0 4 -1 1
2 11 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 f
0
8
2 10 0 11 0 6 -1 0
2 20 0 21 0 6 -1 0
2 10 0 20 0 6 -1 1
2 11 0 21 0 6 -1 1
2 10 0 20 0 18 -1 0
2 11 0 21 0 18 -1 0
2 10 0 11 0 18 -1 1
2 20 0 21 0 18 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 tmp1
0
8
2 10 0 11 0 14 -1 0
2 20 0 21 0 14 -1 0
2 10 0 20 0 14 -1 1
2 11 0 21 0 14 -1 1
2 10 0 20 0 23 -1 0
2 11 0 21 0 23 -1 0
2 10 0 11 0 23 -1 1
2 20 0 21 0 23 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 tmp2
0
8
2 10 0 11 0 15 -1 0
2 20 0 21 0 15 -1 0
2 10 0 20 0 15 -1 1
2 11 0 21 0 15 -1 1
2 10 0 20 0 32 -1 0
2 11 0 21 0 32 -1 0
2 10 0 11 0 32 -1 1
2 20 0 21 0 32 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 r1
0
8
2 10 0 11 0 19 -1 0
2 20 0 21 0 19 -1 0
2 10 0 20 0 19 -1 1
2 11 0 21 0 19 -1 1
2 10 0 20 0 27 -1 0
2 11 0 21 0 27 -1 0
2 10 0 11 0 27 -1 1
2 20 0 21 0 27 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 z1
0
8
2 10 0 11 0 7 -1 0
2 20 0 21 0 7 -1 0
2 10 0 20 0 7 -1 1
2 11 0 21 0 7 -1 1
2 10 0 20 0 8 -1 0
2 11 0 21 0 8 -1 0
2 10 0 11 0 8 -1 1
2 20 0 21 0 8 -1 1
0
end_operator
begin_operator
xor-gate x1 z2 r2
0
8
2 10 0 11 0 30 -1 0
2 20 0 21 0 30 -1 0
2 10 0 20 0 30 -1 1
2 11 0 21 0 30 -1 1
2 10 0 20 0 34 -1 0
2 11 0 21 0 34 -1 0
2 10 0 11 0 34 -1 1
2 20 0 21 0 34 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 t
0
8
2 9 0 21 0 3 -1 0
2 10 0 35 0 3 -1 0
2 9 0 10 0 3 -1 1
2 35 0 21 0 3 -1 1
2 9 0 10 0 4 -1 0
2 35 0 21 0 4 -1 0
2 9 0 21 0 4 -1 1
2 10 0 35 0 4 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 f
0
8
2 9 0 10 0 6 -1 0
2 35 0 21 0 6 -1 0
2 9 0 21 0 6 -1 1
2 10 0 35 0 6 -1 1
2 9 0 21 0 18 -1 0
2 10 0 35 0 18 -1 0
2 9 0 10 0 18 -1 1
2 35 0 21 0 18 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 tmp1
0
8
2 9 0 10 0 14 -1 0
2 35 0 21 0 14 -1 0
2 9 0 21 0 14 -1 1
2 10 0 35 0 14 -1 1
2 9 0 21 0 23 -1 0
2 10 0 35 0 23 -1 0
2 9 0 10 0 23 -1 1
2 35 0 21 0 23 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 tmp2
0
8
2 9 0 10 0 15 -1 0
2 35 0 21 0 15 -1 0
2 9 0 21 0 15 -1 1
2 10 0 35 0 15 -1 1
2 9 0 21 0 32 -1 0
2 10 0 35 0 32 -1 0
2 9 0 10 0 32 -1 1
2 35 0 21 0 32 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 r1
0
8
2 9 0 10 0 19 -1 0
2 35 0 21 0 19 -1 0
2 9 0 21 0 19 -1 1
2 10 0 35 0 19 -1 1
2 9 0 21 0 27 -1 0
2 10 0 35 0 27 -1 0
2 9 0 10 0 27 -1 1
2 35 0 21 0 27 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 z1
0
8
2 9 0 10 0 7 -1 0
2 35 0 21 0 7 -1 0
2 9 0 21 0 7 -1 1
2 10 0 35 0 7 -1 1
2 9 0 21 0 8 -1 0
2 10 0 35 0 8 -1 0
2 9 0 10 0 8 -1 1
2 35 0 21 0 8 -1 1
0
end_operator
begin_operator
xor-gate y1 z2 r2
0
8
2 9 0 10 0 30 -1 0
2 35 0 21 0 30 -1 0
2 9 0 21 0 30 -1 1
2 10 0 35 0 30 -1 1
2 9 0 21 0 34 -1 0
2 10 0 35 0 34 -1 0
2 9 0 10 0 34 -1 1
2 35 0 21 0 34 -1 1
0
end_operator
begin_operator
xor-gate r1 z2 t
0
8
2 10 0 19 0 3 -1 0
2 27 0 21 0 3 -1 0
2 10 0 27 0 3 -1 1
2 19 0 21 0 3 -1 1
2 10 0 27 0 4 -1 0
2 19 0 21 0 4 -1 0
2 10 0 19 0 4 -1 1
2 27 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate r1 z2 f
0
8
2 10 0 27 0 6 -1 0
2 19 0 21 0 6 -1 0
2 10 0 19 0 6 -1 1
2 27 0 21 0 6 -1 1
2 10 0 19 0 18 -1 0
2 27 0 21 0 18 -1 0
2 10 0 27 0 18 -1 1
2 19 0 21 0 18 -1 1
0
end_operator
begin_operator
xor-gate r1 z2 tmp1
0
8
2 10 0 27 0 14 -1 0
2 19 0 21 0 14 -1 0
2 10 0 19 0 14 -1 1
2 27 0 21 0 14 -1 1
2 10 0 19 0 23 -1 0
2 27 0 21 0 23 -1 0
2 10 0 27 0 23 -1 1
2 19 0 21 0 23 -1 1
0
end_operator
begin_operator
xor-gate r1 z2 tmp2
0
8
2 10 0 27 0 15 -1 0
2 19 0 21 0 15 -1 0
2 10 0 19 0 15 -1 1
2 27 0 21 0 15 -1 1
2 10 0 19 0 32 -1 0
2 27 0 21 0 32 -1 0
2 10 0 27 0 32 -1 1
2 19 0 21 0 32 -1 1
0
end_operator
begin_operator
xor-gate r1 z2 z1
0
8
2 10 0 27 0 7 -1 0
2 19 0 21 0 7 -1 0
2 10 0 19 0 7 -1 1
2 27 0 21 0 7 -1 1
2 10 0 19 0 8 -1 0
2 27 0 21 0 8 -1 0
2 10 0 27 0 8 -1 1
2 19 0 21 0 8 -1 1
0
end_operator
begin_operator
xor-gate r1 z2 r2
0
8
2 10 0 27 0 30 -1 0
2 19 0 21 0 30 -1 0
2 10 0 19 0 30 -1 1
2 27 0 21 0 30 -1 1
2 10 0 19 0 34 -1 0
2 27 0 21 0 34 -1 0
2 10 0 27 0 34 -1 1
2 19 0 21 0 34 -1 1
0
end_operator
begin_operator
xor-gate z1 z2 t
0
8
2 8 0 21 0 3 -1 0
2 10 0 7 0 3 -1 0
2 8 0 10 0 3 -1 1
2 21 0 7 0 3 -1 1
2 8 0 10 0 4 -1 0
2 21 0 7 0 4 -1 0
2 8 0 21 0 4 -1 1
2 10 0 7 0 4 -1 1
0
end_operator
begin_operator
xor-gate z1 z2 f
0
8
2 8 0 10 0 6 -1 0
2 21 0 7 0 6 -1 0
2 8 0 21 0 6 -1 1
2 10 0 7 0 6 -1 1
2 8 0 21 0 18 -1 0
2 10 0 7 0 18 -1 0
2 8 0 10 0 18 -1 1
2 21 0 7 0 18 -1 1
0
end_operator
begin_operator
xor-gate z1 z2 tmp1
0
8
2 8 0 10 0 14 -1 0
2 21 0 7 0 14 -1 0
2 8 0 21 0 14 -1 1
2 10 0 7 0 14 -1 1
2 8 0 21 0 23 -1 0
2 10 0 7 0 23 -1 0
2 8 0 10 0 23 -1 1
2 21 0 7 0 23 -1 1
0
end_operator
begin_operator
xor-gate z1 z2 tmp2
0
8
2 8 0 10 0 15 -1 0
2 21 0 7 0 15 -1 0
2 8 0 21 0 15 -1 1
2 10 0 7 0 15 -1 1
2 8 0 21 0 32 -1 0
2 10 0 7 0 32 -1 0
2 8 0 10 0 32 -1 1
2 21 0 7 0 32 -1 1
0
end_operator
begin_operator
xor-gate z1 z2 r1
0
8
2 8 0 10 0 19 -1 0
2 21 0 7 0 19 -1 0
2 8 0 21 0 19 -1 1
2 10 0 7 0 19 -1 1
2 8 0 21 0 27 -1 0
2 10 0 7 0 27 -1 0
2 8 0 10 0 27 -1 1
2 21 0 7 0 27 -1 1
0
end_operator
begin_operator
xor-gate z1 z2 r2
0
8
2 8 0 10 0 30 -1 0
2 21 0 7 0 30 -1 0
2 8 0 21 0 30 -1 1
2 10 0 7 0 30 -1 1
2 8 0 21 0 34 -1 0
2 10 0 7 0 34 -1 0
2 8 0 10 0 34 -1 1
2 21 0 7 0 34 -1 1
0
end_operator
begin_operator
xor-gate r2 z2 t
0
8
2 10 0 30 0 3 -1 0
2 34 0 21 0 3 -1 0
2 21 0 30 0 3 -1 1
2 34 0 10 0 3 -1 1
2 21 0 30 0 4 -1 0
2 34 0 10 0 4 -1 0
2 10 0 30 0 4 -1 1
2 34 0 21 0 4 -1 1
0
end_operator
begin_operator
xor-gate r2 z2 f
0
8
2 21 0 30 0 6 -1 0
2 34 0 10 0 6 -1 0
2 10 0 30 0 6 -1 1
2 34 0 21 0 6 -1 1
2 10 0 30 0 18 -1 0
2 34 0 21 0 18 -1 0
2 21 0 30 0 18 -1 1
2 34 0 10 0 18 -1 1
0
end_operator
begin_operator
xor-gate r2 z2 tmp1
0
8
2 21 0 30 0 14 -1 0
2 34 0 10 0 14 -1 0
2 10 0 30 0 14 -1 1
2 34 0 21 0 14 -1 1
2 10 0 30 0 23 -1 0
2 34 0 21 0 23 -1 0
2 21 0 30 0 23 -1 1
2 34 0 10 0 23 -1 1
0
end_operator
begin_operator
xor-gate r2 z2 tmp2
0
8
2 21 0 30 0 15 -1 0
2 34 0 10 0 15 -1 0
2 10 0 30 0 15 -1 1
2 34 0 21 0 15 -1 1
2 10 0 30 0 32 -1 0
2 34 0 21 0 32 -1 0
2 21 0 30 0 32 -1 1
2 34 0 10 0 32 -1 1
0
end_operator
begin_operator
xor-gate r2 z2 r1
0
8
2 21 0 30 0 19 -1 0
2 34 0 10 0 19 -1 0
2 10 0 30 0 19 -1 1
2 34 0 21 0 19 -1 1
2 10 0 30 0 27 -1 0
2 34 0 21 0 27 -1 0
2 21 0 30 0 27 -1 1
2 34 0 10 0 27 -1 1
0
end_operator
begin_operator
xor-gate r2 z2 z1
0
8
2 21 0 30 0 7 -1 0
2 34 0 10 0 7 -1 0
2 10 0 30 0 7 -1 1
2 34 0 21 0 7 -1 1
2 10 0 30 0 8 -1 0
2 34 0 21 0 8 -1 0
2 21 0 30 0 8 -1 1
2 34 0 10 0 8 -1 1
0
end_operator
begin_operator
not-gate z2 t
0
4
1 21 0 3 -1 0
1 10 0 3 -1 1
1 10 0 4 -1 0
1 21 0 4 -1 1
0
end_operator
begin_operator
not-gate z2 f
0
4
1 10 0 6 -1 0
1 21 0 6 -1 1
1 21 0 18 -1 0
1 10 0 18 -1 1
0
end_operator
begin_operator
not-gate z2 tmp1
0
4
1 10 0 14 -1 0
1 21 0 14 -1 1
1 21 0 23 -1 0
1 10 0 23 -1 1
0
end_operator
begin_operator
not-gate z2 tmp2
0
4
1 10 0 15 -1 0
1 21 0 15 -1 1
1 21 0 32 -1 0
1 10 0 32 -1 1
0
end_operator
begin_operator
not-gate z2 r1
0
4
1 10 0 19 -1 0
1 21 0 19 -1 1
1 21 0 27 -1 0
1 10 0 27 -1 1
0
end_operator
begin_operator
not-gate z2 z1
0
4
1 10 0 7 -1 0
1 21 0 7 -1 1
1 21 0 8 -1 0
1 10 0 8 -1 1
0
end_operator
begin_operator
not-gate z2 r2
0
4
1 10 0 30 -1 0
1 21 0 30 -1 1
1 21 0 34 -1 0
1 10 0 34 -1 1
0
end_operator
begin_operator
not-gate t z2
0
4
1 4 0 10 -1 0
1 3 0 10 -1 1
1 3 0 21 -1 0
1 4 0 21 -1 1
0
end_operator
begin_operator
not-gate f z2
0
4
1 6 0 10 -1 0
1 18 0 10 -1 1
1 18 0 21 -1 0
1 6 0 21 -1 1
0
end_operator
begin_operator
not-gate tmp1 z2
0
4
1 14 0 10 -1 0
1 23 0 10 -1 1
1 23 0 21 -1 0
1 14 0 21 -1 1
0
end_operator
begin_operator
not-gate tmp2 z2
0
4
1 15 0 10 -1 0
1 32 0 10 -1 1
1 32 0 21 -1 0
1 15 0 21 -1 1
0
end_operator
begin_operator
not-gate x1 z2
0
4
1 20 0 10 -1 0
1 11 0 10 -1 1
1 11 0 21 -1 0
1 20 0 21 -1 1
0
end_operator
begin_operator
not-gate y1 z2
0
4
1 35 0 10 -1 0
1 9 0 10 -1 1
1 9 0 21 -1 0
1 35 0 21 -1 1
0
end_operator
begin_operator
not-gate r1 z2
0
4
1 19 0 10 -1 0
1 27 0 10 -1 1
1 27 0 21 -1 0
1 19 0 21 -1 1
0
end_operator
begin_operator
not-gate z1 z2
0
4
1 7 0 10 -1 0
1 8 0 10 -1 1
1 8 0 21 -1 0
1 7 0 21 -1 1
0
end_operator
begin_operator
not-gate r2 z2
0
4
1 30 0 10 -1 0
1 34 0 10 -1 1
1 34 0 21 -1 0
1 30 0 21 -1 1
0
end_operator
54
begin_rule
1
20 0
5 1 0
end_rule
begin_rule
1
9 0
5 1 0
end_rule
begin_rule
1
27 0
5 1 0
end_rule
begin_rule
1
8 0
5 1 0
end_rule
begin_rule
1
30 0
29 1 0
end_rule
begin_rule
1
11 0
29 1 0
end_rule
begin_rule
1
27 0
29 1 0
end_rule
begin_rule
1
7 0
0 1 0
end_rule
begin_rule
1
20 0
0 1 0
end_rule
begin_rule
1
35 0
0 1 0
end_rule
begin_rule
1
27 0
0 1 0
end_rule
begin_rule
1
21 0
12 1 0
end_rule
begin_rule
1
34 0
12 1 0
end_rule
begin_rule
1
19 0
13 1 0
end_rule
begin_rule
1
35 0
13 1 0
end_rule
begin_rule
1
34 0
13 1 0
end_rule
begin_rule
1
30 0
2 1 0
end_rule
begin_rule
1
9 0
2 1 0
end_rule
begin_rule
1
27 0
2 1 0
end_rule
begin_rule
1
19 0
17 1 0
end_rule
begin_rule
1
7 0
17 1 0
end_rule
begin_rule
1
35 0
17 1 0
end_rule
begin_rule
1
11 0
17 1 0
end_rule
begin_rule
1
30 0
24 1 0
end_rule
begin_rule
1
10 0
24 1 0
end_rule
begin_rule
1
19 0
22 1 0
end_rule
begin_rule
1
11 0
22 1 0
end_rule
begin_rule
1
9 0
22 1 0
end_rule
begin_rule
1
8 0
22 1 0
end_rule
begin_rule
1
19 0
31 1 0
end_rule
begin_rule
1
20 0
31 1 0
end_rule
begin_rule
1
35 0
31 1 0
end_rule
begin_rule
1
8 0
31 1 0
end_rule
begin_rule
1
20 0
16 1 0
end_rule
begin_rule
1
35 0
16 1 0
end_rule
begin_rule
1
34 0
16 1 0
end_rule
begin_rule
1
7 0
1 1 0
end_rule
begin_rule
1
11 0
1 1 0
end_rule
begin_rule
1
9 0
1 1 0
end_rule
begin_rule
1
27 0
1 1 0
end_rule
begin_rule
1
30 0
33 1 0
end_rule
begin_rule
1
11 0
33 1 0
end_rule
begin_rule
1
9 0
33 1 0
end_rule
begin_rule
1
19 0
26 1 0
end_rule
begin_rule
1
20 0
26 1 0
end_rule
begin_rule
1
34 0
26 1 0
end_rule
begin_rule
1
35 0
25 1 0
end_rule
begin_rule
1
11 0
25 1 0
end_rule
begin_rule
1
27 0
25 1 0
end_rule
begin_rule
1
8 0
25 1 0
end_rule
begin_rule
1
19 0
28 1 0
end_rule
begin_rule
1
7 0
28 1 0
end_rule
begin_rule
1
20 0
28 1 0
end_rule
begin_rule
1
9 0
28 1 0
end_rule
