#include "smt_counter.h"
#include "globals.h"

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <map>
#include <sstream>
#include <stdexcept>

#include <z3++.h>

#ifdef USE_SMT_CVC4
#include <cvc4/cvc4.h>
#endif

#ifdef USE_SMT_MATHSAT5
#include <mathsat.h>
#endif

#ifdef USE_SMT_YICES2
#include <yices.h>
#endif

using namespace std;

namespace {

static bool isDigits(const std::string &text) {
    if(text.empty())
        return false;
    for(size_t i = 0; i < text.size(); ++i) {
        if(!std::isdigit(static_cast<unsigned char>(text[i])))
            return false;
    }
    return true;
}

static bool insert_time_zero_assignment(std::map<int, int> *sample,
                                        int var,
                                        int val,
                                        std::string *error_message,
                                        const std::string &backend_name) {
    if(!sample)
        return true;
    std::map<int, int>::iterator it = sample->find(var);
    if(it != sample->end() && it->second != val) {
        if(error_message) {
            std::ostringstream oss;
            oss << backend_name << " 模型对同一 time0 变量给出了多个不同取值: var="
                << var << ", old=" << it->second << ", new=" << val;
            *error_message = oss.str();
        }
        return false;
    }
    (*sample)[var] = val;
    return true;
}

#ifdef USE_SMT_MATHSAT5
static std::string mathsat_term_to_string(msat_term t) {
    char *repr = msat_term_repr(t);
    if(repr == 0)
        return std::string();
    std::string result(repr);
    msat_free(repr);
    return result;
}

static std::string trim_copy(const std::string &text) {
    size_t begin = 0;
    while(begin < text.size() && std::isspace(static_cast<unsigned char>(text[begin])))
        ++begin;
    size_t end = text.size();
    while(end > begin && std::isspace(static_cast<unsigned char>(text[end - 1])))
        --end;
    return text.substr(begin, end - begin);
}

static std::string normalize_mathsat_bool_repr(std::string repr) {
    repr = trim_copy(repr);
    while(repr.size() >= 2 && repr[0] == '(' && repr[repr.size() - 1] == ')')
        repr = trim_copy(repr.substr(1, repr.size() - 2));
    for(size_t i = 0; i < repr.size(); ++i)
        repr[i] = static_cast<char>(std::tolower(static_cast<unsigned char>(repr[i])));
    return repr;
}

static bool decode_mathsat_bool_value(msat_env env,
                                      msat_term value,
                                      bool *out_value,
                                      std::string *repr_out) {
    if(MSAT_ERROR_TERM(value) || !out_value)
        return false;

    if(msat_term_is_true(env, value)) {
        *out_value = true;
        if(repr_out)
            *repr_out = "true";
        return true;
    }
    if(msat_term_is_false(env, value)) {
        *out_value = false;
        if(repr_out)
            *repr_out = "false";
        return true;
    }

    std::string repr = normalize_mathsat_bool_repr(mathsat_term_to_string(value));
    if(repr_out)
        *repr_out = repr;
    if(repr == "true") {
        *out_value = true;
        return true;
    }
    if(repr == "false") {
        *out_value = false;
        return true;
    }
    return false;
}
#endif

} // namespace

SMT_counter::SMT_counter() {
}

SMT_counter::~SMT_counter() {
    deleteOwnedNodes();
}

SMT_counter::ExprNode *SMT_counter::newNode(ExprNode::Kind kind) {
    ExprNode *node = new ExprNode(kind);
    owned_nodes_.push_back(node);
    return node;
}

void SMT_counter::deleteOwnedNodes() {
    for(size_t i = 0; i < owned_nodes_.size(); ++i)
        delete owned_nodes_[i];
    owned_nodes_.clear();
}

bool SMT_counter::tokenize(const std::string &input,
                           TokenStream *stream,
                           std::string *error_message) const {
    stream->tokens.clear();
    stream->pos = 0;
    std::string current;
    for(size_t i = 0; i < input.size(); ++i) {
        char ch = input[i];
        if(ch == ';') {
            while(i < input.size() && input[i] != '\n')
                ++i;
            continue;
        }
        if(std::isspace(static_cast<unsigned char>(ch))) {
            if(!current.empty()) {
                stream->tokens.push_back(current);
                current.clear();
            }
            continue;
        }
        if(ch == '(' || ch == ')') {
            if(!current.empty()) {
                stream->tokens.push_back(current);
                current.clear();
            }
            stream->tokens.push_back(std::string(1, ch));
            continue;
        }
        current += ch;
    }
    if(!current.empty())
        stream->tokens.push_back(current);
    if(stream->tokens.empty()) {
        if(error_message)
            *error_message = "SMT 脚本为空";
        return false;
    }
    return true;
}

