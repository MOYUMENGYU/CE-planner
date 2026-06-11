#ifndef IGC_CEGIS_FRAMEWORK_H
#define IGC_CEGIS_FRAMEWORK_H

#include <string>

namespace igc_cegis {

enum StatusCode {
    STATUS_OK = 0,
    STATUS_VALID = 1,
    STATUS_COUNTEREXAMPLE = 2,
    STATUS_INPUT_ERROR = 10,
    STATUS_MAPPING_ERROR = 11,
    STATUS_PLANNER_TIMEOUT = 12,
    STATUS_PLANNER_PARSE_ERROR = 13,
    STATUS_PLANNER_FAILED = 14,
    STATUS_BACKEND_ERROR = 15,
    STATUS_IO_ERROR = 16,
    STATUS_ITERATION_LIMIT = 17,
    STATUS_STAGNATION = 18,
    STATUS_PLANNER_NO_PLAN = 19,
    STATUS_UNSUPPORTED_INPUT = 20
};

const char *status_name(StatusCode code);

// Returns true when the environment explicitly enables the external-planner
// counterexample-guided loop.
bool enabled_from_environment();

// Runs the external candidate-planner CEGIS loop. The planner is selected by
// IGC_CANDIDATE_PLANNER=t1|cnf|dnf|pip|cpah. The preprocessed task must already
// have been loaded into the existing iGC globals by read_everything().
StatusCode run_cegis_loop(const std::string &result_file);

// Backward-compatible alias retained for existing callers/scripts.
StatusCode run_t1_cegis_loop(const std::string &result_file);

// Lightweight parser/writer self-test used by the supplied test script.
StatusCode run_cegis_self_test();

} // namespace igc_cegis

#endif
