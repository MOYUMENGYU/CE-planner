#ifndef CNF_BUILDER_H
#define CNF_BUILDER_H

#include <map>
#include <set>
#include <vector>
#include <string>
#include <ostream>
#include "cnf_types.h"

class SatVarManager;


struct CnfBuilderSnapshot {
    std::vector<ClauseRecord> clauses;
    int declared_max_var;
    CnfBuilderSnapshot() : clauses(), declared_max_var(0) {}
};

class CnfBuilder {
public:
    explicit CnfBuilder(SatVarManager *vm);
    void clear();
    void add_clause(const std::vector<int> &lits, ClauseKind kind, const std::string &note);
    void add_unit(int lit, ClauseKind kind, const std::string &note);
    void add_binary(int a, int b, ClauseKind kind, const std::string &note);
    void add_ternary(int a, int b, int c, ClauseKind kind, const std::string &note);
    void add_binary_no_dedup(int a, int b, ClauseKind kind, const std::string &note);
    void add_ternary_no_dedup(int a, int b, int c, ClauseKind kind, const std::string &note);
    void add_equiv_or2_fast(int lhs, int rhs1, int rhs2, ClauseKind kind, const std::string &note);
    void add_equiv_and2_fast(int lhs, int rhs1, int rhs2, ClauseKind kind, const std::string &note);
    void add_equiv_and2_no_dedup(int lhs, int rhs1, int rhs2, ClauseKind kind, const std::string &note);
    int make_and_gate(const std::vector<int> &inputs, SatVarKind aux_kind, ClauseKind clause_kind, const std::string &label);
    int make_or_gate(const std::vector<int> &inputs, SatVarKind aux_kind, ClauseKind clause_kind, const std::string &label);
    void add_exactly_one(const std::vector<int> &vars, ClauseKind atleast_kind, ClauseKind atmost_kind, const std::string &note);
    int num_clauses() const;
    const std::vector<ClauseRecord> &clauses() const;
    void replace_clauses_preserve_stats(const std::vector<ClauseRecord> &new_clauses);
    int declared_max_var() const;
    void set_declared_max_var(int max_var);
    int clauses_of_kind(ClauseKind kind) const;
    void dump_dimacs(std::ostream &os) const;
    void dump_clause_stats(std::ostream &os) const;

    void export_snapshot(CnfBuilderSnapshot *out) const;
    void import_snapshot(const CnfBuilderSnapshot &in);

    int singleton_and_fold_count() const;
    int singleton_or_fold_count() const;
    int duplicate_clause_skip_count() const;
    int gate_input_duplicate_removed_count() const;
    int complementary_and_fold_count() const;
    int complementary_or_fold_count() const;
    int complementary_gate_saved_clause_count() const;
    int shared_and_gate_hit_count() const;
    int shared_or_gate_hit_count() const;
    int shared_gate_saved_var_count() const;
    int shared_gate_saved_clause_count() const;
    int and_gate_request_count() const;
    int or_gate_request_count() const;
    int no_dedup_clause_append_count() const;

private:
    struct GateCacheKey {
        int gate_type;
        SatVarKind aux_kind;
        std::vector<int> inputs;
        GateCacheKey() : gate_type(0), aux_kind(SATVAR_KIND_FACT), inputs() {}
        bool operator<(const GateCacheKey &other) const {
            if (gate_type != other.gate_type) return gate_type < other.gate_type;
            if (aux_kind != other.aux_kind) return aux_kind < other.aux_kind;
            return inputs < other.inputs;
        }
    };

    bool normalize_clause(const std::vector<int> &in, std::vector<int> *out) const;
    void add_normalized_clause(const std::vector<int> &normalized, ClauseKind kind, const std::string &note);
    void add_normalized_clause_no_dedup(const std::vector<int> &normalized, ClauseKind kind, const std::string &note);
    void normalize_gate_inputs(const std::vector<int> &in, std::vector<int> *out, bool *has_complementary_pair, int *removed_duplicates) const;

private:
    SatVarManager *vm_;
    std::vector<ClauseRecord> clauses_;
    std::map<ClauseKind, int> clause_stats_;
    std::set< std::vector<int> > clause_set_;
    int singleton_and_fold_count_;
    int singleton_or_fold_count_;
    int duplicate_clause_skip_count_;
    int gate_input_duplicate_removed_count_;
    int complementary_and_fold_count_;
    int complementary_or_fold_count_;
    int complementary_gate_saved_clause_count_;
    int shared_and_gate_hit_count_;
    int shared_or_gate_hit_count_;
    int shared_gate_saved_var_count_;
    int shared_gate_saved_clause_count_;
    int and_gate_request_count_;
    int or_gate_request_count_;
    int no_dedup_clause_append_count_;
    std::map<GateCacheKey, int> gate_cache_;
    int declared_max_var_;
    int detail_duplicate_log_count_;
    int detail_clause_add_log_count_;
    int detail_gate_log_count_;
};

#endif
