#include "cnf_preprocessor.h"

#include "cnf_builder.h"
#include "cnf_logger.h"
#include "globals.h"
#include "sat_var_manager.h"

#include <algorithm>
#include <queue>
#include <set>
#include <sstream>

namespace {
static bool clause_less(const ClauseRecord &lhs, const ClauseRecord &rhs) {
    if (lhs.lits != rhs.lits) return lhs.lits < rhs.lits;
    if (lhs.kind != rhs.kind) return lhs.kind < rhs.kind;
    return lhs.note < rhs.note;
}

static bool clause_is_removed(const ClauseRecord &clause) {
    return clause.lits.empty();
}
}

CnfPreprocessor::CnfPreprocessor() {
}

int CnfPreprocessor::lit_to_index(int lit) {
    int var = lit > 0 ? lit : -lit;
    return (lit > 0) ? (2 * (var - 1)) : (2 * (var - 1) + 1);
}

int CnfPreprocessor::index_to_lit(int index) {
    int var = index / 2 + 1;
    return (index % 2 == 0) ? var : -var;
}

bool CnfPreprocessor::clause_subsumes(const std::vector<int> &small_clause,
                                      const std::vector<int> &large_clause) {
    if (small_clause.size() > large_clause.size()) return false;
    std::size_t i = 0, j = 0;
    while (i < small_clause.size() && j < large_clause.size()) {
        if (small_clause[i] == large_clause[j]) {
            ++i;
            ++j;
        } else if (small_clause[i] > large_clause[j]) {
            ++j;
        } else {
            return false;
        }
    }
    return i == small_clause.size();
}

bool CnfPreprocessor::normalize_clause(std::vector<int> *lits, CnfPreprocessStats *stats) const {
    std::sort(lits->begin(), lits->end());
    std::vector<int> out;
    out.reserve(lits->size());
    std::size_t i;
    for (i = 0; i < lits->size(); ++i) {
        int lit = (*lits)[i];
        if (lit == 0) continue;
        if (!out.empty() && out.back() == lit) continue;
        if (std::binary_search(lits->begin(), lits->end(), -lit)) {
            if (stats) ++stats->tautology_clause_removed_count;
            lits->clear();
            return false;
        }
        out.push_back(lit);
    }
    lits->swap(out);
    return !lits->empty();
}

void CnfPreprocessor::collect_formula_stats(const std::vector<ClauseRecord> &clauses,
                                            int *literal_count,
                                            int *binary_clause_count) const {
    *literal_count = 0;
    *binary_clause_count = 0;
    std::size_t i;
    for (i = 0; i < clauses.size(); ++i) {
        if (clause_is_removed(clauses[i])) continue;
        *literal_count += (int)clauses[i].lits.size();
        if (clauses[i].lits.size() == 2) ++(*binary_clause_count);
    }
}

bool CnfPreprocessor::is_aux_literal(const SatVarManager &vm, int lit) const {
    int var = lit > 0 ? lit : -lit;
    if (!vm.has_info(var)) return false;
    return vm.get_info(var).kind != SATVAR_KIND_FACT;
}

void CnfPreprocessor::make_unsat_formula(std::vector<ClauseRecord> *clauses,
                                         int declared_max_var) const {
    int var = declared_max_var > 0 ? declared_max_var : 1;
    clauses->clear();
    ClauseRecord c1;
    c1.kind = CLAUSE_KIND_MISC;
    c1.note = "preprocess-unsat-1";
    c1.lits.push_back(var);
    clauses->push_back(c1);
    ClauseRecord c2;
    c2.kind = CLAUSE_KIND_MISC;
    c2.note = "preprocess-unsat-2";
    c2.lits.push_back(-var);
    clauses->push_back(c2);
}

