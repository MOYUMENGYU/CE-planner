#include "cegis_framework.h"

#include "counter.h"
#include "counter_cnf.h"
#include "globals.h"
#include "operator.h"

#include <algorithm>
#include <cerrno>
#include <cctype>
#include <climits>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>
#include <signal.h>

namespace igc_cegis {
namespace {

enum CandidatePlannerKind {
    CANDIDATE_PLANNER_T1 = 0,
    CANDIDATE_PLANNER_CNF = 1,
    CANDIDATE_PLANNER_DNF = 2,
    CANDIDATE_PLANNER_PIP = 3,
    CANDIDATE_PLANNER_CPAH = 4,
    CANDIDATE_PLANNER_IGC_ORIGIN = 5,
    CANDIDATE_PLANNER_GC_LAMA = 6,
    CANDIDATE_PLANNER_GCPCES = 7,
    CANDIDATE_PLANNER_ICPCES = 8,
    CANDIDATE_PLANNER_CFF = 9
};

enum RefinedPddlProfile {
    REFINED_PDDL_T1 = 0,
    REFINED_PDDL_CPA_FAMILY = 1,
    REFINED_PDDL_CPAH = 2,
    REFINED_PDDL_GC_FAMILY = 3,
    REFINED_PDDL_GCPCES = 4,
    REFINED_PDDL_ICPCES = 5
};

static RefinedPddlProfile refined_pddl_profile(CandidatePlannerKind kind) {
    if (kind == CANDIDATE_PLANNER_T1 ||
        kind == CANDIDATE_PLANNER_CFF)
        return REFINED_PDDL_T1;
    if (kind == CANDIDATE_PLANNER_CPAH) return REFINED_PDDL_CPAH;
    if (kind == CANDIDATE_PLANNER_IGC_ORIGIN ||
        kind == CANDIDATE_PLANNER_GC_LAMA)
        return REFINED_PDDL_GC_FAMILY;
    if (kind == CANDIDATE_PLANNER_GCPCES) return REFINED_PDDL_GCPCES;
    if (kind == CANDIDATE_PLANNER_ICPCES) return REFINED_PDDL_ICPCES;
    return REFINED_PDDL_CPA_FAMILY;
}

static const char *refined_pddl_profile_name(RefinedPddlProfile profile) {
    switch (profile) {
    case REFINED_PDDL_T1:
        return "t1_simplified_structured";
    case REFINED_PDDL_CPAH:
        return "cpah_selector_exact_samples_with_explicit_unknown";
    case REFINED_PDDL_GC_FAMILY:
        return "igc_gc_lama_exact_world_oneof";
    case REFINED_PDDL_GCPCES:
        return "gcpces_exact_world_oneof_with_complete_literals";
    case REFINED_PDDL_ICPCES:
        return "icpces_selector_exact_samples_with_native_oneof_support";
    case REFINED_PDDL_CPA_FAMILY:
    default:
        return "cnf_dnf_pip_selector_exact_samples";
    }
}

static const char *candidate_planner_id(CandidatePlannerKind kind) {
    switch (kind) {
    case CANDIDATE_PLANNER_T1: return "t1";
    case CANDIDATE_PLANNER_CNF: return "cnf";
    case CANDIDATE_PLANNER_DNF: return "dnf";
    case CANDIDATE_PLANNER_PIP: return "pip";
    case CANDIDATE_PLANNER_CPAH: return "cpah";
    case CANDIDATE_PLANNER_IGC_ORIGIN: return "igc";
    case CANDIDATE_PLANNER_GC_LAMA: return "gc_lama";
    case CANDIDATE_PLANNER_GCPCES: return "gcpces";
    case CANDIDATE_PLANNER_ICPCES: return "icpces";
    case CANDIDATE_PLANNER_CFF: return "cff";
    default: return "unknown";
    }
}

static const char *candidate_planner_display_name(CandidatePlannerKind kind) {
    switch (kind) {
    case CANDIDATE_PLANNER_T1: return "T1";
    case CANDIDATE_PLANNER_CNF: return "CNF";
    case CANDIDATE_PLANNER_DNF: return "DNF";
    case CANDIDATE_PLANNER_PIP: return "PIP";
    case CANDIDATE_PLANNER_CPAH: return "CPAH";
    case CANDIDATE_PLANNER_IGC_ORIGIN: return "iGC";
    case CANDIDATE_PLANNER_GC_LAMA: return "GC-LAMA";
    case CANDIDATE_PLANNER_GCPCES: return "gCPCES";
    case CANDIDATE_PLANNER_ICPCES: return "iCPCES";
    case CANDIDATE_PLANNER_CFF: return "CFF";
    default: return "UNKNOWN";
    }
}

struct OriginalProblemContext {
    std::string context_id;
    std::vector<std::string> variable_names;
    std::vector<int> variable_domains;
    std::vector<int> original_sas_state;
    std::vector< std::pair<int, int> > goal_pairs;
    std::string domain_path;
    std::string problem_path;
};

struct CounterexampleState {
    std::string ce_id;
    std::vector<int> sas_values;
    int frequency;
    int first_iteration;
    std::string source_backend;
    std::string fail_reason;
    CounterexampleState()
        : ce_id(), sas_values(), frequency(1), first_iteration(0),
          source_backend("kissat"), fail_reason("plan_invalid") {}
};

class CounterexampleStore {
public:
    explicit CounterexampleStore(const OriginalProblemContext &ctx)
        : ctx_(ctx), states_(), index_() {}

    StatusCode insert(const std::vector<int> &values, int iteration,
                      const std::string &backend,
                      const std::string &reason,
                      bool *inserted_new) {
        if (inserted_new) *inserted_new = false;
        if (values.size() != ctx_.variable_domains.size())
            return STATUS_INPUT_ERROR;
        for (std::size_t i = 0; i < values.size(); ++i) {
            if (values[i] < 0 || values[i] >= ctx_.variable_domains[i])
                return STATUS_INPUT_ERROR;
        }
        const std::string key = vector_key(values);
        std::map<std::string, std::size_t>::iterator it = index_.find(key);
        if (it != index_.end()) {
            ++states_[it->second].frequency;
            return STATUS_OK;
        }
        CounterexampleState ce;
        std::ostringstream id;
        id << "ce" << std::setfill('0') << std::setw(4) << states_.size();
        ce.ce_id = id.str();
        ce.sas_values = values;
        ce.first_iteration = iteration;
        ce.source_backend = backend;
        ce.fail_reason = reason;
        states_.push_back(ce);
        index_[key] = states_.size() - 1;
        if (inserted_new) *inserted_new = true;
        return STATUS_OK;
    }

    const std::vector<CounterexampleState> &states() const { return states_; }
    std::size_t size() const { return states_.size(); }

    StatusCode dump_json(const std::string &path, int iteration) const {
        const std::string tmp = path + ".tmp";
        std::ofstream out(tmp.c_str(), std::ios::out | std::ios::trunc);
        if (!out) return STATUS_IO_ERROR;
        out << "{\n"
            << "  \"schema_version\": \"igc-counterexamples-v1\",\n"
            << "  \"context_id\": \"" << json_escape(ctx_.context_id) << "\",\n"
            << "  \"iteration\": " << iteration << ",\n"
            << "  \"counterexamples\": [\n";
        for (std::size_t i = 0; i < states_.size(); ++i) {
            const CounterexampleState &ce = states_[i];
            out << "    {\"ce_id\": \"" << json_escape(ce.ce_id)
                << "\", \"frequency\": " << ce.frequency
                << ", \"first_iteration\": " << ce.first_iteration
                << ", \"source_backend\": \"" << json_escape(ce.source_backend)
                << "\", \"fail_reason\": \"" << json_escape(ce.fail_reason)
                << "\", \"sas_values\": [";
            for (std::size_t j = 0; j < ce.sas_values.size(); ++j) {
                if (j) out << ",";
                out << ce.sas_values[j];
            }
            out << "]}" << (i + 1 == states_.size() ? "" : ",") << "\n";
        }
        out << "  ]\n}\n";
        out.close();
        if (!out) return STATUS_IO_ERROR;
        if (std::rename(tmp.c_str(), path.c_str()) != 0) return STATUS_IO_ERROR;
        return STATUS_OK;
    }

private:
    static std::string vector_key(const std::vector<int> &values) {
        std::ostringstream out;
        for (std::size_t i = 0; i < values.size(); ++i)
            out << values[i] << '#';
        return out.str();
    }
    static std::string json_escape(const std::string &s) {
        std::ostringstream out;
        for (std::size_t i = 0; i < s.size(); ++i) {
            const unsigned char c = static_cast<unsigned char>(s[i]);
            if (c == '"' || c == '\\') out << '\\' << c;
            else if (c == '\n') out << "\\n";
            else if (c == '\r') out << "\\r";
            else if (c == '\t') out << "\\t";
            else if (c < 32) out << '?';
            else out << c;
        }
        return out.str();
    }

    OriginalProblemContext ctx_;
    std::vector<CounterexampleState> states_;
    std::map<std::string, std::size_t> index_;
};

struct PddlAtom {
    std::string predicate;
    std::vector<std::string> arguments;
};

class SasPddlFactMap {
public:
    typedef std::map< std::pair<int, int>, PddlAtom > FactEntries;

    StatusCode load(const std::string &path,
                    const std::vector<std::string> &current_variable_names) {
        std::map<int, int> original_to_current;
        for (std::size_t i = 0; i < current_variable_names.size(); ++i) {
            const std::string name = trim_local(current_variable_names[i]);
            int original = 0;
            bool found_digit = false;
            for (std::size_t j = 0; j < name.size(); ++j) {
                if (std::isdigit(static_cast<unsigned char>(name[j]))) {
                    found_digit = true;
                    original = original * 10 + (name[j] - '0');
                }
            }
            if (found_digit) original_to_current[original] = static_cast<int>(i);
        }
        std::ifstream in(path.c_str());
        if (!in) return STATUS_IO_ERROR;
        std::string token;
        in >> token;
        if (token != "begin_groups") return STATUS_INPUT_ERROR;
        int groups = 0;
        in >> groups;
        for (int g = 0; g < groups; ++g) {
            in >> token;
            if (token != "group") return STATUS_INPUT_ERROR;
            int count = 0;
            in >> count;
            for (int i = 0; i < count; ++i) {
                int var = -1, val = -1, arity = 0;
                PddlAtom atom;
                in >> var >> val >> atom.predicate >> arity;
                if (!in || var < 0 || val < 0 || arity < 0) return STATUS_INPUT_ERROR;
                for (int a = 0; a < arity; ++a) {
                    std::string arg;
                    in >> arg;
                    atom.arguments.push_back(arg);
                }
                std::map<int, int>::const_iterator remap = original_to_current.find(var);
                if (remap == original_to_current.end()) return STATUS_MAPPING_ERROR;
                facts_[std::make_pair(remap->second, val)] = atom;
            }
        }
        return STATUS_OK;
    }

    bool find(int var, int val, PddlAtom *out) const {
        FactEntries::const_iterator it = facts_.find(std::make_pair(var, val));
        if (it == facts_.end()) return false;
        if (out) *out = it->second;
        return true;
    }

    const FactEntries &entries() const { return facts_; }

private:
    static std::string trim_local(const std::string &s) {
        std::size_t b = 0, e = s.size();
        while (b < e && std::isspace(static_cast<unsigned char>(s[b]))) ++b;
        while (e > b && std::isspace(static_cast<unsigned char>(s[e - 1]))) --e;
        return s.substr(b, e - b);
    }
    FactEntries facts_;
};

struct SasLiteral {
    int var;
    int val;
    bool positive;
    SasLiteral() : var(-1), val(-1), positive(true) {}
};
typedef std::vector<SasLiteral> ConstraintAlternative;
struct ConstraintGroup {
    enum Kind { GROUP_OR, GROUP_ONEOF } kind;
    std::vector<ConstraintAlternative> alternatives;
    ConstraintGroup() : kind(GROUP_ONEOF), alternatives() {}
};

class InitialConstraintIR {
public:
    StatusCode load(const std::string &path,
                    const std::vector<std::string> &variable_names) {
        std::ifstream in(path.c_str());
        if (!in) return STATUS_IO_ERROR;
        std::vector<std::string> lines;
        std::string line;
        while (std::getline(in, line)) {
            line = trim(line);
            if (!line.empty()) lines.push_back(line);
        }
        std::map<std::string, int> var_index;
        for (std::size_t i = 0; i < variable_names.size(); ++i)
            var_index[trim(variable_names[i])] = static_cast<int>(i);

        std::size_t pos = 0;
        while (pos < lines.size()) {
            ConstraintGroup::Kind kind;
            if (lines[pos] == "OR") kind = ConstraintGroup::GROUP_OR;
            else if (lines[pos] == "ONEOF") kind = ConstraintGroup::GROUP_ONEOF;
            else if (lines[pos] == "ORS") kind = ConstraintGroup::GROUP_OR;
            else return STATUS_INPUT_ERROR;
            ++pos;
            if (pos >= lines.size()) return STATUS_INPUT_ERROR;
            const int group_count = std::atoi(lines[pos++].c_str());
            if (group_count < 0) return STATUS_INPUT_ERROR;
            for (int gi = 0; gi < group_count; ++gi) {
                ConstraintGroup group;
                group.kind = kind;
                ConstraintAlternative current;
                bool ended = false;
                while (pos < lines.size()) {
                    if (lines[pos] == "END_OR" || lines[pos] == "END_ONEOF") {
                        if (!current.empty()) {
                            group.alternatives.push_back(current);
                            current.clear();
                        }
                        ++pos;
                        ended = true;
                        break;
                    }
                    if (lines[pos] == ",") {
                        group.alternatives.push_back(current);
                        current.clear();
                        ++pos;
                        if (lines.size() > pos && lines[pos] == "END_OR") {
                            ++pos;
                            ended = true;
                            break;
                        }
                        continue;
                    }
                    if (lines[pos] == "OR" || lines[pos] == "ONEOF" || lines[pos] == "ORS")
                        break;
                    const std::string var_name = trim(lines[pos++]);
                    if (pos >= lines.size()) return STATUS_INPUT_ERROR;
                    const int encoded = std::atoi(lines[pos++].c_str());
                    std::map<std::string, int>::const_iterator vit = var_index.find(var_name);
                    if (vit == var_index.end()) return STATUS_INPUT_ERROR;
                    SasLiteral lit;
                    lit.var = vit->second;
                    lit.positive = encoded >= 0;
                    lit.val = encoded >= 0 ? encoded : -encoded - 1;
                    current.push_back(lit);
                }
                if (!ended && !current.empty()) group.alternatives.push_back(current);
                if (group.alternatives.empty()) return STATUS_INPUT_ERROR;
                groups_.push_back(group);
            }
        }
        return STATUS_OK;
    }

    const std::vector<ConstraintGroup> &groups() const { return groups_; }

