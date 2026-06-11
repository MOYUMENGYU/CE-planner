#include "kissat_counter.h"
#include "cnf_builder.h"
#include "sat_var_manager.h"
#include "cnf_logger.h"
#include "globals.h"


#ifdef USE_KISSAT
static void configure_kissat_quiet(kissat *solver) {
    if (solver == 0) return;
    kissat_set_option(solver, "quiet", 1);
    kissat_set_option(solver, "verbose", 0);
    kissat_set_option(solver, "log", 0);
    kissat_set_option(solver, "statistics", 0);
}
#endif


KissatCounter::KissatCounter() : solver_(0), last_result_(0), active_vars_() {
#ifdef USE_KISSAT
    solver_ = kissat_init();
    configure_kissat_quiet(solver_);
#endif
}

KissatCounter::~KissatCounter() {
#ifdef USE_KISSAT
    if (solver_ != 0) {
        kissat_release(solver_);
        solver_ = 0;
    }
#endif
}

void KissatCounter::clear() {
#ifdef USE_KISSAT
    if (solver_ != 0) kissat_release(solver_);
    solver_ = kissat_init();
    configure_kissat_quiet(solver_);
#endif
    last_result_ = 0;
    active_vars_.clear();
}

bool KissatCounter::load_cnf(const CnfBuilder &cnf) {
#ifdef USE_KISSAT
    const std::vector<ClauseRecord> &clauses = cnf.clauses();
    std::size_t i, j;
    int declared_max_var = cnf.declared_max_var();
    std::vector<char> seen(declared_max_var + 1, 0);
    active_vars_.assign(declared_max_var + 1, 0);
    CNF_LOG_BASIC("[Kissat] 开始装载CNF，子句总数=" << clauses.size());
    for (i = 0; i < clauses.size(); ++i) {
        for (j = 0; j < clauses[i].lits.size(); ++j) {
            int lit = clauses[i].lits[j];
            int var = lit > 0 ? lit : -lit;
            if (var >= (int)seen.size()) {
                seen.resize(var + 1, 0);
                active_vars_.resize(var + 1, 0);
            }
            if (var >= 0 && var < (int)seen.size()) {
                seen[var] = 1;
                active_vars_[var] = 1;
            }
            kissat_add(solver_, lit);
        }
        kissat_add(solver_, 0);
    }
    for (i = 1; i < seen.size(); ++i) {
        if (seen[i]) continue;
        kissat_add(solver_, (int)i);
        kissat_add(solver_, -(int)i);
        kissat_add(solver_, 0);
    }
    return true;
#else
    CNF_LOG_BASIC("[Kissat] 当前未定义 USE_KISSAT，无法真正调用 Kissat。请在 Makefile 中加入 -DUSE_KISSAT，并正确配置 kissat.h 与 libkissat。");
    (void)cnf;
    return false;
#endif
}

int KissatCounter::solve() {
#ifdef USE_KISSAT
    CNF_LOG_BASIC("[Kissat] 开始求解...");
    last_result_ = kissat_solve(solver_);
    if (last_result_ == 10) CNF_LOG_BASIC("[Kissat] 求解结果: SAT，发现反例。");
    else if (last_result_ == 20) CNF_LOG_BASIC("[Kissat] 求解结果: UNSAT，没有反例。候选计划通过验证。");
    else CNF_LOG_BASIC("[Kissat] 求解结果: UNKNOWN/ERROR，返回值=" << last_result_);
    return last_result_;
#else
    last_result_ = 0;
    return last_result_;
#endif
}

int KissatCounter::value_of_var(int var_id) const {
#ifdef USE_KISSAT
    if (last_result_ != 10) return 0;
    return kissat_value((kissat *)solver_, var_id);
#else
    (void)var_id;
    return 0;
#endif
}

bool KissatCounter::extract_time0_sample(const SatVarManager &vm, std::map<int,int> *sample, std::map<int,int> *conflict_counter) const {
    sample->clear();
    conflict_counter->clear();
    if (last_result_ != 10) {
        CNF_LOG_MODEL("[Kissat-模型] 当前结果不是SAT，跳过模型恢复。");
        return false;
    }
    CNF_LOG_MODEL("[Kissat-模型] 开始恢复 t=0 反例状态。");
    int var_index;
    for (var_index = 1; var_index <= vm.max_var(); ++var_index) {
        if (var_index >= (int)active_vars_.size() || !active_vars_[var_index]) continue;
        if (!vm.has_info(var_index)) continue;
        if (!vm.is_fact_var(var_index)) continue;
        const SatVarInfo &info = vm.get_info(var_index);
        if (info.fact.time != 0) continue;
        if (value_of_var(var_index) > 0) {
            std::map<int,int>::iterator it = sample->find(info.fact.var);
            if (it != sample->end()) {
                (*conflict_counter)[info.fact.var]++;
                CNF_LOG_MODEL("[Kissat-模型] 冲突: 变量 " << g_variable_name[info.fact.var] << " 在 t=0 同时出现多个取值。旧值=" << it->second << "，新值=" << info.fact.val);
            } else {
                (*sample)[info.fact.var] = info.fact.val;
                CNF_LOG_MODEL("[Kissat-模型] 恢复: " << g_variable_name[info.fact.var] << " = " << info.fact.val);
            }
        }
    }
    if (!conflict_counter->empty()) {
        CNF_LOG_MODEL("[Kissat-模型] 错误: time0 存在取值冲突，模型恢复失败。");
        return false;
    }
    CNF_LOG_MODEL("[Kissat-模型] 恢复完成，共恢复 " << sample->size() << " 个 time0 变量。");
    return true;
}


bool KissatCounter::is_available() const {
#ifdef USE_KISSAT
    return true;
#else
    return false;
#endif
}
