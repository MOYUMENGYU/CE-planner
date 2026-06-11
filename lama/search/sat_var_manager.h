#ifndef SAT_VAR_MANAGER_H
#define SAT_VAR_MANAGER_H

#include <map>
#include <set>
#include <string>
#include <ostream>
#include <vector>
#include "cnf_types.h"


struct SatVarManagerSnapshot {
    std::map<FactKey, int> fact_to_id;
    std::map<int, SatVarInfo> id_to_info;
    int next_var_id;
    int fact_var_count;
    int aux_var_count;
    std::map<std::string, int> stable_aux_to_id;
    std::set<int> persistent_aux_ids;
    SatVarManagerSnapshot()
        : fact_to_id(), id_to_info(), next_var_id(1), fact_var_count(0), aux_var_count(0),
          stable_aux_to_id(), persistent_aux_ids() {}
};

class SatVarManager {
public:
    SatVarManager();
    void clear();

    // Start a new verification round while keeping semantically stable variables.
    // FACT variables are kept so (var,value,time) has a stable SAT id across rounds.
    // Persistent AUX variables are kept for static init gates and cross-round support-term gates.
    // Round-local AUX variables are dropped and their ids may be reused in the next round.
    void begin_round_preserve_stable();

    // Called after building the static init base. Static AUX variables occur in the
    // cached static CNF snapshot and therefore must survive later round resets.
    void mark_all_current_aux_vars_persistent();

    int get_fact_var(int var, int val, int time);
    int new_aux_var(SatVarKind kind, const std::string &label);
    int get_or_create_stable_aux_var(const std::string &stable_key, SatVarKind kind, const std::string &label, bool *created);

    bool is_fact_var(int id) const;
    bool has_info(int id) const;
    const SatVarInfo &get_info(int id) const;
    int max_var() const;

    std::string fact_to_string(int var, int val, int time) const;
    std::string lit_to_string(int lit) const;
    void dump_var_map(std::ostream &os) const;

    int num_fact_vars() const;
    int num_aux_vars() const;

    void export_snapshot(SatVarManagerSnapshot *out) const;
    void import_snapshot(const SatVarManagerSnapshot &in);

private:
    std::map<FactKey, int> fact_to_id_;
    std::map<int, SatVarInfo> id_to_info_;
    int next_var_id_;
    int fact_var_count_;
    int aux_var_count_;
    int detail_fact_new_log_count_;
    int detail_fact_reuse_log_count_;
    int detail_aux_new_log_count_;
    std::map<std::string, int> stable_aux_to_id_;
    std::set<int> persistent_aux_ids_;

    void recompute_counters_and_next_id();
};

#endif