    static bool alternative_holds(const ConstraintAlternative &alt,
                                  const std::vector<int> &state) {
        for (std::size_t i = 0; i < alt.size(); ++i) {
            const SasLiteral &lit = alt[i];
            if (lit.var < 0 || lit.var >= static_cast<int>(state.size())) return false;
            const bool equal = state[lit.var] == lit.val;
            if (lit.positive != equal) return false;
        }
        return true;
    }

private:
    static std::string trim(const std::string &s) {
        std::size_t b = 0, e = s.size();
        while (b < e && std::isspace(static_cast<unsigned char>(s[b]))) ++b;
        while (e > b && std::isspace(static_cast<unsigned char>(s[e - 1]))) --e;
        return s.substr(b, e - b);
    }
    std::vector<ConstraintGroup> groups_;
};

static std::string trim(const std::string &s) {
    std::size_t b = 0, e = s.size();
    while (b < e && std::isspace(static_cast<unsigned char>(s[b]))) ++b;
    while (e > b && std::isspace(static_cast<unsigned char>(s[e - 1]))) --e;
    return s.substr(b, e - b);
}

static std::string lower_ascii(const std::string &s) {
    std::string out = s;
    for (std::size_t i = 0; i < out.size(); ++i)
        out[i] = static_cast<char>(std::tolower(static_cast<unsigned char>(out[i])));
    return out;
}

static std::string collapse_ws(const std::string &s) {
    std::ostringstream out;
    bool pending = false;
    bool wrote = false;
    for (std::size_t i = 0; i < s.size(); ++i) {
        const unsigned char c = static_cast<unsigned char>(s[i]);
        if (std::isspace(c)) {
            pending = wrote;
        } else {
            if (pending) out << ' ';
            out << static_cast<char>(c);
            wrote = true;
            pending = false;
        }
    }
    return out.str();
}

static std::string canonical_symbol_text(const std::string &s, bool relaxed) {
    std::string x = lower_ascii(collapse_ws(trim(s)));
    if (relaxed) {
        for (std::size_t i = 0; i < x.size(); ++i)
            if (x[i] == '_') x[i] = '-';
    }
    return x;
}

static bool read_file(const std::string &path, std::string *text) {
    std::ifstream in(path.c_str(), std::ios::in | std::ios::binary);
    if (!in) return false;
    std::ostringstream out;
    out << in.rdbuf();
    *text = out.str();
    return static_cast<bool>(in) || in.eof();
}

static bool write_file_atomic(const std::string &path, const std::string &text) {
    const std::string tmp = path + ".tmp";
    std::ofstream out(tmp.c_str(), std::ios::out | std::ios::trunc | std::ios::binary);
    if (!out) return false;
    out << text;
    out.close();
    if (!out) return false;
    return std::rename(tmp.c_str(), path.c_str()) == 0;
}

static bool copy_file(const std::string &src, const std::string &dst) {
    std::string text;
    return read_file(src, &text) && write_file_atomic(dst, text);
}

static bool mkdir_one(const std::string &path) {
    if (path.empty() || path == ".") return true;
    if (::mkdir(path.c_str(), 0755) == 0) return true;
    return errno == EEXIST;
}

static bool mkdirs(const std::string &path) {
    if (path.empty()) return false;
    std::string current;
    if (path[0] == '/') current = "/";
    std::size_t start = (path[0] == '/') ? 1 : 0;
    while (start <= path.size()) {
        std::size_t slash = path.find('/', start);
        std::string part = path.substr(start, slash == std::string::npos ? std::string::npos : slash - start);
        if (!part.empty()) {
            if (!current.empty() && current[current.size() - 1] != '/') current += '/';
            current += part;
            if (!mkdir_one(current)) return false;
        }
        if (slash == std::string::npos) break;
        start = slash + 1;
    }
    return true;
}

static std::string absolute_path(const std::string &path) {
    if (path.empty() || path[0] == '/') return path;
    char cwd[PATH_MAX];
    if (!::getcwd(cwd, sizeof(cwd))) return path;
    return std::string(cwd) + "/" + path;
}

static std::string path_dirname(const std::string &path) {
    if (path.empty()) return ".";
    const std::size_t slash = path.find_last_of('/');
    if (slash == std::string::npos) return ".";
    if (slash == 0) return "/";
    return path.substr(0, slash);
}

static bool executable_file(const std::string &path) {
    struct stat st;
    return ::stat(path.c_str(), &st) == 0 && S_ISREG(st.st_mode) &&
           ::access(path.c_str(), X_OK) == 0;
}

static std::string one_line_excerpt(const std::string &path, std::size_t max_chars) {
    std::string text;
    if (!read_file(path, &text)) return std::string();
    for (std::size_t i = 0; i < text.size(); ++i) {
        if (text[i] == '\r' || text[i] == '\n' || text[i] == '\t') text[i] = ' ';
    }
    text = collapse_ws(text);
    if (text.size() > max_chars) text = text.substr(0, max_chars) + "...";
    return text;
}

/*
 * T1 does not resolve its d-DNNF compiler relative to argv[0].  The original
 * implementation uses the fixed relative path "libdnnf/c2d_linux", so T1
 * must either be started from its installation directory or see a libdnnf
 * entry in its working directory.  We deliberately run each iteration in an
 * isolated directory so planner.result and the other T1 artefacts cannot be
 * overwritten.  Therefore stage a symlink to T1's runtime directory inside
 * the iteration directory before starting T1.
 */
static bool prepare_t1_runtime(const std::string &exec_abs,
                               const std::string &iter_dir,
                               std::string *message) {
    const char *runtime_env = std::getenv("IGC_T1_RUNTIME_DIR");
    const std::string runtime_root = absolute_path(
        (runtime_env && *runtime_env) ? std::string(runtime_env) : path_dirname(exec_abs));
    const std::string libdnnf_target = runtime_root + "/libdnnf";
    const std::string c2d_target = libdnnf_target + "/c2d_linux";
    if (!executable_file(c2d_target)) {
        if (message) {
            *message = std::string("T1 runtime compiler is missing or not executable: ") +
                       c2d_target +
                       "; set IGC_T1_RUNTIME_DIR to the T1 installation directory";
        }
        return false;
    }

    const std::string runtime_link = iter_dir + "/libdnnf";
    struct stat lst;
    if (::lstat(runtime_link.c_str(), &lst) == 0) {
        const std::string staged_c2d = runtime_link + "/c2d_linux";
        if (executable_file(staged_c2d)) {
            if (message) *message = std::string("reusing ") + runtime_link;
            return true;
        }
        if (message) *message = std::string("existing T1 runtime path is invalid: ") + runtime_link;
        return false;
    }
    if (errno != ENOENT) {
        if (message) *message = std::string("cannot inspect T1 runtime path: ") +
                                runtime_link + ": " + std::strerror(errno);
        return false;
    }
    if (::symlink(libdnnf_target.c_str(), runtime_link.c_str()) != 0) {
        if (message) *message = std::string("cannot create T1 runtime link ") +
                                runtime_link + " -> " + libdnnf_target +
                                ": " + std::strerror(errno);
        return false;
    }
    if (!executable_file(runtime_link + "/c2d_linux")) {
        if (message) *message = std::string("staged T1 compiler is not executable: ") +
                                runtime_link + "/c2d_linux";
        return false;
    }
    if (message) *message = runtime_link + " -> " + libdnnf_target;
    return true;
}

static std::string getenv_string(const char *name, const std::string &fallback) {
    const char *v = std::getenv(name);
    return (v && *v) ? std::string(v) : fallback;
}

static int getenv_int(const char *name, int fallback, int minimum) {
    const char *v = std::getenv(name);
    if (!v || !*v) return fallback;
    char *end = 0;
    long n = std::strtol(v, &end, 10);
    if (!end || *end || n < minimum || n > INT_MAX) return fallback;
    return static_cast<int>(n);
}

static bool env_true(const char *name, bool fallback) {
    const char *v = std::getenv(name);
    if (!v || !*v) return fallback;
    const std::string x = lower_ascii(trim(v));
    return x == "1" || x == "true" || x == "yes" || x == "on";
}

static unsigned long long fnv1a(const std::string &s, unsigned long long h) {
    for (std::size_t i = 0; i < s.size(); ++i) {
        h ^= static_cast<unsigned char>(s[i]);
        h *= 1099511628211ULL;
    }
    return h;
}

static OriginalProblemContext build_context(const std::string &domain,
                                            const std::string &problem) {
    OriginalProblemContext ctx;
    ctx.variable_names = g_variable_name;
    ctx.variable_domains = g_variable_domain;
    ctx.original_sas_state = g_original_values;
    ctx.goal_pairs = g_goal;
    ctx.domain_path = absolute_path(domain);
    ctx.problem_path = absolute_path(problem);
    std::ostringstream seed;
    seed << ctx.domain_path << '|' << ctx.problem_path << '|';
    for (std::size_t i = 0; i < ctx.variable_names.size(); ++i)
        seed << ctx.variable_names[i] << ':' << ctx.variable_domains[i] << ':'
             << (i < ctx.original_sas_state.size() ? ctx.original_sas_state[i] : -1) << ';';
    for (std::size_t i = 0; i < ctx.goal_pairs.size(); ++i)
        seed << 'G' << ctx.goal_pairs[i].first << '=' << ctx.goal_pairs[i].second << ';';
    const unsigned long long h = fnv1a(seed.str(), 1469598103934665603ULL);
    std::ostringstream id;
    id << "fnv1a64:" << std::hex << h;
    ctx.context_id = id.str();
    return ctx;
}

static StatusCode dump_context_json(const OriginalProblemContext &ctx,
                                    const std::string &path) {
    std::ostringstream out;
    out << "{\n  \"schema_version\": \"igc-context-v1\",\n"
        << "  \"context_id\": \"" << ctx.context_id << "\",\n"
        << "  \"domain_path\": \"" << ctx.domain_path << "\",\n"
        << "  \"problem_path\": \"" << ctx.problem_path << "\",\n"
        << "  \"variables\": [\n";
    for (std::size_t i = 0; i < ctx.variable_names.size(); ++i) {
        out << "    {\"index\": " << i << ", \"name\": \"" << ctx.variable_names[i]
            << "\", \"domain\": " << ctx.variable_domains[i]
            << ", \"original_value\": " << ctx.original_sas_state[i] << "}"
            << (i + 1 == ctx.variable_names.size() ? "" : ",") << "\n";
    }
    out << "  ]\n}\n";
    return write_file_atomic(path, out.str()) ? STATUS_OK : STATUS_IO_ERROR;
}

static std::size_t find_form_start(const std::string &text, const std::string &keyword) {
    bool comment = false;
    for (std::size_t i = 0; i < text.size(); ++i) {
        const char c = text[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') { comment = true; continue; }
        if (c != '(') continue;
        std::size_t j = i + 1;
        while (j < text.size() && std::isspace(static_cast<unsigned char>(text[j]))) ++j;
        if (j + keyword.size() <= text.size() &&
            lower_ascii(text.substr(j, keyword.size())) == lower_ascii(keyword))
            return i;
    }
    return std::string::npos;
}

static std::size_t matching_paren(const std::string &text, std::size_t start) {
    int depth = 0;
    bool comment = false;
    for (std::size_t i = start; i < text.size(); ++i) {
        const char c = text[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') { comment = true; continue; }
        if (c == '(') ++depth;
        else if (c == ')') {
            --depth;
            if (depth == 0) return i;
            if (depth < 0) return std::string::npos;
        }
    }
    return std::string::npos;
}

static std::vector<std::string> split_top_level_forms(const std::string &content) {
    std::vector<std::string> forms;
    bool comment = false;
    int depth = 0;
    std::size_t start = std::string::npos;
    for (std::size_t i = 0; i < content.size(); ++i) {
        const char c = content[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') { comment = true; continue; }
        if (c == '(') {
            if (depth == 0) start = i;
            ++depth;
        } else if (c == ')') {
            if (depth > 0) --depth;
            if (depth == 0 && start != std::string::npos) {
                forms.push_back(trim(content.substr(start, i - start + 1)));
                start = std::string::npos;
            }
        }
    }
    return forms;
}

static std::string form_head(const std::string &form) {
    std::size_t i = form.find('(');
    if (i == std::string::npos) return std::string();
    ++i;
    while (i < form.size() && std::isspace(static_cast<unsigned char>(form[i]))) ++i;
    std::size_t j = i;
    while (j < form.size() && !std::isspace(static_cast<unsigned char>(form[j])) && form[j] != ')') ++j;
    return lower_ascii(form.substr(i, j - i));
}

// Some benchmark families encode :init as "(:init (and ...))" while others
// place the initial forms directly under :init.  Normalise both shapes before
// separating fixed facts from uncertainty constraints.  Without this step an
// outer AND would be copied as a fixed fact together with the old oneof/or
// constraints, defeating refinement and potentially duplicating constraints.
static std::vector<std::string> normalise_init_forms(const std::string &old_content) {
    std::vector<std::string> forms = split_top_level_forms(old_content);
    if (forms.size() != 1 || form_head(forms[0]) != "and") return forms;

    const std::string &and_form = forms[0];
    std::size_t open = and_form.find('(');
    if (open == std::string::npos) return forms;
    std::size_t cursor = open + 1;
    while (cursor < and_form.size() &&
           std::isspace(static_cast<unsigned char>(and_form[cursor]))) ++cursor;
    while (cursor < and_form.size() &&
           !std::isspace(static_cast<unsigned char>(and_form[cursor])) &&
           and_form[cursor] != ')') ++cursor;
    if (cursor >= and_form.size()) return forms;
    const std::size_t close = and_form.rfind(')');
    if (close == std::string::npos || close <= cursor) return forms;
    return split_top_level_forms(and_form.substr(cursor, close - cursor));
}

class AtomSpellingResolver {
public:
    void learn_from_text(const std::string &text) {
        for (std::size_t i = 0; i < text.size(); ++i) {
            if (text[i] != '(') continue;
            const std::size_t end = matching_paren(text, i);
            if (end == std::string::npos) continue;
            const std::string form = trim(text.substr(i, end - i + 1));
            const std::string head = form_head(form);
            if (!head.empty() && head != "and" && head != "or" && head != "oneof" &&
                head != "not" && head != "unknown" && head[0] != ':') {
                spellings_[canonical_atom_form(form)] = form;
            }
        }
    }

    std::string render(const PddlAtom &atom) const {
        std::ostringstream raw;
        raw << '(' << atom.predicate;
        for (std::size_t i = 0; i < atom.arguments.size(); ++i) raw << ' ' << atom.arguments[i];
        raw << ')';
        const std::string key = canonical_atom_form(raw.str());
        std::map<std::string, std::string>::const_iterator it = spellings_.find(key);
        return it == spellings_.end() ? raw.str() : it->second;
    }

private:
    static std::string canonical_atom_form(const std::string &form) {
        std::string x = canonical_symbol_text(form, true);
        return x;
    }
    std::map<std::string, std::string> spellings_;
};

static bool parens_balanced(const std::string &text) {
    int depth = 0;
    bool comment = false;
    for (std::size_t i = 0; i < text.size(); ++i) {
        const char c = text[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') { comment = true; continue; }
        if (c == '(') ++depth;
        else if (c == ')' && --depth < 0) return false;
    }
    return depth == 0;
}


static std::string context_symbol_suffix(const std::string &context_id) {
    std::string out;
    for (std::size_t i = 0; i < context_id.size(); ++i) {
        const unsigned char c = static_cast<unsigned char>(context_id[i]);
        if (std::isalnum(c)) out += static_cast<char>(std::tolower(c));
    }
    if (out.size() > 10) out = out.substr(out.size() - 10);
    if (out.empty()) out = "context";
    return out;
}

static std::string cpa_selector_predicate(const std::string &context_id,
                                          std::size_t index) {
    std::ostringstream out;
    out << "igc-ce-" << context_symbol_suffix(context_id)
        << "-sel-" << std::setw(4) << std::setfill('0') << index;
    return out.str();
}

static std::string cpa_selector_atom(const std::string &context_id,
                                     std::size_t index) {
    return std::string("(") + cpa_selector_predicate(context_id, index) + ")";
}

// iCPCES only exposes atoms that occur positively in an initial ONEOF to its
// relaxed reachability analysis.  A top-level (unknown atom) is parsed, but it
// is not inserted into the Datalog facts used to ground actions.  For every
// ordinary varying atom p, introduce a fresh static complement np and emit
// oneof(p, np).  This preserves ordinary Boolean uncertainty while keeping p
// visible to the unmodified iCPCES implementation.
static std::string icpces_complement_predicate(const std::string &context_id,
                                                std::size_t index) {
    std::ostringstream out;
    out << "igc-ce-" << context_symbol_suffix(context_id)
        << "-neg-" << std::setw(4) << std::setfill('0') << index;
    return out.str();
}

static std::string icpces_complement_atom(const std::string &context_id,
                                          std::size_t index) {
    return std::string("(") +
        icpces_complement_predicate(context_id, index) + ")";
}

struct RefinedRenderStats {
    std::size_t input_counterexamples;
    std::size_t visible_worlds;
    std::size_t mapped_atoms;
    std::size_t fixed_true_atoms;
    std::size_t fixed_false_atoms;
    std::size_t varying_atoms;
    std::size_t emitted_unknown_atoms;
    std::size_t emitted_oneof_groups;
    std::size_t emitted_or_groups;
    std::size_t selector_atoms;
    std::size_t selector_implications;
    std::size_t icpces_complement_atoms;

    RefinedRenderStats()
        : input_counterexamples(0), visible_worlds(0), mapped_atoms(0),
          fixed_true_atoms(0), fixed_false_atoms(0), varying_atoms(0),
          emitted_unknown_atoms(0), emitted_oneof_groups(0), emitted_or_groups(0),
          selector_atoms(0), selector_implications(0),
          icpces_complement_atoms(0) {}
};

class RefinedProblemWriter {
public:
    enum Mode { SINGLE_WORLD, STRUCTURED_PRODUCT, EXACT_SAMPLE_SET };

    RefinedProblemWriter(const OriginalProblemContext &ctx,
                           const SasPddlFactMap &fact_map,
                           const InitialConstraintIR &constraints)
        : ctx_(ctx), fact_map_(fact_map), constraints_(constraints) {}

    StatusCode write(const CounterexampleStore &store,
                     const std::string &template_problem,
                     const std::string &out_problem,
                     Mode mode,
                     RefinedPddlProfile profile,
                     std::string *rendered,
                     RefinedRenderStats *stats) const {
        if (store.size() == 0) return STATUS_INPUT_ERROR;
        if (mode == EXACT_SAMPLE_SET &&
            profile != REFINED_PDDL_CPA_FAMILY &&
            profile != REFINED_PDDL_CPAH &&
            profile != REFINED_PDDL_GC_FAMILY &&
            profile != REFINED_PDDL_GCPCES &&
            profile != REFINED_PDDL_ICPCES)
            return STATUS_UNSUPPORTED_INPUT;
        if (mode == STRUCTURED_PRODUCT && profile != REFINED_PDDL_T1)
            return STATUS_UNSUPPORTED_INPUT;

        RefinedRenderStats local_stats;
        local_stats.input_counterexamples = store.size();

        std::string text;
        if (!read_file(template_problem, &text)) return STATUS_IO_ERROR;
        const std::size_t init_start = find_form_start(text, ":init");
        if (init_start == std::string::npos) return STATUS_INPUT_ERROR;
        const std::size_t init_end = matching_paren(text, init_start);
        if (init_end == std::string::npos) return STATUS_INPUT_ERROR;
        std::size_t keyword_end = text.find(":init", init_start);
        if (keyword_end == std::string::npos || keyword_end > init_end) return STATUS_INPUT_ERROR;
        keyword_end += 5;
        const std::string old_content = text.substr(keyword_end, init_end - keyword_end);
        const std::vector<std::string> forms = normalise_init_forms(old_content);

        std::vector<std::string> fixed_forms;
        AtomSpellingResolver resolver;
        resolver.learn_from_text(old_content);
        for (std::size_t i = 0; i < forms.size(); ++i) {
            const std::string head = form_head(forms[i]);
            if (head == "unknown" || head == "oneof" || head == "or")
                continue;
            // T1 and the original iGC/GC-LAMA front-ends have no usable
            // top-level (not atom) initial form. Known-false atoms are represented
            // by omission under their closed-world convention. CPA-family planners
            // do accept explicit negatives.
            if ((profile == REFINED_PDDL_T1 ||
                 profile == REFINED_PDDL_GC_FAMILY) && head == "not")
                continue;
            fixed_forms.push_back(forms[i]);
        }

        const bool wrap_init_in_and =
            profile == REFINED_PDDL_CPA_FAMILY ||
            profile == REFINED_PDDL_CPAH ||
            profile == REFINED_PDDL_GCPCES ||
            profile == REFINED_PDDL_ICPCES;
        const std::string item_indent = wrap_init_in_and ? "      " : "    ";
        std::vector<std::string> post_and_forms;

        std::ostringstream init;
        init << "(:init\n";
        if (wrap_init_in_and) init << "    (and\n";
        std::set<std::string> emitted;
        for (std::size_t i = 0; i < fixed_forms.size(); ++i) {
            const std::string key = canonical_symbol_text(fixed_forms[i], true);
            if (emitted.insert(key).second)
                init << item_indent << fixed_forms[i] << "\n";
        }

        StatusCode status = STATUS_OK;
        if (mode == SINGLE_WORLD) {
            status = emit_single_world(store.states().front(), resolver, emitted,
                                       profile, item_indent, init, &local_stats);
        } else if (mode == EXACT_SAMPLE_SET) {
            if (profile == REFINED_PDDL_GC_FAMILY) {
                status = emit_gc_exact_sample_set(
                    store, resolver, emitted,
                    item_indent, init, &local_stats);
            } else if (profile == REFINED_PDDL_GCPCES) {
                status = emit_gcpces_exact_sample_set(
                    store, resolver, emitted,
                    item_indent, init, &local_stats);
            } else if (profile == REFINED_PDDL_ICPCES) {
                status = emit_icpces_exact_sample_set(
                    store, resolver, emitted, post_and_forms,
                    item_indent, init, &local_stats);
            } else {
                status = emit_cpa_exact_sample_set(
                    store, resolver, emitted,
                    profile == REFINED_PDDL_CPAH,
                    item_indent, init, &local_stats);
            }
        } else {
            status = emit_t1_structured(store, resolver, emitted,
                                        item_indent, init, &local_stats);
        }
        if (status != STATUS_OK) return status;
        if (wrap_init_in_and) init << "    )\n";
        for (std::size_t i = 0; i < post_and_forms.size(); ++i)
            init << "    " << post_and_forms[i] << "\n";
        init << "  )";

        const std::string output = text.substr(0, init_start) + init.str() + text.substr(init_end + 1);
        if (!parens_balanced(output)) return STATUS_IO_ERROR;
        if (!write_file_atomic(out_problem, output)) return STATUS_IO_ERROR;
        if (rendered) *rendered = output;
        if (stats) *stats = local_stats;
        return STATUS_OK;
    }

private:
    struct MappedAtom {
        int var;
        int val;
        std::string atom;
        std::string key;
    };

    struct MappedAtomLess {
        bool operator()(const MappedAtom &a, const MappedAtom &b) const {
            if (a.key != b.key) return a.key < b.key;
            if (a.var != b.var) return a.var < b.var;
            return a.val < b.val;
        }
    };

    enum CommonValue { COMMON_FALSE = -1, COMMON_VARYING = 0, COMMON_TRUE = 1 };

    StatusCode collect_mapped_atoms(const AtomSpellingResolver &resolver,
                                    std::vector<MappedAtom> *atoms) const {
        atoms->clear();
        std::map<std::string, std::pair<int, int> > seen;
        const SasPddlFactMap::FactEntries &entries = fact_map_.entries();
        for (SasPddlFactMap::FactEntries::const_iterator it = entries.begin();
             it != entries.end(); ++it) {
            MappedAtom item;
            item.var = it->first.first;
            item.val = it->first.second;
            item.atom = resolver.render(it->second);
            item.key = canonical_symbol_text(item.atom, true);
            std::map<std::string, std::pair<int, int> >::const_iterator old = seen.find(item.key);
            if (old != seen.end()) {
                if (old->second.first != item.var || old->second.second != item.val)
                    return STATUS_MAPPING_ERROR;
                continue;
            }
            seen[item.key] = std::make_pair(item.var, item.val);
            atoms->push_back(item);
        }
        std::sort(atoms->begin(), atoms->end(), MappedAtomLess());
        return atoms->empty() ? STATUS_MAPPING_ERROR : STATUS_OK;
    }

    StatusCode build_visible_worlds(const CounterexampleStore &store,
                                    const std::vector<MappedAtom> &atoms,
                                    std::vector< std::vector<int> > *worlds) const {
        worlds->clear();
        std::set<std::string> seen;
        for (std::size_t wi = 0; wi < store.states().size(); ++wi) {
            const std::vector<int> &state = store.states()[wi].sas_values;
            std::vector<int> truth(atoms.size(), 0);
            std::ostringstream signature;
            for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
                if (atoms[ai].var < 0 || atoms[ai].var >= static_cast<int>(state.size()))
                    return STATUS_INPUT_ERROR;
                truth[ai] = state[atoms[ai].var] == atoms[ai].val ? 1 : 0;
                signature << truth[ai];
            }
            if (seen.insert(signature.str()).second) worlds->push_back(truth);
        }
        return worlds->empty() ? STATUS_INPUT_ERROR : STATUS_OK;
    }

    static std::string literal_form(const std::string &atom, bool positive) {
        return positive ? atom : std::string("(not ") + atom + ")";
    }

    StatusCode emit_assignment(const std::string &atom,
                               bool value,
                               bool explicit_false,
                               std::set<std::string> &emitted,
                               const std::string &indent,
                               std::ostringstream &out) const {
        const std::string pos_key = canonical_symbol_text(atom, true);
        const std::string neg_form = std::string("(not ") + atom + ")";
        const std::string neg_key = canonical_symbol_text(neg_form, true);
        if (value) {
            if (emitted.find(neg_key) != emitted.end()) return STATUS_BACKEND_ERROR;
            if (emitted.insert(pos_key).second) out << indent << atom << "\n";
        } else {
            if (emitted.find(pos_key) != emitted.end()) return STATUS_BACKEND_ERROR;
            if (explicit_false && emitted.insert(neg_key).second)
                out << indent << neg_form << "\n";
        }
        return STATUS_OK;
    }

    StatusCode emit_single_world(const CounterexampleState &ce,
                                 const AtomSpellingResolver &resolver,
                                 std::set<std::string> &emitted,
                                 RefinedPddlProfile profile,
                                 const std::string &indent,
                                 std::ostringstream &out,
                                 RefinedRenderStats *stats) const {
        std::vector<MappedAtom> atoms;
        StatusCode st = collect_mapped_atoms(resolver, &atoms);
        if (st != STATUS_OK) return st;
        stats->mapped_atoms = atoms.size();
        stats->visible_worlds = 1;
        const bool explicit_false =
            profile != REFINED_PDDL_T1 && profile != REFINED_PDDL_GC_FAMILY;
        for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
            if (atoms[ai].var < 0 || atoms[ai].var >= static_cast<int>(ce.sas_values.size()))
                return STATUS_INPUT_ERROR;
            const bool value = ce.sas_values[atoms[ai].var] == atoms[ai].val;
            st = emit_assignment(atoms[ai].atom, value, explicit_false,
                                 emitted, indent, out);
            if (st != STATUS_OK) return st;
            if (value) ++stats->fixed_true_atoms;
            else ++stats->fixed_false_atoms;
        }
        return STATUS_OK;
    }

    StatusCode emit_gc_exact_sample_set(const CounterexampleStore &store,
                                        const AtomSpellingResolver &resolver,
                                        std::set<std::string> &emitted,
                                        const std::string &indent,
                                        std::ostringstream &out,
                                        RefinedRenderStats *stats) const {
        std::vector<MappedAtom> atoms;
        StatusCode st = collect_mapped_atoms(resolver, &atoms);
        if (st != STATUS_OK) return st;
        std::vector< std::vector<int> > worlds;
        st = build_visible_worlds(store, atoms, &worlds);
        if (st != STATUS_OK) return st;
        stats->mapped_atoms = atoms.size();
        stats->visible_worlds = worlds.size();

        std::vector<std::size_t> varying;
        for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
            bool same = true;
            for (std::size_t wi = 1; wi < worlds.size(); ++wi) {
                if (worlds[wi][ai] != worlds[0][ai]) {
                    same = false;
                    break;
                }
            }
            if (same) {
                // The original iGC and GC-LAMA translators use a closed-world
                // initial state. Emit common true atoms and omit common false
                // atoms; top-level negative literals are not parsed correctly.
                st = emit_assignment(atoms[ai].atom, worlds[0][ai] != 0, false,
                                     emitted, indent, out);
                if (st != STATUS_OK) return st;
                if (worlds[0][ai]) ++stats->fixed_true_atoms;
                else ++stats->fixed_false_atoms;
            } else {
                varying.push_back(ai);
                ++stats->varying_atoms;
            }
        }

        if (worlds.size() == 1) return STATUS_OK;
        if (varying.empty()) return STATUS_BACKEND_ERROR;

        // GC-LAMA's parser is not standard PDDL here: :init must list forms
        // directly (without an outer AND), UNKNOWN is unsupported, and its
        // translator turns a ONEOF of conjunctions into the explicit belief
        // states stored in the generated "belief" file.  Each alternative
        // contains exactly the positive varying atoms of one counterexample;
        // omitted atoms are reset to the SAS <none of those> value when the
        // planner moves to the next belief state.  This operational encoding is
        // shared by the original iGC translator and GC-LAMA.
        std::ostringstream oneof;
        oneof << "(oneof\n";
        for (std::size_t wi = 0; wi < worlds.size(); ++wi) {
            oneof << indent << "  (and";
            bool any = false;
            for (std::size_t vi = 0; vi < varying.size(); ++vi) {
                const std::size_t ai = varying[vi];
                if (worlds[wi][ai]) {
                    oneof << ' ' << atoms[ai].atom;
                    any = true;
                }
            }
            // Empty conjunction is intentional: it denotes a world in which
            // all varying atoms are false under the planner's closed-world
            // convention.
            (void)any;
            oneof << ")\n";
        }
        oneof << indent << ')';
        const std::string form = oneof.str();
        if (emitted.insert(canonical_symbol_text(form, true)).second)
            out << indent << form << "\n";
        ++stats->emitted_oneof_groups;
        return STATUS_OK;
    }

    StatusCode emit_gcpces_exact_sample_set(const CounterexampleStore &store,
                                            const AtomSpellingResolver &resolver,
                                            std::set<std::string> &emitted,
                                            const std::string &indent,
                                            std::ostringstream &out,
                                            RefinedRenderStats *stats) const {
        std::vector<MappedAtom> atoms;
        StatusCode st = collect_mapped_atoms(resolver, &atoms);
        if (st != STATUS_OK) return st;
        std::vector< std::vector<int> > worlds;
        st = build_visible_worlds(store, atoms, &worlds);
        if (st != STATUS_OK) return st;
        stats->mapped_atoms = atoms.size();
        stats->visible_worlds = worlds.size();

        std::vector<std::size_t> varying;
        for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
            bool same = true;
            for (std::size_t wi = 1; wi < worlds.size(); ++wi) {
                if (worlds[wi][ai] != worlds[0][ai]) {
                    same = false;
                    break;
                }
            }
            if (same) {
                st = emit_assignment(atoms[ai].atom, worlds[0][ai] != 0, true,
                                     emitted, indent, out);
                if (st != STATUS_OK) return st;
                if (worlds[0][ai]) ++stats->fixed_true_atoms;
                else ++stats->fixed_false_atoms;
            } else {
                varying.push_back(ai);
                ++stats->varying_atoms;
            }
        }

        if (worlds.size() == 1) return STATUS_OK;
        if (varying.empty()) return STATUS_BACKEND_ERROR;

        // gCPCES uses PPMaJal2. It accepts an ordinary PDDL ONEOF whose
        // alternatives are arbitrary formulas, including conjunctions with
        // explicit negative literals. UNKNOWN is not part of its grammar.
        // Encode every varying atom in every alternative so that the projected
        // model set is exactly the current PDDL-visible counterexample set.
        std::ostringstream oneof;
        oneof << "(oneof\n";
        for (std::size_t wi = 0; wi < worlds.size(); ++wi) {
            oneof << indent << "  (and";
            for (std::size_t vi = 0; vi < varying.size(); ++vi) {
                const std::size_t ai = varying[vi];
                oneof << ' ' << literal_form(atoms[ai].atom,
                                              worlds[wi][ai] != 0);
            }
            oneof << ")\n";
        }
        oneof << indent << ')';
        const std::string form = oneof.str();
        if (emitted.insert(canonical_symbol_text(form, true)).second)
            out << indent << form << "\n";
        ++stats->emitted_oneof_groups;
        return STATUS_OK;
    }

    StatusCode emit_icpces_exact_sample_set(
            const CounterexampleStore &store,
            const AtomSpellingResolver &resolver,
            std::set<std::string> &emitted,
            std::vector<std::string> &post_and_forms,
            const std::string &indent,
            std::ostringstream &out,
            RefinedRenderStats *stats) const {
        std::vector<MappedAtom> atoms;
        StatusCode st = collect_mapped_atoms(resolver, &atoms);
        if (st != STATUS_OK) return st;
        std::vector< std::vector<int> > worlds;
        st = build_visible_worlds(store, atoms, &worlds);
        if (st != STATUS_OK) return st;
        stats->mapped_atoms = atoms.size();
        stats->visible_worlds = worlds.size();

        std::vector<std::size_t> varying;
        for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
            bool same = true;
            for (std::size_t wi = 1; wi < worlds.size(); ++wi) {
                if (worlds[wi][ai] != worlds[0][ai]) {
                    same = false;
                    break;
                }
            }
            if (same) {
                st = emit_assignment(atoms[ai].atom, worlds[0][ai] != 0, true,
                                     emitted, indent, out);
                if (st != STATUS_OK) return st;
                if (worlds[0][ai]) ++stats->fixed_true_atoms;
                else ++stats->fixed_false_atoms;
            } else {
                varying.push_back(ai);
                ++stats->varying_atoms;
            }
        }

        if (worlds.size() == 1) return STATUS_OK;
        if (varying.empty()) return STATUS_BACKEND_ERROR;

        // Do not emit top-level UNKNOWN for iCPCES.  Its parser records those
        // atoms, but its unmodified translate/pddl_to_prolog.py does not feed
        // them into relaxed reachability.  The consequence is missing grounded
        // actions, incomplete contexts, and eventually malformed SuperB tag
        // constraints.  Use only the native positive-atomic ONEOF mechanism:
        //
        //   oneof(p, fresh-not-p)
        //
        // for each varying ordinary atom p.  The fresh atom is static and has
        // no action effects.  It is merely the positive complement required by
        // iCPCES' ONEOF front-end.  Together with the selector implications,
        // the projection onto the original atoms is exactly the stored finite
        // world set.
        (void)post_and_forms; // Kept in the signature for the common writer API.
        for (std::size_t vi = 0; vi < varying.size(); ++vi) {
            const std::size_t ai = varying[vi];
            std::ostringstream pair;
            pair << "(oneof " << atoms[ai].atom << ' '
                 << icpces_complement_atom(ctx_.context_id, vi) << ')';
            const std::string form = pair.str();
            if (emitted.insert(canonical_symbol_text(form, true)).second)
                out << indent << form << "\n";
            ++stats->emitted_oneof_groups;
            ++stats->icpces_complement_atoms;
        }

        std::ostringstream selectors;
        selectors << "(oneof";
        for (std::size_t wi = 0; wi < worlds.size(); ++wi)
            selectors << ' ' << cpa_selector_atom(ctx_.context_id, wi);
        selectors << ')';
        const std::string selector_form = selectors.str();
        if (emitted.insert(canonical_symbol_text(selector_form, true)).second)
            out << indent << selector_form << "\n";
        ++stats->emitted_oneof_groups;
        stats->selector_atoms = worlds.size();

        for (std::size_t wi = 0; wi < worlds.size(); ++wi) {
            const std::string selector = cpa_selector_atom(ctx_.context_id, wi);
            for (std::size_t vi = 0; vi < varying.size(); ++vi) {
                const std::size_t ai = varying[vi];
                std::ostringstream clause;
                clause << "(or (not " << selector << ") "
                       << literal_form(atoms[ai].atom, worlds[wi][ai] != 0)
                       << ')';
                const std::string form = clause.str();
                if (emitted.insert(canonical_symbol_text(form, true)).second)
                    out << indent << form << "\n";
                ++stats->emitted_or_groups;
                ++stats->selector_implications;
            }
        }
        return STATUS_OK;
    }

    StatusCode emit_cpa_exact_sample_set(const CounterexampleStore &store,
                                         const AtomSpellingResolver &resolver,
                                         std::set<std::string> &emitted,
                                         bool declare_varying_unknown,
                                         const std::string &indent,
                                         std::ostringstream &out,
                                         RefinedRenderStats *stats) const {
        std::vector<MappedAtom> atoms;
        StatusCode st = collect_mapped_atoms(resolver, &atoms);
        if (st != STATUS_OK) return st;
        std::vector< std::vector<int> > worlds;
        st = build_visible_worlds(store, atoms, &worlds);
        if (st != STATUS_OK) return st;
        stats->mapped_atoms = atoms.size();
        stats->visible_worlds = worlds.size();

        std::vector<std::size_t> varying;
        for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
            bool same = true;
            for (std::size_t wi = 1; wi < worlds.size(); ++wi) {
                if (worlds[wi][ai] != worlds[0][ai]) {
                    same = false;
                    break;
                }
            }
            if (same) {
                st = emit_assignment(atoms[ai].atom, worlds[0][ai] != 0, true,
                                     emitted, indent, out);
                if (st != STATUS_OK) return st;
                if (worlds[0][ai]) ++stats->fixed_true_atoms;
                else ++stats->fixed_false_atoms;
            } else {
                varying.push_back(ai);
                ++stats->varying_atoms;
            }
        }

        if (worlds.size() == 1) return STATUS_OK;
        if (varying.empty()) return STATUS_BACKEND_ERROR;

        // CPA(H)'s newer PDDL front-end infers UNKNOWN only from ONEOF members
        // and explicit (unknown atom) forms.  Unlike the older CNF/DNF/PIP
        // front-end, merely mentioning an atom in an OR clause does not stop
        // the closed-world rule from asserting it false.  The selector
        // implications below therefore require explicit UNKNOWN declarations
        // for every ordinary atom that varies across the stored worlds.
        // Keep this profile-specific: the bundled CNF/DNF/PIP translator rejects
        // the UNKNOWN token entirely.
        if (declare_varying_unknown) {
            for (std::size_t vi = 0; vi < varying.size(); ++vi) {
                const std::string form = std::string("(unknown ") +
                    atoms[varying[vi]].atom + ")";
                if (emitted.insert(canonical_symbol_text(form, true)).second)
                    out << indent << form << "\n";
                ++stats->emitted_unknown_atoms;
            }
        }

        // The bundled CPA-family front-end accepts ONEOF-of-conjunctions
        // syntactically, but mult5zsic.pl fails for three or more complete
        // alternatives when two worlds share a literal. Encode the exact
        // finite sample with fresh static selector fluents instead:
        //
        //   oneof(sel_0, ..., sel_n)
        //   sel_i -> each varying literal of world i
        //
        // Exactly one selector is true and every varying atom is fixed by the
        // selected world, so the projected initial states are exactly the
        // stored counterexample worlds. This uses only the CPA front-end's
        // mature primitives: positive atomic ONEOF and literal OR clauses.
        std::ostringstream selectors;
        selectors << "(oneof";
        for (std::size_t wi = 0; wi < worlds.size(); ++wi)
            selectors << ' ' << cpa_selector_atom(ctx_.context_id, wi);
        selectors << ')';
        const std::string selector_form = selectors.str();
        if (emitted.insert(canonical_symbol_text(selector_form, true)).second)
            out << indent << selector_form << "\n";
        ++stats->emitted_oneof_groups;
        stats->selector_atoms = worlds.size();

        for (std::size_t wi = 0; wi < worlds.size(); ++wi) {
            const std::string selector = cpa_selector_atom(ctx_.context_id, wi);
            for (std::size_t vi = 0; vi < varying.size(); ++vi) {
                const std::size_t ai = varying[vi];
                std::ostringstream clause;
                clause << "(or (not " << selector << ") "
                       << literal_form(atoms[ai].atom, worlds[wi][ai] != 0)
                       << ')';
                const std::string form = clause.str();
                if (emitted.insert(canonical_symbol_text(form, true)).second)
                    out << indent << form << "\n";
                ++stats->emitted_or_groups;
                ++stats->selector_implications;
            }
        }
        return STATUS_OK;
    }

    StatusCode atom_for_literal(const SasLiteral &lit,
                                const AtomSpellingResolver &resolver,
                                std::string *atom) const {
        PddlAtom p;
        if (!fact_map_.find(lit.var, lit.val, &p)) return STATUS_MAPPING_ERROR;
        *atom = resolver.render(p);
        return STATUS_OK;
    }

