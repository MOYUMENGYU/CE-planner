#include "cnf_builder.h"
#include "sat_var_manager.h"
#include "cnf_logger.h"
#include <algorithm>
#include <sstream>

namespace {
static bool cnf_store_debug_notes() {
    return g_cnf_log_detail || g_cnf_log_clause;
}
static bool cnf_should_log_detail_event(int count) {
    return count < 20;
}
}

CnfBuilder::CnfBuilder(SatVarManager *vm)
    : vm_(vm), singleton_and_fold_count_(0), singleton_or_fold_count_(0), duplicate_clause_skip_count_(0),
      gate_input_duplicate_removed_count_(0), complementary_and_fold_count_(0), complementary_or_fold_count_(0), complementary_gate_saved_clause_count_(0),
      shared_and_gate_hit_count_(0), shared_or_gate_hit_count_(0), shared_gate_saved_var_count_(0), shared_gate_saved_clause_count_(0),
      and_gate_request_count_(0), or_gate_request_count_(0), no_dedup_clause_append_count_(0), gate_cache_(), declared_max_var_(0),
      detail_duplicate_log_count_(0), detail_clause_add_log_count_(0), detail_gate_log_count_(0) {}

void CnfBuilder::clear() {
    clauses_.clear();
    clause_stats_.clear();
    clause_set_.clear();
    singleton_and_fold_count_ = 0;
    singleton_or_fold_count_ = 0;
    duplicate_clause_skip_count_ = 0;
    gate_input_duplicate_removed_count_ = 0;
    complementary_and_fold_count_ = 0;
    complementary_or_fold_count_ = 0;
    complementary_gate_saved_clause_count_ = 0;
    shared_and_gate_hit_count_ = 0;
    shared_or_gate_hit_count_ = 0;
    shared_gate_saved_var_count_ = 0;
    shared_gate_saved_clause_count_ = 0;
    and_gate_request_count_ = 0;
    or_gate_request_count_ = 0;
    no_dedup_clause_append_count_ = 0;
    gate_cache_.clear();
    declared_max_var_ = 0;
    detail_duplicate_log_count_ = 0;
    detail_clause_add_log_count_ = 0;
    detail_gate_log_count_ = 0;
}

bool CnfBuilder::normalize_clause(const std::vector<int> &in, std::vector<int> *out) const {
    out->clear();
    std::vector<int> tmp = in;
    std::sort(tmp.begin(), tmp.end());
    std::size_t i;
    for (i = 0; i < tmp.size(); ++i) {
        int lit = tmp[i];
        if (lit == 0) continue;
        if (!out->empty() && out->back() == lit) continue;
        if (std::binary_search(tmp.begin(), tmp.end(), -lit)) return false;
        out->push_back(lit);
    }
    return !out->empty();
}

void CnfBuilder::normalize_gate_inputs(const std::vector<int> &in, std::vector<int> *out, bool *has_complementary_pair, int *removed_duplicates) const {
    out->clear();
    if (has_complementary_pair) *has_complementary_pair = false;
    if (removed_duplicates) *removed_duplicates = 0;

    std::vector<int> tmp;
    tmp.reserve(in.size());
    std::size_t i;
    for (i = 0; i < in.size(); ++i)
        if (in[i] != 0) tmp.push_back(in[i]);

    std::sort(tmp.begin(), tmp.end());
    for (i = 0; i < tmp.size(); ++i) {
        int lit = tmp[i];
        if (!out->empty() && out->back() == lit) {
            if (removed_duplicates) ++(*removed_duplicates);
            continue;
        }
        out->push_back(lit);
    }

    for (i = 0; i < out->size(); ++i) {
        if (std::binary_search(out->begin(), out->end(), -(*out)[i])) {
            if (has_complementary_pair) *has_complementary_pair = true;
            return;
        }
    }
}