bool SMT_counter::parseProblem(const std::string &input,
                               ParsedProblem *problem,
                               std::string *error_message) {
    deleteOwnedNodes();
    problem->declarations.clear();
    problem->assertions.clear();

    TokenStream stream;
    if(!tokenize(input, &stream, error_message))
        return false;

    while(stream.pos < stream.tokens.size()) {
        if(!parseCommand(&stream, problem, error_message))
            return false;
    }
    return true;
}

bool SMT_counter::parseCommand(TokenStream *stream,
                               ParsedProblem *problem,
                               std::string *error_message) {
    if(stream->pos >= stream->tokens.size() || stream->tokens[stream->pos] != "(") {
        if(error_message)
            *error_message = "命令应以 '(' 开始";
        return false;
    }
    ++stream->pos;
    if(stream->pos >= stream->tokens.size()) {
        if(error_message)
            *error_message = "命令缺少操作符";
        return false;
    }
    const std::string op = stream->tokens[stream->pos++];
    if(op == "declare-const") {
        if(stream->pos + 1 >= stream->tokens.size()) {
            if(error_message)
                *error_message = "declare-const 参数不完整";
            return false;
        }
        const std::string name = stream->tokens[stream->pos++];
        const std::string type = stream->tokens[stream->pos++];
        if(type != "Bool") {
            if(error_message)
                *error_message = "当前仅支持 Bool 变量声明";
            return false;
        }
        if(stream->pos >= stream->tokens.size() || stream->tokens[stream->pos] != ")") {
            if(error_message)
                *error_message = "declare-const 缺少 ')'";
            return false;
        }
        ++stream->pos;
        problem->declarations.push_back(name);
        return true;
    }
    if(op == "assert") {
        ExprNode *expr = parseExpr(stream, error_message);
        if(!expr)
            return false;
        if(stream->pos >= stream->tokens.size() || stream->tokens[stream->pos] != ")") {
            if(error_message)
                *error_message = "assert 缺少 ')'";
            return false;
        }
        ++stream->pos;
        problem->assertions.push_back(expr);
        return true;
    }
    if(op == "check-sat" || op == "get-model") {
        if(stream->pos >= stream->tokens.size() || stream->tokens[stream->pos] != ")") {
            if(error_message)
                *error_message = op + " 缺少 ')'";
            return false;
        }
        ++stream->pos;
        return true;
    }
    if(error_message)
        *error_message = "不支持的 SMT 命令: " + op;
    return false;
}

SMT_counter::ExprNode *SMT_counter::parseExpr(TokenStream *stream, std::string *error_message) {
    if(stream->pos >= stream->tokens.size()) {
        if(error_message)
            *error_message = "表达式意外结束";
        return 0;
    }
    const std::string token = stream->tokens[stream->pos++];
    if(token == "true")
        return newNode(ExprNode::EXPR_TRUE);
    if(token == "false")
        return newNode(ExprNode::EXPR_FALSE);
    if(token != "(") {
        ExprNode *node = newNode(ExprNode::EXPR_VAR);
        node->symbol = token;
        return node;
    }

    if(stream->pos >= stream->tokens.size()) {
        if(error_message)
            *error_message = "复合表达式缺少操作符";
        return 0;
    }
    const std::string op = stream->tokens[stream->pos++];
    ExprNode *node = 0;
    if(op == "not") {
        node = newNode(ExprNode::EXPR_NOT);
        ExprNode *child = parseExpr(stream, error_message);
        if(!child)
            return 0;
        node->children.push_back(child);
    } else if(op == "and") {
        node = newNode(ExprNode::EXPR_AND);
        while(stream->pos < stream->tokens.size() && stream->tokens[stream->pos] != ")") {
            ExprNode *child = parseExpr(stream, error_message);
            if(!child)
                return 0;
            node->children.push_back(child);
        }
    } else if(op == "or") {
        node = newNode(ExprNode::EXPR_OR);
        while(stream->pos < stream->tokens.size() && stream->tokens[stream->pos] != ")") {
            ExprNode *child = parseExpr(stream, error_message);
            if(!child)
                return 0;
            node->children.push_back(child);
        }
    } else if(op == "=") {
        node = newNode(ExprNode::EXPR_EQ);
        ExprNode *lhs = parseExpr(stream, error_message);
        ExprNode *rhs = parseExpr(stream, error_message);
        if(!lhs || !rhs)
            return 0;
        node->children.push_back(lhs);
        node->children.push_back(rhs);
        if(stream->pos < stream->tokens.size() && stream->tokens[stream->pos] != ")") {
            if(error_message)
                *error_message = "当前仅支持二元 '='";
            return 0;
        }
    } else {
        if(error_message)
            *error_message = "不支持的表达式操作符: " + op;
        return 0;
    }

    if(stream->pos >= stream->tokens.size() || stream->tokens[stream->pos] != ")") {
        if(error_message)
            *error_message = "表达式缺少 ')'";
        return 0;
    }
    ++stream->pos;
    return node;
}

