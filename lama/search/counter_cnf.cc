#include "counter_cnf.h"
#include "cnf_logger.h"
#include <ctime>
#include <fstream>
#include <sstream>
#include <algorithm>

namespace {
static int clock_diff_ms(std::clock_t begin_clock, std::clock_t end_clock) {
    return (int)(((double)(end_clock - begin_clock) / CLOCKS_PER_SEC) * 1000.0);
}
}

CounterCNF::CounterCNF(bool isinitial)
    : isfind(false), findvalidplan(false), total_counter(0), lastcountertime(0),
      last_var_count_(0), last_clause_count_(0), persist_shortcut_count_(0),
      no_del_direct_count_(0), no_add_direct_count_(0),
      no_del_saved_vars_(0), no_del_saved_clauses_(0),
      no_add_saved_vars_(0), no_add_saved_clauses_(0),
      time0_fixed_compact_count_(0), time0_fixed_saved_clauses_(0),
      time0_group_cover_skip_count_(0), time0_group_cover_saved_clauses_(0),
      time0_direct_literal_group_count_(0), time0_direct_literal_group_saved_clauses_(0),
      general_direct_count_(0), general_saved_vars_(0), general_saved_clauses_(0),
      unconditional_add_shortcut_count_(0), unconditional_del_shortcut_count_(0),
      dominated_add_term_skip_count_(0), dominated_del_term_skip_count_(0), lazy_prev_var_avoid_count_(0),
      round_true_var_(0),
      init_build_time_ms_(0), goal_regression_build_time_ms_(0), preprocess_time_ms_(0),
      kissat_load_time_ms_(0), kissat_solve_time_ms_(0), model_extract_time_ms_(0), total_compute_time_ms_(0),
      minisat_load_time_ms_(0), minisat_solve_time_ms_(0), minisat_model_extract_time_ms_(0),
      glucose_load_time_ms_(0), glucose_solve_time_ms_(0), glucose_model_extract_time_ms_(0),
      cadical_load_time_ms_(0), cadical_solve_time_ms_(0), cadical_model_extract_time_ms_(0),
      kissat_last_has_counterexample_(false), minisat_last_has_counterexample_(false),
      glucose_last_has_counterexample_(false), cadical_last_has_counterexample_(false),
      kissat_last_result_valid_(false), minisat_last_result_valid_(false),
      glucose_last_result_valid_(false), cadical_last_result_valid_(false),
      kissat_last_sample_valid_(false), minisat_last_sample_valid_(false),
      glucose_last_sample_valid_(false), cadical_last_sample_valid_(false),
      validation_base_state_(), kissat_last_counterexample_state_(), minisat_last_counterexample_state_(),
      glucose_last_counterexample_state_(), cadical_last_counterexample_state_(),
      var_skeleton_cache_hit_count_(0), var_skeleton_cache_miss_count_(0), regression_call_count_(0),
      regression_instantiated_add_term_count_(0), regression_instantiated_del_term_count_(0),
      goal_root_var_count_(0), regression_unique_fact_count_(0), regression_layer_peak_fact_count_(0),
      instantiated_term_cache_hit_count_(0), instantiated_term_cache_miss_count_(0), persistent_var_skeleton_cache_size_(0), support_term_pool_reuse_hit_count_(0),
      persistence_alias_saved_var_count_(0), persistence_alias_hit_count_(0), persistence_tautology_skip_count_(0),
      action_impact_summary_build_count_(0), action_impact_fastskip_count_(0),
      suffix_summary_build_count_(0), suffix_summary_reuse_count_(0),
      last_suffix_reused_steps_(0), last_suffix_rebuilt_steps_(0),
      suffix_jump_queries_(0), suffix_jump_total_skipped_steps_(0),
      persistence_change_vector_build_count_(0), persistence_change_point_total_(0),
      regression_scheduled_fact_count_(0), regression_processed_fact_count_(0), regression_time0_fact_count_(0),
      diag_plan_size_(0), diag_regression_loop_steps_scanned_(0), diag_regression_active_layer_count_(0),
      diag_regression_processed_bucket_count_(0), diag_empty_support_term_count_(0), diag_nonempty_support_term_count_(0),
      regression_case_record_use_count_(0), regression_case_early_exit_count_(0),
      suffix_change_points_reused_count_(0), suffix_summary_prefix_scanned_steps_(0), suffix_summary_suffix_replayed_steps_(0),
      p4_no_add_single_del_direct_count_(0), p4_no_del_single_add_direct_count_(0),
      p4_uncond_add_single_del_direct_count_(0), p4_general_single_add_bypass_count_(0),
      p4_general_single_del_bypass_count_(0), p4_layer_swap_count_(0),
      p4_branch_lit_vector_hit_count_(0), p4_branch_lit_vector_miss_count_(0),
      p6_reg_equiv_and2_no_dedup_count_(0), p7_scheduled_layer_vector_size_(0), p7_scheduled_layer_vector_resize_count_(0),
      p8_frontier_common_suffix_(0), p8_frontier_compared_layers_(0), p8_frontier_equal_layers_(0),
      p8_frontier_mismatch_layers_(0), p8_frontier_skipped_layers_(0),
      p8_active_enabled_(0), p8_active_replayed_layers_(0), p8_active_replayed_buckets_(0),
      p8_active_replayed_facts_(0), p8_active_schedule_suppressed_count_(0),
      p8_active_schedule_boundary_allowed_count_(0), p8_active_schedule_suppression_attempt_count_(0),
      p8_active_schedule_logical_attempt_count_(0), p8_active_schedule_inserted_count_(0),
      p8_active_schedule_suppression_enabled_(false), p8_active_current_processing_time_(-1),
      p8_active_replayed_layer_mask_(), last_regression_frontier_plan_size_(0),
      last_regression_frontier_layers_(), last_regression_frontier_signatures_(),
      vm_(), cnf_(&vm_), solver_(), minisat_solver_(), glucose_solver_(), cadical_solver_() {
    parse_oneof_file(isinitial);
    build_axiom_index();
    build_L0();
}

CounterCNF::~CounterCNF() {}
int CounterCNF::get_last_var_count() const { return last_var_count_; }
int CounterCNF::get_last_clause_count() const { return last_clause_count_; }
int CounterCNF::get_cnf_build_time_ms() const { return init_build_time_ms_ + goal_regression_build_time_ms_ + preprocess_time_ms_; }
int CounterCNF::get_kissat_load_time_ms() const { return kissat_load_time_ms_; }
int CounterCNF::get_kissat_solve_time_ms() const { return kissat_solve_time_ms_; }
int CounterCNF::get_kissat_model_extract_time_ms() const { return model_extract_time_ms_; }
int CounterCNF::get_minisat_load_time_ms() const { return minisat_load_time_ms_; }
int CounterCNF::get_minisat_solve_time_ms() const { return minisat_solve_time_ms_; }
int CounterCNF::get_minisat_model_extract_time_ms() const { return minisat_model_extract_time_ms_; }
int CounterCNF::get_glucose_load_time_ms() const { return glucose_load_time_ms_; }
int CounterCNF::get_glucose_solve_time_ms() const { return glucose_solve_time_ms_; }
int CounterCNF::get_glucose_model_extract_time_ms() const { return glucose_model_extract_time_ms_; }
int CounterCNF::get_cadical_load_time_ms() const { return cadical_load_time_ms_; }
int CounterCNF::get_cadical_solve_time_ms() const { return cadical_solve_time_ms_; }
int CounterCNF::get_cadical_model_extract_time_ms() const { return cadical_model_extract_time_ms_; }
int CounterCNF::get_total_compute_time_ms() const { return total_compute_time_ms_; }
int CounterCNF::get_kissat_end_to_end_time_ms() const { return kissat_load_time_ms_ + kissat_solve_time_ms_ + model_extract_time_ms_; }
int CounterCNF::get_minisat_end_to_end_time_ms() const { return minisat_load_time_ms_ + minisat_solve_time_ms_ + minisat_model_extract_time_ms_; }
int CounterCNF::get_glucose_end_to_end_time_ms() const { return glucose_load_time_ms_ + glucose_solve_time_ms_ + glucose_model_extract_time_ms_; }
int CounterCNF::get_cadical_end_to_end_time_ms() const { return cadical_load_time_ms_ + cadical_solve_time_ms_ + cadical_model_extract_time_ms_; }
bool CounterCNF::get_kissat_last_has_counterexample() const { return kissat_last_has_counterexample_; }
bool CounterCNF::get_minisat_last_has_counterexample() const { return minisat_last_has_counterexample_; }
bool CounterCNF::get_glucose_last_has_counterexample() const { return glucose_last_has_counterexample_; }
bool CounterCNF::get_cadical_last_has_counterexample() const { return cadical_last_has_counterexample_; }
bool CounterCNF::get_kissat_result_valid() const { return kissat_last_result_valid_; }
bool CounterCNF::get_minisat_result_valid() const { return minisat_last_result_valid_; }
bool CounterCNF::get_glucose_result_valid() const { return glucose_last_result_valid_; }
bool CounterCNF::get_cadical_result_valid() const { return cadical_last_result_valid_; }
bool CounterCNF::get_kissat_sample_valid() const { return kissat_last_sample_valid_; }
bool CounterCNF::get_minisat_sample_valid() const { return minisat_last_sample_valid_; }
bool CounterCNF::get_glucose_sample_valid() const { return glucose_last_sample_valid_; }
bool CounterCNF::get_cadical_sample_valid() const { return cadical_last_sample_valid_; }
const std::vector<int> &CounterCNF::get_kissat_counterexample_state() const { return kissat_last_counterexample_state_; }
const std::vector<int> &CounterCNF::get_minisat_counterexample_state() const { return minisat_last_counterexample_state_; }
const std::vector<int> &CounterCNF::get_glucose_counterexample_state() const { return glucose_last_counterexample_state_; }
const std::vector<int> &CounterCNF::get_cadical_counterexample_state() const { return cadical_last_counterexample_state_; }
bool CounterCNF::kissat_available() const { return solver_.is_available(); }
bool CounterCNF::minisat_available() const { return minisat_solver_.is_available(); }
bool CounterCNF::glucose_available() const { return glucose_solver_.is_available(); }
bool CounterCNF::cadical_available() const { return cadical_solver_.is_available(); }

void CounterCNF::clear_round_dynamic_state() {
    last_var_count_ = 0;
    last_clause_count_ = 0;
    persist_shortcut_count_ = 0;
    no_del_direct_count_ = 0;
    no_add_direct_count_ = 0;
    no_del_saved_vars_ = 0;
    no_del_saved_clauses_ = 0;
    no_add_saved_vars_ = 0;
    no_add_saved_clauses_ = 0;
    time0_fixed_compact_count_ = 0;
    time0_fixed_saved_clauses_ = 0;
    time0_group_cover_skip_count_ = 0;
    time0_group_cover_saved_clauses_ = 0;
    time0_direct_literal_group_count_ = 0;
    time0_direct_literal_group_saved_clauses_ = 0;
    general_direct_count_ = 0;
    general_saved_vars_ = 0;
    general_saved_clauses_ = 0;
    unconditional_add_shortcut_count_ = 0;
    unconditional_del_shortcut_count_ = 0;
    dominated_add_term_skip_count_ = 0;
    dominated_del_term_skip_count_ = 0;
    lazy_prev_var_avoid_count_ = 0;
    round_true_var_ = 0;

    init_build_time_ms_ = 0;
    goal_regression_build_time_ms_ = 0;
    preprocess_time_ms_ = 0;
    kissat_load_time_ms_ = 0;
    kissat_solve_time_ms_ = 0;
    model_extract_time_ms_ = 0;
    total_compute_time_ms_ = 0;
    minisat_load_time_ms_ = 0;
    minisat_solve_time_ms_ = 0;
    minisat_model_extract_time_ms_ = 0;
    glucose_load_time_ms_ = 0;
    glucose_solve_time_ms_ = 0;
    glucose_model_extract_time_ms_ = 0;
    cadical_load_time_ms_ = 0;
    cadical_solve_time_ms_ = 0;
    cadical_model_extract_time_ms_ = 0;
    kissat_last_has_counterexample_ = false;
    minisat_last_has_counterexample_ = false;
    glucose_last_has_counterexample_ = false;
    cadical_last_has_counterexample_ = false;
    kissat_last_result_valid_ = false;
    minisat_last_result_valid_ = false;
    glucose_last_result_valid_ = false;
    cadical_last_result_valid_ = false;
    kissat_last_sample_valid_ = false;
    minisat_last_sample_valid_ = false;
    glucose_last_sample_valid_ = false;
    cadical_last_sample_valid_ = false;
    validation_base_state_.clear();
    kissat_last_counterexample_state_.clear();
    minisat_last_counterexample_state_.clear();
    glucose_last_counterexample_state_.clear();
    cadical_last_counterexample_state_.clear();

    var_skeleton_cache_hit_count_ = 0;
    var_skeleton_cache_miss_count_ = 0;
    regression_call_count_ = 0;
    regression_instantiated_add_term_count_ = 0;
    regression_instantiated_del_term_count_ = 0;
    goal_root_var_count_ = 0;
    regression_unique_fact_count_ = 0;
    regression_layer_peak_fact_count_ = 0;
    instantiated_term_cache_hit_count_ = 0;
    instantiated_term_cache_miss_count_ = 0;
    persistent_var_skeleton_cache_size_ = (int)var_regression_skeleton_cache_.size();
    support_term_pool_reuse_hit_count_ = 0;
    persistence_alias_saved_var_count_ = 0;
    persistence_alias_hit_count_ = 0;
    persistence_tautology_skip_count_ = 0;
    diag_plan_size_ = 0;
    diag_regression_loop_steps_scanned_ = 0;
    diag_regression_active_layer_count_ = 0;
    diag_regression_processed_bucket_count_ = 0;
    diag_empty_support_term_count_ = 0;
    diag_nonempty_support_term_count_ = 0;
    regression_case_record_use_count_ = 0;
    regression_case_early_exit_count_ = 0;
    suffix_change_points_reused_count_ = 0;
    suffix_summary_prefix_scanned_steps_ = 0;
    suffix_summary_suffix_replayed_steps_ = 0;
    p4_no_add_single_del_direct_count_ = 0;
    p4_no_del_single_add_direct_count_ = 0;
    p4_uncond_add_single_del_direct_count_ = 0;
    p4_general_single_add_bypass_count_ = 0;
    p4_general_single_del_bypass_count_ = 0;
    p4_layer_swap_count_ = 0;
    p4_branch_lit_vector_hit_count_ = 0;
    p4_branch_lit_vector_miss_count_ = 0;
    p6_reg_equiv_and2_no_dedup_count_ = 0;
    p7_scheduled_layer_vector_size_ = 0;
    p7_scheduled_layer_vector_resize_count_ = 0;
    p8_frontier_common_suffix_ = 0;
    p8_frontier_compared_layers_ = 0;
    p8_frontier_equal_layers_ = 0;
    p8_frontier_mismatch_layers_ = 0;
    p8_frontier_skipped_layers_ = 0;
    p8_active_enabled_ = 0;
    p8_active_replayed_layers_ = 0;
    p8_active_replayed_buckets_ = 0;
    p8_active_replayed_facts_ = 0;
    p8_active_schedule_suppressed_count_ = 0;
    p8_active_schedule_boundary_allowed_count_ = 0;
    p8_active_schedule_suppression_attempt_count_ = 0;
    p8_active_schedule_logical_attempt_count_ = 0;
    p8_active_schedule_inserted_count_ = 0;
    p8_active_schedule_suppression_enabled_ = false;
    p8_active_current_processing_time_ = -1;
    p8_active_replayed_layer_mask_.clear();

    appearcounter.clear();
    firststate.clear();
    isfind = false;
    findvalidplan = false;
    total_counter = 0;
    lastcountertime = 0;

    instantiated_term_cache_.clear();
    vm_.clear();
    cnf_.clear();
    solver_.clear();
    minisat_solver_.clear();
    glucose_solver_.clear();
    cadical_solver_.clear();
}