bool CnfPreprocessor::apply_unit_propagation(std::vector<ClauseRecord> *clauses,
                                             int declared_max_var,
                                             CnfPreprocessStats *stats,
                                             bool *became_unsat) const {
    *became_unsat = false;
    bool changed = false;
    std::vector<int> assign(declared_max_var + 1, 0);
    std::queue<int> unit_queue;

    std::size_t i;
    for (i = 0; i < clauses->size(); ++i) {
        if (clause_is_removed((*clauses)[i])) continue;
        if ((*clauses)[i].lits.size() == 1) unit_queue.push((*clauses)[i].lits[0]);
    }

    while (!unit_queue.empty()) {
        int lit = unit_queue.front();
        unit_queue.pop();
        int var = lit > 0 ? lit : -lit;
        int val = lit > 0 ? 1 : -1;
        if (var >= (int)assign.size()) continue;
        if (assign[var] == val) continue;
        if (assign[var] == -val) {
            *became_unsat = true;
            make_unsat_formula(clauses, declared_max_var);
            stats->unsat_detected = 1;
            return true;
        }
        assign[var] = val;
        ++stats->unit_literals_fixed;
    }

    std::vector<ClauseRecord> out;
    out.reserve(clauses->size());
    for (i = 0; i < clauses->size(); ++i) {
        ClauseRecord clause = (*clauses)[i];
        if (clause_is_removed(clause)) continue;
        bool satisfied = false;
        std::vector<int> new_lits;
        new_lits.reserve(clause.lits.size());
        std::size_t j;
        for (j = 0; j < clause.lits.size(); ++j) {
            int lit = clause.lits[j];
            int var = lit > 0 ? lit : -lit;
            if (var < (int)assign.size() && assign[var] != 0) {
                int lit_val = lit > 0 ? 1 : -1;
                if (assign[var] == lit_val) {
                    satisfied = true;
                    break;
                }
                changed = true;
                continue;
            }
            new_lits.push_back(lit);
        }
        if (satisfied) {
            changed = true;
            continue;
        }
        if (new_lits.empty()) {
            *became_unsat = true;
            make_unsat_formula(clauses, declared_max_var);
            stats->unsat_detected = 1;
            return true;
        }
        if (new_lits.size() != clause.lits.size()) changed = true;
        clause.lits.swap(new_lits);
        if (clause.lits.size() == 1) unit_queue.push(clause.lits[0]);
        out.push_back(clause);
    }

    if (changed) clauses->swap(out);
    return changed;
}