    StatusCode emit_t1_structured(const CounterexampleStore &store,
                                  const AtomSpellingResolver &resolver,
                                  std::set<std::string> &emitted,
                                  const std::string &indent,
                                  std::ostringstream &out,
                                  RefinedRenderStats *stats) const {
        std::vector<MappedAtom> atoms;
        StatusCode st = collect_mapped_atoms(resolver, &atoms);
        if (st != STATUS_OK) return st;
        std::vector< std::vector<int> > worlds;
        st = build_visible_worlds(store, atoms, &worlds);
        if (st != STATUS_OK) return st;
        stats->mapped_atoms = atoms.size();
        stats->visible_worlds = worlds.size();

        std::map<std::string, CommonValue> assignment;
        std::set<std::string> uncertain_atoms;
        for (std::size_t ai = 0; ai < atoms.size(); ++ai) {
            bool same = true;
            for (std::size_t wi = 1; wi < worlds.size(); ++wi) {
                if (worlds[wi][ai] != worlds[0][ai]) {
                    same = false;
                    break;
                }
            }
            if (!same) {
                assignment[atoms[ai].key] = COMMON_VARYING;
                uncertain_atoms.insert(atoms[ai].atom);
                ++stats->varying_atoms;
                continue;
            }
            const bool value = worlds[0][ai] != 0;
            assignment[atoms[ai].key] = value ? COMMON_TRUE : COMMON_FALSE;
            st = emit_assignment(atoms[ai].atom, value, false,
                                 emitted, indent, out);
            if (st != STATUS_OK) return st;
            if (value) ++stats->fixed_true_atoms;
            else ++stats->fixed_false_atoms;
        }

        std::vector<std::string> rendered_oneofs;
        std::vector<std::string> rendered_ors;
        const std::vector<ConstraintGroup> &groups = constraints_.groups();
        for (std::size_t gi = 0; gi < groups.size(); ++gi) {
            const ConstraintGroup &group = groups[gi];
            if (group.kind == ConstraintGroup::GROUP_ONEOF) {
                std::vector<std::string> varying_alts;
                int fixed_true_count = 0;
                for (std::size_t ai = 0; ai < group.alternatives.size(); ++ai) {
                    const ConstraintAlternative &alt = group.alternatives[ai];
                    // T1's grammar accepts only atomic, positive ONEOF members.
                    if (alt.size() != 1 || !alt[0].positive)
                        return STATUS_UNSUPPORTED_INPUT;
                    std::string atom;
                    st = atom_for_literal(alt[0], resolver, &atom);
                    if (st != STATUS_OK) return st;
                    const std::string key = canonical_symbol_text(atom, true);
                    std::map<std::string, CommonValue>::const_iterator av = assignment.find(key);
                    if (av == assignment.end()) return STATUS_MAPPING_ERROR;
                    if (av->second == COMMON_TRUE) {
                        ++fixed_true_count;
                    } else if (av->second == COMMON_VARYING) {
                        varying_alts.push_back(atom);
                        uncertain_atoms.insert(atom);
                    }
                }
                if (fixed_true_count > 1) return STATUS_BACKEND_ERROR;
                if (fixed_true_count == 1) {
                    if (!varying_alts.empty()) return STATUS_BACKEND_ERROR;
                    continue;
                }
                if (varying_alts.size() < 2) return STATUS_BACKEND_ERROR;
                std::ostringstream form;
                form << "(oneof";
                for (std::size_t i = 0; i < varying_alts.size(); ++i)
                    form << ' ' << varying_alts[i];
                form << ')';
                rendered_oneofs.push_back(form.str());
                continue;
            }

            bool satisfied_by_fixed = false;
            std::vector<std::string> varying_disjuncts;
            for (std::size_t ai = 0; ai < group.alternatives.size(); ++ai) {
                const ConstraintAlternative &alt = group.alternatives[ai];
                // T1's OR grammar is a disjunction of literals, not conjunctions.
                if (alt.size() != 1) return STATUS_UNSUPPORTED_INPUT;
                std::string atom;
                st = atom_for_literal(alt[0], resolver, &atom);
                if (st != STATUS_OK) return st;
                const std::string key = canonical_symbol_text(atom, true);
                std::map<std::string, CommonValue>::const_iterator av = assignment.find(key);
                if (av == assignment.end()) return STATUS_MAPPING_ERROR;
                if (av->second == COMMON_VARYING) {
                    uncertain_atoms.insert(atom);
                    varying_disjuncts.push_back(literal_form(atom, alt[0].positive));
                    continue;
                }
                const bool atom_value = av->second == COMMON_TRUE;
                const bool literal_value = alt[0].positive ? atom_value : !atom_value;
                if (literal_value) {
                    satisfied_by_fixed = true;
                    break;
                }
            }
            if (satisfied_by_fixed) continue;
            // Every stored world satisfies the original OR.  If partial
            // evaluation leaves fewer than two varying disjuncts, the common
            // assignment or the SAS/PDDL map is inconsistent.
            if (varying_disjuncts.size() < 2) return STATUS_BACKEND_ERROR;
            std::ostringstream form;
            form << "(or";
            for (std::size_t i = 0; i < varying_disjuncts.size(); ++i)
                form << ' ' << varying_disjuncts[i];
            form << ')';
            rendered_ors.push_back(form.str());
        }

        // Every atom that varies across the stored worlds must remain unknown,
        // including independent unknowns not mentioned by oneof/or.
        for (std::set<std::string>::const_iterator it = uncertain_atoms.begin();
             it != uncertain_atoms.end(); ++it) {
            const std::string form = std::string("(unknown ") + *it + ")";
            const std::string key = canonical_symbol_text(form, true);
            if (emitted.insert(key).second) {
                out << indent << form << "\n";
                ++stats->emitted_unknown_atoms;
            }
        }

        for (std::size_t i = 0; i < rendered_oneofs.size(); ++i) {
            const std::string key = canonical_symbol_text(rendered_oneofs[i], true);
            if (emitted.insert(key).second) out << indent << rendered_oneofs[i] << "\n";
            ++stats->emitted_oneof_groups;
        }
        for (std::size_t i = 0; i < rendered_ors.size(); ++i) {
            const std::string key = canonical_symbol_text(rendered_ors[i], true);
            if (emitted.insert(key).second) out << indent << rendered_ors[i] << "\n";
            ++stats->emitted_or_groups;
        }
        return STATUS_OK;
    }

    OriginalProblemContext ctx_;
    const SasPddlFactMap &fact_map_;
    const InitialConstraintIR &constraints_;
};


static std::size_t count_top_level_action_field(const std::string &action_form,
                                                const std::string &field_name) {
    const std::string wanted = lower_ascii(field_name);
    std::size_t count = 0;
    int depth = 0;
    bool comment = false;
    for (std::size_t i = 0; i < action_form.size(); ++i) {
        const char c = action_form[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') {
            comment = true;
            continue;
        }
        if (c == '(') {
            ++depth;
            continue;
        }
        if (c == ')') {
            --depth;
            if (depth < 0) return 0;
            continue;
        }
        if (depth != 1 || c != ':') continue;

        std::size_t j = i + 1;
        while (j < action_form.size()) {
            const char t = action_form[j];
            if (std::isspace(static_cast<unsigned char>(t)) ||
                t == '(' || t == ')' || t == ';')
                break;
            ++j;
        }
        if (lower_ascii(action_form.substr(i, j - i)) == wanted) ++count;
        if (j > i) i = j - 1;
    }
    return count;
}

static StatusCode validate_cpah_action_parameter_fields(const std::string &input,
                                                        std::size_t *action_count) {
    std::size_t actions = 0;
    bool comment = false;
    for (std::size_t i = 0; i < input.size(); ++i) {
        const char c = input[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') {
            comment = true;
            continue;
        }
        if (c != '(') continue;
        const std::size_t end = matching_paren(input, i);
        if (end == std::string::npos) return STATUS_INPUT_ERROR;
        const std::string form = input.substr(i, end - i + 1);
        if (form_head(form) != ":action") continue;
        ++actions;
        if (count_top_level_action_field(form, ":parameters") != 1)
            return STATUS_INPUT_ERROR;
        i = end;
    }
    if (action_count) *action_count = actions;
    return STATUS_OK;
}

static StatusCode normalise_cpah_empty_action_parameters(
        const std::string &input,
        std::string *output,
        std::size_t *inserted_count) {
    std::vector<std::size_t> insertions;
    bool comment = false;
    for (std::size_t i = 0; i < input.size(); ++i) {
        const char c = input[i];
        if (comment) {
            if (c == '\n') comment = false;
            continue;
        }
        if (c == ';') {
            comment = true;
            continue;
        }
        if (c != '(') continue;
        const std::size_t end = matching_paren(input, i);
        if (end == std::string::npos) return STATUS_INPUT_ERROR;
        const std::string form = input.substr(i, end - i + 1);
        if (form_head(form) != ":action") continue;

        // :parameters is a top-level action field, not a parenthesised form.
        // find_form_start() therefore cannot detect a valid declaration such as
        //     :parameters (?x - block)
        // and the old implementation inserted a duplicate :parameters () field.
        const std::size_t parameter_fields =
            count_top_level_action_field(form, ":parameters");
        if (parameter_fields > 1) return STATUS_INPUT_ERROR;
        if (parameter_fields == 1) {
            i = end;
            continue;
        }

        // Insert only for a genuinely parameterless action.
        std::size_t cursor = i + 1;
        while (cursor < end &&
               std::isspace(static_cast<unsigned char>(input[cursor]))) ++cursor;
        while (cursor < end &&
               !std::isspace(static_cast<unsigned char>(input[cursor])) &&
               input[cursor] != ')') ++cursor; // :action
        while (cursor < end &&
               std::isspace(static_cast<unsigned char>(input[cursor]))) ++cursor;
        while (cursor < end &&
               !std::isspace(static_cast<unsigned char>(input[cursor])) &&
               input[cursor] != ')') ++cursor; // action name
        if (cursor >= end) return STATUS_INPUT_ERROR;
        insertions.push_back(cursor);
        i = end;
    }

    std::string result = input;
    for (std::vector<std::size_t>::reverse_iterator it = insertions.rbegin();
         it != insertions.rend(); ++it)
        result.insert(*it, "\n    :parameters ()");
    if (!parens_balanced(result)) return STATUS_IO_ERROR;

    // Fail before invoking cpa.pddl2pl if generation produced a missing or
    // duplicate action-parameter field.
    std::size_t validated_actions = 0;
    const StatusCode validation =
        validate_cpah_action_parameter_fields(result, &validated_actions);
    if (validation != STATUS_OK) return validation;

    if (output) *output = result;
    if (inserted_count) *inserted_count = insertions.size();
    return STATUS_OK;
}

static StatusCode write_cpa_selector_domain(const OriginalProblemContext &ctx,
                                            const std::string &template_domain,
                                            const std::string &out_domain,
                                            std::size_t selector_count,
                                            std::size_t icpces_complement_count,
                                            bool cpah_compatibility,
                                            std::size_t *added_empty_parameters,
                                            std::string *rendered) {
    std::string text;
    if (!read_file(template_domain, &text)) return STATUS_IO_ERROR;

    std::string with_selectors = text;
    if (selector_count > 0 || icpces_complement_count > 0) {
        const std::size_t predicates_start = find_form_start(text, ":predicates");
        if (predicates_start == std::string::npos) return STATUS_INPUT_ERROR;
        const std::size_t predicates_end = matching_paren(text, predicates_start);
        if (predicates_end == std::string::npos) return STATUS_INPUT_ERROR;

        const std::string lowered = lower_ascii(text);
        std::ostringstream additions;
        for (std::size_t i = 0; i < selector_count; ++i) {
            const std::string pred = cpa_selector_predicate(ctx.context_id, i);
            if (lowered.find(std::string("(") + lower_ascii(pred) + ")") !=
                std::string::npos)
                return STATUS_MAPPING_ERROR;
            additions << "\n    (" << pred << ")";
        }
        for (std::size_t i = 0; i < icpces_complement_count; ++i) {
            const std::string pred =
                icpces_complement_predicate(ctx.context_id, i);
            if (lowered.find(std::string("(") + lower_ascii(pred) + ")") !=
                std::string::npos)
                return STATUS_MAPPING_ERROR;
            additions << "\n    (" << pred << ")";
        }
        additions << "\n  ";
        with_selectors = text.substr(0, predicates_end) + additions.str() +
                         text.substr(predicates_end);
    }

    std::string output = with_selectors;
    std::size_t inserted = 0;
    if (cpah_compatibility) {
        StatusCode st = normalise_cpah_empty_action_parameters(
            with_selectors, &output, &inserted);
        if (st != STATUS_OK) return st;
    }
    if (!parens_balanced(output)) return STATUS_IO_ERROR;
    if (!write_file_atomic(out_domain, output)) return STATUS_IO_ERROR;
    if (added_empty_parameters) *added_empty_parameters = inserted;
    if (rendered) *rendered = output;
    return STATUS_OK;
}

static StatusCode validate_refined(const OriginalProblemContext &ctx,
                                   const CounterexampleStore &store,
                                   const InitialConstraintIR &constraints,
                                   const std::string &rendered,
                                   RefinedProblemWriter::Mode mode,
                                   RefinedPddlProfile profile,
                                   const RefinedRenderStats &stats,
                                   std::string *message) {
    if (!parens_balanced(rendered)) {
        if (message) *message = "PDDL parentheses are not balanced";
        return STATUS_IO_ERROR;
    }
    const std::string lowered_rendered = lower_ascii(rendered);
    const bool unknown_forbidden =
        profile == REFINED_PDDL_CPA_FAMILY ||
        profile == REFINED_PDDL_GC_FAMILY ||
        profile == REFINED_PDDL_GCPCES;
    if (unknown_forbidden &&
        (lowered_rendered.find("(unknown") != std::string::npos ||
         stats.emitted_unknown_atoms != 0)) {
        if (message) {
            if (profile == REFINED_PDDL_GC_FAMILY)
                *message = "iGC/GC-LAMA profile must not contain UNKNOWN forms";
            else if (profile == REFINED_PDDL_GCPCES)
                *message = "gCPCES profile must not contain UNKNOWN forms";
            else
                *message = "CNF/DNF/PIP profile must not contain UNKNOWN forms";
        }
        return STATUS_UNSUPPORTED_INPUT;
    }
    if (stats.visible_worlds == 0 || stats.mapped_atoms == 0) {
        if (message) *message = "renderer did not encode any visible world or mapped atom";
        return STATUS_BACKEND_ERROR;
    }
    if (stats.fixed_true_atoms + stats.fixed_false_atoms + stats.varying_atoms !=
        stats.mapped_atoms) {
        if (message) *message = "renderer atom accounting mismatch";
        return STATUS_BACKEND_ERROR;
    }

    const bool exact_selector_profile =
        profile == REFINED_PDDL_CPA_FAMILY ||
        profile == REFINED_PDDL_CPAH ||
        profile == REFINED_PDDL_ICPCES;
    const bool exact_gc_profile = profile == REFINED_PDDL_GC_FAMILY;
    const bool exact_gcpces_profile = profile == REFINED_PDDL_GCPCES;

    if (exact_selector_profile) {
        if (mode != RefinedProblemWriter::SINGLE_WORLD &&
            mode != RefinedProblemWriter::EXACT_SAMPLE_SET) {
            if (message) *message =
                "selector renderer must use exact world/sample semantics";
            return STATUS_BACKEND_ERROR;
        }
        if (stats.visible_worlds == 1 &&
            (stats.varying_atoms != 0 || stats.emitted_unknown_atoms != 0 ||
             stats.emitted_oneof_groups != 0 || stats.emitted_or_groups != 0 ||
             stats.selector_atoms != 0 || stats.selector_implications != 0 ||
             stats.icpces_complement_atoms != 0)) {
            if (message) *message =
                "single selector-profile world must contain only complete unit assignments";
            return STATUS_BACKEND_ERROR;
        }
        if (stats.visible_worlds > 1) {
            const std::size_t expected_implications =
                stats.visible_worlds * stats.varying_atoms;
            const std::size_t expected_oneofs =
                profile == REFINED_PDDL_ICPCES
                    ? stats.varying_atoms + 1
                    : 1;
            if (stats.varying_atoms == 0 ||
                stats.emitted_oneof_groups != expected_oneofs ||
                stats.selector_atoms != stats.visible_worlds ||
                stats.selector_implications != expected_implications ||
                stats.emitted_or_groups != expected_implications) {
                if (message) *message =
                    profile == REFINED_PDDL_ICPCES
                        ? "iCPCES exact worlds require one selector ONEOF, one native "
                          "binary ONEOF per varying atom, and one selector implication "
                          "per world/varying-atom pair"
                        : "multiple selector-profile worlds require one selector ONEOF "
                          "and one selector implication per world/varying-atom pair";
                return STATUS_BACKEND_ERROR;
            }
            if (profile == REFINED_PDDL_CPAH) {
                if (stats.emitted_unknown_atoms != stats.varying_atoms ||
                    stats.icpces_complement_atoms != 0) {
                    if (message) *message =
                        "CPA(H) must explicitly declare every varying ordinary atom UNKNOWN";
                    return STATUS_BACKEND_ERROR;
                }
            } else if (profile == REFINED_PDDL_ICPCES) {
                if (stats.emitted_unknown_atoms != 0 ||
                    stats.icpces_complement_atoms != stats.varying_atoms) {
                    if (message) *message =
                        "iCPCES must expose every varying ordinary atom through a native "
                        "positive-atomic binary ONEOF and must not use top-level UNKNOWN";
                    return STATUS_BACKEND_ERROR;
                }
            } else if (stats.emitted_unknown_atoms != 0 ||
                       stats.icpces_complement_atoms != 0) {
                if (message) *message =
                    "CNF/DNF/PIP selector profile emitted iCPCES-only uncertainty forms";
                return STATUS_BACKEND_ERROR;
            }
            if (lowered_rendered.find("(oneof (and") != std::string::npos) {
                if (message) *message =
                    "selector renderer must not emit ONEOF-of-conjunctions";
                return STATUS_UNSUPPORTED_INPUT;
            }
        }

        if (profile == REFINED_PDDL_ICPCES) {
            const std::size_t init_start = find_form_start(rendered, ":init");
            if (init_start == std::string::npos) {
                if (message) *message = "iCPCES problem has no :init form";
                return STATUS_INPUT_ERROR;
            }
            const std::size_t init_end = matching_paren(rendered, init_start);
            const std::size_t key = rendered.find(":init", init_start);
            if (init_end == std::string::npos || key == std::string::npos ||
                key > init_end) {
                if (message) *message = "cannot parse iCPCES :init form";
                return STATUS_INPUT_ERROR;
            }
            const std::vector<std::string> top = split_top_level_forms(
                rendered.substr(key + 5, init_end - (key + 5)));
            if (top.empty() || form_head(top[0]) != "and") {
                if (message) *message =
                    "iCPCES :init must start with exactly one outer AND";
                return STATUS_UNSUPPORTED_INPUT;
            }
            if (lower_ascii(top[0]).find("(unknown") != std::string::npos ||
                stats.emitted_unknown_atoms != 0) {
                if (message) *message =
                    "iCPCES refined problems must not use top-level UNKNOWN; varying "
                    "atoms must use native positive-atomic binary ONEOF groups";
                return STATUS_UNSUPPORTED_INPUT;
            }
            if (top.size() != 1) {
                if (message) *message =
                    "iCPCES refined :init must contain exactly one outer AND and no "
                    "additional top-level forms";
                return STATUS_UNSUPPORTED_INPUT;
            }
        }
    } else if (exact_gcpces_profile) {
        if (mode != RefinedProblemWriter::SINGLE_WORLD &&
            mode != RefinedProblemWriter::EXACT_SAMPLE_SET) {
            if (message) *message =
                "gCPCES renderer must use exact world/sample semantics";
            return STATUS_BACKEND_ERROR;
        }
        if (stats.emitted_unknown_atoms != 0 ||
            stats.emitted_or_groups != 0 ||
            stats.selector_atoms != 0 ||
            stats.selector_implications != 0) {
            if (message) *message =
                "gCPCES exact profile may only use complete units and one world ONEOF";
            return STATUS_BACKEND_ERROR;
        }
        if (stats.visible_worlds == 1) {
            if (stats.varying_atoms != 0 || stats.emitted_oneof_groups != 0) {
                if (message) *message =
                    "single gCPCES world was not simplified to complete unit assignments";
                return STATUS_BACKEND_ERROR;
            }
        } else if (stats.varying_atoms == 0 ||
                   stats.emitted_oneof_groups != 1) {
            if (message) *message =
                "multiple gCPCES worlds require exactly one ONEOF of complete conjunctions";
            return STATUS_BACKEND_ERROR;
        }
        const std::size_t init_pos = lowered_rendered.find("(:init");
        if (init_pos == std::string::npos) {
            if (message) *message = "gCPCES problem has no :init form";
            return STATUS_INPUT_ERROR;
        }
        std::size_t after_init = init_pos + 6;
        while (after_init < lowered_rendered.size() &&
               std::isspace(static_cast<unsigned char>(lowered_rendered[after_init])))
            ++after_init;
        if (after_init >= lowered_rendered.size() ||
            lowered_rendered.compare(after_init, 4, "(and") != 0) {
            if (message) *message = "gCPCES :init must use an outer AND";
            return STATUS_UNSUPPORTED_INPUT;
        }
    } else if (exact_gc_profile) {
        if (mode != RefinedProblemWriter::SINGLE_WORLD &&
            mode != RefinedProblemWriter::EXACT_SAMPLE_SET) {
            if (message) *message =
                "iGC/GC-LAMA renderer must use exact world/sample semantics";
            return STATUS_BACKEND_ERROR;
        }
        if (stats.emitted_unknown_atoms != 0 ||
            stats.emitted_or_groups != 0 ||
            stats.selector_atoms != 0 ||
            stats.selector_implications != 0) {
            if (message) *message =
                "iGC/GC-LAMA exact profile may only use closed-world units and one world ONEOF";
            return STATUS_BACKEND_ERROR;
        }
        if (stats.visible_worlds == 1) {
            if (stats.varying_atoms != 0 || stats.emitted_oneof_groups != 0) {
                if (message) *message =
                    "single iGC/GC-LAMA world was not simplified to a deterministic init";
                return STATUS_BACKEND_ERROR;
            }
        } else if (stats.varying_atoms == 0 ||
                   stats.emitted_oneof_groups != 1) {
            if (message) *message =
                "multiple iGC/GC-LAMA worlds require exactly one ONEOF of world conjunctions";
            return STATUS_BACKEND_ERROR;
        }
        const std::size_t init_pos = lowered_rendered.find("(:init");
        if (init_pos == std::string::npos) {
            if (message) *message = "iGC/GC-LAMA problem has no :init form";
            return STATUS_INPUT_ERROR;
        }
        std::size_t after_init = init_pos + 6;
        while (after_init < lowered_rendered.size() &&
               std::isspace(static_cast<unsigned char>(lowered_rendered[after_init])))
            ++after_init;
        if (after_init < lowered_rendered.size() &&
            lowered_rendered.compare(after_init, 4, "(and") == 0) {
            if (message) *message =
                "iGC/GC-LAMA :init must list formulas directly and must not use an outer AND";
            return STATUS_UNSUPPORTED_INPUT;
        }
    } else if (mode == RefinedProblemWriter::STRUCTURED_PRODUCT) {
        if (stats.visible_worlds == 1 &&
            (stats.varying_atoms != 0 || stats.emitted_oneof_groups != 0 ||
             stats.emitted_or_groups != 0)) {
            if (message) *message =
                "single T1 world was not fully simplified to a deterministic init";
            return STATUS_BACKEND_ERROR;
        }
    }

    for (std::size_t i = 0; i < store.states().size(); ++i) {
        const std::vector<int> &state = store.states()[i].sas_values;
        if (state.size() != ctx.variable_domains.size()) {
            if (message) *message = "counterexample dimension mismatch";
            return STATUS_INPUT_ERROR;
        }
        for (std::size_t v = 0; v < state.size(); ++v) {
            if (state[v] < 0 || state[v] >= ctx.variable_domains[v]) {
                if (message) *message = "counterexample value out of range";
                return STATUS_INPUT_ERROR;
            }
        }
        if (mode == RefinedProblemWriter::SINGLE_WORLD && i > 0) continue;
        const std::vector<ConstraintGroup> &groups = constraints.groups();
        for (std::size_t gi = 0; gi < groups.size(); ++gi) {
            int satisfied = 0;
            for (std::size_t ai = 0; ai < groups[gi].alternatives.size(); ++ai)
                if (InitialConstraintIR::alternative_holds(
                        groups[gi].alternatives[ai], state)) ++satisfied;
            if (groups[gi].kind == ConstraintGroup::GROUP_OR && satisfied < 1) {
                if (message) *message =
                    "historical counterexample violates original OR constraint";
                return STATUS_BACKEND_ERROR;
            }
            if (groups[gi].kind == ConstraintGroup::GROUP_ONEOF && satisfied != 1) {
                if (message) *message =
                    "historical counterexample violates original ONEOF constraint";
                return STATUS_BACKEND_ERROR;
            }
        }
    }
    if (message) {
        std::ostringstream ok;
        ok << "basic checks passed: visible_worlds=" << stats.visible_worlds
           << " mapped_atoms=" << stats.mapped_atoms
           << " fixed_true=" << stats.fixed_true_atoms
           << " fixed_false=" << stats.fixed_false_atoms
           << " varying=" << stats.varying_atoms
           << " unknown=" << stats.emitted_unknown_atoms
           << " oneof=" << stats.emitted_oneof_groups
           << " or=" << stats.emitted_or_groups;
        *message = ok.str();
    }
    return STATUS_OK;
}

static std::string shell_quote(const std::string &s) {
    std::string out = "'";
    for (std::size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '\'') out += "'\\''";
        else out += s[i];
    }
    out += "'";
    return out;
}

static bool readable_regular_file(const std::string &path) {
    struct stat st;
    return ::stat(path.c_str(), &st) == 0 && S_ISREG(st.st_mode) &&
           ::access(path.c_str(), R_OK) == 0;
}

static bool readable_directory(const std::string &path) {
    struct stat st;
    return ::stat(path.c_str(), &st) == 0 && S_ISDIR(st.st_mode) &&
           ::access(path.c_str(), R_OK | X_OK) == 0;
}

static bool stage_runtime_link(const std::string &target,
                               const std::string &link_path,
                               bool require_executable,
                               std::string *message) {
    if (!readable_regular_file(target)) {
        if (message) *message = std::string("missing or unreadable runtime file: ") + target;
        return false;
    }

    struct stat st;
    if (::lstat(link_path.c_str(), &st) == 0) {
        if (::unlink(link_path.c_str()) != 0) {
            if (message) *message = std::string("cannot replace runtime link ") +
                                    link_path + ": " + std::strerror(errno);
            return false;
        }
    } else if (errno != ENOENT) {
        if (message) *message = std::string("cannot inspect runtime link ") +
                                link_path + ": " + std::strerror(errno);
        return false;
    }

    if (!require_executable || executable_file(target)) {
        if (::symlink(target.c_str(), link_path.c_str()) != 0) {
            if (message) *message = std::string("cannot create runtime link ") +
                                    link_path + " -> " + target + ": " +
                                    std::strerror(errno);
            return false;
        }
        return true;
    }

    // Some ZIP tools discard executable permission bits.  Keep the original
    // planner directory read-only and stage a private executable copy.
    if (!copy_file(target, link_path) || ::chmod(link_path.c_str(), 0755) != 0) {
        if (message) *message = std::string("cannot stage executable copy from ") +
                                target + " to " + link_path;
        return false;
    }
    return executable_file(link_path);
}

static bool stage_runtime_directory_link(const std::string &target,
                                         const std::string &link_path,
                                         std::string *message) {
    if (!readable_directory(target)) {
        if (message) *message = std::string("missing or unreadable runtime directory: ") + target;
        return false;
    }
    struct stat st;
    if (::lstat(link_path.c_str(), &st) == 0) {
        if (S_ISLNK(st.st_mode)) {
            if (::unlink(link_path.c_str()) != 0) {
                if (message) *message = std::string("cannot replace runtime directory link ") +
                    link_path + ": " + std::strerror(errno);
                return false;
            }
        } else {
            if (message) *message = std::string("runtime directory path already exists: ") + link_path;
            return false;
        }
    } else if (errno != ENOENT) {
        if (message) *message = std::string("cannot inspect runtime directory link ") +
            link_path + ": " + std::strerror(errno);
        return false;
    }
    if (::symlink(target.c_str(), link_path.c_str()) != 0) {
        if (message) *message = std::string("cannot create runtime directory link ") +
            link_path + " -> " + target + ": " + std::strerror(errno);
        return false;
    }
    return true;
}

