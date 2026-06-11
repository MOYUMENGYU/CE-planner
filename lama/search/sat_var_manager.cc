#include "sat_var_manager.h"
#include "cnf_logger.h"
#include "globals.h"
#include <cassert>
#include <sstream>
#include <vector>

namespace {
static bool cnf_preserve_labels() {
    return g_cnf_log_detail || g_cnf_log_clause || g_cnf_log_model;
}
static bool cnf_should_log_detail_event(int count) {
    return count < 200;
}
}


SatVarManager::SatVarManager()
    : next_var_id_(1), fact_var_count_(0), aux_var_count_(0),
      detail_fact_new_log_count_(0), detail_fact_reuse_log_count_(0), detail_aux_new_log_count_(0),
      stable_aux_to_id_(), persistent_aux_ids_() {
}

void SatVarManager::clear() {
    fact_to_id_.clear();
    id_to_info_.clear();
    stable_aux_to_id_.clear();
    persistent_aux_ids_.clear();
    next_var_id_ = 1;
    fact_var_count_ = 0;
    aux_var_count_ = 0;
    detail_fact_new_log_count_ = 0;
    detail_fact_reuse_log_count_ = 0;
    detail_aux_new_log_count_ = 0;
}

void SatVarManager::recompute_counters_and_next_id() {
    fact_var_count_ = 0;
    aux_var_count_ = 0;
    next_var_id_ = 1;
    std::map<int, SatVarInfo>::const_iterator it;
    for (it = id_to_info_.begin(); it != id_to_info_.end(); ++it) {
        if (it->second.kind == SATVAR_KIND_FACT) ++fact_var_count_;
        else ++aux_var_count_;
        if (it->first >= next_var_id_) next_var_id_ = it->first + 1;
    }
}

void SatVarManager::begin_round_preserve_stable() {
    std::vector<int> erase_ids;
    std::map<int, SatVarInfo>::const_iterator it;
    for (it = id_to_info_.begin(); it != id_to_info_.end(); ++it) {
        if (it->second.kind != SATVAR_KIND_FACT && persistent_aux_ids_.find(it->first) == persistent_aux_ids_.end())
            erase_ids.push_back(it->first);
    }
    std::size_t i;
    for (i = 0; i < erase_ids.size(); ++i) id_to_info_.erase(erase_ids[i]);
    recompute_counters_and_next_id();
    detail_fact_new_log_count_ = 0;
    detail_fact_reuse_log_count_ = 0;
    detail_aux_new_log_count_ = 0;
}

void SatVarManager::mark_all_current_aux_vars_persistent() {
    std::map<int, SatVarInfo>::const_iterator it;
    for (it = id_to_info_.begin(); it != id_to_info_.end(); ++it) {
        if (it->second.kind != SATVAR_KIND_FACT) persistent_aux_ids_.insert(it->first);
    }
}

int SatVarManager::get_fact_var(int var, int val, int time) {
    FactKey key(var, val, time);
    std::map<FactKey, int>::iterator it = fact_to_id_.find(key);
    if (it != fact_to_id_.end()) {
        if (cnf_should_log_detail_event(detail_fact_reuse_log_count_))
            CNF_LOG_DETAIL("[CNF-变量] 复用事实变量 id=" << it->second << ", 含义=" << fact_to_string(var, val, time));
        ++detail_fact_reuse_log_count_;
        return it->second;
    }

    SatVarInfo info;
    info.id = next_var_id_;
    info.kind = SATVAR_KIND_FACT;
    info.fact = key;
    if (cnf_preserve_labels()) info.label = fact_to_string(var, val, time);

    fact_to_id_[key] = info.id;
    id_to_info_[info.id] = info;
    ++next_var_id_;
    ++fact_var_count_;

    if (cnf_should_log_detail_event(detail_fact_new_log_count_))
        CNF_LOG_DETAIL("[CNF-变量] 新建事实变量 id=" << info.id << ", 含义=" << fact_to_string(var, val, time));
    ++detail_fact_new_log_count_;
    return info.id;
}

int SatVarManager::new_aux_var(SatVarKind kind, const std::string &label) {
    SatVarInfo info;
    info.id = next_var_id_;
    info.kind = kind;
    if (cnf_preserve_labels()) info.label = label;

    id_to_info_[info.id] = info;
    ++next_var_id_;
    ++aux_var_count_;

    if (cnf_should_log_detail_event(detail_aux_new_log_count_))
        CNF_LOG_DETAIL("[CNF-变量] 新建辅助变量 id=" << info.id << ", 类型=" << (int)kind << ", 含义=" << label);
    ++detail_aux_new_log_count_;
    return info.id;
}