bool CnfPreprocessor::apply_aux_equivalence_substitution(std::vector<ClauseRecord> *clauses,
                                                         const SatVarManager &vm,
                                                         int declared_max_var,
                                                         CnfPreprocessStats *stats,
                                                         bool *became_unsat) const {
    *became_unsat = false;
    if (declared_max_var <= 0) return false;

    std::vector< std::vector<int> > graph(2 * declared_max_var);
    std::vector< std::vector<int> > rev_graph(2 * declared_max_var);
    std::vector<char> active(2 * declared_max_var, 0);

    std::size_t i;
    for (i = 0; i < clauses->size(); ++i) {
        const ClauseRecord &clause = (*clauses)[i];
        if (clause_is_removed(clause) || clause.lits.size() != 2) continue;
        int a = clause.lits[0];
        int b = clause.lits[1];
        int na = -a;
        int nb = -b;
        int idx1 = lit_to_index(na);
        int idx2 = lit_to_index(b);
        int idx3 = lit_to_index(nb);
        int idx4 = lit_to_index(a);
        graph[idx1].push_back(idx2);
        rev_graph[idx2].push_back(idx1);
        graph[idx3].push_back(idx4);
        rev_graph[idx4].push_back(idx3);
        active[idx1] = active[idx2] = active[idx3] = active[idx4] = 1;
    }

    std::vector<int> order;
    order.reserve(2 * declared_max_var);
    std::vector<char> visited(2 * declared_max_var, 0);

    struct DfsState {
        int node;
        std::size_t next_child;
        DfsState(int n, std::size_t c) : node(n), next_child(c) {}
    };

    int start;
    for (start = 0; start < 2 * declared_max_var; ++start) {
        if (!active[start] || visited[start]) continue;
        std::vector<DfsState> stack;
        stack.push_back(DfsState(start, 0));
        visited[start] = 1;
        while (!stack.empty()) {
            DfsState &cur = stack.back();
            if (cur.next_child < graph[cur.node].size()) {
                int nxt = graph[cur.node][cur.next_child++];
                if (!visited[nxt]) {
                    visited[nxt] = 1;
                    stack.push_back(DfsState(nxt, 0));
                }
            } else {
                order.push_back(cur.node);
                stack.pop_back();
            }
        }
    }

    std::vector<int> comp(2 * declared_max_var, -1);
    std::vector< std::vector<int> > components;
    int cid = 0;
    int oi;
    for (oi = (int)order.size() - 1; oi >= 0; --oi) {
        int node = order[oi];
        if (comp[node] != -1) continue;
        components.push_back(std::vector<int>());
        std::vector<int> stack;
        stack.push_back(node);
        comp[node] = cid;
        while (!stack.empty()) {
            int cur = stack.back();
            stack.pop_back();
            components[cid].push_back(cur);
            std::size_t j;
            for (j = 0; j < rev_graph[cur].size(); ++j) {
                int nxt = rev_graph[cur][j];
                if (comp[nxt] == -1) {
                    comp[nxt] = cid;
                    stack.push_back(nxt);
                }
            }
        }
        ++cid;
    }

    std::vector<int> subst(2 * declared_max_var, 0);
    bool changed = false;
    std::size_t cidx;
    for (cidx = 0; cidx < components.size(); ++cidx) {
        const std::vector<int> &nodes = components[cidx];
        if (nodes.size() <= 1) continue;

        std::set<int> lits_in_comp;
        std::size_t j;
        for (j = 0; j < nodes.size(); ++j) lits_in_comp.insert(index_to_lit(nodes[j]));
        for (j = 0; j < nodes.size(); ++j) {
            int lit = index_to_lit(nodes[j]);
            if (lits_in_comp.find(-lit) != lits_in_comp.end()) {
                *became_unsat = true;
                make_unsat_formula(clauses, declared_max_var);
                stats->unsat_detected = 1;
                return true;
            }
        }

        int rep = 0;
        int best_score = 100;
        for (j = 0; j < nodes.size(); ++j) {
            int lit = index_to_lit(nodes[j]);
            int score = 10;
            if (vm.has_info(lit > 0 ? lit : -lit)) {
                const SatVarInfo &info = vm.get_info(lit > 0 ? lit : -lit);
                if (info.kind == SATVAR_KIND_FACT) score = 0;
                else score = 1;
            }
            if (lit > 0) --score;
            if (rep == 0 || score < best_score || (score == best_score && (lit > 0 ? lit : -lit) < (rep > 0 ? rep : -rep))) {
                rep = lit;
                best_score = score;
            }
        }

        bool useful = false;
        for (j = 0; j < nodes.size(); ++j) {
            int lit = index_to_lit(nodes[j]);
            if (lit == rep) continue;
            if (!is_aux_literal(vm, lit)) continue;
            subst[lit_to_index(lit)] = rep;
            subst[lit_to_index(-lit)] = -rep;
            useful = true;
            ++stats->aux_literal_substitutions;
        }
        if (useful) {
            ++stats->aux_equivalence_classes_used;
            changed = true;
        }
    }

    if (!changed) return false;

    std::vector<ClauseRecord> out;
    out.reserve(clauses->size());
    for (i = 0; i < clauses->size(); ++i) {
        ClauseRecord clause = (*clauses)[i];
        std::size_t j;
        for (j = 0; j < clause.lits.size(); ++j) {
            int idx = lit_to_index(clause.lits[j]);
            if (idx >= 0 && idx < (int)subst.size() && subst[idx] != 0)
                clause.lits[j] = subst[idx];
        }
        if (!normalize_clause(&clause.lits, stats)) continue;
        out.push_back(clause);
    }
    std::sort(out.begin(), out.end(), clause_less);
    out.erase(std::unique(out.begin(), out.end(),
        [](const ClauseRecord &a, const ClauseRecord &b){ return a.lits == b.lits; }), out.end());
    clauses->swap(out);
    return true;
}