void CnfBuilder::add_normalized_clause(const std::vector<int> &normalized, ClauseKind kind, const std::string &note) {
    if (normalized.empty()) return;

    std::pair< std::set< std::vector<int> >::iterator, bool > insert_result = clause_set_.insert(normalized);
    if (!insert_result.second) {
        ++duplicate_clause_skip_count_;
        if (cnf_should_log_detail_event(detail_duplicate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] 跳过重复子句，说明=" << note);
        ++detail_duplicate_log_count_;
        return;
    }

    std::size_t max_i;
    for (max_i = 0; max_i < normalized.size(); ++max_i) {
        int v = normalized[max_i] > 0 ? normalized[max_i] : -normalized[max_i];
        if (v > declared_max_var_) declared_max_var_ = v;
    }

    ClauseRecord rec;
    rec.lits = normalized;
    rec.kind = kind;
    if (cnf_store_debug_notes()) rec.note = note;
    clauses_.push_back(rec);
    clause_stats_[kind]++;

    if (cnf_should_log_detail_event(detail_clause_add_log_count_))
        CNF_LOG_DETAIL("[CNF-子句] 新增子句 #" << clauses_.size() << ", 类型=" << (int)kind << ", 长度=" << rec.lits.size() << ", 说明=" << note);
    ++detail_clause_add_log_count_;
    if (g_cnf_log_clause) {
        std::ostringstream oss;
        oss << "[CNF-子句] 内容: ";
        std::size_t i;
        for (i = 0; i < rec.lits.size(); ++i) {
            if (i) oss << " OR ";
            oss << vm_->lit_to_string(rec.lits[i]);
        }
        CNF_LOG_CLAUSE(oss.str());
    }
}


void CnfBuilder::add_normalized_clause_no_dedup(const std::vector<int> &normalized, ClauseKind kind, const std::string &note) {
    if (normalized.empty()) return;

    std::size_t max_i;
    for (max_i = 0; max_i < normalized.size(); ++max_i) {
        int v = normalized[max_i] > 0 ? normalized[max_i] : -normalized[max_i];
        if (v > declared_max_var_) declared_max_var_ = v;
    }

    ClauseRecord rec;
    rec.lits = normalized;
    rec.kind = kind;
    if (cnf_store_debug_notes()) rec.note = note;
    clauses_.push_back(rec);
    clause_stats_[kind]++;
    ++no_dedup_clause_append_count_;

    /* P6.1: no-dedup is a hot path.  Do not print per-clause detail here;
       CounterCNF prints an aggregated P6 summary after construction. */
}
void CnfBuilder::add_clause(const std::vector<int> &lits, ClauseKind kind, const std::string &note) {
    std::vector<int> normalized;
    if (!normalize_clause(lits, &normalized)) {
        CNF_LOG_CLAUSE("[CNF-子句] 跳过空子句或重言式子句，说明=" << note);
        return;
    }
    add_normalized_clause(normalized, kind, note);
}

void CnfBuilder::add_unit(int lit, ClauseKind kind, const std::string &note) {
    if (lit == 0) return;
    std::vector<int> normalized;
    normalized.push_back(lit);
    add_normalized_clause(normalized, kind, note);
}

void CnfBuilder::add_binary(int a, int b, ClauseKind kind, const std::string &note) {
    if (a == 0 && b == 0) return;
    if (a == 0) { add_unit(b, kind, note); return; }
    if (b == 0) { add_unit(a, kind, note); return; }
    if (a == -b) {
        CNF_LOG_CLAUSE("[CNF-子句] 跳过二元重言式子句，说明=" << note);
        return;
    }
    if (a == b) { add_unit(a, kind, note); return; }
    if (b < a) {
        int tmp = a;
        a = b;
        b = tmp;
    }
    std::vector<int> normalized;
    normalized.reserve(2);
    normalized.push_back(a);
    normalized.push_back(b);
    add_normalized_clause(normalized, kind, note);
}

void CnfBuilder::add_ternary(int a, int b, int c_lit, ClauseKind kind, const std::string &note) {
    int arr[3];
    int n = 0;
    if (a != 0) arr[n++] = a;
    if (b != 0) arr[n++] = b;
    if (c_lit != 0) arr[n++] = c_lit;
    if (n == 0) return;
    if (n == 1) { add_unit(arr[0], kind, note); return; }

    if (n >= 2 && arr[1] < arr[0]) { int t = arr[0]; arr[0] = arr[1]; arr[1] = t; }
    if (n == 3) {
        if (arr[2] < arr[1]) { int t = arr[1]; arr[1] = arr[2]; arr[2] = t; }
        if (arr[1] < arr[0]) { int t = arr[0]; arr[0] = arr[1]; arr[1] = t; }
    }

    int out[3];
    int m = 0;
    int i, j;
    for (i = 0; i < n; ++i) {
        int lit = arr[i];
        if (m > 0 && out[m - 1] == lit) continue;
        for (j = 0; j < m; ++j) {
            if (out[j] == -lit) {
                CNF_LOG_CLAUSE("[CNF-子句] 跳过三元重言式子句，说明=" << note);
                return;
            }
        }
        out[m++] = lit;
    }

    if (m == 0) return;
    if (m == 1) { add_unit(out[0], kind, note); return; }
    if (m == 2) { add_binary(out[0], out[1], kind, note); return; }

    std::vector<int> normalized;
    normalized.reserve(3);
    normalized.push_back(out[0]);
    normalized.push_back(out[1]);
    normalized.push_back(out[2]);
    add_normalized_clause(normalized, kind, note);
}

void CnfBuilder::add_binary_no_dedup(int a, int b, ClauseKind kind, const std::string &note) {
    if (a == 0 && b == 0) return;
    if (a == 0) { add_unit(b, kind, note); return; }
    if (b == 0) { add_unit(a, kind, note); return; }
    if (a == -b) {
        CNF_LOG_CLAUSE("[CNF-P6] 跳过二元重言式no-dedup子句，说明=" << note);
        return;
    }
    if (a == b) { add_unit(a, kind, note); return; }
    if (b < a) {
        int tmp = a;
        a = b;
        b = tmp;
    }
    std::vector<int> normalized;
    normalized.reserve(2);
    normalized.push_back(a);
    normalized.push_back(b);
    add_normalized_clause_no_dedup(normalized, kind, note);
}

void CnfBuilder::add_ternary_no_dedup(int a, int b, int c_lit, ClauseKind kind, const std::string &note) {
    int arr[3];
    int n = 0;
    if (a != 0) arr[n++] = a;
    if (b != 0) arr[n++] = b;
    if (c_lit != 0) arr[n++] = c_lit;
    if (n == 0) return;
    if (n == 1) { add_unit(arr[0], kind, note); return; }

    if (n >= 2 && arr[1] < arr[0]) { int t = arr[0]; arr[0] = arr[1]; arr[1] = t; }
    if (n == 3) {
        if (arr[2] < arr[1]) { int t = arr[1]; arr[1] = arr[2]; arr[2] = t; }
        if (arr[1] < arr[0]) { int t = arr[0]; arr[0] = arr[1]; arr[1] = t; }
    }

    int out[3];
    int m = 0;
    int i, j;
    for (i = 0; i < n; ++i) {
        int lit = arr[i];
        if (m > 0 && out[m - 1] == lit) continue;
        for (j = 0; j < m; ++j) {
            if (out[j] == -lit) {
                CNF_LOG_CLAUSE("[CNF-P6] 跳过三元重言式no-dedup子句，说明=" << note);
                return;
            }
        }
        out[m++] = lit;
    }

    if (m == 0) return;
    if (m == 1) { add_unit(out[0], kind, note); return; }
    if (m == 2) { add_binary_no_dedup(out[0], out[1], kind, note); return; }

    std::vector<int> normalized;
    normalized.reserve(3);
    normalized.push_back(out[0]);
    normalized.push_back(out[1]);
    normalized.push_back(out[2]);
    add_normalized_clause_no_dedup(normalized, kind, note);
}

void CnfBuilder::add_equiv_or2_fast(int lhs, int rhs1, int rhs2, ClauseKind kind, const std::string &note) {
    add_ternary(-lhs, rhs1, rhs2, kind, note.empty() ? std::string() : note + " : lhs -> rhs1 OR rhs2");
    add_binary(lhs, -rhs1, kind, note.empty() ? std::string() : note + " : rhs1 -> lhs");
    add_binary(lhs, -rhs2, kind, note.empty() ? std::string() : note + " : rhs2 -> lhs");
}

void CnfBuilder::add_equiv_and2_fast(int lhs, int rhs1, int rhs2, ClauseKind kind, const std::string &note) {
    add_binary(-lhs, rhs1, kind, note.empty() ? std::string() : note + " : lhs -> rhs1");
    add_binary(-lhs, rhs2, kind, note.empty() ? std::string() : note + " : lhs -> rhs2");
    add_ternary(lhs, -rhs1, -rhs2, kind, note.empty() ? std::string() : note + " : rhs1 AND rhs2 -> lhs");
}

void CnfBuilder::add_equiv_and2_no_dedup(int lhs, int rhs1, int rhs2, ClauseKind kind, const std::string &note) {
    add_binary_no_dedup(-lhs, rhs1, kind, note.empty() ? std::string() : note + " : lhs -> rhs1");
    add_binary_no_dedup(-lhs, rhs2, kind, note.empty() ? std::string() : note + " : lhs -> rhs2");
    add_ternary_no_dedup(lhs, -rhs1, -rhs2, kind, note.empty() ? std::string() : note + " : rhs1 AND rhs2 -> lhs");
}

int CnfBuilder::make_and_gate(const std::vector<int> &inputs, SatVarKind aux_kind, ClauseKind clause_kind, const std::string &label) {
    ++and_gate_request_count_;
    std::vector<int> normalized_inputs;
    bool has_complementary_pair = false;
    int removed_duplicates = 0;
    normalize_gate_inputs(inputs, &normalized_inputs, &has_complementary_pair, &removed_duplicates);

    if (removed_duplicates > 0) {
        gate_input_duplicate_removed_count_ += removed_duplicates;
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] AND门输入去重，删除重复字面量次数=" << removed_duplicates << "，说明=" << label);
        ++detail_gate_log_count_;
    }

    if (has_complementary_pair) {
        ++complementary_and_fold_count_;
        complementary_gate_saved_clause_count_ += (int)normalized_inputs.size();
        int out_false = vm_->new_aux_var(aux_kind, label);
        add_unit(-out_false, clause_kind, label + " : AND输入含互补文字，恒为假");
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] AND门互补折叠，直接生成恒假输出 x" << out_false << "，说明=" << label);
        ++detail_gate_log_count_;
        return out_false;
    }

    if (normalized_inputs.empty()) {
        int out_empty = vm_->new_aux_var(aux_kind, label);
        add_unit(out_empty, clause_kind, label + " : 空AND恒为真");
        return out_empty;
    }
    if (normalized_inputs.size() == 1) {
        ++singleton_and_fold_count_;
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] AND门单输入折叠，直接复用 " << vm_->lit_to_string(normalized_inputs[0]) << "，说明=" << label);
        ++detail_gate_log_count_;
        return normalized_inputs[0];
    }

    GateCacheKey cache_key;
    cache_key.gate_type = 0;
    cache_key.aux_kind = aux_kind;
    cache_key.inputs = normalized_inputs;
    std::map<GateCacheKey, int>::const_iterator it_and = gate_cache_.find(cache_key);
    if (it_and != gate_cache_.end()) {
        ++shared_and_gate_hit_count_;
        ++shared_gate_saved_var_count_;
        shared_gate_saved_clause_count_ += (int)normalized_inputs.size() + 1;
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] AND门结构共享，复用已有辅助变量 x" << it_and->second << "，输入数量=" << normalized_inputs.size() << "，说明=" << label);
        ++detail_gate_log_count_;
        return it_and->second;
    }

    int out = vm_->new_aux_var(aux_kind, label);
    std::size_t i;
    for (i = 0; i < normalized_inputs.size(); ++i)
        add_binary(-out, normalized_inputs[i], clause_kind, label + " : out -> in");
    std::vector<int> back;
    back.push_back(out);
    for (i = 0; i < normalized_inputs.size(); ++i)
        back.push_back(-normalized_inputs[i]);
    add_clause(back, clause_kind, label + " : all in -> out");
    gate_cache_[cache_key] = out;
    if (cnf_should_log_detail_event(detail_gate_log_count_))
        CNF_LOG_DETAIL("[CNF-门] 构造AND门 out=x" << out << ", 输入数量=" << normalized_inputs.size() << ", 说明=" << label);
    ++detail_gate_log_count_;
    return out;
}

