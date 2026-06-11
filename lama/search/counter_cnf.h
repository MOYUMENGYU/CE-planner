#ifndef COUNTER_CNF_H
#define COUNTER_CNF_H

#include <map>
#include <set>
#include <string>
#include <vector>
#include "globals.h"
#include "operator.h"
#include "cnf_types.h"
#include "sat_var_manager.h"
#include "cnf_builder.h"
#include "kissat_counter.h"
#include "minisat_counter.h"
#include "glucose_counter.h"
#include "cadical_counter.h"
#include "counter.h"
#include "cnf_preprocessor.h"

class CounterCNF {
public:
    typedef std::vector<const Operator *> Plan;
    typedef std::vector< std::map<int, std::set<int> > > ScheduledFactLayers;
    struct SolverValidationStats {
        bool available;
        bool executed;
        bool has_counterexample;
        bool sample_valid;
        int load_time_ms;
        int solve_time_ms;
        int extract_time_ms;
        std::vector<int> counterexample_state;
        SolverValidationStats()
            : available(false), executed(false), has_counterexample(false), sample_valid(false),
              load_time_ms(0), solve_time_ms(0), extract_time_ms(0), counterexample_state() {}
    };
    explicit CounterCNF(bool isinitial);
    ~CounterCNF();
    bool computeCounterCNF(const Plan &plan, bool isfirst);
    bool prepare_counterexample_cnf(const Plan &plan, bool isfirst);
    bool run_kissat_validation();
    bool run_minisat_validation();
    bool run_glucose_validation();
    bool run_cadical_validation();
    bool prepare_counterexample_cnf(const Plan &plan, bool isfirst, const Counter *driver_counter);
    void import_driver_state(const Counter &driver_counter);
    int get_last_var_count() const;
    int get_last_clause_count() const;
    int get_cnf_build_time_ms() const;
    int get_kissat_load_time_ms() const;
    int get_kissat_solve_time_ms() const;
    int get_kissat_model_extract_time_ms() const;
    int get_minisat_load_time_ms() const;
    int get_minisat_solve_time_ms() const;
    int get_minisat_model_extract_time_ms() const;
    int get_glucose_load_time_ms() const;
    int get_glucose_solve_time_ms() const;
    int get_glucose_model_extract_time_ms() const;
    int get_cadical_load_time_ms() const;
    int get_cadical_solve_time_ms() const;
    int get_cadical_model_extract_time_ms() const;
    int get_total_compute_time_ms() const;
    int get_kissat_end_to_end_time_ms() const;
    int get_minisat_end_to_end_time_ms() const;
    int get_glucose_end_to_end_time_ms() const;
    int get_cadical_end_to_end_time_ms() const;
    bool get_kissat_last_has_counterexample() const;
    bool get_minisat_last_has_counterexample() const;
    bool get_glucose_last_has_counterexample() const;
    bool get_cadical_last_has_counterexample() const;
    bool get_kissat_result_valid() const;
    bool get_minisat_result_valid() const;
    bool get_glucose_result_valid() const;
    bool get_cadical_result_valid() const;
    bool get_kissat_sample_valid() const;
    bool get_minisat_sample_valid() const;
    bool get_glucose_sample_valid() const;
    bool get_cadical_sample_valid() const;
    const std::vector<int> &get_kissat_counterexample_state() const;
    const std::vector<int> &get_minisat_counterexample_state() const;
    const std::vector<int> &get_glucose_counterexample_state() const;
    const std::vector<int> &get_cadical_counterexample_state() const;
    bool kissat_available() const;
    bool minisat_available() const;
    bool glucose_available() const;
    bool cadical_available() const;

private:
    struct TimedFact {
        int var;
        int val;
        int rel_time;
        TimedFact() : var(-1), val(-1), rel_time(0) {}
        TimedFact(int v, int value, int t) : var(v), val(value), rel_time(t) {}
        bool operator<(const TimedFact &other) const {
            if (var != other.var) return var < other.var;
            if (val != other.val) return val < other.val;
            return rel_time < other.rel_time;
        }
        bool operator==(const TimedFact &other) const {
            return var == other.var && val == other.val && rel_time == other.rel_time;
        }
    };

