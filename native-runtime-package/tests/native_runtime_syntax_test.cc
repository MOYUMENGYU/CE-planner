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
enum CandidateRuntimeMode { CANDIDATE_RUNTIME_NATIVE, CANDIDATE_RUNTIME_ISOLATED };
enum StatusCode {
 STATUS_OK, STATUS_VALID, STATUS_COUNTEREXAMPLE, STATUS_INPUT_ERROR,
 STATUS_MAPPING_ERROR, STATUS_PLANNER_TIMEOUT, STATUS_PLANNER_PARSE_ERROR,
 STATUS_PLANNER_FAILED, STATUS_BACKEND_ERROR, STATUS_IO_ERROR,
 STATUS_ITERATION_LIMIT, STATUS_STAGNATION, STATUS_PLANNER_NO_PLAN,
 STATUS_UNSUPPORTED_INPUT
};

static std::string getenv_string(const char*, const std::string &d) { return d; }
static bool copy_file(const std::string&, const std::string&) { return true; }
static bool read_file(const std::string&, std::string *s) { *s = "Found a plan of length 1 (a)"; return true; }
static bool write_file_atomic(const std::string&, const std::string&) { return true; }
static std::string absolute_path(const std::string &s) { return s; }
static bool executable_file(const std::string&) { return true; }
static std::string path_dirname(const std::string&) { return "."; }
static std::string shell_quote(const std::string &s) { return s; }
static std::string one_line_excerpt(const std::string&, std::size_t) { return ""; }
static std::string lower_ascii(const std::string &s) { return s; }
static std::string trim(const std::string &s) { return s; }
static bool contains_no_plan_marker(const std::string&) { return false; }
static bool contains_cpa_success_marker(const std::string&) { return true; }
static bool readable_regular_file(const std::string&) { return true; }
static bool readable_directory(const std::string&) { return true; }
static bool env_true(const char*, bool d) { return d; }
static const char *candidate_planner_display_name(CandidatePlannerKind) { return "X"; }
static StatusCode run_shell_command(const std::string&, int, const std::string&, int *e, int *s) { *e=0; *s=0; return STATUS_OK; }
static bool write_plain_plan_artifact(const std::vector<std::string>&, const std::string&) { return true; }
static StatusCode extract_cff_console_plan_actions(const std::string&, std::vector<std::string> *a, std::string*) { a->push_back("a"); return STATUS_OK; }
static StatusCode extract_gc_console_plan_actions(const std::string&, CandidatePlannerKind, std::vector<std::string> *a, std::string*) { a->push_back("a"); return STATUS_OK; }
static StatusCode extract_plain_plan_actions(const std::string&, std::vector<std::string> *a, std::string*) { a->push_back("a"); return STATUS_OK; }
static StatusCode extract_cpah_plan_actions(const std::string&, std::vector<std::string> *a, std::string*) { a->push_back("a"); return STATUS_OK; }
static StatusCode extract_gcpces_console_plan_actions(const std::string&, std::vector<std::string> *a, std::string*) { a->push_back("a"); return STATUS_OK; }
static StatusCode extract_cpa_plan_actions(const std::string&, std::vector<std::string> *a, std::string*) { a->push_back("a"); return STATUS_OK; }

class CandidatePlannerRunner {
public:
    CandidatePlannerRunner(CandidatePlannerKind k) : kind_(k) {}
private:
    static void print_common_diagnostics(const std::string&, const std::string&, const std::string&, const std::string&) {}
    StatusCode run_icpces(const std::string&, const std::string&, const std::string&, int, std::string*) const { return STATUS_OK; }
    std::string cff_runtime_root() const { return "."; }
    std::string gc_family_runtime_root() const { return "."; }
    StatusCode normalize_gc_family_frontend(const std::string&, const std::string&, bool, std::string*) const { return STATUS_OK; }
    std::string gcpces_runtime_root() const { return "."; }
    std::string cpa_runtime_root() const { return "."; }
    std::string cpa_binary_name() const { return "dnf"; }
#include "cegis_native_runtime.inc"
    CandidatePlannerKind kind_;
};
int main() { return 0; }