int CnfBuilder::make_or_gate(const std::vector<int> &inputs, SatVarKind aux_kind, ClauseKind clause_kind, const std::string &label) {
    ++or_gate_request_count_;
    std::vector<int> normalized_inputs;
    bool has_complementary_pair = false;
    int removed_duplicates = 0;
    normalize_gate_inputs(inputs, &normalized_inputs, &has_complementary_pair, &removed_duplicates);

    if (removed_duplicates > 0) {
        gate_input_duplicate_removed_count_ += removed_duplicates;
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] OR门输入去重，删除重复字面量次数=" << removed_duplicates << "，说明=" << label);
        ++detail_gate_log_count_;
    }

    if (has_complementary_pair) {
        ++complementary_or_fold_count_;
        complementary_gate_saved_clause_count_ += (int)normalized_inputs.size();
        int out_true = vm_->new_aux_var(aux_kind, label);
        add_unit(out_true, clause_kind, label + " : OR输入含互补文字，恒为真");
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] OR门互补折叠，直接生成恒真输出 x" << out_true << "，说明=" << label);
        ++detail_gate_log_count_;
        return out_true;
    }

    if (normalized_inputs.empty()) {
        int out_empty = vm_->new_aux_var(aux_kind, label);
        add_unit(-out_empty, clause_kind, label + " : 空OR恒为假");
        return out_empty;
    }
    if (normalized_inputs.size() == 1) {
        ++singleton_or_fold_count_;
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] OR门单输入折叠，直接复用 " << vm_->lit_to_string(normalized_inputs[0]) << "，说明=" << label);
        ++detail_gate_log_count_;
        return normalized_inputs[0];
    }

    GateCacheKey cache_key;
    cache_key.gate_type = 1;
    cache_key.aux_kind = aux_kind;
    cache_key.inputs = normalized_inputs;
    std::map<GateCacheKey, int>::const_iterator it_or = gate_cache_.find(cache_key);
    if (it_or != gate_cache_.end()) {
        ++shared_or_gate_hit_count_;
        ++shared_gate_saved_var_count_;
        shared_gate_saved_clause_count_ += (int)normalized_inputs.size() + 1;
        if (cnf_should_log_detail_event(detail_gate_log_count_))
            CNF_LOG_DETAIL("[CNF-化简] OR门结构共享，复用已有辅助变量 x" << it_or->second << "，输入数量=" << normalized_inputs.size() << "，说明=" << label);
        ++detail_gate_log_count_;
        return it_or->second;
    }

    int out = vm_->new_aux_var(aux_kind, label);
    std::size_t i;
    for (i = 0; i < normalized_inputs.size(); ++i)
        add_binary(out, -normalized_inputs[i], clause_kind, label + " : in -> out");
    std::vector<int> back;
    back.push_back(-out);
    for (i = 0; i < normalized_inputs.size(); ++i)
        back.push_back(normalized_inputs[i]);
    add_clause(back, clause_kind, label + " : out -> any in");
    gate_cache_[cache_key] = out;
    if (cnf_should_log_detail_event(detail_gate_log_count_))
        CNF_LOG_DETAIL("[CNF-门] 构造OR门 out=x" << out << ", 输入数量=" << normalized_inputs.size() << ", 说明=" << label);
    ++detail_gate_log_count_;
    return out;
}