void CounterCNF::clear_round() {
    clear_round_dynamic_state();
}

void CounterCNF::import_driver_state(const Counter &driver_counter) {
    appearcounter = driver_counter.appearcounter;
    firststate = driver_counter.firststate;
    isfind = driver_counter.isfind;
    findvalidplan = driver_counter.findvalidplan;
}

void CounterCNF::parse_oneof_file(bool isinitial) {
    oneofs.type = 0; oneofs.orlens = 0; oneofs.lens = 0; oneofs.oneof.clear();
    std::ifstream infile;
    if (isinitial) infile.open("oneof_initial", std::ios::in);
    else infile.open("oneof", std::ios::in);
    if (!infile.good()) {
        CNF_LOG_BASIC("[CNF-初始化] 错误：无法打开 oneof 文件。");
        return;
    }
    std::string line;
    std::getline(infile, line);
    if (line == "ORS") oneofs.type = 1;
    else if (line == "OR") oneofs.type = 3;
    else oneofs.type = 2;
    std::getline(infile, line);
    std::istringstream ss(line);
    if (oneofs.type == 3) ss >> oneofs.orlens;
    else ss >> oneofs.lens;
    int base = (oneofs.type == 3 ? oneofs.orlens : oneofs.lens);
    int i;
    for (i = 0; i < base; ++i) { oneof_item tmp; tmp.len = 0; oneofs.oneof.push_back(tmp); }
    int index = 0; int andsize = 0;
    while (std::getline(infile, line)) {
        if (line == ", ") {
            if (index >= 0 && index < (int)oneofs.oneof.size()) oneofs.oneof[index].size.push_back(andsize);
            andsize = 0;
        }
        if (line == "ONEOF") {
            std::getline(infile, line);
            std::istringstream ss2(line); ss2 >> oneofs.lens;
            for (i = 0; i < oneofs.lens; ++i) { oneof_item tmp; tmp.len = 0; oneofs.oneof.push_back(tmp); }
        } else if (line == "END_ONEOF" || line == "END_OR" || (line == ", " && oneofs.type == 1)) {
            if (index >= 0 && index < (int)oneofs.oneof.size()) oneofs.oneof[index].len = oneofs.oneof[index].size.size();
            ++index;
        } else if (line != ", ") {
            ++andsize;
            int var = -1;
            for (i = 0; i < (int)g_variable_name.size(); ++i) {
                if (line.find(g_variable_name[i]) == 0 && line.size() == g_variable_name[i].size() + 1) { var = i; break; }
            }
            std::getline(infile, line);
            std::stringstream ss3(line); int val = 0; ss3 >> val;
            if (var != -1 && index >= 0 && index < (int)oneofs.oneof.size()) {
                oneofs.oneof[index].var.push_back(var);
                oneofs.oneof[index].val.push_back(val);
            }
        }
    }
    CNF_LOG_BASIC("[CNF-初始化] oneof 文件读取完成，type=" << oneofs.type << ", orlens=" << oneofs.orlens << ", lens=" << oneofs.lens);
}

void CounterCNF::build_axiom_index() {
    axiomtovar.clear();
    int i, j;
    for (i = 0; i < (int)g_axioms.size(); ++i) {
        std::vector<PrePost> prepost = g_axioms[i].get_pre_post();
        for (j = 0; j < (int)prepost.size(); ++j) axiomtovar[std::make_pair(prepost[j].var, prepost[j].post)].push_back(prepost[j]);
    }
    CNF_LOG_BASIC("[CNF-初始化] axiom 映射建立完成，条目数=" << axiomtovar.size());
}

void CounterCNF::compute_unknown_fact_mask(std::vector<int> *mask) const {
    mask->assign(g_initial_state->vars.size(), 0);
    int i, j, k, nowindex, index;
    for (i = 0; i < oneofs.orlens; ++i) {
        nowindex = 0;
        for (j = 0; j < oneofs.oneof[i].len; ++j)
            for (k = 0; k < oneofs.oneof[i].size[j]; ++k) (*mask)[oneofs.oneof[i].var[nowindex++]] = 1;
    }
    for (i = 0; i < oneofs.lens; ++i) {
        nowindex = 0; index = oneofs.orlens + i;
        if (index < 0 || index >= (int)oneofs.oneof.size()) continue;
        for (j = 0; j < oneofs.oneof[index].len; ++j)
            for (k = 0; k < oneofs.oneof[index].size[j]; ++k) (*mask)[oneofs.oneof[index].var[nowindex++]] = 1;
    }
}

void CounterCNF::build_L0() {
    L0.clear();
    std::vector<int> is_unknown;
    compute_unknown_fact_mask(&is_unknown);
    int i;
    for (i = 0; i < (int)g_initial_state->vars.size(); ++i)
        if (i < (int)is_unknown.size() && !is_unknown[i]) L0.push_back(std::make_pair(i, g_initial_state->vars[i]));
    CNF_LOG_BASIC("[CNF-初始化] L0 确定事实数量=" << L0.size());
}

void CounterCNF::build_static_init_base() {
    static_init_base_.ready = false;
    static_init_base_.unknown_mask.clear();
    compute_unknown_fact_mask(&static_init_base_.unknown_mask);
    const std::vector<int> &is_unknown = static_init_base_.unknown_mask;

    CNF_LOG_BASIC("[CNF-静态基座] 开始构造静态 time0 基座");

    if (oneofs.type == 1) {
        int i, j, k;
        for (i = 0; i < (int)g_initial_state->vars.size(); ++i)
            if (!is_unknown[i] && axiomtovar.find(std::make_pair(i, g_initial_state->vars[i])) == axiomtovar.end())
                cnf_.add_unit(fact_var(i, g_initial_state->vars[i], 0), CLAUSE_KIND_INIT_KNOWN, std::string("L0确定事实 ") + fact_desc(i, g_initial_state->vars[i], 0));
        std::vector<int> working = g_original_values;
        for (i = 0; i < (int)working.size(); ++i) if (i < (int)is_unknown.size() && is_unknown[i]) working[i] = g_variable_domain[i] - 1;
        std::vector<int> state_terms;
        for (i = 0; i < oneofs.lens && i < (int)oneofs.oneof.size(); ++i) {
            int nowindex = 0;
            for (k = 0; k < oneofs.oneof[i].len; ++k) {
                std::vector<int> changed_vars;
                for (j = 0; j < oneofs.oneof[i].size[k]; ++j) { int var = oneofs.oneof[i].var[nowindex]; int val = oneofs.oneof[i].val[nowindex]; working[var] = val; changed_vars.push_back(var); ++nowindex; }
                std::vector<int> lits;
                for (j = 0; j < (int)working.size(); ++j) if (j < (int)is_unknown.size() && is_unknown[j]) {
                    if (working[j] < 0) lits.push_back(-fact_var(j, -(working[j] + 1), 0));
                    else lits.push_back(fact_var(j, working[j], 0));
                }
                int term = make_term_gate_from_literals(lits, std::string("ORS完整状态项 #") + cnf_int_to_string((int)state_terms.size()), CLAUSE_KIND_INIT_TERM, SATVAR_KIND_AUX_AND);
                state_terms.push_back(term);
                for (j = 0; j < (int)changed_vars.size(); ++j) working[changed_vars[j]] = g_variable_domain[changed_vars[j]] - 1;
            }
        }
        cnf_.add_clause(state_terms, CLAUSE_KIND_INIT_GROUP_ATLEAST, "ORS 至少选择一个完整状态");
        for (i = 0; i < (int)state_terms.size(); ++i) for (j = i + 1; j < (int)state_terms.size(); ++j) cnf_.add_binary(-state_terms[i], -state_terms[j], CLAUSE_KIND_INIT_GROUP_ATMOST, "ORS 完整状态两两互斥");
    } else {
        int i, j, k, m;
        for (i = 0; i < (int)g_initial_state->vars.size(); ++i)
            if (!is_unknown[i] && axiomtovar.find(std::make_pair(i, g_initial_state->vars[i])) == axiomtovar.end())
                cnf_.add_unit(fact_var(i, g_initial_state->vars[i], 0), CLAUSE_KIND_INIT_KNOWN, std::string("L0确定事实 ") + fact_desc(i, g_initial_state->vars[i], 0));
        for (i = 0; i < oneofs.lens + oneofs.orlens; ++i) {
            if (i < 0 || i >= (int)oneofs.oneof.size()) continue;

            int direct_var = -1;
            std::vector<int> direct_vals;
            bool full_domain_cover = false;
            if (analyze_time0_single_var_literal_group(i, &direct_var, &direct_vals, &full_domain_cover)) {
                if (full_domain_cover) {
                    ++time0_group_cover_skip_count_;
                    int domain_size = (direct_var >= 0 && direct_var < (int)g_variable_domain.size()) ? g_variable_domain[direct_var] : 0;
                    time0_group_cover_saved_clauses_ += 1;
                    if (i >= oneofs.orlens)
                        time0_group_cover_saved_clauses_ += (domain_size * (domain_size - 1)) / 2;
                    continue;
                }

                std::vector<int> lits;
                for (j = 0; j < (int)direct_vals.size(); ++j)
                    lits.push_back(fact_var(direct_var, direct_vals[j], 0));
                cnf_.add_clause(lits, CLAUSE_KIND_INIT_GROUP_ATLEAST,
                    std::string("初始组#") + cnf_int_to_string(i) + " 单变量候选值至少满足一项");
                ++time0_direct_literal_group_count_;
                if (i >= oneofs.orlens)
                    time0_direct_literal_group_saved_clauses_ += ((int)direct_vals.size() * ((int)direct_vals.size() - 1)) / 2;
                continue;
            }

            std::map<int,int> items; int nowindex = 0;
            for (j = 0; j < oneofs.oneof[i].len; ++j) for (k = 0; k < oneofs.oneof[i].size[j]; ++k) items[oneofs.oneof[i].var[nowindex++]] = 0;
            std::vector<int> item_terms; nowindex = 0;
            for (j = 0; j < oneofs.oneof[i].len; ++j) {
                std::vector<int> lits;
                if (oneofs.type == 3 || items.size() == 1) {
                    for (m = 0; m < oneofs.oneof[i].size[j]; ++m) { lits.push_back(literal_for_fact(oneofs.oneof[i].var[nowindex], oneofs.oneof[i].val[nowindex], 0)); ++nowindex; }
                } else {
                    std::map<int,int> mark = items; int cursor = 0;
                    for (k = 0; k < oneofs.oneof[i].len; ++k) {
                        for (m = 0; m < oneofs.oneof[i].size[k]; ++m) {
                            if (k == j) { lits.push_back(literal_for_fact(oneofs.oneof[i].var[cursor], oneofs.oneof[i].val[cursor], 0)); mark[oneofs.oneof[i].var[cursor]] = 1; }
                            ++cursor;
                        }
                    }
                    std::map<int,int>::iterator mit;
                    for (mit = mark.begin(); mit != mark.end(); ++mit) if (mit->second == 0) lits.push_back(fact_var(mit->first, g_variable_domain[mit->first] - 1, 0));
                    nowindex = cursor;
                }
                int gate = make_term_gate_from_literals(lits, std::string("初始组#") + cnf_int_to_string(i) + " 项#" + cnf_int_to_string(j), CLAUSE_KIND_INIT_TERM, SATVAR_KIND_AUX_AND);
                item_terms.push_back(gate);
            }
            cnf_.add_clause(item_terms, CLAUSE_KIND_INIT_GROUP_ATLEAST, std::string("初始组#") + cnf_int_to_string(i) + " 至少满足一项");
            if (i >= oneofs.orlens) for (j = 0; j < (int)item_terms.size(); ++j) for (k = j + 1; k < (int)item_terms.size(); ++k) cnf_.add_binary(-item_terms[j], -item_terms[k], CLAUSE_KIND_INIT_GROUP_ATMOST, std::string("初始oneof组#") + cnf_int_to_string(i) + " 两两互斥");
        }
    }

    build_time0_exactly_one(is_unknown);
    cnf_.set_declared_max_var(vm_.max_var());
    vm_.export_snapshot(&static_init_base_.vm_snapshot);
    cnf_.export_snapshot(&static_init_base_.cnf_snapshot);
    static_init_base_.static_var_count = vm_.max_var();
    static_init_base_.static_clause_count = cnf_.num_clauses();
    static_init_base_.ready = true;

    CNF_LOG_BASIC("[CNF-静态基座] 构造完成: vars=" << static_init_base_.static_var_count << ", clauses=" << static_init_base_.static_clause_count);
}

void CounterCNF::restore_round_base_from_static_cache() {
    if (!static_init_base_.ready) return;
    vm_.import_snapshot(static_init_base_.vm_snapshot);
    cnf_.import_snapshot(static_init_base_.cnf_snapshot);
    cnf_.set_declared_max_var(vm_.max_var());
    CNF_LOG_BASIC("[CNF-静态基座] 已恢复静态基座: vars=" << vm_.max_var() << ", clauses=" << cnf_.num_clauses());
}

void CounterCNF::build_round_init_delta(bool isfirst, const std::vector<int> &is_unknown) {
    add_init_restriction_cnf(isfirst, is_unknown);
}

