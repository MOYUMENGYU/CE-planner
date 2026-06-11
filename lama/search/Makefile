HEADERS = heuristic.h ff_heuristic.h wa_star_search.h \
	  domain_transition_graph.h globals.h \
          operator.h state.h successor_generator.h \
	  best_first_search.h axioms.h \
	  search_engine.h open_list.h closed_list.h \
	  landmarks_graph.h \
	  landmarks_graph_rpg_sasp.h \
	  landmarks_count_heuristic.h \
	  counter.h \
	  z3_counter.h \
	  smt_counter.h \
	  cnf_types.h \
	  cnf_logger.h \
	  sat_var_manager.h \
	  cnf_builder.h \
	  kissat_counter.h \
	  minisat_counter.h \
	  glucose_counter.h \
	  cadical_counter.h \
	  counter_cnf.h \
	  cnf_preprocessor.h \
	  cegis_framework.h \


SOURCES = planner.cc $(HEADERS:%.h=%.cc)
OBJECTS = $(SOURCES:%.cc=%.o)
PROFILE_OBJECTS = $(SOURCES:%.cc=%.profile.o)
RELEASE_OBJECTS = $(SOURCES:%.cc=%.release.o)

CC = g++
DEPEND = g++ -MM
CCOPT =      -Wall -W -Wno-sign-compare  -pedantic  -DNDEBUG -O0 -Wno-deprecated

# search debug 调试
# RELEASEOPT = -Wall -W -Wno-sign-compare  -pedantic  -DNDEBUG -O0 -m64 -Wno-deprecated

# release
RELEASEOPT = -Wall -W -Wno-sign-compare -pedantic -DNDEBUG -O3 -m64 -Wno-deprecated

LINKOPT = -lz3
RELEASELINKOPT = -lz3 -lm

# =========================
# Kissat 本地静态链接配置
# Kissat 根目录建议放在:
#   gc_counter/third_party/kissat
# 当前 Makefile 位于:
#   gc_counter/lama/search
# 所以相对路径用 ../../third_party/kissat
# =========================
KISSAT_ROOT = ../../third_party/kissat
KISSAT_BUILD = $(KISSAT_ROOT)/build
KISSAT_INC = -I$(KISSAT_ROOT)/src
KISSAT_LIB = $(KISSAT_BUILD)/libkissat.a

ENABLE_KISSAT ?= 1

ifeq ($(ENABLE_KISSAT),1)
# 编译时打开 Kissat 后端，并让编译器能找到 kissat.h
CCOPT += -DUSE_KISSAT $(KISSAT_INC)
RELEASEOPT += -DUSE_KISSAT $(KISSAT_INC)
# 链接时加入 Kissat 静态库和数学库
LINKOPT += $(KISSAT_LIB) -lm
RELEASELINKOPT += $(KISSAT_LIB)
endif

# =========================
# MiniSAT 本地静态链接配置
# MiniSAT 根目录建议放在:
#   gc_counter/third_party/minisat
# 当前 Makefile 位于:
#   gc_counter/lama/search
# 所以相对路径用 ../../third_party/minisat
# =========================
ENABLE_MINISAT ?= 1

MINISAT_ROOT = ../../third_party/minisat
MINISAT_INC = -I$(MINISAT_ROOT)
MINISAT_LIB = $(MINISAT_ROOT)/build/release/lib/libminisat.a

ifeq ($(ENABLE_MINISAT),1)
CCOPT += -DUSE_MINISAT $(MINISAT_INC)
RELEASEOPT += -DUSE_MINISAT $(MINISAT_INC)
LINKOPT += $(MINISAT_LIB)
RELEASELINKOPT += $(MINISAT_LIB)
endif


