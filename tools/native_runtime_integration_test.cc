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

static std::string trim(const std::string &s) {
    std::size_t b=0,e=s.size();
    while (b<e && std::isspace((unsigned char)s[b])) ++b;
    while (e>b && std::isspace((unsigned char)s[e-1])) --e;
    return s.substr(b,e-b);
}
static std::string lower_ascii(const std::string &s) {
    std::string r=s; for (std::size_t i=0;i<r.size();++i) r[i]=std::tolower((unsigned char)r[i]); return r;
}
static std::string getenv_string(const char *k, const std::string &d) {
    const char *v=std::getenv(k); return v ? std::string(v) : d;
}
static bool env_true(const char *k, bool d) {
    const char *v=std::getenv(k); if(!v) return d; std::string x=lower_ascii(v); return !(x=="0"||x=="false"||x=="off");
}
static bool read_file(const std::string &p, std::string *s) {
    std::ifstream in(p.c_str(),std::ios::binary); if(!in) return false; std::ostringstream o; o<<in.rdbuf(); *s=o.str(); return true;
}
static bool write_file_atomic(const std::string &p,const std::string &s) {
    std::ofstream out(p.c_str(),std::ios::binary|std::ios::trunc); if(!out) return false; out<<s; return (bool)out;
}
static bool copy_file(const std::string &a,const std::string &b) { std::string s; return read_file(a,&s)&&write_file_atomic(b,s); }
static bool executable_file(const std::string &p) { struct stat st; return ::stat(p.c_str(),&st)==0&&S_ISREG(st.st_mode)&&::access(p.c_str(),X_OK)==0; }
static bool readable_regular_file(const std::string &p) { struct stat st; return ::stat(p.c_str(),&st)==0&&S_ISREG(st.st_mode)&&::access(p.c_str(),R_OK)==0; }
static bool readable_directory(const std::string &p) { struct stat st; return ::stat(p.c_str(),&st)==0&&S_ISDIR(st.st_mode)&&::access(p.c_str(),R_OK|X_OK)==0; }
static std::string absolute_path(const std::string &p) { if(!p.empty()&&p[0]=='/')return p; char cwd[PATH_MAX]; getcwd(cwd,sizeof(cwd)); return std::string(cwd)+"/"+p; }
static std::string path_dirname(const std::string &p) { std::size_t x=p.find_last_of('/'); return x==std::string::npos?".":(x==0?"/":p.substr(0,x)); }
static std::string shell_quote(const std::string &s) { std::string o="'"; for(std::size_t i=0;i<s.size();++i){if(s[i]=='\'')o+="'\\''";else o+=s[i];} return o+"'"; }
static std::string one_line_excerpt(const std::string &p,std::size_t n) { std::string s; if(!read_file(p,&s))return ""; if(s.size()>n)s.resize(n); std::replace(s.begin(),s.end(),'\n',' '); return s; }
static bool contains_no_plan_marker(const std::string &s) { std::string x=lower_ascii(s); return x.find("no plan")!=std::string::npos||x.find("unsolvable")!=std::string::npos; }
static bool contains_cpa_success_marker(const std::string &s) { return lower_ascii(s).find("found a plan")!=std::string::npos; }
static StatusCode run_shell_command(const std::string &c,int,const std::string&,int *e,int *sig) {
    int st=std::system(c.c_str()); *sig=0; if(st==-1){*e=-1;return STATUS_PLANNER_FAILED;} if(WIFSIGNALED(st)){*sig=WTERMSIG(st);return STATUS_PLANNER_FAILED;} *e=WEXITSTATUS(st); return *e==0?STATUS_OK:STATUS_PLANNER_FAILED;
}
static bool write_plain_plan_artifact(const std::vector<std::string>&a,const std::string&p){std::ostringstream o;if(a.empty())o<<";; empty plan\n";for(std::size_t i=0;i<a.size();++i)o<<a[i]<<"\n";return write_file_atomic(p,o.str());}
static void lines_to_actions(const std::string&s,std::vector<std::string>*a){std::istringstream in(s);std::string l;while(std::getline(in,l)){l=trim(l);if(l.empty())continue;if(l[0]=='('&&l[l.size()-1]==')')l=l.substr(1,l.size()-2);if(l.find("act")!=std::string::npos)a->push_back("act");}}
static StatusCode extract_plain_plan_actions(const std::string&s,std::vector<std::string>*a,std::string*){a->clear();lines_to_actions(s,a);return a->empty()?STATUS_PLANNER_PARSE_ERROR:STATUS_OK;}
static StatusCode extract_cpa_plan_actions(const std::string&s,std::vector<std::string>*a,std::string*){a->clear();if(contains_no_plan_marker(s))return STATUS_PLANNER_NO_PLAN;if(s.find("act")!=std::string::npos){a->push_back("act");return STATUS_OK;}return STATUS_PLANNER_PARSE_ERROR;}
static StatusCode extract_cpah_plan_actions(const std::string&s,std::vector<std::string>*a,std::string*e){return extract_cpa_plan_actions(s,a,e);}
static StatusCode extract_cff_console_plan_actions(const std::string&s,std::vector<std::string>*a,std::string*){a->clear();if(contains_no_plan_marker(s))return STATUS_PLANNER_NO_PLAN;if(s.find("ACT")!=std::string::npos||s.find("act")!=std::string::npos){a->push_back("act");return STATUS_OK;}return STATUS_PLANNER_PARSE_ERROR;}
static StatusCode extract_gc_console_plan_actions(const std::string&s,CandidatePlannerKind,std::vector<std::string>*a,std::string*e){return extract_cff_console_plan_actions(s,a,e);}
static StatusCode extract_gcpces_console_plan_actions(const std::string&s,std::vector<std::string>*a,std::string*e){return extract_cff_console_plan_actions(s,a,e);}
static const char *candidate_planner_display_name(CandidatePlannerKind k){const char*n[]={"T1","CNF","DNF","PIP","CPAH","iGC","GC-LAMA","gCPCES","iCPCES","CFF"};return n[k];}