static StatusCode run_shell_command(const std::string &command,
                                    int timeout_seconds,
                                    const std::string &log_prefix,
                                    int *exit_code,
                                    int *term_signal) {
    if (exit_code) *exit_code = -1;
    if (term_signal) *term_signal = 0;
    const pid_t pid = ::fork();
    if (pid < 0) return STATUS_IO_ERROR;
    if (pid == 0) {
        ::setpgid(0, 0);
        ::execl("/bin/sh", "sh", "-c", command.c_str(),
                static_cast<char *>(0));
        _exit(127);
    }
    ::setpgid(pid, pid);
    const std::time_t start = std::time(0);
    int status = 0;
    while (true) {
        const pid_t w = ::waitpid(pid, &status, WNOHANG);
        if (w == pid) break;
        if (w < 0) return STATUS_IO_ERROR;
        if (std::time(0) - start >= timeout_seconds) {
            ::kill(-pid, SIGTERM);
            ::sleep(1);
            ::kill(-pid, SIGKILL);
            ::waitpid(pid, &status, 0);
            std::cout << log_prefix << " timeout after " << timeout_seconds
                      << " seconds" << std::endl;
            return STATUS_PLANNER_TIMEOUT;
        }
        ::usleep(100000);
    }
    if (WIFSIGNALED(status)) {
        if (term_signal) *term_signal = WTERMSIG(status);
        return STATUS_PLANNER_FAILED;
    }
    if (!WIFEXITED(status)) return STATUS_PLANNER_FAILED;
    if (exit_code) *exit_code = WEXITSTATUS(status);
    return WEXITSTATUS(status) == 0 ? STATUS_OK : STATUS_PLANNER_FAILED;
}

static bool contains_no_plan_marker(const std::string &text) {
    const std::string low = lower_ascii(text);
    return low.find("no plan was found") != std::string::npos ||
           low.find("no plan found") != std::string::npos ||
           low.find("problem has no solution") != std::string::npos ||
           low.find("problem is unsolvable") != std::string::npos ||
           low.find("no plan will solve it") != std::string::npos ||
           low.find("problem proven unsolvable") != std::string::npos ||
           low.find("best first search space empty") != std::string::npos;
}

static bool contains_cpa_success_marker(const std::string &text) {
    return lower_ascii(text).find("found a plan") != std::string::npos;
}

static bool parse_nonnegative_after(const std::string &text,
                                    const std::string &marker,
                                    std::size_t start,
                                    int *value) {
    const std::string low = lower_ascii(text);
    const std::string marker_low = lower_ascii(marker);
    const std::size_t pos = low.find(marker_low, start);
    if (pos == std::string::npos) return false;
    std::size_t i = pos + marker_low.size();
    while (i < text.size() && !std::isdigit(static_cast<unsigned char>(text[i]))) ++i;
    if (i == text.size()) return false;
    long n = 0;
    while (i < text.size() && std::isdigit(static_cast<unsigned char>(text[i]))) {
        n = n * 10 + (text[i] - '0');
        if (n > INT_MAX) return false;
        ++i;
    }
    if (value) *value = static_cast<int>(n);
    return true;
}

static std::string strip_cpa_prefix(const std::string &symbol) {
    std::string s = trim(symbol);
    if (s.size() >= 4 && lower_ascii(s.substr(0, 4)) == "cpa_")
        s = s.substr(4);
    return s;
}

static bool normalize_cpa_action_token(const std::string &token,
                                       std::string *body) {
    std::string x = trim(token);
    if (x.empty()) return false;
    if (x[0] == '"' && x.size() >= 2 && x[x.size() - 1] == '"')
        x = x.substr(1, x.size() - 2);
    x = trim(x);
    const std::size_t open = x.find('(');
    if (open == std::string::npos) {
        *body = strip_cpa_prefix(x);
        return !body->empty();
    }
    const std::size_t close = x.rfind(')');
    if (close == std::string::npos || close < open) return false;
    const std::string name = strip_cpa_prefix(x.substr(0, open));
    if (name.empty()) return false;
    std::ostringstream out;
    out << name;
    const std::string args = x.substr(open + 1, close - open - 1);
    std::size_t begin = 0;
    while (begin <= args.size()) {
        const std::size_t comma = args.find(',', begin);
        const std::string raw = args.substr(begin,
            comma == std::string::npos ? std::string::npos : comma - begin);
        const std::string arg = strip_cpa_prefix(raw);
        if (!arg.empty()) out << ' ' << arg;
        if (comma == std::string::npos) break;
        begin = comma + 1;
    }
    *body = collapse_ws(out.str());
    return !body->empty();
}

static void extract_quoted_strings(const std::string &text,
                                   std::vector<std::string> *items) {
    items->clear();
    bool in_quote = false;
    bool escape = false;
    std::ostringstream current;
    for (std::size_t i = 0; i < text.size(); ++i) {
        const char c = text[i];
        if (!in_quote) {
            if (c == '"') {
                in_quote = true;
                escape = false;
                current.str(std::string());
                current.clear();
            }
            continue;
        }
        if (escape) {
            current << c;
            escape = false;
        } else if (c == '\\') {
            escape = true;
        } else if (c == '"') {
            items->push_back(current.str());
            in_quote = false;
        } else {
            current << c;
        }
    }
}

// Some CPA-family builds print actions without double quotes, e.g.
//   put_down(a) pick_up(b) stack(b,a)
// Keep this fallback strictly inside the plan section so that statistics and
// diagnostic function-like text cannot be mistaken for actions.
static void extract_unquoted_action_tokens(const std::string &text,
                                           std::vector<std::string> *items) {
    items->clear();
    bool in_quote = false;
    for (std::size_t i = 0; i < text.size();) {
        const char c = text[i];
        if (c == '"') {
            in_quote = !in_quote;
            ++i;
            continue;
        }
        if (in_quote) {
            ++i;
            continue;
        }
        const unsigned char uc = static_cast<unsigned char>(c);
        if (!(std::isalpha(uc) || c == '_')) {
            ++i;
            continue;
        }

        const std::size_t name_begin = i;
        while (i < text.size()) {
            const unsigned char x = static_cast<unsigned char>(text[i]);
            if (!(std::isalnum(x) || text[i] == '_' || text[i] == '-')) break;
            ++i;
        }
        std::size_t open = i;
        while (open < text.size() &&
               std::isspace(static_cast<unsigned char>(text[open]))) ++open;
        if (open >= text.size() || text[open] != '(') continue;

        int depth = 0;
        std::size_t close = std::string::npos;
        for (std::size_t j = open; j < text.size(); ++j) {
            if (text[j] == '(') ++depth;
            else if (text[j] == ')') {
                --depth;
                if (depth == 0) {
                    close = j;
                    break;
                }
            }
        }
        if (close == std::string::npos) break;
        items->push_back(text.substr(name_begin, close - name_begin + 1));
        i = close + 1;
    }
}

static StatusCode extract_cpa_plan_actions(const std::string &text,
                                           std::vector<std::string> *actions,
                                           std::string *error) {
    actions->clear();
    const std::string low = lower_ascii(text);
    if (contains_no_plan_marker(text)) {
        if (error) *error = "candidate planner reported that no plan was found";
        return STATUS_PLANNER_NO_PLAN;
    }
    const std::size_t found = low.find("found a plan");
    if (found == std::string::npos) {
        if (error) *error = "candidate output has no 'Found a plan' marker";
        return STATUS_PLANNER_PARSE_ERROR;
    }

    int declared_length = -1;
    parse_nonnegative_after(text, "found a plan of length", found, &declared_length);
    if (declared_length < 0)
        parse_nonnegative_after(text, "length:", found, &declared_length);
    if (declared_length < 0)
        parse_nonnegative_after(text, "size of solution:", found, &declared_length);

    std::size_t end = text.size();
    const std::size_t statistics = low.find("statistics", found);
    if (statistics != std::string::npos) end = std::min(end, statistics);
    const std::size_t length_line = low.find("length:", found);
    if (length_line != std::string::npos) end = std::min(end, length_line);
    const std::string plan_section = text.substr(found, end - found);

    std::vector<std::string> quoted;
    extract_quoted_strings(plan_section, &quoted);
    std::vector<std::string> tokens = quoted;
    if (tokens.empty())
        extract_unquoted_action_tokens(plan_section, &tokens);
    for (std::size_t i = 0; i < tokens.size(); ++i) {
        std::string normalized;
        if (!normalize_cpa_action_token(tokens[i], &normalized)) {
            if (error) *error = std::string("cannot parse action token: ") + tokens[i];
            return STATUS_PLANNER_PARSE_ERROR;
        }
        actions->push_back(normalized);
    }

    if (declared_length == 0 && actions->empty()) return STATUS_OK;
    if (actions->empty()) {
        if (error) *error = "planner reported a non-empty plan but omitted the action sequence";
        return STATUS_PLANNER_PARSE_ERROR;
    }
    if (declared_length >= 0 && declared_length != static_cast<int>(actions->size())) {
        if (error) {
            std::ostringstream msg;
            msg << "declared plan length " << declared_length
                << " differs from parsed action count " << actions->size();
            *error = msg.str();
        }
        return STATUS_PLANNER_PARSE_ERROR;
    }
    return STATUS_OK;
}


static bool parse_leading_nonnegative(const std::string &text,
                                      int *value,
                                      std::size_t *after) {
    std::size_t i = 0;
    while (i < text.size() &&
           std::isspace(static_cast<unsigned char>(text[i]))) ++i;
    if (i == text.size() ||
        !std::isdigit(static_cast<unsigned char>(text[i]))) return false;
    long n = 0;
    while (i < text.size() &&
           std::isdigit(static_cast<unsigned char>(text[i]))) {
        n = n * 10 + (text[i] - '0');
        if (n > INT_MAX) return false;
        ++i;
    }
    if (value) *value = static_cast<int>(n);
    if (after) *after = i;
    return true;
}

// CPA(H) does not use the CNF/DNF/PIP "Found a plan" format. Its
// plan-result contains two different objects:
//
//   <catalog-size> action_0 action_1 ... action_(N-1)
//   %%
//   linear <plan-length> index_0 index_1 ... index_(L-1)
//
// The first list is an action catalogue used by the following linear trace;
// it is NOT necessarily the executable plan because the trace may repeat
// catalogue entries.  The candidate plan sent to iGC must therefore be the
// expansion action[index_0], ..., action[index_(L-1)].
static bool parse_cpah_linear_trace(const std::string &text,
                                    std::size_t start,
                                    const std::vector<std::string> &catalog,
                                    std::vector<std::string> *expanded,
                                    std::string *error,
                                    bool *found) {
    expanded->clear();
    if (found) *found = false;

    std::size_t pos = start;
    while (pos < text.size()) {
        std::size_t line_end = text.find('\n', pos);
        if (line_end == std::string::npos) line_end = text.size();
        const std::string line = trim(text.substr(pos, line_end - pos));
        pos = line_end == text.size() ? text.size() : line_end + 1;
        if (line.empty()) continue;

        if (line == "STATISTICS" || line.find("%%") == 0) return true;

        std::istringstream in(line);
        std::string marker;
        in >> marker;
        if (marker != "linear") continue;
        if (found) *found = true;

        long declared_length = -1;
        if (!(in >> declared_length) || declared_length < 0 ||
            declared_length > INT_MAX) {
            if (error) *error = "CPA(H) linear trace has an invalid length";
            return false;
        }

        std::vector<int> indices;
        int index = -1;
        while (in >> index) indices.push_back(index);
        if (!in.eof()) {
            if (error) *error =
                "CPA(H) linear trace contains a non-integer action index";
            return false;
        }
        if (declared_length != static_cast<long>(indices.size())) {
            if (error) {
                std::ostringstream msg;
                msg << "CPA(H) linear trace declares length "
                    << declared_length << " but contains "
                    << indices.size() << " indices";
                *error = msg.str();
            }
            return false;
        }

        expanded->reserve(indices.size());
        for (std::size_t i = 0; i < indices.size(); ++i) {
            if (indices[i] < 0 ||
                indices[i] >= static_cast<int>(catalog.size())) {
                if (error) {
                    std::ostringstream msg;
                    msg << "CPA(H) linear trace index " << indices[i]
                        << " is outside action catalogue [0,"
                        << catalog.size() << ")";
                    *error = msg.str();
                }
                expanded->clear();
                return false;
            }
            expanded->push_back(catalog[indices[i]]);
        }
        return true;
    }
    return true;
}

static StatusCode extract_cpah_plan_actions(const std::string &text,
                                            std::vector<std::string> *actions,
                                            std::string *error) {
    actions->clear();
    if (error) error->clear();

    // A theory_names file may contain more than one generated theory. Some
    // CPA(H) builds print a failure line for one theory and a delimited plan
    // block for another. Prefer any complete, internally consistent block.
    std::size_t cursor = 0;
    std::string last_error = "CPA(H) output contains no complete %% plan block";
    while (true) {
        const std::size_t begin = text.find("%%", cursor);
        if (begin == std::string::npos) break;
        const std::size_t end = text.find("%%", begin + 2);
        if (end == std::string::npos) break;
        const std::string block = trim(text.substr(begin + 2, end - begin - 2));
        cursor = end + 2;

        int catalog_size = -1;
        std::size_t body_start = 0;
        if (!parse_leading_nonnegative(block, &catalog_size, &body_start)) {
            last_error =
                "CPA(H) plan block does not start with a non-negative action catalogue size";
            continue;
        }
        const std::string body = block.substr(body_start);
        std::vector<std::string> tokens;
        extract_quoted_strings(body, &tokens);
        if (tokens.empty()) extract_unquoted_action_tokens(body, &tokens);

        std::vector<std::string> catalog;
        bool token_error = false;
        for (std::size_t i = 0; i < tokens.size(); ++i) {
            std::string normalized;
            if (!normalize_cpa_action_token(tokens[i], &normalized)) {
                token_error = true;
                last_error = std::string("cannot parse CPA(H) action token: ") +
                             tokens[i];
                break;
            }
            catalog.push_back(normalized);
        }
        if (token_error) continue;
        if (catalog_size != static_cast<int>(catalog.size())) {
            std::ostringstream msg;
            msg << "CPA(H) declared action catalogue size " << catalog_size
                << " but printed " << catalog.size() << " catalogue actions";
            last_error = msg.str();
            continue;
        }

        std::vector<std::string> expanded;
        std::string trace_error;
        bool linear_found = false;
        if (!parse_cpah_linear_trace(text, end + 2, catalog, &expanded,
                                     &trace_error, &linear_found)) {
            last_error = trace_error;
            continue;
        }
        if (!linear_found) {
            last_error =
                "CPA(H) plan block is missing the required linear action-index trace";
            continue;
        }
        if (expanded.empty()) {
            if (catalog_size == 0) {
                actions->clear();
                return STATUS_OK;
            }
            last_error =
                "CPA(H) printed a non-empty action catalogue but an empty linear plan";
            continue;
        }

        *actions = expanded;
        return STATUS_OK;
    }
    if (contains_no_plan_marker(text)) {
        if (error) *error = "CPA(H) reported that no plan was found";
        return STATUS_PLANNER_NO_PLAN;
    }
    if (error) *error = last_error;
    return STATUS_PLANNER_PARSE_ERROR;
}

static bool normalize_plain_action_line(const std::string &line,
                                        std::string *action) {
    std::string body = trim(line);
    if (body.empty()) return false;
    if (body[0] == ';' || body[0] == '#') return false;
    if (body == "%%" || body.find("linear ") == 0) return false;
    bool all_digits = true;
    for (std::size_t i = 0; i < body.size(); ++i) {
        if (!std::isdigit(static_cast<unsigned char>(body[i])) &&
            !std::isspace(static_cast<unsigned char>(body[i]))) {
            all_digits = false;
            break;
        }
    }
    if (all_digits) return false;
    if (body.size() >= 2 && body[0] == '(' && body[body.size() - 1] == ')')
        body = trim(body.substr(1, body.size() - 2));
    if (body.empty()) return false;
    *action = body;
    return true;
}


static bool parse_cff_step_line(const std::string &line,
                                int expected_step,
                                std::string *action,
                                std::string *error) {
    std::string t = trim(line);
    if (t.empty()) return false;

    const std::string low = lower_ascii(t);
    if (low.find("step") == 0) t = trim(t.substr(4));

    const std::size_t colon = t.find(':');
    if (colon == std::string::npos) return false;

    const std::string index_text = trim(t.substr(0, colon));
    if (index_text.empty()) return false;
    for (std::size_t i = 0; i < index_text.size(); ++i)
        if (!std::isdigit(static_cast<unsigned char>(index_text[i])))
            return false;

    std::istringstream index_stream(index_text);
    int parsed_step = -1;
    index_stream >> parsed_step;
    if (!index_stream || parsed_step < 0) return false;
    if (parsed_step != expected_step) {
        if (error) {
            std::ostringstream msg;
            msg << "CFF plan step index " << parsed_step
                << " differs from expected index " << expected_step;
            *error = msg.str();
        }
        return false;
    }

    const std::string body = collapse_ws(trim(t.substr(colon + 1)));
    if (body.empty()) {
        if (error) *error = "CFF plan step contains no action";
        return false;
    }
    if (action) *action = body;
    return true;
}

static StatusCode extract_cff_console_plan_actions(
        const std::string &text,
        std::vector<std::string> *actions,
        std::string *error) {
    actions->clear();
    if (error) error->clear();

    const std::string low = lower_ascii(text);
    const std::string marker = "ff: found legal plan as follows";
    const std::string empty_marker =
        "goal can be simplified to true. the empty plan solves it";
    const std::string no_plan_markers[] = {
        "goal can be simplified to false. no plan will solve it",
        "best first search space empty! problem proven unsolvable.",
        "problem proven unsolvable"
    };

    const std::size_t start_marker = low.rfind(marker);
    const std::size_t empty_pos = low.rfind(empty_marker);
    std::size_t no_plan_pos = std::string::npos;
    for (std::size_t i = 0;
         i < sizeof(no_plan_markers)/sizeof(no_plan_markers[0]); ++i) {
        const std::size_t pos = low.rfind(no_plan_markers[i]);
        if (pos != std::string::npos &&
            (no_plan_pos == std::string::npos || pos > no_plan_pos))
            no_plan_pos = pos;
    }

    // Choose the last concrete CFF outcome marker. This also keeps parser
    // tests robust when an outer benchmark log prints the marker strings in
    // its metadata before appending the real raw CFF console.
    if (empty_pos != std::string::npos &&
        (start_marker == std::string::npos || empty_pos > start_marker) &&
        (no_plan_pos == std::string::npos || empty_pos > no_plan_pos))
        return STATUS_OK;
    if (no_plan_pos != std::string::npos &&
        (start_marker == std::string::npos || no_plan_pos > start_marker) &&
        (empty_pos == std::string::npos || no_plan_pos > empty_pos)) {
        if (error) *error = "CFF reported that no plan was found";
        return STATUS_PLANNER_NO_PLAN;
    }
    if (start_marker == std::string::npos) {
        if (contains_no_plan_marker(text)) {
            if (error) *error = "CFF reported that no plan was found";
            return STATUS_PLANNER_NO_PLAN;
        }
        if (error) *error =
            "CFF console contains neither a legal-plan marker nor an empty-plan marker";
        return STATUS_PLANNER_PARSE_ERROR;
    }

    const std::size_t start = start_marker + marker.size();
    std::size_t end = low.find("\nstatistics:", start);
    if (end == std::string::npos)
        end = low.find("\r\nstatistics:", start);
    if (end == std::string::npos) end = text.size();

    std::istringstream in(text.substr(start, end - start));
    std::string line;
    int expected_step = 0;
    while (std::getline(in, line)) {
        const std::string t = trim(line);
        if (t.empty()) continue;

        std::string action;
        std::string line_error;
        if (parse_cff_step_line(line, expected_step, &action, &line_error)) {
            actions->push_back(action);
            ++expected_step;
            continue;
        }
        if (!line_error.empty()) {
            if (error) *error = line_error;
            actions->clear();
            return STATUS_PLANNER_PARSE_ERROR;
        }
    }

    if (actions->empty()) {
        if (error) *error =
            "CFF legal-plan section contains no parseable step lines";
        return STATUS_PLANNER_PARSE_ERROR;
    }
    return STATUS_OK;
}

static StatusCode extract_plain_plan_actions(const std::string &text,
                                             std::vector<std::string> *actions,
                                             std::string *error) {
    actions->clear();
    if (error) error->clear();
    std::istringstream in(text);
    std::string line;
    bool empty_marker = false;
    while (std::getline(in, line)) {
        const std::string low = lower_ascii(trim(line));
        if (low == ";; empty plan" || low == "empty plan") {
            empty_marker = true;
            continue;
        }
        std::string action;
        if (normalize_plain_action_line(line, &action))
            actions->push_back(action);
    }
    if (!actions->empty() || empty_marker) return STATUS_OK;
    if (contains_no_plan_marker(text)) {
        if (error) *error = "planner reported that no plan was found";
        return STATUS_PLANNER_NO_PLAN;
    }
    if (error) *error = "plain plan artifact contains no parseable actions";
    return STATUS_PLANNER_PARSE_ERROR;
}

static StatusCode extract_gc_console_plan_actions(const std::string &text,
                                                  CandidatePlannerKind kind,
                                                  std::vector<std::string> *actions,
                                                  std::string *error) {
    actions->clear();
    if (error) error->clear();
    const std::string low = lower_ascii(text);
    std::size_t start = std::string::npos;
    if (kind == CANDIDATE_PLANNER_GC_LAMA) {
        start = low.rfind("\nfinal plan\n");
        if (start != std::string::npos) start += std::strlen("\nfinal plan\n");
    } else {
        const std::string marker = "没有反例，找到最终解！";
        start = text.rfind(marker);
        if (start != std::string::npos) start += marker.size();
    }
    if (start == std::string::npos) {
        if (contains_no_plan_marker(text)) return STATUS_PLANNER_NO_PLAN;
        if (error) *error = "console output contains no final-plan marker";
        return STATUS_PLANNER_PARSE_ERROR;
    }

    std::istringstream in(text.substr(start));
    std::string line;
    while (std::getline(in, line)) {
        const std::string trimmed = trim(line);
        const std::string lower = lower_ascii(trimmed);
        if (trimmed.empty()) continue;
        if (lower.find("total time:") == 0 ||
            lower.find("final plan:") == 0 ||
            trimmed.find("不能移动:") == 0 ||
            trimmed.find("是否找到landmark:") == 0 ||
            trimmed.find("最终反例集大小:") == 0)
            break;
        std::string action;
        if (normalize_plain_action_line(trimmed, &action))
            actions->push_back(action);
    }
    if (!actions->empty()) return STATUS_OK;
    if (error) *error = "final-plan section contains no parseable actions";
    return STATUS_PLANNER_PARSE_ERROR;
}

static bool parse_nonnegative_after_prefix(const std::string &line,
                                           const std::string &prefix,
                                           int *value) {
    const std::string t = trim(line);
    if (lower_ascii(t).find(lower_ascii(prefix)) != 0) return false;
    std::string rest = trim(t.substr(prefix.size()));
    if (!rest.empty() && rest[0] == ':') rest = trim(rest.substr(1));
    if (rest.empty()) return false;
    std::istringstream in(rest);
    int parsed = -1;
    in >> parsed;
    if (!in || parsed < 0) return false;
    if (value) *value = parsed;
    return true;
}

static StatusCode extract_gcpces_console_plan_actions(
        const std::string &text,
        std::vector<std::string> *actions,
        std::string *error) {
    actions->clear();
    if (error) error->clear();
    const std::string low = lower_ascii(text);
    const std::size_t pi_pos = low.rfind("|pi|:");
    if (pi_pos == std::string::npos) {
        if (low.find("unsolvable") != std::string::npos ||
            contains_no_plan_marker(text)) return STATUS_PLANNER_NO_PLAN;
        if (error) *error = "gCPCES console contains no |pi| plan-length marker";
        return STATUS_PLANNER_PARSE_ERROR;
    }
    std::size_t line_start = text.rfind('\n', pi_pos);
    line_start = line_start == std::string::npos ? 0 : line_start + 1;
    std::size_t line_end = text.find('\n', pi_pos);
    if (line_end == std::string::npos) line_end = text.size();
    int declared = -1;
    if (!parse_nonnegative_after_prefix(text.substr(line_start, line_end-line_start),
                                        "|pi|", &declared)) {
        if (error) *error = "cannot parse gCPCES |pi| length";
        return STATUS_PLANNER_PARSE_ERROR;
    }

    std::size_t section_start = low.rfind("iteration:", pi_pos);
    if (section_start == std::string::npos) section_start = 0;
    std::istringstream in(text.substr(section_start, pi_pos - section_start));
    std::string line;
    while (std::getline(in, line)) {
        const std::string marker = " Parameters:";
        const std::size_t pos = line.find(marker);
        if (pos == std::string::npos) continue;
        const std::string name = trim(line.substr(0, pos));
        if (name.empty()) continue;
        std::istringstream args(line.substr(pos + marker.size()));
        std::vector<std::string> tokens;
        std::string token;
        while (args >> token) tokens.push_back(token);
        std::ostringstream action;
        action << name;
        for (std::size_t i = 1; i < tokens.size(); ++i) {
            if (tokens[i] == "-" && !tokens[i-1].empty())
                action << ' ' << tokens[i-1];
        }
        actions->push_back(collapse_ws(action.str()));
    }
    if (declared != static_cast<int>(actions->size())) {
        std::ostringstream msg;
        msg << "gCPCES declared plan length " << declared
            << " but printed " << actions->size() << " action lines";
        if (error) *error = msg.str();
        actions->clear();
        return STATUS_PLANNER_PARSE_ERROR;
    }
    return STATUS_OK;
}

static void extract_python_quoted_strings(const std::string &text,
                                          std::vector<std::string> *items) {
    items->clear();
    char quote = 0;
    bool escape = false;
    std::ostringstream current;
    for (std::size_t i = 0; i < text.size(); ++i) {
        const char c = text[i];
        if (quote == 0) {
            if (c == '\'' || c == '"') {
                quote = c;
                escape = false;
                current.str(std::string());
                current.clear();
            }
            continue;
        }
        if (escape) {
            current << c;
            escape = false;
        } else if (c == '\\') {
            escape = true;
        } else if (c == quote) {
            items->push_back(current.str());
            quote = 0;
        } else {
            current << c;
        }
    }
}

static StatusCode extract_icpces_console_plan_actions(
        const std::string &text,
        std::vector<std::string> *actions,
        std::string *error) {
    actions->clear();
    if (error) error->clear();
    const std::string low = lower_ascii(text);
    const std::size_t marker = low.rfind("find a valid plan");
    if (marker == std::string::npos) {
        if (low.find("no solution") != std::string::npos ||
            low.find("search stopped without finding a solution") != std::string::npos ||
            contains_no_plan_marker(text)) return STATUS_PLANNER_NO_PLAN;
        if (error) *error = "iCPCES console contains no final valid-plan marker";
        return STATUS_PLANNER_PARSE_ERROR;
    }
    const std::size_t length_pos = low.find("plan length:", marker);
    if (length_pos == std::string::npos) {
        if (error) *error = "iCPCES final-plan section contains no plan length";
        return STATUS_PLANNER_PARSE_ERROR;
    }
    std::size_t length_end = text.find('\n', length_pos);
    if (length_end == std::string::npos) length_end = text.size();
    int declared = -1;
    if (!parse_nonnegative_after_prefix(
            text.substr(length_pos, length_end-length_pos),
            "plan length", &declared)) {
        if (error) *error = "cannot parse iCPCES plan length";
        return STATUS_PLANNER_PARSE_ERROR;
    }
    std::vector<std::string> quoted;
    extract_python_quoted_strings(
        text.substr(marker + std::strlen("find a valid plan"),
                    length_pos - (marker + std::strlen("find a valid plan"))),
        &quoted);
    for (std::size_t i = 0; i < quoted.size(); ++i) {
        const std::string action = collapse_ws(trim(quoted[i]));
        if (!action.empty()) actions->push_back(action);
    }
    if (declared != static_cast<int>(actions->size())) {
        std::ostringstream msg;
        msg << "iCPCES declared plan length " << declared
            << " but printed " << actions->size() << " actions";
        if (error) *error = msg.str();
        actions->clear();
        return STATUS_PLANNER_PARSE_ERROR;
    }
    return STATUS_OK;
}

static bool write_plain_plan_artifact(const std::vector<std::string> &actions,
                                      const std::string &path) {
    std::ostringstream out;
    if (actions.empty()) out << ";; empty plan\n";
    else
        for (std::size_t i = 0; i < actions.size(); ++i)
            out << actions[i] << '\n';
    return write_file_atomic(path, out.str());
}