bool CnfPreprocessor::apply_subsumption(std::vector<ClauseRecord> *clauses,
                                        CnfPreprocessStats *stats) const {
    std::map<int, std::vector<int> > occ;
    std::size_t i;
    for (i = 0; i < clauses->size(); ++i) {
        if (clause_is_removed((*clauses)[i])) continue;
        std::size_t j;
        for (j = 0; j < (*clauses)[i].lits.size(); ++j)
            occ[(*clauses)[i].lits[j]].push_back((int)i);
    }

    std::vector<char> removed(clauses->size(), 0);
    bool changed = false;

    /*
     * 这里只保留“安全的 SSR 风格删文字”：
     * 若当前公式已由二元子句蕴含 (lit -> other)，且该子句同时含 lit 与 other，
     * 则 lit 在该子句中是冗余的，可以删除。
     *
     * 注意：这里显式禁用了上一版中的两条激进规则：
     *  1) 基于 succ[-other] 的“蕴含删文字”；
     *  2) 由长子句 + 二元图交集导出新二元子句的 HBR 近似实现。
     *
     * 这两条规则在当前实现里并不保持等可满足性，会把 SAT 公式错误强化成
     * 更强公式，直接导致“SMT 找到反例，而多个 CNF solver 一起返回无反例”。
     */
    for (i = 0; i < clauses->size(); ++i) {
        if (removed[i] || clause_is_removed((*clauses)[i])) continue;
        const std::vector<int> &base = (*clauses)[i].lits;
        if (base.empty()) continue;
        int pivot = base[0];
        std::size_t best_occ = occ[pivot].size();
        std::size_t j;
        for (j = 1; j < base.size(); ++j) {
            std::size_t cur_occ = occ[base[j]].size();
            if (cur_occ < best_occ) {
                best_occ = cur_occ;
                pivot = base[j];
            }
        }
        const std::vector<int> &cands = occ[pivot];
        for (j = 0; j < cands.size(); ++j) {
            int other = cands[j];
            if (other == (int)i || removed[other] || clause_is_removed((*clauses)[other])) continue;
            if ((*clauses)[other].lits.size() < base.size()) continue;
            if (clause_subsumes(base, (*clauses)[other].lits)) {
                removed[other] = 1;
                changed = true;
                ++stats->subsumed_clause_count;
            }
        }
    }

    if (!changed) return false;
    std::vector<ClauseRecord> out;
    out.reserve(clauses->size());
    for (i = 0; i < clauses->size(); ++i)
        if (!removed[i] && !clause_is_removed((*clauses)[i])) out.push_back((*clauses)[i]);
    clauses->swap(out);
    return true;
}

bool CnfPreprocessor::apply_binary_strengthening(std::vector<ClauseRecord> *clauses,
                                                 int declared_max_var,
                                                 CnfPreprocessStats *stats) const {
    if (declared_max_var <= 0) return false;
    std::vector< std::set<int> > succ(2 * declared_max_var);
    std::size_t i;
    for (i = 0; i < clauses->size(); ++i) {
        const ClauseRecord &clause = (*clauses)[i];
        if (clause_is_removed(clause) || clause.lits.size() != 2) continue;
        int a = clause.lits[0], b = clause.lits[1];
        succ[lit_to_index(-a)].insert(b);
        succ[lit_to_index(-b)].insert(a);
    }

    bool changed = false;
    for (i = 0; i < clauses->size(); ++i) {
        ClauseRecord &clause = (*clauses)[i];
        if (clause_is_removed(clause) || clause.lits.size() < 2) continue;

        std::vector<int> reduced_by_ssr;
        reduced_by_ssr.reserve(clause.lits.size());
        std::size_t a;
        for (a = 0; a < clause.lits.size(); ++a) {
            int lit = clause.lits[a];
            bool removable = false;
            const std::set<int> &s = succ[lit_to_index(lit)];
            std::size_t b;
            for (b = 0; b < clause.lits.size(); ++b) {
                if (a == b) continue;
                if (s.find(clause.lits[b]) != s.end()) {
                    removable = true;
                    break;
                }
            }
            if (removable) {
                ++stats->ssr_literal_removed_count;
                changed = true;
            } else {
                reduced_by_ssr.push_back(lit);
            }
        }
        if (reduced_by_ssr.empty()) {
            make_unsat_formula(clauses, declared_max_var);
            stats->unsat_detected = 1;
            return true;
        }
        clause.lits.swap(reduced_by_ssr);
        if (!normalize_clause(&clause.lits, stats)) {
            clause.lits.clear();
            changed = true;
            continue;
        }
    }

    if (!changed) return false;

    std::vector<ClauseRecord> out;
    out.reserve(clauses->size());
    std::set< std::vector<int> > seen;
    for (i = 0; i < clauses->size(); ++i) {
        ClauseRecord clause = (*clauses)[i];
        if (clause_is_removed(clause)) continue;
        if (!normalize_clause(&clause.lits, stats)) continue;
        if (seen.find(clause.lits) != seen.end()) {
            ++stats->duplicate_clause_removed_count;
            continue;
        }
        seen.insert(clause.lits);
        out.push_back(clause);
    }
    clauses->swap(out);
    return true;
}