void CnfBuilder::add_exactly_one(const std::vector<int> &vars, ClauseKind atleast_kind, ClauseKind atmost_kind, const std::string &note) {
    if (vars.empty()) return;
    add_clause(vars, atleast_kind, note + " : 至少一个");
    std::size_t i, j;
    for (i = 0; i < vars.size(); ++i)
        for (j = i + 1; j < vars.size(); ++j)
            add_binary(-vars[i], -vars[j], atmost_kind, note + " : 至多一个");
}

void CnfBuilder::replace_clauses_preserve_stats(const std::vector<ClauseRecord> &new_clauses) {
    clauses_ = new_clauses;
    clause_stats_.clear();
    clause_set_.clear();
    declared_max_var_ = 0;
    std::size_t i, j;
    for (i = 0; i < clauses_.size(); ++i) {
        clause_stats_[clauses_[i].kind]++;
        clause_set_.insert(clauses_[i].lits);
        for (j = 0; j < clauses_[i].lits.size(); ++j) {
            int v = clauses_[i].lits[j] > 0 ? clauses_[i].lits[j] : -clauses_[i].lits[j];
            if (v > declared_max_var_) declared_max_var_ = v;
        }
    }
}

int CnfBuilder::declared_max_var() const { return declared_max_var_; }
void CnfBuilder::set_declared_max_var(int max_var) {
    if (max_var > declared_max_var_) declared_max_var_ = max_var;
}

