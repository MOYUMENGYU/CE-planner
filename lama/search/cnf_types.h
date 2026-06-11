#ifndef CNF_TYPES_H
#define CNF_TYPES_H

#include <string>
#include <vector>

struct FactKey {
    int var;
    int val;
    int time;
    FactKey() : var(-1), val(-1), time(-1) {}
    FactKey(int v, int va, int t) : var(v), val(va), time(t) {}
    bool operator<(const FactKey &other) const {
        if (var != other.var) return var < other.var;
        if (val != other.val) return val < other.val;
        return time < other.time;
    }
};

enum SatVarKind {
    SATVAR_KIND_FACT = 0,
    SATVAR_KIND_AUX_AND,
    SATVAR_KIND_AUX_OR,
    SATVAR_KIND_AUX_BODY,
    SATVAR_KIND_AUX_AXIOM,
    SATVAR_KIND_AUX_CONST
};

enum ClauseKind {
    CLAUSE_KIND_INIT_KNOWN = 0,
    CLAUSE_KIND_INIT_TERM,
    CLAUSE_KIND_INIT_GROUP_ATLEAST,
    CLAUSE_KIND_INIT_GROUP_ATMOST,
    CLAUSE_KIND_INIT_FORBID,
    CLAUSE_KIND_TIME0_ATLEASTONE,
    CLAUSE_KIND_TIME0_ATMOSTONE,
    CLAUSE_KIND_GATE_AND,
    CLAUSE_KIND_GATE_OR,
    CLAUSE_KIND_AXIOM,
    CLAUSE_KIND_REG_EQUIV,
    CLAUSE_KIND_ROOT_FAIL,
    CLAUSE_KIND_MISC
};

struct SatVarInfo {
    int id;
    SatVarKind kind;
    FactKey fact;
    std::string label;
    SatVarInfo() : id(0), kind(SATVAR_KIND_FACT), fact(), label("") {}
};

struct ClauseRecord {
    std::vector<int> lits;
    ClauseKind kind;
    std::string note;
};

#endif