bool SMT_counter::parseVarAssignmentAtTimeZero(const std::string &name,
                                               int *var,
                                               int *val,
                                               int *timestep) {
    size_t last_dash = name.rfind('-');
    if(last_dash == std::string::npos)
        return false;
    size_t second_last_dash = name.rfind('-', last_dash - 1);
    if(second_last_dash == std::string::npos)
        return false;

    std::string prefix = name.substr(0, second_last_dash);
    std::string val_text = name.substr(second_last_dash + 1, last_dash - second_last_dash - 1);
    std::string time_text = name.substr(last_dash + 1);
    if(!isDigits(val_text) || !isDigits(time_text))
        return false;

    int parsed_var = 0;
    bool has_digit = false;
    for(size_t i = 0; i < prefix.size(); ++i) {
        if(std::isdigit(static_cast<unsigned char>(prefix[i]))) {
            has_digit = true;
            parsed_var = parsed_var * 10 + (prefix[i] - '0');
        }
    }
    if(!has_digit)
        return false;

    if(var)
        *var = parsed_var;
    if(val)
        *val = atoi(val_text.c_str());
    if(timestep)
        *timestep = atoi(time_text.c_str());
    return true;
}

bool SMT_counter::extractCounter(const std::string &smt_script,
                                 const std::set<std::string> &declared_bool_vars,
                                 std::map<int, int> *sample,
                                 SolveReport *report) {
    if(sample)
        sample->clear();
    if(report)
        *report = SolveReport();
    if(report) {
        report->requested_backend = (int)g_smt_solver_backend;
        report->used_backend = (int)g_smt_solver_backend;
    }

    ParsedProblem problem;
    std::string parse_error;
    bool parsed = parseProblem(smt_script, &problem, &parse_error);
    if(report)
        report->parse_ok = parsed;
    if(!parsed) {
        if(report) {
            report->error_message = parse_error;
            report->result_valid = false;
        }
        return false;
    }

    return extractCounterWithRequestedOrFallback(problem, declared_bool_vars, sample, report);
}

bool SMT_counter::extractCounterWithRequestedOrFallback(const ParsedProblem &problem,
                                                        const std::set<std::string> &declared_bool_vars,
                                                        std::map<int, int> *sample,
                                                        SolveReport *report) {
    if(!report)
        return extractCounterForBackend((int)g_smt_solver_backend, problem, declared_bool_vars, sample, 0);

    SolveReport try_report = *report;
    bool found = extractCounterForBackend(report->requested_backend, problem, declared_bool_vars, sample, &try_report);
    if(try_report.requested_backend_available && try_report.result_valid) {
        *report = try_report;
        return found;
    }

    if(report->requested_backend != (int)SMT_SOLVER_Z3) {
        SolveReport fallback_report = *report;
        fallback_report.requested_backend = report->requested_backend;
        fallback_report.used_backend = (int)SMT_SOLVER_Z3;
        bool fallback_found = extractCounterForBackend((int)SMT_SOLVER_Z3,
                                                       problem,
                                                       declared_bool_vars,
                                                       sample,
                                                       &fallback_report);
        if(fallback_report.result_valid) {
            fallback_report.used_fallback_solver = true;
            fallback_report.requested_backend_available = try_report.requested_backend_available;
            if(!try_report.error_message.empty()) {
                if(!fallback_report.error_message.empty())
                    fallback_report.error_message += " | ";
                fallback_report.error_message += "原请求后端信息: " + try_report.error_message;
            }
            *report = fallback_report;
            return fallback_found;
        }
        *report = fallback_report;
        return false;
    }

    *report = try_report;
    return found;
}