int CounterCNF::compute_common_suffix_length(const Plan &plan) const {
    if (!plan_suffix_summary_.valid) return 0;
    int common = 0;
    int i = (int)plan.size() - 1;
    int j = (int)plan_suffix_summary_.plan_snapshot.size() - 1;
    while (i >= 0 && j >= 0 && plan[i] == plan_suffix_summary_.plan_snapshot[j]) {
        ++common;
        --i;
        --j;
    }
    return common;
}

void CounterCNF::build_action_impact_summary_for_op(const Operator *op, ActionImpactSummary *summary) {
    summary->initialized = true;
    summary->changed_vars.assign(g_variable_domain.size(), 0);
    summary->changed_var_ids.clear();
    summary->prevail_facts.clear();
    if (op == 0) return;
    const std::vector<PrePost> &prepost = op->get_pre_post();
    const std::vector<Prevail> &prevail = op->get_prevail();
    int i;
    for (i = 0; i < (int)prepost.size(); ++i) {
        if (prepost[i].var >= 0 && prepost[i].var < (int)summary->changed_vars.size()) {
            if (!summary->changed_vars[prepost[i].var])
                summary->changed_var_ids.push_back(prepost[i].var);
            summary->changed_vars[prepost[i].var] = 1;
        }
    }
    for (i = 0; i < (int)prevail.size(); ++i)
        summary->prevail_facts.push_back(TimedFact(prevail[i].var, prevail[i].prev, -1));
    ++action_impact_summary_build_count_;
}

const CounterCNF::ActionImpactSummary &CounterCNF::get_action_impact_summary(const Operator *op) {
    std::map<const Operator *, ActionImpactSummary>::iterator it = action_impact_summary_cache_.find(op);
    if (it != action_impact_summary_cache_.end()) return it->second;
    ActionImpactSummary summary;
    build_action_impact_summary_for_op(op, &summary);
    std::pair<std::map<const Operator *, ActionImpactSummary>::iterator, bool> ins = action_impact_summary_cache_.insert(std::make_pair(op, summary));
    return ins.first->second;
}

void CounterCNF::build_plan_suffix_summary(const Plan &plan) {
    const int num_vars = (int)g_variable_domain.size();
    const int plan_size = (int)plan.size();
    const int words = (num_vars + 63) / 64;
    const int common_suffix = compute_common_suffix_length(plan);
    const int prev_size = plan_suffix_summary_.valid ? plan_suffix_summary_.plan_size : 0;
    const int new_suffix_start = plan_size - common_suffix;
    const int old_suffix_start = prev_size - common_suffix;

    PlanSuffixSummary fresh;
    fresh.valid = true;
    fresh.plan_size = plan_size;
    fresh.plan_snapshot = plan;
    fresh.change_points_by_var.assign(num_vars, std::vector<int>());
    fresh.suffix_changed_bits.assign(plan_size + 1, std::vector<unsigned long long>(words, 0ULL));

    int t, i;

    /*
     * P3：公共后缀摘要重放。
     * improve4 已经能复用 suffix_changed_bits 的公共后缀；这里进一步避免
     * 为公共后缀重新扫描所有 action/var 来重建 change_points_by_var。
     * 由于公共后缀的动作序列完全相同，旧 change point 只需要整体平移
     * delta = new_suffix_start - old_suffix_start 即可。前缀仍然按当前 plan 重建。
     */
    if (common_suffix > 0 && plan_suffix_summary_.valid) {
        const int delta = new_suffix_start - old_suffix_start;
        for (i = 0; i < num_vars; ++i) {
            const std::vector<int> &old_points = plan_suffix_summary_.change_points_by_var[i];
            std::vector<int>::const_iterator lb = std::upper_bound(old_points.begin(), old_points.end(), old_suffix_start);
            for (; lb != old_points.end(); ++lb) {
                fresh.change_points_by_var[i].push_back((*lb) + delta);
                ++suffix_change_points_reused_count_;
            }
        }
        suffix_summary_suffix_replayed_steps_ = common_suffix;
    } else {
        suffix_summary_suffix_replayed_steps_ = 0;
    }

    for (t = 0; t < new_suffix_start; ++t) {
        ++suffix_summary_prefix_scanned_steps_;
        const ActionImpactSummary &summary = get_action_impact_summary(plan[t]);
        for (i = 0; i < (int)summary.changed_var_ids.size(); ++i) {
            int var = summary.changed_var_ids[i];
            if (var >= 0 && var < num_vars)
                fresh.change_points_by_var[var].push_back(t + 1);
        }
    }

    for (i = 0; i < num_vars; ++i) {
        std::sort(fresh.change_points_by_var[i].begin(), fresh.change_points_by_var[i].end());
        persistence_change_point_total_ += (int)fresh.change_points_by_var[i].size();
    }

    fresh.suffix_changed_bits[plan_size].assign(words, 0ULL);
    if (common_suffix > 0 && plan_suffix_summary_.valid) {
        ++suffix_summary_reuse_count_;
        last_suffix_reused_steps_ = common_suffix;
        last_suffix_rebuilt_steps_ = new_suffix_start;
        for (t = new_suffix_start; t <= plan_size; ++t)
            fresh.suffix_changed_bits[t] = plan_suffix_summary_.suffix_changed_bits[old_suffix_start + (t - new_suffix_start)];
    } else {
        last_suffix_reused_steps_ = 0;
        last_suffix_rebuilt_steps_ = plan_size;
    }

    for (t = new_suffix_start - 1; t >= 0; --t) {
        fresh.suffix_changed_bits[t] = fresh.suffix_changed_bits[t + 1];
        const ActionImpactSummary &summary = get_action_impact_summary(plan[t]);
        for (i = 0; i < (int)summary.changed_var_ids.size(); ++i) {
            int var = summary.changed_var_ids[i];
            if (var >= 0 && var < num_vars) {
                int w = var >> 6;
                int b = var & 63;
                fresh.suffix_changed_bits[t][w] |= (1ULL << b);
            }
        }
    }

    ++suffix_summary_build_count_;
    persistence_change_vector_build_count_ = num_vars;
    plan_suffix_summary_ = fresh;
}


bool CounterCNF::suffix_may_change_var(int time_index, int var) const {
    if (!plan_suffix_summary_.valid) return true;
    if (time_index < 0 || time_index >= (int)plan_suffix_summary_.suffix_changed_bits.size()) return true;
    if (var < 0) return true;
    int w = var >> 6;
    int b = var & 63;
    if (w < 0 || w >= (int)plan_suffix_summary_.suffix_changed_bits[time_index].size()) return false;
    return (plan_suffix_summary_.suffix_changed_bits[time_index][w] >> b) & 1ULL;
}

int CounterCNF::schedule_fact_requirement(int var, int val, int abs_time,
        CounterCNF::ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts) {
    if (abs_time <= 0) {
        if (time0_facts->insert(std::make_pair(var, val)).second) ++regression_time0_fact_count_;
        return 0;
    }
    ++suffix_jump_queries_;
    int canon = canonical_time_for_fact(var, val, abs_time);
    if (canon < 0) canon = 0;
    if (canon < abs_time) suffix_jump_total_skipped_steps_ += (abs_time - canon);
    if (canon <= 0) {
        if (time0_facts->insert(std::make_pair(var, val)).second) ++regression_time0_fact_count_;
        return 0;
    }

    ++p8_active_schedule_logical_attempt_count_;
    if (p8_active_schedule_suppression_enabled_ && scheduled_layers != 0) {
        ++p8_active_schedule_suppression_attempt_count_;
        if (canon > 0 && canon < p8_active_current_processing_time_ &&
            canon < (int)p8_active_replayed_layer_mask_.size() &&
            p8_active_replayed_layer_mask_[canon]) {
            ++p8_active_schedule_suppressed_count_;
            return canon;
        }
        ++p8_active_schedule_boundary_allowed_count_;
    }

    if (scheduled_layers != 0 && canon >= (int)scheduled_layers->size()) {
        scheduled_layers->resize(canon + 1);
        ++p7_scheduled_layer_vector_resize_count_;
        p7_scheduled_layer_vector_size_ = (int)scheduled_layers->size();
    }
    std::set<int> &bucket = (*scheduled_layers)[canon][var];
    if (bucket.insert(val).second) {
        ++regression_scheduled_fact_count_;
        ++p8_active_schedule_inserted_count_;
    }
    return canon;
}

int CounterCNF::canonical_time_for_fact(int var, int val, int time) const {
    (void)val;
    if (time <= 0) return time;
    if (!plan_suffix_summary_.valid) return time;
    if (var < 0 || var >= (int)plan_suffix_summary_.change_points_by_var.size()) return time;
    const std::vector<int> &changes = plan_suffix_summary_.change_points_by_var[var];
    if (changes.empty()) return 0;
    std::vector<int>::const_iterator it = std::upper_bound(changes.begin(), changes.end(), time);
    if (it == changes.begin()) return 0;
    --it;
    return *it;
}


int CounterCNF::fact_var(int var, int val, int time) {
    int canon_time = canonical_time_for_fact(var, val, time);
    if (canon_time != time) {
        ++persistence_alias_hit_count_;
        persistence_alias_saved_var_count_ += (time - canon_time);
    }
    return vm_.get_fact_var(var, val, canon_time);
}
int CounterCNF::literal_for_fact(int var, int val, int time) { return val >= 0 ? fact_var(var, val, time) : -fact_var(var, -(val + 1), time); }
std::string CounterCNF::fact_desc(int var, int val, int time) const { return vm_.fact_to_string(var, val, time); }
int CounterCNF::make_term_gate_from_literals(const std::vector<int> &lits, const std::string &label, ClauseKind clause_kind, SatVarKind aux_kind) { return cnf_.make_and_gate(lits, aux_kind, clause_kind, label); }

int CounterCNF::get_round_true_var() {
    if (round_true_var_ == 0) {
        round_true_var_ = vm_.new_aux_var(SATVAR_KIND_AUX_AND, "共享恒真");
        cnf_.add_unit(round_true_var_, CLAUSE_KIND_GATE_AND, "共享恒真辅助变量");
    }
    return round_true_var_;
}