bool CnfPreprocessor::run_pass(std::vector<ClauseRecord> *clauses,
                               const SatVarManager &vm,
                               int declared_max_var,
                               CnfPreprocessStats *stats,
                               bool *became_unsat) const {
    *became_unsat = false;
    bool any_change = false;
    bool local_unsat = false;

    if (apply_unit_propagation(clauses, declared_max_var, stats, &local_unsat)) any_change = true;
    if (local_unsat) { *became_unsat = true; return true; }

    if (apply_aux_equivalence_substitution(clauses, vm, declared_max_var, stats, &local_unsat)) any_change = true;
    if (local_unsat) { *became_unsat = true; return true; }

    if (apply_unit_propagation(clauses, declared_max_var, stats, &local_unsat)) any_change = true;
    if (local_unsat) { *became_unsat = true; return true; }

    if (apply_binary_strengthening(clauses, declared_max_var, stats)) {
        any_change = true;
        if (stats->unsat_detected) { *became_unsat = true; return true; }
    }

    if (apply_unit_propagation(clauses, declared_max_var, stats, &local_unsat)) any_change = true;
    if (local_unsat) { *became_unsat = true; return true; }

    if (apply_subsumption(clauses, stats)) any_change = true;

    return any_change;
}

bool CnfPreprocessor::simplify_safe(CnfBuilder *cnf, const SatVarManager &vm, CnfPreprocessStats *stats) {
    if (stats) *stats = CnfPreprocessStats();
    if (cnf == 0) return false;

    const int declared_max_var = std::max(cnf->declared_max_var(), vm.max_var());
    std::vector<ClauseRecord> work = cnf->clauses();

    int in_lits = 0, in_bin = 0;
    collect_formula_stats(work, &in_lits, &in_bin);
    if (stats) {
        stats->input_clause_count = (int)work.size();
        stats->input_literal_count = in_lits;
        stats->input_binary_clause_count = in_bin;
    }

    CNF_LOG_BASIC("[CNF-预处理] ===== 开始 CNF 预处理 =====");
    CNF_LOG_BASIC("[CNF-预处理] 输入子句数=" << work.size() << ", 输入文字数=" << in_lits << ", 输入二元子句数=" << in_bin);

    bool ever_changed = false;
    const int max_passes = 3;
    int pass;
    for (pass = 1; pass <= max_passes; ++pass) {
        bool became_unsat = false;
        bool changed = run_pass(&work, vm, declared_max_var, stats, &became_unsat);
        if (stats) stats->passes_run = pass;
        if (became_unsat) {
            ever_changed = true;
            break;
        }
        if (!changed) break;
        ever_changed = true;
    }

    std::sort(work.begin(), work.end(), clause_less);
    work.erase(std::unique(work.begin(), work.end(),
        [](const ClauseRecord &a, const ClauseRecord &b){ return a.lits == b.lits; }), work.end());

    int out_lits = 0, out_bin = 0;
    collect_formula_stats(work, &out_lits, &out_bin);
    if (stats) {
        stats->output_clause_count = (int)work.size();
        stats->output_literal_count = out_lits;
        stats->output_binary_clause_count = out_bin;
    }

    cnf->replace_clauses_preserve_stats(work);
    cnf->set_declared_max_var(declared_max_var);

    CNF_LOG_BASIC("[CNF-预处理] 输出子句数=" << work.size() << ", 输出文字数=" << out_lits << ", 输出二元子句数=" << out_bin);
    if (stats) {
        CNF_LOG_BASIC("[CNF-预处理] 轮数=" << stats->passes_run);
        CNF_LOG_BASIC("[CNF-预处理] 单位传播固定文字数=" << stats->unit_literals_fixed);
        CNF_LOG_BASIC("[CNF-预处理] aux 等价替换次数=" << stats->aux_literal_substitutions);
        CNF_LOG_BASIC("[CNF-预处理] aux 等价类使用次数=" << stats->aux_equivalence_classes_used);
        CNF_LOG_BASIC("[CNF-预处理] 子句包含删除次数=" << stats->subsumed_clause_count);
        CNF_LOG_BASIC("[CNF-预处理] SSR 删除文字数=" << stats->ssr_literal_removed_count);
        CNF_LOG_BASIC("[CNF-预处理] 蕴含删除文字数=" << stats->implication_literal_removed_count);
        CNF_LOG_BASIC("[CNF-预处理] HBR 新增二元子句数=" << stats->hbr_binary_added_count);
        CNF_LOG_BASIC("[CNF-预处理] 重复子句删除数=" << stats->duplicate_clause_removed_count);
        CNF_LOG_BASIC("[CNF-预处理] 重言式删除数=" << stats->tautology_clause_removed_count);
        CNF_LOG_BASIC("[CNF-预处理] 是否检测到UNSAT=" << (stats->unsat_detected ? "是" : "否"));
    }
    CNF_LOG_BASIC("[CNF-预处理] ===== CNF 预处理结束 =====");

    return ever_changed;
}
