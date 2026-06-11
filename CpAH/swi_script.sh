#!/bin/sh

#echo 
#echo Creating dp.pddl file from $1 and $2
#cat $1 $2 > dp.pddl

#./cpa.pddl2pl dp.pddl
./cpa.pddl2pl $1

echo Performing statistical analysis ...

cat mult5zz.pl pddl2pl.pl > new.pl
prolog -L128m -G128m -f new.pl -g main,halt. > trash 

echo Running CPA(H) ...
./CPAH theory_names > temp

sed -e 's/cpa_//g' temp > plan-result

cat plan-result 