# =========================
# Glucose 本地静态链接配置
# 默认关闭；启用示例：
#   make ENABLE_GLUCOSE=1 GLUCOSE_ROOT=../../third_party/glucose
# 若库路径不同，可直接覆写 GLUCOSE_INC / GLUCOSE_LIB
# =========================
ENABLE_GLUCOSE ?= 1
GLUCOSE_ROOT ?= ../../third_party/glucose
GLUCOSE_INC ?= -I$(GLUCOSE_ROOT)
GLUCOSE_LIB ?= $(GLUCOSE_ROOT)/build/libglucose.a

ifeq ($(ENABLE_GLUCOSE),1)
CCOPT += -DUSE_GLUCOSE $(GLUCOSE_INC)
RELEASEOPT += -DUSE_GLUCOSE $(GLUCOSE_INC)
LINKOPT += $(GLUCOSE_LIB)
RELEASELINKOPT += $(GLUCOSE_LIB)
endif

# =========================
# CaDiCaL 本地静态链接配置
# 默认关闭；启用示例：
#   make ENABLE_CADICAL=1 CADICAL_ROOT=../../third_party/cadical
# 若库路径不同，可直接覆写 CADICAL_INC / CADICAL_LIB
# =========================
ENABLE_CADICAL ?= 0
CADICAL_ROOT ?= ../../third_party/cadical
CADICAL_INC ?= -I$(CADICAL_ROOT) -I$(CADICAL_ROOT)/src -I$(CADICAL_ROOT)/build
CADICAL_LIB ?= $(CADICAL_ROOT)/build/libcadical.a

ifeq ($(ENABLE_CADICAL),1)
CCOPT += -DUSE_CADICAL $(CADICAL_INC)
RELEASEOPT += -DUSE_CADICAL $(CADICAL_INC)
LINKOPT += $(CADICAL_LIB)
RELEASELINKOPT += $(CADICAL_LIB)
endif

# =========================
# 可选 SMT 多求解器接入
# 默认全部关闭，不影响现有 Z3 / Kissat / MiniSAT / search / release-search
# 使用方式示例：
#   make ENABLE_SMT_CVC4=1
#   make ENABLE_SMT_MATHSAT5=1
#   make ENABLE_SMT_YICES2=1
# 如需覆盖默认 third_party 路径，也可以直接命令行覆写：
#   make ENABLE_SMT_CVC4=1 CVC4_INC=-I/path/include CVC4_LIB="-L/path/lib -lcvc4"
# =========================

# ---------- CVC4 ----------
ENABLE_SMT_CVC4 ?= 0
CVC4_ROOT ?= ../../third_party/cvc4/install
CVC4_INC ?= -I$(CVC4_ROOT)/include
CVC4_LIB ?= -L$(CVC4_ROOT)/lib -Wl,-rpath,$(abspath $(CVC4_ROOT)/lib) -lcvc4
# CVC4_LIB ?= -L$(CVC4_ROOT)/lib -lcvc4
ifeq ($(ENABLE_SMT_CVC4),1)
CCOPT += -DUSE_SMT_CVC4 $(CVC4_INC)
RELEASEOPT += -DUSE_SMT_CVC4 $(CVC4_INC)
LINKOPT += $(CVC4_LIB)
RELEASELINKOPT += $(CVC4_LIB)
endif

# ---------- MathSAT5 ----------
ENABLE_SMT_MATHSAT5 ?= 1
MATHSAT5_VER ?= mathsat-5.6.16-linux-x86_64
MATHSAT5_ROOT ?= ../../third_party/mathsat5/$(MATHSAT5_VER)
MATHSAT5_INC ?= -I$(MATHSAT5_ROOT)/include
MATHSAT5_LIB ?= $(MATHSAT5_ROOT)/lib/libmathsat.a -lgmpxx -lgmp
ifeq ($(ENABLE_SMT_MATHSAT5),1)
CCOPT += -DUSE_SMT_MATHSAT5 $(MATHSAT5_INC)
RELEASEOPT += -DUSE_SMT_MATHSAT5 $(MATHSAT5_INC)
LINKOPT += $(MATHSAT5_LIB)
RELEASELINKOPT += $(MATHSAT5_LIB)
endif