int SatVarManager::get_or_create_stable_aux_var(const std::string &stable_key, SatVarKind kind, const std::string &label, bool *created) {
    if (created) *created = false;
    std::map<std::string, int>::const_iterator it = stable_aux_to_id_.find(stable_key);
    if (it != stable_aux_to_id_.end()) {
        persistent_aux_ids_.insert(it->second);
        return it->second;
    }

    SatVarInfo info;
    info.id = next_var_id_;
    info.kind = kind;
    if (cnf_preserve_labels()) info.label = label;

    id_to_info_[info.id] = info;
    stable_aux_to_id_[stable_key] = info.id;
    persistent_aux_ids_.insert(info.id);
    ++next_var_id_;
    ++aux_var_count_;
    if (created) *created = true;

    if (cnf_should_log_detail_event(detail_aux_new_log_count_))
        CNF_LOG_DETAIL("[CNF-变量] 新建稳定辅助变量 id=" << info.id << ", 类型=" << (int)kind << ", key=" << stable_key << ", 含义=" << label);
    ++detail_aux_new_log_count_;
    return info.id;
}

bool SatVarManager::is_fact_var(int id) const {
    std::map<int, SatVarInfo>::const_iterator it = id_to_info_.find(id);
    if (it == id_to_info_.end()) return false;
    return it->second.kind == SATVAR_KIND_FACT;
}

bool SatVarManager::has_info(int id) const {
    return id_to_info_.find(id) != id_to_info_.end();
}

const SatVarInfo &SatVarManager::get_info(int id) const {
    std::map<int, SatVarInfo>::const_iterator it = id_to_info_.find(id);
    assert(it != id_to_info_.end());
    return it->second;
}

int SatVarManager::max_var() const {
    return next_var_id_ - 1;
}

std::string SatVarManager::fact_to_string(int var, int val, int time) const {
    std::ostringstream oss;
    oss << "(";
    if (var >= 0 && var < (int)g_variable_name.size()) oss << g_variable_name[var];
    else oss << "var#" << var;
    oss << "=" << val << ", t=" << time << ")";
    return oss.str();
}

std::string SatVarManager::lit_to_string(int lit) const {
    std::ostringstream oss;
    if (lit < 0) oss << "¬";
    int var = lit < 0 ? -lit : lit;
    if (!has_info(var)) {
        oss << "x" << var;
        return oss.str();
    }
    const SatVarInfo &info = get_info(var);
    if (info.kind == SATVAR_KIND_FACT) {
        if (!info.label.empty()) oss << info.label;
        else oss << fact_to_string(info.fact.var, info.fact.val, info.fact.time);
    } else {
        oss << "aux#" << var;
        if (!info.label.empty()) oss << "{" << info.label << "}";
    }
    return oss.str();
}

void SatVarManager::dump_var_map(std::ostream &os) const {
    std::map<int, SatVarInfo>::const_iterator it;
    for (it = id_to_info_.begin(); it != id_to_info_.end(); ++it) {
        os << it->first << " ";
        if (it->second.kind == SATVAR_KIND_FACT) os << "FACT ";
        else os << "AUX ";
        os << it->second.label << std::endl;
    }
}

int SatVarManager::num_fact_vars() const { return fact_var_count_; }
int SatVarManager::num_aux_vars() const { return aux_var_count_; }

void SatVarManager::export_snapshot(SatVarManagerSnapshot *out) const {
    if (!out) return;
    out->fact_to_id = fact_to_id_;
    out->id_to_info = id_to_info_;
    out->next_var_id = next_var_id_;
    out->fact_var_count = fact_var_count_;
    out->aux_var_count = aux_var_count_;
    out->stable_aux_to_id = stable_aux_to_id_;
    out->persistent_aux_ids = persistent_aux_ids_;
}

void SatVarManager::import_snapshot(const SatVarManagerSnapshot &in) {
    fact_to_id_ = in.fact_to_id;
    id_to_info_ = in.id_to_info;
    next_var_id_ = in.next_var_id;
    fact_var_count_ = in.fact_var_count;
    aux_var_count_ = in.aux_var_count;
    stable_aux_to_id_ = in.stable_aux_to_id;
    persistent_aux_ids_ = in.persistent_aux_ids;
    detail_fact_new_log_count_ = 0;
    detail_fact_reuse_log_count_ = 0;
    detail_aux_new_log_count_ = 0;
}
