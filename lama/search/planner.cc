/*********************************************************************
 * Author: Malte Helmert (helmert@informatik.uni-freiburg.de)
 * (C) Copyright 2003-2004 Malte Helmert
 * Modified by: Silvia Richter (silvia.richter@nicta.com.au),
 *              Matthias Westphal (westpham@informatik.uni-freiburg.de)             
 * (C) Copyright 2008 NICTA and Matthias Westphal
 *
 * This file is part of LAMA.
 *
 * LAMA is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the license, or (at your option) any later version.
 *
 * LAMA is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 *
 *********************************************************************/

#include "best_first_search.h"
#include "wa_star_search.h"
#include "ff_heuristic.h"
#include "globals.h"
#include "operator.h"
#include "landmarks_graph.h"
#include "landmarks_graph_rpg_sasp.h"
#include "landmarks_count_heuristic.h"
#include "counter.h"

#include <memory>
#include <cassert>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
#include <map>
#include <sys/times.h>
#include <climits>
#include <cstdlib>
#include <string.h>
#include "counter_cnf.h"
#include "cnf_logger.h"
#include "cegis_framework.h"
#include "ctime"


using namespace std;

vector<std::pair<int, int>> g_goal_tmp;
void show_action();
bool solve_belief_state(BestFirstSearchEngine* engine);
bool solve_belief_state_ite(BestFirstSearchEngine* subengine);
int save_plan(const vector<const Operator *> &plan, const string& filename, int iteration);


BestFirstSearchEngine *search_subplan(State *init_state, vector<pair<int, int> > subgoal, bool ff_heuristic, bool ff_preferred_operators);

void print_heuristics_used(bool ff_heuristic, bool ff_preferred_operators, 
			   bool landmarks_heuristic, 
			   bool landmarks_heuristic_preferred_operators);

BestFirstSearchEngine *search_subplan(State *init_state, bool ff_heuristic, bool ff_preferred_operators);

string stateToStringmain(state_var s){
    string tmp = "";
    for(int i=0;i<s.vars.size();i++){
        if(s.vars[i]!=(g_variable_domain[i]-1)){
            tmp+=to_string(i);
            tmp+="-";
            tmp+=to_string(s.vars[i]);
            tmp+='.';
        }
    }
    return tmp;
}

/* =========================
 * CNF/Kissat 对拍测试开关
 * 第一阶段：
 * 1) 只在最终 verifier 位置做对拍
 * 2) 不替换原 SMT/Z3 主流程
 * 3) CNF 结果只打印，不参与 planner 决策
 * ========================= */
static bool g_enable_cnf_compare = false;

/* 迭代过程中是否打印每轮反例验证时间。
 * 注意：该开关只控制打印，不影响任何时间统计与累计。 */
static bool g_print_iteration_counterexample_timing = false;

/* 备用开关：后续若要测试初始参考状态生成，再打开 */
static bool g_enable_cnf_compare_initial = true;

/* 简要打印一个状态向量，方便比较 CNF 和 SMT 找到的反例 */
static void dumpStateVectorBrief(const std::vector<int> &vars, const std::string &tag) {
    cout << tag << endl;
    for(int i = 0; i < (int)vars.size(); i++) {
        if(vars[i] != (g_variable_domain[i] - 1)) {
            cout << "  " << g_variable_name[i] << " = " << vars[i] << endl;
        }
    }
}

enum CounterexampleBackend {
    COUNTEREXAMPLE_BACKEND_SMT_Z3 = 0,
    COUNTEREXAMPLE_BACKEND_SMT_CVC4 = 1,
    COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5 = 2,
    COUNTEREXAMPLE_BACKEND_SMT_YICES2 = 3,
    COUNTEREXAMPLE_BACKEND_CNF_KISSAT = 4,
    COUNTEREXAMPLE_BACKEND_CNF_MINISAT = 5,
    COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE = 6,
    COUNTEREXAMPLE_BACKEND_CNF_CADICAL = 7
};

static CounterexampleBackend g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_SMT_Z3;

static bool isSmtCounterexampleBackend(CounterexampleBackend backend) {
    return backend == COUNTEREXAMPLE_BACKEND_SMT_Z3
        || backend == COUNTEREXAMPLE_BACKEND_SMT_CVC4
        || backend == COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5
        || backend == COUNTEREXAMPLE_BACKEND_SMT_YICES2;
}

static CounterexampleBackend counterexampleBackendFromSmtSolverBackend(SMTSolverBackend backend) {
    switch(backend) {
    case SMT_SOLVER_Z3:
        return COUNTEREXAMPLE_BACKEND_SMT_Z3;
    case SMT_SOLVER_CVC4:
        return COUNTEREXAMPLE_BACKEND_SMT_CVC4;
    case SMT_SOLVER_MATHSAT5:
        return COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5;
    case SMT_SOLVER_YICES2:
        return COUNTEREXAMPLE_BACKEND_SMT_YICES2;
    default:
        return COUNTEREXAMPLE_BACKEND_SMT_Z3;
    }
}

static int clockDiffMs(std::clock_t begin_clock, std::clock_t end_clock) {
    return (int)(((double)(end_clock - begin_clock) / CLOCKS_PER_SEC) * 1000.0);
}

struct BackendTimingAggregate {
    long long comparable_total_ms_all;
    long long comparable_total_ms_primary;
    long long comparable_total_ms_compare;
    long long actual_exec_ms_all;
    long long actual_exec_ms_primary;
    long long actual_exec_ms_compare;
    long long build_ms_all;
    long long build_ms_primary;
    long long build_ms_compare;
    int runs_all;
    int runs_primary;
    int runs_compare;
    BackendTimingAggregate()
        : comparable_total_ms_all(0), comparable_total_ms_primary(0), comparable_total_ms_compare(0),
          actual_exec_ms_all(0), actual_exec_ms_primary(0), actual_exec_ms_compare(0),
          build_ms_all(0), build_ms_primary(0), build_ms_compare(0),
          runs_all(0), runs_primary(0), runs_compare(0) {}
};

struct PlanningTimingAggregate {
    long long total_validation_actual_ms_all;
    long long total_validation_actual_ms_primary;
    long long total_cnf_prepare_actual_ms_all;
    long long total_cnf_prepare_actual_ms_primary;
    long long total_program_ms;
    long long total_planning_ms;
    BackendTimingAggregate smt;
    BackendTimingAggregate kissat;
    BackendTimingAggregate minisat;
    BackendTimingAggregate glucose;
    BackendTimingAggregate cadical;
    PlanningTimingAggregate()
        : total_validation_actual_ms_all(0), total_validation_actual_ms_primary(0),
          total_cnf_prepare_actual_ms_all(0), total_cnf_prepare_actual_ms_primary(0),
          total_program_ms(0), total_planning_ms(0), smt(), kissat(), minisat(), glucose(), cadical() {}
};

static PlanningTimingAggregate g_planning_timing_summary;
static std::clock_t g_program_start_clock = 0;
static std::clock_t g_planning_start_clock = 0;
static int g_subplan_cache_hits = 0;
static int g_subplan_cache_misses = 0;

struct CachedSubplanResult {
    bool found;
    vector<const Operator *> plan;
    CachedSubplanResult() : found(false), plan() {}
};

static map<string, CachedSubplanResult> g_subplan_cache;
static const size_t SUBPLAN_CACHE_MAX_ENTRIES = 20000;

struct CounterexampleRunResult {
    CounterexampleBackend backend;
    bool available;
    bool result_valid;
    bool has_counterexample;
    bool sample_valid;
    int build_time_ms;
    int solver_and_extract_time_ms;
    int total_time_ms;
    int variable_count;
    int clause_count;
    std::vector<int> counterexample_state;
    CounterexampleRunResult()
        : backend(COUNTEREXAMPLE_BACKEND_SMT_Z3), available(false), result_valid(false),
          has_counterexample(false), sample_valid(false), build_time_ms(0),
          solver_and_extract_time_ms(0), total_time_ms(0), variable_count(0),
          clause_count(0), counterexample_state() {}
};

static const char *counterexampleBackendName(CounterexampleBackend backend) {
    switch(backend) {
    case COUNTEREXAMPLE_BACKEND_SMT_Z3:
        return "SMT/Z3";
    case COUNTEREXAMPLE_BACKEND_SMT_CVC4:
        return "SMT/CVC4";
    case COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5:
        return "SMT/MathSAT5";
    case COUNTEREXAMPLE_BACKEND_SMT_YICES2:
        return "SMT/Yices2";
    case COUNTEREXAMPLE_BACKEND_CNF_KISSAT:
        return "CNF/Kissat";
    case COUNTEREXAMPLE_BACKEND_CNF_MINISAT:
        return "CNF/MiniSAT";
    case COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE:
        return "CNF/Glucose";
    case COUNTEREXAMPLE_BACKEND_CNF_CADICAL:
        return "CNF/CaDiCaL";
    default:
        return "UNKNOWN";
    }
}

static BackendTimingAggregate *getBackendTimingAggregate(CounterexampleBackend backend) {
    switch(backend) {
    case COUNTEREXAMPLE_BACKEND_SMT_Z3:
    case COUNTEREXAMPLE_BACKEND_SMT_CVC4:
    case COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5:
    case COUNTEREXAMPLE_BACKEND_SMT_YICES2:
        return &g_planning_timing_summary.smt;
    case COUNTEREXAMPLE_BACKEND_CNF_KISSAT:
        return &g_planning_timing_summary.kissat;
    case COUNTEREXAMPLE_BACKEND_CNF_MINISAT:
        return &g_planning_timing_summary.minisat;
    case COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE:
        return &g_planning_timing_summary.glucose;
    case COUNTEREXAMPLE_BACKEND_CNF_CADICAL:
        return &g_planning_timing_summary.cadical;
    default:
        return 0;
    }
}

static void recordCnfPrepareTiming(int build_time_ms,
                                   bool is_primary_path,
                                   const std::string &phase_tag) {
    if(build_time_ms < 0) build_time_ms = 0;
    g_planning_timing_summary.total_cnf_prepare_actual_ms_all += build_time_ms;
    g_planning_timing_summary.total_validation_actual_ms_all += build_time_ms;
    if(is_primary_path) {
        g_planning_timing_summary.total_cnf_prepare_actual_ms_primary += build_time_ms;
        g_planning_timing_summary.total_validation_actual_ms_primary += build_time_ms;
    }
    if(g_print_iteration_counterexample_timing) {
        cout << "[反例计时] " << phase_tag
             << " CNF公共构造实际耗时(ms) = " << build_time_ms
             << "，归属=" << (is_primary_path ? "主流程" : "对比/旁路") << endl;
    }
}

static void recordBackendExecutionTiming(const CounterexampleRunResult &result,
                                         bool is_primary_path,
                                         const std::string &phase_tag) {
    if(!result.available) return;
    BackendTimingAggregate *agg = getBackendTimingAggregate(result.backend);
    if(agg == 0) return;

	long long comparable_ms = result.total_time_ms;

	/*
	* actual_validation_ms:
	*   主流程/全流程“实际反例验证总时间”口径。
	*   对 SMT/Z3：构造 + 求解/提取
	*   对 CNF 后端：这里只累计 solver/extract，
	*   CNF 公共构造时间由 recordCnfPrepareTiming(...) 单独累计，避免重复算。
	*/
	long long actual_validation_ms = (isSmtCounterexampleBackend(result.backend))
		? result.total_time_ms
		: result.solver_and_extract_time_ms;

	/*
	* solver_extract_ms:
	*   纯“求解/提取”口径。
	*   三种后端统一都只取 result.solver_and_extract_time_ms。
	*   这样在 SMT/Z3 主流程下，就不会再把 total_time_ms 错打印成
	*   “主流程后端累计求解/提取时间(ms)”。
	*/
	long long solver_extract_ms = result.solver_and_extract_time_ms;

	agg->comparable_total_ms_all += comparable_ms;
	agg->actual_exec_ms_all += solver_extract_ms;
	agg->build_ms_all += result.build_time_ms;
	agg->runs_all += 1;

	g_planning_timing_summary.total_validation_actual_ms_all += actual_validation_ms;

	if(is_primary_path) {
		agg->comparable_total_ms_primary += comparable_ms;
		agg->actual_exec_ms_primary += solver_extract_ms;
		agg->build_ms_primary += result.build_time_ms;
		agg->runs_primary += 1;
		g_planning_timing_summary.total_validation_actual_ms_primary += actual_validation_ms;
	} else {
		agg->comparable_total_ms_compare += comparable_ms;
		agg->actual_exec_ms_compare += solver_extract_ms;
		agg->build_ms_compare += result.build_time_ms;
		agg->runs_compare += 1;
	}



    if(g_print_iteration_counterexample_timing) {
        cout << "[反例计时] " << phase_tag
             << " backend=" << counterexampleBackendName(result.backend)
             << "，归属=" << (is_primary_path ? "主流程" : "对比/旁路")
             << "，build_ms=" << result.build_time_ms
             << "，solver_extract_ms=" << result.solver_and_extract_time_ms
             << "，method_total_ms=" << result.total_time_ms
			 << "，actual_validation_ms=" << actual_validation_ms
			<< "，solver_extract_only_ms=" << solver_extract_ms
             << "，has_counterexample=" << (result.has_counterexample ? 1 : 0)
             << "，sample_valid=" << (result.sample_valid ? 1 : 0) << endl;
    }
}

