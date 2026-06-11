#ifndef _COUNTER_H
#define _COUNTER_H

#include <cassert>
#include <iostream>
#include <string>
#include <vector>
#include <set>
#include "globals.h"
#include "state.h"
#include <map>
#include "sys/time.h"
#include "smt_counter.h"
using namespace std;
struct oneof_item
{
    int len;
    vector<int> size;
    vector<int> var;
    vector<int> val;
    ~oneof_item(){
        size.clear();
        var.clear();
        val.clear();
    }
};
/*oneofs数据结构规则*/
/*
orlens:其中or子句的个数
lens：oneof子句的个数
oneof：表示每一个or或oneof
       len-oneof中的参数个数
       size-第i个参数中多值变量的个数
       var/val-依次存取所有的多值变量
*/

struct ONEOFS
{
    /*1:oneof-combine后的状态 2:全是oneof 3：包括有or*/
    int type;
    int orlens;
    int lens;
    vector<oneof_item> oneof;
    ~ONEOFS(){
        oneof.clear();
    }
};

struct Landmarkitem{
    int in,out;
    vector<pair<int,int>> item;
};

struct Landmark{
    int oneoflen;
    vector<vector<Landmarkitem>> insidelandmarks;
    vector<Landmarkitem> outsidelandmarks;
};

struct state_var{
    vector<int> vars; 
    int frequency;
};

struct treeNode{
    int var,val,timestep;
    bool istrue, isfalse;
    string assert;
    set<pair<pair<int, int>, int>> repeated_childrens;
    set<pair<pair<int,int>,int>> repeated_fathers;
    vector<treeNode *> childrens;
    vector<treeNode *> fathers;
    string father;
    treeNode(){
        istrue = false;
        isfalse = false;
        assert = "";
        father = "";
    }
    /* data */
};



class Counter
{
public:
    typedef std::vector<const Operator *> Plan;
    ONEOFS oneofs;
    /*用于每次计算反例的tags,用oneof_item中的size[i]=-1来表示某个tag已经出现过*/
    ONEOFS tags;
    int sum;
    Plan newplan;
    /*表示约束部分反例的SMT，已经找不到反例，=true时会放开初始状态的约束*/
    bool isfind;
    int operateTimes;
    /*表示删除的例子是否能解*/
    bool counterissolvered;
    
    vector<State*> counterset;
    vector<vector<State*>> planSet;
    /*用于简化规划解*/
    vector<state_var> counterset_new;
    vector<string> everyplanvarset; 
    /*存储下标与变量的映射*/
    std::map<int,int> indextovar;
    long long belief_size;
    /*存储axiom与前置条件的映射*/
    std::map<pair<int,int>,vector<PrePost>> axiomtovar;
    
    /*反例集中的反例，记录了出现次数，如果大于2会限制其在后续迭代中不出现*/
    std::map<string,state_var> appearcounter;
    /*出现过的s0集合，用于变换s0的选择*/
    std::map<string,state_var> firststate;
    /*确定性literal*/
    vector<pair<int, int>> L0;
    std::set<string> knownliteral;
    /*smt字符串公式*/
    set<string> variables;
    string fix_init_smt;
    string init_smt;
    string regret_smt;
    // string new_regret_smt;
    string smt;
    string sasrestraint_smt;
    /*总反例时间*/
    int total_counter;
    /*landmark time*/
    int landmarktime;
    /*化简时间*/
    int simplifytime;
    /*1:固定前置状态为减少可以汇集的点 2:利用另一个解的最优部分解来解决当前问题 3:默认方式，前置状态一直变化*/
    int plantype;
    /*前置条件不满足时被删除的动作数*/
    int unapplyaction;
    int lastcountertime;
    int lastsmtvariables;

    struct SMTValidationStats {
        int build_time_ms;
        int solver_and_extract_time_ms;
        int total_time_ms;
        int smt_variable_count;
        int requested_solver_backend;
        int used_solver_backend;
        bool requested_solver_available;
        bool used_fallback_solver;
        bool result_valid;
        bool has_counterexample;
        bool sample_valid;
        std::vector<int> counterexample_state;
        std::string solver_message;
        SMTValidationStats()
            : build_time_ms(0), solver_and_extract_time_ms(0), total_time_ms(0),
              smt_variable_count(0), requested_solver_backend(0), used_solver_backend(0),
              requested_solver_available(false), used_fallback_solver(false), result_valid(false),
              has_counterexample(false), sample_valid(false),
              counterexample_state(), solver_message() {}
    };
    SMTValidationStats last_validation_stats_;