void CounterCNF::add_equiv_to_or(int lhs, const std::vector<int> &rhs_lits, const std::string &note) {
    if (rhs_lits.empty()) {
        cnf_.add_unit(-lhs, CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : 空OR恒为假");
        return;
    }
    if (rhs_lits.size() == 1) {
        cnf_.add_binary(-lhs, rhs_lits[0], CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : lhs -> rhs");
        cnf_.add_binary(lhs, -rhs_lits[0], CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : rhs -> lhs");
        return;
    }
    if (rhs_lits.size() == 2) {
        add_equiv_to_or2(lhs, rhs_lits[0], rhs_lits[1], note);
        return;
    }
    std::vector<int> forward;
    forward.reserve(rhs_lits.size() + 1);
    forward.push_back(-lhs);
    std::size_t i;
    for (i = 0; i < rhs_lits.size(); ++i) forward.push_back(rhs_lits[i]);
    cnf_.add_clause(forward, CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : lhs -> OR(rhs)");
    for (i = 0; i < rhs_lits.size(); ++i)
        cnf_.add_binary(lhs, -rhs_lits[i], CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : rhs_lit -> lhs");
}

void CounterCNF::add_equiv_to_and(int lhs, const std::vector<int> &rhs_lits, const std::string &note) {
    if (rhs_lits.empty()) {
        cnf_.add_unit(lhs, CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : 空AND恒为真");
        return;
    }
    if (rhs_lits.size() == 1) {
        cnf_.add_binary(-lhs, rhs_lits[0], CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : lhs -> rhs");
        cnf_.add_binary(lhs, -rhs_lits[0], CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : rhs -> lhs");
        return;
    }
    if (rhs_lits.size() == 2) {
        add_equiv_to_and2(lhs, rhs_lits[0], rhs_lits[1], note);
        return;
    }
    std::size_t i;
    for (i = 0; i < rhs_lits.size(); ++i)
        cnf_.add_binary(-lhs, rhs_lits[i], CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : lhs -> rhs_lit");
    std::vector<int> backward;
    backward.reserve(rhs_lits.size() + 1);
    backward.push_back(lhs);
    for (i = 0; i < rhs_lits.size(); ++i) backward.push_back(-rhs_lits[i]);
    cnf_.add_clause(backward, CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : AND(rhs) -> lhs");
}

void CounterCNF::add_equiv_to_or2(int lhs, int rhs1, int rhs2, const std::string &note) {
    cnf_.add_equiv_or2_fast(lhs, rhs1, rhs2, CLAUSE_KIND_REG_EQUIV, note);
}

void CounterCNF::add_equiv_to_and2(int lhs, int rhs1, int rhs2, const std::string &note) {
    cnf_.add_equiv_and2_fast(lhs, rhs1, rhs2, CLAUSE_KIND_REG_EQUIV, note);
}

void CounterCNF::add_equiv_to_and2_no_dedup(int lhs, int rhs1, int rhs2, const std::string &note) {
    cnf_.add_equiv_and2_no_dedup(lhs, rhs1, rhs2, CLAUSE_KIND_REG_EQUIV, note);
}

void CounterCNF::add_equiv_to_prev_or_and_not_del(int lhs, int prev_lit, int add_or_lit, int del_or_lit, const std::string &note) {
    cnf_.add_binary(-lhs, -del_or_lit, CLAUSE_KIND_REG_EQUIV, note.empty() ? std::string() : note + " : lhs -> not del_or");

    cnf_.add_ternary(-lhs, prev_lit, add_or_lit, CLAUSE_KIND_REG_EQUIV,
        note.empty() ? std::string() : note + " : lhs -> (prev OR add_or)");
    cnf_.add_ternary(lhs, del_or_lit, -prev_lit, CLAUSE_KIND_REG_EQUIV,
        note.empty() ? std::string() : note + " : prev and not del_or -> lhs");
    cnf_.add_ternary(lhs, del_or_lit, -add_or_lit, CLAUSE_KIND_REG_EQUIV,
        note.empty() ? std::string() : note + " : add_or and not del_or -> lhs");
}

std::string CounterCNF::state_to_string_local(const std::vector<int> &vars) const {
    std::ostringstream oss;
    int i;
    for (i = 0; i < (int)vars.size(); ++i) if (vars[i] != g_variable_domain[i] - 1) oss << g_variable_name[i] << "-" << vars[i] << ";";
    return oss.str();
}


bool CounterCNF::use_debug_labels() const {
    return g_cnf_log_detail || g_cnf_log_clause;
}

bool CounterCNF::collect_hotpath_diag() const {
    return g_cnf_log_detail || g_cnf_log_clause;
}

bool CounterCNF::use_reg_equiv_no_dedup_hotpath() const {
    return true;
}

bool CounterCNF::use_frontier_replay_check() const {
    /* P8-check is intentionally diagnostic only.  It is enabled only in
       detailed/clause logging runs so normal performance tests do not pay the
       extra frontier-signature scan cost. */
    return g_cnf_log_detail || g_cnf_log_clause;
}

bool CounterCNF::use_frontier_replay_active() const {
    /* P8-active stage 1 only replays symbolic scheduled frontiers.
       It does not reuse CNF clauses or solver state.  The replayed layers are
       used only to suppress repeated scheduling inside a proven common suffix. */
    return true;
}

int CounterCNF::count_frontier_layer_facts(const std::map<int, std::set<int> > &layer) const {
    int total = 0;
    std::map<int, std::set<int> >::const_iterator it;
    for (it = layer.begin(); it != layer.end(); ++it)
        total += (int)it->second.size();
    return total;
}

void CounterCNF::merge_frontier_layer_into(const std::map<int, std::set<int> > &src,
        std::map<int, std::set<int> > *dst) {
    std::map<int, std::set<int> >::const_iterator it;
    for (it = src.begin(); it != src.end(); ++it) {
        std::set<int> &bucket = (*dst)[it->first];
        bucket.insert(it->second.begin(), it->second.end());
    }
}

CounterCNF::FrontierLayerSignature CounterCNF::make_frontier_layer_signature(
        const std::map<int, std::set<int> > &layer) const {
    FrontierLayerSignature sig;
    sig.valid = true;
    sig.bucket_count = (int)layer.size();
    sig.fact_count = 0;
    unsigned long long h = 1469598103934665603ULL;
    const unsigned long long prime = 1099511628211ULL;
    std::map<int, std::set<int> >::const_iterator bit;
    for (bit = layer.begin(); bit != layer.end(); ++bit) {
        h ^= (unsigned long long)(bit->first + 0x9e3779b9);
        h *= prime;
        h ^= (unsigned long long)(bit->second.size() + 0x85ebca6b);
        h *= prime;
        std::set<int>::const_iterator vit;
        for (vit = bit->second.begin(); vit != bit->second.end(); ++vit) {
            h ^= (unsigned long long)((bit->first + 1) * 1315423911u) ^ (unsigned long long)(*vit + 0x27d4eb2d);
            h *= prime;
            ++sig.fact_count;
        }
    }
    sig.hash = h;
    return sig;
}

std::string CounterCNF::maybe_fact_desc(int var, int val, int time) const {
    if (!use_debug_labels()) return std::string();
    return fact_desc(var, val, time);
}

std::string CounterCNF::make_debug_label(const std::string &prefix, int var, int val, int time) const {
    if (!use_debug_labels()) return std::string();
    return prefix + fact_desc(var, val, time);
}
void CounterCNF::add_init_restriction_cnf(bool isfirst, const std::vector<int> &is_unknown) {
    if (open_closed_loop_avoidance && !isfind && !isfirst) {
        std::map<std::string, state_var>::iterator it;
        for (it = appearcounter.begin(); it != appearcounter.end(); ++it) {
            if (it->second.frequency <= 1) continue;
            std::vector<int> clause; int i;
            for (i = 0; i < (int)it->second.vars.size(); ++i) if (i < (int)is_unknown.size() && is_unknown[i]) clause.push_back(-fact_var(i, it->second.vars[i], 0));
            cnf_.add_clause(clause, CLAUSE_KIND_INIT_FORBID, "禁止重复反例初始状态");
        }
    }
    if (open_closed_loop_avoidance && isfirst) {
        std::map<std::string, state_var>::iterator it2;
        for (it2 = firststate.begin(); it2 != firststate.end(); ++it2) {
            std::vector<int> clause; int i;
            for (i = 0; i < (int)it2->second.vars.size(); ++i) if (i < (int)is_unknown.size() && is_unknown[i]) clause.push_back(-fact_var(i, it2->second.vars[i], 0));
            cnf_.add_clause(clause, CLAUSE_KIND_INIT_FORBID, "禁止已使用过的参考初始状态");
        }
    }
}

void CounterCNF::build_type1_init_cnf(bool isfirst, const std::vector<int> &is_unknown) {
    int i, j, k;
    for (i = 0; i < (int)g_initial_state->vars.size(); ++i)
        if (!is_unknown[i] && axiomtovar.find(std::make_pair(i, g_initial_state->vars[i])) == axiomtovar.end())
            cnf_.add_unit(fact_var(i, g_initial_state->vars[i], 0), CLAUSE_KIND_INIT_KNOWN, std::string("L0确定事实 ") + fact_desc(i, g_initial_state->vars[i], 0));
    std::vector<int> working = g_original_values;
    for (i = 0; i < (int)working.size(); ++i) if (i < (int)is_unknown.size() && is_unknown[i]) working[i] = g_variable_domain[i] - 1;
    std::vector<int> state_terms;
    for (i = 0; i < oneofs.lens && i < (int)oneofs.oneof.size(); ++i) {
        int nowindex = 0;
        for (k = 0; k < oneofs.oneof[i].len; ++k) {
            std::vector<int> changed_vars;
            for (j = 0; j < oneofs.oneof[i].size[k]; ++j) { int var = oneofs.oneof[i].var[nowindex]; int val = oneofs.oneof[i].val[nowindex]; working[var] = val; changed_vars.push_back(var); ++nowindex; }
            std::vector<int> lits;
            for (j = 0; j < (int)working.size(); ++j) if (j < (int)is_unknown.size() && is_unknown[j]) {
                if (working[j] < 0) lits.push_back(-fact_var(j, -(working[j] + 1), 0));
                else lits.push_back(fact_var(j, working[j], 0));
            }
            int term = make_term_gate_from_literals(lits, std::string("ORS完整状态项 #") + cnf_int_to_string((int)state_terms.size()), CLAUSE_KIND_INIT_TERM, SATVAR_KIND_AUX_AND);
            state_terms.push_back(term);
            for (j = 0; j < (int)changed_vars.size(); ++j) working[changed_vars[j]] = g_variable_domain[changed_vars[j]] - 1;
        }
    }
    cnf_.add_clause(state_terms, CLAUSE_KIND_INIT_GROUP_ATLEAST, "ORS 至少选择一个完整状态");
    for (i = 0; i < (int)state_terms.size(); ++i) for (j = i + 1; j < (int)state_terms.size(); ++j) cnf_.add_binary(-state_terms[i], -state_terms[j], CLAUSE_KIND_INIT_GROUP_ATMOST, "ORS 完整状态两两互斥");
    add_init_restriction_cnf(isfirst, is_unknown);
}


void CounterCNF::build_type23_init_cnf(bool isfirst, const std::vector<int> &is_unknown) {
    int i, j, k, m;
    for (i = 0; i < (int)g_initial_state->vars.size(); ++i)
        if (!is_unknown[i] && axiomtovar.find(std::make_pair(i, g_initial_state->vars[i])) == axiomtovar.end())
            cnf_.add_unit(fact_var(i, g_initial_state->vars[i], 0), CLAUSE_KIND_INIT_KNOWN, std::string("L0确定事实 ") + fact_desc(i, g_initial_state->vars[i], 0));

    for (i = 0; i < oneofs.lens + oneofs.orlens; ++i) {
        if (i < 0 || i >= (int)oneofs.oneof.size()) continue;

        int direct_var = -1;
        std::vector<int> direct_vals;
        bool full_domain_cover = false;
        if (analyze_time0_single_var_literal_group(i, &direct_var, &direct_vals, &full_domain_cover)) {
            if (full_domain_cover) {
                ++time0_group_cover_skip_count_;
                int domain_size = (direct_var >= 0 && direct_var < (int)g_variable_domain.size()) ? g_variable_domain[direct_var] : 0;
                time0_group_cover_saved_clauses_ += 1;
                if (i >= oneofs.orlens)
                    time0_group_cover_saved_clauses_ += (domain_size * (domain_size - 1)) / 2;
                continue;
            }

            std::vector<int> lits;
            for (j = 0; j < (int)direct_vals.size(); ++j)
                lits.push_back(fact_var(direct_var, direct_vals[j], 0));
            cnf_.add_clause(lits, CLAUSE_KIND_INIT_GROUP_ATLEAST,
                std::string("初始组#") + cnf_int_to_string(i) + " 单变量候选值至少满足一项");
            ++time0_direct_literal_group_count_;
            if (i >= oneofs.orlens)
                time0_direct_literal_group_saved_clauses_ += ((int)direct_vals.size() * ((int)direct_vals.size() - 1)) / 2;
            continue;
        }

        std::map<int,int> items; int nowindex = 0;
        for (j = 0; j < oneofs.oneof[i].len; ++j)
            for (k = 0; k < oneofs.oneof[i].size[j]; ++k)
                items[oneofs.oneof[i].var[nowindex++]] = 0;

        std::vector<int> item_terms; nowindex = 0;
        for (j = 0; j < oneofs.oneof[i].len; ++j) {
            std::vector<int> lits;
            if (oneofs.type == 3 || items.size() == 1) {
                for (m = 0; m < oneofs.oneof[i].size[j]; ++m) {
                    lits.push_back(literal_for_fact(oneofs.oneof[i].var[nowindex], oneofs.oneof[i].val[nowindex], 0));
                    ++nowindex;
                }
            } else {
                std::map<int,int> mark = items; int cursor = 0;
                for (k = 0; k < oneofs.oneof[i].len; ++k) {
                    for (m = 0; m < oneofs.oneof[i].size[k]; ++m) {
                        if (k == j) {
                            lits.push_back(literal_for_fact(oneofs.oneof[i].var[cursor], oneofs.oneof[i].val[cursor], 0));
                            mark[oneofs.oneof[i].var[cursor]] = 1;
                        }
                        ++cursor;
                    }
                }
                std::map<int,int>::iterator mit;
                for (mit = mark.begin(); mit != mark.end(); ++mit)
                    if (mit->second == 0)
                        lits.push_back(fact_var(mit->first, g_variable_domain[mit->first] - 1, 0));
                nowindex = cursor;
            }
            int gate = make_term_gate_from_literals(lits,
                std::string("初始组#") + cnf_int_to_string(i) + " 项#" + cnf_int_to_string(j),
                CLAUSE_KIND_INIT_TERM, SATVAR_KIND_AUX_AND);
            item_terms.push_back(gate);
        }
        cnf_.add_clause(item_terms, CLAUSE_KIND_INIT_GROUP_ATLEAST,
            std::string("初始组#") + cnf_int_to_string(i) + " 至少满足一项");
        if (i >= oneofs.orlens)
            for (j = 0; j < (int)item_terms.size(); ++j)
                for (k = j + 1; k < (int)item_terms.size(); ++k)
                    cnf_.add_binary(-item_terms[j], -item_terms[k], CLAUSE_KIND_INIT_GROUP_ATMOST,
                        std::string("初始oneof组#") + cnf_int_to_string(i) + " 两两互斥");
    }
    add_init_restriction_cnf(isfirst, is_unknown);
}

bool CounterCNF::analyze_time0_single_var_literal_group(int group_index, int *group_var, std::vector<int> *group_vals, bool *is_full_domain_cover) const {
    if (group_var) *group_var = -1;
    if (group_vals) group_vals->clear();
    if (is_full_domain_cover) *is_full_domain_cover = false;
    if (group_index < 0 || group_index >= (int)oneofs.oneof.size()) return false;

    const oneof_item &group = oneofs.oneof[group_index];
    if (group.len <= 0 || group.size.size() != (std::size_t)group.len) return false;

    int cursor = 0;
    int candidate_var = -1;
    std::vector<int> seen_vals;
    int item_idx;
    for (item_idx = 0; item_idx < group.len; ++item_idx) {
        if (group.size[item_idx] != 1) return false;
        if (cursor >= (int)group.var.size() || cursor >= (int)group.val.size()) return false;
        int var = group.var[cursor];
        int val = group.val[cursor];
        ++cursor;
        if (var < 0 || var >= (int)g_variable_domain.size()) return false;
        if (val < 0 || val >= g_variable_domain[var]) return false;

        if (candidate_var == -1) {
            candidate_var = var;
            seen_vals.assign(g_variable_domain[var], 0);
        } else if (var != candidate_var) {
            return false;
        }

        if (seen_vals[val]) return false;
        seen_vals[val] = 1;
        if (group_vals) group_vals->push_back(val);
    }

    if (cursor != (int)group.var.size() || cursor != (int)group.val.size()) {
        if (group_vals) group_vals->clear();
        return false;
    }
    if (candidate_var == -1) {
        if (group_vals) group_vals->clear();
        return false;
    }

    bool full_cover = true;
    int val_idx;
    for (val_idx = 0; val_idx < (int)seen_vals.size(); ++val_idx)
        if (!seen_vals[val_idx]) { full_cover = false; break; }

    if (group_var) *group_var = candidate_var;
    if (is_full_domain_cover) *is_full_domain_cover = full_cover;
    return true;
}

void CounterCNF::build_time0_exactly_one(const std::vector<int> &is_unknown) {
    int i, j;
    for (i = 0; i < (int)g_variable_domain.size(); ++i) {
        int domain_size = g_variable_domain[i];
        if (domain_size <= 0) continue;

        bool is_fixed_known = (i < (int)is_unknown.size() && !is_unknown[i]
            && g_initial_state->vars[i] >= 0
            && g_initial_state->vars[i] < domain_size
            && axiomtovar.find(std::make_pair(i, g_initial_state->vars[i])) == axiomtovar.end());

        if (is_fixed_known) {
            int fixed_val = g_initial_state->vars[i];
            cnf_.add_unit(fact_var(i, fixed_val, 0),
                CLAUSE_KIND_TIME0_ATLEASTONE,
                std::string("time0 确定变量 ") + g_variable_name[i] + " : 固定真值");
            for (j = 0; j < domain_size; ++j) {
                if (j == fixed_val) continue;
                cnf_.add_unit(-fact_var(i, j, 0),
                    CLAUSE_KIND_TIME0_ATMOSTONE,
                    std::string("time0 确定变量 ") + g_variable_name[i] + " : 排除其他取值");
            }
            ++time0_fixed_compact_count_;
            time0_fixed_saved_clauses_ += (1 + (domain_size * (domain_size - 1)) / 2) - domain_size;
            continue;
        }

        std::vector<int> vars;
        for (j = 0; j < domain_size; ++j) vars.push_back(fact_var(i, j, 0));
        cnf_.add_exactly_one(vars, CLAUSE_KIND_TIME0_ATLEASTONE, CLAUSE_KIND_TIME0_ATMOSTONE,
            std::string("time0 变量 ") + g_variable_name[i]);
    }
}

void CounterCNF::build_init_cnf(bool isfirst) {
    CNF_LOG_BASIC("[CNF-验证] 开始构造初始 belief CNF，isfirst=" << (isfirst ? "true" : "false"));
    if (!static_init_base_.ready)
        build_static_init_base();
    restore_round_base_from_static_cache();
    build_round_init_delta(isfirst, static_init_base_.unknown_mask);
}

void CounterCNF::encode_axiom_goal_roots(int plan_size, const std::set< std::pair<int,int> > &goal_facts, std::set< std::pair<int,int> > *now_facts, std::set<int> *root_vars) {
    std::set< std::pair<int,int> >::const_iterator it;
    for (it = goal_facts.begin(); it != goal_facts.end(); ++it) {
        std::pair<int,int> fact = *it;
        int goal_var = fact_var(fact.first, fact.second, plan_size);
        root_vars->insert(goal_var);
        if (axiomtovar.find(fact) == axiomtovar.end()) { now_facts->insert(fact); continue; }
        const std::vector<PrePost> &defs = axiomtovar[fact];
        std::vector<int> supports; int i, j;
        std::string goal_label = maybe_fact_desc(fact.first, fact.second, plan_size);
        for (i = 0; i < (int)defs.size(); ++i) {
            std::vector<int> cond_lits;
            for (j = 0; j < (int)defs[i].cond.size(); ++j) {
                cond_lits.push_back(fact_var(defs[i].cond[j].var, defs[i].cond[j].prev, plan_size));
                now_facts->insert(std::make_pair(defs[i].cond[j].var, defs[i].cond[j].prev));
            }
            int term = make_term_gate_from_literals(cond_lits, goal_label.empty() ? std::string() : std::string("axiom目标支持 ") + goal_label, CLAUSE_KIND_AXIOM, SATVAR_KIND_AUX_AXIOM);
            supports.push_back(term);
        }
        int axiom_or = cnf_.make_or_gate(supports, SATVAR_KIND_AUX_AXIOM, CLAUSE_KIND_AXIOM, goal_label.empty() ? std::string() : std::string("axiom目标OR ") + goal_label);
        cnf_.add_binary(-goal_var, axiom_or, CLAUSE_KIND_AXIOM, "axiom目标：goal -> support_or");
        cnf_.add_binary(goal_var, -axiom_or, CLAUSE_KIND_AXIOM, "axiom目标：support_or -> goal");
    }
}


int CounterCNF::get_or_create_support_term_id(const std::vector<TimedFact> &cond_facts) {
    SupportTermKey key;
    key.cond_facts = cond_facts;
    std::sort(key.cond_facts.begin(), key.cond_facts.end());
    key.cond_facts.erase(std::unique(key.cond_facts.begin(), key.cond_facts.end()), key.cond_facts.end());

    std::map<SupportTermKey, int>::iterator it = support_term_index_.find(key);
    if (it != support_term_index_.end()) {
        ++support_term_pool_reuse_hit_count_;
        return it->second;
    }

    SupportTermTemplate term;
    term.cond_facts = key.cond_facts;
    int id = (int)support_term_pool_.size();
    support_term_pool_.push_back(term);
    support_term_index_.insert(std::make_pair(key, id));
    return id;
}

const CounterCNF::VarRegressionSkeleton &CounterCNF::get_var_regression_skeleton(const Operator *op, int var) {
    VarRegressionSkeletonKey key(op, var);
    std::map<VarRegressionSkeletonKey, VarRegressionSkeleton>::iterator it = var_regression_skeleton_cache_.find(key);
    if (it != var_regression_skeleton_cache_.end()) {
        ++var_skeleton_cache_hit_count_;
        return it->second;
    }

    ++var_skeleton_cache_miss_count_;
    VarRegressionSkeleton skel;
    skel.initialized = true;
    skel.prevail_facts = get_action_impact_summary(op).prevail_facts;

    int domain_size = 0;
    if (var >= 0 && var < (int)g_variable_domain.size())
        domain_size = g_variable_domain[var];
    skel.add_branch_ids_by_val.resize(domain_size);
    skel.del_branch_ids_by_val.resize(domain_size);
    skel.total_add_branch_count_by_val.assign(domain_size, 0);
    skel.total_del_branch_count_by_val.assign(domain_size, 0);
    skel.add_has_unconditional_by_val.assign(domain_size, 0);
    skel.del_has_unconditional_by_val.assign(domain_size, 0);

    const std::vector<PrePost> &prepost = op->get_pre_post();
    int i, j;
    for (i = 0; i < (int)prepost.size(); ++i) {
        const PrePost &pp = prepost[i];
        if (pp.var != var)
            continue;

        TransitionBranchSkeleton branch;
        branch.initialized = true;
        branch.prepost_index = i;

        std::vector<TimedFact> cond_facts;
        cond_facts.reserve(pp.cond.size());
        for (j = 0; j < (int)pp.cond.size(); ++j)
            cond_facts.push_back(TimedFact(pp.cond[j].var, pp.cond[j].prev, -1));
        if (cond_facts.empty()) {
            branch.unconditional = true;
        } else {
            branch.term_id = get_or_create_support_term_id(cond_facts);
        }

        if (pp.post >= 0 && pp.post < domain_size)
            branch.add_vals.push_back(pp.post);

        if (pp.pre == -1) {
            for (j = 0; j < domain_size; ++j) {
                if (j != pp.post)
                    branch.del_vals.push_back(j);
            }
        } else if (pp.pre >= 0 && pp.pre < domain_size && pp.pre != pp.post) {
            branch.del_vals.push_back(pp.pre);
        }

        int branch_id = (int)skel.branches.size();
        skel.branches.push_back(branch);
        const TransitionBranchSkeleton &stored = skel.branches.back();

        for (j = 0; j < (int)stored.add_vals.size(); ++j) {
            int val = stored.add_vals[j];
            ++skel.total_add_branch_count_by_val[val];
            if (stored.unconditional) {
                skel.add_has_unconditional_by_val[val] = 1;
            } else {
                skel.add_branch_ids_by_val[val].push_back(branch_id);
            }
        }
        for (j = 0; j < (int)stored.del_vals.size(); ++j) {
            int val = stored.del_vals[j];
            ++skel.total_del_branch_count_by_val[val];
            if (stored.unconditional) {
                skel.del_has_unconditional_by_val[val] = 1;
            } else {
                skel.del_branch_ids_by_val[val].push_back(branch_id);
            }
        }
    }

    skel.case_by_val.assign(domain_size, RegressionCaseRecord());
    for (j = 0; j < domain_size; ++j) {
        RegressionCaseRecord rec;
        rec.initialized = true;
        rec.add_has_unconditional = (skel.add_has_unconditional_by_val[j] != 0);
        rec.del_has_unconditional = (skel.del_has_unconditional_by_val[j] != 0);
        rec.total_add_term_count = skel.total_add_branch_count_by_val[j];
        rec.total_del_term_count = skel.total_del_branch_count_by_val[j];
        if (rec.del_has_unconditional)
            rec.case_type = 1;
        else if (rec.add_has_unconditional && skel.del_branch_ids_by_val[j].empty())
            rec.case_type = 2;
        else if (!rec.add_has_unconditional && skel.add_branch_ids_by_val[j].empty() && skel.del_branch_ids_by_val[j].empty())
            rec.case_type = 3;
        else if (skel.del_branch_ids_by_val[j].empty())
            rec.case_type = 4;
        else if (rec.add_has_unconditional)
            rec.case_type = 5;
        else if (skel.add_branch_ids_by_val[j].empty())
            rec.case_type = 6;
        else
            rec.case_type = 7;
        skel.case_by_val[j] = rec;
    }

    std::pair<std::map<VarRegressionSkeletonKey, VarRegressionSkeleton>::iterator, bool> ins =
        var_regression_skeleton_cache_.insert(std::make_pair(key, skel));
    return ins.first->second;
}


int CounterCNF::instantiate_term_from_id(int term_id, int time_step, const std::string &label, ClauseKind clause_kind, SatVarKind aux_kind,
        CounterCNF::ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts) {
    if (term_id < 0 || term_id >= (int)support_term_pool_.size())
        return get_round_true_var();

    const SupportTermTemplate &term_template = support_term_pool_[term_id];
    int i;
    const bool collect_diag = collect_hotpath_diag();
    for (i = 0; i < (int)term_template.cond_facts.size(); ++i) {
        const TimedFact &tf = term_template.cond_facts[i];
        int abs_time = time_step + tf.rel_time;
        schedule_fact_requirement(tf.var, tf.val, abs_time, scheduled_layers, time0_facts);
    }

    InstantiatedTermKey key(term_id, time_step);
    std::map<InstantiatedTermKey, int>::iterator it = instantiated_term_cache_.find(key);
    if (it != instantiated_term_cache_.end()) {
        ++instantiated_term_cache_hit_count_;
        return it->second;
    }

    ++instantiated_term_cache_miss_count_;
    if (term_template.cond_facts.empty()) {
        if (collect_diag) ++diag_empty_support_term_count_;
        int gate_true = get_round_true_var();
        instantiated_term_cache_[key] = gate_true;
        return gate_true;
    }
    if (collect_diag) ++diag_nonempty_support_term_count_;
    std::vector<int> cond_lits;
    cond_lits.reserve(term_template.cond_facts.size());
    for (i = 0; i < (int)term_template.cond_facts.size(); ++i) {
        const TimedFact &tf = term_template.cond_facts[i];
        int abs_time = time_step + tf.rel_time;
        cond_lits.push_back(fact_var(tf.var, tf.val, abs_time));
    }
    int gate = make_term_gate_from_literals(cond_lits, label, clause_kind, aux_kind);
    instantiated_term_cache_[key] = gate;
    return gate;
}

void CounterCNF::regress_var_bucket(const Operator *op, int var, const std::set<int> &requested_vals, int time_step,
        CounterCNF::ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts,
        std::set<int> *root_vars) {
    regression_call_count_ += (int)requested_vals.size();
    const bool collect_diag = collect_hotpath_diag();

    const ActionImpactSummary &impact = get_action_impact_summary(op);
    int i;
    for (i = 0; i < (int)impact.prevail_facts.size(); ++i) {
        const TimedFact &tf = impact.prevail_facts[i];
        int abs_time = time_step + tf.rel_time;
        int root = fact_var(tf.var, tf.val, abs_time);
        root_vars->insert(root);
        schedule_fact_requirement(tf.var, tf.val, abs_time, scheduled_layers, time0_facts);
    }

    bool maybe_changes_var = (var >= 0 && var < (int)impact.changed_vars.size() && impact.changed_vars[var]);
    if (!maybe_changes_var) {
        ++action_impact_fastskip_count_;
        for (std::set<int>::const_iterator vit = requested_vals.begin(); vit != requested_vals.end(); ++vit) {
            int val = *vit;
            ++persist_shortcut_count_;
            int cur = fact_var(var, val, time_step);
            int prev = fact_var(var, val, time_step - 1);
            schedule_fact_requirement(var, val, time_step - 1, scheduled_layers, time0_facts);
            if (cur == prev) {
                ++persistence_tautology_skip_count_;
                continue;
            }
            cnf_.add_binary(-cur, prev, CLAUSE_KIND_REG_EQUIV, use_debug_labels() ? "动作无关快速纯保持：cur -> prev" : std::string());
            cnf_.add_binary(cur, -prev, CLAUSE_KIND_REG_EQUIV, use_debug_labels() ? "动作无关快速纯保持：prev -> cur" : std::string());
        }
        return;
    }

    const VarRegressionSkeleton &skel = get_var_regression_skeleton(op, var);
    std::vector<int> instantiated_branch_lits(skel.branches.size(), 0);

    for (std::set<int>::const_iterator vit = requested_vals.begin(); vit != requested_vals.end(); ++vit) {
        int val = *vit;
        if (val < 0 || val >= (int)skel.add_branch_ids_by_val.size())
            continue;

        const std::string fact_label = maybe_fact_desc(var, val, time_step);
        const std::string add_support_label = fact_label.empty() ? std::string() : std::string("回归ADD支持 ") + fact_label;
        const std::string del_support_label = fact_label.empty() ? std::string() : std::string("回归DEL支持 ") + fact_label;

        int cur = fact_var(var, val, time_step);

        const RegressionCaseRecord &case_rec = skel.case_by_val[val];
        if (collect_diag) ++regression_case_record_use_count_;
        bool del_has_unconditional = case_rec.del_has_unconditional;
        bool add_has_unconditional = case_rec.add_has_unconditional;
        int total_add_term_count = case_rec.total_add_term_count;
        int total_del_term_count = case_rec.total_del_term_count;
        const std::vector<int> &add_branch_ids = skel.add_branch_ids_by_val[val];
        const std::vector<int> &del_branch_ids = skel.del_branch_ids_by_val[val];

        if (del_has_unconditional) {
            ++unconditional_del_shortcut_count_;
            ++lazy_prev_var_avoid_count_;
            if (collect_diag) ++regression_case_early_exit_count_;
            cnf_.add_unit(-cur, CLAUSE_KIND_REG_EQUIV,
                fact_label.empty() ? std::string() : std::string("回归无条件DEL：") + fact_label);
            continue;
        }

        if (case_rec.case_type == 2) {
            ++unconditional_add_shortcut_count_;
            ++lazy_prev_var_avoid_count_;
            if (collect_diag) ++regression_case_early_exit_count_;
            dominated_add_term_skip_count_ += std::max(0, total_add_term_count - 1);
            cnf_.add_unit(cur, CLAUSE_KIND_REG_EQUIV,
                fact_label.empty() ? std::string() : std::string("回归无条件ADD且无DEL：") + fact_label);
            continue;
        }

        if (case_rec.case_type == 3) {
            ++persist_shortcut_count_;
            if (collect_diag) ++regression_case_early_exit_count_;
            int prev = fact_var(var, val, time_step - 1);
            schedule_fact_requirement(var, val, time_step - 1, scheduled_layers, time0_facts);
            if (cur == prev) {
                ++persistence_tautology_skip_count_;
                continue;
            }
            cnf_.add_binary(-cur, prev, CLAUSE_KIND_REG_EQUIV, use_debug_labels() ? "回归纯保持：cur -> prev" : std::string());
            cnf_.add_binary(cur, -prev, CLAUSE_KIND_REG_EQUIV, use_debug_labels() ? "回归纯保持：prev -> cur" : std::string());
            continue;
        }

        std::vector<int> add_terms;
        std::vector<int> del_terms;

        if (!add_has_unconditional) {
            add_terms.reserve(add_branch_ids.size());
            for (i = 0; i < (int)add_branch_ids.size(); ++i) {
                int branch_id = add_branch_ids[i];
                int lit = instantiated_branch_lits[branch_id];
                if (lit != 0) {
                    if (collect_diag) ++p4_branch_lit_vector_hit_count_;
                } else {
                    if (collect_diag) ++p4_branch_lit_vector_miss_count_;
                    const TransitionBranchSkeleton &branch = skel.branches[branch_id];
                    lit = instantiate_term_from_id(
                        branch.term_id,
                        time_step,
                        add_support_label,
                        CLAUSE_KIND_GATE_AND,
                        SATVAR_KIND_AUX_AND,
                        scheduled_layers,
                        time0_facts);
                    instantiated_branch_lits[branch_id] = lit;
                }
                add_terms.push_back(lit);
            }
            regression_instantiated_add_term_count_ += (int)add_branch_ids.size();
        } else {
            dominated_add_term_skip_count_ += std::max(0, total_add_term_count - 1);
        }

        del_terms.reserve(del_branch_ids.size());
        for (i = 0; i < (int)del_branch_ids.size(); ++i) {
            int branch_id = del_branch_ids[i];
            int lit = instantiated_branch_lits[branch_id];
            if (lit != 0) {
                if (collect_diag) ++p4_branch_lit_vector_hit_count_;
            } else {
                if (collect_diag) ++p4_branch_lit_vector_miss_count_;
                const TransitionBranchSkeleton &branch = skel.branches[branch_id];
                lit = instantiate_term_from_id(
                    branch.term_id,
                    time_step,
                    del_support_label,
                    CLAUSE_KIND_GATE_AND,
                    SATVAR_KIND_AUX_AND,
                    scheduled_layers,
                    time0_facts);
                instantiated_branch_lits[branch_id] = lit;
            }
            del_terms.push_back(lit);
        }
        regression_instantiated_del_term_count_ += (int)del_branch_ids.size();
        if (del_has_unconditional)
            dominated_del_term_skip_count_ += std::max(0, total_del_term_count - (int)del_branch_ids.size());

        if (add_terms.empty() && del_terms.empty() && !add_has_unconditional) {
            ++persist_shortcut_count_;
            int prev = fact_var(var, val, time_step - 1);
            schedule_fact_requirement(var, val, time_step - 1, scheduled_layers, time0_facts);
            if (cur == prev) {
                ++persistence_tautology_skip_count_;
                continue;
            }
            cnf_.add_binary(-cur, prev, CLAUSE_KIND_REG_EQUIV, use_debug_labels() ? "回归纯保持：cur -> prev" : std::string());
            cnf_.add_binary(cur, -prev, CLAUSE_KIND_REG_EQUIV, use_debug_labels() ? "回归纯保持：prev -> cur" : std::string());
            continue;
        }

        if (add_has_unconditional && del_terms.empty()) {
            ++unconditional_add_shortcut_count_;
            ++lazy_prev_var_avoid_count_;
            cnf_.add_unit(cur, CLAUSE_KIND_REG_EQUIV,
                fact_label.empty() ? std::string() : std::string("回归无条件ADD且无DEL：") + fact_label);
            continue;
        }

        if (del_terms.empty()) {
            ++no_del_direct_count_;
            int prev = fact_var(var, val, time_step - 1);
            schedule_fact_requirement(var, val, time_step - 1, scheduled_layers, time0_facts);
            if (add_terms.size() == 1) {
                if (collect_diag) ++p4_no_del_single_add_direct_count_;
                add_equiv_to_or2(cur, add_terms[0], prev,
                    (fact_label.empty() ? std::string() : std::string("P4回归无DEL单ADD直接OR2 ") + fact_label));
            } else {
                std::vector<int> rhs_lits = add_terms;
                rhs_lits.push_back(prev);
                add_equiv_to_or(cur, rhs_lits, (fact_label.empty() ? std::string() : std::string("回归无DEL直接OR等价 ") + fact_label));
            }
            continue;
        }

        if (add_has_unconditional) {
            ++unconditional_add_shortcut_count_;
            ++lazy_prev_var_avoid_count_;
            if (del_terms.size() == 1) {
                if (collect_diag) ++p4_uncond_add_single_del_direct_count_;
                int del_lit = del_terms[0];
                cnf_.add_binary(-cur, -del_lit, CLAUSE_KIND_REG_EQUIV,
                    fact_label.empty() ? std::string() : std::string("P4回归无条件ADD单DEL：cur -> not del ") + fact_label);
                cnf_.add_binary(cur, del_lit, CLAUSE_KIND_REG_EQUIV,
                    fact_label.empty() ? std::string() : std::string("P4回归无条件ADD单DEL：not del -> cur ") + fact_label);
            } else {
                int del_or_direct = cnf_.make_or_gate(del_terms, SATVAR_KIND_AUX_OR, CLAUSE_KIND_GATE_OR,
                    (fact_label.empty() ? std::string() : std::string("回归无条件ADD_DEL_OR ") + fact_label));
                cnf_.add_binary(-cur, -del_or_direct, CLAUSE_KIND_REG_EQUIV,
                    fact_label.empty() ? std::string() : std::string("回归无条件ADD：cur -> not del_or ") + fact_label);
                cnf_.add_binary(cur, del_or_direct, CLAUSE_KIND_REG_EQUIV,
                    fact_label.empty() ? std::string() : std::string("回归无条件ADD：not del_or -> cur ") + fact_label);
            }
            continue;
        }

        if (add_terms.empty()) {
            ++no_add_direct_count_;
            int prev = fact_var(var, val, time_step - 1);
            schedule_fact_requirement(var, val, time_step - 1, scheduled_layers, time0_facts);
            if (del_terms.size() == 1) {
                if (collect_diag) ++p4_no_add_single_del_direct_count_;
                if (use_reg_equiv_no_dedup_hotpath()) {
                    ++p6_reg_equiv_and2_no_dedup_count_;
                    add_equiv_to_and2_no_dedup(cur, prev, -del_terms[0],
                        (fact_label.empty() ? std::string() : std::string("P6回归无ADD单DEL直接AND2去重旁路 ") + fact_label));
                } else {
                    add_equiv_to_and2(cur, prev, -del_terms[0],
                        (fact_label.empty() ? std::string() : std::string("P6回归无ADD单DEL直接AND2保守去重路径 ") + fact_label));
                }
            } else {
                int del_or_direct = cnf_.make_or_gate(del_terms, SATVAR_KIND_AUX_OR, CLAUSE_KIND_GATE_OR,
                    (fact_label.empty() ? std::string() : std::string("回归无ADD_DEL_OR ") + fact_label));
                std::vector<int> rhs_lits;
                rhs_lits.reserve(2);
                rhs_lits.push_back(prev);
                rhs_lits.push_back(-del_or_direct);
                add_equiv_to_and(cur, rhs_lits, (fact_label.empty() ? std::string() : std::string("回归无ADD直接AND等价 ") + fact_label));
            }
            continue;
        }

        int prev = fact_var(var, val, time_step - 1);
        schedule_fact_requirement(var, val, time_step - 1, scheduled_layers, time0_facts);
        int add_or;
        if (add_terms.size() == 1) {
            if (collect_diag) ++p4_general_single_add_bypass_count_;
            add_or = add_terms[0];
        } else {
            add_or = cnf_.make_or_gate(add_terms, SATVAR_KIND_AUX_OR, CLAUSE_KIND_GATE_OR,
                (fact_label.empty() ? std::string() : std::string("回归ADD_OR ") + fact_label));
        }
        int del_or;
        if (del_terms.size() == 1) {
            if (collect_diag) ++p4_general_single_del_bypass_count_;
            del_or = del_terms[0];
        } else {
            del_or = cnf_.make_or_gate(del_terms, SATVAR_KIND_AUX_OR, CLAUSE_KIND_GATE_OR,
                (fact_label.empty() ? std::string() : std::string("回归DEL_OR ") + fact_label));
        }

        ++general_direct_count_;
        add_equiv_to_prev_or_and_not_del(cur, prev, add_or, del_or,
            (fact_label.empty() ? std::string() : std::string("回归一般情形直接子句编码 ") + fact_label));
    }
}


void CounterCNF::regress_one_fact(const Operator *op, const std::pair<int,int> &fact, int time_step,
        CounterCNF::ScheduledFactLayers *scheduled_layers,
        std::set< std::pair<int,int> > *time0_facts,
        std::set<int> *root_vars) {
    std::set<int> singleton;
    singleton.insert(fact.second);
    regress_var_bucket(op, fact.first, singleton, time_step, scheduled_layers, time0_facts, root_vars);
}

void CounterCNF::precompute_persistence_time_representatives(const Plan &plan) {
    build_plan_suffix_summary(plan);
}

void CounterCNF::build_goal_regression_cnf(const Plan &plan) {
    CNF_LOG_BASIC("[CNF-验证] 开始构造计划失败 CNF，计划长度=" << plan.size());
    precompute_persistence_time_representatives(plan);
    int i;
    std::set< std::pair<int,int> > goal_facts;
    std::set<int> root_vars;
    const int plan_size = plan.size();
    const bool collect_diag = collect_hotpath_diag();
    diag_plan_size_ = plan_size;
    for (i = 0; i < (int)g_goal.size(); ++i) goal_facts.insert(g_goal[i]);

    std::set< std::pair<int,int> > initial_goal_facts;
    encode_axiom_goal_roots(plan_size, goal_facts, &initial_goal_facts, &root_vars);

    ScheduledFactLayers scheduled_layers(plan_size + 1);
    p7_scheduled_layer_vector_size_ = (int)scheduled_layers.size();

    const bool p8_check = use_frontier_replay_check();
    const int p8_common_suffix = last_suffix_reused_steps_;
    const int p8_new_suffix_start = plan_size - p8_common_suffix;
    const int p8_old_plan_size = last_regression_frontier_plan_size_;
    const int p8_old_suffix_start = p8_old_plan_size - p8_common_suffix;
    p8_frontier_common_suffix_ = p8_common_suffix;

    const bool p8_active_candidate =
        use_frontier_replay_active() &&
        p8_common_suffix > 1 &&
        p8_old_plan_size > 0 &&
        p8_old_suffix_start >= 0 &&
        !last_regression_frontier_layers_.empty() &&
        (int)last_regression_frontier_layers_.size() == p8_old_plan_size + 1;

    std::vector<FrontierLayerSignature> current_frontier_signatures;
    if (p8_check) current_frontier_signatures.assign(plan_size + 1, FrontierLayerSignature());
    ScheduledFactLayers current_frontier_layers;
    current_frontier_layers.resize(plan_size + 1);

    std::set< std::pair<int,int> > time0_facts;
    std::set< std::pair<int,int> >::const_iterator fit;
    for (fit = initial_goal_facts.begin(); fit != initial_goal_facts.end(); ++fit)
        schedule_fact_requirement(fit->first, fit->second, plan_size, &scheduled_layers, &time0_facts);

    p8_active_replayed_layer_mask_.assign(plan_size + 1, 0);
    if (p8_active_candidate) {
        int new_t;
        for (new_t = p8_new_suffix_start + 1; new_t <= plan_size; ++new_t) {
            int old_t = p8_old_suffix_start + (new_t - p8_new_suffix_start);
            if (old_t < 0 || old_t >= (int)last_regression_frontier_layers_.size())
                continue;
            const std::map<int, std::set<int> > &src = last_regression_frontier_layers_[old_t];
            if (src.empty())
                continue;
            merge_frontier_layer_into(src, &scheduled_layers[new_t]);
            p8_active_replayed_layer_mask_[new_t] = 1;
            ++p8_active_replayed_layers_;
            p8_active_replayed_buckets_ += (int)src.size();
            p8_active_replayed_facts_ += count_frontier_layer_facts(src);
        }
        if (p8_active_replayed_layers_ > 0)
            p8_active_enabled_ = 1;
    }

    for (i = 1; i <= plan_size && i < (int)scheduled_layers.size(); ++i) {
        if (scheduled_layers[i].empty()) continue;
        int layer_fact_count = 0;
        for (std::map<int, std::set<int> >::const_iterator bit = scheduled_layers[i].begin(); bit != scheduled_layers[i].end(); ++bit)
            layer_fact_count += (int)bit->second.size();
        if (layer_fact_count > regression_layer_peak_fact_count_)
            regression_layer_peak_fact_count_ = layer_fact_count;
    }

    for (i = plan_size - 1; i >= 0; --i) {
        if (collect_diag) ++diag_regression_loop_steps_scanned_;
        const int time_step = i + 1;
        if (time_step < 0 || time_step >= (int)scheduled_layers.size()) continue;
        if (scheduled_layers[time_step].empty()) continue;
        if (p8_check) {
            FrontierLayerSignature sig = make_frontier_layer_signature(scheduled_layers[time_step]);
            if (time_step >= 0 && time_step < (int)current_frontier_signatures.size())
                current_frontier_signatures[time_step] = sig;
            if (p8_common_suffix > 0 && !last_regression_frontier_signatures_.empty() && time_step > p8_new_suffix_start) {
                int old_time = p8_old_suffix_start + (time_step - p8_new_suffix_start);
                if (old_time >= 0 && old_time < (int)last_regression_frontier_signatures_.size() &&
                    last_regression_frontier_signatures_[old_time].valid) {
                    ++p8_frontier_compared_layers_;
                    if (sig.same_as(last_regression_frontier_signatures_[old_time]))
                        ++p8_frontier_equal_layers_;
                    else
                        ++p8_frontier_mismatch_layers_;
                } else {
                    ++p8_frontier_skipped_layers_;
                }
            }
        }
        if (collect_diag) ++diag_regression_active_layer_count_;
        std::map<int, std::set<int> > current;
        current.swap(scheduled_layers[time_step]);
        if (collect_diag) ++p4_layer_swap_count_;

        current_frontier_layers[time_step] = current;

        int current_fact_count = 0;
        for (std::map<int, std::set<int> >::const_iterator bit = current.begin(); bit != current.end(); ++bit)
            current_fact_count += (int)bit->second.size();
        regression_processed_fact_count_ += current_fact_count;
        if (collect_diag) diag_regression_processed_bucket_count_ += (int)current.size();
        if (current_fact_count > regression_layer_peak_fact_count_)
            regression_layer_peak_fact_count_ = current_fact_count;

        p8_active_schedule_suppression_enabled_ =
            (p8_active_enabled_ != 0) &&
            time_step > p8_new_suffix_start + 1 &&
            time_step < (int)p8_active_replayed_layer_mask_.size() &&
            p8_active_replayed_layer_mask_[time_step];
        p8_active_current_processing_time_ = time_step;

        for (std::map<int, std::set<int> >::const_iterator bit = current.begin(); bit != current.end(); ++bit)
            regress_var_bucket(plan[i], bit->first, bit->second, time_step, &scheduled_layers, &time0_facts, &root_vars);

        p8_active_schedule_suppression_enabled_ = false;
        p8_active_current_processing_time_ = -1;
    }

    last_regression_frontier_layers_.swap(current_frontier_layers);
    if (p8_check) {
        last_regression_frontier_signatures_.swap(current_frontier_signatures);
    } else {
        last_regression_frontier_signatures_.clear();
    }
    last_regression_frontier_plan_size_ = plan_size;

    regression_unique_fact_count_ = (int)time0_facts.size();
    goal_root_var_count_ = (int)root_vars.size();
    std::vector<int> fail_clause; std::set<int>::const_iterator rit;
    for (rit = root_vars.begin(); rit != root_vars.end(); ++rit) fail_clause.push_back(-(*rit));
    cnf_.add_clause(fail_clause, CLAUSE_KIND_ROOT_FAIL, "最终失败条件：不是所有根条件都成立");
}
bool CounterCNF::build_state_from_sample(const std::map<int,int> &sample, const std::vector<int> &base_state, std::vector<int> *state) const {
    *state = base_state;
    std::map<int,int>::const_iterator it;
    for (it = sample.begin(); it != sample.end(); ++it) {
        if (it->first < 0 || it->first >= (int)state->size()) return false;
        (*state)[it->first] = it->second;
    }
    return true;
}

bool CounterCNF::solve_with_minisat() {
    minisat_last_has_counterexample_ = false;
    minisat_last_result_valid_ = false;
    minisat_last_sample_valid_ = false;
    minisat_last_counterexample_state_.clear();
    minisat_load_time_ms_ = 0;
    minisat_solve_time_ms_ = 0;
    minisat_model_extract_time_ms_ = 0;

    if (!minisat_solver_.is_available()) {
        CNF_LOG_BASIC("[CNF-MiniSAT] MiniSAT 未启用，跳过 MiniSAT 验证分支。 如需启用，请在 Makefile 中使用 ENABLE_MINISAT=1，并配置 MINISAT_ROOT/MINISAT_LIB。");
        return false;
    }

    std::clock_t load_begin = std::clock();
    if (!minisat_solver_.load_cnf(cnf_)) return false;
    std::clock_t load_end = std::clock();
    minisat_load_time_ms_ = clock_diff_ms(load_begin, load_end);

    std::clock_t solve_begin = std::clock();
    int res = minisat_solver_.solve();
    std::clock_t solve_end = std::clock();
    minisat_solve_time_ms_ = clock_diff_ms(solve_begin, solve_end);
    minisat_last_result_valid_ = true;

    if (res == 10) {
        std::map<int,int> sample;
        std::map<int,int> conflicts;
        minisat_last_has_counterexample_ = true;
        std::clock_t extract_begin = std::clock();
        if (!minisat_solver_.extract_time0_sample(vm_, &sample, &conflicts)) {
            minisat_last_sample_valid_ = false;
            minisat_model_extract_time_ms_ = 0;
            minisat_last_counterexample_state_.clear();
            return false;
        }
        if (!build_state_from_sample(sample, validation_base_state_, &minisat_last_counterexample_state_)) {
            minisat_last_sample_valid_ = false;
            minisat_model_extract_time_ms_ = 0;
            minisat_last_counterexample_state_.clear();
            return false;
        }
        std::clock_t extract_end = std::clock();
        minisat_model_extract_time_ms_ = clock_diff_ms(extract_begin, extract_end);
        minisat_last_sample_valid_ = true;
        return true;
    }

    minisat_model_extract_time_ms_ = 0;
    minisat_last_has_counterexample_ = false;
    minisat_last_sample_valid_ = false;
    return false;
}

bool CounterCNF::solve_with_glucose() {
    glucose_last_has_counterexample_ = false;
    glucose_last_result_valid_ = false;
    glucose_last_sample_valid_ = false;
    glucose_last_counterexample_state_.clear();
    glucose_load_time_ms_ = 0;
    glucose_solve_time_ms_ = 0;
    glucose_model_extract_time_ms_ = 0;

    if (!glucose_solver_.is_available()) {
        CNF_LOG_BASIC("[CNF-Glucose] Glucose 未启用，跳过 Glucose 验证分支。 如需启用，请在 Makefile 中使用 ENABLE_GLUCOSE=1，并配置 GLUCOSE_ROOT/GLUCOSE_LIB。");
        return false;
    }

    std::clock_t load_begin = std::clock();
    if (!glucose_solver_.load_cnf(cnf_)) return false;
    std::clock_t load_end = std::clock();
    glucose_load_time_ms_ = clock_diff_ms(load_begin, load_end);

    std::clock_t solve_begin = std::clock();
    int res = glucose_solver_.solve();
    std::clock_t solve_end = std::clock();
    glucose_solve_time_ms_ = clock_diff_ms(solve_begin, solve_end);
    glucose_last_result_valid_ = true;

    if (res == 10) {
        std::map<int,int> sample;
        std::map<int,int> conflicts;
        glucose_last_has_counterexample_ = true;
        std::clock_t extract_begin = std::clock();
        if (!glucose_solver_.extract_time0_sample(vm_, &sample, &conflicts)) {
            glucose_last_sample_valid_ = false;
            glucose_model_extract_time_ms_ = 0;
            glucose_last_counterexample_state_.clear();
            return false;
        }
        if (!build_state_from_sample(sample, validation_base_state_, &glucose_last_counterexample_state_)) {
            glucose_last_sample_valid_ = false;
            glucose_model_extract_time_ms_ = 0;
            glucose_last_counterexample_state_.clear();
            return false;
        }
        std::clock_t extract_end = std::clock();
        glucose_model_extract_time_ms_ = clock_diff_ms(extract_begin, extract_end);
        glucose_last_sample_valid_ = true;
        return true;
    }

    glucose_model_extract_time_ms_ = 0;
    glucose_last_has_counterexample_ = false;
    glucose_last_sample_valid_ = false;
    return false;
}

bool CounterCNF::solve_with_cadical() {
    cadical_last_has_counterexample_ = false;
    cadical_last_result_valid_ = false;
    cadical_last_sample_valid_ = false;
    cadical_last_counterexample_state_.clear();
    cadical_load_time_ms_ = 0;
    cadical_solve_time_ms_ = 0;
    cadical_model_extract_time_ms_ = 0;

    if (!cadical_solver_.is_available()) {
        CNF_LOG_BASIC("[CNF-CaDiCaL] CaDiCaL 未启用，跳过 CaDiCaL 验证分支。 如需启用，请在 Makefile 中使用 ENABLE_CADICAL=1，并配置 CADICAL_ROOT/CADICAL_LIB。");
        return false;
    }

    std::clock_t load_begin = std::clock();
    if (!cadical_solver_.load_cnf(cnf_)) return false;
    std::clock_t load_end = std::clock();
    cadical_load_time_ms_ = clock_diff_ms(load_begin, load_end);

    std::clock_t solve_begin = std::clock();
    int res = cadical_solver_.solve();
    std::clock_t solve_end = std::clock();
    cadical_solve_time_ms_ = clock_diff_ms(solve_begin, solve_end);
    cadical_last_result_valid_ = true;

    if (res == 10) {
        std::map<int,int> sample;
        std::map<int,int> conflicts;
        cadical_last_has_counterexample_ = true;
        std::clock_t extract_begin = std::clock();
        if (!cadical_solver_.extract_time0_sample(vm_, &sample, &conflicts)) {
            cadical_last_sample_valid_ = false;
            cadical_model_extract_time_ms_ = 0;
            cadical_last_counterexample_state_.clear();
            return false;
        }
        if (!build_state_from_sample(sample, validation_base_state_, &cadical_last_counterexample_state_)) {
            cadical_last_sample_valid_ = false;
            cadical_model_extract_time_ms_ = 0;
            cadical_last_counterexample_state_.clear();
            return false;
        }
        std::clock_t extract_end = std::clock();
        cadical_model_extract_time_ms_ = clock_diff_ms(extract_begin, extract_end);
        cadical_last_sample_valid_ = true;
        return true;
    }

    cadical_model_extract_time_ms_ = 0;
    cadical_last_has_counterexample_ = false;
    cadical_last_sample_valid_ = false;
    return false;
}

bool CounterCNF::solve_with_kissat() {
    last_var_count_ = vm_.max_var();
    last_clause_count_ = cnf_.num_clauses();
    kissat_last_has_counterexample_ = false;
    kissat_last_result_valid_ = false;
    kissat_last_sample_valid_ = false;
    kissat_last_counterexample_state_.clear();

    int singleton_and_folds = cnf_.singleton_and_fold_count();
    int singleton_or_folds = cnf_.singleton_or_fold_count();
    int duplicate_clause_skips = cnf_.duplicate_clause_skip_count();
    int gate_input_duplicate_removed = cnf_.gate_input_duplicate_removed_count();
    int complementary_and_folds = cnf_.complementary_and_fold_count();
    int complementary_or_folds = cnf_.complementary_or_fold_count();
    int complementary_gate_saved_clauses = cnf_.complementary_gate_saved_clause_count();
    int shared_and_gate_hits = cnf_.shared_and_gate_hit_count();
    int shared_or_gate_hits = cnf_.shared_or_gate_hit_count();
    int shared_gate_saved_vars = cnf_.shared_gate_saved_var_count();
    int shared_gate_saved_clauses = cnf_.shared_gate_saved_clause_count();
    int est_saved_vars = singleton_and_folds + singleton_or_folds
        + shared_gate_saved_vars
        + 4 * persist_shortcut_count_
        + no_del_saved_vars_
        + no_add_saved_vars_
        + general_saved_vars_;
    int est_saved_clauses = 2 * singleton_and_folds + 2 * singleton_or_folds
        + gate_input_duplicate_removed
        + complementary_gate_saved_clauses
        + shared_gate_saved_clauses
        + 8 * persist_shortcut_count_
        + no_del_saved_clauses_
        + no_add_saved_clauses_
        + general_saved_clauses_
        + time0_fixed_saved_clauses_
        + time0_group_cover_saved_clauses_
        + time0_direct_literal_group_saved_clauses_
        + duplicate_clause_skips;

    CNF_LOG_BASIC("[CNF-化简] 单输入AND折叠次数=" << singleton_and_folds);
    CNF_LOG_BASIC("[CNF-化简] 单输入OR折叠次数=" << singleton_or_folds);
    CNF_LOG_BASIC("[CNF-化简] 门输入去重删除字面量次数=" << gate_input_duplicate_removed);
    CNF_LOG_BASIC("[CNF-化简] AND门互补折叠次数=" << complementary_and_folds);
    CNF_LOG_BASIC("[CNF-化简] OR门互补折叠次数=" << complementary_or_folds);
    CNF_LOG_BASIC("[CNF-化简] AND门结构共享复用次数=" << shared_and_gate_hits);
    CNF_LOG_BASIC("[CNF-化简] OR门结构共享复用次数=" << shared_or_gate_hits);
    CNF_LOG_BASIC("[CNF-化简] 纯保持事实快捷编码次数=" << persist_shortcut_count_);
    CNF_LOG_BASIC("[CNF-化简] 无DEL直接OR等价次数=" << no_del_direct_count_);
    CNF_LOG_BASIC("[CNF-化简] 无ADD直接AND等价次数=" << no_add_direct_count_);
    CNF_LOG_BASIC("[CNF-化简] 无条件ADD快捷编码次数=" << unconditional_add_shortcut_count_);
    CNF_LOG_BASIC("[CNF-化简] 无条件DEL快捷编码次数=" << unconditional_del_shortcut_count_);
    CNF_LOG_BASIC("[CNF-化简] 被无条件项支配而跳过的ADD支持项数=" << dominated_add_term_skip_count_);
    CNF_LOG_BASIC("[CNF-化简] 被无条件项支配而跳过的DEL支持项数=" << dominated_del_term_skip_count_);
    CNF_LOG_BASIC("[CNF-化简] 延迟prev创建并避免无用前驱变量次数=" << lazy_prev_var_avoid_count_);
    CNF_LOG_BASIC("[CNF-化简] 一般情形直接子句编码次数=" << general_direct_count_);
    CNF_LOG_BASIC("[CNF-化简] time0确定变量紧凑编码次数=" << time0_fixed_compact_count_);
    CNF_LOG_BASIC("[CNF-化简] time0完整oneof/OR全域覆盖并吸收次数=" << time0_group_cover_skip_count_);
    CNF_LOG_BASIC("[CNF-化简] time0单变量候选组直接文字编码次数=" << time0_direct_literal_group_count_);
    CNF_LOG_BASIC("[CNF-化简] 跳过重复子句次数=" << duplicate_clause_skips);
    CNF_LOG_BASIC("[CNF-化简] 估计少建辅助变量=" << est_saved_vars);
    CNF_LOG_BASIC("[CNF-化简] 估计少加子句=" << est_saved_clauses);

    CNF_LOG_BASIC("[CNF-缓存] 变量骨架缓存命中次数=" << var_skeleton_cache_hit_count_);
    CNF_LOG_BASIC("[CNF-缓存] 变量骨架缓存未命中次数=" << var_skeleton_cache_miss_count_);
    CNF_LOG_BASIC("[CNF-缓存] 变量桶内处理值请求次数=" << regression_call_count_);
    CNF_LOG_BASIC("[CNF-缓存] 实例化ADD支持项次数=" << regression_instantiated_add_term_count_);
    CNF_LOG_BASIC("[CNF-缓存] 实例化DEL支持项次数=" << regression_instantiated_del_term_count_);
    CNF_LOG_BASIC("[CNF-缓存] 支持项门缓存命中次数=" << instantiated_term_cache_hit_count_);
    CNF_LOG_BASIC("[CNF-缓存] 支持项门缓存未命中次数=" << instantiated_term_cache_miss_count_);
    CNF_LOG_BASIC("[CNF-缓存] 持久变量骨架缓存大小=" << persistent_var_skeleton_cache_size_ << " -> " << var_regression_skeleton_cache_.size());
    CNF_LOG_BASIC("[CNF-缓存] support term pool 复用命中次数=" << support_term_pool_reuse_hit_count_ << ", pool_size=" << support_term_pool_.size());
    CNF_LOG_BASIC("[CNF-化简] persistence别名命中次数=" << persistence_alias_hit_count_);
    CNF_LOG_BASIC("[CNF-化简] persistence时间别名累计跨度=" << persistence_alias_saved_var_count_);
    CNF_LOG_BASIC("[CNF-化简] persistence纯保持重言式跳过次数=" << persistence_tautology_skip_count_);
    CNF_LOG_BASIC("[CNF-跨轮] 动作影响摘要 build_count=" << action_impact_summary_build_count_ << ", cache_size=" << action_impact_summary_cache_.size());
    CNF_LOG_BASIC("[CNF-跨轮] 后缀摘要 build_count=" << suffix_summary_build_count_ << ", reuse_count=" << suffix_summary_reuse_count_);
    CNF_LOG_BASIC("[CNF-跨轮] 本轮复用公共后缀步数=" << last_suffix_reused_steps_ << ", 本轮重建前缀步数=" << last_suffix_rebuilt_steps_);
    CNF_LOG_BASIC("[CNF-跨轮] 动作无关快速纯保持次数=" << action_impact_fastskip_count_);
    CNF_LOG_BASIC("[CNF-跨轮] 后缀跳跃查询次数=" << suffix_jump_queries_ << ", 累计跳过步数=" << suffix_jump_total_skipped_steps_);
    CNF_LOG_BASIC("[CNF-跨轮] persistence变化向量建立次数=" << persistence_change_vector_build_count_ << ", 变化项总数=" << persistence_change_point_total_);
    CNF_LOG_BASIC("[CNF-跨轮] 回归调度插入事实数=" << regression_scheduled_fact_count_ << ", 实际处理事实数=" << regression_processed_fact_count_ << ", time0落地事实数=" << regression_time0_fact_count_);
    CNF_LOG_BASIC("[CNF-P8-count] logical_schedule_attempts=" << p8_active_schedule_logical_attempt_count_ << ", inserted=" << p8_active_schedule_inserted_count_ << ", suppressed=" << p8_active_schedule_suppressed_count_ << ", active_attempts=" << p8_active_schedule_suppression_attempt_count_ << ", boundary_allowed=" << p8_active_schedule_boundary_allowed_count_);
    CNF_LOG_BASIC("[CNF-P5] 固定长度子句快速路径已启用，hotpath诊断计数=" << (collect_hotpath_diag() ? "on" : "off"));
    CNF_LOG_BASIC("[CNF-P6] REG_EQUIV热路径去重旁路=" << (use_reg_equiv_no_dedup_hotpath() ? "on" : "off") << ", and2旁路次数=" << p6_reg_equiv_and2_no_dedup_count_ << ", no-dedup追加子句数=" << cnf_.no_dedup_clause_append_count());
    CNF_LOG_BASIC("[CNF-P7] scheduled外层vector已启用, layer_vector_size=" << p7_scheduled_layer_vector_size_ << ", resize_count=" << p7_scheduled_layer_vector_resize_count_);
    CNF_LOG_BASIC("[CNF-P7.1] detail门事件逐条日志上限=20/轮，仅保留汇总计数用于分析");
    CNF_LOG_BASIC("[CNF-P8-check] frontier重放校验=" << (use_frontier_replay_check() ? "on" : "off") << ", common_suffix=" << p8_frontier_common_suffix_ << ", compared=" << p8_frontier_compared_layers_ << ", equal=" << p8_frontier_equal_layers_ << ", mismatch=" << p8_frontier_mismatch_layers_ << ", skipped=" << p8_frontier_skipped_layers_);
    CNF_LOG_BASIC("[CNF-P8-active] frontier调度复用=" << (p8_active_enabled_ ? "on" : "off") << ", replay_layers=" << p8_active_replayed_layers_ << ", replay_buckets=" << p8_active_replayed_buckets_ << ", replay_facts=" << p8_active_replayed_facts_ << ", suppressed=" << p8_active_schedule_suppressed_count_ << ", allowed=" << p8_active_schedule_boundary_allowed_count_ << ", attempts=" << p8_active_schedule_suppression_attempt_count_);
    CNF_LOG_BASIC("[CNF-P1] plan_size=" << diag_plan_size_ << ", regression_loop_scanned_steps=" << diag_regression_loop_steps_scanned_ << ", active_layers=" << diag_regression_active_layer_count_ << ", processed_buckets=" << diag_regression_processed_bucket_count_);
    CNF_LOG_BASIC("[CNF-P1] AND门请求次数=" << cnf_.and_gate_request_count() << ", OR门请求次数=" << cnf_.or_gate_request_count() << ", 空support项=" << diag_empty_support_term_count_ << ", 非空support项=" << diag_nonempty_support_term_count_);
    CNF_LOG_BASIC("[CNF-P2] 回归case记录使用次数=" << regression_case_record_use_count_ << ", case早退出次数=" << regression_case_early_exit_count_);
    CNF_LOG_BASIC("[CNF-P3] 公共后缀change-point复用数=" << suffix_change_points_reused_count_ << ", 前缀扫描步数=" << suffix_summary_prefix_scanned_steps_ << ", 后缀重放步数=" << suffix_summary_suffix_replayed_steps_);
    CNF_LOG_BASIC("[CNF-P4] noADD单DEL直连=" << p4_no_add_single_del_direct_count_ << ", noDEL单ADD直连=" << p4_no_del_single_add_direct_count_ << ", 无条件ADD单DEL直连=" << p4_uncond_add_single_del_direct_count_);
    CNF_LOG_BASIC("[CNF-P4] 一般情形单ADD绕过OR=" << p4_general_single_add_bypass_count_ << ", 一般情形单DEL绕过OR=" << p4_general_single_del_bypass_count_ << ", 层swap次数=" << p4_layer_swap_count_);
    CNF_LOG_BASIC("[CNF-P4] branch_lit_vector_hit=" << p4_branch_lit_vector_hit_count_ << ", branch_lit_vector_miss=" << p4_branch_lit_vector_miss_count_);

    CNF_LOG_BASIC("[CNF-汇总] 事实变量数=" << vm_.num_fact_vars());
    CNF_LOG_BASIC("[CNF-汇总] 辅助变量数=" << vm_.num_aux_vars());
    CNF_LOG_BASIC("[CNF-汇总] 变量总数=" << vm_.max_var());
    CNF_LOG_BASIC("[CNF-汇总] 子句总数=" << cnf_.num_clauses());
    CNF_LOG_BASIC("[CNF-汇总] 根条件变量数=" << goal_root_var_count_);
    CNF_LOG_BASIC("[CNF-汇总] 回归最终唯一事实数=" << regression_unique_fact_count_);
    CNF_LOG_BASIC("[CNF-汇总] 回归层峰值事实数=" << regression_layer_peak_fact_count_);

    std::clock_t load_begin = std::clock();
    if (!solver_.load_cnf(cnf_)) return false;
    std::clock_t load_end = std::clock();
    kissat_load_time_ms_ = clock_diff_ms(load_begin, load_end);

    std::clock_t solve_begin = std::clock();
    int res = solver_.solve();
    std::clock_t solve_end = std::clock();
    kissat_solve_time_ms_ = clock_diff_ms(solve_begin, solve_end);
    lastcountertime = kissat_solve_time_ms_;
    kissat_last_result_valid_ = true;

    if (res == 10) {
        std::map<int,int> sample;
        std::map<int,int> conflicts;
        kissat_last_has_counterexample_ = true;
        std::clock_t extract_begin = std::clock();
        if (!solver_.extract_time0_sample(vm_, &sample, &conflicts)) {
            kissat_last_sample_valid_ = false;
            model_extract_time_ms_ = 0;
            kissat_last_counterexample_state_.clear();
            return false;
        }
        if (!build_state_from_sample(sample, validation_base_state_, &kissat_last_counterexample_state_)) {
            kissat_last_sample_valid_ = false;
            model_extract_time_ms_ = 0;
            kissat_last_counterexample_state_.clear();
            return false;
        }
        std::clock_t extract_end = std::clock();
        model_extract_time_ms_ = clock_diff_ms(extract_begin, extract_end);
        kissat_last_sample_valid_ = true;
        return true;
    } else if (res == 20) {
        model_extract_time_ms_ = 0;
        findvalidplan = true;
        kissat_last_has_counterexample_ = false;
        kissat_last_sample_valid_ = false;
        return false;
    } else {
        model_extract_time_ms_ = 0;
        kissat_last_has_counterexample_ = false;
        kissat_last_sample_valid_ = false;
        return false;
    }
}

bool CounterCNF::prepare_counterexample_cnf(const Plan &plan, bool isfirst) {
    return prepare_counterexample_cnf(plan, isfirst, 0);
}

bool CounterCNF::prepare_counterexample_cnf(const Plan &plan, bool isfirst, const Counter *driver_counter) {
    clear_round();
    if (driver_counter != 0) import_driver_state(*driver_counter);
    CNF_LOG_BASIC("[CNF-版本] improve4_p0p1p2p3_p4_p5_p6_p61_p7_p71_p8active_stage1_countfix");
    CNF_LOG_BASIC("[CNF-验证] ===== 开始一次 CNF 编码构造 =====");
    validation_base_state_ = g_initial_state->vars;

    std::clock_t init_begin = std::clock();
    build_init_cnf(isfirst);
    std::clock_t init_end = std::clock();
    init_build_time_ms_ = clock_diff_ms(init_begin, init_end);

    std::clock_t regression_begin = std::clock();
    build_goal_regression_cnf(plan);
    std::clock_t regression_end = std::clock();
    goal_regression_build_time_ms_ = clock_diff_ms(regression_begin, regression_end);

    cnf_.set_declared_max_var(vm_.max_var());

    if (g_enable_cnf_preprocess) {
        std::clock_t preprocess_begin = std::clock();
        CnfPreprocessor preprocessor;
        CnfPreprocessStats preprocess_stats;
        preprocessor.simplify_safe(&cnf_, vm_, &preprocess_stats);
        std::clock_t preprocess_end = std::clock();
        preprocess_time_ms_ = clock_diff_ms(preprocess_begin, preprocess_end);
        CNF_LOG_BASIC("[CNF-计时] preprocess_ms=" << preprocess_time_ms_);
    }

    last_var_count_ = vm_.max_var();
    last_clause_count_ = cnf_.num_clauses();
    CNF_LOG_BASIC("[CNF-计时] init_build_ms=" << init_build_time_ms_);
    CNF_LOG_BASIC("[CNF-计时] goal_regression_build_ms=" << goal_regression_build_time_ms_);
    if (!g_enable_cnf_preprocess) CNF_LOG_BASIC("[CNF-计时] preprocess_ms=0");
    CNF_LOG_BASIC("[CNF-汇总] CNF构造耗时(ms)=" << get_cnf_build_time_ms());
    CNF_LOG_BASIC("[CNF-验证] ===== CNF 编码构造结束 =====");
    return true;
}

bool CounterCNF::run_kissat_validation() {
    std::clock_t total_begin = std::clock();
    bool result = solve_with_kissat();
    std::clock_t total_end = std::clock();
    total_compute_time_ms_ = clock_diff_ms(total_begin, total_end);
    CNF_LOG_BASIC("[CNF-Kissat] load_ms=" << kissat_load_time_ms_);
    CNF_LOG_BASIC("[CNF-Kissat] solve_ms=" << kissat_solve_time_ms_);
    CNF_LOG_BASIC("[CNF-Kissat] extract_ms=" << model_extract_time_ms_);
    CNF_LOG_BASIC("[CNF-Kissat] total_solver_ms=" << get_kissat_end_to_end_time_ms());
    return result;
}

bool CounterCNF::run_minisat_validation() {
    std::clock_t total_begin = std::clock();
    bool result = solve_with_minisat();
    std::clock_t total_end = std::clock();
    total_compute_time_ms_ = clock_diff_ms(total_begin, total_end);
    if (minisat_last_result_valid_) {
        CNF_LOG_BASIC("[CNF-MiniSAT] load_ms=" << minisat_load_time_ms_);
        CNF_LOG_BASIC("[CNF-MiniSAT] solve_ms=" << minisat_solve_time_ms_);
        CNF_LOG_BASIC("[CNF-MiniSAT] extract_ms=" << minisat_model_extract_time_ms_);
        CNF_LOG_BASIC("[CNF-MiniSAT] total_solver_ms=" << get_minisat_end_to_end_time_ms());
    }
    return result;
}

bool CounterCNF::run_glucose_validation() {
    std::clock_t total_begin = std::clock();
    bool result = solve_with_glucose();
    std::clock_t total_end = std::clock();
    total_compute_time_ms_ = clock_diff_ms(total_begin, total_end);
    if (glucose_last_result_valid_) {
        CNF_LOG_BASIC("[CNF-Glucose] load_ms=" << glucose_load_time_ms_);
        CNF_LOG_BASIC("[CNF-Glucose] solve_ms=" << glucose_solve_time_ms_);
        CNF_LOG_BASIC("[CNF-Glucose] extract_ms=" << glucose_model_extract_time_ms_);
        CNF_LOG_BASIC("[CNF-Glucose] total_solver_ms=" << get_glucose_end_to_end_time_ms());
    }
    return result;
}

bool CounterCNF::run_cadical_validation() {
    std::clock_t total_begin = std::clock();
    bool result = solve_with_cadical();
    std::clock_t total_end = std::clock();
    total_compute_time_ms_ = clock_diff_ms(total_begin, total_end);
    if (cadical_last_result_valid_) {
        CNF_LOG_BASIC("[CNF-CaDiCaL] load_ms=" << cadical_load_time_ms_);
        CNF_LOG_BASIC("[CNF-CaDiCaL] solve_ms=" << cadical_solve_time_ms_);
        CNF_LOG_BASIC("[CNF-CaDiCaL] extract_ms=" << cadical_model_extract_time_ms_);
        CNF_LOG_BASIC("[CNF-CaDiCaL] total_solver_ms=" << get_cadical_end_to_end_time_ms());
    }
    return result;
}

bool CounterCNF::computeCounterCNF(const Plan &plan, bool isfirst) {
    if (!prepare_counterexample_cnf(plan, isfirst)) return false;
    bool kissat_result = run_kissat_validation();
    run_minisat_validation();
    run_glucose_validation();
    run_cadical_validation();
    return kissat_result;
}