class CandidatePlannerRunner {
public:
    explicit CandidatePlannerRunner(CandidatePlannerKind kind) : kind_(kind) {}

    CandidatePlannerKind kind() const { return kind_; }

    StatusCode run(const std::string &domain,
                   const std::string &problem,
                   const std::string &iter_dir,
                   int timeout_seconds,
                   std::string *result_path) const {
        if (kind_ == CANDIDATE_PLANNER_T1)
            return run_t1(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_CFF)
            return run_cff(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_CPAH)
            return run_cpah(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_IGC_ORIGIN ||
            kind_ == CANDIDATE_PLANNER_GC_LAMA)
            return run_gc_family(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_GCPCES)
            return run_gcpces(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_ICPCES)
            return run_icpces(domain, problem, iter_dir, timeout_seconds, result_path);
        return run_cpa_family(domain, problem, iter_dir, timeout_seconds, result_path);
    }

private:
    static void print_common_diagnostics(const std::string &prefix,
                                         const std::string &stdout_path,
                                         const std::string &stderr_path,
                                         const std::string &extra_path) {
        const std::string planner_err = one_line_excerpt(stderr_path, 700);
        const std::string planner_out = one_line_excerpt(stdout_path, 900);
        const std::string extra = one_line_excerpt(extra_path, 700);
        if (!planner_err.empty())
            std::cout << prefix << " planner.stderr: " << planner_err << std::endl;
        if (!extra.empty())
            std::cout << prefix << " diagnostic: " << extra << std::endl;
        if (!planner_out.empty())
            std::cout << prefix << " planner.stdout: " << planner_out << std::endl;
    }

    StatusCode run_t1(const std::string &domain,
                      const std::string &problem,
                      const std::string &iter_dir,
                      int timeout_seconds,
                      std::string *result_path) const {
        const std::string planner_result = iter_dir + "/planner.result";
        const std::string mock = getenv_string("IGC_T1_MOCK_RESULT", "");
        if (!mock.empty()) {
            std::cout << "[T1-RUNNER] mock mode; copying " << mock << std::endl;
            if (!copy_file(mock, planner_result)) return STATUS_IO_ERROR;
            if (result_path) *result_path = planner_result;
            return STATUS_OK;
        }

        const std::string exec_abs = absolute_path(getenv_string("IGC_T1_EXEC", "./T1/t1"));
        if (!executable_file(exec_abs)) {
            std::cout << "[T1-RUNNER] executable is missing or not executable: "
                      << exec_abs << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        if (env_true("IGC_T1_PREPARE_RUNTIME", true)) {
            std::string runtime_message;
            if (!prepare_t1_runtime(exec_abs, iter_dir, &runtime_message)) {
                std::cout << "[T1-RUNNER] runtime preparation failed: "
                          << runtime_message << std::endl;
                return STATUS_PLANNER_FAILED;
            }
            std::cout << "[T1-RUNNER] runtime=" << runtime_message << std::endl;
        }

        const std::string args = getenv_string(
            "IGC_T1_ARGS", "-p -x -S dqbfs -f 10 -X count -W 1");
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        ::unlink(planner_result.c_str());
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink((iter_dir + "/c2d.stdout").c_str());
        ::unlink((iter_dir + "/c2d.stderr").c_str());
        ::unlink((iter_dir + "/inp.cnf.nnf").c_str());

        std::ostringstream command;
        command << "cd " << shell_quote(iter_dir) << " && "
                << shell_quote(exec_abs) << ' ' << args
                << " -d " << shell_quote(absolute_path(domain))
                << " -i " << shell_quote(absolute_path(problem))
                << " > " << shell_quote(absolute_path(stdout_path))
                << " 2> " << shell_quote(absolute_path(stderr_path));
        std::cout << "[T1-RUNNER] command=" << command.str() << std::endl;

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(command.str(), timeout_seconds,
                                          "[T1-RUNNER]", &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal)
                std::cout << "[T1-RUNNER] process terminated by signal=" << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << "[T1-RUNNER] process exit_code=" << exit_code << std::endl;
            print_common_diagnostics("[T1-RUNNER]", stdout_path, stderr_path,
                                     iter_dir + "/c2d.stderr");
            return st;
        }

        const std::string c2d_error = one_line_excerpt(iter_dir + "/c2d.stderr", 500);
        const std::string c2d_error_low = lower_ascii(c2d_error);
        if (!c2d_error.empty() &&
            (c2d_error_low.find("error doing execv") != std::string::npos ||
             c2d_error_low.find("check path to compiler") != std::string::npos ||
             c2d_error_low.find("permission denied") != std::string::npos ||
             c2d_error_low.find("not found") != std::string::npos)) {
            std::cout << "[T1-RUNNER] d-DNNF compiler failure: "
                      << c2d_error << std::endl;
            print_common_diagnostics("[T1-RUNNER]", stdout_path, stderr_path,
                                     iter_dir + "/c2d.stderr");
            return STATUS_PLANNER_FAILED;
        }

        std::string result_text;
        if (!read_file(planner_result, &result_text) || result_text.empty()) {
            std::cout << "[T1-RUNNER] planner.result is missing or empty" << std::endl;
            print_common_diagnostics("[T1-RUNNER]", stdout_path, stderr_path,
                                     iter_dir + "/c2d.stderr");
            return STATUS_PLANNER_PARSE_ERROR;
        }
        if (contains_no_plan_marker(result_text)) return STATUS_PLANNER_NO_PLAN;
        if (result_path) *result_path = planner_result;
        return STATUS_OK;
    }


    std::string cff_runtime_root() const {
        const std::string configured = trim(getenv_string("IGC_CFF_DIR", ""));
        if (!configured.empty()) return absolute_path(configured);
        const char *candidates[] = {
            "./conformant-ff", "./Conformant-FF", "./CFF", "./cff"
        };
        for (std::size_t i = 0; i < sizeof(candidates)/sizeof(candidates[0]); ++i) {
            const std::string root = absolute_path(candidates[i]);
            if (readable_directory(root) && executable_file(root + "/ff"))
                return root;
        }
        return absolute_path("./conformant-ff");
    }

    StatusCode run_cff(const std::string &domain,
                       const std::string &problem,
                       const std::string &iter_dir,
                       int timeout_seconds,
                       std::string *result_path) const {
        const std::string prefix = "[CFF-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string mock = getenv_string("IGC_CFF_MOCK_OUTPUT", "");

        std::string output_text;
        if (!mock.empty()) {
            std::cout << prefix << " mock mode; copying " << mock << std::endl;
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            if (!read_file(stdout_path, &output_text)) return STATUS_IO_ERROR;
        } else {
            const std::string root = cff_runtime_root();
            const std::string configured_exec =
                trim(getenv_string("IGC_CFF_EXEC", ""));
            const std::string exec_abs = configured_exec.empty()
                ? root + "/ff" : absolute_path(configured_exec);
            if (!executable_file(exec_abs)) {
                std::cout << prefix
                          << " executable is missing or not executable: "
                          << exec_abs << std::endl;
                return STATUS_PLANNER_FAILED;
            }

            const std::string args = trim(getenv_string("IGC_CFF_ARGS", ""));
            ::unlink(stdout_path.c_str());
            ::unlink(stderr_path.c_str());
            ::unlink(stable.c_str());

            std::ostringstream command;
            command << "cd " << shell_quote(iter_dir) << " && "
                    << shell_quote(exec_abs);
            if (!args.empty()) command << ' ' << args;
            command << " -o " << shell_quote(absolute_path(domain))
                    << " -f " << shell_quote(absolute_path(problem))
                    << " > " << shell_quote(absolute_path(stdout_path))
                    << " 2> " << shell_quote(absolute_path(stderr_path));
            write_file_atomic(iter_dir + "/planner.command",
                              command.str() + "\n");
            std::cout << prefix << " runtime=" << root << std::endl;
            std::cout << prefix << " command=" << command.str() << std::endl;

            int exit_code = -1;
            int term_signal = 0;
            StatusCode run_status = run_shell_command(
                command.str(), timeout_seconds, prefix,
                &exit_code, &term_signal);
            if (!read_file(stdout_path, &output_text))
                output_text.clear();
            if (run_status != STATUS_OK) {
                // CFF exits with status 1 for both the proven empty-plan case
                // and the proven no-plan case.  Its console outcome is the
                // authoritative contract, not the raw process exit code.
                std::vector<std::string> probe_actions;
                std::string probe_error;
                const StatusCode probe_status =
                    extract_cff_console_plan_actions(
                        output_text, &probe_actions, &probe_error);
                if (probe_status == STATUS_PLANNER_NO_PLAN)
                    return STATUS_PLANNER_NO_PLAN;
                if (probe_status != STATUS_OK) {
                    if (term_signal > 0)
                        std::cout << prefix << " signal=" << term_signal << std::endl;
                    else if (exit_code >= 0)
                        std::cout << prefix << " exit_code=" << exit_code << std::endl;
                    print_common_diagnostics(prefix, stdout_path, stderr_path, "");
                    return run_status;
                }
                std::cout << prefix
                          << " accepted CFF console outcome despite process exit_code="
                          << exit_code << std::endl;
            }
        }

        std::vector<std::string> actions;
        std::string parse_error;
        const StatusCode parsed = extract_cff_console_plan_actions(
            output_text, &actions, &parse_error);
        if (parsed != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: "
                      << parse_error << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path, "");
            return parsed;
        }
        if (!write_plain_plan_artifact(actions, stable))
            return STATUS_IO_ERROR;

        std::ostringstream source;
        source << "{\"primary_planner\":\"CFF\""
               << ",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"artifact\":\"planner.stdout\""
               << ",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    std::string gc_family_runtime_root() const {
        const bool igc = kind_ == CANDIDATE_PLANNER_IGC_ORIGIN;
        const char *env_name = igc ? "IGC_IGC_DIR" : "IGC_GC_LAMA_DIR";
        const std::string configured = trim(getenv_string(env_name, ""));
        if (!configured.empty()) return absolute_path(configured);