bool SMT_counter::extractCounterForBackend(int backend,
                                           const ParsedProblem &problem,
                                           const std::set<std::string> &declared_bool_vars,
                                           std::map<int, int> *sample,
                                           SolveReport *report) {
    if(report) {
        report->used_backend = backend;
        report->used_fallback_solver = false;
    }
    switch(backend) {
    case SMT_SOLVER_Z3:
        return extractCounterZ3(problem, declared_bool_vars, sample, report);
    case SMT_SOLVER_CVC4:
        return extractCounterCVC4(problem, declared_bool_vars, sample, report);
    case SMT_SOLVER_MATHSAT5:
        return extractCounterMathSAT5(problem, declared_bool_vars, sample, report);
    case SMT_SOLVER_YICES2:
        return extractCounterYices2(problem, declared_bool_vars, sample, report);
    default:
        if(report) {
            report->requested_backend_available = false;
            report->result_valid = false;
            report->error_message = "未知 SMT 后端";
        }
        return false;
    }
}

bool SMT_counter::extractCounterZ3(const ParsedProblem &problem,
                                   const std::set<std::string> &declared_bool_vars,
                                   std::map<int, int> *sample,
                                   SolveReport *report) {
    if(report)
        report->requested_backend_available = true;
    try {
        z3::context c;
        z3::solver s(c);
        std::map<std::string, z3::expr> vars;
        for(size_t i = 0; i < problem.declarations.size(); ++i) {
            vars.insert(std::make_pair(problem.declarations[i], c.bool_const(problem.declarations[i].c_str())));
        }

        std::function<z3::expr(ExprNode*)> build = [&](ExprNode *node) -> z3::expr {
            switch(node->kind) {
            case ExprNode::EXPR_TRUE:
                return c.bool_val(true);
            case ExprNode::EXPR_FALSE:
                return c.bool_val(false);
            case ExprNode::EXPR_VAR: {
                std::map<std::string, z3::expr>::iterator it = vars.find(node->symbol);
                if(it == vars.end())
                    throw std::runtime_error("未声明变量: " + node->symbol);
                return it->second;
            }
            case ExprNode::EXPR_NOT:
                return !build(node->children[0]);
            case ExprNode::EXPR_AND: {
                if(node->children.empty())
                    return c.bool_val(true);
                z3::expr result = build(node->children[0]);
                for(size_t i = 1; i < node->children.size(); ++i)
                    result = result && build(node->children[i]);
                return result;
            }
            case ExprNode::EXPR_OR: {
                if(node->children.empty())
                    return c.bool_val(false);
                z3::expr result = build(node->children[0]);
                for(size_t i = 1; i < node->children.size(); ++i)
                    result = result || build(node->children[i]);
                return result;
            }
            case ExprNode::EXPR_EQ:
                return build(node->children[0]) == build(node->children[1]);
            }
            throw std::runtime_error("内部错误：未知 AST 节点");
        };

        for(size_t i = 0; i < problem.assertions.size(); ++i)
            s.add(build(problem.assertions[i]));

        z3::check_result cr = s.check();
        if(cr == z3::sat) {
            z3::model m = s.get_model();
            if(report) {
                report->status = STATUS_SAT;
                report->result_valid = true;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = "";
            }
            if(sample) sample->clear();
            for(std::set<std::string>::const_iterator it = declared_bool_vars.begin(); it != declared_bool_vars.end(); ++it) {
                std::map<std::string, z3::expr>::iterator vit = vars.find(*it);
                if(vit == vars.end())
                    continue;
                z3::expr value = m.eval(vit->second, true);
                if(value.is_bool() && Z3_get_bool_value(c, value) == Z3_L_TRUE) {
                    int var = 0, val = 0, timestep = -1;
                    if(parseVarAssignmentAtTimeZero(*it, &var, &val, &timestep) && timestep == 0) {
                        if(!insert_time_zero_assignment(sample, var, val,
                                                        report ? &report->error_message : 0,
                                                        "Z3")) {
                            if(report) {
                                report->status = STATUS_INVALID;
                                report->result_valid = false;
                            }
                            return false;
                        }
                    }
                }
            }
            std::cout << "找到反例！" << std::endl;
            std::cout << "SMT变量数:" << problem.declarations.size() << std::endl;
            return true;
        }
        if(cr == z3::unsat) {
            if(report) {
                report->status = STATUS_UNSAT;
                report->result_valid = true;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = "";
            }
            std::cout << "没有反例，找到最终解！" << std::endl;
            return false;
        }
        if(report) {
            report->status = STATUS_UNKNOWN;
            report->result_valid = false;
            report->model_const_count = (int)problem.declarations.size();
            report->error_message = "Z3 返回 unknown";
        }
        std::cout << "unknown!!" << std::endl;
        return false;
    } catch(const std::exception &e) {
        if(report) {
            report->status = STATUS_INVALID;
            report->result_valid = false;
            report->error_message = std::string("Z3 异常: ") + e.what();
        }
        return false;
    }
}