    struct SupportTermTemplate {
        std::vector<TimedFact> cond_facts;
    };

    struct SupportTermKey {
        std::vector<TimedFact> cond_facts;
        bool operator<(const SupportTermKey &other) const {
            if (cond_facts.size() != other.cond_facts.size())
                return cond_facts.size() < other.cond_facts.size();
            int i;
            for (i = 0; i < (int)cond_facts.size(); ++i) {
                if (cond_facts[i] < other.cond_facts[i]) return true;
                if (other.cond_facts[i] < cond_facts[i]) return false;
            }
            return false;
        }
    };

    struct TransitionBranchSkeleton {
        bool initialized;
        int prepost_index;
        bool unconditional;
        int term_id;
        std::vector<int> add_vals;
        std::vector<int> del_vals;
        TransitionBranchSkeleton()
            : initialized(false), prepost_index(-1), unconditional(false), term_id(-1),
              add_vals(), del_vals() {}
    };

    struct RegressionCaseRecord {
        bool initialized;
        bool add_has_unconditional;
        bool del_has_unconditional;
        int total_add_term_count;
        int total_del_term_count;
        int case_type;
        RegressionCaseRecord()
            : initialized(false), add_has_unconditional(false), del_has_unconditional(false),
              total_add_term_count(0), total_del_term_count(0), case_type(0) {}
    };

    struct VarRegressionSkeleton {
        bool initialized;
        std::vector<TimedFact> prevail_facts;
        std::vector<TransitionBranchSkeleton> branches;
        std::vector< std::vector<int> > add_branch_ids_by_val;
        std::vector< std::vector<int> > del_branch_ids_by_val;
        std::vector<int> total_add_branch_count_by_val;
        std::vector<int> total_del_branch_count_by_val;
        std::vector<char> add_has_unconditional_by_val;
        std::vector<char> del_has_unconditional_by_val;
        std::vector<RegressionCaseRecord> case_by_val;
        VarRegressionSkeleton()
            : initialized(false), prevail_facts(), branches(), add_branch_ids_by_val(), del_branch_ids_by_val(),
              total_add_branch_count_by_val(), total_del_branch_count_by_val(),
              add_has_unconditional_by_val(), del_has_unconditional_by_val(), case_by_val() {}
    };

    struct VarRegressionSkeletonKey {
        const Operator *op;
        int var;
        VarRegressionSkeletonKey() : op(0), var(-1) {}
        VarRegressionSkeletonKey(const Operator *o, int v) : op(o), var(v) {}
        bool operator<(const VarRegressionSkeletonKey &other) const {
            if (op != other.op) return op < other.op;
            return var < other.var;
        }
    };

    struct InstantiatedTermKey {
        int term_id;
        int time_step;
        InstantiatedTermKey() : term_id(-1), time_step(0) {}
        InstantiatedTermKey(int id, int t)
            : term_id(id), time_step(t) {}
        bool operator<(const InstantiatedTermKey &other) const {
            if (term_id != other.term_id) return term_id < other.term_id;
            return time_step < other.time_step;
        }
    };


    struct ActionImpactSummary {
        bool initialized;
        std::vector<char> changed_vars;
        std::vector<int> changed_var_ids;
        std::vector<TimedFact> prevail_facts;
        ActionImpactSummary() : initialized(false), changed_vars(), changed_var_ids(), prevail_facts() {}
    };

    struct PlanSuffixSummary {
        bool valid;
        int plan_size;
        std::vector<const Operator *> plan_snapshot;
        std::vector< std::vector<int> > change_points_by_var;
        std::vector< std::vector<unsigned long long> > suffix_changed_bits;
        PlanSuffixSummary() : valid(false), plan_size(0), plan_snapshot(), change_points_by_var(), suffix_changed_bits() {}
    };