        const char *igc_candidates[] = {
            "./iGC", "./igc_planner", "./iGC-origin/gc_counter",
            "./iGC-origin", "./igc-origin/gc_counter", "./igc-origin"
        };
        const char *gc_candidates[] = {
            "./GC_LAMA", "./GC-LAMA", "./gc_lama", "./gc-lama", "./gc_lama_planner"
        };
        const char **items = igc ? igc_candidates : gc_candidates;
        const std::size_t count = igc
            ? sizeof(igc_candidates) / sizeof(igc_candidates[0])
            : sizeof(gc_candidates) / sizeof(gc_candidates[0]);
        for (std::size_t i = 0; i < count; ++i) {
            const std::string root = absolute_path(items[i]);
            if (readable_directory(root) &&
                readable_regular_file(root + "/lama/translate/translate.py") &&
                readable_regular_file(root + "/lama/preprocess/preprocess") &&
                readable_regular_file(root + "/lama/search/release-search"))
                return root;
        }
        return absolute_path(igc ? "./iGC" : "./GC_LAMA");
    }

    StatusCode prepare_gc_family_workspace(const std::string &workspace,
                                           std::string *message) const {
        if (!mkdirs(workspace)) {
            if (message) *message = std::string("cannot create workspace: ") + workspace;
            return STATUS_IO_ERROR;
        }
        const std::string root = gc_family_runtime_root();
        if (!readable_regular_file(root + "/lama/translate/translate.py")) {
            if (message) *message = std::string("missing translator: ") +
                root + "/lama/translate/translate.py";
            return STATUS_PLANNER_FAILED;
        }
        if (!stage_runtime_link(root + "/lama/preprocess/preprocess",
                                workspace + "/preprocess", true, message))
            return STATUS_PLANNER_FAILED;
        if (!stage_runtime_link(root + "/lama/search/release-search",
                                workspace + "/search", true, message))
            return STATUS_PLANNER_FAILED;
        if (message) *message = workspace + " -> runtime " + root;
        return STATUS_OK;
    }

    static bool gc_problem_has_uncertainty_forms(const std::string &problem_path) {
        std::string text;
        if (!read_file(problem_path, &text)) return false;
        const std::string low = lower_ascii(text);
        return low.find("(oneof") != std::string::npos ||
               low.find("(or ") != std::string::npos ||
               low.find("(or\n") != std::string::npos ||
               low.find("(unknown") != std::string::npos;
    }

    static bool gc_constraint_file_has_assignment(const std::string &path) {
        std::ifstream in(path.c_str());
        if (!in) return false;
        std::string line;
        while (std::getline(in, line)) {
            const std::string t = trim(line);
            if (t.size() > 3 && t.compare(0, 3, "var") == 0)
                return true;
        }
        return false;
    }

    static StatusCode read_first_preprocessed_assignment(
            const std::string &output_path,
            std::string *variable_name,
            int *value,
            std::string *message) {
        if (variable_name) variable_name->clear();
        if (value) *value = -1;
        std::ifstream in(output_path.c_str());
        if (!in) {
            if (message) *message = "cannot open preprocessed output: " + output_path;
            return STATUS_IO_ERROR;
        }

        std::string line;
        int variable_count = -1;
        std::string first_name;
        while (std::getline(in, line)) {
            if (trim(line) != "begin_variables") continue;
            if (!std::getline(in, line)) break;
            variable_count = std::atoi(trim(line).c_str());
            if (variable_count <= 0) break;
            for (int i = 0; i < variable_count; ++i) {
                if (!std::getline(in, line)) {
                    if (message) *message = "truncated variable section in " + output_path;
                    return STATUS_INPUT_ERROR;
                }
                if (i == 0) {
                    std::istringstream row(line);
                    row >> first_name;
                }
            }
            break;
        }
        if (variable_count <= 0 || first_name.empty()) {
            if (message) *message = "cannot read the first SAS variable from " + output_path;
            return STATUS_INPUT_ERROR;
        }

        bool found_state = false;
        while (std::getline(in, line)) {
            if (trim(line) == "begin_state") {
                found_state = true;
                break;
            }
        }
        if (!found_state || !std::getline(in, line)) {
            if (message) *message = "cannot read the initial SAS state from " + output_path;
            return STATUS_INPUT_ERROR;
        }
        std::istringstream value_row(line);
        int first_value = -1;
        value_row >> first_value;
        if (!value_row || first_value < 0) {
            if (message) *message = "invalid first SAS value in " + output_path;
            return STATUS_INPUT_ERROR;
        }
        if (variable_name) *variable_name = first_name;
        if (value) *value = first_value;
        return STATUS_OK;
    }

    StatusCode normalize_gc_family_frontend(const std::string &workspace,
                                             const std::string &problem,
                                             bool igc,
                                             std::string *message) const {
        if (message) message->clear();
        const bool pddl_has_uncertainty = gc_problem_has_uncertainty_forms(problem);

        if (!igc) {
            const std::string belief_path = workspace + "/belief";
            std::string belief_text;
            const bool readable = read_file(belief_path, &belief_text);
            if (!readable || trim(belief_text).empty()) {
                // GC-LAMA's completion loop assumes that the belief file contains
                // at least one END_BELIEF record.  Its translator writes an empty
                // file for a deterministic singleton problem, which otherwise
                // makes solve_belief_state() return false forever.
                if (pddl_has_uncertainty) {
                    if (message) *message =
                        "GC-LAMA translator produced an empty belief for an uncertain refined problem";
                    return STATUS_PLANNER_PARSE_ERROR;
                }
                if (!write_file_atomic(belief_path, "END_BELIEF\n")) {
                    if (message) *message = "cannot write singleton GC-LAMA belief marker";
                    return STATUS_IO_ERROR;
                }
                if (message) *message =
                    "inserted one END_BELIEF record for a deterministic singleton refined problem";
                std::ostringstream meta;
                meta << "{\"planner\":\"GC-LAMA\","
                     << "\"mode\":\"singleton_belief_marker\","
                     << "\"belief_records\":1}\n";
                write_file_atomic(workspace + "/runtime-normalization.json", meta.str());
            } else if (message) {
                *message = "translator belief representation retained unchanged";
            }
            return STATUS_OK;
        }

        const std::string oneof_path = workspace + "/oneof";
        const std::string oneof_initial_path = workspace + "/oneof_initial";
        const bool has_oneof_assignment =
            gc_constraint_file_has_assignment(oneof_path) ||
            gc_constraint_file_has_assignment(oneof_initial_path);
        if (has_oneof_assignment) {
            if (message) *message = "translator ONEOF/OR representation retained unchanged";
            return STATUS_OK;
        }
        if (pddl_has_uncertainty) {
            if (message) *message =
                "iGC translator produced no SAS assignment for an uncertain refined problem";
            return STATUS_PLANNER_PARSE_ERROR;
        }

        // The original iGC Counter parser dereferences oneofs.oneof[0] when
        // its translator emits the zero-group sequence "ORS 0 END_ONEOF".
        // Introduce one semantically redundant, single-alternative ONEOF over
        // a value already fixed in the deterministic initial state.  This does
        // not add an initial world; it only provides the non-empty structure
        // expected by the unmodified external iGC executable.
        std::string var_name;
        int var_value = -1;
        std::string parse_message;
        StatusCode st = read_first_preprocessed_assignment(
            workspace + "/output", &var_name, &var_value, &parse_message);
        if (st != STATUS_OK) {
            if (message) *message = parse_message;
            return st;
        }
        std::ostringstream guard;
        guard << "ONEOF\n1\n"
              << var_name << " \n"
              << var_value << "\n"
              << ", \n"
              << "END_ONEOF\n";
        if (!write_file_atomic(oneof_path, guard.str()) ||
            !write_file_atomic(oneof_initial_path, guard.str())) {
            if (message) *message = "cannot write iGC singleton ONEOF guard";
            return STATUS_IO_ERROR;
        }
        std::ostringstream meta;
        meta << "{\"planner\":\"iGC\","
             << "\"mode\":\"singleton_oneof_guard\","
             << "\"variable\":\"" << var_name << "\","
             << "\"value\":" << var_value << "}\n";
        write_file_atomic(workspace + "/runtime-normalization.json", meta.str());
        if (message) {
            std::ostringstream msg;
            msg << "inserted a semantically redundant singleton ONEOF guard: "
                << var_name << '=' << var_value;
            *message = msg.str();
        }
        return STATUS_OK;
    }

    StatusCode run_gc_family(const std::string &domain,
                             const std::string &problem,
                             const std::string &iter_dir,
                             int timeout_seconds,
                             std::string *result_path) const {
        const bool igc = kind_ == CANDIDATE_PLANNER_IGC_ORIGIN;
        const std::string prefix = igc ? "[iGC-RUNNER]" : "[GC-LAMA-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string mock = getenv_string(
            igc ? "IGC_IGC_MOCK_OUTPUT" : "IGC_GC_LAMA_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            std::string text;
            if (!read_file(mock, &text)) return STATUS_IO_ERROR;
            std::vector<std::string> parsed;
            std::string parse_error;
            StatusCode st = extract_gc_console_plan_actions(
                text, kind_, &parsed, &parse_error);
            if (st != STATUS_OK) {
                st = extract_plain_plan_actions(text, &parsed, &parse_error);
            }
            if (st != STATUS_OK) {
                std::cout << prefix << " mock parse failure: " << parse_error << std::endl;
                return st;
            }
            const std::string stable = iter_dir + "/plan-result";
            if (!write_plain_plan_artifact(parsed, stable)) return STATUS_IO_ERROR;
            copy_file(mock, stdout_path);
            std::ostringstream source;
            source << "{\"primary_planner\":\""
                   << candidate_planner_display_name(kind_)
                   << "\",\"primary_status\":\"EXPLICIT_PLAN\""
                   << ",\"materializer\":\""
                   << candidate_planner_display_name(kind_)
                   << "\",\"artifact\":\"mock_console\"}\n";
            write_file_atomic(iter_dir + "/candidate-source.json", source.str());
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string workspace = iter_dir + "/planner_work";
        std::string preparation;
        StatusCode st = prepare_gc_family_workspace(workspace, &preparation);
        if (st != STATUS_OK) {
            std::cout << prefix << " runtime preparation failed: "
                      << preparation << std::endl;
            return st;
        }
        std::cout << prefix << " runtime=" << preparation << std::endl;

        const std::string root = gc_family_runtime_root();
        const std::string python = getenv_string(
            igc ? "IGC_IGC_PYTHON" : "IGC_GC_LAMA_PYTHON",
            getenv_string("IGC_GC_PYTHON", "python2"));
        const std::string flags = getenv_string(
            igc ? "IGC_IGC_SEARCH_FLAGS" : "IGC_GC_LAMA_SEARCH_FLAGS",
            igc ? "pdaMfF" : "fF");
        const std::string result_prefix = workspace + "/result";
        const std::string translator = root + "/lama/translate/translate.py";

        // Run translation/preprocessing separately from search.  The adapter
        // must normalize the legacy runtime files between these phases.
        std::ostringstream frontend;
        frontend << "( cd " << shell_quote(workspace) << " && "
                 << "rm -f trans_file output.sas output belief oneof oneof_initial "
                 << "oneofcombine all.groups test.groups finalplan C_Plan result result.* "
                 << "runtime-normalization.json && "
                 << shell_quote(python) << ' ' << shell_quote(translator) << ' '
                 << shell_quote(absolute_path(domain)) << ' '
                 << shell_quote(absolute_path(problem)) << " > trans_file && "
                 << "test -s output.sas && "
                 << "./preprocess < output.sas && test -s output )"
                 << " > " << shell_quote(absolute_path(stdout_path))
                 << " 2> " << shell_quote(absolute_path(stderr_path));

        std::ostringstream search;
        search << "( cd " << shell_quote(workspace) << " && "
               << "./search " << shell_quote(flags) << ' '
               << shell_quote(result_prefix) << " false < output )"
               << " >> " << shell_quote(absolute_path(stdout_path))
               << " 2>> " << shell_quote(absolute_path(stderr_path));

        std::ostringstream recorded;
        recorded << frontend.str() << "\n"
                 << "# adapter runtime normalization occurs here\n"
                 << search.str() << "\n";
        write_file_atomic(iter_dir + "/planner.command", recorded.str());
        std::cout << prefix << " frontend_command=" << frontend.str() << std::endl;

        int exit_code = -1;
        int term_signal = 0;
        st = run_shell_command(frontend.str(), timeout_seconds,
                               prefix + "[frontend]", &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal > 0)
                std::cout << prefix << " frontend signal=" << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " frontend exit_code=" << exit_code << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trans_file");
            return st;
        }

        std::string normalization;
        st = normalize_gc_family_frontend(workspace, absolute_path(problem),
                                          igc, &normalization);
        if (st != STATUS_OK) {
            std::cout << prefix << " runtime normalization failed: "
                      << normalization << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trans_file");
            return st;
        }
        std::cout << prefix << " normalization=" << normalization << std::endl;
        std::cout << prefix << " search_command=" << search.str() << std::endl;

        exit_code = -1;
        term_signal = 0;
        st = run_shell_command(search.str(), timeout_seconds,
                               prefix + "[search]", &exit_code, &term_signal);
        std::string stdout_text;
        read_file(stdout_path, &stdout_text);
        if (st != STATUS_OK) {
            if (contains_no_plan_marker(stdout_text)) return STATUS_PLANNER_NO_PLAN;
            if (term_signal > 0)
                std::cout << prefix << " search signal=" << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " search exit_code=" << exit_code << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trans_file");
            return st;
        }

        std::vector<std::string> actions;
        std::string parse_error;
        std::string artifact = "";
        const std::string finalplan = workspace + "/finalplan";
        const std::string c_plan = workspace + "/C_Plan";
        std::string final_text;
        struct stat final_stat;
        if (::stat(finalplan.c_str(), &final_stat) == 0 && S_ISREG(final_stat.st_mode)) {
            read_file(finalplan, &final_text);
            if (final_text.empty()) {
                const bool success = igc
                    ? stdout_text.find("没有反例，找到最终解！") != std::string::npos
                    : lower_ascii(stdout_text).find("\nfinal plan\n") != std::string::npos;
                if (success) {
                    actions.clear();
                    st = STATUS_OK;
                } else {
                    st = STATUS_PLANNER_PARSE_ERROR;
                    parse_error = "empty finalplan without a final-plan success marker";
                }
            } else {
                st = extract_plain_plan_actions(final_text, &actions, &parse_error);
            }
            if (st == STATUS_OK) artifact = "finalplan";
        } else {
            st = STATUS_PLANNER_PARSE_ERROR;
            parse_error = "finalplan is missing";
        }

        if (st != STATUS_OK && readable_regular_file(c_plan)) {
            std::string c_text;
            if (read_file(c_plan, &c_text)) {
                std::string c_error;
                const StatusCode c_status = extract_cpah_plan_actions(
                    c_text, &actions, &c_error);
                if (c_status == STATUS_OK) {
                    st = STATUS_OK;
                    artifact = "C_Plan";
                } else if (!c_error.empty()) {
                    parse_error = c_error;
                }
            }
        }
        if (st != STATUS_OK) {
            std::string console_error;
            const StatusCode console_status = extract_gc_console_plan_actions(
                stdout_text, kind_, &actions, &console_error);
            if (console_status == STATUS_OK) {
                st = STATUS_OK;
                artifact = "planner.stdout";
            } else if (!console_error.empty()) {
                parse_error = console_error;
            }
        }
        if (st != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: " << parse_error << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trans_file");
            return st;
        }

        const std::string stable = iter_dir + "/plan-result";
        if (!write_plain_plan_artifact(actions, stable)) return STATUS_IO_ERROR;
        if (readable_regular_file(finalplan)) copy_file(finalplan, iter_dir + "/finalplan");
        if (readable_regular_file(c_plan)) copy_file(c_plan, iter_dir + "/C_Plan");
        if (readable_regular_file(workspace + "/runtime-normalization.json"))
            copy_file(workspace + "/runtime-normalization.json",
                      iter_dir + "/runtime-normalization.json");
        std::ostringstream source;
        source << "{\"primary_planner\":\""
               << candidate_planner_display_name(kind_)
               << "\",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"materializer\":\""
               << candidate_planner_display_name(kind_)
               << "\",\"artifact\":\"" << artifact << "\""
               << ",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    std::string gcpces_runtime_root() const {
        const std::string configured = trim(getenv_string("IGC_GCPCES_DIR", ""));
        if (!configured.empty()) return absolute_path(configured);
        const char *candidates[] = {"./gCPCES", "./GCPCES", "./CPCES"};
        for (std::size_t i = 0; i < sizeof(candidates)/sizeof(candidates[0]); ++i) {
            const std::string root = absolute_path(candidates[i]);
            if (readable_directory(root) &&
                readable_regular_file(root + "/build/main.class") &&
                readable_directory(root + "/libs")) return root;
        }
        return absolute_path("./gCPCES");
    }

    StatusCode run_gcpces(const std::string &domain,
                          const std::string &problem,
                          const std::string &iter_dir,
                          int timeout_seconds,
                          std::string *result_path) const {
        const std::string prefix = "[gCPCES-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string raw_plan = iter_dir + "/gcpces.raw.plan";
        const std::string mock = getenv_string("IGC_GCPCES_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            std::string text;
            if (!read_file(stdout_path, &text)) return STATUS_IO_ERROR;
            std::vector<std::string> actions;
            std::string parse_error;
            const StatusCode parsed = extract_gcpces_console_plan_actions(
                text, &actions, &parse_error);
            if (parsed != STATUS_OK) return parsed;
            if (!write_plain_plan_artifact(actions, stable)) return STATUS_IO_ERROR;
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string root = gcpces_runtime_root();
        if (!readable_regular_file(root + "/build/main.class") ||
            !readable_directory(root + "/libs")) {
            std::cout << prefix << " missing build/main.class or libs under "
                      << root << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        if (!executable_file(root + "/ff")) {
            std::cout << prefix << " default classical planner is missing or not executable: "
                      << root + "/ff" << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        const std::string workspace = iter_dir + "/planner_work";
        if (!mkdirs(workspace)) return STATUS_IO_ERROR;
        const std::string java_exec = getenv_string("IGC_GCPCES_JAVA", "java");
        const std::string args = trim(getenv_string("IGC_GCPCES_ARGS", ""));
        const std::string classpath = root + "/build:" + root + "/libs/*";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink(raw_plan.c_str());
        ::unlink(stable.c_str());

        std::ostringstream command;
        command << "( cd " << shell_quote(workspace) << " && "
                << "export LD_LIBRARY_PATH=" << shell_quote(root + "/libs")
                << "${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}; "
                << shell_quote(java_exec)
                << " -Djava.library.path=" << shell_quote(root + "/libs")
                << " -classpath " << shell_quote(classpath)
                << " main -o " << shell_quote(absolute_path(domain))
                << " -f " << shell_quote(absolute_path(problem))
                << " -op " << shell_quote(absolute_path(raw_plan));
        if (!args.empty()) command << ' ' << args;
        command << " ) > " << shell_quote(absolute_path(stdout_path))
                << " 2> " << shell_quote(absolute_path(stderr_path));
        std::cout << prefix << " runtime=" << root << std::endl;
        std::cout << prefix << " command=" << command.str() << std::endl;
        write_file_atomic(iter_dir + "/planner.command", command.str() + "\n");

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(command.str(), timeout_seconds,
                                          prefix, &exit_code, &term_signal);
        std::string stdout_text;
        read_file(stdout_path, &stdout_text);
        if (st != STATUS_OK) {
            if (lower_ascii(stdout_text).find("unsolvable") != std::string::npos)
                return STATUS_PLANNER_NO_PLAN;
            if (term_signal > 0)
                std::cout << prefix << " process signal=" << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code=" << exit_code << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path, std::string());
            return st;
        }

        std::vector<std::string> actions;
        std::string parse_error;
        bool artifact_used = false;
        std::string raw_text;
        if (read_file(raw_plan, &raw_text)) {
            if (!raw_text.empty()) {
                st = extract_plain_plan_actions(raw_text, &actions, &parse_error);
                artifact_used = st == STATUS_OK;
            } else {
                st = extract_gcpces_console_plan_actions(
                    stdout_text, &actions, &parse_error);
                artifact_used = false;
            }
        } else {
            st = extract_gcpces_console_plan_actions(
                stdout_text, &actions, &parse_error);
        }
        if (st != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: " << parse_error << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path, std::string());
            return st;
        }
        if (!write_plain_plan_artifact(actions, stable)) return STATUS_IO_ERROR;
        if (readable_regular_file(raw_plan))
            copy_file(raw_plan, iter_dir + "/gcpces-output.plan");
        std::ostringstream source;
        source << "{\"primary_planner\":\"gCPCES\""
               << ",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"materializer\":\"gCPCES\""
               << ",\"artifact\":\""
               << (artifact_used ? "-op plan file" : "planner.stdout") << "\""
               << ",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    std::string icpces_runtime_root() const {
        const std::string configured = trim(getenv_string("IGC_ICPCES_DIR", ""));
        if (!configured.empty()) return absolute_path(configured);
        const char *candidates[] = {"./iCPCES", "./ICPCES", "./icpces"};
        for (std::size_t i = 0; i < sizeof(candidates)/sizeof(candidates[0]); ++i) {
            const std::string root = absolute_path(candidates[i]);
            if (readable_directory(root) &&
                readable_regular_file(root + "/conformant_planning.py") &&
                readable_directory(root + "/translate")) return root;
        }
        return absolute_path("./iCPCES");
    }

    StatusCode validate_icpces_runtime(const std::string &root,
                                        std::string *message) const {
        if (!readable_directory(root)) {
            if (message) *message = "iCPCES runtime directory is not readable: " + root;
            return STATUS_PLANNER_FAILED;
        }
        if (!readable_regular_file(root + "/conformant_planning.py")) {
            if (message) *message =
                "missing iCPCES entry script: " + root + "/conformant_planning.py";
            return STATUS_PLANNER_FAILED;
        }
        const char *required_dirs[] = {
            "ConformantPlanning", "Methods", "translate", "downward"
        };
        for (std::size_t i = 0;
             i < sizeof(required_dirs) / sizeof(required_dirs[0]); ++i) {
            const std::string path = root + "/" + required_dirs[i];
            if (!readable_directory(path)) {
                if (message) *message = "missing iCPCES runtime directory: " + path;
                return STATUS_PLANNER_FAILED;
            }
        }
        if (!readable_regular_file(root + "/downward/fast-downward.py")) {
            if (message) *message =
                "missing iCPCES Fast Downward driver: " +
                root + "/downward/fast-downward.py";
            return STATUS_PLANNER_FAILED;
        }
        if (message) {
            *message = root +
                " (native project directory; no source staging and no PYTHONPATH shim)";
        }
        return STATUS_OK;
    }

    StatusCode run_icpces(const std::string &domain,
                          const std::string &problem,
                          const std::string &iter_dir,
                          int timeout_seconds,
                          std::string *result_path) const {
        const std::string prefix = "[iCPCES-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string abs_domain = absolute_path(domain);
        const std::string abs_problem = absolute_path(problem);
        const std::string plan_file = abs_problem + "_plan";
        const std::string mock = getenv_string("IGC_ICPCES_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            std::string text;
            if (!read_file(stdout_path, &text)) return STATUS_IO_ERROR;
            std::vector<std::string> actions;
            std::string parse_error;
            const StatusCode parsed = extract_icpces_console_plan_actions(
                text, &actions, &parse_error);
            if (parsed != STATUS_OK) return parsed;
            if (!write_plain_plan_artifact(actions, stable)) return STATUS_IO_ERROR;
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        // iCPCES is not relocatable: its Python modules and Fast Downward
        // driver use paths relative to the iCPCES project directory.  Run it
        // exactly where a successful manual invocation is run.  Only the
        // refined PDDL paths point into the CEGIS iteration directory.
        const std::string root = icpces_runtime_root();
        std::string runtime_message;
        StatusCode st = validate_icpces_runtime(root, &runtime_message);
        if (st != STATUS_OK) {
            std::cout << prefix << " runtime validation failed: "
                      << runtime_message << std::endl;
            return st;
        }
        std::cout << prefix << " runtime=" << runtime_message << std::endl;

        const std::string python = getenv_string("IGC_ICPCES_PYTHON", "python3");
        const std::string args = trim(getenv_string("IGC_ICPCES_ARGS", "-p superfd"));
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink(stable.c_str());
        ::unlink(plan_file.c_str());

        // iCPCES writes output.sas/sas_plan in its current directory.  The
        // advisory lock prevents concurrent CEGIS runs from corrupting these
        // shared native-runtime artifacts.  If flock is unavailable, the
        // command still runs serially as before.
        const std::string lock_file = root + "/.igc-cegis-icpces.lock";
        std::ostringstream command;
        command << "( exec 9>" << shell_quote(lock_file) << "; "
                << "if command -v flock >/dev/null 2>&1; then flock -x 9; fi; "
                << "cd " << shell_quote(root) << " || exit 126; "
                << "rm -f output.sas sas_plan sas_plan.*; "
                << "export PYTHONUNBUFFERED=1; "
                << shell_quote(python) << " ./conformant_planning.py"
                << " -d " << shell_quote(abs_domain)
                << " -i " << shell_quote(abs_problem);
        if (!args.empty()) command << ' ' << args;
        command << " ) > " << shell_quote(absolute_path(stdout_path))
                << " 2> " << shell_quote(absolute_path(stderr_path));
        std::cout << prefix << " command=" << command.str() << std::endl;
        write_file_atomic(iter_dir + "/planner.command", command.str() + "\n");

        int exit_code = -1, term_signal = 0;
        st = run_shell_command(command.str(), timeout_seconds,
                               prefix, &exit_code, &term_signal);
        std::string stdout_text;
        read_file(stdout_path, &stdout_text);
        if (st != STATUS_OK) {
            const std::string low = lower_ascii(stdout_text);
            if (low.find("no solution") != std::string::npos ||
                low.find("search stopped without finding a solution") !=
                    std::string::npos)
                return STATUS_PLANNER_NO_PLAN;
            if (term_signal > 0)
                std::cout << prefix << " process signal=" << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code=" << exit_code << std::endl;
            std::cout << prefix << " full stdout=" << stdout_path
                      << " stderr=" << stderr_path << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path, std::string());
            return st;
        }

        std::vector<std::string> actions;
        std::string parse_error;
        bool artifact_used = false;
        std::string plan_text;
        if (read_file(plan_file, &plan_text)) {
            if (!plan_text.empty()) {
                st = extract_plain_plan_actions(plan_text, &actions, &parse_error);
                artifact_used = st == STATUS_OK;
            } else {
                st = extract_icpces_console_plan_actions(
                    stdout_text, &actions, &parse_error);
                artifact_used = false;
            }
        } else {
            st = extract_icpces_console_plan_actions(
                stdout_text, &actions, &parse_error);
        }
        if (st != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: "
                      << parse_error << std::endl;
            std::cout << prefix << " full stdout=" << stdout_path
                      << " stderr=" << stderr_path << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path, std::string());
            return st;
        }
        if (!write_plain_plan_artifact(actions, stable)) return STATUS_IO_ERROR;
        if (readable_regular_file(plan_file))
            copy_file(plan_file, iter_dir + "/icpces-output.plan");
        std::ostringstream source;
        source << "{\"primary_planner\":\"iCPCES\""
               << ",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"materializer\":\"iCPCES\""
               << ",\"runtime\":\"native_project_directory\""
               << ",\"artifact\":\""
               << (artifact_used ? "problem_plan file" : "planner.stdout") << "\""
               << ",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    std::string cpa_runtime_root() const {
        switch (kind_) {
        case CANDIDATE_PLANNER_CNF:
            return absolute_path(getenv_string("IGC_CNF_DIR", "./cnf_planner"));
        case CANDIDATE_PLANNER_DNF:
            return absolute_path(getenv_string("IGC_DNF_DIR", "./dnf_planner"));
        case CANDIDATE_PLANNER_PIP:
            return absolute_path(getenv_string("IGC_PIP_DIR", "./pip_planner"));
        case CANDIDATE_PLANNER_CPAH:
            return absolute_path(getenv_string("IGC_CPAH_DIR", "./CpAH"));
        default:
            return std::string();
        }
    }

    std::string cpa_binary_name() const {
        switch (kind_) {
        case CANDIDATE_PLANNER_CNF: return "cnf";
        case CANDIDATE_PLANNER_DNF: return "dnf";
        case CANDIDATE_PLANNER_PIP: return "pip";
        case CANDIDATE_PLANNER_CPAH: return "CPAH";
        default: return std::string();
        }
    }

    StatusCode prepare_cpa_workspace(const std::string &workspace,
                                     std::string *message) const {
        if (!mkdirs(workspace)) {
            if (message) *message = std::string("cannot create workspace: ") + workspace;
            return STATUS_IO_ERROR;
        }
        const std::string root = cpa_runtime_root();
        const std::string binary = cpa_binary_name();
        struct Entry { const char *name; bool executable; };
        const Entry entries[] = {
            {"cpa.pddl2pl", true},
            {"mult5zsic.pl", false},
            {"input", false}
        };
        for (std::size_t i = 0; i < sizeof(entries) / sizeof(entries[0]); ++i) {
            if (!stage_runtime_link(root + "/" + entries[i].name,
                                    workspace + "/" + entries[i].name,
                                    entries[i].executable, message))
                return STATUS_PLANNER_FAILED;
        }
        if (!stage_runtime_link(root + "/" + binary,
                                workspace + "/" + binary,
                                true, message))
            return STATUS_PLANNER_FAILED;
        if (message) *message = workspace + " -> runtime " + root;
        return STATUS_OK;
    }

    StatusCode prepare_cpah_workspace(const std::string &workspace,
                                      std::string *message) const {
        if (!mkdirs(workspace)) {
            if (message) *message = std::string("cannot create workspace: ") + workspace;
            return STATUS_IO_ERROR;
        }
        const std::string root = absolute_path(
            getenv_string("IGC_CPAH_DIR", "./CpAH"));
        struct Entry { const char *name; bool executable; };
        const Entry entries[] = {
            {"cpa.pddl2pl", true},
            {"mult5zsic.pl", false},
            {"CPAH", true}
        };
        for (std::size_t i = 0; i < sizeof(entries) / sizeof(entries[0]); ++i) {
            if (!stage_runtime_link(root + "/" + entries[i].name,
                                    workspace + "/" + entries[i].name,
                                    entries[i].executable, message))
                return STATUS_PLANNER_FAILED;
        }
        if (message) *message = workspace + " -> runtime " + root;
        return STATUS_OK;
    }

    StatusCode run_cpah(const std::string &domain,
                        const std::string &problem,
                        const std::string &iter_dir,
                        int timeout_seconds,
                        std::string *result_path) const {
        const std::string prefix = "[CPAH-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string mock = getenv_string("IGC_CPAH_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            std::cout << prefix << " mock mode; copying " << mock << std::endl;
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            std::vector<std::string> parsed;
            std::string parse_error;
            std::string text;
            if (!read_file(stdout_path, &text)) return STATUS_IO_ERROR;
            StatusCode st = extract_cpah_plan_actions(text, &parsed, &parse_error);
            if (st != STATUS_OK) {
                std::cout << prefix << " mock output parse failure: "
                          << parse_error << std::endl;
                return st;
            }
            if (result_path) *result_path = stdout_path;
            return STATUS_OK;
        }

        const std::string workspace = iter_dir + "/planner_work";
        std::string preparation;
        StatusCode st = prepare_cpah_workspace(workspace, &preparation);
        if (st != STATUS_OK) {
            std::cout << prefix << " runtime preparation failed: "
                      << preparation << std::endl;
            return st;
        }
        std::cout << prefix << " runtime=" << preparation << std::endl;

        const std::string sicstus = getenv_string("IGC_SICSTUS_EXEC", "sicstus");
        const std::string plan_result = workspace + "/plan-result";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());

        std::ostringstream pipeline;
        pipeline << "( cd " << shell_quote(workspace) << " && "
                 << "rm -f case-input.pddl pddl2pl.pl new.pl theory_*.al "
                 << "theory_names temp trash plan-result result-time && "
                 << "cat " << shell_quote(absolute_path(domain)) << ' '
                 << shell_quote(absolute_path(problem)) << " > case-input.pddl && "
                 << "./cpa.pddl2pl case-input.pddl && "
                 << "test -s pddl2pl.pl && "
                 << "cat mult5zsic.pl pddl2pl.pl > new.pl && "
                 << shell_quote(sicstus)
                 << " -l new.pl --goal 'main,halt.' > trash && "
                 << "test -s theory_names && "
                 << "./CPAH theory_names > temp && "
                 << "sed -e 's/cpa_//g' temp > plan-result && "
                 << "cat plan-result )"
                 << " > " << shell_quote(absolute_path(stdout_path))
                 << " 2> " << shell_quote(absolute_path(stderr_path));
        std::cout << prefix << " command=" << pipeline.str() << std::endl;
        write_file_atomic(iter_dir + "/planner.command", pipeline.str() + "\n");

        int exit_code = -1, term_signal = 0;
        st = run_shell_command(pipeline.str(), timeout_seconds,
                               prefix, &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal)
                std::cout << prefix << " process terminated by signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trash");
            return st;
        }

        std::string result_text;
        if (!read_file(plan_result, &result_text) || result_text.empty()) {
            std::cout << prefix << " plan-result is missing or empty" << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trash");
            return STATUS_PLANNER_PARSE_ERROR;
        }
        std::vector<std::string> actions;
        std::string parse_error;
        st = extract_cpah_plan_actions(result_text, &actions, &parse_error);
        if (st != STATUS_OK) {
            if (st == STATUS_PLANNER_NO_PLAN)
                std::cout << prefix << " planner reported no candidate plan" << std::endl;
            else
                std::cout << prefix << " output parse failure: "
                          << parse_error << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trash");
            return st;
        }

        const std::string stable_result = iter_dir + "/plan-result";
        if (!copy_file(plan_result, stable_result)) return STATUS_IO_ERROR;
        copy_file(workspace + "/case-input.pddl", iter_dir + "/case-input.pddl");
        copy_file(workspace + "/theory_names", iter_dir + "/theory_names");
        std::ostringstream source_info;
        source_info << "{\"primary_planner\":\"CPAH\""
                    << ",\"primary_status\":\"EXPLICIT_PLAN\""
                    << ",\"materializer\":\"CPAH\""
                    << ",\"recovered_actions\":0}\n";
        write_file_atomic(iter_dir + "/candidate-source.json",
                          source_info.str());
        if (result_path) *result_path = stable_result;
        return STATUS_OK;
    }

    StatusCode run_cpa_family(const std::string &domain,
                              const std::string &problem,
                              const std::string &iter_dir,
                              int timeout_seconds,
                              std::string *result_path) const {
        const std::string prefix = std::string("[") +
            candidate_planner_display_name(kind_) + "-RUNNER]";
        const std::string mock_env = std::string("IGC_") +
            candidate_planner_display_name(kind_) + "_MOCK_OUTPUT";
        const std::string mock = getenv_string(mock_env.c_str(), "");
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        if (!mock.empty()) {
            std::cout << prefix << " mock mode; copying " << mock << std::endl;
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            if (result_path) *result_path = stdout_path;
            return STATUS_OK;
        }

        const std::string workspace = iter_dir + "/planner_work";
        std::string preparation;
        StatusCode st = prepare_cpa_workspace(workspace, &preparation);
        if (st != STATUS_OK) {
            std::cout << prefix << " runtime preparation failed: "
                      << preparation << std::endl;
            return st;
        }
        std::cout << prefix << " runtime=" << preparation << std::endl;

        const std::string binary = cpa_binary_name();
        const std::string sicstus = getenv_string("IGC_SICSTUS_EXEC", "sicstus");
        const std::string plan_result = workspace + "/plan-result";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());

        std::ostringstream pipeline;
        pipeline << "( cd " << shell_quote(workspace) << " && "
                 << "rm -f dp.pddl pddl2pl.pl new.pl theory_*.al theory_names "
                 << "temp trash plan-result result-time && "
                 << "cat " << shell_quote(absolute_path(domain)) << ' '
                 << shell_quote(absolute_path(problem)) << " > dp.pddl && "
                 << "./cpa.pddl2pl dp.pddl && "
                 << "test -s pddl2pl.pl && "
                 << "cat mult5zsic.pl pddl2pl.pl > new.pl && "
                 << shell_quote(sicstus)
                 << " -l new.pl --goal 'main,halt.' < input > trash && "
                 << "test -s theory_0.al && "
                 << "./" << binary << " theory_0.al > temp && "
                 << "sed -e 's/cpa_//g' temp > plan-result && "
                 << "cat plan-result )"
                 << " > " << shell_quote(absolute_path(stdout_path))
                 << " 2> " << shell_quote(absolute_path(stderr_path));
        std::cout << prefix << " command=" << pipeline.str() << std::endl;
        write_file_atomic(iter_dir + "/planner.command", pipeline.str() + "\n");

        int exit_code = -1, term_signal = 0;
        st = run_shell_command(pipeline.str(), timeout_seconds,
                               prefix, &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal)
                std::cout << prefix << " process terminated by signal=" << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code=" << exit_code << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trash");
            return st;
        }

        std::string result_text;
        if (!read_file(plan_result, &result_text) || result_text.empty()) {
            std::cout << prefix << " plan-result is missing or empty" << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trash");
            return STATUS_PLANNER_PARSE_ERROR;
        }
        if (contains_no_plan_marker(result_text)) {
            std::cout << prefix << " planner reported no candidate plan" << std::endl;
            return STATUS_PLANNER_NO_PLAN;
        }
        if (!contains_cpa_success_marker(result_text)) {
            std::cout << prefix << " output has no success marker" << std::endl;
            print_common_diagnostics(prefix, stdout_path, stderr_path,
                                     workspace + "/trash");
            return STATUS_PLANNER_PARSE_ERROR;
        }

        // Preserve the primary planner output even when a recovery backend is
        // needed to materialise the concrete action sequence.  Old DNF builds,
        // and some PIP builds, may report a non-empty plan length while losing
        // the predecessor/action chain and therefore print no actions at all.
        // This is a planner-output defect, not a valid empty plan.
        const std::string primary_result = iter_dir + "/primary-plan-result";
        if (!copy_file(plan_result, primary_result)) return STATUS_IO_ERROR;

        std::vector<std::string> primary_actions;
        std::string primary_parse_error;
        const StatusCode primary_parse = extract_cpa_plan_actions(
            result_text, &primary_actions, &primary_parse_error);

        if (primary_parse != STATUS_OK &&
            kind_ != CANDIDATE_PLANNER_CNF &&
            env_true("IGC_CPA_PLAN_RECOVERY", true) &&
            primary_parse_error.find("omitted the action sequence") != std::string::npos) {
            std::cout << prefix
                      << " primary planner found a plan but omitted its action sequence; "
                      << "starting explicit-plan recovery on the same theory_0.al"
                      << std::endl;

            const std::string recovery_exec_env = getenv_string(
                "IGC_CPA_PLAN_RECOVERY_EXEC", "");
            const std::string recovery_exec = recovery_exec_env.empty()
                ? absolute_path(getenv_string("IGC_CNF_DIR", "./cnf_planner") + "/cnf")
                : absolute_path(recovery_exec_env);
            if (!executable_file(recovery_exec)) {
                std::cout << prefix
                          << " recovery executable is missing or not executable: "
                          << recovery_exec << std::endl;
                return STATUS_PLANNER_PARSE_ERROR;
            }

            const std::string recovery_temp = workspace + "/recovery.temp";
            const std::string recovery_result = workspace + "/recovery-plan-result";
            const std::string recovery_stdout = iter_dir + "/planner.recovery.stdout";
            const std::string recovery_stderr = iter_dir + "/planner.recovery.stderr";
            ::unlink(recovery_temp.c_str());
            ::unlink(recovery_result.c_str());
            ::unlink(recovery_stdout.c_str());
            ::unlink(recovery_stderr.c_str());

            std::ostringstream recovery;
            recovery << "( cd " << shell_quote(workspace) << " && "
                     << shell_quote(recovery_exec)
                     << " theory_0.al > recovery.temp && "
                     << "sed -e 's/cpa_//g' recovery.temp > recovery-plan-result && "
                     << "cat recovery-plan-result )"
                     << " > " << shell_quote(absolute_path(recovery_stdout))
                     << " 2> " << shell_quote(absolute_path(recovery_stderr));
            std::cout << prefix << " recovery_command=" << recovery.str() << std::endl;
            write_file_atomic(iter_dir + "/planner.recovery.command",
                              recovery.str() + "\n");

            int recovery_exit = -1, recovery_signal = 0;
            StatusCode recovery_status = run_shell_command(
                recovery.str(), timeout_seconds, prefix + "[RECOVERY]",
                &recovery_exit, &recovery_signal);
            if (recovery_status != STATUS_OK) {
                if (recovery_signal)
                    std::cout << prefix << " recovery terminated by signal="
                              << recovery_signal << std::endl;
                else if (recovery_exit >= 0)
                    std::cout << prefix << " recovery exit_code="
                              << recovery_exit << std::endl;
                print_common_diagnostics(prefix + "[RECOVERY]",
                                         recovery_stdout, recovery_stderr,
                                         recovery_temp);
                return recovery_status;
            }

            std::string recovery_text;
            if (!read_file(recovery_result, &recovery_text) || recovery_text.empty()) {
                std::cout << prefix << " recovery output is missing or empty" << std::endl;
                print_common_diagnostics(prefix + "[RECOVERY]",
                                         recovery_stdout, recovery_stderr,
                                         recovery_temp);
                return STATUS_PLANNER_PARSE_ERROR;
            }
            if (contains_no_plan_marker(recovery_text)) {
                std::cout << prefix
                          << " recovery backend reported no plan for the same candidate problem"
                          << std::endl;
                return STATUS_PLANNER_PARSE_ERROR;
            }

            std::vector<std::string> recovered_actions;
            std::string recovered_error;
            const StatusCode recovered_parse = extract_cpa_plan_actions(
                recovery_text, &recovered_actions, &recovered_error);
            if (recovered_parse != STATUS_OK || recovered_actions.empty()) {
                std::cout << prefix << " recovery output is not a concrete plan";
                if (!recovered_error.empty())
                    std::cout << ": " << recovered_error;
                std::cout << std::endl;
                print_common_diagnostics(prefix + "[RECOVERY]",
                                         recovery_stdout, recovery_stderr,
                                         recovery_temp);
                return STATUS_PLANNER_PARSE_ERROR;
            }

            const std::string stable_recovery = iter_dir + "/recovery-plan-result";
            if (!copy_file(recovery_result, stable_recovery)) return STATUS_IO_ERROR;
            const std::string stable_result = iter_dir + "/plan-result";
            if (!copy_file(recovery_result, stable_result)) return STATUS_IO_ERROR;
            std::ostringstream source_info;
            source_info << "{\"primary_planner\":\""
                        << candidate_planner_display_name(kind_)
                        << "\",\"primary_status\":\"PLAN_WITHOUT_SEQUENCE\""
                        << ",\"materializer\":\"CNF\""
                        << ",\"recovered_actions\":" << recovered_actions.size()
                        << "}\n";
            write_file_atomic(iter_dir + "/candidate-source.json",
                              source_info.str());
            std::cout << prefix
                      << " explicit plan recovered with CNF on the identical theory; actions="
                      << recovered_actions.size() << std::endl;
            if (result_path) *result_path = stable_result;
            return STATUS_OK;
        }

        if (primary_parse != STATUS_OK) {
            std::cout << prefix << " primary plan output is incomplete: "
                      << primary_parse_error << std::endl;
            return primary_parse;
        }

        // Keep the canonical candidate-planner result at the iteration root as
        // well.  planner_work remains the isolated mutable runtime directory;
        // iter_xxxx/plan-result is the stable artifact consumed by mapping and
        // retained for later inspection.
        const std::string stable_result = iter_dir + "/plan-result";
        if (!copy_file(plan_result, stable_result)) return STATUS_IO_ERROR;
        std::ostringstream source_info;
        source_info << "{\"primary_planner\":\""
                    << candidate_planner_display_name(kind_)
                    << "\",\"primary_status\":\"EXPLICIT_PLAN\""
                    << ",\"materializer\":\""
                    << candidate_planner_display_name(kind_)
                    << "\",\"recovered_actions\":0}\n";
        write_file_atomic(iter_dir + "/candidate-source.json",
                          source_info.str());
        if (result_path) *result_path = stable_result;
        return STATUS_OK;
    }

    CandidatePlannerKind kind_;
};

class ActionMapper {
public:
    ActionMapper() : exact_(), relaxed_(), ambiguous_relaxed_() {
        for (std::size_t i = 0; i < g_operators.size(); ++i) {
            const Operator *op = &g_operators[i];
            const std::string exact = canonical_action(op->get_name(), false);
            exact_[exact] = op;
            const std::string relaxed = canonical_action(op->get_name(), true);
            std::map<std::string, const Operator *>::iterator it = relaxed_.find(relaxed);
            if (it != relaxed_.end() && it->second != op) ambiguous_relaxed_.insert(relaxed);
            else relaxed_[relaxed] = op;
        }
    }

    StatusCode parse_and_map(CandidatePlannerKind kind,
                             const std::string &path,
                             std::vector<const Operator *> *plan,
                             std::vector<std::string> *raw_actions,
                             std::string *error) const {
        // Never leave the previous iteration's candidate visible after a
        // parser failure.  v6 logged actions=8 at iter_0002 even though the
        // current DNF output contained zero actions, because clearing happened
        // only inside map_actions() after parsing had succeeded.
        if (plan) plan->clear();
        if (raw_actions) raw_actions->clear();
        if (error) error->clear();
        std::vector<std::string> parsed;
        StatusCode st = STATUS_OK;
        if (kind == CANDIDATE_PLANNER_T1)
            st = parse_t1_actions(path, &parsed, error);
        else if (kind == CANDIDATE_PLANNER_CPAH)
            st = parse_cpah_actions(path, &parsed, error);
        else if (kind == CANDIDATE_PLANNER_IGC_ORIGIN ||
                 kind == CANDIDATE_PLANNER_GC_LAMA ||
                 kind == CANDIDATE_PLANNER_GCPCES ||
                 kind == CANDIDATE_PLANNER_ICPCES ||
                 kind == CANDIDATE_PLANNER_CFF)
            st = parse_plain_actions(path, &parsed, error);
        else
            st = parse_cpa_actions(path, &parsed, error);
        if (st != STATUS_OK) return st;
        return map_actions(parsed, plan, raw_actions, error);
    }

private:
    static StatusCode parse_t1_actions(const std::string &path,
                                       std::vector<std::string> *actions,
                                       std::string *error) {
        actions->clear();
        std::ifstream in(path.c_str());
        if (!in) return STATUS_IO_ERROR;
        std::string line;
        while (std::getline(in, line)) {
            line = trim(line);
            if (line.empty() || line[0] == ';' || line[0] == '#') continue;
            if (line[0] != '(') continue;
            const std::size_t close = line.rfind(')');
            if (close == std::string::npos) continue;
            const std::string body = trim(line.substr(1, close - 1));
            if (!body.empty()) actions->push_back(body);
        }
        if (!in.eof() && in.fail()) return STATUS_IO_ERROR;
        if (actions->empty()) {
            std::string all;
            if (!read_file(path, &all)) return STATUS_IO_ERROR;
            const std::string low = lower_ascii(all);
            if (contains_no_plan_marker(all)) return STATUS_PLANNER_NO_PLAN;
            if (low.find("empty plan") == std::string::npos &&
                low.find("plan length: 0") == std::string::npos &&
                low.find("plan_length=0") == std::string::npos) {
                if (error) *error = "T1 planner.result contains no parseable actions";
                return STATUS_PLANNER_PARSE_ERROR;
            }
        }
        return STATUS_OK;
    }