bool SMT_counter::extractCounterCVC4(const ParsedProblem &problem,
                                     const std::set<std::string> &declared_bool_vars,
                                     std::map<int, int> *sample,
                                     SolveReport *report) {
#ifndef USE_SMT_CVC4
    (void)problem; (void)declared_bool_vars; (void)sample;
    if(report) {
        report->requested_backend_available = false;
        report->result_valid = false;
        report->error_message = "CVC4 未编译启用（需 -DUSE_SMT_CVC4 并链接 CVC4 库）";
    }
    return false;
#else
    if(report)
        report->requested_backend_available = true;
    try {
        CVC4::ExprManager em;
        CVC4::SmtEngine smt(&em);
        smt.setOption("produce-models", CVC4::SExpr("true"));
        try {
            smt.setLogic("QF_BOOL");
        } catch(...) {
        }
        std::map<std::string, CVC4::Expr> vars;
        CVC4::Type boolType = em.booleanType();
        for(size_t i = 0; i < problem.declarations.size(); ++i)
            vars.insert(std::make_pair(problem.declarations[i], em.mkVar(problem.declarations[i], boolType)));

        std::function<CVC4::Expr(ExprNode*)> build = [&](ExprNode *node) -> CVC4::Expr {
            switch(node->kind) {
            case ExprNode::EXPR_TRUE:
                return em.mkConst(true);
            case ExprNode::EXPR_FALSE:
                return em.mkConst(false);
            case ExprNode::EXPR_VAR: {
                std::map<std::string, CVC4::Expr>::iterator it = vars.find(node->symbol);
                if(it == vars.end())
                    throw std::runtime_error("未声明变量: " + node->symbol);
                return it->second;
            }
            case ExprNode::EXPR_NOT:
                return em.mkExpr(CVC4::kind::NOT, build(node->children[0]));
            case ExprNode::EXPR_AND: {
                if(node->children.empty())
                    return em.mkConst(true);
                if(node->children.size() == 1)
                    return build(node->children[0]);
                std::vector<CVC4::Expr> args;
                for(size_t i = 0; i < node->children.size(); ++i)
                    args.push_back(build(node->children[i]));
                return em.mkExpr(CVC4::kind::AND, args);
            }
            case ExprNode::EXPR_OR: {
                if(node->children.empty())
                    return em.mkConst(false);
                if(node->children.size() == 1)
                    return build(node->children[0]);
                std::vector<CVC4::Expr> args;
                for(size_t i = 0; i < node->children.size(); ++i)
                    args.push_back(build(node->children[i]));
                return em.mkExpr(CVC4::kind::OR, args);
            }
            case ExprNode::EXPR_EQ:
                return em.mkExpr(CVC4::kind::EQUAL, build(node->children[0]), build(node->children[1]));
            }
            throw std::runtime_error("内部错误：未知 AST 节点");
        };

        for(size_t i = 0; i < problem.assertions.size(); ++i)
            smt.assertFormula(build(problem.assertions[i]));

        CVC4::Result result = smt.checkSat();

        std::ostringstream result_ss;
        result_ss << result;
        const std::string result_str = result_ss.str();

        if(result.isSat()) {
            if(report) {
                report->status = STATUS_SAT;
                report->result_valid = true;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = "";
            }
            if(sample) sample->clear();
            int extracted_time0_assignments = 0;
            for(std::set<std::string>::const_iterator it = declared_bool_vars.begin();
                it != declared_bool_vars.end(); ++it) {
                std::map<std::string, CVC4::Expr>::iterator vit = vars.find(*it);
                if(vit == vars.end())
                    continue;
                try {
                    CVC4::Expr value = smt.getValue(vit->second);
                    if(value.isConst() && value.getConst<bool>()) {
                        int var = 0, val = 0, timestep = -1;
                        if(parseVarAssignmentAtTimeZero(*it, &var, &val, &timestep) && timestep == 0) {
                            if(!insert_time_zero_assignment(sample, var, val,
                                                            report ? &report->error_message : 0,
                                                            "CVC4")) {
                                if(report) {
                                    report->status = STATUS_INVALID;
                                    report->result_valid = false;
                                }
                                return false;
                            }
                            ++extracted_time0_assignments;
                        }
                    }
                } catch(const std::exception &) {
                    continue;
                }
            }
            if(report && extracted_time0_assignments == 0) {
                report->status = STATUS_INVALID;
                report->result_valid = false;
                report->error_message = "CVC4 SAT 但没有提取到任何 time0 反例赋值";
                return false;
            }
            return true;
        }
        else if(result_str == "unsat") {
            if(report) {
                report->status = STATUS_UNSAT;
                report->result_valid = true;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = "";
            }
            return false;
        }
        else {
            if(report) {
                report->status = STATUS_UNKNOWN;
                report->result_valid = false;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = std::string("CVC4 返回 unknown/invalid: ") + result_str;
            }
            return false;
        }
    } catch(const std::exception &e) {
        if(report) {
            report->status = STATUS_INVALID;
            report->result_valid = false;
            report->error_message = std::string("CVC4 异常: ") + e.what();
        }
        return false;
    }
#endif
}