static void printFinalTimingSummary(const Counter *driver_counter) {
    g_planning_timing_summary.total_program_ms = clockDiffMs(g_program_start_clock, std::clock());
    g_planning_timing_summary.total_planning_ms = clockDiffMs(g_planning_start_clock, std::clock());

    const BackendTimingAggregate *primary_agg = 0;
    if(isSmtCounterexampleBackend(g_primary_counterexample_backend)) {
        primary_agg = &g_planning_timing_summary.smt;
    } else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT) {
        primary_agg = &g_planning_timing_summary.kissat;
    } else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT) {
        primary_agg = &g_planning_timing_summary.minisat;
    } else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE) {
        primary_agg = &g_planning_timing_summary.glucose;
    } else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL) {
        primary_agg = &g_planning_timing_summary.cadical;
    }

    cout << "[总时间日志] =====================================" << endl;
    cout << "[总时间日志] 主流程后端 = "
         << counterexampleBackendName(g_primary_counterexample_backend) << endl;
    // cout << "[总时间日志] 整个规划任务总时间(ms) = "
    //      << g_planning_timing_summary.total_program_ms << endl;
    cout << "[总时间日志] 总规划时间(ms) = "
         << g_planning_timing_summary.total_planning_ms << endl;
    cout << "[总时间日志] 主流程反例验证总时间(ms) = "
         << g_planning_timing_summary.total_validation_actual_ms_primary << endl;
    cout << "[总时间日志] 总构造CNF时间(ms) = "
         << g_planning_timing_summary.total_cnf_prepare_actual_ms_primary << endl;
    cout << "[总时间日志] 总构造SMT时间(ms) = "
         << g_planning_timing_summary.smt.build_ms_all << endl;

    if(primary_agg != 0) {
        // cout << "[总时间日志] 主流程后端累计验证时间(ms, 构造+求解+提取) = "
        //      << primary_agg->comparable_total_ms_primary << endl;
        cout << "[总时间日志] 主流程后端累计求解/提取时间(ms) = "
             << primary_agg->actual_exec_ms_primary << endl;
    }

    if(driver_counter != 0) {
        const Counter::SMTValidationStats &last_stats = driver_counter->get_last_validation_stats();
        cout << "[总时间日志] 最近一轮主流程反例验证(ms): build="
             << last_stats.build_time_ms
             << "，solver_extract=" << last_stats.solver_and_extract_time_ms
             << "，total=" << last_stats.total_time_ms << endl;
    }
    cout << "[subplan-cache] hits=" << g_subplan_cache_hits
         << ", misses=" << g_subplan_cache_misses
         << ", entries=" << g_subplan_cache.size() << endl;
    cout << "[总时间日志] =====================================" << endl;
}

static std::string stateToStringFromVars(const std::vector<int> &vars) {
    state_var tmp;
    tmp.vars = vars;
    tmp.frequency = 0;
    return stateToStringmain(tmp);
}

static void copyCounterDriverStateForShadowRun(const Counter &src, Counter *dst) {
    dst->isfind = src.isfind;
    dst->findvalidplan = src.findvalidplan;
    dst->appearcounter = src.appearcounter;
    dst->firststate = src.firststate;
    dst->counterset_new = src.counterset_new;
    dst->findfinallandmark = src.findfinallandmark;
}

static void fillRunResultFromSmtCounter(CounterexampleBackend backend,
                                        const Counter &driver_counter,
                                        CounterexampleRunResult *result) {
    const Counter::SMTValidationStats &stats = driver_counter.get_last_validation_stats();
    (void)backend;
    result->backend = counterexampleBackendFromSmtSolverBackend((SMTSolverBackend)stats.used_solver_backend);
    result->available = stats.requested_solver_available || stats.used_fallback_solver || stats.result_valid;
    result->result_valid = stats.result_valid;
    result->has_counterexample = stats.has_counterexample;
    result->sample_valid = stats.sample_valid;
    result->build_time_ms = stats.build_time_ms;
    result->solver_and_extract_time_ms = stats.solver_and_extract_time_ms;
    result->total_time_ms = stats.total_time_ms;
    result->variable_count = stats.smt_variable_count;
    result->clause_count = 0;
    result->counterexample_state = stats.counterexample_state;
}

static bool runShadowSmtCounterexample(const Counter &driver_state,
                                       const std::vector<const Operator *> &plan,
                                       bool isfirst,
                                       CounterexampleRunResult *result) {
    std::vector<int> saved_initial_state = g_initial_state->vars;
    Counter shadow_counter(isfirst);
    copyCounterDriverStateForShadowRun(driver_state, &shadow_counter);
    bool has_counterexample = shadow_counter.conputerCounter(plan, isfirst);
    fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, shadow_counter, result);
    g_initial_state->vars = saved_initial_state;
    return has_counterexample;
}

static void fillRunResultFromCnfSolver(CounterexampleBackend backend,
                                       CounterCNF *cnf_solver,
                                       CounterexampleRunResult *result) {
    result->backend = backend;
    result->available = true;
    result->build_time_ms = cnf_solver->get_cnf_build_time_ms();
    result->variable_count = cnf_solver->get_last_var_count();
    result->clause_count = cnf_solver->get_last_clause_count();
    if(backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT) {
        result->available = cnf_solver->kissat_available();
        result->result_valid = cnf_solver->get_kissat_result_valid();
        result->has_counterexample = cnf_solver->get_kissat_last_has_counterexample();
        result->sample_valid = cnf_solver->get_kissat_sample_valid();
        result->solver_and_extract_time_ms = cnf_solver->get_kissat_end_to_end_time_ms();
        result->total_time_ms = result->build_time_ms + result->solver_and_extract_time_ms;
        result->counterexample_state = cnf_solver->get_kissat_counterexample_state();
    } else if(backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT) {
        result->available = cnf_solver->minisat_available();
        result->result_valid = cnf_solver->get_minisat_result_valid();
        result->has_counterexample = cnf_solver->get_minisat_last_has_counterexample();
        result->sample_valid = cnf_solver->get_minisat_sample_valid();
        result->solver_and_extract_time_ms = cnf_solver->get_minisat_end_to_end_time_ms();
        result->total_time_ms = result->build_time_ms + result->solver_and_extract_time_ms;
        result->counterexample_state = cnf_solver->get_minisat_counterexample_state();
    } else if(backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE) {
        result->available = cnf_solver->glucose_available();
        result->result_valid = cnf_solver->get_glucose_result_valid();
        result->has_counterexample = cnf_solver->get_glucose_last_has_counterexample();
        result->sample_valid = cnf_solver->get_glucose_sample_valid();
        result->solver_and_extract_time_ms = cnf_solver->get_glucose_end_to_end_time_ms();
        result->total_time_ms = result->build_time_ms + result->solver_and_extract_time_ms;
        result->counterexample_state = cnf_solver->get_glucose_counterexample_state();
    } else if(backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL) {
        result->available = cnf_solver->cadical_available();
        result->result_valid = cnf_solver->get_cadical_result_valid();
        result->has_counterexample = cnf_solver->get_cadical_last_has_counterexample();
        result->sample_valid = cnf_solver->get_cadical_sample_valid();
        result->solver_and_extract_time_ms = cnf_solver->get_cadical_end_to_end_time_ms();
        result->total_time_ms = result->build_time_ms + result->solver_and_extract_time_ms;
        result->counterexample_state = cnf_solver->get_cadical_counterexample_state();
    } else {
        result->available = false;
        result->result_valid = false;
    }
}

static bool isCnfBackendAvailable(CounterexampleBackend backend,
                                  CounterCNF *cnf_solver) {
    if(cnf_solver == 0) return false;
    switch(backend) {
    case COUNTEREXAMPLE_BACKEND_CNF_KISSAT:
        return cnf_solver->kissat_available();
    case COUNTEREXAMPLE_BACKEND_CNF_MINISAT:
        return cnf_solver->minisat_available();
    case COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE:
        return cnf_solver->glucose_available();
    case COUNTEREXAMPLE_BACKEND_CNF_CADICAL:
        return cnf_solver->cadical_available();
    default:
        return false;
    }
}

static void runSelectedCnfBackend(CounterexampleBackend backend,
                                  CounterCNF *cnf_solver,
                                  CounterexampleRunResult *result) {
    if(backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT) {
        cnf_solver->run_kissat_validation();
        fillRunResultFromCnfSolver(COUNTEREXAMPLE_BACKEND_CNF_KISSAT, cnf_solver, result);
    } else if(backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT) {
        cnf_solver->run_minisat_validation();
        fillRunResultFromCnfSolver(COUNTEREXAMPLE_BACKEND_CNF_MINISAT, cnf_solver, result);
    } else if(backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE) {
        cnf_solver->run_glucose_validation();
        fillRunResultFromCnfSolver(COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE, cnf_solver, result);
    } else if(backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL) {
        cnf_solver->run_cadical_validation();
        fillRunResultFromCnfSolver(COUNTEREXAMPLE_BACKEND_CNF_CADICAL, cnf_solver, result);
    } else {
        result->available = false;
        result->result_valid = false;
    }
}

static bool applyPrimaryCounterexampleResult(Counter *driver_counter,
                                             const CounterexampleRunResult &result) {
    driver_counter->last_validation_stats_ = Counter::SMTValidationStats();
    driver_counter->last_validation_stats_.build_time_ms = result.build_time_ms;
    driver_counter->last_validation_stats_.solver_and_extract_time_ms = result.solver_and_extract_time_ms;
    driver_counter->last_validation_stats_.total_time_ms = result.total_time_ms;
    driver_counter->last_validation_stats_.smt_variable_count = result.variable_count;
    driver_counter->last_validation_stats_.requested_solver_backend = (int)g_smt_solver_backend;
    driver_counter->last_validation_stats_.used_solver_backend = (int)g_smt_solver_backend;
    if(isSmtCounterexampleBackend(result.backend))
        driver_counter->last_validation_stats_.used_solver_backend = SMT_SOLVER_Z3;
    else if(result.backend == COUNTEREXAMPLE_BACKEND_SMT_CVC4)
        driver_counter->last_validation_stats_.used_solver_backend = SMT_SOLVER_CVC4;
    else if(result.backend == COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5)
        driver_counter->last_validation_stats_.used_solver_backend = SMT_SOLVER_MATHSAT5;
    else if(result.backend == COUNTEREXAMPLE_BACKEND_SMT_YICES2)
        driver_counter->last_validation_stats_.used_solver_backend = SMT_SOLVER_YICES2;
    driver_counter->last_validation_stats_.requested_solver_available = result.available;
    driver_counter->last_validation_stats_.result_valid = result.result_valid;
    driver_counter->last_validation_stats_.has_counterexample = result.has_counterexample;
    driver_counter->last_validation_stats_.sample_valid = result.sample_valid;
    driver_counter->last_validation_stats_.counterexample_state = result.counterexample_state;
    driver_counter->lastsmtvariables = result.variable_count;
    driver_counter->lastcountertime = result.solver_and_extract_time_ms;
    driver_counter->total_counter += result.total_time_ms;

    if(result.has_counterexample) {
        if(!result.sample_valid || result.counterexample_state.empty()) {
            cout << "[主反例后端] 错误：" << counterexampleBackendName(result.backend)
                 << " 报告存在反例，但未能恢复完整反例状态，不能安全驱动主流程。" << endl;
            return false;
        }
        driver_counter->isfind = false;
        g_initial_state->vars = result.counterexample_state;

        string statestring = stateToStringFromVars(g_initial_state->vars);
        if(driver_counter->appearcounter.find(statestring) == driver_counter->appearcounter.end()) {
            state_var tmp;
            tmp.frequency = 1;
            tmp.vars = g_initial_state->vars;
            driver_counter->appearcounter.insert(pair<string, state_var>(statestring, tmp));
            driver_counter->counterset_new.push_back(tmp);
        } else {
            driver_counter->appearcounter[statestring].frequency++;
            cout << "已经出现过" << endl;
        }
        // int k = 1;
        // for(std::map<string, state_var>::iterator t = driver_counter->appearcounter.begin();
        //     t != driver_counter->appearcounter.end(); ++t) {
        //     cout << "状态" << k << "出现在反例集中的次数：" << t->second.frequency << endl;
        //     k++;
        // }
        return true;
    }

    if(driver_counter->isfind) {
        driver_counter->findvalidplan = true;
    } else if(!driver_counter->isfind && open_closed_loop_avoidance) {
        driver_counter->isfind = true;
        int restrictsize = 0;
        for(std::map<string, state_var>::iterator t = driver_counter->appearcounter.begin();
            t != driver_counter->appearcounter.end(); ++t) {
            if(t->second.frequency > 1) restrictsize++;
        }
        if(restrictsize == 0) driver_counter->findvalidplan = true;
    } else if(!driver_counter->isfind && !open_closed_loop_avoidance) {
        driver_counter->isfind = true;
        driver_counter->findvalidplan = true;
    }
    return false;
}

