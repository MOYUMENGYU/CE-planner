#ifndef CNF_LOGGER_H
#define CNF_LOGGER_H

#include <iostream>
#include <sstream>
#include <string>

extern bool g_cnf_log_basic;
extern bool g_cnf_log_detail;
extern bool g_cnf_log_clause;
extern bool g_cnf_log_model;

inline std::string cnf_int_to_string(int x) {
    std::ostringstream oss;
    oss << x;
    return oss.str();
}

#define CNF_LOG_BASIC(msg) \
    do { if (g_cnf_log_basic) { std::ostringstream _cnf_oss; _cnf_oss << msg; std::cout << _cnf_oss.str() << std::endl; } } while(0)

#define CNF_LOG_DETAIL(msg) \
    do { if (g_cnf_log_detail) { std::ostringstream _cnf_oss; _cnf_oss << msg; std::cout << _cnf_oss.str() << std::endl; } } while(0)

#define CNF_LOG_CLAUSE(msg) \
    do { if (g_cnf_log_clause) { std::ostringstream _cnf_oss; _cnf_oss << msg; std::cout << _cnf_oss.str() << std::endl; } } while(0)

#define CNF_LOG_MODEL(msg) \
    do { if (g_cnf_log_model) { std::ostringstream _cnf_oss; _cnf_oss << msg; std::cout << _cnf_oss.str() << std::endl; } } while(0)

#endif
