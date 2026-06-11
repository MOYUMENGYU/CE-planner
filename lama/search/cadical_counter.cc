#include "cadical_counter.h"
#include "cnf_builder.h"
#include "sat_var_manager.h"
#include "cnf_logger.h"
#include "globals.h"

namespace {
#ifdef USE_CADICAL
static CaDiCaL::Solver *create_cadical_solver() {
    CaDiCaL::Solver *solver = new CaDiCaL::Solver();
    solver->set("quiet", 1);
    return solver;
}
#endif
}

CaDiCaLCounter::CaDiCaLCounter()
    : solver_(0), last_result_(0), active_vars_() {
#ifdef USE_CADICAL
    solver_ = create_cadical_solver();
#endif
}

CaDiCaLCounter::~CaDiCaLCounter() {
#ifdef USE_CADICAL
    if (solver_ != 0) {
        delete solver_;
        solver_ = 0;
    }
#endif
}

void CaDiCaLCounter::clear() {
#ifdef USE_CADICAL
    if (solver_ != 0) {
        delete solver_;
        solver_ = 0;
    }
    solver_ = create_cadical_solver();
#endif
    last_result_ = 0;
    active_vars_.clear();
}

bool CaDiCaLCounter::load_cnf(const CnfBuilder &cnf) {
#ifdef USE_CADICAL
    if (solver_ == 0) {
        solver_ = new CaDiCaL::Solver();
        solver_->set("quiet", 1);
    }

    last_result_ = 0;

    const std::vector<ClauseRecord> &clauses = cnf.clauses();
    std::size_t i, j;

    // 1) 先扫描本轮 CNF 中出现的最大变量编号，并记录真正参与本轮 CNF 的变量
    int max_var = cnf.declared_max_var();
    active_vars_.assign(max_var + 1, 0);
    for (i = 0; i < clauses.size(); ++i) {
        for (j = 0; j < clauses[i].lits.size(); ++j) {
            int lit = clauses[i].lits[j];
            int var = (lit > 0) ? lit : -lit;
            if (var > max_var) {
                max_var = var;
                active_vars_.resize(max_var + 1, 0);
            }
            if (var >= 0 && var < (int)active_vars_.size()) active_vars_[var] = 1;
        }
    }

    CNF_LOG_BASIC("[CaDiCaL] 开始装载CNF，子句总数=" << clauses.size()
                  << "，最大变量编号=" << max_var);

    // 2) 先显式声明用户变量
    //
    // 对当前这版 CaDiCaL，在 factor/factorcheck 场景下，
    // 直接 add(lit) 会因为“undeclared variable”而 fatal。
    //
    // 不使用 reserve（你的版本没有），也不优先用 resize，
    // 而是按官方建议使用 declare_more_variables。
    if (max_var > 0) {
        int current_max = solver_->vars();
        if (current_max < max_var) {
            int need_more = max_var - current_max;
            solver_->declare_more_variables(need_more);
        }
    }

    // 3) 再逐子句灌入
    for (i = 0; i < clauses.size(); ++i) {
        for (j = 0; j < clauses[i].lits.size(); ++j) {
            solver_->add(clauses[i].lits[j]);
        }
        solver_->add(0);
    }

    return true;
#else
    (void)cnf;
    CNF_LOG_BASIC("[CaDiCaL] 当前未定义 USE_CADICAL，无法真正调用 CaDiCaL。请在 Makefile 中启用 ENABLE_CADICAL=1，并配置 CADICAL_ROOT/CADICAL_LIB。");
    return false;
#endif
}

int CaDiCaLCounter::solve() {
#ifdef USE_CADICAL
    if (solver_ == 0) {
        last_result_ = 0;
        return last_result_;
    }

    CNF_LOG_BASIC("[CaDiCaL] 开始求解...");
    last_result_ = solver_->solve();

    if (last_result_ == 10)
        CNF_LOG_BASIC("[CaDiCaL] 求解结果: SAT，发现反例。");
    else if (last_result_ == 20)
        CNF_LOG_BASIC("[CaDiCaL] 求解结果: UNSAT，没有反例。候选计划通过验证。");
    else
        CNF_LOG_BASIC("[CaDiCaL] 求解结果: UNKNOWN/ERROR，返回值=" << last_result_);

    return last_result_;
#else
    last_result_ = 0;
    return last_result_;
#endif
}

int CaDiCaLCounter::value_of_var(int var_id) const {
#ifdef USE_CADICAL
    if (solver_ == 0 || last_result_ != 10) return 0;

    if (var_id <= 0 || var_id > solver_->vars()) return 0;
    int value = solver_->val(var_id);
    if (value > 0) return var_id;
    if (value < 0) return -var_id;
    return 0;
#else
    (void)var_id;
    return 0;
#endif
}

bool CaDiCaLCounter::extract_time0_sample(const SatVarManager &vm,
                                          std::map<int, int> *sample,
                                          std::map<int, int> *conflict_counter) const {
    sample->clear();
    conflict_counter->clear();

    if (last_result_ != 10) {
        CNF_LOG_MODEL("[CaDiCaL-模型] 当前结果不是SAT，跳过模型恢复。");
        return false;
    }

    CNF_LOG_MODEL("[CaDiCaL-模型] 开始恢复 t=0 反例状态。");

    int var_index;
    for (var_index = 1; var_index <= vm.max_var(); ++var_index) {
        if (var_index >= (int)active_vars_.size() || !active_vars_[var_index]) continue;
        if (!vm.has_info(var_index)) continue;
        if (!vm.is_fact_var(var_index)) continue;

        const SatVarInfo &info = vm.get_info(var_index);
        if (info.fact.time != 0) continue;

        if (value_of_var(var_index) > 0) {
            std::map<int, int>::iterator it = sample->find(info.fact.var);
            if (it != sample->end()) {
                (*conflict_counter)[info.fact.var]++;
                CNF_LOG_MODEL("[CaDiCaL-模型] 冲突: 变量 "
                              << g_variable_name[info.fact.var]
                              << " 在 t=0 同时出现多个取值。旧值=" << it->second
                              << "，新值=" << info.fact.val);
            } else {
                (*sample)[info.fact.var] = info.fact.val;
                CNF_LOG_MODEL("[CaDiCaL-模型] 恢复: "
                              << g_variable_name[info.fact.var]
                              << " = " << info.fact.val);
            }
        }
    }

    if (!conflict_counter->empty()) {
        CNF_LOG_MODEL("[CaDiCaL-模型] 错误: time0 存在取值冲突，模型恢复失败。");
        return false;
    }

    CNF_LOG_MODEL("[CaDiCaL-模型] 恢复完成，共恢复 "
                  << sample->size() << " 个 time0 变量。");
    return true;
}

bool CaDiCaLCounter::is_available() const {
#ifdef USE_CADICAL
    return true;
#else
    return false;
#endif
}