int CnfBuilder::num_clauses() const { return (int)clauses_.size(); }
const std::vector<ClauseRecord> &CnfBuilder::clauses() const { return clauses_; }
int CnfBuilder::clauses_of_kind(ClauseKind kind) const {
    std::map<ClauseKind, int>::const_iterator it = clause_stats_.find(kind);
    if (it == clause_stats_.end()) return 0;
    return it->second;
}

void CnfBuilder::dump_dimacs(std::ostream &os) const {
    os << "p cnf " << vm_->max_var() << " " << clauses_.size() << std::endl;
    std::size_t i, j;
    for (i = 0; i < clauses_.size(); ++i) {
        for (j = 0; j < clauses_[i].lits.size(); ++j) os << clauses_[i].lits[j] << " ";
        os << "0" << std::endl;
    }
}

void CnfBuilder::dump_clause_stats(std::ostream &os) const {
    std::map<ClauseKind, int>::const_iterator it;
    for (it = clause_stats_.begin(); it != clause_stats_.end(); ++it)
        os << "kind=" << (int)it->first << ", count=" << it->second << std::endl;
}

int CnfBuilder::singleton_and_fold_count() const { return singleton_and_fold_count_; }
int CnfBuilder::singleton_or_fold_count() const { return singleton_or_fold_count_; }
int CnfBuilder::duplicate_clause_skip_count() const { return duplicate_clause_skip_count_; }
int CnfBuilder::gate_input_duplicate_removed_count() const { return gate_input_duplicate_removed_count_; }
int CnfBuilder::complementary_and_fold_count() const { return complementary_and_fold_count_; }
int CnfBuilder::complementary_or_fold_count() const { return complementary_or_fold_count_; }
int CnfBuilder::complementary_gate_saved_clause_count() const { return complementary_gate_saved_clause_count_; }
int CnfBuilder::shared_and_gate_hit_count() const { return shared_and_gate_hit_count_; }
int CnfBuilder::shared_or_gate_hit_count() const { return shared_or_gate_hit_count_; }
int CnfBuilder::shared_gate_saved_var_count() const { return shared_gate_saved_var_count_; }
int CnfBuilder::shared_gate_saved_clause_count() const { return shared_gate_saved_clause_count_; }
int CnfBuilder::and_gate_request_count() const { return and_gate_request_count_; }
int CnfBuilder::or_gate_request_count() const { return or_gate_request_count_; }
int CnfBuilder::no_dedup_clause_append_count() const { return no_dedup_clause_append_count_; }

void CnfBuilder::export_snapshot(CnfBuilderSnapshot *out) const {
    if (!out) return;
    out->clauses = clauses_;
    out->declared_max_var = declared_max_var_;
}

void CnfBuilder::import_snapshot(const CnfBuilderSnapshot &in) {
    clear();
    clauses_ = in.clauses;
    declared_max_var_ = in.declared_max_var;
    for (std::size_t i = 0; i < clauses_.size(); ++i) {
        clause_set_.insert(clauses_[i].lits);
        clause_stats_[clauses_[i].kind]++;
    }
}