static bool runInitialCounterexampleSelection(Counter *driver_counter,
                                              const std::vector<const Operator *> &plan) {
    if(isSmtCounterexampleBackend(g_primary_counterexample_backend)) {
        bool has_counterexample = driver_counter->conputerCounter(plan, true);
        CounterexampleRunResult smt_result;
        fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *driver_counter, &smt_result);
        recordBackendExecutionTiming(smt_result, true, "初始状态阶段");
        return has_counterexample;
    }

    CounterCNF initial_cnf_solver(true);
    bool cnf_prepare_counts_for_primary = true;
    if(!initial_cnf_solver.prepare_counterexample_cnf(plan, true, driver_counter)) {
        recordCnfPrepareTiming(initial_cnf_solver.get_cnf_build_time_ms(),
                               cnf_prepare_counts_for_primary,
                               "初始状态阶段");
        cout << "[主反例后端] 初始状态阶段 CNF 构造失败，回退到 SMT 后端。" << endl;
        bool has_counterexample = driver_counter->conputerCounter(plan, true);
        CounterexampleRunResult smt_result;
        fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *driver_counter, &smt_result);
        recordBackendExecutionTiming(smt_result, true, "初始状态阶段-回退SMT");
        return has_counterexample;
    }
    recordCnfPrepareTiming(initial_cnf_solver.get_cnf_build_time_ms(),
                           cnf_prepare_counts_for_primary,
                           "初始状态阶段");

    if(!isCnfBackendAvailable(g_primary_counterexample_backend, &initial_cnf_solver)) {
        cout << "[主反例后端] " << counterexampleBackendName(g_primary_counterexample_backend)
             << " 当前不可用，初始状态阶段回退到 SMT 后端。" << endl;
        bool has_counterexample = driver_counter->conputerCounter(plan, true);
        CounterexampleRunResult smt_result;
        fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *driver_counter, &smt_result);
        recordBackendExecutionTiming(smt_result, true, "初始状态阶段-回退SMT");
        return has_counterexample;
    }

    CounterexampleRunResult primary_result;
    runSelectedCnfBackend(g_primary_counterexample_backend, &initial_cnf_solver, &primary_result);
    recordBackendExecutionTiming(primary_result, true, "初始状态阶段");

    if(!primary_result.result_valid || (primary_result.has_counterexample && !primary_result.sample_valid)) {
        cout << "[主反例后端] " << counterexampleBackendName(primary_result.backend)
             << " 初始状态阶段结果不可安全使用，回退到 SMT 后端。" << endl;
        bool has_counterexample = driver_counter->conputerCounter(plan, true);
        CounterexampleRunResult smt_result;
        fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *driver_counter, &smt_result);
        recordBackendExecutionTiming(smt_result, true, "初始状态阶段-回退SMT");
        return has_counterexample;
    }
    return applyPrimaryCounterexampleResult(driver_counter, primary_result);
}

int operateTimes=0;

int main(int argc, const char **argv) {
    const char *cegis_selftest = std::getenv("IGC_CEGIS_SELFTEST");
    if (cegis_selftest != NULL && cegis_selftest[0] != '\0' &&
        std::string(cegis_selftest) != "0" && std::string(cegis_selftest) != "false") {
        const igc_cegis::StatusCode selftest_status = igc_cegis::run_cegis_self_test();
        std::cout << "[IGC-CEGIS-SELFTEST] final_status="
                  << igc_cegis::status_name(selftest_status) << std::endl;
        return selftest_status == igc_cegis::STATUS_OK ? 0 : 4;
    }

    g_program_start_clock = std::clock();
    struct tms start, search_start, search_end, end;
    struct tms landmarks_generation_start, landmarks_generation_end;
    times(&start);
    bool poly_time_method = false;
    string plan_filename = "sas_plan";
    
    bool ff_heuristic = false, ff_preferred_operators = false;
    bool landmarks_heuristic = false, landmarks_preferred_operators = false;
    bool reasonable_orders = true;
    bool iterative_search = false;
	original_dynamic = false;
    g_display = false;
    enum {wa_star, bfs} search_type = bfs;
    /*默认ff_heuristic=true,默认ff_preferred_operators = true*/
	if(argc < 2 || argc > 4) {
	std::cout << "Usage: \"search options [outputfile]\"\n";
    }
    else {
		bool backend_explicitly_selected = false;
		for(const char *c = argv[1]; *c != 0; c++) {
			if(*c == 'f') {
			/*默认开启*/
			ff_heuristic = true;
			} else if(*c == 'F') {
			/*默认开启*/
			ff_preferred_operators = true;
			} else if(*c == 'l') {
					landmarks_heuristic = true; 
			} else if(*c == 'L') {
					landmarks_preferred_operators = true; 
			} else if(*c == 'w') {
					search_type = wa_star;
			} else if(*c == 'i') {
					iterative_search = true;
			}else if(*c =='p'){
				/*开启规划解简化*/
				open_plan_optimize = true;
			}else if(*c == 'd'){
				/*开启动态参考状态*/
				dynamic_reference_state = true;
			}else if(*c == 's'){
				/*开启静态参考状态，默认使用landmark*/
				static_reference_state = true;
			}else if(*c == 'r'){
				/*开启框架的放松*/
				open_frame_relax = true;
			}else if(*c == 'a'){
				/*死循环避免*/
				open_closed_loop_avoidance = true;
			}else if(*c == 'o'){
				// 使用最初的动态参考状态,previous stat无规律变
				original_dynamic = true;
			}else if(*c == 'M'){
				//使用SMT变量简化
				smt_simplifier = false;
			}else if(*c == 'u'){
				// 开启 CNF 预处理（构造完成后、装入求解器前）
				g_enable_cnf_preprocess = true;
			}else if(*c == 'v'){
				// CNF/预处理基础日志
				g_cnf_log_basic = true;
			}else if(*c == 'V'){
				// CNF/预处理详细日志
				g_cnf_log_basic = true;
				g_cnf_log_detail = true;
			}else if(*c == 'q'){
				// 子句级日志（量很大）
				g_cnf_log_basic = true;
				g_cnf_log_clause = true;
			}else if(*c == 'N'){
				// 模型恢复日志
				g_cnf_log_model = true;
			}else if(*c == 'z'){
				g_smt_solver_backend = SMT_SOLVER_Z3;
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_SMT_Z3;
				backend_explicitly_selected = true;
			}else if(*c == 'c'){
				g_smt_solver_backend = SMT_SOLVER_CVC4;
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_SMT_CVC4;
				backend_explicitly_selected = true;
			}else if(*c == 'm'){
				g_smt_solver_backend = SMT_SOLVER_MATHSAT5;
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_SMT_MATHSAT5;
				backend_explicitly_selected = true;
			}else if(*c == 'y'){
				g_smt_solver_backend = SMT_SOLVER_YICES2;
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_SMT_YICES2;
				backend_explicitly_selected = true;
			}else if(*c == 'k'){
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_CNF_KISSAT;
				backend_explicitly_selected = true;
			}else if(*c == 'n'){
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_CNF_MINISAT;
				backend_explicitly_selected = true;
			}else if(*c == 'g'){
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE;
				backend_explicitly_selected = true;
			}else if(*c == 'C'){
				g_primary_counterexample_backend = COUNTEREXAMPLE_BACKEND_CNF_CADICAL;
				backend_explicitly_selected = true;
			}else {
				cerr << "Unknown option: " << *c << endl;
				return 1;
			}
		}

		if(!backend_explicitly_selected) {
			g_primary_counterexample_backend = counterexampleBackendFromSmtSolverBackend(g_smt_solver_backend);
		}

		if(argc >= 3)
		{
			plan_filename = argv[2];
			if(strcmp(argv[3],"true")==0) g_display = false;
		}
    }
    if(!ff_heuristic && !landmarks_heuristic) {
	cerr << "Error: you must select at least one heuristic!" << endl
	     << "If you are unsure, choose options \"fFlL\"." << endl;
	return 2;
    }
    cout << "主流程反例求解后端: " << counterexampleBackendName(g_primary_counterexample_backend) << endl;
    cout << "CNF预处理开关: " << (g_enable_cnf_preprocess ? "开启" : "关闭") << endl;
    cout << "CNF日志开关: basic=" << (g_cnf_log_basic ? "on" : "off")
         << ", detail=" << (g_cnf_log_detail ? "on" : "off")
         << ", clause=" << (g_cnf_log_clause ? "on" : "off")
         << ", model=" << (g_cnf_log_model ? "on" : "off") << endl;
    if(isSmtCounterexampleBackend(g_primary_counterexample_backend)) {
        cout << "请求的 SMT solver: " << smt_solver_backend_name(g_smt_solver_backend) << endl;
    }
    // cout << "三方法对比开关: " << (g_enable_cnf_compare ? "开启" : "关闭") << endl;
    // cout << "迭代反例验证时间打印开关: " << (g_print_iteration_counterexample_timing ? "开启" : "关闭") << endl;

    cin >> poly_time_method;
    if(poly_time_method) {
	cout << "Poly-time method not implemented in this branch." << endl;
	cout << "Starting normal solver." << endl;
    }

    g_planning_start_clock = std::clock();

    // Read input and generate landmarks
    bool generate_landmarks = false;
    g_lgraph = NULL; 
    g_lm_heur = NULL;
    /*无*/
	if(landmarks_heuristic || landmarks_preferred_operators) 
		generate_landmarks = true;
    
	/*landmarks_generation_start时间*/
	times(&landmarks_generation_start);
    
	/*将output中的数据全部读入到类中*/
	read_everything(cin, generate_landmarks, reasonable_orders);
    // dump_everything();

    times(&landmarks_generation_end);
    int landmarks_generation_ms = (landmarks_generation_end.tms_utime - 
				   landmarks_generation_start.tms_utime) * 10;
    /*无*/
	if(g_lgraph != NULL) {
	cout << "Landmarks generation time: " << landmarks_generation_ms / 1000.0 
	     << " seconds" << endl;
    }

    // External-planner CEGIS mode: the mature preprocessing and CNF/Kissat
    // verifier remain in this process, while legacy internal search/repair and
    // subplan-cache code are deliberately bypassed.
    if(igc_cegis::enabled_from_environment()) {
        igc_cegis::StatusCode cegis_status = igc_cegis::run_cegis_loop(plan_filename);
        cout << "[IGC-CEGIS] final_status=" << igc_cegis::status_name(cegis_status) << endl;
        return cegis_status == igc_cegis::STATUS_VALID ? 0 : 3;
    }

    // Check whether landmarks were found, if not switch to FF-heuristic.
    if(generate_landmarks && g_lgraph->number_of_landmarks() == 0) {
		cout << "No landmarks found. This should only happen if task is unsolvable." << endl;

		/*无*/
		if(landmarks_heuristic) {
			cout << "Disabling landmarks count heuristic." << endl;
			landmarks_heuristic = false;
		}

		/*有*/
		if(!ff_heuristic) {
			cout << "Using FF heuristic with preferred operators." << endl;
			ff_heuristic = true;
			ff_preferred_operators = true;
		}
    }

    int iteration_no = 0;
    bool solution_found = false;
	/*暂时不知道什么意思*/
    int wa_star_weights[] = {10, 5, 3, 2, 1, -1};
    int wastar_bound = -1;
    g_ff_heur = NULL;
    int wastar_weight = wa_star_weights[0];
    bool reducing_weight = true;
	
	// open_plan_optimize = false;
	// dynamic_reference_state = false;
	// static_reference_state =false;
	// open_frame_relax=true;
	// open_closed_loop_avoidance=true;

	/*这个循环只会一次，相当于没有*/
    do{
		iteration_no++;
		cout << "Search iteration " << iteration_no << endl;
		// 未使用迭代搜索
		if(reducing_weight && wa_star_weights[iteration_no - 1] != -1)
			wastar_weight = wa_star_weights[iteration_no - 1];
		else {
			cout << "No more new weight, weight is " << wastar_weight << endl;
			reducing_weight = false;
		}
		// Initialize search engine and heuristics (this is cheap and we want to vary search type
		// and heuristics, so we initialize freshly in each iteration)
		/*这里只使用到了bfs，不再迭代使用多种搜索方式*/
		BestFirstSearchEngine* engine; 
		//addin
		g_ff_heur = new FFHeuristic;
		
			// no prefer operator
	   	// open_lists.push_back(OpenListInfo(g_ff_heur, false));

		if(search_type == wa_star)
			// Parameters of WAStar are 1) weight for heuristic, 2) upper bound on solution
			// cost (this cuts of search branches if the cost of a node exceeds the bound), 
			// use -1 for none.
			engine = new WAStarSearchEngine(wastar_weight, wastar_bound);  
		/*默认bfs，gclama并没有改变*/
		
		print_heuristics_used(ff_heuristic, ff_preferred_operators, 
					landmarks_heuristic, landmarks_preferred_operators);
		/*不会再使用*/
		if(landmarks_heuristic || landmarks_preferred_operators) {
		/*
			if(landmarks_preferred_operators)
			if(!g_ff_heur)
				g_ff_heur = new FFHeuristic;
			g_lm_heur = new LandmarksCountHeuristic(
			*g_lgraph, *engine, landmarks_preferred_operators, g_ff_heur);
			engine->add_heuristic(g_lm_heur, landmarks_heuristic,
					landmarks_preferred_operators);
		*/
		}
		
		// Search
		int plan_cost = INT_MAX;
		bool ctask;
		//times(&search_start);
		/*不断对第一个状态进行求解，ctask为false时，一直循环*/
		// for(int i=0;i<g_variable_domain.size();i++){
		// 	cout<<i<<"-"<<g_variable_domain[i]<<endl;
		// }
		
		// g_initial_state->dump();

		// return 0;

		/*这里要调用一次反例求解，得到一个初始状态*/
		vector<const Operator *> Plan;
		counter = new Counter(false);
		g_goal_tmp = g_goal;
		// cout<<"当前目标的大小"<<g_goal.size()<<endl;
		// counter->selectMinState();
		// cout<<"当前目标的大小"<<g_goal.size()<<endl;
		// counter->conputerCounter(Plan,true);

		/*根据这个来选择初始状态*/
		/*4.*/
		Counter *counter_initial = new Counter(true);
		// cout << "hear!!" << endl;
		if (dynamic_reference_state || static_reference_state)
		{
			// counter->conputerCounter(Plan,true);
			runInitialCounterexampleSelection(counter_initial, Plan);
		}
		else{
			if(counter->oneofs.type==2||counter->oneofs.type==1){
				counter->selectLandmark();
				if(!counter->findfinallandmark){
					runInitialCounterexampleSelection(counter_initial, Plan);
				}
			}
			else{
				runInitialCounterexampleSelection(counter_initial, Plan);
			}
		}
		delete counter_initial;

		/*用于保存第一个反例*/
		state_var firststate;
		firststate.frequency=1;
		firststate.vars=g_initial_state->vars;
		string firststatestring = stateToStringmain(firststate);
		state_var initial_state;
		initial_state.vars = g_initial_state->vars;

		// if(counter->oneofs.type==2){
		// 	counter->appearcounter.insert(pair<string,state_var>(firststatestring,firststate));
		// 	counter->counterset_new.push_back(firststate);
		// 	cout<<11111<<endl;
		// }

		/*已经作为s0的进行禁止*/
		if(open_closed_loop_avoidance)
			counter->firststate.insert(pair<string,state_var>(stateToStringmain(initial_state),initial_state));
		
		/*根据第一个反例进行搜索*/
		engine = new BestFirstSearchEngine;
		if(ff_heuristic || ff_preferred_operators) {
		//	    if(!g_ff_heur)
		//		g_ff_heur = new FFHeuristic;
			/*修改了*/
			engine->add_heuristic( ff_heuristic,
					ff_preferred_operators);
		}

		fail_time=0;
		do {
			/*这个和里面的不一样?里面能解决,这里不能解?*/
			// g_initial_state->dump();
			engine->search();
			operateTimes++;
			//times(&search_end);
			if(engine->found_solution())
			{
				/*输出s0状态*/
				// g_initial_state->dump();
				/*plan_filename表示输入时需要保存信息的位置*/
				cout<<engine->get_plan().size()<<endl;
				plan_cost = save_plan(engine->get_plan(), plan_filename, iteration_no);
				
				g_initial_state->vars = firststate.vars;
				counter->appearcounter.insert(pair<string,state_var>(firststatestring,firststate));
				counter->counterset_new.push_back(firststate);
				cout<<"反例集大小：" <<endl;
				cout<<counter->counterset_new.size() <<endl;
			}else{

				/*无解说明当前反例作为初始状态不可行，切换初始状态，并把这一个在初始状态中禁止*/
				cout<<"一开始就没有解！？"<<endl;
				cout<<"no validplan found!"<<endl;
				if(open_closed_loop_avoidance){
					if(!runInitialCounterexampleSelection(counter, Plan)){
						cout<<"该规划器不能解该问题！"<<endl;
						break;
					}
					// g_initial_state->dump();
					
					/*8.*/
					/*已经作为s0的进行禁止*/
					state_var loop_initial_state;
					loop_initial_state.vars = g_initial_state->vars;
					counter->firststate.insert(pair<string,state_var>(stateToStringmain(loop_initial_state),loop_initial_state));

					/*更新s0*/
					// firststate = counter->counterset_new[0];
					// firststatestring = stateToStringmain(firststate);
					// cout<<"firststate:"<<counter->firststate.size()<<endl;
					// engine = search_subplan(g_initial_state,g_goal,true,true);

					/*更新s0*/
					firststate.vars = g_initial_state->vars;
					firststatestring = stateToStringmain(firststate);
					counter->appearcounter.insert(pair<string,state_var>(firststatestring,firststate));
					counter->counterset_new.push_back(firststate);
					cout<<"firststate:"<<counter->firststate.size()<<endl;
					engine = search_subplan(g_initial_state,g_goal,true,true);
				}else{
					break;
				}
				
			}
			
			cout<<"plansize:"<<engine->get_plan().size()<<endl;
			// ctask = true;
			ctask = solve_belief_state_ite(engine);
			// return 0;
			if (!ctask)
			{
				cout << "reach dead end!" << endl;
				fail_time++;
				/*上一个解搜索失败，清空反例集*/
				counter->appearcounter.clear();
				counter->counterset_new.clear();
			}
		}
		while (!ctask);

		times(&end);
		int total_ms = clockDiffMs(g_program_start_clock, std::clock());
		cout << "Total time: " << total_ms / 1000.0 << " seconds" << endl;

		/*engine->statistics();
		int search_ms = (search_end.tms_utime - search_start.tms_utime) * 10;
		cout << "Search time: " << search_ms / 1000.0 << " seconds" << endl;
		int total_ms = (search_end.tms_utime - start.tms_utime) * 10;
		cout << "Total time: " << total_ms / 1000.0 << " seconds" << endl;*/
		
		solution_found |= engine->found_solution();
		/*没有找到解，退出循环*/
		if(!engine->found_solution())
			iterative_search = false;

		// Set new parameters for next search
		search_type = wa_star;
		wastar_bound = plan_cost;
		if(wastar_weight <= 2) { // make search less greedy
			ff_preferred_operators = false;
			landmarks_preferred_operators = false;
		}

		// If the heuristic weight was already 0, we can only search for better solutions
		// by decreasing the bound (note: this could be improved by making WA* expand 
		// all fringe states, but seems to have little importance).
		if(wastar_weight == 0) {
			wastar_bound--;
		}

    }
    while(iterative_search);

    return solution_found ? 0 : 1; 
}
void show_action()
{
	for(int i=0;i<g_operators.size();i++)
		g_operators[i].dump();
}

