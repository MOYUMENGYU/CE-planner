#ifndef SMT_COUNTER_H
#define SMT_COUNTER_H

#include <map>
#include <set>
#include <string>
#include <vector>

class SMT_counter {
public:
    enum Status {
        STATUS_INVALID = 0,
        STATUS_SAT = 1,
        STATUS_UNSAT = 2,
        STATUS_UNKNOWN = 3
    };

    struct SolveReport {
        int requested_backend;
        int used_backend;
        bool requested_backend_available;
        bool used_fallback_solver;
        bool parse_ok;
        bool result_valid;
        Status status;
        int model_const_count;
        std::string error_message;
        SolveReport()
            : requested_backend(0), used_backend(0), requested_backend_available(false),
              used_fallback_solver(false), parse_ok(false), result_valid(false),
              status(STATUS_INVALID), model_const_count(0), error_message() {}
    };

    SMT_counter();
    ~SMT_counter();

    bool extractCounter(const std::string &smt_script,
                        const std::set<std::string> &declared_bool_vars,
                        std::map<int, int> *sample,
                        SolveReport *report);

private:
    struct ExprNode {
        enum Kind {
            EXPR_TRUE,
            EXPR_FALSE,
            EXPR_VAR,
            EXPR_NOT,
            EXPR_AND,
            EXPR_OR,
            EXPR_EQ
        } kind;
        std::string symbol;
        std::vector<ExprNode *> children;
        explicit ExprNode(Kind k) : kind(k), symbol(), children() {}
    };

    struct ParsedProblem {
        std::vector<std::string> declarations;
        std::vector<ExprNode *> assertions;
    };

    struct TokenStream {
        std::vector<std::string> tokens;
        size_t pos;
        TokenStream() : tokens(), pos(0) {}
    };

private:
    std::vector<ExprNode *> owned_nodes_;

private:
    ExprNode *newNode(ExprNode::Kind kind);
    void deleteOwnedNodes();

    bool tokenize(const std::string &input,
                  TokenStream *stream,
                  std::string *error_message) const;
    bool parseProblem(const std::string &input,
                      ParsedProblem *problem,
                      std::string *error_message);
    bool parseCommand(TokenStream *stream,
                      ParsedProblem *problem,
                      std::string *error_message);
    ExprNode *parseExpr(TokenStream *stream, std::string *error_message);

    static bool parseVarAssignmentAtTimeZero(const std::string &name,
                                             int *var,
                                             int *val,
                                             int *timestep);

    bool extractCounterForBackend(int backend,
                                  const ParsedProblem &problem,
                                  const std::set<std::string> &declared_bool_vars,
                                  std::map<int, int> *sample,
                                  SolveReport *report);
    bool extractCounterWithRequestedOrFallback(const ParsedProblem &problem,
                                               const std::set<std::string> &declared_bool_vars,
                                               std::map<int, int> *sample,
                                               SolveReport *report);

    bool extractCounterZ3(const ParsedProblem &problem,
                          const std::set<std::string> &declared_bool_vars,
                          std::map<int, int> *sample,
                          SolveReport *report);
    bool extractCounterCVC4(const ParsedProblem &problem,
                            const std::set<std::string> &declared_bool_vars,
                            std::map<int, int> *sample,
                            SolveReport *report);
    bool extractCounterMathSAT5(const ParsedProblem &problem,
                                const std::set<std::string> &declared_bool_vars,
                                std::map<int, int> *sample,
                                SolveReport *report);
    bool extractCounterYices2(const ParsedProblem &problem,
                              const std::set<std::string> &declared_bool_vars,
                              std::map<int, int> *sample,
                              SolveReport *report);
};

#endif