# ---------- Yices2 ----------
ENABLE_SMT_YICES2 ?= 1
YICES2_ROOT ?= ../../third_party/yices2/install
YICES2_INC ?= -I$(YICES2_ROOT)/include
# YICES2_LIB ?= -L$(YICES2_ROOT)/lib -lyices
YICES2_LIB ?= -L$(YICES2_ROOT)/lib -Wl,-rpath,$(abspath $(YICES2_ROOT)/lib) -lyices
ifeq ($(ENABLE_SMT_YICES2),1)
CCOPT += -DUSE_SMT_YICES2 $(YICES2_INC)
RELEASEOPT += -DUSE_SMT_YICES2 $(YICES2_INC)
LINKOPT += $(YICES2_LIB)
RELEASELINKOPT += $(YICES2_LIB)
endif

## debug, don't optimize
CCOPT += -g3
LINKOPT += -g3


## debug, optimize
# CCOPT += -O3 -g
# LINKOPT += -g

## no debug, optimize a lot
#CCOPT += -O3 -DNDEBUG -march=athlon-xp

PROFOPT = -pg -O0 -DNDEBUG

PROFILE_ARGS = fFxXo fF fFxX fFxXD xX
PROFILE_TASK = driverlog/pfile20

PROFILES = $(PROFILE_ARGS:%=PROFILE-%)

# PROFLINKOPT = -lc_p

vpath %.o obj
# $(CC) $(OBJECTS:%=obj/%) -o search $(LINKOPT)
search: $(OBJECTS)
	$(CC) $(LINKOPT) $(OBJECTS:%=obj/%) -o search


profile-search: $(PROFILE_OBJECTS)
	$(CC) $(LINKOPT) $(PROFLINKOPT) $(PROFOPT) $(PROFILE_OBJECTS:%=obj/%) \
          -o profile-search -lz3

release: release-search 

# release-search: $(RELEASE_OBJECTS)
# 	$(CC) $(RELEASEOPT) $(RELEASE_OBJECTS:%=obj/%) \
# 	  -o release-search -lz3

release-search: $(RELEASE_OBJECTS)
	$(CC) $(RELEASEOPT) $(RELEASE_OBJECTS:%=obj/%) \
	  -o release-search $(RELEASELINKOPT)

PROFILES = $(PROFILE_ARGS:%=PROFILE-%)

$(PROFILES): PROFILE-%: profile-search
	cp ../../results/translate/$(PROFILE_TASK)/all.groups .
	./profile-search $* < ../../results/preprocess/$(PROFILE_TASK)/output
	gprof profile-search | ./cleanup-profile > $@

$(OBJECTS): %.o: %.cc
	$(CC) $(CCOPT) -c $< -o obj/$@ 

$(PROFILE_OBJECTS): %.profile.o: %.cc
	$(CC) $(CCOPT) $(PROFOPT) -c $< -o obj/$@

$(RELEASE_OBJECTS): %.release.o: %.cc
	$(CC) $(RELEASEOPT) -c $< -o obj/$@ 

clean:
	rm -f $(OBJECTS:%=obj/%) $(PROFILE_OBJECTS:%=obj/%) $(RELEASE_OBJECTS:%=obj/%) *~ *.pyc
	rm -f Makefile.depend profile-search gmon.out PROFILE core
	rm -f sas_plan

veryclean: clean
	rm -f search

Makefile.depend: $(SOURCES) $(HEADERS)
	$(DEPEND) $(SOURCES) > Makefile.temp
	sed -e "s/\(.*\)\.o:\(.*\)/\1.profile.o:\2/" Makefile.temp >> Makefile.temp2
	cat Makefile.temp Makefile.temp2 > Makefile.depend
	rm -f Makefile.temp Makefile.temp2

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),veryclean)
-include Makefile.depend
endif
endif

.PHONY: release clean veryclean