void printPlan(vector<const Operator *> plan){
	cout<<"规划长度："<<plan.size()<<endl;
    for(int i=0;i<plan.size();i++){
        cout<<plan[i]->get_name()<<" ";
    }
    cout<<endl;
}

bool sovle_counter(vector<const Operator *> oldplan){
	 State* current_state;
     State* previous_state;
     State* check_plan_state;
     vector<const Operator *> plan;
     vector<const Operator *> subplan;
     bool maintain_maximum = true;
     BestFirstSearchEngine *subsubengine;
//     cout << "Initial " << endl;
//     g_initial_state->dump();
     int iter = 0;
     int iteration = 0;
	 int belief_size = 0;
     int last_modified = 0;
     bool valid_plan = false;
    //  int operateTimes=1;
	 /*将s0的plan插入*/
     subplan.insert(subplan.end(),oldplan.begin(),oldplan.end());

	 /*将当前状态赋值为初始状态*/
     current_state = new State(); 
     current_state->assign(*g_initial_state);
	 /*前一个状态也赋值为初始状态*/
	 previous_state = new State();
     previous_state->assign(*g_initial_state);
     /*这个也是初始状态*/
	 check_plan_state = new State();
     check_plan_state->assign(*g_initial_state);
	 plan.clear();
	 plan.insert(plan.end(),subplan.begin(),subplan.end());
	 for(map<string,state_var>::iterator t=counter->appearcounter.begin();t!=counter->appearcounter.end();t++){
		/*只处理被约束的状态*/
		if(t->second.frequency<2)
			continue;
		check_plan_state->vars=t->second.vars;
		/*检查该状态是否能到达目标状态*/
		for(int i=0;i<plan.size();i++)
		{
			/*找到操作下标*/
			int j;
			for(j=0;j<g_operators.size();j++)
			{
				if(g_operators[j].get_name().compare(plan[i]->get_name()) == 0) break;
			}
			/*操作可用，check_plan_state后移*/
			if(g_operators[j].is_applicable(*check_plan_state))
			{
				check_plan_state->assign(State(*check_plan_state,g_operators[j]));
						//cout << "current state" << endl;
							//check_plan_state->dump();
			}
		}
		/*检查该状态是否达到目标*/
		
		if(check_plan_state->satisfy_subgoal(g_goal))
		{
			if(original_dynamic)
				previous_state->vars = t->second.vars;
			cout<<"issatisfy:1"<<endl;
			continue;
		}
		cout<<"issatisfy:0"<<endl;
		if(!original_dynamic)
			previous_state->assign(*g_initial_state);
		current_state->vars=t->second.vars;		
		//plan.insert(plan.end(),subsubengine->get_plan().begin(),subsubengine->get_plan().end());
		/*plan使得该状态不能到达目标状态 | plan中有动作不适用*/
		int i=0;
		/*之前的plan，不适用当前状态，在当前状态中进行插入*/
		while(i<plan.size())
		{
			/*找到当前的opera下标*/
			int j;
			for(j=0;j<g_operators.size();j++)
			{
				if(g_operators[j].get_name().compare(plan[i]->get_name()) == 0) break;
			}
			/*如果前置条件和条件影响是相同的变量，则两个都检查，否则只需要检查前置条件*/
			/*满足前置条件或者即满足前置条件，又满足条件影响*/
			/**/
			// cout<<i<<"是否满足:"<<g_operators[j].is_conformant_applicable(*current_state)<<endl;
			if(g_operators[j].is_conformant_applicable(*current_state))
			{
				vector<pair <int, int> > sub_goal;
				vector<const Operator *> sub_plan;					
				/*前一个状态在该plan下的条件影响 */
				sub_goal = g_operators[j].condition_sub_goal(*previous_state);
				
				/*如果有一个的条件影响是不满足的，那么后面的都不再进行子目标的求解*/
				/*？？？？*/
				if(maintain_maximum == false) sub_goal.clear();				
				// cout<<!current_state->satisfy_subgoal(sub_goal)<<endl;
				/*当前状态不满足这个子目标*/
				// 11.24删除
				// if(counter->unapplyaction==0)
				if(!current_state->satisfy_subgoal(sub_goal))
				{
					/*找到这个子规划*/
					subsubengine = search_subplan(current_state,sub_goal,true,true);
					operateTimes++;
					//cout << "subsub 1 " << endl;
					/*插入到第i个动作前*/
					if(subsubengine->found_solution())
					{
						sub_plan = subsubengine->get_plan();
						/*insert(a,b,c)  将b-c插入到a位置*/
						plan.insert(plan.begin()+i,subsubengine->get_plan().begin(),subsubengine->get_plan().end());
						// cout<<"2.plan"<<endl;
						// printPlan(plan);
						/*当前状态后移*/
						for(int k=0;k<sub_plan.size();k++)
						{
							/*下标k*/
							int h;
							for(h=0;h<g_operators.size();h++)
							{
								if(g_operators[h].get_name().compare(sub_plan[k]->get_name()) == 0) break;
							}
							if(g_display)
							{
								g_operators[h].dump();
							}
							current_state->assign(State(*current_state, g_operators[h]));
						}
						i=i+subsubengine->get_plan().size();
					}
					/*下面不满足是直接退出？*/
					else
					{
						cout<<"没有找到！"<<endl;
						if(!open_frame_relax)
							maintain_maximum = false;
					}
					delete subsubengine;
				} 	
				/*当前状态和后续状态都后移*/
				// current_state->assign(State(*current_state, g_operators[j]));
				// previous_state->assign(State(*previous_state, g_operators[j]));
				
				// 11.24修改
				if(g_operators[j].is_conformant_applicable(*current_state)&&g_operators[j].is_conformant_applicable(*previous_state)){
					current_state->assign(State(*current_state, g_operators[j]));
					previous_state->assign(State(*previous_state, g_operators[j]));
				}else{
					cout<<"不能移动"<<endl;
				}

				// current_state->dump();
				i++;
			}
			/*不满足前置条件*/
			else
			{
				//cout << "not applicable";
				//g_operators[j].dump();
				vector<pair <int, int> > sub_goal;
				/*当前状态不满足的前置条件和条件影响*/
				sub_goal = g_operators[j].conformant_sub_goal(*current_state);
				vector<const Operator *> sub_plan;					
				subsubengine = search_subplan(current_state,sub_goal,true,true);
				operateTimes++;
				//cout << " subsub 2" << endl;
				if (!subsubengine->found_solution())
				{
					// 11.24 修改
					// cout<<plan.size()<<endl;
					if(open_plan_optimize){
						while(i<plan.size())
							plan.erase(plan.begin()+i);
						break;
						// cout<<plan.size()<<endl;
						// continue;
					}else
						return false;
				}
				sub_plan = subsubengine->get_plan();
				/*将子plan插入第i个动作前*/
				plan.insert(plan.begin()+i,subsubengine->get_plan().begin(),subsubengine->get_plan().end());
				// cout<<"3.plan"<<endl;
				// printPlan(sub_plan);
				/*将当前状态后移*/
				for(int k=0;k<sub_plan.size();k++)
				{
					int h;
					for(h=0;h<g_operators.size();h++)
					{
						if(g_operators[h].get_name().compare(sub_plan[k]->get_name()) == 0) break;
					}
					if(g_display)
					{
						g_operators[h].dump();
					}
					current_state->assign(State(*current_state, g_operators[h]));
				}
				current_state->assign(State(*current_state, g_operators[j]));
				i=i+subsubengine->get_plan().size()+1;
				delete subsubengine;

			}
		}
		/*当前状态*/
		// cout<<"当前状态"<<endl;
		// current_state->dump();
		/*再找一遍，查看经过上面的操作后，最终能否到达目标状态*/
		subsubengine = search_subplan(current_state,g_goal,true,true);
		operateTimes++;
		if (!subsubengine->found_solution())
		{
			return false;
		}
		subplan.clear();
		
		/*将新形成的plan与之前的plan连接*/
		subplan.insert(subplan.end(),subsubengine->get_plan().begin(),subsubengine->get_plan().end());
		plan.insert(plan.end(),subplan.begin(),subplan.end());
		// cout<<"4.plan"<<endl;
		// printPlan(subplan);
		/*此状态前满足的状态*/
		g_initial_state->vars=t->second.vars;
		delete subsubengine;
	}
	counter->newplan.insert(counter->newplan.end(),plan.begin(),plan.end());


	return true;
}

