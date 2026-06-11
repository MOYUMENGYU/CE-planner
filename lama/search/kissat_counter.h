#ifndef KISSAT_COUNTER_H
#define KISSAT_COUNTER_H

#include <map>
#include <vector>
#include "cnf_types.h"

class CnfBuilder;
class SatVarManager;

#ifdef USE_KISSAT
extern "C" {
#include "kissat.h"
}
#endif

class KissatCounter {
public:
    KissatCounter();
    ~KissatCounter();
    void clear();
    bool load_cnf(const CnfBuilder &cnf);
    int solve();
    int value_of_var(int var_id) const;
    bool extract_time0_sample(const SatVarManager &vm, std::map<int,int> *sample, std::map<int,int> *conflict_counter) const;
    bool is_available() const;

private:
#ifdef USE_KISSAT
    kissat *solver_;
#else
    void *solver_;
#endif
    int last_result_;
    std::vector<char> active_vars_;
};

#endif