    struct FrontierLayerSignature {
        bool valid;
        int bucket_count;
        int fact_count;
        unsigned long long hash;
        FrontierLayerSignature()
            : valid(false), bucket_count(0), fact_count(0), hash(0ULL) {}
        bool same_as(const FrontierLayerSignature &other) const {
            return valid && other.valid &&
                   bucket_count == other.bucket_count &&
                   fact_count == other.fact_count &&
                   hash == other.hash;
        }
    };

    struct StaticInitBaseCache {
        bool ready;
        std::vector<int> unknown_mask;
        SatVarManagerSnapshot vm_snapshot;
        CnfBuilderSnapshot cnf_snapshot;
        int static_var_count;
        int static_clause_count;
        StaticInitBaseCache()
            : ready(false), unknown_mask(), vm_snapshot(), cnf_snapshot(),
              static_var_count(0), static_clause_count(0) {}
    };

private:
    void clear_round();
    void clear_round_dynamic_state();
    void build_static_init_base();
    void restore_round_base_from_static_cache();
    void build_round_init_delta(bool isfirst, const std::vector<int> &is_unknown);
    void parse_oneof_file(bool isinitial);
    void build_axiom_index();
    void build_L0();
    void compute_unknown_fact_mask(std::vector<int> *mask) const;
    void build_init_cnf(bool isfirst);
    void build_type1_init_cnf(bool isfirst, const std::vector<int> &is_unknown);
    void build_type23_init_cnf(bool isfirst, const std::vector<int> &is_unknown);
    void build_time0_exactly_one(const std::vector<int> &is_unknown);
    bool analyze_time0_single_var_literal_group(int group_index, int *group_var, std::vector<int> *group_vals, bool *is_full_domain_cover) const;
    void add_init_restriction_cnf(bool isfirst, const std::vector<int> &is_unknown);
    void build_goal_regression_cnf(const Plan &plan);
    void precompute_persistence_time_representatives(const Plan &plan);
    void build_plan_suffix_summary(const Plan &plan);
    int compute_common_suffix_length(const Plan &plan) const;
    int canonical_time_for_fact(int var, int val, int time) const;
    bool suffix_may_change_var(int time_index, int var) const;
    int schedule_fact_requirement(int var, int val, int abs_time,
        ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts);
    void encode_axiom_goal_roots(int plan_size, const std::set< std::pair<int,int> > &goal_facts, std::set< std::pair<int,int> > *now_facts, std::set<int> *root_vars);
    void regress_one_fact(const Operator *op, const std::pair<int,int> &fact, int time_step,
        ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts,
        std::set<int> *root_vars);
    void regress_var_bucket(const Operator *op, int var, const std::set<int> &requested_vals, int time_step,
        ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts,
        std::set<int> *root_vars);
    const VarRegressionSkeleton &get_var_regression_skeleton(const Operator *op, int var);
    int get_or_create_support_term_id(const std::vector<TimedFact> &cond_facts);
    const ActionImpactSummary &get_action_impact_summary(const Operator *op);
    void build_action_impact_summary_for_op(const Operator *op, ActionImpactSummary *summary);
    int instantiate_term_from_id(int term_id, int time_step, const std::string &label, ClauseKind clause_kind, SatVarKind aux_kind,
        ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts);
    bool solve_with_kissat();
    bool solve_with_minisat();
    bool solve_with_glucose();
    bool solve_with_cadical();
    bool build_state_from_sample(const std::map<int,int> &sample, const std::vector<int> &base_state, std::vector<int> *state) const;
    int fact_var(int var, int val, int time);
    int literal_for_fact(int var, int val, int time);
    int make_term_gate_from_literals(const std::vector<int> &lits, const std::string &label, ClauseKind clause_kind, SatVarKind aux_kind);
    int get_round_true_var();
    void add_equiv_to_or(int lhs, const std::vector<int> &rhs_lits, const std::string &note);
    void add_equiv_to_and(int lhs, const std::vector<int> &rhs_lits, const std::string &note);
    void add_equiv_to_or2(int lhs, int rhs1, int rhs2, const std::string &note);
    void add_equiv_to_and2(int lhs, int rhs1, int rhs2, const std::string &note);
    void add_equiv_to_and2_no_dedup(int lhs, int rhs1, int rhs2, const std::string &note);
    void add_equiv_to_prev_or_and_not_del(int lhs, int prev_lit, int add_or_lit, int del_or_lit, const std::string &note);
    std::string fact_desc(int var, int val, int time) const;
    std::string state_to_string_local(const std::vector<int> &vars) const;
    bool use_debug_labels() const;
    bool collect_hotpath_diag() const;
    bool use_reg_equiv_no_dedup_hotpath() const;
    bool use_frontier_replay_check() const;
    bool use_frontier_replay_active() const;
    int count_frontier_layer_facts(const std::map<int, std::set<int> > &layer) const;
    void merge_frontier_layer_into(const std::map<int, std::set<int> > &src, std::map<int, std::set<int> > *dst);
    FrontierLayerSignature make_frontier_layer_signature(const std::map<int, std::set<int> > &layer) const;
    std::string maybe_fact_desc(int var, int val, int time) const;
    std::string make_debug_label(const std::string &prefix, int var, int val, int time) const;

private:
    ONEOFS oneofs;
    std::map< std::pair<int,int>, std::vector<PrePost> > axiomtovar;
    std::vector< std::pair<int,int> > L0;
    std::map<std::string, state_var> appearcounter;
    std::map<std::string, state_var> firststate;
    bool isfind;
    bool findvalidplan;
    int total_counter;
    int lastcountertime;
    int last_var_count_;
    int last_clause_count_;
    int persist_shortcut_count_;
    int no_del_direct_count_;
    int no_add_direct_count_;
    int no_del_saved_vars_;
    int no_del_saved_clauses_;
    int no_add_saved_vars_;
    int no_add_saved_clauses_;
    int time0_fixed_compact_count_;
    int time0_fixed_saved_clauses_;
    int time0_group_cover_skip_count_;
    int time0_group_cover_saved_clauses_;
    int time0_direct_literal_group_count_;
    int time0_direct_literal_group_saved_clauses_;
    int general_direct_count_;
    int general_saved_vars_;
    int general_saved_clauses_;
    int unconditional_add_shortcut_count_;
    int unconditional_del_shortcut_count_;
    int dominated_add_term_skip_count_;
    int dominated_del_term_skip_count_;
    int lazy_prev_var_avoid_count_;
    int round_true_var_;