bool havecounterfrequencycout1(){
	bool flag = false;
	for(map<string,state_var>::iterator t=counter->appearcounter.begin();t!=counter->appearcounter.end();t++){
		if(t->second.frequency>5){
			return true;
		}
	}
	return flag;
}

/*修改的迭代版本*/
bool solve_belief_state_ite(BestFirstSearchEngine* subengine){
	int not_move=0;
	int qiehuan = 0;
    State* current_state;
    State* previous_state;
    State* check_plan_state;
    vector<const Operator *> plan;
    vector<const Operator *> subplan;
    bool maintain_maximum = true;
    BestFirstSearchEngine *subsubengine;
	set<string> action_notreach;
    int iter = 0;
    int iteration = 0;
	int belief_size = 0;
    int last_modified = 0;
    bool valid_plan = false;
	
	/*将s0的plan插入*/
    subplan.insert(subplan.end(),subengine->get_plan().begin(),subengine->get_plan().end());
	 
	/*将当前状态赋值为初始状态*/
    current_state = new State(); 
    current_state->assign(*g_initial_state);
	previous_state = new State();
    previous_state->assign(*g_initial_state);
	check_plan_state = new State();
    check_plan_state->assign(*g_initial_state);
	//  printPlan(subplan);
	int yinxian1=0,yinxian2=0,test1=0;
	 
	plan.clear();
	for(;;){
		iteration++;
		cout<<"第"<<iteration<<"次迭代"<<endl;
		
		plan.insert(plan.end(),subplan.begin(),subplan.end());
		subplan.clear();
		// cout<<"规划长度:"<<plan.size()<<endl;
		// printPlan(plan);
		
		/*2*/
		/*对当前的规划解进行化简，只有能找到反例才化简，不能找到反例只有两种情况(此时均已对初始状态约束放开)：1、前一次有约束时无反例，并且对这些约束进行了求解 2、前一次无约束时无反例*/
		if(open_plan_optimize){
			if(!counter->isfind){
				counter->optimizePlantest(plan);
				plan.clear();
				plan.insert(plan.end(),counter->newplan.begin(),counter->newplan.end());
				counter->newplan.clear();
			}
			// else{
			// 	counter->counterissolvered=true;
			// }
		}
		// else{
		// 	counter->counterissolvered=true;
		// }
		
		// counter->counterissolvered=true;

		// cout<<"1.plan"<<endl;
		// printPlan(plan);
		
		/*3*/
		/*两种选择参考方式的方法*/
		if(dynamic_reference_state==true){
			if(original_dynamic){
			}else
				previous_state->assign(*g_initial_state);
		}else if(static_reference_state==true){
			string prestatestring = "";
			for(int i=0;i<previous_state->vars.size();i++){
				if(previous_state->vars[i]!=(g_variable_domain[i]-1)){
					prestatestring+=to_string(i);
					prestatestring+="-";
					prestatestring+=to_string(previous_state->vars[i]);
					prestatestring+='.';
				}
			}
			if(counter->appearcounter.find(prestatestring)!= counter->appearcounter.end()&&counter->appearcounter[prestatestring].frequency>1){
				qiehuan=1;
				for(map<string,state_var>::iterator t=counter->appearcounter.begin();t!=counter->appearcounter.end();t++){
					if(t->second.frequency==1){
						previous_state->vars=t->second.vars;
						check_plan_state->vars = t->second.vars;
						break;
					}
				}
			}else
				previous_state->assign(*check_plan_state);
		}else{
			if(counter->findfinallandmark){
				string prestatestring = "";
				for(int i=0;i<previous_state->vars.size();i++){
					if(previous_state->vars[i]!=(g_variable_domain[i]-1)){
						prestatestring+=to_string(i);
						prestatestring+="-";
						prestatestring+=to_string(previous_state->vars[i]);
						prestatestring+='.';
					}
				}
				if(counter->appearcounter.find(prestatestring)!= counter->appearcounter.end()&&counter->appearcounter[prestatestring].frequency>1){
					qiehuan=1;
					for(map<string,state_var>::iterator t=counter->appearcounter.begin();t!=counter->appearcounter.end();t++){
						if(t->second.frequency==1){
							previous_state->vars=t->second.vars;
							check_plan_state->vars = t->second.vars;
							break;
						}
					}
				}else
					previous_state->assign(*check_plan_state);
			}else{
				if(original_dynamic){
				}else
					previous_state->assign(*g_initial_state);
			}
		}

		        CounterexampleRunResult primary_result;
        CounterexampleRunResult smt_compare_result;
        CounterexampleRunResult kissat_compare_result;
        CounterexampleRunResult minisat_compare_result;
        CounterexampleRunResult glucose_compare_result;
        CounterexampleRunResult cadical_compare_result;
        bool driver_has_counterexample = false;
        bool have_smt_compare_result = false;
        bool have_kissat_compare_result = false;
        bool have_minisat_compare_result = false;
        bool have_glucose_compare_result = false;
        bool have_cadical_compare_result = false;

        CounterCNF *persistent_counter_cnf = 0;
        bool need_cnf_prepare = g_enable_cnf_compare
            || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT
            || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT
            || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE
            || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL;

        if(need_cnf_prepare) {
            static CounterCNF *shared_counter_cnf = 0;
            if(shared_counter_cnf == 0) {
                shared_counter_cnf = new CounterCNF(false);
            }
            persistent_counter_cnf = shared_counter_cnf;
        }

        if(g_enable_cnf_compare) {
            cout << "[反例对比] =====================================" << endl;
            cout << "[反例对比] 当前验证轮次 = " << iteration << endl;
            cout << "[反例对比] 当前候选计划长度 = " << plan.size() << endl;
            cout << "[反例对比] 主流程驱动后端 = "
                 << counterexampleBackendName(g_primary_counterexample_backend) << endl;
        }

        if(need_cnf_prepare && persistent_counter_cnf != 0) {
            bool cnf_prepare_counts_for_primary = (!isSmtCounterexampleBackend(g_primary_counterexample_backend));
            if(!persistent_counter_cnf->prepare_counterexample_cnf(plan, false, counter)) {
                recordCnfPrepareTiming(persistent_counter_cnf->get_cnf_build_time_ms(),
                                       cnf_prepare_counts_for_primary,
                                       "迭代验证轮");
                cout << "[主反例后端] CNF 构造失败。" << endl;
            } else {
                recordCnfPrepareTiming(persistent_counter_cnf->get_cnf_build_time_ms(),
                                       cnf_prepare_counts_for_primary,
                                       "迭代验证轮");
                if((g_enable_cnf_compare
                   || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT)
                   && isCnfBackendAvailable(COUNTEREXAMPLE_BACKEND_CNF_KISSAT, persistent_counter_cnf)) {
                    runSelectedCnfBackend(COUNTEREXAMPLE_BACKEND_CNF_KISSAT,
                                          persistent_counter_cnf,
                                          &kissat_compare_result);
                    have_kissat_compare_result = kissat_compare_result.available;
                    if(have_kissat_compare_result) {
                        recordBackendExecutionTiming(kissat_compare_result,
                                                     g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT,
                                                     "迭代验证轮");
                    }
                }
                if((g_enable_cnf_compare
                   || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT)
                   && isCnfBackendAvailable(COUNTEREXAMPLE_BACKEND_CNF_MINISAT, persistent_counter_cnf)) {
                    runSelectedCnfBackend(COUNTEREXAMPLE_BACKEND_CNF_MINISAT,
                                          persistent_counter_cnf,
                                          &minisat_compare_result);
                    have_minisat_compare_result = minisat_compare_result.available;
                    if(have_minisat_compare_result) {
                        recordBackendExecutionTiming(minisat_compare_result,
                                                     g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT,
                                                     "迭代验证轮");
                    }
                }
                if((g_enable_cnf_compare
                   || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE)
                   && isCnfBackendAvailable(COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE, persistent_counter_cnf)) {
                    runSelectedCnfBackend(COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE,
                                          persistent_counter_cnf,
                                          &glucose_compare_result);
                    have_glucose_compare_result = glucose_compare_result.available;
                    if(have_glucose_compare_result) {
                        recordBackendExecutionTiming(glucose_compare_result,
                                                     g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE,
                                                     "迭代验证轮");
                    }
                }
                if((g_enable_cnf_compare
                   || g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL)
                   && isCnfBackendAvailable(COUNTEREXAMPLE_BACKEND_CNF_CADICAL, persistent_counter_cnf)) {
                    runSelectedCnfBackend(COUNTEREXAMPLE_BACKEND_CNF_CADICAL,
                                          persistent_counter_cnf,
                                          &cadical_compare_result);
                    have_cadical_compare_result = cadical_compare_result.available;
                    if(have_cadical_compare_result) {
                        recordBackendExecutionTiming(cadical_compare_result,
                                                     g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL,
                                                     "迭代验证轮");
                    }
                }
            }
        }

        if(g_enable_cnf_compare
           && !isSmtCounterexampleBackend(g_primary_counterexample_backend)) {
            runShadowSmtCounterexample(*counter, plan, false, &smt_compare_result);
            have_smt_compare_result = true;
            recordBackendExecutionTiming(smt_compare_result, false, "迭代验证轮-ShadowSMT");
        }

        if(isSmtCounterexampleBackend(g_primary_counterexample_backend)) {
            driver_has_counterexample = counter->conputerCounter(plan, false);
            fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *counter, &primary_result);
            recordBackendExecutionTiming(primary_result, true, "迭代验证轮");
            smt_compare_result = primary_result;
            have_smt_compare_result = true;
        } else {
            const CounterexampleRunResult *selected_cnf_result = 0;
            if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_KISSAT)
                selected_cnf_result = have_kissat_compare_result ? &kissat_compare_result : 0;
            else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_MINISAT)
                selected_cnf_result = have_minisat_compare_result ? &minisat_compare_result : 0;
            else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_GLUCOSE)
                selected_cnf_result = have_glucose_compare_result ? &glucose_compare_result : 0;
            else if(g_primary_counterexample_backend == COUNTEREXAMPLE_BACKEND_CNF_CADICAL)
                selected_cnf_result = have_cadical_compare_result ? &cadical_compare_result : 0;

            if(selected_cnf_result == 0 || !selected_cnf_result->available) {
                cout << "[主反例后端] " << counterexampleBackendName(g_primary_counterexample_backend)
                     << " 当前不可用，回退到 SMT 后端。" << endl;
                driver_has_counterexample = counter->conputerCounter(plan, false);
                fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *counter, &primary_result);
                recordBackendExecutionTiming(primary_result, true, "迭代验证轮-回退SMT");
                smt_compare_result = primary_result;
                have_smt_compare_result = true;
            } else if(!selected_cnf_result->result_valid
                      || (selected_cnf_result->has_counterexample && !selected_cnf_result->sample_valid)) {
                cout << "[主反例后端] " << counterexampleBackendName(g_primary_counterexample_backend)
                     << " 结果不可安全驱动主流程，回退到 SMT 后端。" << endl;
                driver_has_counterexample = counter->conputerCounter(plan, false);
                fillRunResultFromSmtCounter(COUNTEREXAMPLE_BACKEND_SMT_Z3, *counter, &primary_result);
                recordBackendExecutionTiming(primary_result, true, "迭代验证轮-回退SMT");
                smt_compare_result = primary_result;
                have_smt_compare_result = true;
            } else {
                primary_result = *selected_cnf_result;
                driver_has_counterexample = applyPrimaryCounterexampleResult(counter, primary_result);
            }
        }

        if(g_enable_cnf_compare) {
            cout << "[反例对比] ---------------- 结果与时间统计 ----------------" << endl;
            if(have_smt_compare_result) {
                cout << "[反例对比] SMT/Z3 结果 (1=找到反例, 0=无反例) = "
                     << smt_compare_result.has_counterexample << endl;
                cout << "[反例对比] SMT 构造时间(ms) = "
                     << smt_compare_result.build_time_ms << endl;
                cout << "[反例对比] SMT 求解并提取反例时间(ms) = "
                     << smt_compare_result.solver_and_extract_time_ms << endl;
                cout << "[反例对比] SMT/Z3 总验证时间(ms) = "
                     << smt_compare_result.total_time_ms << endl;
                cout << "[反例对比] SMT 模型变量数 = "
                     << smt_compare_result.variable_count << endl;
            }
            if(have_kissat_compare_result) {
                cout << "[反例对比] CNF 统计信息: vars = " << kissat_compare_result.variable_count
                     << ", clauses = " << kissat_compare_result.clause_count << endl;
                cout << "[反例对比] CNF 构造时间(ms) = "
                     << kissat_compare_result.build_time_ms << endl;
                cout << "[反例对比] CNF/Kissat 结果 (1=找到反例, 0=无反例) = "
                     << kissat_compare_result.has_counterexample << endl;
                cout << "[反例对比] CNF/Kissat 灌入+求解+提取时间(ms) = "
                     << kissat_compare_result.solver_and_extract_time_ms << endl;
                cout << "[反例对比] CNF/Kissat 总验证时间(ms) = "
                     << kissat_compare_result.total_time_ms << endl;
            } else {
                cout << "[反例对比] Kissat 当前未启用或未成功接入，本轮不参与 Kissat 对比。" << endl;
            }
            if(have_minisat_compare_result) {
                cout << "[反例对比] CNF/MiniSAT 结果 (1=找到反例, 0=无反例) = "
                     << minisat_compare_result.has_counterexample << endl;
                cout << "[反例对比] CNF/MiniSAT 灌入+求解+提取时间(ms) = "
                     << minisat_compare_result.solver_and_extract_time_ms << endl;
                cout << "[反例对比] CNF/MiniSAT 总验证时间(ms) = "
                     << minisat_compare_result.total_time_ms << endl;
            } else {
                cout << "[反例对比] MiniSAT 当前未启用或未成功接入，本轮不参与 MiniSAT 对比。" << endl;
            }
            if(have_glucose_compare_result) {
                cout << "[反例对比] CNF/Glucose 结果 (1=找到反例, 0=无反例) = "
                     << glucose_compare_result.has_counterexample << endl;
                cout << "[反例对比] CNF/Glucose 灌入+求解+提取时间(ms) = "
                     << glucose_compare_result.solver_and_extract_time_ms << endl;
                cout << "[反例对比] CNF/Glucose 总验证时间(ms) = "
                     << glucose_compare_result.total_time_ms << endl;
            } else {
                cout << "[反例对比] Glucose 当前未启用或未成功接入，本轮不参与 Glucose 对比。" << endl;
            }
            if(have_cadical_compare_result) {
                cout << "[反例对比] CNF/CaDiCaL 结果 (1=找到反例, 0=无反例) = "
                     << cadical_compare_result.has_counterexample << endl;
                cout << "[反例对比] CNF/CaDiCaL 灌入+求解+提取时间(ms) = "
                     << cadical_compare_result.solver_and_extract_time_ms << endl;
                cout << "[反例对比] CNF/CaDiCaL 总验证时间(ms) = "
                     << cadical_compare_result.total_time_ms << endl;
            } else {
                cout << "[反例对比] CaDiCaL 当前未启用或未成功接入，本轮不参与 CaDiCaL 对比。" << endl;
            }

            cout << "[反例对比] ---------------- 结果一致性检查 ----------------" << endl;
            if(have_smt_compare_result && have_kissat_compare_result) {
                cout << "[反例对比] SMT/Z3 vs CNF/Kissat SAT/UNSAT 是否一致 = "
                     << ((smt_compare_result.has_counterexample == kissat_compare_result.has_counterexample) ? "是" : "否") << endl;
            }
            if(have_smt_compare_result && have_minisat_compare_result) {
                cout << "[反例对比] SMT/Z3 vs CNF/MiniSAT SAT/UNSAT 是否一致 = "
                     << ((smt_compare_result.has_counterexample == minisat_compare_result.has_counterexample) ? "是" : "否") << endl;
            }
            if(have_kissat_compare_result && have_minisat_compare_result) {
                cout << "[反例对比] CNF/Kissat vs CNF/MiniSAT SAT/UNSAT 是否一致 = "
                     << ((kissat_compare_result.has_counterexample == minisat_compare_result.has_counterexample) ? "是" : "否") << endl;
            }
            if(have_smt_compare_result && smt_compare_result.sample_valid && have_kissat_compare_result && kissat_compare_result.sample_valid) {
                cout << "[反例对比] SMT/Z3 与 CNF/Kissat 找到的反例状态是否完全相同 = "
                     << ((smt_compare_result.counterexample_state == kissat_compare_result.counterexample_state) ? "是" : "否") << endl;
            }
            if(have_smt_compare_result && smt_compare_result.sample_valid && have_minisat_compare_result && minisat_compare_result.sample_valid) {
                cout << "[反例对比] SMT/Z3 与 CNF/MiniSAT 找到的反例状态是否完全相同 = "
                     << ((smt_compare_result.counterexample_state == minisat_compare_result.counterexample_state) ? "是" : "否") << endl;
            }
            if(have_kissat_compare_result && kissat_compare_result.sample_valid && have_minisat_compare_result && minisat_compare_result.sample_valid) {
                cout << "[反例对比] CNF/Kissat 与 CNF/MiniSAT 找到的反例状态是否完全相同 = "
                     << ((kissat_compare_result.counterexample_state == minisat_compare_result.counterexample_state) ? "是" : "否") << endl;
            }
            if(have_smt_compare_result && have_minisat_compare_result
               && smt_compare_result.has_counterexample == minisat_compare_result.has_counterexample
               && smt_compare_result.sample_valid && minisat_compare_result.sample_valid
               && smt_compare_result.counterexample_state != minisat_compare_result.counterexample_state) {
                cout << "[反例对比] 说明：SAT 模型通常不唯一；若 SAT/UNSAT 一致且两边都恢复出合法反例，状态不同不必然表示编码错误。" << endl;
            }

            cout << "[反例对比] ---------------- 总时间横向对比 ----------------" << endl;
            if(have_smt_compare_result)
                cout << "[反例对比] SMT/Z3 总验证时间(ms) = " << smt_compare_result.total_time_ms << endl;
            if(have_kissat_compare_result)
                cout << "[反例对比] CNF/Kissat 总验证时间(ms) = " << kissat_compare_result.total_time_ms << endl;
            if(have_minisat_compare_result)
                cout << "[反例对比] CNF/MiniSAT 总验证时间(ms) = " << minisat_compare_result.total_time_ms << endl;

            cout << "[反例对比] 主流程最终采用的结果来自 = "
                 << counterexampleBackendName(primary_result.backend) << endl;
            cout << "[反例对比] =====================================" << endl;
        }

        if(!driver_has_counterexample){
            /*如果是5.的话，需要，如果不是5.的话，不需要*/
            if(!counter->findvalidplan){
                cout<<"还不是最终解，对反例中不能解的状态继续求解"<<endl;
                bool sovle = sovle_counter(plan);
                plan.clear();
                plan.insert(plan.end(),counter->newplan.begin(),counter->newplan.end());

                // counter->counterissolvered=true;
                counter->newplan.clear();
                continue;
            }
            else{
                valid_plan=true;
                break;
            }
        }

		/*7.*/
		// 退出这一次求解的条件，重复在一个状态中循环，不可解状态
		if(open_closed_loop_avoidance&&havecounterfrequencycout1()){
			cout<<"重复在一个状态中循环！！！"<<endl;
			return false;
		}

		/*current_state更新为g_initial_state*/
		current_state->assign(*g_initial_state);
		// cout << "新反例更新：Initial State:" << endl;
		// for(int v=0;v<g_initial_state->vars.size();v++){
		// 	if(g_initial_state->vars[v]!=g_variable_domain[v]-1)
		// 		cout << "  " << g_variable_name[v] << ": " << g_initial_state->vars[v] << endl;
		// }
		// cout << "前一个状态：Previou State:" << endl;
		// for(int v=0;v<previous_state->vars.size();v++){
		// 	if(previous_state->vars[v]!=g_variable_domain[v]-1)
		// 		cout << "  " << g_variable_name[v] << ": " << previous_state->vars[v] << endl;
		// }
    	
		last_modified = 0;
		//plan.insert(plan.end(),subsubengine->get_plan().begin(),subsubengine->get_plan().end());
		/*plan使得该状态不能到达目标状态 | plan中有动作不适用*/
		int i=0;
		/*之前的plan，不适用当前状态，在当前状态中进行插入*/
		/**/
		// maintain_maximum=false;
		while(i<plan.size())
		{
			/*找到当前的opera下标*/
			int j;
			for(j=0;j<g_operators.size();j++)
			{
				if(g_operators[j].get_name().compare(plan[i]->get_name()) == 0) break;
			}

			/*如果前置条件和条件影响是相同的变量，则两个都检查，否则只需要检查前置条件*/
			/*满足前置条件或者即满足前置条件，又满足条件影响*/
			/*6./
			/*修改只需要满足前置条件，不要考虑条件影响*/
			// cout<<i<<"是否满足:"<<g_operators[j].is_conformant_applicable(*current_state)<<endl;
			if(g_operators[j].is_conformant_applicable(*current_state))
			{
				vector<pair <int, int> > sub_goal;
				vector<const Operator *> sub_plan;					
				
				/*617待修改，这里可能前面的状态也不满足*/
				/*前一个状态在该plan下的条件影响 */
				/*包括前置条件和条件影响*/

				/*原：仅仅考虑条件影响变量数小于等于1的*/
				/*改为贪婪的考虑所有的条件影响变量*/
				sub_goal = g_operators[j].condition_sub_goal(*previous_state);
				// cout<<i<<" "<<g_operators[j].get_name()<<": 2.sub_goal:"<<sub_goal.size()<<endl;
				
				/*原：如果有一个的条件影响是不满足的，那么后面的都不再进行子目标的求解*/
				/*修改：如果有一个的条件影响不满足，后面的也要进行子目标的求解*/
				if(maintain_maximum == false) sub_goal.clear();	
				
				//add
				// if(action_notreach.find(g_operators[j].get_name())!=action_notreach.end()){
				// 	test1++;
				// 	sub_goal.clear();	
				// } 
				/*test*/
				// cout<<"当前的action_notreach"<<endl;
				// for (auto it = action_notreach.begin(); it != action_notreach.end(); ++it)
				// 	cout << *it << endl;
				// cout<<g_operators[j].get_name()<<endl;
				// cout<<!current_state->satisfy_subgoal(sub_goal)<<endl;
				
				/*当前状态不满足这个子目标*/
				// if(counter->unapplyaction==0)
				if(!current_state->satisfy_subgoal(sub_goal))
				{
					if(g_display)
					{
						// cout << "fail to execute action:" << endl;
						// g_operators[j].dump();
						// cout << "need to maintain effect:" << endl;
						// 	for(int d = 0; d < sub_goal.size(); d++)
						// 		cout << "  " << g_variable_name[sub_goal[d].first] << ": "
						// 		<< sub_goal[d].second << endl;
					}

					/*找到这个子规划*/
					subsubengine = search_subplan(current_state,sub_goal,true,true);
					operateTimes++;
					//cout << "subsub 1 " << endl;
					/*插入到第i个动作前*/
					
					if(subsubengine->found_solution())
					{
						sub_plan = subsubengine->get_plan();
						plan.insert(plan.begin()+i,subsubengine->get_plan().begin(),subsubengine->get_plan().end());
						// cout<<i<<": 2.plan"<<endl;
						// printPlan(subsubengine->get_plan());
						//判断是否会影响到其他动作

						if(g_display)
						{
							cout << "insert the following actions into plan--confor:" << endl;
						}
						/*当前状态后移*/
						for(int k=0;k<sub_plan.size();k++)
						{
							/*下标k*/
							int h;
							for(h=0;h<g_operators.size();h++)
							{
								if(g_operators[h].get_name().compare(sub_plan[k]->get_name()) == 0) break;
							}
							if(g_display)
							{
								g_operators[h].dump();
							}
							current_state->assign(State(*current_state, g_operators[h]));
						}
						i=i+subsubengine->get_plan().size();
					}
					/*下面不满足是直接退出？*/
					else
					{
						cout<<i<<" 没有找到！"<<endl;
						yinxian1++;
						//add
						// action_notreach.insert(g_operators[j].get_name());
						if(!open_frame_relax)
							maintain_maximum = false;
					}
					
					delete subsubengine;
				}
				// cout << "apply ";
				// g_operators[j].dump();		
				// current_state->dump();		
				/*当前状态和后续状态都后移?是否要同样保证前置条件符合*/

				/*原：无论如何都会移动*/
				/*修改：只有满足才移动，否则会出现前面满足，但到这个地方不满足。这里本不回出现问题，但由于参考状态的选择，可能导致这种情况*/
				if(original_dynamic){
					current_state->assign(State(*current_state, g_operators[j]));
					previous_state->assign(State(*previous_state, g_operators[j]));
				}else{
					if(g_operators[j].is_conformant_applicable(*current_state)&&g_operators[j].is_conformant_applicable(*previous_state)){
						current_state->assign(State(*current_state, g_operators[j]));
						previous_state->assign(State(*previous_state, g_operators[j]));
					}else{
						cout<<"不能移动"<<endl;
						not_move++;
					}
				}
				
				
					
				// if(g_operators[j].is_conformant_applicable(*previous_state))
				// current_state->dump();
				i++;
			}
			/*不满足前置条件，或者前置条件中有一样的，不满足前置条件和条件影响*/
			else
			{
				cout << "not applicable";
				//g_operators[j].dump();
				vector<pair <int, int> > sub_goal;
				/*当前状态不满足的前置条件和条件影响*/
				sub_goal = g_operators[j].conformant_sub_goal(*current_state);
				if(g_display)
				{
					g_operators[j].dump();
					cout << "need to maintain minimum effect:" << endl;
						for(int d = 0; d < sub_goal.size(); d++)
							cout << "  " << g_variable_name[sub_goal[d].first] << ": "
							<< sub_goal[d].second << endl;
				}
				vector<const Operator *> sub_plan;					
				subsubengine = search_subplan(current_state,sub_goal,true,true);
				operateTimes++;
				
				/*原：如果有不满足的直接舍弃该plan*/
				/*修改：不舍弃，仅删除不满足前置条件的动作。因为有删除操作，能够寻找最大的可解度，尽可能寻找质量更好的解*/
				if (!subsubengine->found_solution())
				{
					if(g_display) 
					{
						cout << "No plan was found. Backtracking." << endl;
					}
					// return false;
					if(open_plan_optimize){
						cout<<i<<":"<<plan[i]->get_name()<<"前置条件不满足"<<endl;
						yinxian2++;
						// return false;
						while(i<plan.size())
							plan.erase(plan.begin()+i);
						break;
					}else{
						return false;
					}
					
				}
				sub_plan = subsubengine->get_plan();
				/*将子plan插入第i个动作前*/
				plan.insert(plan.begin()+i,subsubengine->get_plan().begin(),subsubengine->get_plan().end());
				// cout<<i<<": 3.plan"<<endl;
				// printPlan(sub_plan);
				if(g_display)
				{
					cout << "insert the following actions into plan:" << endl;
				}
				/*添加将当前状态后移*/
				for(int k=0;k<sub_plan.size();k++)
				{
					int h;
					for(h=0;h<g_operators.size();h++)
					{
						if(g_operators[h].get_name().compare(sub_plan[k]->get_name()) == 0) break;
					}
					if(g_display)
					{
						g_operators[h].dump();
					}
					current_state->assign(State(*current_state, g_operators[h]));
				}
				current_state->assign(State(*current_state, g_operators[j]));
				i=i+subsubengine->get_plan().size()+1;
				delete subsubengine;

			}
			// cout<<i<<endl;
			// current_state->dump();
		}
		if(g_display)
		{
			cout << "check if we need to insert actions after the plan to satisfy goal" << endl;
		}
		/*当前状态*/
		// cout<<"经过规划解后的当前状态"<<endl;
		// current_state->dump();
		/*再找一遍，查看经过上面的操作后，最终能否到达目标状态*/
		subsubengine = search_subplan(current_state,g_goal,true,true);
		operateTimes++;
		if (!subsubengine->found_solution())
		{
			if(g_display) 
			{
				cout << "No plan was found. Backtracking." << endl;
			}
			return false;
		}
		
		/*将新形成的plan与之前的plan连接*/
		subplan.insert(subplan.end(),subsubengine->get_plan().begin(),subsubengine->get_plan().end());
		// cout<<"4.plan"<<endl;
		// printPlan(subplan);
		
		/*添加：此状态作为切换子目标为总目标时的当前状态*/
		for(int k=0;k<subplan.size();k++)
		{
			int h;
			for(h=0;h<g_operators.size();h++)
			{
				if(g_operators[h].get_name().compare(subplan[k]->get_name()) == 0) break;
			}
			if(g_display)
			{
				g_operators[h].dump();
			}
			current_state->assign(State(*current_state, g_operators[h]));
		}
 		if(g_display)
		{
			if(subsubengine->get_plan().size()==0)
			{	
				cout << "Valid plan. No need to insert more action" << endl;
			}
			else
			{
				cout << "Insert the following actions into plan:" << endl;
				for(int k=0;k<subsubengine->get_plan().size();k++)
				{
					int h;
					for(h=0;h<g_operators.size();h++)
					{
						if(g_operators[h].get_name().compare(subsubengine->get_plan()[k]->get_name()) == 0) break;
					}
					g_operators[h].dump();
				}
			}
		}
		delete subsubengine;
	}
	/*迭代完成后，判断反例集合是否能解决，如果有未完成的，还要对这一部分进行求解*/

	// plan.insert(plan.end(),subplan.begin(),subplan.end());
	subplan.clear();
	if(!valid_plan) return false;
    ofstream outfile;
    outfile.open("finalplan", ios::out);
    for(int k=0;k<plan.size();k++)
    {
		cout << plan[k]->get_name() << endl;
		outfile << plan[k]->get_name() << endl;
    }
    outfile.close();     
	// counter->optimizePlan(plan);
	// counter->optimizePlantest(plan);
	// counter->conputerCounter(plan,false);
	// counter->optimizePlan(counter->newplan);
	int k=0;
	for(map<string,state_var>::iterator t=counter->appearcounter.begin();t!=counter->appearcounter.end();t++){
		// cout<<"状态"<<k<<"出现在反例集中的次数："<<t->second.frequency<<endl;
		if(t->second.frequency>1)
			k++; 
	}
	// smt_simplifier = false;
	// counter->conputerCounter(plan, false);
	// counter->testPlanisvalid(plan);
	// cout<<"test1:"<<test1<<endl;
	ifstream infile;
    infile.open("oneofcombine", ios::in);
    string line;
    /*读取类型*/
    getline(infile, line);
	infile.close();

	// cout<<"不能移动:"<<not_move<<endl;
	// cout<<"是否找到landmark:"<<counter->findfinallandmark<<endl;
	// cout << "oneof_combine:" << line << endl;
	// cout << "影响1:" << yinxian1 << endl;
	// cout<<"影响2:"<<yinxian2<<endl;
	// cout<<"删除不满足前置条件的动作数:"<<counter->unapplyaction<<endl;
	// cout<<"最终反例集大小:"<<counter->appearcounter.size()<<endl;
	// cout<<"反例集中出现次数大于1的反例数:"<<k<<endl;
	// cout<<"检测到可精简plan次数:"<<counter->sum<<endl;
	// cout<<"belief_size:"<<counter->getBelief_size()<<endl;
	// cout<<"operate size:"<<operateTimes<<endl;
	// cout<<"final plan: plan_size "<<plan.size()<< endl;
	// cout<<"iteration:"<<iteration<<endl;
	// cout<<"fail_time:"<<fail_time<<endl;
	// cout<<"simply_time:"<< counter->simplifytime/1000.0 <<endl;
	// cout<<"landmark time:"<< counter->landmarktime /1000.0 <<endl;
	printFinalTimingSummary(counter);

	//ofstream outfile;       
	outfile.open("C_Plan", ios::out);
	int numberofactions = 0;
	for(int i=0;i<plan.size();i++)
	{
		int h;
		for(h=0;h<g_operators.size();h++)
		{
			if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
		}
		if (g_operators[h].index_number ==-1)
		{
			g_operators[h].index_number = numberofactions;
			numberofactions++;
		}
	}
	outfile << "0" << endl;
	outfile << "%%" <<endl;
	outfile << numberofactions << " ";
	int action_count = 0;
	for(int i=0;i<plan.size();i++)
	{
		int h;
		for(h=0;h<g_operators.size();h++)
		{
			if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
		}
		if (g_operators[h].index_number >=action_count) 
		{
			outfile << "(" << g_operators[h].get_name() << ") ";
			action_count++;
		}
	}
	outfile << endl;
	outfile << "%%" <<endl;
	outfile << "linear " << plan.size() << " ";
	for(int i=0;i<plan.size();i++)
	{
		int h;
		for(h=0;h<g_operators.size();h++)
		{
			if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
		}
		outfile << g_operators[h].index_number << " ";
	}
	outfile.close();
	return true;	
}