    static StatusCode parse_plain_actions(const std::string &path,
                                          std::vector<std::string> *actions,
                                          std::string *error) {
        std::string text;
        if (!read_file(path, &text)) return STATUS_IO_ERROR;
        return extract_plain_plan_actions(text, actions, error);
    }

    static StatusCode parse_cpah_actions(const std::string &path,
                                         std::vector<std::string> *actions,
                                         std::string *error) {
        std::string text;
        if (!read_file(path, &text)) return STATUS_IO_ERROR;
        return extract_cpah_plan_actions(text, actions, error);
    }

    static StatusCode parse_cpa_actions(const std::string &path,
                                        std::vector<std::string> *actions,
                                        std::string *error) {
        std::string text;
        if (!read_file(path, &text)) return STATUS_IO_ERROR;
        return extract_cpa_plan_actions(text, actions, error);
    }

    StatusCode map_actions(const std::vector<std::string> &parsed,
                           std::vector<const Operator *> *plan,
                           std::vector<std::string> *raw_actions,
                           std::string *error) const {
        plan->clear();
        if (raw_actions) raw_actions->clear();
        for (std::size_t i = 0; i < parsed.size(); ++i) {
            const std::string &body = parsed[i];
            const Operator *op = 0;
            const std::string exact = canonical_action(body, false);
            std::map<std::string, const Operator *>::const_iterator eit = exact_.find(exact);
            if (eit != exact_.end()) op = eit->second;
            if (!op) {
                const std::string relaxed = canonical_action(body, true);
                if (ambiguous_relaxed_.find(relaxed) != ambiguous_relaxed_.end()) {
                    if (error) *error = std::string("ambiguous relaxed action name: ") + body;
                    return STATUS_MAPPING_ERROR;
                }
                std::map<std::string, const Operator *>::const_iterator rit = relaxed_.find(relaxed);
                if (rit != relaxed_.end()) op = rit->second;
            }
            if (!op) {
                if (error) *error = std::string("unknown action from candidate planner: ") + body;
                return STATUS_MAPPING_ERROR;
            }
            plan->push_back(op);
            if (raw_actions) raw_actions->push_back(body);
        }
        return STATUS_OK;
    }

    static std::string canonical_action(const std::string &s, bool relaxed) {
        return canonical_symbol_text(s, relaxed);
    }
    std::map<std::string, const Operator *> exact_;
    std::map<std::string, const Operator *> relaxed_;
    std::set<std::string> ambiguous_relaxed_;
};


struct VerificationResult {
    StatusCode status;
    bool has_counterexample;
    std::vector<int> counterexample;
    int build_ms;
    int solve_ms;
    int extract_ms;
    VerificationResult()
        : status(STATUS_BACKEND_ERROR), has_counterexample(false), counterexample(),
          build_ms(0), solve_ms(0), extract_ms(0) {}
};

static VerificationResult verify_full_problem(const OriginalProblemContext &ctx,
                                              CounterCNF *verifier,
                                              const Counter *driver,
                                              const std::vector<const Operator *> &plan) {
    VerificationResult r;
    if (g_initial_state == 0 || ctx.original_sas_state.size() != g_initial_state->vars.size()) {
        r.status = STATUS_INPUT_ERROR;
        return r;
    }
    g_initial_state->vars = ctx.original_sas_state;
    if (!verifier->prepare_counterexample_cnf(plan, true, driver)) {
        r.status = STATUS_BACKEND_ERROR;
        return r;
    }
    r.build_ms = verifier->get_cnf_build_time_ms();
    if (!verifier->kissat_available()) {
        r.status = STATUS_BACKEND_ERROR;
        return r;
    }
    verifier->run_kissat_validation();
    r.solve_ms = verifier->get_kissat_solve_time_ms();
    r.extract_ms = verifier->get_kissat_model_extract_time_ms();
    if (!verifier->get_kissat_result_valid()) {
        r.status = STATUS_BACKEND_ERROR;
        return r;
    }
    r.has_counterexample = verifier->get_kissat_last_has_counterexample();
    if (r.has_counterexample) {
        if (!verifier->get_kissat_sample_valid()) {
            r.status = STATUS_BACKEND_ERROR;
            return r;
        }
        r.counterexample = verifier->get_kissat_counterexample_state();
        r.status = STATUS_COUNTEREXAMPLE;
    } else {
        r.status = STATUS_VALID;
    }
    g_initial_state->vars = ctx.original_sas_state;
    return r;
}

static StatusCode write_candidate_plan(const std::vector<const Operator *> &plan,
                                       const std::string &path) {
    std::ostringstream out;
    for (std::size_t i = 0; i < plan.size(); ++i)
        out << '(' << plan[i]->get_name() << ")\n";
    return write_file_atomic(path, out.str()) ? STATUS_OK : STATUS_IO_ERROR;
}

static StatusCode write_final_outputs(const std::vector<const Operator *> &plan,
                                      const std::string &result_file) {
    if (write_candidate_plan(plan, result_file) != STATUS_OK) return STATUS_IO_ERROR;
    std::ostringstream plain;
    for (std::size_t i = 0; i < plan.size(); ++i) plain << plan[i]->get_name() << '\n';
    if (!write_file_atomic("finalplan", plain.str())) return STATUS_IO_ERROR;
    if (!write_file_atomic("C_Plan", plain.str())) return STATUS_IO_ERROR;
    return STATUS_OK;
}

static std::string iteration_dir(const std::string &run_dir, int iteration) {
    std::ostringstream out;
    out << run_dir << "/iter_" << std::setfill('0') << std::setw(4) << iteration;
    return out.str();
}

static RefinedProblemWriter::Mode configured_mode(CandidatePlannerKind kind) {
    const std::string mode = lower_ascii(getenv_string("IGC_REFINED_MODE", "structured"));
    if (mode == "single" || mode == "single_world")
        return RefinedProblemWriter::SINGLE_WORLD;
    // All CPA-family backends use an exact selector encoding for the accumulated
    // counterexample worlds. CPA(H) receives its own syntax profile because its
    // newer PDDL front-end requires explicit UNKNOWN declarations for ordinary
    // varying atoms. T1 and CFF share the structure-preserving renderer because
    // their initial-state grammar accepts UNKNOWN/ONEOF/OR but not the selector
    // implication profile used by the exact-sample backends.
    if (kind != CANDIDATE_PLANNER_T1 &&
        kind != CANDIDATE_PLANNER_CFF)
        return RefinedProblemWriter::EXACT_SAMPLE_SET;
    return RefinedProblemWriter::STRUCTURED_PRODUCT;
}

static const char *refined_mode_name(RefinedProblemWriter::Mode mode) {
    switch (mode) {
    case RefinedProblemWriter::SINGLE_WORLD: return "single_world";
    case RefinedProblemWriter::EXACT_SAMPLE_SET: return "exact_sample_set";
    case RefinedProblemWriter::STRUCTURED_PRODUCT: default: return "structured_product";
    }
}

static StatusCode configured_candidate_planner(CandidatePlannerKind *kind) {
    const std::string value = lower_ascii(trim(
        getenv_string("IGC_CANDIDATE_PLANNER", "t1")));
    if (value == "t1") *kind = CANDIDATE_PLANNER_T1;
    else if (value == "cnf" || value == "cnf_planner") *kind = CANDIDATE_PLANNER_CNF;
    else if (value == "dnf" || value == "dnf_planner") *kind = CANDIDATE_PLANNER_DNF;
    else if (value == "pip" || value == "pip_planner") *kind = CANDIDATE_PLANNER_PIP;
    else if (value == "cpah" || value == "cpa_h" || value == "cpah_planner")
        *kind = CANDIDATE_PLANNER_CPAH;
    else if (value == "igc" || value == "igc_origin" ||
             value == "igc-origin" || value == "original_igc")
        *kind = CANDIDATE_PLANNER_IGC_ORIGIN;
    else if (value == "gc" || value == "gc_lama" ||
             value == "gc-lama" || value == "gclama")
        *kind = CANDIDATE_PLANNER_GC_LAMA;
    else if (value == "gcpces" || value == "g_cpces" ||
             value == "g-cpces" || value == "cpces")
        *kind = CANDIDATE_PLANNER_GCPCES;
    else if (value == "icpces" || value == "i_cpces" ||
             value == "i-cpces")
        *kind = CANDIDATE_PLANNER_ICPCES;
    else if (value == "cff" || value == "conformant_ff" ||
             value == "conformant-ff" || value == "ff")
        *kind = CANDIDATE_PLANNER_CFF;
    else return STATUS_INPUT_ERROR;
    return STATUS_OK;
}

static int configured_planner_timeout(CandidatePlannerKind kind) {
    const char *specific = "IGC_T1_TIMEOUT";
    switch (kind) {
    case CANDIDATE_PLANNER_CNF: specific = "IGC_CNF_TIMEOUT"; break;
    case CANDIDATE_PLANNER_DNF: specific = "IGC_DNF_TIMEOUT"; break;
    case CANDIDATE_PLANNER_PIP: specific = "IGC_PIP_TIMEOUT"; break;
    case CANDIDATE_PLANNER_CPAH: specific = "IGC_CPAH_TIMEOUT"; break;
    case CANDIDATE_PLANNER_IGC_ORIGIN: specific = "IGC_IGC_TIMEOUT"; break;
    case CANDIDATE_PLANNER_GC_LAMA: specific = "IGC_GC_LAMA_TIMEOUT"; break;
    case CANDIDATE_PLANNER_GCPCES: specific = "IGC_GCPCES_TIMEOUT"; break;
    case CANDIDATE_PLANNER_ICPCES: specific = "IGC_ICPCES_TIMEOUT"; break;
    case CANDIDATE_PLANNER_CFF: specific = "IGC_CFF_TIMEOUT"; break;
    case CANDIDATE_PLANNER_T1: default: break;
    }
    const int per_planner = getenv_int(specific, 3600, 1);
    return getenv_int("IGC_CANDIDATE_TIMEOUT", per_planner, 1);
}

static bool problem_goal_contains_or(const std::string &problem_path) {
    std::string text;
    if (!read_file(problem_path, &text)) return false;
    const std::size_t goal = find_form_start(text, ":goal");
    if (goal == std::string::npos) return false;
    const std::size_t end = matching_paren(text, goal);
    if (end == std::string::npos) return false;
    const std::string goal_form = lower_ascii(text.substr(goal, end - goal + 1));
    return goal_form.find("(or") != std::string::npos;
}

} // namespace

const char *status_name(StatusCode code) {
    switch (code) {
    case STATUS_OK: return "OK";
    case STATUS_VALID: return "VALID";
    case STATUS_COUNTEREXAMPLE: return "COUNTEREXAMPLE";
    case STATUS_INPUT_ERROR: return "INPUT_ERROR";
    case STATUS_MAPPING_ERROR: return "MAPPING_ERROR";
    case STATUS_PLANNER_TIMEOUT: return "PLANNER_TIMEOUT";
    case STATUS_PLANNER_PARSE_ERROR: return "PLANNER_PARSE_ERROR";
    case STATUS_PLANNER_FAILED: return "PLANNER_FAILED";
    case STATUS_BACKEND_ERROR: return "BACKEND_ERROR";
    case STATUS_IO_ERROR: return "IO_ERROR";
    case STATUS_ITERATION_LIMIT: return "ITERATION_LIMIT";
    case STATUS_STAGNATION: return "STAGNATION";
    case STATUS_PLANNER_NO_PLAN: return "PLANNER_NO_PLAN";
    case STATUS_UNSUPPORTED_INPUT: return "UNSUPPORTED_INPUT";
    default: return "UNKNOWN";
    }
}

bool enabled_from_environment() {
    return env_true("IGC_CEGIS_MODE", false);
}

StatusCode run_cegis_loop(const std::string &result_file) {
    const std::string domain = getenv_string("IGC_ORIGINAL_DOMAIN", "");
    const std::string problem = getenv_string("IGC_ORIGINAL_PROBLEM", "");
    if (domain.empty() || problem.empty()) {
        std::cerr << "[IGC-CEGIS] IGC_ORIGINAL_DOMAIN and IGC_ORIGINAL_PROBLEM are required." << std::endl;
        return STATUS_INPUT_ERROR;
    }
    CandidatePlannerKind planner_kind = CANDIDATE_PLANNER_T1;
    StatusCode planner_config = configured_candidate_planner(&planner_kind);
    if (planner_config != STATUS_OK) {
        std::cerr << "[IGC-CEGIS] invalid IGC_CANDIDATE_PLANNER; expected t1|cff|cnf|dnf|pip|cpah|igc|gc_lama|gcpces|icpces." << std::endl;
        return planner_config;
    }
    const std::string all_groups = absolute_path(getenv_string("IGC_ALL_GROUPS", "all.groups"));
    const std::string oneof_initial = absolute_path(getenv_string("IGC_ONEOF_INITIAL", "oneof_initial"));
    std::ostringstream default_run;
    default_run << "runs/run_" << ::getpid();
    const std::string run_dir = absolute_path(getenv_string("IGC_CEGIS_RUN_DIR", default_run.str()));
    const std::string original_dir = run_dir + "/original";
    const int max_iterations = getenv_int("IGC_CEGIS_MAX_ITERATIONS", 100, 1);
    const int timeout_seconds = configured_planner_timeout(planner_kind);
    const int duplicate_limit = getenv_int("IGC_CEGIS_DUPLICATE_LIMIT", 2, 1);
    const bool basic_validation = !lower_ascii(getenv_string("IGC_REFINED_VALIDATION", "basic")).compare("off") ? false : true;

    if (!mkdirs(original_dir)) return STATUS_IO_ERROR;
    const OriginalProblemContext ctx = build_context(domain, problem);
    if (ctx.original_sas_state.size() != ctx.variable_domains.size()) return STATUS_INPUT_ERROR;
    StatusCode st = dump_context_json(ctx, original_dir + "/context.json");
    if (st != STATUS_OK) return st;
    copy_file(ctx.domain_path, original_dir + "/domain.pddl");
    copy_file(ctx.problem_path, original_dir + "/problem.pddl");
    copy_file(all_groups, original_dir + "/all.groups");
    copy_file(oneof_initial, original_dir + "/oneof_initial");

    SasPddlFactMap fact_map;
    st = fact_map.load(all_groups, ctx.variable_names);
    if (st != STATUS_OK) {
        std::cerr << "[IGC-CEGIS] cannot load all.groups: " << status_name(st) << std::endl;
        return st;
    }
    InitialConstraintIR constraints;
    st = constraints.load(oneof_initial, ctx.variable_names);
    if (st != STATUS_OK) {
        std::cerr << "[IGC-CEGIS] cannot load oneof_initial: " << status_name(st) << std::endl;
        return st;
    }

    CounterexampleStore store(ctx);
    RefinedProblemWriter writer(ctx, fact_map, constraints);
    CandidatePlannerRunner runner(planner_kind);
    ActionMapper mapper;
    Counter original_driver(true);
    CounterCNF verifier(false);
    std::vector<const Operator *> candidate;

    std::cout << "[IGC-CEGIS] context=" << ctx.context_id
              << " vars=" << ctx.variable_domains.size()
              << " constraints=" << constraints.groups().size()
              << " candidate_planner=" << candidate_planner_display_name(planner_kind)
              << " planner_timeout=" << timeout_seconds
              << " run_dir=" << run_dir << std::endl;
    std::cout << "[IGC-CEGIS] legacy internal search and subplan cache are bypassed." << std::endl;
    if ((planner_kind == CANDIDATE_PLANNER_CNF ||
         planner_kind == CANDIDATE_PLANNER_DNF ||
         planner_kind == CANDIDATE_PLANNER_PIP ||
         planner_kind == CANDIDATE_PLANNER_CPAH) &&
        problem_goal_contains_or(ctx.problem_path)) {
        std::cout << "[IGC-PLANNER] warning: the bundled CPA-family PDDL front-ends "
                  << "have planner-specific handling of OR clauses in goals; "
                  << "candidate output must be treated as untrusted and will still be "
                  << "checked by the full iGC verifier." << std::endl;
    }

    VerificationResult first = verify_full_problem(ctx, &verifier, &original_driver, candidate);
    std::cout << "[IGC-VERIFY] iteration=bootstrap plan_len=0 status=" << status_name(first.status)
              << " build_ms=" << first.build_ms << " solve_ms=" << first.solve_ms
              << " extract_ms=" << first.extract_ms << std::endl;
    if (first.status == STATUS_VALID) {
        st = write_final_outputs(candidate, result_file);
        if (st == STATUS_OK)
            std::cout << "[IGC-CEGIS] no counterexample found; final conformant plan accepted." << std::endl;
        return st == STATUS_OK ? STATUS_VALID : st;
    }
    if (first.status != STATUS_COUNTEREXAMPLE) return first.status;
    bool inserted = false;
    st = store.insert(first.counterexample, 0, "kissat", "empty_plan_invalid", &inserted);
    if (st != STATUS_OK) return st;

    int duplicate_streak = 0;
    for (int iteration = 0; iteration < max_iterations; ++iteration) {
        const std::string idir = iteration_dir(run_dir, iteration);
        if (!mkdirs(idir)) return STATUS_IO_ERROR;
        st = store.dump_json(idir + "/counterexamples.json", iteration);
        if (st != STATUS_OK) return st;
        store.dump_json(run_dir + "/counterexamples.json", iteration);

        const std::string refined = idir + "/refined_" +
            candidate_planner_id(planner_kind) + "_problem.pddl";
        std::string rendered;
        RefinedRenderStats render_stats;
        const RefinedProblemWriter::Mode mode = configured_mode(planner_kind);
        const RefinedPddlProfile profile = refined_pddl_profile(planner_kind);
        st = writer.write(store, ctx.problem_path, refined, mode, profile,
                          &rendered, &render_stats);
        std::cout << "[IGC-WRITER] iteration=" << iteration
                  << " mode=" << refined_mode_name(mode)
                  << " syntax=" << refined_pddl_profile_name(profile)
                  << " counterexamples=" << store.size()
                  << " visible_worlds=" << render_stats.visible_worlds
                  << " mapped_atoms=" << render_stats.mapped_atoms
                  << " fixed_true=" << render_stats.fixed_true_atoms
                  << " fixed_false=" << render_stats.fixed_false_atoms
                  << " varying=" << render_stats.varying_atoms
                  << " unknown=" << render_stats.emitted_unknown_atoms
                  << " oneof=" << render_stats.emitted_oneof_groups
                  << " or=" << render_stats.emitted_or_groups
                  << " selectors=" << render_stats.selector_atoms
                  << " selector_implications=" << render_stats.selector_implications
                  << " icpces_complements=" << render_stats.icpces_complement_atoms
                  << " status=" << status_name(st) << std::endl;
        if (st != STATUS_OK) return st;

        std::string validation_message;
        if (basic_validation) {
            st = validate_refined(ctx, store, constraints, rendered, mode,
                                  profile, render_stats, &validation_message);
            std::ofstream vout((idir + "/validation.json").c_str());
            vout << "{\"mode\":\"BASIC\",\"status\":\"" << status_name(st)
                 << "\",\"renderer\":\"" << refined_mode_name(mode)
                 << "\",\"profile\":\"" << refined_pddl_profile_name(profile)
                 << "\",\"input_counterexamples\":" << render_stats.input_counterexamples
                 << ",\"visible_worlds\":" << render_stats.visible_worlds
                 << ",\"mapped_atoms\":" << render_stats.mapped_atoms
                 << ",\"fixed_true\":" << render_stats.fixed_true_atoms
                 << ",\"fixed_false\":" << render_stats.fixed_false_atoms
                 << ",\"varying\":" << render_stats.varying_atoms
                 << ",\"unknown_atoms\":" << render_stats.emitted_unknown_atoms
                 << ",\"oneof_groups\":" << render_stats.emitted_oneof_groups
                 << ",\"or_groups\":" << render_stats.emitted_or_groups
                 << ",\"selector_atoms\":" << render_stats.selector_atoms
                 << ",\"selector_implications\":" << render_stats.selector_implications
                 << ",\"icpces_complement_atoms\":" << render_stats.icpces_complement_atoms
                 << ",\"message\":\"" << validation_message << "\"}\n";
            std::cout << "[IGC-VALIDATE] " << validation_message << " status=" << status_name(st) << std::endl;
            if (st != STATUS_OK) return st;
        }

        std::string candidate_domain = ctx.domain_path;
        if (profile == REFINED_PDDL_CPA_FAMILY ||
            profile == REFINED_PDDL_CPAH ||
            profile == REFINED_PDDL_ICPCES) {
            candidate_domain = idir + "/refined_" +
                candidate_planner_id(planner_kind) + "_domain.pddl";
            std::string rendered_domain;
            std::size_t added_empty_parameters = 0;
            const bool cpah_compatibility = profile == REFINED_PDDL_CPAH;
            st = write_cpa_selector_domain(
                ctx, ctx.domain_path, candidate_domain,
                render_stats.selector_atoms,
                render_stats.icpces_complement_atoms, cpah_compatibility,
                &added_empty_parameters, &rendered_domain);
            std::cout << "[IGC-DOMAIN] iteration=" << iteration
                      << " profile="
                      << (cpah_compatibility
                          ? "cpah_selector_domain"
                          : (profile == REFINED_PDDL_ICPCES
                              ? "icpces_selector_domain"
                              : "cnf_dnf_pip_selector_domain"))
                      << " selectors=" << render_stats.selector_atoms
                      << " icpces_complements=" << render_stats.icpces_complement_atoms
                      << " added_empty_parameters=" << added_empty_parameters
                      << " status=" << status_name(st) << std::endl;
            if (st != STATUS_OK) return st;
        }

        std::string planner_result;
        st = runner.run(candidate_domain, refined, idir, timeout_seconds, &planner_result);
        std::cout << "[IGC-PLANNER] planner="
                  << candidate_planner_display_name(planner_kind)
                  << " iteration=" << iteration
                  << " status=" << status_name(st) << std::endl;
        if (st != STATUS_OK) {
            std::cout << "[IGC-CEGIS] candidate planner failed; original problem is NOT classified as unsolvable." << std::endl;
            return st;
        }

        std::string map_error;
        std::vector<std::string> raw;
        st = mapper.parse_and_map(planner_kind, planner_result,
                                  &candidate, &raw, &map_error);
        std::cout << "[IGC-MAP] actions=" << candidate.size() << " status=" << status_name(st);
        if (!map_error.empty()) std::cout << " message=" << map_error;
        std::cout << std::endl;
        if (st != STATUS_OK) return st;
        st = write_candidate_plan(candidate, idir + "/candidate.plan");
        if (st != STATUS_OK) return st;

        VerificationResult vr = verify_full_problem(ctx, &verifier, &original_driver, candidate);
        std::cout << "[IGC-VERIFY] iteration=" << iteration << " plan_len=" << candidate.size()
                  << " status=" << status_name(vr.status)
                  << " build_ms=" << vr.build_ms << " solve_ms=" << vr.solve_ms
                  << " extract_ms=" << vr.extract_ms << std::endl;
        if (vr.status == STATUS_VALID) {
            st = write_final_outputs(candidate, result_file);
            if (st != STATUS_OK) return st;
            std::cout << "[IGC-CEGIS] no counterexample found; final conformant plan accepted." << std::endl;
            return STATUS_VALID;
        }
        if (vr.status != STATUS_COUNTEREXAMPLE) return vr.status;
        inserted = false;
        st = store.insert(vr.counterexample, iteration + 1, "kissat",
                          "goal_or_precondition_failure", &inserted);
        if (st != STATUS_OK) return st;
        if (inserted) duplicate_streak = 0;
        else ++duplicate_streak;
        std::cout << "[IGC-STORE] size=" << store.size() << " inserted_new="
                  << (inserted ? "yes" : "no") << " duplicate_streak=" << duplicate_streak << std::endl;
        if (duplicate_streak >= duplicate_limit) {
            std::cout << "[IGC-CEGIS] repeated counterexample indicates candidate/refinement stagnation; no unsolvability conclusion." << std::endl;
            return STATUS_STAGNATION;
        }
    }
    std::cout << "[IGC-CEGIS] iteration limit reached; no unsolvability conclusion." << std::endl;
    return STATUS_ITERATION_LIMIT;
}

StatusCode run_t1_cegis_loop(const std::string &result_file) {
    return run_cegis_loop(result_file);
}