bool SMT_counter::extractCounterMathSAT5(const ParsedProblem &problem,
                                         const std::set<std::string> &declared_bool_vars,
                                         std::map<int, int> *sample,
                                         SolveReport *report) {
#ifndef USE_SMT_MATHSAT5
    (void)problem; (void)declared_bool_vars; (void)sample;
    if(report) {
        report->requested_backend_available = false;
        report->result_valid = false;
        report->error_message = "MathSAT5 未编译启用（需 -DUSE_SMT_MATHSAT5 并链接 MathSAT5 库）";
    }
    return false;
#else
    if(report)
        report->requested_backend_available = true;
    msat_config cfg = msat_create_config();
    msat_set_option(cfg, "model_generation", "true");
    msat_env env = msat_create_env(cfg);
    msat_destroy_config(cfg);
    if(MSAT_ERROR_ENV(env)) {
        if(report) {
            report->status = STATUS_INVALID;
            report->result_valid = false;
            report->error_message = "MathSAT5 环境创建失败";
        }
        return false;
    }
    bool found = false;
    try {
        std::map<std::string, msat_term> vars;
        msat_type bool_type = msat_get_bool_type(env);
        for(size_t i = 0; i < problem.declarations.size(); ++i) {
            msat_decl decl = msat_declare_function(env, problem.declarations[i].c_str(), bool_type);
            if(MSAT_ERROR_DECL(decl))
                throw std::runtime_error("声明变量失败: " + problem.declarations[i]);
            msat_term term = msat_make_constant(env, decl);
            if(MSAT_ERROR_TERM(term))
                throw std::runtime_error("创建变量失败: " + problem.declarations[i]);
            vars.insert(std::make_pair(problem.declarations[i], term));
        }

        std::function<msat_term(ExprNode*)> build = [&](ExprNode *node) -> msat_term {
            switch(node->kind) {
            case ExprNode::EXPR_TRUE:
                return msat_make_true(env);
            case ExprNode::EXPR_FALSE:
                return msat_make_false(env);
            case ExprNode::EXPR_VAR: {
                std::map<std::string, msat_term>::iterator it = vars.find(node->symbol);
                if(it == vars.end())
                    throw std::runtime_error("未声明变量: " + node->symbol);
                return it->second;
            }
            case ExprNode::EXPR_NOT:
                return msat_make_not(env, build(node->children[0]));
            case ExprNode::EXPR_AND: {
                if(node->children.empty())
                    return msat_make_true(env);
                msat_term result = build(node->children[0]);
                for(size_t i = 1; i < node->children.size(); ++i)
                    result = msat_make_and(env, result, build(node->children[i]));
                return result;
            }
            case ExprNode::EXPR_OR: {
                if(node->children.empty())
                    return msat_make_false(env);
                msat_term result = build(node->children[0]);
                for(size_t i = 1; i < node->children.size(); ++i)
                    result = msat_make_or(env, result, build(node->children[i]));
                return result;
            }
            case ExprNode::EXPR_EQ:
                return msat_make_eq(env, build(node->children[0]), build(node->children[1]));
            }
            return msat_term();
        };

        for(size_t i = 0; i < problem.assertions.size(); ++i) {
            msat_term clause = build(problem.assertions[i]);
            if(MSAT_ERROR_TERM(clause))
                throw std::runtime_error(std::string("MathSAT5 构建公式失败: ") + msat_last_error_message(env));
            if(msat_assert_formula(env, clause) != 0)
                throw std::runtime_error(std::string("MathSAT5 assert 失败: ") + msat_last_error_message(env));
        }

        msat_result res = msat_solve(env);
        if(res == MSAT_SAT) {
            found = true;
            if(report) {
                report->status = STATUS_SAT;
                report->result_valid = true;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = "";
            }
            if(sample) sample->clear();

            msat_model model = msat_get_model(env);
            if(MSAT_ERROR_MODEL(model))
                throw std::runtime_error(std::string("MathSAT5 获取模型失败: ") + msat_last_error_message(env));

            int extracted_time0_assignments = 0;
            int unresolved_bool_values = 0;
            std::ostringstream unresolved_examples;
            int unresolved_examples_count = 0;

            for(std::set<std::string>::const_iterator it = declared_bool_vars.begin(); it != declared_bool_vars.end(); ++it) {
                std::map<std::string, msat_term>::iterator vit = vars.find(*it);
                if(vit == vars.end())
                    continue;

                msat_term value = msat_model_eval(model, vit->second);
                if(MSAT_ERROR_TERM(value))
                    value = msat_get_model_value(env, vit->second);
                if(MSAT_ERROR_TERM(value)) {
                    ++unresolved_bool_values;
                    if(unresolved_examples_count < 8) {
                        unresolved_examples << *it << "=<error>";
                        ++unresolved_examples_count;
                        if(unresolved_examples_count < 8)
                            unresolved_examples << "; ";
                    }
                    continue;
                }

                bool bool_value = false;
                std::string value_repr;
                if(!decode_mathsat_bool_value(env, value, &bool_value, &value_repr)) {
                    ++unresolved_bool_values;
                    if(unresolved_examples_count < 8) {
                        unresolved_examples << *it << "=" << (value_repr.empty() ? mathsat_term_to_string(value) : value_repr);
                        ++unresolved_examples_count;
                        if(unresolved_examples_count < 8)
                            unresolved_examples << "; ";
                    }
                    continue;
                }
                if(!bool_value)
                    continue;

                int var = 0, val = 0, timestep = -1;
                if(parseVarAssignmentAtTimeZero(*it, &var, &val, &timestep) && timestep == 0) {
                    if(!insert_time_zero_assignment(sample, var, val,
                                                    report ? &report->error_message : 0,
                                                    "MathSAT5")) {
                        if(report) {
                            report->status = STATUS_INVALID;
                            report->result_valid = false;
                        }
                        msat_destroy_model(model);
                        return false;
                    }
                    ++extracted_time0_assignments;
                }
            }
            msat_destroy_model(model);

            if(report && extracted_time0_assignments == 0) {
                report->status = STATUS_INVALID;
                report->result_valid = false;
                std::ostringstream oss;
                oss << "MathSAT5 SAT 但没有提取到任何 time0 反例赋值";
                if(unresolved_bool_values > 0) {
                    oss << "；无法解析的布尔值个数=" << unresolved_bool_values;
                    if(unresolved_examples_count > 0)
                        oss << "；示例: " << unresolved_examples.str();
                }
                report->error_message = oss.str();
                return false;
            }
        } else if(res == MSAT_UNSAT) {
            if(report) {
                report->status = STATUS_UNSAT;
                report->result_valid = true;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = "";
            }
            found = false;
        } else {
            if(report) {
                report->status = STATUS_UNKNOWN;
                report->result_valid = false;
                report->model_const_count = (int)problem.declarations.size();
                report->error_message = std::string("MathSAT5 返回 unknown: ") + msat_last_error_message(env);
            }
            found = false;
        }
    } catch(const std::exception &e) {
        if(report) {
            report->status = STATUS_INVALID;
            report->result_valid = false;
            report->error_message = std::string("MathSAT5 异常: ") + e.what();
        }
        found = false;
    }
    msat_destroy_env(env);
    return found;
#endif
}