/*subengine：求解s0的求解器，原版本*/
bool solve_belief_state(BestFirstSearchEngine* subengine)
{
     //show_action();
     cout << "Open belief states" << endl;
     ifstream infile;

     std::string name;
	 /*var：对应g_variable_name下标,val：该变量的值*/
     vector<pair<int,int> > prev_values;
     vector<pair<int,int> > new_values;
     State* current_state;
     State* previous_state;
     State* check_plan_state;
     vector<const Operator *> plan;
     vector<const Operator *> subplan;
     bool first = true;
     bool maintain_maximum = true;
     BestFirstSearchEngine *subsubengine;

//     cout << "Initial " << endl;
//     g_initial_state->dump();

     int iter = 0;
     int belief_size = 0;
     int last_modified = 0;
     bool valid_plan = false;
	 
	 /*将s0的plan插入*/
     subplan.insert(subplan.end(),subengine->get_plan().begin(),subengine->get_plan().end());

	 /*将当前状态赋值为初始状态*/
     current_state = new State(); 
     current_state->assign(*g_initial_state);
	 /*前一个状态也赋值为初始状态*/
	 previous_state = new State();
     previous_state->assign(*g_initial_state);
     /*这个也是初始状态*/
	 check_plan_state = new State();
     check_plan_state->assign(*g_initial_state);
     int operateTimes=1;
	 do 
     {
		cout << "iteration " << iter << endl;
		
		/*读取belief文件中所有的初始状态*/
		infile.open("belief", ios::in);
		int bstate =0;     
		
		/*新的开始*/
		subplan.insert(subplan.end(),plan.begin(),plan.end());
		plan.clear();
		
		/*遍历belief中的每一个状态*/
		/*修改：改变这里每次循环，不再是读取belief，而是每次反例添加后，再对这个反例插入，并且再用的plan验证所有的反例，最后调用一次SMT求解器*/
		while(getline(infile, name))
		{
			// 已经读取完一个状态
			

			if(name == "END_BELIEF") {
				/*每次循环都要调用一次*/
				
				
				/*如果是第一次，不搜索*/
				if(first)
				{
					// cout << "Initial State:" << endl;
    				// g_initial_state->dump();
					belief_size++;
					//cout << "first time, no search" << endl;
					first = false;
					/*赋予prev刚刚读取的状态*/
					prev_values = new_values;
					//restore values when there is axiom
					
					/*初始化g_initial_state*/
					g_initial_state->vars = g_original_values;
					//restore values when there is axiom
					for(int i=0;i<prev_values.size();i++)
					{
						g_initial_state->negate_var(prev_values[i].first);
					}
					new_values = vector<pair<int, int> > ();
					
				}
				else
				{
					// cout << "Initial State:" << endl;
   					//  g_initial_state->dump();
					/*第0次循环就要一直增加belief_size的大小*/
					if(iter==0) belief_size++;
					/*last_modified == belief_size，确定plan满足belief_size个状态，退出，*/
					
					/*第iter==0时不可能，因为有一个不满足就会赋予last_modified=0*/
					/*用于后两次循环*/
					if(last_modified == belief_size)
					{
						valid_plan = true;
						break;
					}
					/*保存s0状态的所有变量赋值*/
					g_original_values = g_initial_state->vars;
					/*设置为当前状态，用于规划器求解*/
					current_state->assign(*g_initial_state);
					if(g_display)
					{
						current_state->dump();
					}
					plan.insert(plan.end(),subplan.begin(),subplan.end());

					//check plan
					bool fill_in = false; //是否之前的规划满足当前状态 this variable determines if the previous plan satisfies current initial state
					/*赋值为当前状态，检查是否之前的plan满足当前状态*/
					check_plan_state->assign(*g_initial_state);
					if(g_display)
					{
						cout << "check if previous plan satisfies current initial state " << endl;
								//cout << "current state" << endl;
								//check_plan_state->dump();
					}
					/*检查之前的plan是否满足现在的
						改用SMT，这一步没必要，因为当前这个初始状态肯定是不满足的*/
					for(int i=0;i<plan.size();i++)
					{ 
						/*找到操作下标*/
						int j;
						for(j=0;j<g_operators.size();j++)
						{
							if(g_operators[j].get_name().compare(plan[i]->get_name()) == 0) break;
						}
						/*操作可用，check_plan_state后移*/
						if(g_operators[j].is_applicable(*check_plan_state))
						{
							check_plan_state->assign(State(*check_plan_state,g_operators[j]));
									//cout << "current state" << endl;
										//check_plan_state->dump();
						}
						/*不可用*/
						else
						{
							if(g_display)
							{
								cout << "No. Fail at:" << endl;
								g_operators[j].dump();
							}
							fill_in = true;
							break;
						}
					}
					/*plan所有动作都适用*/
					if(fill_in == false)
					{
						/*到达的状态包含目标状态，转而对下一个状态处理，last_modified++*/
						if(check_plan_state->satisfy_subgoal(g_goal))
						{
							/*满足的状态值+1*/
							last_modified++;
							if(g_display)
							{
										/*cout << "final state:" << endl;
										check_plan_state->dump();
										dump_goal();*/
								cout << "previous plan satisfies current initial state " << endl;
							}
							/*状态已经满足，previous_state赋值为当前状态，进入下一次循环*/
							previous_state->assign(*g_initial_state);
							prev_values = new_values;
							/*初始化g_initial_state*/
							for(int i=0;i<prev_values.size();i++)
							{
								g_initial_state->negate_var(prev_values[i].first);
							}
							new_values = vector<pair<int, int> > ();
							subplan.clear();
							continue;
						}
					}
					//check plan

					/**/
					last_modified = 0;
					//plan.insert(plan.end(),subsubengine->get_plan().begin(),subsubengine->get_plan().end());
					
					/*plan使得该状态不能到达目标状态 | plan中有动作不适用*/
					int i=0;
					/*之前的plan，不适用当前状态，在当前状态中进行插入*/
					/**/
					while(i<plan.size())
					{
						/*找到当前的opera下标*/
						int j;
						for(j=0;j<g_operators.size();j++)
						{
							if(g_operators[j].get_name().compare(plan[i]->get_name()) == 0) break;
						}

						/*如果前置条件和条件影响是相同的变量，则两个都检查，否则只需要检查前置条件*/
						/*满足前置条件或者即满足前置条件，又满足条件影响*/
						if(g_operators[j].is_conformant_applicable(*current_state))
						{
							vector<pair <int, int> > sub_goal;
							vector<const Operator *> sub_plan;					
							/*前一个状态在该plan下的条件影响 */
							sub_goal = g_operators[j].condition_sub_goal(*previous_state);
							
							/*如果有一个的条件影响是不满足的，那么后面的都不再进行子目标的求解*/
							/*？？？？*/
							if(maintain_maximum == false) sub_goal.clear();				
							
							/*当前状态不满足这个子目标*/
							if(!current_state->satisfy_subgoal(sub_goal))
							{
								if(g_display)
								{
									// cout << "fail to execute action:" << endl;
									// g_operators[j].dump();
									// cout << "need to maintain effect:" << endl;
									// 	for(int d = 0; d < sub_goal.size(); d++)
									// 		cout << "  " << g_variable_name[sub_goal[d].first] << ": "
									// 		<< sub_goal[d].second << endl;
								}

								/*找到这个子规划*/
								subsubengine = search_subplan(current_state,sub_goal,true,true);
								operateTimes++;
								//cout << "subsub 1 " << endl;
								/*插入到第i个动作前*/
								if(subsubengine->found_solution())
								{
									sub_plan = subsubengine->get_plan();
									/*insert(a,b,c)  将b-c插入到a位置*/
									plan.insert(plan.begin()+i,subsubengine->get_plan().begin(),subsubengine->get_plan().end());
									if(g_display)
									{
										cout << "insert the following actions into plan--confor:" << endl;
									}
									/*当前状态后移*/
									for(int k=0;k<sub_plan.size();k++)
									{
										/*下标k*/
										int h;
										for(h=0;h<g_operators.size();h++)
										{
											if(g_operators[h].get_name().compare(sub_plan[k]->get_name()) == 0) break;
										}
										if(g_display)
										{
											g_operators[h].dump();
										}
										current_state->assign(State(*current_state, g_operators[h]));
									}
									i=i+subsubengine->get_plan().size();
								}
								/*下面不满足是直接退出？*/
								else
								{
									cout<<"没有找到！"<<endl;
									// maintain_maximum = false;
								}
								
								delete subsubengine;
							} 
							//cout << "apply ";
							//g_operators[j].dump();				
							/*当前状态和后续状态都后移*/
							current_state->assign(State(*current_state, g_operators[j]));
							previous_state->assign(State(*previous_state, g_operators[j]));
							//current_state->dump();
							i++;
						}
						/*不满足前置条件*/
						else
						{
							//cout << "not applicable";
							//g_operators[j].dump();
							vector<pair <int, int> > sub_goal;
							/*当前状态不满足的前置条件和条件影响*/
							sub_goal = g_operators[j].conformant_sub_goal(*current_state);
							if(g_display)
							{
								g_operators[j].dump();
								cout << "need to maintain minimum effect:" << endl;
									for(int d = 0; d < sub_goal.size(); d++)
										cout << "  " << g_variable_name[sub_goal[d].first] << ": "
										<< sub_goal[d].second << endl;
							}
							vector<const Operator *> sub_plan;					
							subsubengine = search_subplan(current_state,sub_goal,true,true);
							operateTimes++;
							//cout << " subsub 2" << endl;
							if (!subsubengine->found_solution())
							{
								if(g_display) 
								{
									cout << "No plan was found. Backtracking." << endl;
								}
								i++;
								continue;
								// return false;
							}
							sub_plan = subsubengine->get_plan();
							/*将子plan插入第i个动作前*/
							plan.insert(plan.begin()+i,subsubengine->get_plan().begin(),subsubengine->get_plan().end());
							if(g_display)
							{
								cout << "insert the following actions into plan:" << endl;
							}
							/*将当前状态后移*/
							for(int k=0;k<sub_plan.size();k++)
							{
								int h;
								for(h=0;h<g_operators.size();h++)
								{
									if(g_operators[h].get_name().compare(sub_plan[k]->get_name()) == 0) break;
								}
								if(g_display)
								{
									g_operators[h].dump();
								}
								current_state->assign(State(*current_state, g_operators[h]));
							}
							current_state->assign(State(*current_state, g_operators[j]));
							i=i+subsubengine->get_plan().size()+1;
							
							delete subsubengine;

						}
					}
					if(g_display)
					{
						cout << "check if we need to insert actions after the plan to satisfy goal" << endl;
					}

					/*再找一遍，查看经过上面的操作后，最终能否到达目标状态*/
					subsubengine = search_subplan(current_state,g_goal,true,true);
					operateTimes++;
					if (!subsubengine->found_solution())
					{
						if(g_display) 
						{
							cout << "No plan was found. Backtracking." << endl;
						}
						return false;
					}
					prev_values = new_values;
					
					/*初始化*/
					//restore values
					g_initial_state->vars = g_original_values;
					//restore values
					for(int i=0;i<prev_values.size();i++)
					{
						g_initial_state->negate_var(prev_values[i].first);
					}
					new_values = vector<pair<int, int> > ();
					subplan.clear();
					
					/*将新形成的plan与之前的plan连接*/
					subplan.insert(subplan.end(),subsubengine->get_plan().begin(),subsubengine->get_plan().end());
					/*此状态前满足的状态*/
					
					if(g_display)
					{
						if(subsubengine->get_plan().size()==0)
						{	
							cout << "Valid plan. No need to insert more action" << endl;
						}
						else
						{
							cout << "Insert the following actions into plan:" << endl;
							for(int k=0;k<subsubengine->get_plan().size();k++)
							{
								int h;
								for(h=0;h<g_operators.size();h++)
								{
									if(g_operators[h].get_name().compare(subsubengine->get_plan()[k]->get_name()) == 0) break;
								}
								g_operators[h].dump();
							}
						}
					}
					delete subsubengine;
				}
				
			}
			/*还没有将一个完整的状态读入*/
			/*修改：不需要读取，只需要把这个当成反例输入，变成新的初始状态
			  var是变量的下标 val是变量的值
			*/
			else
			{
				/*修改：学习这个对初始状态进行插入*/
				int var,val;
				var = -1;		
					
				for(int i = 0 ; i < g_variable_name.size() ; i++)
				{
					/*读取的name后面有一个空格，长度会+1*/
					if(name.find(g_variable_name[i]) == 0 && name.size() == g_variable_name[i].size()+1)
					{
						var = i;
						// cout << g_variable_name[i]<<" ";
					}
				}
				getline(infile, name);
				stringstream ss(name);
				ss >> val;
				// cout << val << endl;
				if (var!=-1) {
					g_initial_state->set_var(var,val);
					/*var：对应g_variable_name下标,val：该变量的值*/
					new_values.push_back(make_pair(var,val));
				}
			}
		}
		plan.insert(plan.end(),subplan.begin(),subplan.end());

		subplan.clear();
		infile.close();
		iter++;
    }
    while(iter < 3);
	// Counter *counter = new Counter;
	// counter->conputerCounter(plan);
	
	if(!valid_plan) return false;
    ofstream outfile;
    outfile.open("finalplan", ios::out);
    for(int k=0;k<plan.size();k++)
    {
		cout << plan[k]->get_name() << endl;
		outfile << plan[k]->get_name() << endl;
    }
     outfile.close();     
		cout<<"belief_size:"<<belief_size<<endl;
	cout<<"operate size:"<<operateTimes<<endl;
	cout << "final plan: plan_size "<<plan.size()<< endl;
	//ofstream outfile;       
	outfile.open("C_Plan", ios::out);
	int numberofactions = 0;
	for(int i=0;i<plan.size();i++)
	{
		int h;
		for(h=0;h<g_operators.size();h++)
		{
			if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
		}
		if (g_operators[h].index_number ==-1)
		{
			g_operators[h].index_number = numberofactions;
			numberofactions++;
		}
	}
	outfile << "0" << endl;
	outfile << "%%" <<endl;
	outfile << numberofactions << " ";
	int action_count = 0;
	for(int i=0;i<plan.size();i++)
	{
		int h;
		for(h=0;h<g_operators.size();h++)
		{
			if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
		}
		if (g_operators[h].index_number >=action_count) 
		{
			outfile << "(" << g_operators[h].get_name() << ") ";
			action_count++;
		}
	}
	outfile << endl;
	outfile << "%%" <<endl;
	outfile << "linear " << plan.size() << " ";
	for(int i=0;i<plan.size();i++)
	{
		int h;
		for(h=0;h<g_operators.size();h++)
		{
			if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
		}
		outfile << g_operators[h].index_number << " ";
	}
	outfile.close();
	return true;	
}



