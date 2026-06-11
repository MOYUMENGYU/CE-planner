#ifndef CNF_PREPROCESSOR_H
#define CNF_PREPROCESSOR_H

#include <map>
#include <set>
#include <string>
#include <vector>
#include "cnf_types.h"

class CnfBuilder;
class SatVarManager;

struct CnfPreprocessStats {
    int input_clause_count;
    int output_clause_count;
    int input_literal_count;
    int output_literal_count;
    int input_binary_clause_count;
    int output_binary_clause_count;
    int passes_run;
    int unit_literals_fixed;
    int aux_literal_substitutions;
    int aux_equivalence_classes_used;
    int subsumed_clause_count;
    int ssr_literal_removed_count;
    int implication_literal_removed_count;
    int hbr_binary_added_count;
    int duplicate_clause_removed_count;
    int tautology_clause_removed_count;
    int unsat_detected;
    CnfPreprocessStats()
        : input_clause_count(0), output_clause_count(0),
          input_literal_count(0), output_literal_count(0),
          input_binary_clause_count(0), output_binary_clause_count(0),
          passes_run(0), unit_literals_fixed(0), aux_literal_substitutions(0),
          aux_equivalence_classes_used(0), subsumed_clause_count(0),
          ssr_literal_removed_count(0), implication_literal_removed_count(0),
          hbr_binary_added_count(0), duplicate_clause_removed_count(0),
          tautology_clause_removed_count(0), unsat_detected(0) {}
};

class CnfPreprocessor {
public:
    CnfPreprocessor();
    bool simplify_safe(CnfBuilder *cnf, const SatVarManager &vm, CnfPreprocessStats *stats);

private:
    struct BinaryClause {
        int a;
        int b;
        BinaryClause() : a(0), b(0) {}
        BinaryClause(int aa, int bb) : a(aa), b(bb) {}
    };

    bool normalize_clause(std::vector<int> *lits, CnfPreprocessStats *stats) const;
    void collect_formula_stats(const std::vector<ClauseRecord> &clauses,
                               int *literal_count,
                               int *binary_clause_count) const;
    bool run_pass(std::vector<ClauseRecord> *clauses,
                  const SatVarManager &vm,
                  int declared_max_var,
                  CnfPreprocessStats *stats,
                  bool *became_unsat) const;
    bool apply_unit_propagation(std::vector<ClauseRecord> *clauses,
                                int declared_max_var,
                                CnfPreprocessStats *stats,
                                bool *became_unsat) const;
    bool apply_aux_equivalence_substitution(std::vector<ClauseRecord> *clauses,
                                            const SatVarManager &vm,
                                            int declared_max_var,
                                            CnfPreprocessStats *stats,
                                            bool *became_unsat) const;
    bool apply_subsumption(std::vector<ClauseRecord> *clauses,
                           CnfPreprocessStats *stats) const;
    bool apply_binary_strengthening(std::vector<ClauseRecord> *clauses,
                                    int declared_max_var,
                                    CnfPreprocessStats *stats) const;
    void make_unsat_formula(std::vector<ClauseRecord> *clauses,
                            int declared_max_var) const;
    bool is_aux_literal(const SatVarManager &vm, int lit) const;
    static int lit_to_index(int lit);
    static int index_to_lit(int index);
    static bool clause_subsumes(const std::vector<int> &small_clause,
                                const std::vector<int> &large_clause);
};

#endif