    int init_build_time_ms_;
    int goal_regression_build_time_ms_;
    int preprocess_time_ms_;
    int kissat_load_time_ms_;
    int kissat_solve_time_ms_;
    int model_extract_time_ms_;
    int total_compute_time_ms_;
    int minisat_load_time_ms_;
    int minisat_solve_time_ms_;
    int minisat_model_extract_time_ms_;
    int glucose_load_time_ms_;
    int glucose_solve_time_ms_;
    int glucose_model_extract_time_ms_;
    int cadical_load_time_ms_;
    int cadical_solve_time_ms_;
    int cadical_model_extract_time_ms_;

    bool kissat_last_has_counterexample_;
    bool minisat_last_has_counterexample_;
    bool glucose_last_has_counterexample_;
    bool cadical_last_has_counterexample_;
    bool kissat_last_result_valid_;
    bool minisat_last_result_valid_;
    bool glucose_last_result_valid_;
    bool cadical_last_result_valid_;
    bool kissat_last_sample_valid_;
    bool minisat_last_sample_valid_;
    bool glucose_last_sample_valid_;
    bool cadical_last_sample_valid_;
    std::vector<int> validation_base_state_;
    std::vector<int> kissat_last_counterexample_state_;
    std::vector<int> minisat_last_counterexample_state_;
    std::vector<int> glucose_last_counterexample_state_;
    std::vector<int> cadical_last_counterexample_state_;