int save_plan(const vector<const Operator *> &plan, const string& filename, int iteration) {
    ofstream outfile;
    int plan_cost = 0;
    bool separate_outfiles = true; // IPC conditions, change to false for a single outfile.
    cout<<"g_use_metric:"<<g_use_metric<<endl;
	if(separate_outfiles) {
		// Write a separat output file for each plan found by iterative search
		stringstream it_no;
		it_no << iteration;
		outfile.open((filename + "." + it_no.str()).c_str(), ios::out);
    }
    else {
		// Write newest plan always to same output file
		outfile.open(filename.c_str(), ios::out);
    }
    for(int i = 0; i < plan.size(); i++) {
		int action_cost =  plan[i]->get_cost();
		/*metric是什么*/
		if(g_use_metric)
			action_cost--; // Note: action costs have all been increased by 1 to deal with 0-cost actions
		plan_cost += action_cost;
		if(!g_use_metric)
			cout << plan[i]->get_name() << endl;
		else
			cout << plan[i]->get_name() << " (" 
			<< action_cost << ")" << endl;
		outfile << "(" << plan[i]->get_name() << ")" << endl;
    }
    outfile.close();
    if(!g_use_metric)
		cout << "Plan length: " << plan.size() << " step(s)." << endl;
    else 
		cout << "Plan length: " << plan.size() << " step(s), cost: " 
	     << plan_cost << "." << endl;
    return plan_cost;
}