class CandidatePlannerRunner {
public:
    explicit CandidatePlannerRunner(CandidatePlannerKind k):kind_(k){}
    StatusCode test(const std::string&d,const std::string&p,const std::string&i,std::string*r)const{return run_native(d,p,i,30,r);}
private:
    static void print_common_diagnostics(const std::string&,const std::string&,const std::string&,const std::string&){}
    static StatusCode prepare_cpa_sicstus_input(const std::string &path, std::string *message) {
        const std::string configured = trim(getenv_string("IGC_CPA_SICSTUS_INPUT_FILE", ""));
        std::string content;
        if (!configured.empty()) {
            const std::string source = absolute_path(configured);
            if (!read_file(source, &content)) return STATUS_IO_ERROR;
        } else {
            content = "y\ny\n";
        }
        std::istringstream in(content);
        std::string line;
        int answers = 0;
        while (std::getline(in, line)) {
            const std::string answer = lower_ascii(trim(line));
            if (answer.empty()) continue;
            if (answer != "y" && answer != "yes" && answer != "n" && answer != "no")
                return STATUS_INPUT_ERROR;
            ++answers;
        }
        if (answers < 2) return STATUS_INPUT_ERROR;
        if (!write_file_atomic(path, content)) return STATUS_IO_ERROR;
        if (message) *message = path;
        return STATUS_OK;
    }
    StatusCode run_icpces(const std::string&,const std::string&,const std::string&i,int,std::string*r)const{std::string p=i+"/plan-result";write_file_atomic(p,"act\n");if(r)*r=p;return STATUS_OK;}
    std::string cff_runtime_root()const{return absolute_path(getenv_string("IGC_CFF_DIR","./cff"));}
    std::string gc_family_runtime_root()const{return absolute_path(getenv_string(kind_==CANDIDATE_PLANNER_IGC_ORIGIN?"IGC_IGC_DIR":"IGC_GC_LAMA_DIR","./gc"));}
    StatusCode normalize_gc_family_frontend(const std::string&,const std::string&,bool,std::string*m)const{*m="ok";return STATUS_OK;}
    std::string gcpces_runtime_root()const{return absolute_path(getenv_string("IGC_GCPCES_DIR","./gcpces"));}
    std::string cpa_runtime_root()const{const char*k=kind_==CANDIDATE_PLANNER_CPAH?"IGC_CPAH_DIR":kind_==CANDIDATE_PLANNER_CNF?"IGC_CNF_DIR":kind_==CANDIDATE_PLANNER_DNF?"IGC_DNF_DIR":"IGC_PIP_DIR";return absolute_path(getenv_string(k,"."));}
    std::string cpa_binary_name()const{return kind_==CANDIDATE_PLANNER_CNF?"cnf":kind_==CANDIDATE_PLANNER_DNF?"dnf":kind_==CANDIDATE_PLANNER_PIP?"pip":"CPAH";}
#include "cegis_native_runtime.inc"
    CandidatePlannerKind kind_;
};

int main(int argc,char**argv){if(argc!=5)return 2;CandidatePlannerKind k=(CandidatePlannerKind)std::atoi(argv[1]);CandidatePlannerRunner r(k);std::string out;StatusCode st=r.test(argv[2],argv[3],argv[4],&out);std::cout<<"status="<<st<<" result="<<out<<"\n";return st==STATUS_OK?0:1;}
