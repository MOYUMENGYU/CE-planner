#include "glucose_counter.h"
#include "cnf_builder.h"
#include "sat_var_manager.h"
#include "cnf_logger.h"
#include "globals.h"

GlucoseCounter::GlucoseCounter()
    : solver_(0), last_result_(0), active_vars_() {
#ifdef USE_GLUCOSE
    solver_ = new Glucose::Solver();
#endif
}

GlucoseCounter::~GlucoseCounter() {
#ifdef USE_GLUCOSE
    if (solver_ != 0) {
        delete solver_;
        solver_ = 0;
    }
#endif
}

void GlucoseCounter::clear() {
#ifdef USE_GLUCOSE
    if (solver_ != 0) delete solver_;
    solver_ = new Glucose::Solver();
#endif
    last_result_ = 0;
    active_vars_.clear();
}

bool GlucoseCounter::load_cnf(const CnfBuilder &cnf) {
#ifdef USE_GLUCOSE
    if (solver_ == 0) solver_ = new Glucose::Solver();

    const std::vector<ClauseRecord> &clauses = cnf.clauses();
    int max_var = cnf.declared_max_var();
    std::size_t i, j;
    active_vars_.assign(max_var + 1, 0);
    for (i = 0; i < clauses.size(); ++i) {
        for (j = 0; j < clauses[i].lits.size(); ++j) {
            int lit = clauses[i].lits[j];
            int var = lit > 0 ? lit : -lit;
            if (var > max_var) {
                max_var = var;
                active_vars_.resize(max_var + 1, 0);
            }
            if (var >= 0 && var < (int)active_vars_.size()) active_vars_[var] = 1;
        }
    }
    while (solver_->nVars() < max_var) solver_->newVar();

    CNF_LOG_BASIC("[Glucose] 开始装载CNF，子句总数=" << clauses.size());
    for (i = 0; i < clauses.size(); ++i) {
        Glucose::vec<Glucose::Lit> ps;
        for (j = 0; j < clauses[i].lits.size(); ++j) {
            int lit = clauses[i].lits[j];
            int var_index = lit > 0 ? (lit - 1) : ((-lit) - 1);
            bool sign = (lit < 0);
            ps.push(Glucose::mkLit(var_index, sign));
        }
        if (!solver_->addClause(ps)) {
            CNF_LOG_BASIC("[Glucose] 装载子句时检测到不可满足。子句索引=" << i);
            last_result_ = 20;
            return true;
        }
    }
    return true;
#else
    (void)cnf;
    CNF_LOG_BASIC("[Glucose] 当前未定义 USE_GLUCOSE，无法真正调用 Glucose。请在 Makefile 中启用 ENABLE_GLUCOSE=1，并配置 GLUCOSE_ROOT/GLUCOSE_LIB。");
    return false;
#endif
}

int GlucoseCounter::solve() {
#ifdef USE_GLUCOSE
    if (solver_ == 0) {
        last_result_ = 0;
        return last_result_;
    }
    CNF_LOG_BASIC("[Glucose] 开始求解...");
    bool sat = solver_->solve();
    last_result_ = sat ? 10 : 20;
    if (last_result_ == 10) CNF_LOG_BASIC("[Glucose] 求解结果: SAT，发现反例。");
    else CNF_LOG_BASIC("[Glucose] 求解结果: UNSAT，没有反例。候选计划通过验证。");
    return last_result_;
#else
    last_result_ = 0;
    return last_result_;
#endif
}

int GlucoseCounter::value_of_var(int var_id) const {
#ifdef USE_GLUCOSE
    if (solver_ == 0 || last_result_ != 10) return 0;

    if (var_id <= 0 || var_id > solver_->nVars()) return 0;
    Glucose::lbool value = solver_->modelValue(var_id - 1);
    int ivalue = Glucose::toInt(value);

    if (ivalue == 0) return var_id;   // true
    if (ivalue == 1) return -var_id;  // false
    return 0;                         // undef
#else
    (void)var_id;
    return 0;
#endif
}

bool GlucoseCounter::extract_time0_sample(const SatVarManager &vm,
                                          std::map<int,int> *sample,
                                          std::map<int,int> *conflict_counter) const {
    sample->clear();
    conflict_counter->clear();
    if (last_result_ != 10) {
        CNF_LOG_MODEL("[Glucose-模型] 当前结果不是SAT，跳过模型恢复。");
        return false;
    }

    CNF_LOG_MODEL("[Glucose-模型] 开始恢复 t=0 反例状态。");
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
                CNF_LOG_MODEL("[Glucose-模型] 冲突: 变量 " << g_variable_name[info.fact.var]
                              << " 在 t=0 同时出现多个取值。旧值=" << it->second
                              << "，新值=" << info.fact.val);
            } else {
                (*sample)[info.fact.var] = info.fact.val;
                CNF_LOG_MODEL("[Glucose-模型] 恢复: " << g_variable_name[info.fact.var]
                              << " = " << info.fact.val);
            }
        }
    }

    if (!conflict_counter->empty()) {
        CNF_LOG_MODEL("[Glucose-模型] 错误: time0 存在取值冲突，模型恢复失败。");
        return false;
    }

    CNF_LOG_MODEL("[Glucose-模型] 恢复完成，共恢复 " << sample->size() << " 个 time0 变量。");
    return true;
}

bool GlucoseCounter::is_available() const {
#ifdef USE_GLUCOSE
    return true;
#else
    return false;
#endif
}