void print_heuristics_used(bool ff_heuristic, bool ff_preferred_operators, 
			   bool landmarks_heuristic, 
			   bool landmarks_preferred_operators) {
    cout << "Using the following heuristic(s):" << endl;
    if(ff_heuristic) {
		cout << "FF heuristic ";
		if(ff_preferred_operators)
			cout << "with preferred operators";
		cout << endl;
    }
    if(landmarks_heuristic) {
	cout << "Landmark heuristic ";
	if(landmarks_preferred_operators)
	    cout << "with preferred operators";
	cout << endl;
    }
}

static string makeSubplanCacheKey(const State &state,
                                  vector<pair<int, int> > subgoal,
                                  bool ff_heuristic,
                                  bool ff_preferred_operators) {
    sort(subgoal.begin(), subgoal.end());
    stringstream key;
    key << (ff_heuristic ? 1 : 0) << ':' << (ff_preferred_operators ? 1 : 0) << '|';
    for(int i = 0; i < (int)state.vars.size(); ++i) {
        key << state.vars[i] << ',';
    }
    key << '|';
    for(int i = 0; i < (int)subgoal.size(); ++i) {
        key << subgoal[i].first << '=' << subgoal[i].second << ',';
    }
    return key.str();
}

static BestFirstSearchEngine *makeCachedSubplanEngine(const CachedSubplanResult &cached) {
    BestFirstSearchEngine *subengine = new BestFirstSearchEngine;
    if(cached.found) {
        subengine->set_cached_plan(cached.plan);
    }
    return subengine;
}

BestFirstSearchEngine *search_subplan(State *init_state, vector<pair<int, int> > subgoal, bool ff_heuristic, bool ff_preferred_operators) {
    const string cache_key = makeSubplanCacheKey(*init_state, subgoal, ff_heuristic, ff_preferred_operators);
    map<string, CachedSubplanResult>::const_iterator cached = g_subplan_cache.find(cache_key);
    if(cached != g_subplan_cache.end()) {
        ++g_subplan_cache_hits;
        return makeCachedSubplanEngine(cached->second);
    }

    ++g_subplan_cache_misses;

    if(init_state->satisfy_subgoal(subgoal)) {
        CachedSubplanResult satisfied;
        satisfied.found = true;
        if(g_subplan_cache.size() < SUBPLAN_CACHE_MAX_ENTRIES) {
            g_subplan_cache.insert(make_pair(cache_key, satisfied));
        }
        return makeCachedSubplanEngine(satisfied);
    }
    
    //initialize subint & subgoal
    State* temp;
    temp = g_initial_state;
    g_initial_state = init_state;
    vector<pair<int, int> > tmpgoal;
    
    tmpgoal.insert(tmpgoal.end(),g_goal.begin(),g_goal.end());
    g_goal.clear();
    g_goal.insert(g_goal.begin(),subgoal.begin(),subgoal.end());

    BestFirstSearchEngine *subengine;
    subengine = new BestFirstSearchEngine;
	/*再启动一次搜索*/
    subengine->add_heuristic(ff_heuristic, ff_preferred_operators);
    subengine->search();

    g_initial_state = temp;
    g_goal.clear();
    g_goal.insert(g_goal.begin(),tmpgoal.begin(),tmpgoal.end());

    if(g_subplan_cache.size() < SUBPLAN_CACHE_MAX_ENTRIES) {
        CachedSubplanResult result;
        result.found = subengine->found_solution();
        if(result.found) {
            result.plan = subengine->get_plan();
        }
        g_subplan_cache.insert(make_pair(cache_key, result));
    }
    
    return subengine;
}