    Landmark landmark;
    bool findfinallandmark;
    bool findvalidplan;

    /*用于生成树，来简化SMT公式*/
    treeNode *head;
    treeNode *null_poi;

public:
    Counter(bool isinitial);
    ~Counter(){
        variables.clear();
    }
    set<string> getVariables(){
        return variables;
    }
    int getBelief_size(){
        return belief_size;
    }
    void printfhello(){
        cout<<"::"<<oneofs.type<<endl;
        if(oneofs.type==1){

        }else if(oneofs.type==2){

        }else if(oneofs.type==3){
            for(int i=0;i<oneofs.orlens;i++){
                int nowindex=0;
                cout<<"OR:"<<oneofs.oneof[i].len<<" ";
                for(int j=0;j<oneofs.oneof[i].len;j++){    
                    // cout<<oneofs.oneof[i].size[j]<<" ";
                    for(int k=0;k<oneofs.oneof[i].size[j];k++){
                        cout<<g_variable_name[oneofs.oneof[i].var[nowindex]]<<":"<<oneofs.oneof[i].val[nowindex];
                        if(k!=oneofs.oneof[i].size[j]-1)
                            cout<<",";
                        else
                            cout<<";";
                        nowindex++;
                    }
                }
                cout<<endl;      
            }
            for(int i=0;i<oneofs.lens;i++){
                cout<<"231"<<endl;
                int index=i+oneofs.orlens;
                cout<<"ONEOF:"<<oneofs.oneof[index].len<<" ";
                int nowindex=0;
                for(int j=0;j<oneofs.oneof[index].len;j++){    
                    // cout<<oneofs.oneof[i].size[j]<<" ";
                    for(int k=0;k<oneofs.oneof[index].size[j];k++){
                        cout<<g_variable_name[oneofs.oneof[index].var[nowindex]]<<":"<<oneofs.oneof[index].val[nowindex];
                        if(k!=oneofs.oneof[index].size[j]-1)
                            cout<<",";
                        else
                            cout<<";";
                        nowindex++;
                    }
                }
                cout<<endl;      
            }
        }

        // if(oneofs.type==3)
        //     cout<<"ONEOF:";
        // for(int i=0;i<oneofs.lens;i++){
        //     if(!oneofs.type)
        //        cout<<"ONEOF:"<<oneofs.oneof[i].len<<" ";
        //     int nowindex=0;
        //     for(int j=0;j<oneofs.oneof[i].len;j++){    
        //         // cout<<oneofs.oneof[i].size[j]<<" ";
        //         for(int k=0;k<oneofs.oneof[i].size[j];k++){
        //             cout<<g_variable_name[oneofs.oneof[i].var[nowindex]]<<":"<<oneofs.oneof[i].val[nowindex];
        //             if(k!=oneofs.oneof[i].size[j]-1)
        //                 cout<<",";
        //             else
        //                 cout<<";";
        //             nowindex++;
        //         }
        //     }
        //     if(!oneofs.type)
        //         cout<<endl;      
        // }
    }
    int getTotal_counter(){
        return total_counter;
    }
    const SMTValidationStats &get_last_validation_stats() const {
        return last_validation_stats_;
    }
    void initToSmt(bool isfirst);
    bool conputerCounter(Plan plan,bool isfirst);
    void addActionToGoal(Plan plan);
    string varToSmt(int var,int l,int i);
    void addRestraintToTime0();
    void addAxiomSmt(pair<int,int> vari,string *pre_smt,int timestep);
    string regretCurFact(const Operator *a,set<string> *preference_var,pair<int,int> now_facts,set<pair<int,int> > *new_facts,std::map<pair<int,int>,treeNode*> &nowtreeleaf,std::map<pair<int,int>,treeNode*> &newtreeleaf,set<treeNode*> &trash_nodes,int time_step);
    void optimizePlan(Plan plan);
    void optimizePlantest(Plan plan);
    void testPlanisvalid(Plan plan);
    void addInitRestriction(bool isfirst);
    void travelTree(treeNode *head);
    void deleteRedundancyNode(treeNode* pnow,int type);
    void obtainKnownLiteral(Plan plan);
    int planType();
    void superCounter();

    void selectMinState();
    bool selectLandmark();
    bool invokeSMTSolver();
    void clearAll(){
        init_smt.clear();
        init_smt.shrink_to_fit();
        regret_smt.clear();
        regret_smt.shrink_to_fit();
        smt.clear();
        smt.shrink_to_fit();
        sasrestraint_smt.clear();
        sasrestraint_smt.shrink_to_fit();
        variables.clear();
        knownliteral.clear();
    }
};

#endif