bool SMT_counter::extractCounterYices2(const ParsedProblem &problem,
                                       const std::set<std::string> &declared_bool_vars,
                                       std::map<int, int> *sample,
                                       SolveReport *report) {
#ifndef USE_SMT_YICES2
    (void)problem; (void)declared_bool_vars; (void)sample;
    if(report) {
        report->requested_backend_available = false;
        report->result_valid = false;
        report->error_message = "Yices2 未编译启用（需 -DUSE_SMT_YICES2 并链接 Yices2 库）";
    }
    return false;
#else
    if(report)
        report->requested_backend_available = true;
    yices_init();
    bool found = false;
    try {
        ctx_config_t *config = yices_new_config();
        yices_default_config_for_logic(config, "QF_UF");
        context_t *ctx = yices_new_context(config);
        yices_free_config(config);
        std::map<std::string, term_t> vars;
        type_t bool_type = yices_bool_type();
        for(size_t i = 0; i < problem.declarations.size(); ++i) {
            term_t t = yices_new_uninterpreted_term(bool_type);
            if(t < 0)
                throw std::runtime_error("创建 Yices 变量失败: " + problem.declarations[i]);
            if(yices_set_term_name(t, problem.declarations[i].c_str()) < 0)
                throw std::runtime_error("设置 Yices 变量名失败: " + problem.declarations[i]);
            vars.insert(std::make_pair(problem.declarations[i], t));
        }

        std::function<term_t(ExprNode*)> build = [&](ExprNode *node) -> term_t {
            switch(node->kind) {
            case ExprNode::EXPR_TRUE:
                return yices_true();
            case ExprNode::EXPR_FALSE:
                return yices_false();
            case ExprNode::EXPR_VAR: {
                std::map<std::string, term_t>::iterator it = vars.find(node->symbol);
                if(it == vars.end())
                    throw std::runtime_error("未声明变量: " + node->symbol);
                return it->second;
            }
            case ExprNode::EXPR_NOT:
                return yices_not(build(node->children[0]));
            case ExprNode::EXPR_AND: {
                if(node->children.empty())
                    return yices_true();
                std::vector<term_t> args;
                for(size_t i = 0; i < node->children.size(); ++i)
                    args.push_back(build(node->children[i]));
                return yices_and((uint32_t)args.size(), &args[0]);
            }
            case ExprNode::EXPR_OR: {
                if(node->children.empty())
                    return yices_false();
                std::vector<term_t> args;
                for(size_t i = 0; i < node->children.size(); ++i)
                    args.push_back(build(node->children[i]));
                return yices_or((uint32_t)args.size(), &args[0]);
            }
            case ExprNode::EXPR_EQ:
                return yices_iff(build(node->children[0]), build(node->children[1]));
            }
            return NULL_TERM;
        };

        for(size_t i = 0; i < problem.assertions.size(); ++i) {
            term_t clause = build(problem.assertions[i]);
            if(clause == NULL_TERM)
                throw std::runtime_error("Yices 构建公式失败");
            if(yices_assert_formula(ctx, clause) < 0)
                throw std::runtime_error("Yices assert 失败");
        }

        smt_status_t status = yices_check_context(ctx, 0);

        const int yices_status_code = static_cast<int>(status);

            if(yices_status_code == 3) { // STATUS_SAT
                found = true;
                if(report) {
                    report->status = STATUS_SAT;
                    report->result_valid = true;
                    report->model_const_count = (int)problem.declarations.size();
                    report->error_message = "";
                }
                if(sample) sample->clear();

                model_t *model = yices_get_model(ctx, 1);
                if(!model)
                    throw std::runtime_error("Yices 获取模型失败");

                for(std::set<std::string>::const_iterator it = declared_bool_vars.begin();
                    it != declared_bool_vars.end(); ++it) {
                    std::map<std::string, term_t>::iterator vit = vars.find(*it);
                    if(vit == vars.end())
                        continue;

                    int32_t value = 0;
                    if(yices_get_bool_value(model, vit->second, &value) == 0 && value) {
                        int var = 0, val = 0, timestep = -1;
                        if(parseVarAssignmentAtTimeZero(*it, &var, &val, &timestep) && timestep == 0) {
                            if(!insert_time_zero_assignment(sample, var, val,
                                                            report ? &report->error_message : 0,
                                                            "Yices2")) {
                                if(report) {
                                    report->status = STATUS_INVALID;
                                    report->result_valid = false;
                                }
                                yices_free_model(model);
                                yices_free_context(ctx);
                                yices_exit();
                                return false;
                            }
                        }
                    }
                }

                yices_free_model(model);

            } else if(yices_status_code == 4) { // STATUS_UNSAT
                if(report) {
                    report->status = STATUS_UNSAT;
                    report->result_valid = true;
                    report->model_const_count = (int)problem.declarations.size();
                    report->error_message = "";
                }
                found = false;

            } else {
                if(report) {
                    report->status = STATUS_UNKNOWN;
                    report->result_valid = false;
                    report->model_const_count = (int)problem.declarations.size();

                    if(yices_status_code == 2) {
                        report->error_message = "Yices2 返回 unknown";
                    } else if(yices_status_code == 5) {
                        report->error_message = "Yices2 求解被中断";
                    } else if(yices_status_code == 6) {
                        report->error_message = "Yices2 返回 error";
                    } else {
                        report->error_message = "Yices2 返回未识别状态码: " + std::to_string(yices_status_code);
                    }
                }
                found = false;
            }

        yices_free_context(ctx);
    } catch(const std::exception &e) {
        if(report) {
            report->status = STATUS_INVALID;
            report->result_valid = false;
            report->error_message = std::string("Yices2 异常: ") + e.what();
        }
        found = false;
    }
    yices_exit();
    return found;
#endif
}