StatusCode run_cegis_self_test() {
    std::cout << "[IGC-CEGIS-SELFTEST] status names: " << status_name(STATUS_OK)
              << ", " << status_name(STATUS_PLANNER_TIMEOUT) << std::endl;
    const std::string sample = "(define (problem p) (:domain d) (:init (a) (unknown (b)) (oneof (b) (c))) (:goal (a)))";
    if (!parens_balanced(sample)) return STATUS_BACKEND_ERROR;
    const std::size_t init = find_form_start(sample, ":init");
    if (init == std::string::npos || matching_paren(sample, init) == std::string::npos)
        return STATUS_BACKEND_ERROR;
    const std::vector<std::string> flattened = normalise_init_forms(
        " (and (a) (unknown (b)) (oneof (b) (c))) ");
    if (flattened.size() != 3 || form_head(flattened[0]) != "a" ||
        form_head(flattened[1]) != "unknown" ||
        form_head(flattened[2]) != "oneof")
        return STATUS_BACKEND_ERROR;
    const std::string cpa_profile_sample =
        "(:init\n    (and\n      (a)\n      (oneof (b) (c))\n    )\n  )";
    if (lower_ascii(cpa_profile_sample).find("(unknown") != std::string::npos ||
        !parens_balanced(cpa_profile_sample))
        return STATUS_BACKEND_ERROR;

    // End-to-end renderer regression test with three binary SAS fluents.
    // This specifically covers the failure observed in run_948324: the bundled
    // mult5zsic.pl truncates ONEOF-of-complete-conjunctions at the third world.
    // The CPA renderer must therefore emit atomic selectors plus OR implications.
    {
        std::ostringstream prefix;
        prefix << "/tmp/igc_cegis_renderer_selftest_" << ::getpid();
        const std::string groups_path = prefix.str() + ".groups";
        const std::string constraints_path = prefix.str() + ".constraints";
        const std::string problem_path = prefix.str() + ".pddl";
        const std::string domain_path = prefix.str() + ".domain.pddl";
        const std::string cpa_one_path = prefix.str() + ".cpa_one.pddl";
        const std::string cpa_three_path = prefix.str() + ".cpa_three.pddl";
        const std::string cpa_domain_path = prefix.str() + ".cpa_domain.pddl";
        const std::string cpah_one_path = prefix.str() + ".cpah_one.pddl";
        const std::string cpah_three_path = prefix.str() + ".cpah_three.pddl";
        const std::string cpah_domain_path = prefix.str() + ".cpah_domain.pddl";
        const std::string t1_one_path = prefix.str() + ".t1_one.pddl";
        const std::string t1_three_path = prefix.str() + ".t1_three.pddl";
        const std::string gc_one_path = prefix.str() + ".gc_one.pddl";
        const std::string gc_three_path = prefix.str() + ".gc_three.pddl";
        const std::string gcpces_one_path = prefix.str() + ".gcpces_one.pddl";
        const std::string gcpces_three_path = prefix.str() + ".gcpces_three.pddl";
        const std::string icpces_one_path = prefix.str() + ".icpces_one.pddl";
        const std::string icpces_three_path = prefix.str() + ".icpces_three.pddl";
        const std::string icpces_domain_path = prefix.str() + ".icpces_domain.pddl";
        const std::string groups_text =
            "begin_groups\n3\n"
            "group\n1\n0 0 a 0\n"
            "group\n1\n1 0 b 0\n"
            "group\n1\n2 0 c 0\n"
            "end_groups\n";
        const std::string constraints_text =
            "ONEOF\n1\n"
            "var0\n0\n,\nvar1\n0\n,\nvar2\n0\n,\nEND_ONEOF\n";
        const std::string problem_text =
            "(define (problem selftest) (:domain d)\n"
            "  (:init (and (unknown (a)) (unknown (b)) (unknown (c))\n"
            "              (oneof (a) (b) (c))))\n"
            "  (:goal (a)))\n";
        const std::string domain_text =
            "(define (domain d) (:requirements :strips)\n"
            "  (:predicates (a) (b) (c) (tag ?x))\n"
            "  (:action noop :precondition (a) :effect (a))\n"
            "  (:action keep :parameters (?x) :precondition (a) :effect (a)))\n";
        if (!write_file_atomic(groups_path, groups_text) ||
            !write_file_atomic(constraints_path, constraints_text) ||
            !write_file_atomic(problem_path, problem_text) ||
            !write_file_atomic(domain_path, domain_text))
            return STATUS_IO_ERROR;

        OriginalProblemContext test_ctx;
        test_ctx.context_id = "selftest-1234567890";
        test_ctx.variable_names.push_back("var0");
        test_ctx.variable_names.push_back("var1");
        test_ctx.variable_names.push_back("var2");
        test_ctx.variable_domains.push_back(2);
        test_ctx.variable_domains.push_back(2);
        test_ctx.variable_domains.push_back(2);
        test_ctx.original_sas_state.push_back(1);
        test_ctx.original_sas_state.push_back(1);
        test_ctx.original_sas_state.push_back(1);

        SasPddlFactMap test_map;
        InitialConstraintIR test_constraints;
        if (test_map.load(groups_path, test_ctx.variable_names) != STATUS_OK ||
            test_constraints.load(constraints_path, test_ctx.variable_names) != STATUS_OK)
            return STATUS_BACKEND_ERROR;
        RefinedProblemWriter test_writer(test_ctx, test_map, test_constraints);

        CounterexampleStore one_store(test_ctx);
        std::vector<int> w1(3, 1);
        w1[0] = 0; // a=true, b=false, c=false
        bool added = false;
        if (one_store.insert(w1, 0, "selftest", "selftest", &added) != STATUS_OK || !added)
            return STATUS_BACKEND_ERROR;

        std::string rendered_one_cpa;
        std::string rendered_one_cpah;
        std::string rendered_one_t1;
        std::string rendered_one_gc;
        std::string rendered_one_gcpces;
        std::string rendered_one_icpces;
        RefinedRenderStats one_cpa_stats;
        RefinedRenderStats one_cpah_stats;
        RefinedRenderStats one_t1_stats;
        RefinedRenderStats one_gc_stats;
        RefinedRenderStats one_gcpces_stats;
        RefinedRenderStats one_icpces_stats;
        if (test_writer.write(one_store, problem_path, cpa_one_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_CPA_FAMILY,
                              &rendered_one_cpa, &one_cpa_stats) != STATUS_OK ||
            test_writer.write(one_store, problem_path, cpah_one_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_CPAH,
                              &rendered_one_cpah, &one_cpah_stats) != STATUS_OK ||
            test_writer.write(one_store, problem_path, t1_one_path,
                              RefinedProblemWriter::STRUCTURED_PRODUCT,
                              REFINED_PDDL_T1,
                              &rendered_one_t1, &one_t1_stats) != STATUS_OK ||
            test_writer.write(one_store, problem_path, gc_one_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_GC_FAMILY,
                              &rendered_one_gc, &one_gc_stats) != STATUS_OK ||
            test_writer.write(one_store, problem_path, gcpces_one_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_GCPCES,
                              &rendered_one_gcpces, &one_gcpces_stats) != STATUS_OK ||
            test_writer.write(one_store, problem_path, icpces_one_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_ICPCES,
                              &rendered_one_icpces, &one_icpces_stats) != STATUS_OK)
            return STATUS_BACKEND_ERROR;
        if (lower_ascii(rendered_one_cpa).find("(unknown") != std::string::npos ||
            lower_ascii(rendered_one_cpa).find("(not (b))") == std::string::npos ||
            lower_ascii(rendered_one_cpa).find("(not (c))") == std::string::npos ||
            one_cpa_stats.visible_worlds != 1 || one_cpa_stats.mapped_atoms != 3 ||
            one_cpa_stats.fixed_true_atoms != 1 || one_cpa_stats.fixed_false_atoms != 2 ||
            one_cpa_stats.selector_atoms != 0 ||
            lower_ascii(rendered_one_cpah).find("(unknown") != std::string::npos ||
            lower_ascii(rendered_one_cpah).find("(not (b))") == std::string::npos ||
            one_cpah_stats.visible_worlds != 1 || one_cpah_stats.emitted_unknown_atoms != 0 ||
            lower_ascii(rendered_one_t1).find("(unknown") != std::string::npos ||
            lower_ascii(rendered_one_t1).find("(oneof") != std::string::npos ||
            one_t1_stats.visible_worlds != 1 || one_t1_stats.varying_atoms != 0 ||
            lower_ascii(rendered_one_gc).find("(:init\n    (and") != std::string::npos ||
            lower_ascii(rendered_one_gc).find("(unknown") != std::string::npos ||
            lower_ascii(rendered_one_gc).find("(not (b))") != std::string::npos ||
            lower_ascii(rendered_one_gc).find("(oneof") != std::string::npos ||
            one_gc_stats.visible_worlds != 1 || one_gc_stats.fixed_true_atoms != 1 ||
            one_gc_stats.fixed_false_atoms != 2 || one_gc_stats.varying_atoms != 0 ||
            lower_ascii(rendered_one_gcpces).find("(:init\n    (and") == std::string::npos ||
            lower_ascii(rendered_one_gcpces).find("(not (b))") == std::string::npos ||
            lower_ascii(rendered_one_gcpces).find("(unknown") != std::string::npos ||
            one_gcpces_stats.visible_worlds != 1 || one_gcpces_stats.fixed_false_atoms != 2 ||
            lower_ascii(rendered_one_icpces).find("(:init\n    (and") == std::string::npos ||
            lower_ascii(rendered_one_icpces).find("(not (b))") == std::string::npos ||
            lower_ascii(rendered_one_icpces).find("(unknown") != std::string::npos ||
            one_icpces_stats.visible_worlds != 1 || one_icpces_stats.fixed_false_atoms != 2 ||
            one_icpces_stats.icpces_complement_atoms != 0)
            return STATUS_BACKEND_ERROR;

        CounterexampleStore three_store(test_ctx);
        if (three_store.insert(w1, 0, "selftest", "selftest", &added) != STATUS_OK)
            return STATUS_BACKEND_ERROR;
        std::vector<int> w2(3, 1);
        w2[1] = 0; // a=false, b=true, c=false
        if (three_store.insert(w2, 1, "selftest", "selftest", &added) != STATUS_OK || !added)
            return STATUS_BACKEND_ERROR;
        std::vector<int> w3(3, 1);
        w3[2] = 0; // a=false, b=false, c=true
        if (three_store.insert(w3, 2, "selftest", "selftest", &added) != STATUS_OK || !added)
            return STATUS_BACKEND_ERROR;

        std::string rendered_three_cpa;
        std::string rendered_three_cpah;
        std::string rendered_three_t1;
        std::string rendered_three_gc;
        std::string rendered_three_gcpces;
        std::string rendered_three_icpces;
        RefinedRenderStats three_cpa_stats;
        RefinedRenderStats three_cpah_stats;
        RefinedRenderStats three_t1_stats;
        RefinedRenderStats three_gc_stats;
        RefinedRenderStats three_gcpces_stats;
        RefinedRenderStats three_icpces_stats;
        if (test_writer.write(three_store, problem_path, cpa_three_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_CPA_FAMILY,
                              &rendered_three_cpa, &three_cpa_stats) != STATUS_OK ||
            test_writer.write(three_store, problem_path, cpah_three_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_CPAH,
                              &rendered_three_cpah, &three_cpah_stats) != STATUS_OK ||
            test_writer.write(three_store, problem_path, t1_three_path,
                              RefinedProblemWriter::STRUCTURED_PRODUCT,
                              REFINED_PDDL_T1,
                              &rendered_three_t1, &three_t1_stats) != STATUS_OK ||
            test_writer.write(three_store, problem_path, gc_three_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_GC_FAMILY,
                              &rendered_three_gc, &three_gc_stats) != STATUS_OK ||
            test_writer.write(three_store, problem_path, gcpces_three_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_GCPCES,
                              &rendered_three_gcpces, &three_gcpces_stats) != STATUS_OK ||
            test_writer.write(three_store, problem_path, icpces_three_path,
                              RefinedProblemWriter::EXACT_SAMPLE_SET,
                              REFINED_PDDL_ICPCES,
                              &rendered_three_icpces, &three_icpces_stats) != STATUS_OK)
            return STATUS_BACKEND_ERROR;

        const std::string cpa_three_lower = lower_ascii(rendered_three_cpa);
        const std::string cpah_three_lower = lower_ascii(rendered_three_cpah);
        const std::string t1_three_lower = lower_ascii(rendered_three_t1);
        const std::string gc_three_lower = lower_ascii(rendered_three_gc);
        const std::string gcpces_three_lower = lower_ascii(rendered_three_gcpces);
        const std::string icpces_three_lower = lower_ascii(rendered_three_icpces);
        const std::string sel0 = cpa_selector_atom(test_ctx.context_id, 0);
        const std::string sel1 = cpa_selector_atom(test_ctx.context_id, 1);
        const std::string sel2 = cpa_selector_atom(test_ctx.context_id, 2);
        const std::string neg0 = icpces_complement_atom(test_ctx.context_id, 0);
        const std::string neg1 = icpces_complement_atom(test_ctx.context_id, 1);
        const std::string neg2 = icpces_complement_atom(test_ctx.context_id, 2);
        if (cpa_three_lower.find("(unknown") != std::string::npos ||
            cpa_three_lower.find("(oneof (and") != std::string::npos ||
            cpa_three_lower.find(lower_ascii(std::string("(oneof ") + sel0 + " " + sel1 + " " + sel2 + ")")) == std::string::npos ||
            cpa_three_lower.find(lower_ascii(std::string("(or (not ") + sel0 + ") (a))")) == std::string::npos ||
            cpa_three_lower.find(lower_ascii(std::string("(or (not ") + sel0 + ") (not (b)))")) == std::string::npos ||
            three_cpa_stats.visible_worlds != 3 || three_cpa_stats.varying_atoms != 3 ||
            three_cpa_stats.selector_atoms != 3 ||
            three_cpa_stats.selector_implications != 9 ||
            three_cpa_stats.emitted_oneof_groups != 1 ||
            three_cpa_stats.emitted_or_groups != 9 ||
            cpah_three_lower.find("(unknown (a))") == std::string::npos ||
            cpah_three_lower.find("(unknown (b))") == std::string::npos ||
            cpah_three_lower.find("(unknown (c))") == std::string::npos ||
            cpah_three_lower.find(lower_ascii(std::string("(oneof ") + sel0 + " " + sel1 + " " + sel2 + ")")) == std::string::npos ||
            three_cpah_stats.visible_worlds != 3 ||
            three_cpah_stats.varying_atoms != 3 ||
            three_cpah_stats.emitted_unknown_atoms != 3 ||
            three_cpah_stats.selector_atoms != 3 ||
            three_cpah_stats.selector_implications != 9 ||
            t1_three_lower.find("(unknown (a))") == std::string::npos ||
            t1_three_lower.find("(unknown (b))") == std::string::npos ||
            t1_three_lower.find("(unknown (c))") == std::string::npos ||
            t1_three_lower.find("(oneof (a) (b) (c))") == std::string::npos ||
            three_t1_stats.visible_worlds != 3 || three_t1_stats.varying_atoms != 3 ||
            gc_three_lower.find("(:init\n    (and") != std::string::npos ||
            gc_three_lower.find("(unknown") != std::string::npos ||
            gc_three_lower.find("(or ") != std::string::npos ||
            gc_three_lower.find("(oneof") == std::string::npos ||
            gc_three_lower.find("(and (a))") == std::string::npos ||
            gc_three_lower.find("(and (b))") == std::string::npos ||
            gc_three_lower.find("(and (c))") == std::string::npos ||
            three_gc_stats.visible_worlds != 3 || three_gc_stats.varying_atoms != 3 ||
            three_gc_stats.emitted_oneof_groups != 1 ||
            three_gc_stats.emitted_or_groups != 0 ||
            three_gc_stats.emitted_unknown_atoms != 0 ||
            gcpces_three_lower.find("(:init\n    (and") == std::string::npos ||
            gcpces_three_lower.find("(unknown") != std::string::npos ||
            gcpces_three_lower.find("(oneof") == std::string::npos ||
            gcpces_three_lower.find("(and (a) (not (b)) (not (c)))") == std::string::npos ||
            gcpces_three_lower.find("(and (not (a)) (b) (not (c)))") == std::string::npos ||
            three_gcpces_stats.visible_worlds != 3 ||
            three_gcpces_stats.varying_atoms != 3 ||
            three_gcpces_stats.emitted_oneof_groups != 1 ||
            three_gcpces_stats.emitted_unknown_atoms != 0 ||
            icpces_three_lower.find("(:init\n    (and") == std::string::npos ||
            icpces_three_lower.find("(unknown") != std::string::npos ||
            icpces_three_lower.find(lower_ascii(std::string("(oneof ") + sel0 + " " + sel1 + " " + sel2 + ")")) == std::string::npos ||
            icpces_three_lower.find(lower_ascii(std::string("(oneof (a) ") + neg0 + ")")) == std::string::npos ||
            icpces_three_lower.find(lower_ascii(std::string("(oneof (b) ") + neg1 + ")")) == std::string::npos ||
            icpces_three_lower.find(lower_ascii(std::string("(oneof (c) ") + neg2 + ")")) == std::string::npos ||
            three_icpces_stats.visible_worlds != 3 ||
            three_icpces_stats.varying_atoms != 3 ||
            three_icpces_stats.emitted_unknown_atoms != 0 ||
            three_icpces_stats.emitted_oneof_groups != 4 ||
            three_icpces_stats.icpces_complement_atoms != 3 ||
            three_icpces_stats.selector_atoms != 3 ||
            three_icpces_stats.selector_implications != 9)
            return STATUS_BACKEND_ERROR;

        std::string rendered_selector_domain;
        std::string rendered_cpah_domain;
        std::string rendered_icpces_domain;
        std::size_t cpa_added_parameters = 0;
        std::size_t cpah_added_parameters = 0;
        std::size_t icpces_added_parameters = 0;
        if (write_cpa_selector_domain(test_ctx, domain_path, cpa_domain_path,
                                      three_cpa_stats.selector_atoms, 0, false,
                                      &cpa_added_parameters,
                                      &rendered_selector_domain) != STATUS_OK ||
            write_cpa_selector_domain(test_ctx, domain_path, cpah_domain_path,
                                      three_cpah_stats.selector_atoms, 0, true,
                                      &cpah_added_parameters,
                                      &rendered_cpah_domain) != STATUS_OK ||
            write_cpa_selector_domain(test_ctx, domain_path, icpces_domain_path,
                                      three_icpces_stats.selector_atoms,
                                      three_icpces_stats.icpces_complement_atoms, false,
                                      &icpces_added_parameters,
                                      &rendered_icpces_domain) != STATUS_OK ||
            lower_ascii(rendered_selector_domain).find(
                std::string("(") + lower_ascii(cpa_selector_predicate(test_ctx.context_id, 0)) + ")") == std::string::npos ||
            lower_ascii(rendered_cpah_domain).find(":parameters ()") == std::string::npos ||
            lower_ascii(rendered_cpah_domain).find(":parameters (?x)") == std::string::npos ||
            lower_ascii(rendered_icpces_domain).find(
                std::string("(") + lower_ascii(cpa_selector_predicate(test_ctx.context_id, 2)) + ")") == std::string::npos ||
            lower_ascii(rendered_icpces_domain).find(
                std::string("(") + lower_ascii(icpces_complement_predicate(test_ctx.context_id, 2)) + ")") == std::string::npos ||
            cpa_added_parameters != 0 || cpah_added_parameters != 1 ||
            icpces_added_parameters != 0 ||
            validate_cpah_action_parameter_fields(rendered_cpah_domain, NULL) != STATUS_OK ||
            !parens_balanced(rendered_selector_domain) ||
            !parens_balanced(rendered_cpah_domain) ||
            !parens_balanced(rendered_icpces_domain))
            return STATUS_BACKEND_ERROR;

        std::string validation_message;
        if (validate_refined(test_ctx, one_store, test_constraints,
                             rendered_one_cpa, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_CPA_FAMILY, one_cpa_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, one_store, test_constraints,
                             rendered_one_cpah, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_CPAH, one_cpah_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, one_store, test_constraints,
                             rendered_one_t1, RefinedProblemWriter::STRUCTURED_PRODUCT,
                             REFINED_PDDL_T1, one_t1_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, three_store, test_constraints,
                             rendered_three_cpa, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_CPA_FAMILY, three_cpa_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, three_store, test_constraints,
                             rendered_three_cpah, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_CPAH, three_cpah_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, three_store, test_constraints,
                             rendered_three_t1, RefinedProblemWriter::STRUCTURED_PRODUCT,
                             REFINED_PDDL_T1, three_t1_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, one_store, test_constraints,
                             rendered_one_gc, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_GC_FAMILY, one_gc_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, three_store, test_constraints,
                             rendered_three_gc, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_GC_FAMILY, three_gc_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, one_store, test_constraints,
                             rendered_one_gcpces, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_GCPCES, one_gcpces_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, three_store, test_constraints,
                             rendered_three_gcpces, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_GCPCES, three_gcpces_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, one_store, test_constraints,
                             rendered_one_icpces, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_ICPCES, one_icpces_stats,
                             &validation_message) != STATUS_OK ||
            validate_refined(test_ctx, three_store, test_constraints,
                             rendered_three_icpces, RefinedProblemWriter::EXACT_SAMPLE_SET,
                             REFINED_PDDL_ICPCES, three_icpces_stats,
                             &validation_message) != STATUS_OK)
            return STATUS_BACKEND_ERROR;

        std::remove(groups_path.c_str());
        std::remove(constraints_path.c_str());
        std::remove(problem_path.c_str());
        std::remove(domain_path.c_str());
        std::remove(cpa_one_path.c_str());
        std::remove(cpa_three_path.c_str());
        std::remove(cpa_domain_path.c_str());
        std::remove(cpah_one_path.c_str());
        std::remove(cpah_three_path.c_str());
        std::remove(cpah_domain_path.c_str());
        std::remove(t1_one_path.c_str());
        std::remove(t1_three_path.c_str());
        std::remove(gc_one_path.c_str());
        std::remove(gc_three_path.c_str());
        std::remove(gcpces_one_path.c_str());
        std::remove(gcpces_three_path.c_str());
        std::remove(icpces_one_path.c_str());
        std::remove(icpces_three_path.c_str());
        std::remove(icpces_domain_path.c_str());
    }

    const std::string cnf_output =
        "Found a plan of length 3:\n"
        "\"put_down(a)\" \"pick_up(b)\" \"stack(b,a)\"\n"
        "STATISTICS\n";
    const std::string dnf_output =
        "Found a plan \n"
        "\"put_down(a)\" \"pick_up(b)\" \"stack(b,a)\"\n"
        "Length: 3\nSTATISTICS\n";
    const std::string unquoted_output =
        "Found a plan of length 3:\n"
        "put_down(a) pick_up(b) stack(b,a)\n"
        "STATISTICS\n";
    const std::string omitted_output =
        "Found a plan \n\n"
        "Length: 17\nSTATISTICS\n";
    const std::string cpah_output =
        "0\n%%\n"
        "6 put_down(a) pick_up(b) unstack(b,a) unstack(a,b) "
        "put_down(b) stack(b,a) \n"
        "%%\nlinear 8 0 1 2 3 4 0 1 5\nSTATISTICS\n";
    const std::string cpah_mixed_output =
        "No plan was found.\n"
        "1\n%%\n1 pick_up(a)\n%%\nlinear 1 0\n";
    const std::string gc_lama_output =
        "Search iteration 1\n"
        "final plan\n"
        "put-down c\n"
        "pick-up b\n"
        "stack b a\n"
        "Total time: 0 seconds\n";
    const std::string igc_output =
        "规划解长度3\n"
        "没有反例，找到最终解！\n"
        "0\n"
        "put-down c\n"
        "pick-up b\n"
        "stack b a\n"
        "不能移动:0\n"
        "最终反例集大小:3\n";
    const std::string cff_output =
        "ff: parsing domain file\n"
        "domain 'BLOCKS' defined\n"
        "ff: parsing problem file\n"
        "problem 'B2' defined\n"
        "ff: found legal plan as follows\n\n"
        "step    0: STACK A B\n"
        "        1: PICK-UP A\n"
        "        2: UNSTACK A B\n"
        "        3: PUT-DOWN A\n"
        "        4: PICK-UP B\n"
        "        5: STACK B A\n"
        "\nstatistics: 0.00 seconds total time\n";
    const std::string cff_empty_output =
        "ff: goal can be simplified to TRUE. The empty plan solves it\n";
    const std::string cff_no_plan_output =
        "best first search space empty! problem proven unsolvable.\n";
    const std::string gcpces_output =
        "Domain parsed\nIteration: 3\n"
        " put-down Parameters: B  - block  \n"
        " stack Parameters: C  - block  A  - block  \n\n"
        "|pi|:2\n|S|:3\n";
    const std::string icpces_output =
        "iteration: 4\nNone\n\nfind a valid plan\n"
        "['PUT-DOWN B', 'STACK C A']\n"
        "iteration: 4\nplan length: 2\n";
    std::vector<std::string> actions;
    std::string error;
    if (extract_cpa_plan_actions(cnf_output, &actions, &error) != STATUS_OK ||
        actions.size() != 3 || actions[0] != "put_down a" ||
        actions[2] != "stack b a" ||
        canonical_symbol_text(actions[0], true) !=
            canonical_symbol_text("put-down a", true))
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cpa_plan_actions(dnf_output, &actions, &error) != STATUS_OK ||
        actions.size() != 3 || actions[1] != "pick_up b")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cpa_plan_actions(unquoted_output, &actions, &error) != STATUS_OK ||
        actions.size() != 3 || actions[2] != "stack b a")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cpa_plan_actions(omitted_output, &actions, &error) !=
            STATUS_PLANNER_PARSE_ERROR ||
        !actions.empty() ||
        error.find("omitted the action sequence") == std::string::npos)
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cpah_plan_actions(cpah_output, &actions, &error) != STATUS_OK ||
        actions.size() != 8 || actions[0] != "put_down a" ||
        actions[2] != "unstack b a" || actions[4] != "put_down b" ||
        actions[5] != "put_down a" || actions[6] != "pick_up b" ||
        actions[7] != "stack b a")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cpah_plan_actions(cpah_mixed_output, &actions, &error) != STATUS_OK ||
        actions.size() != 1 || actions[0] != "pick_up a")
        return STATUS_BACKEND_ERROR;

    actions.clear();
    error.clear();
    if (extract_cff_console_plan_actions(cff_output, &actions, &error) != STATUS_OK ||
        actions.size() != 6 || actions[0] != "STACK A B" ||
        actions[5] != "STACK B A")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cff_console_plan_actions(cff_empty_output, &actions, &error) != STATUS_OK ||
        !actions.empty())
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_cff_console_plan_actions(cff_no_plan_output, &actions, &error) !=
            STATUS_PLANNER_NO_PLAN ||
        !actions.empty())
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_gc_console_plan_actions(gc_lama_output,
                                        CANDIDATE_PLANNER_GC_LAMA,
                                        &actions, &error) != STATUS_OK ||
        actions.size() != 3 || actions[0] != "put-down c" ||
        actions[2] != "stack b a")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_gc_console_plan_actions(igc_output,
                                        CANDIDATE_PLANNER_IGC_ORIGIN,
                                        &actions, &error) != STATUS_OK ||
        actions.size() != 3 || actions[0] != "put-down c" ||
        actions[2] != "stack b a")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_gcpces_console_plan_actions(gcpces_output,
                                            &actions, &error) != STATUS_OK ||
        actions.size() != 2 || actions[0] != "put-down B" ||
        actions[1] != "stack C A")
        return STATUS_BACKEND_ERROR;
    actions.clear();
    error.clear();
    if (extract_icpces_console_plan_actions(icpces_output,
                                            &actions, &error) != STATUS_OK ||
        actions.size() != 2 || actions[0] != "PUT-DOWN B" ||
        actions[1] != "STACK C A")
        return STATUS_BACKEND_ERROR;

    struct ExternalLogCheck {
        const char *env_name;
        const char *planner_name;
        CandidatePlannerKind kind;
    };
    const ExternalLogCheck checks[] = {
        {"IGC_CNF_TEST_OUTPUT", "CNF", CANDIDATE_PLANNER_CNF},
        {"IGC_DNF_TEST_OUTPUT", "DNF", CANDIDATE_PLANNER_DNF},
        {"IGC_PIP_TEST_OUTPUT", "PIP", CANDIDATE_PLANNER_PIP},
        {"IGC_CPAH_TEST_OUTPUT", "CPAH", CANDIDATE_PLANNER_CPAH},
        {"IGC_IGC_TEST_OUTPUT", "iGC", CANDIDATE_PLANNER_IGC_ORIGIN},
        {"IGC_GC_LAMA_TEST_OUTPUT", "GC-LAMA", CANDIDATE_PLANNER_GC_LAMA},
        {"IGC_GCPCES_TEST_OUTPUT", "gCPCES", CANDIDATE_PLANNER_GCPCES},
        {"IGC_ICPCES_TEST_OUTPUT", "iCPCES", CANDIDATE_PLANNER_ICPCES}
    };
    for (std::size_t i = 0; i < sizeof(checks) / sizeof(checks[0]); ++i) {
        const std::string path = getenv_string(checks[i].env_name, "");
        if (path.empty()) continue;
        std::string text;
        if (!read_file(path, &text)) {
            std::cerr << "[IGC-CEGIS-SELFTEST] cannot read "
                      << checks[i].planner_name << " output: " << path << std::endl;
            return STATUS_IO_ERROR;
        }
        actions.clear();
        error.clear();
        StatusCode parsed = STATUS_PLANNER_PARSE_ERROR;
        if (checks[i].kind == CANDIDATE_PLANNER_CPAH)
            parsed = extract_cpah_plan_actions(text, &actions, &error);
        else if (checks[i].kind == CANDIDATE_PLANNER_IGC_ORIGIN ||
                 checks[i].kind == CANDIDATE_PLANNER_GC_LAMA)
            parsed = extract_gc_console_plan_actions(text, checks[i].kind,
                                                     &actions, &error);
        else if (checks[i].kind == CANDIDATE_PLANNER_GCPCES)
            parsed = extract_gcpces_console_plan_actions(text, &actions, &error);
        else if (checks[i].kind == CANDIDATE_PLANNER_ICPCES)
            parsed = extract_icpces_console_plan_actions(text, &actions, &error);
        else
            parsed = extract_cpa_plan_actions(text, &actions, &error);
        std::cout << "[IGC-CEGIS-SELFTEST] planner=" << checks[i].planner_name
                  << " status=" << status_name(parsed)
                  << " actions=" << actions.size();
        if (!error.empty()) std::cout << " message=" << error;
        std::cout << std::endl;
        if (parsed != STATUS_OK) return parsed;
    }

    std::cout << "[IGC-CEGIS-SELFTEST] selector-exact CPA/CPA(H) rendering, exact iGC/GC-LAMA world-oneof rendering, CPA(H) action-field preservation/normalisation, simplified T1/CFF rendering, CFF console parsing, "
              << "init normalisation, CNF/DNF/PIP parsing, CPAH linear-trace expansion, iGC/GC-LAMA final-plan parsing, and gCPCES/iCPCES renderer/parser checks passed." << std::endl;
    return STATUS_OK;
}

} // namespace igc_cegis
