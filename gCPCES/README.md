This is the CPCES repository. CPCES is a conformant planner based on intelligent sampling of the belief state.
It reads in input description of conformant planning problems given as dialect of PDDL. The initial state is represented as a formula
such that each model is a possible initial state and the planner is required to find a plan which is conformant (works for any possible initial state). 

The way CPCES works is explained in the following papers:

A. Grastien, E. Scala: **Intelligent Belief State Sampling for Conformant Planning**, IJCAI 2017

A. Grastien, E. Scala: **Sampling Strategies for Conformant Planning**, ICAPS 2018


##Compilation and Installation

To compile CPCES you are required to have some external tools and planners. The planner is written in [JAVA 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html). 

Before compiling make sure to have the Java machine installed on your computer. In Ubuntu this can be obtained executing the following commands from the bash:

```
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default
```

CPCES depends on a number of other external libraries, some for the PDDL parsing, other for some standard algorithm on graphs, and some to interface the API:

In particular:

- [Antlr 3.4](http://www.antlr3.org) is used for parsing pddl problems. [Here](http://www.antlr3.org/download/antlr-3.4-complete.jar) the link to the actual library file that needs to be linked
- [Jgraph](http://jgrapht.org). This is for general algorithms on graphs
- [Ojalgo](http://ojalgo.org). The version used is the v40
- [Json Simple](https://github.com/fangyidong/json-simple). This is used to store information of the search space explored.
- [Apache Commons CLI](https://commons.apache.org/proper/commons-cli/). This is used to facilitate parsing
- [Z3](https://github.com/Z3Prover/z3/releases). This is used to test if a candidate plan is valid for each initial state
- [PPMaJaL](https://bitbucket.org/enricode/ppmajal-expressive-pddl-java-library). This is used for handling the PDDL Language and provide facilities for conversion in SMT. The library has been modified recently; the version in this repository (in the libs folder) should work smoothly.

This is all for the compilation. Yet, the planner also needs a PDDL classical planner to solve the incremental compilation of the conformant planning problem. At the moment we support FF and Madagascar whose executables need to be put within the source folder (i.e., /src). You need to get the source and compile it from their websites: [FF](https://fai.cs.uni-saarland.de/hoffmann/ff.html), [Madagascar](https://users.aalto.fi/~rintanj1/satplan.html), but for your convenience we provide the executable (compiled in Ubuntu 17.10) for you in the src folder. The install script will then copy them in the root of this repository so that the planner can find them when it runs.

There are a couple of things that need to be done to run the planner:
1 - Compile Z3 with the JAVA API, and modify your LD_LIBRARY_PATH to include Z3 folder. This is explained [here](https://github.com/Z3Prover/z3/issues/294).
2 - You need to modify some FF global variable to make it work with big instances. This may also require to address issues concerning constants that could be set when building the parser of FF.

To compile it just type ./compile from the CPCES root folder, and then ./install. Those two very simple scripts will create
a script file within this folder that you can execute.

To facilitate the compilation the libraries are already supplied in the libs folder, as well as the FF and the MpC executable are already in the src folder. So you really only need to compile, run and enjoy it ;)

##Usage

To use the solver you need to provide a domain and a problem file. In the domain you have the description of action. In the problem file
the initial state (that here is a belief of possible worlds) and a goal. Both needs to be expressed as first order formulae, where the objects to be used need to be typed and specified in the head of your problem file. For examples of conformant PDDL Problems have a look at the benchmark folder.

This is a typical example of use:

```
./cpces2 -o domain.pddl -f instance.pddl

There are a number of other ways cpces2 can be used. Have a look at the help to find more information about that. In general, you can decide to use another sampling strategy, or another classical planner (default is greedy for the sampling and ff for the planner). Also the planner can be used as a validator by inputting a conformant plan. If that conformant plan is not valid the planner tries to refine it by adding the intial state counterexample that justifies why that plan is not a solution.
 

The planner can also take as input the classical planner to be used through the -planner option. Run the ./cpces command without option to get help info