    int var_skeleton_cache_hit_count_;
    int var_skeleton_cache_miss_count_;
    int regression_call_count_;
    int regression_instantiated_add_term_count_;
    int regression_instantiated_del_term_count_;
    int goal_root_var_count_;
    int regression_unique_fact_count_;
    int regression_layer_peak_fact_count_;
    int instantiated_term_cache_hit_count_;
    int instantiated_term_cache_miss_count_;
    int persistent_var_skeleton_cache_size_;
    int support_term_pool_reuse_hit_count_;
    int persistence_alias_saved_var_count_;
    int persistence_alias_hit_count_;
    int persistence_tautology_skip_count_;
    int action_impact_summary_build_count_;
    int action_impact_fastskip_count_;
    int suffix_summary_build_count_;
    int suffix_summary_reuse_count_;
    int last_suffix_reused_steps_;
    int last_suffix_rebuilt_steps_;
    int suffix_jump_queries_;
    int suffix_jump_total_skipped_steps_;
    int persistence_change_vector_build_count_;
    int persistence_change_point_total_;
    int regression_scheduled_fact_count_;
    int regression_processed_fact_count_;
    int regression_time0_fact_count_;
    int diag_plan_size_;
    int diag_regression_loop_steps_scanned_;
    int diag_regression_active_layer_count_;
    int diag_regression_processed_bucket_count_;
    int diag_empty_support_term_count_;
    int diag_nonempty_support_term_count_;
    int regression_case_record_use_count_;
    int regression_case_early_exit_count_;
    int suffix_change_points_reused_count_;
    int suffix_summary_prefix_scanned_steps_;
    int suffix_summary_suffix_replayed_steps_;
    int p4_no_add_single_del_direct_count_;
    int p4_no_del_single_add_direct_count_;
    int p4_uncond_add_single_del_direct_count_;
    int p4_general_single_add_bypass_count_;
    int p4_general_single_del_bypass_count_;
    int p4_layer_swap_count_;
    int p4_branch_lit_vector_hit_count_;
    int p4_branch_lit_vector_miss_count_;
    int p6_reg_equiv_and2_no_dedup_count_;
    int p7_scheduled_layer_vector_size_;
    int p7_scheduled_layer_vector_resize_count_;
    int p8_frontier_common_suffix_;
    int p8_frontier_compared_layers_;
    int p8_frontier_equal_layers_;
    int p8_frontier_mismatch_layers_;
    int p8_frontier_skipped_layers_;
    int p8_active_enabled_;
    int p8_active_replayed_layers_;
    int p8_active_replayed_buckets_;
    int p8_active_replayed_facts_;
    int p8_active_schedule_suppressed_count_;
    int p8_active_schedule_boundary_allowed_count_;
    int p8_active_schedule_suppression_attempt_count_;
    int p8_active_schedule_logical_attempt_count_;
    int p8_active_schedule_inserted_count_;
    bool p8_active_schedule_suppression_enabled_;
    int p8_active_current_processing_time_;
    std::vector<char> p8_active_replayed_layer_mask_;
    int last_regression_frontier_plan_size_;
    ScheduledFactLayers last_regression_frontier_layers_;
    std::vector<FrontierLayerSignature> last_regression_frontier_signatures_;

    StaticInitBaseCache static_init_base_;

    std::map<VarRegressionSkeletonKey, VarRegressionSkeleton> var_regression_skeleton_cache_;
    std::vector<SupportTermTemplate> support_term_pool_;
    std::map<SupportTermKey, int> support_term_index_;
    std::map<InstantiatedTermKey, int> instantiated_term_cache_;
    std::map<const Operator *, ActionImpactSummary> action_impact_summary_cache_;
    PlanSuffixSummary plan_suffix_summary_;

    SatVarManager vm_;
    CnfBuilder cnf_;
    KissatCounter solver_;
    MiniSatCounter minisat_solver_;
    GlucoseCounter glucose_solver_;
    CaDiCaLCounter cadical_solver_;
};

#endif





