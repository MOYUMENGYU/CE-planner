#include "counter.h"
#include "operator.h"
#include <cstdlib>
#include <string>
#include <vector>
#include <memory>
#include <cassert>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <sys/times.h>
#include <climits>
#include <string.h>
#include <string>
#include <utility>
#include "state.h"
#include "best_first_search.h"
#include "axioms.h"
using namespace std;

static string trim_copy_counter(const string &text) {
    const string whitespace = " \t\r\n";
    string::size_type begin = text.find_first_not_of(whitespace);
    if (begin == string::npos) return string();
    string::size_type end = text.find_last_not_of(whitespace);
    return text.substr(begin, end - begin + 1);
}

// void printPlan(vector<const Operator *> plan){
// 	cout<<"规划长度："<<plan.size()<<endl;
//     for(int i=0;i<plan.size();i++){
//         cout<<plan[i]->get_name()<<" ";
//     }
//     cout<<endl;
// }

void actionIsSatisfy(int index,state_var s,vector<pair<int,int>>* addfacts,vector<pair<int, int>> tmpgoal,bool relax){
    vector<Prevail> prevail = g_operators[index].get_prevail();
    vector<PrePost> prepost = g_operators[index].get_pre_post();
    bool satisfy=false;
    for(int i=0;i<prevail.size();i++){
        // cout<< s.vars[prevail[i].var] <<","<< prevail[i].prev<<endl;
        if(relax && s.vars[prevail[i].var] == prevail[i].prev)
            satisfy=true;
        else if(!relax && s.vars[prevail[i].var] != prevail[i].prev){
            return;
        }
    }
    for(int i=0;i<prepost.size();i++){
        bool havetmpgoal=false,inpreandpost=false;
        satisfy = true;
        // cout<< s.vars[prepost[i].var] <<","<< prepost[i].pre<<endl;
        if(relax && s.vars[prepost[i].var]==prepost[i].pre)
            satisfy=true;
        else if(!relax && prepost[i].pre!=-1 && s.vars[prepost[i].var]!=prepost[i].pre){
            return;
        }
        for(int j=0;j<prepost[i].cond.size();j++){
            if(relax && s.vars[prepost[i].cond[j].var] == prepost[i].cond[j].prev)
                satisfy=true;
            else if(!relax && s.vars[prepost[i].cond[j].var] != prepost[i].cond[j].prev){
                satisfy = false;
            }
            /*确保是在条件中*/
            for(int t=0;t<tmpgoal.size();t++){
                if(tmpgoal[t].first==prepost[i].cond[j].var&&tmpgoal[t].second==prepost[i].cond[j].prev)
                    havetmpgoal = true;
            }
            /*要排除自己到自己的情况*/
            if(prepost[i].cond[j].var==prepost[i].var&&prepost[i].cond[j].prev==prepost[i].post)
                inpreandpost = true;
            
        }
        // cout<<"satisfy:"<<satisfy<<"-have:"<<havetmpgoal<<endl;
        if(satisfy&&havetmpgoal&&!inpreandpost){
                addfacts->push_back(pair<int,int>(prepost[i].var,prepost[i].post));
        }
            
    }
}

string Counter::varToSmt(int var,int l,int i){
    // cout<<"hear3";
    string a = "",b = "";
    while(l>=0){
        char tmp = 48+l%10;
        a+=tmp;
        l/=10;
        if(l==0)
            break;
    }
    reverse(a.begin(),a.end());
    while(i>=0){
        char tmp = 48+i%10;
        b+=tmp;
        i/=10;
        if(i==0)
            break;
    }
    reverse(b.begin(),b.end());
    return g_variable_name[var]+"-"+a+"-"+b;
}

string stateToString(State* s){
    string tmp = "";
    for(int i=0;i<s->vars.size();i++){
        if(s->vars[i]!=(g_variable_domain[i]-1)){
            tmp+=to_string(i);
            tmp+="-";
            tmp+=to_string(s->vars[i]);
            tmp+='.';
        }
    }
    return tmp;
}

string stateToString2(state_var s){
    string tmp = "";
    for(int i=0;i<s.vars.size();i++){
        if(s.vars[i]!=(g_variable_domain[i]-1)){
            tmp+=to_string(i);
            tmp+="-";
            tmp+=to_string(s.vars[i]);
            tmp+='.';
        }
    }
    return tmp;
}

/*状态后移*/
void applyAction(state_var *predecessor, const Operator &op){
    /*test*/
    // for(int i=0;i<predecessor->vars.size();i++){
    //     cout<<g_variable_name[i]<<"-"<<predecessor->vars[i]<<endl;
    // }

    vector<Prevail> prevail = op.get_prevail();
    vector<PrePost> prepost = op.get_pre_post();
    
    bool isApply =true;
    /*第一步判断是否满足前置条件*/
    if(prevail.size()==0)
        isApply = true;
    else{
        for(int i=0;i<prevail.size();i++){
            if(prevail[i].prev!=predecessor->vars[prevail[i].var]){
                isApply = false;
                break;
            }
        }
    }
    //第二步,根据prepost,赋予新值
    vector<pair<int,int>> changevar;
    if(isApply)
        for(int i = 0; i < prepost.size(); i++) {
            int flag=true;
            for(int j = 0; j < prepost[i].cond.size(); j++){
                /*test*/
                // cout<<prepost[i].cond[j].prev<<"条件--状态"<<predecessor->vars[prepost[i].cond[j].var]<<endl;
                if(prepost[i].cond[j].prev!=predecessor->vars[prepost[i].cond[j].var]){
                    flag=false;
                    break;
                }
            }
            if((prepost[i].pre!=-1)&&(prepost[i].pre!=predecessor->vars[prepost[i].var]))
                flag=false;
            if(flag){
                // predecessor->vars[prepost[i].var] = prepost[i].post;
                changevar.push_back(pair<int,int>(prepost[i].var,prepost[i].post));
                /*test*/
                // cout<<"要改变的变量"<<i<<g_variable_name[prepost[i].var]<<"为"<<prepost[i].post<<endl;
            }
        }
    else{

        cout<<op.get_name()<<":不满足前置条件"<<endl;
    }


    for(int i=0;i<changevar.size();i++){
        predecessor->vars[changevar[i].first] = changevar[i].second;
    }
    
    /*test*/
    // cout<<"动作后"<<endl;
    // for(int i=0;i<predecessor->vars.size();i++){
    //     cout<<g_variable_name[i]<<"-"<<predecessor->vars[i]<<endl;
    // }
}

Counter::Counter(bool isinitial){
    
    struct tms start, end;
    isfind=false;
    findvalidplan = false;
    sum=0;
    unapplyaction=0;
    operateTimes=0;
    total_counter=0;
    landmarktime=0;
    simplifytime=0;
    last_validation_stats_ = SMTValidationStats();
    findfinallandmark=false;
    null_poi = new treeNode;
    times(&start);
    /*找到vari与var对应下标*/
    for(int i = 0 ; i < g_variable_name.size() ; i++){
        string name = g_variable_name[i];
        int j=0,var=0,namesize = name.size();
        
        while(j<namesize){
            if(name[j]>=48&&name[j]<=57){
                var*=10;
                var+=(name[j]-48);
            }
            j++;
        }
        
        indextovar.insert(pair<int,int>(i,var));
    }
    oneofs.type = 0;
    oneofs.orlens = 0;
    oneofs.lens = 0;
    oneofs.oneof.clear();
    belief_size = 1;

    ifstream infile;
    if (isinitial == false) infile.open("oneof", ios::in);
    else infile.open("oneof_initial", ios::in);
    string line;
    if (!getline(infile, line)) {
        cerr << "无法读取 oneof 文件" << endl;
        return;
    }
    line = trim_copy_counter(line);
    if (line == "ORS") oneofs.type = 1;
    else if (line == "OR") oneofs.type = 3;
    else oneofs.type = 2;
    cout << oneofs.type << endl;

    if (!getline(infile, line)) return;
    line = trim_copy_counter(line);
    istringstream ss(line);
    if (oneofs.type == 3) ss >> oneofs.orlens;
    else ss >> oneofs.lens;
    int base = (oneofs.type == 3 ? oneofs.orlens : oneofs.lens);
    for (int i = 0; i < base; ++i) {
        oneof_item tmp;
        tmp.len = 0;
        oneofs.oneof.push_back(tmp);
    }

    int index = 0;
    int andsize = 0;
    while (getline(infile, line)) {
        line = trim_copy_counter(line);
        if (line.empty()) continue;

        if (line == "ONEOF") {
            if (!getline(infile, line)) break;
            line = trim_copy_counter(line);
            istringstream ss2(line);
            ss2 >> oneofs.lens;
            for (int i = 0; i < oneofs.lens; ++i) {
                oneof_item tmp;
                tmp.len = 0;
                oneofs.oneof.push_back(tmp);
            }
            continue;
        }
        if (line == ",") {
            if (index >= 0 && index < (int)oneofs.oneof.size())
                oneofs.oneof[index].size.push_back(andsize);
            andsize = 0;
            if (oneofs.type == 1) {
                if (index >= 0 && index < (int)oneofs.oneof.size())
                    oneofs.oneof[index].len = (int)oneofs.oneof[index].size.size();
                ++index;
            }
            continue;
        }
        if (line == "END_ONEOF" || line == "END_OR") {
            if (index >= 0 && index < (int)oneofs.oneof.size())
                oneofs.oneof[index].len = (int)oneofs.oneof[index].size.size();
            ++index;
            andsize = 0;
            continue;
        }

        int var = -1;
        for (int i = 0; i < (int)g_variable_name.size(); ++i) {
            if (line == g_variable_name[i]) {
                var = i;
                break;
            }
        }
        string value_line;
        if (!getline(infile, value_line)) break;
        value_line = trim_copy_counter(value_line);
        stringstream value_stream(value_line);
        int val = 0;
        value_stream >> val;

        if (var == -1 || index < 0 || index >= (int)oneofs.oneof.size()) {
            cerr << "oneof 解析错误: variable='" << line << "', group=" << index << endl;
            continue;
        }
        oneofs.oneof[index].var.push_back(var);
        oneofs.oneof[index].val.push_back(val);
        ++andsize;
    }

    for (int i = 0; i < (int)oneofs.oneof.size(); ++i) {
        int expected = 0;
        for (int j = 0; j < (int)oneofs.oneof[i].size.size(); ++j)
            expected += oneofs.oneof[i].size[j];
        if (expected != (int)oneofs.oneof[i].var.size() ||
            expected != (int)oneofs.oneof[i].val.size()) {
            cerr << "oneof 组结构不一致: group=" << i
                 << ", expected=" << expected
                 << ", vars=" << oneofs.oneof[i].var.size()
                 << ", vals=" << oneofs.oneof[i].val.size() << endl;
            oneofs.oneof[i].len = 0;
            oneofs.oneof[i].size.clear();
            oneofs.oneof[i].var.clear();
            oneofs.oneof[i].val.clear();
        }
    }

    /*计算信仰状态数量*/
    if(oneofs.type==2)
        belief_size=oneofs.lens;
    else
    for(int i=0;i<oneofs.lens;i++){
        belief_size*=oneofs.oneof[i].len;
    }
    /*保存axiom*/
    /*如果有axiom，要添加axiom的约束*/
    for(int i=0;i<g_axioms.size();i++){
        vector<PrePost> prepost = g_axioms[i].get_pre_post();
        for(int j=0;j<prepost.size();j++){
            pair<int,int> vari = pair<int,int>(prepost[j].var,prepost[j].post);
            if(axiomtovar.find(vari)==axiomtovar.end()){
                vector<PrePost> now;
                axiomtovar.insert(pair<pair<int,int>,vector<PrePost>>(vari,now));
            }
            axiomtovar[vari].push_back(prepost[j]);
        }
    }
    cout<<"axiom:"<<axiomtovar.size()<<endl;
    for(auto ot : axiomtovar){
        for(int i=0;i<ot.second.size();i++){
            cout<<"(-["<<ot.second[i].var<<","<<ot.second[i].pre<<"]-";
            for(int j=0;j<ot.second[i].cond.size();j++){
                cout<<"["<<ot.second[i].cond[j].var<<","<<ot.second[i].cond[j].prev<<"]-";
            }
            cout<<")"<<endl;
        }
        cout<<"->["<<ot.first.first<<"-"<<ot.first.second<<"]"<<endl;
    }
    // for(int i = 0 ; i < g_variable_name.size() ; i++){
    //     cout<<indextovar[i]<<" "<<i<<endl;
    // }
    /*初始化tags*/
    if(oneofs.type==2){
        tags.lens = oneofs.lens;
        tags.oneof = oneofs.oneof;
        for(int i=0;i<tags.lens;i++){
            tags.oneof[i].len = oneofs.oneof[i].len;
            tags.oneof[i].size = oneofs.oneof[i].size;
        }
    }
    /*初始化landmark*/
    landmark.oneoflen = oneofs.lens;
    for(int i=0;i<oneofs.lens;i++){
        vector<Landmarkitem> landmarkitem; 
        int m=0;
        for(int j=0;j<oneofs.oneof[i].len;j++){
            Landmarkitem lt;
            lt.in=0;
            lt.out=0;
            landmarkitem.push_back(lt);
        }
        landmark.insidelandmarks.push_back(landmarkitem);
    }

    /*创建初始状态SMT*/
    if(smt_simplifier)
        initToSmt(false);

    int var_len = g_initial_state->vars.size();
    int *isunKnownFact = (int*)calloc(var_len,sizeof(int));
    memset(isunKnownFact,0,var_len);
    
    /*使用oneofcombine得到的oneof*/
    /*目前未使用*/
    
    /*识别known_fact*/
    for(int i=0;i<oneofs.orlens;i++){
        int nowindex=0;
        /*识别or中的*/
        for(int j=0;j<oneofs.oneof[i].len;j++){
            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                isunKnownFact[oneofs.oneof[i].var[nowindex]]=1;
                nowindex++;
            }
        }
    }
    
    /*再识别oneof中的*/
    for(int i=0;i<oneofs.lens;i++){
        int nowindex=0;
        int index = oneofs.orlens+i;
        /*识别or中的*/
        for(int j=0;j<oneofs.oneof[index].len;j++){
            for(int k=0;k<oneofs.oneof[index].size[j];k++){
                isunKnownFact[oneofs.oneof[index].var[nowindex]]=1;
                nowindex++;
            }
        }
    }


    for (int i = 0; i < var_len;i++){
        if(isunKnownFact[i]==0){
            L0.push_back(pair<int, int>(i, g_initial_state->vars[i]));
        }
    }

    free(isunKnownFact);

    times(&end);
    int total_ms = (end.tms_utime - start.tms_utime) * 10;
    (void)total_ms;
}


void Counter::obtainKnownLiteral(Plan plan){
    std::map<int,int> nowL,nextL,actionlit;
    // cout << "known literal:" << endl;
    for (auto tmp : L0)
    {
        // cout << g_variable_name[tmp.first] << "-" << tmp.second << " ";
        nowL.insert(pair<int, int>(tmp.first, tmp.second));
    }
    // cout << endl;
    for (int i = 0; i < plan.size(); i++)
    {
        // cout << plan[i]->get_name() << endl;
        vector<PrePost> prepost;
        for (int j = 0; j < g_operators.size(); j++)
        {
            if (g_operators[j].get_name().compare(plan[i]->get_name()) == 0){
                prepost = g_operators[j].get_pre_post();
                break;
            }
        }
        for (int j = 0; j < prepost.size(); j++)
        {
            int isapply = true;
            for (int k = 0; k < prepost[j].cond.size(); k++)
            {
                if(nowL.find(prepost[j].cond[k].var)==nowL.end() || nowL[prepost[j].cond[k].var]!=prepost[j].cond[k].prev){
                    isapply = false;
                    break;
                }
            }
            if((prepost[j].pre!=-1)&&(nowL.find(prepost[j].var)==nowL.end() || nowL[prepost[j].var]!=prepost[j].pre))
                isapply = false;
            if(isapply){
                nextL.insert(pair<int, int>(prepost[j].var, prepost[j].post));
                knownliteral.insert(varToSmt(prepost[j].var, prepost[j].post, i+1));
                // cout << g_variable_name[prepost[j].var] << "-" << prepost[j].post << " ";
            }
            actionlit.insert(pair<int, int>(prepost[j].var, prepost[j].post));
        }
        for(auto tmp:nowL){
            if(actionlit.find(tmp.first)==actionlit.end()){
                nextL.insert(tmp);
                knownliteral.insert(varToSmt(tmp.first, tmp.second, i+1));
                // cout << g_variable_name[tmp.first] << "-" << tmp.second << " ";
            }
        }
        // cout << endl;
        nowL.clear();
        nowL = nextL;
        nextL.clear();
        actionlit.clear();
    }
}


bool Counter::selectLandmark(){
    struct tms start,end;
    times(&start);
    bool findlandmark = false;
    std::map<pair<int,int>,pair<int,int>> itemindex;
    int nowindex=0;
    vector<int> tmpvar=g_initial_state->vars;
    for(int i=0;i<oneofs.lens;i++){
        nowindex=0;
        for(int j=0;j<oneofs.oneof[i].len;j++){
            if(oneofs.oneof[i].val[nowindex]>=0)
                itemindex.insert(pair<pair<int,int>,pair<int,int>>(pair<int,int>(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]),pair<int,int>(i,j)));
            else
                itemindex.insert(pair<pair<int,int>,pair<int,int>>(pair<int,int>(oneofs.oneof[i].var[nowindex],g_variable_domain[oneofs.oneof[i].var[nowindex]]-1),pair<int,int>(i,j)));
            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                tmpvar[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                nowindex++;
            }
            // nowindex+=oneofs.oneof[i].size[j];
        }
    }

    cout << "111" << endl;
    for (int i = 0; i < oneofs.lens; i++)
    {
        // cout<<"第一步"<<endl;
        /*1.初始化：（1）对于oneof每一个item构造一个map<pair<var,val>,index>，快速找到下标;(2)选择第1个和n/2个为所选的两个状态;(3)构造一个oenof内部所有元素全部设置为空的变量*/
        nowindex=0;
        
        vector<int> candidatestate=g_initial_state->vars,rightstate=g_initial_state->vars;
        vector<pair<int,int>> leftgoal,rightgoal;
        
        for(int j=0;j<oneofs.oneof[i].len;j++){
            // cout<<oneofs.oneof[i].var[nowindex]<<" "<<oneofs.oneof[i].val[nowindex]<<endl;
            
            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                candidatestate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                rightstate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                
                if(j==0){
                    if(oneofs.oneof[i].val[nowindex]>=0){
                        // leftstate[oneofs.oneof[i].var[nowindex]] = oneofs.oneof[i].val[nowindex]-1;
                        leftgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]-1));
                    }
                    else{
                        // leftstate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]];
                        leftgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],g_variable_domain[oneofs.oneof[i].var[nowindex]]));
                    }
                        
                }
                if(j==oneofs.oneof[i].len/2){
                    if(oneofs.oneof[i].val[nowindex]>=0){
                        rightstate[oneofs.oneof[i].var[nowindex]] = oneofs.oneof[i].val[nowindex];
                        rightgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]));
                    }else{
                        rightstate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].val[nowindex]]-1;
                        rightgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],g_variable_domain[oneofs.oneof[i].val[nowindex]]-1));
                    }
                    
                }
                nowindex++;
            }
        }
        // cout<<"第二步"<<endl;
        /*2.任意选择oneof的两个状态，判断是否可达到，有一边能到另一边就行*/
        bool leftcan=true,rightcan=true;
        // BestFirstSearchEngine *subengine1,*subengine2;
        // vector<int> temp;
        // temp = g_initial_state->vars;
        vector<pair<int, int> > tmpgoal;
        // tmpgoal.insert(tmpgoal.end(),g_goal.begin(),g_goal.end());
        
        // //计算左-》右
        // g_initial_state->vars = leftstate;
        // g_goal.clear();
        // g_goal.insert(g_goal.begin(),rightgoal.begin(),rightgoal.end());
        // subengine1 = new BestFirstSearchEngine;
        // //启动一次搜索
        // subengine1->add_heuristic(1, 1);
        // subengine1->search();
        // if(subengine1->found_solution())
        //     leftcan = true;
        // //计算右-》左       
        // g_initial_state->vars = rightstate;
        // g_goal.clear();
        // g_goal.insert(g_goal.begin(),leftgoal.begin(),leftgoal.end());
        // subengine2 = new BestFirstSearchEngine;
        // //启动一次搜索
        // subengine2->add_heuristic(1, 1);
        // subengine2->search();
        // if(subengine2->found_solution())
        //     rightcan = true;

        // g_goal.clear();
        // g_goal.insert(g_goal.begin(),tmpgoal.begin(),tmpgoal.end());
        // g_initial_state->vars = temp;
        // delete subengine2;
        // delete subengine1;

        // cout<<"第三步"<<endl;
        /*3.可达到（说明参考状态有用），继续下一步;否则continue*/
        if(leftcan||rightcan){
        /*4.对于每一个oneof的item，找到所有的包含其在内的所有动作（当前满足动作前置条件以及条件影响），把add的那个状态的in+1，自己的out+1（如果刚好是oneof内的）*/
        /*待判定？？？，这里有个细节，就是单个item满足条件，则算是到add集的一条边，还是出现在条件中就算一条边。明显第一种更严谨，第二种更放松*/
            nowindex = 0;
            state_var nowstate;
            nowstate.frequency = 0;
            for(int j=0;j<oneofs.oneof[i].len;j++){
                vector<pair<int,int>> addfacts;
                tmpgoal.clear();
                for(int k=0;k<oneofs.oneof[i].size[j];k++){
                    if(oneofs.oneof[i].val[nowindex]>=0){
                        tmpgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]));
                        tmpvar[oneofs.oneof[i].var[nowindex]] = oneofs.oneof[i].val[nowindex];
                    }
                    else{
                        tmpgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],g_variable_domain[oneofs.oneof[i].var[nowindex]]-1));
                        tmpvar[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                    }
                    nowindex++;
                }
                // for(auto a:tmpgoal){
                //     cout<<"oneofitem:"<<g_variable_name[a.first]<<","<<a.second<<endl;
                // }
                nowstate.vars = tmpvar;
                for(int k=0;k<g_operators.size();k++){
                    // cout<<g_operators[k].get_name()<<endl;
                    actionIsSatisfy(k,nowstate,&addfacts,tmpgoal,false);
                    // cout<<addfacts.size()<<endl;
                    if(addfacts.size()>0){
                        Landmarkitem landmarkitem;
                        landmarkitem.in=0;
                        landmarkitem.out=0;
                        for(auto fact:addfacts){
                            // cout<<g_variable_name[fact.first]<<" "<<fact.second<<"---";
                            // cout<<g_variable_domain[fact.first]-1<<" "<<fact.second<<endl;

                            // if(fact.second!=g_variable_domain[fact.first]-1){
                                if(itemindex.find(pair<int,int>(fact.first,fact.second))!=itemindex.end()){
                                    landmark.insidelandmarks[i][j].out++;
                                    landmark.insidelandmarks[itemindex[pair<int,int>(fact.first,fact.second)].first][itemindex[pair<int,int>(fact.first,fact.second)].second].in++;
                                }else{
                                    // cout<<"??"<<endl;
                                    // landmarkitem.item.push_back(pair<int,int>(fact.first,fact.second));
                                    // landmarkitem.in++;
                                }
                            // }
                        }
                        // cout<<endl;
                        // if(landmarkitem.item.size()>0)
                        //     landmark.outsidelandmarks.push_back(landmarkitem);
                    }
                    addfacts.clear();
                }   
                for(auto a:tmpgoal){
                    tmpvar[a.first] = g_variable_domain[a.first]-1;
                }
            }
        }else{
            continue;
        }
    }
    for(int i=0;i<landmark.insidelandmarks.size();i++){
        cout<<"第"<<i<<"个oneof:";
        for(int j=0;j<landmark.insidelandmarks[i].size();j++){
            cout<<"("<<landmark.insidelandmarks[i][j].in<<","<<landmark.insidelandmarks[i][j].out<<") ";
        }
        cout<<endl;
        nowindex=0;
        vector<pair<int,int>> tmpgoal;
        vector<int> candidatestate=g_initial_state->vars;
        for(int j=0;j<oneofs.oneof[i].len;j++){
            // cout<<oneofs.oneof[i].var[nowindex]<<" "<<oneofs.oneof[i].val[nowindex]<<endl;
            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                candidatestate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                nowindex++;
            }
        }

         /*5.选择每个oneof中出边+入边最少的里面选取离目标最近的作为landmark（这里只变这一个oeoof），这部分是一直不变的，其它可以随着previous变化*/
        /*选择总边少的，总边一样，选择入边少的，如果都一样，那么加入到集合中，如果比原来的少，清空表格*/
        // (1)找到候选的landmarks
        vector<int> need2select;
        bool findlandmark=false;
        int finallandmark=0,zeroitem=0;
        need2select.push_back(0);
        if(landmark.insidelandmarks[i][0].in+landmark.insidelandmarks[i][0].out>0)
            findlandmark=true;
        else
            zeroitem++;
        for(int j=1;j<landmark.insidelandmarks[i].size();j++){
            if((landmark.insidelandmarks[i][j].in+landmark.insidelandmarks[i][j].out)==0){
                zeroitem++;
                continue;
            }
                
            // cout<<"对比1:"<<(landmark.insidelandmarks[i][j].out+landmark.insidelandmarks[i][j].in)<<" "<<(landmark.insidelandmarks[i][need2select[0]].in+landmark.insidelandmarks[i][need2select[0]].out)<<endl;
            if((landmark.insidelandmarks[i][j].in+landmark.insidelandmarks[i][j].out)<(landmark.insidelandmarks[i][need2select[0]].in+landmark.insidelandmarks[i][need2select[0]].out)){
                need2select.clear();
                need2select.push_back(j);
                findlandmark = true;
            }else if((landmark.insidelandmarks[i][j].in+landmark.insidelandmarks[i][j].out)==(landmark.insidelandmarks[i][need2select[0]].in+landmark.insidelandmarks[i][need2select[0]].out)){
                if(landmark.insidelandmarks[i][j].out>landmark.insidelandmarks[i][need2select[0]].out){
                    need2select.clear();
                    need2select.push_back(j);
                    findlandmark = true;
                }else if(landmark.insidelandmarks[i][j].out==landmark.insidelandmarks[i][need2select[0]].out){
                    need2select.push_back(j);
                    findlandmark = true;
                }
            }
        }
        /*如果选择的点超过半数，那么不如不选。默认选择第0个*/
        cout<<"选择的下标:";
        for(int j=0;j<need2select.size();j++){
            cout<<need2select[j]<<",";
        }
        cout<<endl;

        // (2)判断是否有landmarks,如果有选出离目标最近的作为最终选择，需要有landmark，一样的landmark小于一半，为空的landmark小于一半
        if(findlandmark&&need2select.size()<=(oneofs.oneof[i].len/2)&&zeroitem<=(oneofs.oneof[i].len/2)){
            findfinallandmark = true;
            if(need2select.size()>1){
                int lastplansize=0;
                for(int j=0;j<need2select.size();j++){
                    tmpgoal.clear();
                    nowindex=0;
                    /*找到目标*/
                    for(int k=0;k<oneofs.oneof[i].len;k++){
                        if(k==need2select[j]){
                            for(int m=0;m<oneofs.oneof[i].size[k];m++){
                                if(oneofs.oneof[i].val[nowindex]<0){
                                    candidatestate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                                    tmpgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],g_variable_domain[oneofs.oneof[i].var[nowindex]]-1));
                                }else{
                                    tmpgoal.push_back(pair<int,int>(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]));
                                    candidatestate[oneofs.oneof[i].var[nowindex]] = oneofs.oneof[i].val[nowindex];
                                }
                                nowindex++;
                            }
                            break;
                        }else{
                            nowindex+=oneofs.oneof[i].size[k];
                        }
                    }
                    BestFirstSearchEngine *subengine1;
                    vector<int> temp;
                    temp = g_initial_state->vars;
                    g_initial_state->vars = candidatestate;
                    subengine1 = new BestFirstSearchEngine;
                    // //启动一次搜索
                    subengine1->add_heuristic(1, 1);
                    subengine1->search();
                    if(subengine1->found_solution()){
                        cout<<"第"<<j<<"个landmark到目标的plan长度"<<subengine1->get_plan().size()<<endl;
                        if(j!=0&&(subengine1->get_plan().size()<lastplansize)){
                            lastplansize = subengine1->get_plan().size();
                            finallandmark = need2select[j];
                        }else if(j==0){
                            lastplansize = subengine1->get_plan().size();
                        }
                    }
                    delete subengine1;
                    g_initial_state->vars = temp;
                    for(auto item:tmpgoal){
                        candidatestate[item.first] = g_variable_domain[item.first]-1;
                    }
                }
            }else{
                finallandmark = need2select[0];
            }
            

        }else{
            finallandmark=0;
        }
        // (3)修改oneof的这个item为最终oneof中的
        nowindex=0;
        for(int k=0;k<oneofs.oneof[i].len;k++){
            if(k==finallandmark){
                for(int m=0;m<oneofs.oneof[i].size[k];m++){
                    if(oneofs.oneof[i].val[nowindex]<0){
                        candidatestate[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                    }else{
                        candidatestate[oneofs.oneof[i].var[nowindex]] = oneofs.oneof[i].val[nowindex];
                    }
                    nowindex++;
                }
                break;
            }else{
                nowindex+=oneofs.oneof[i].size[k];
            }
        }
        g_initial_state->vars = candidatestate;
        cout<<"最终选择"<<finallandmark<<endl;
    }
    // for(int i=0;i<landmark.outsidelandmarks.size();i++){
    //     cout<<"外部状态:";
    //     cout<<"("<<landmark.outsidelandmarks[i].in<<","<<landmark.outsidelandmarks[i].out<<") ";
    // }
    // cout<<endl;

    times(&end);
    int total_ms = (end.tms_utime - start.tms_utime) * 10;
    landmarktime+=total_ms;
    return findlandmark;
}


/*不再使用*/
void Counter::optimizePlan(Plan plan){
    /*test*/
    // cout<<"修改前规划长度:"<<plan.size()<<endl;
    // for(int i=0;i<plan.size();i++){
    //     cout<<plan[i]->get_name()<<" ";        
    // }
    int plansize = plan.size(),countersize = counterset.size();
    int planrepeat[plansize+10]={0};
    /*test*/
    for(int i=counterset.size()-1;i>counterset.size()-3;i--){
        cout<<i<<"次"<<endl;
        counterset[i]->dump();
        cout<<stateToString(counterset[i])<<endl;
    }
    planSet.push_back(counterset);
    int now = 0;
    for(int i=0;i<plansize;i++){
        vector<State*> curCounterset;
         /*所有的状态后移*/
        // cout<<plan[i]->get_name()<<":"<<endl;
        for(int j=0;j<countersize;j++){
            State* curState = new State();
            int h;
            for(h=0;h<g_operators.size();h++)
            {
                if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
            }
            // curState = new State(*planSet[i][j],g_operators[h]);
            // planSet[i][j]->dump();
            curState->assign(State(*planSet[i][j],g_operators[h]));
            // curState->dump();
            // planSet[i][j]->dump();
            // planSet[i][j]->dump();
            curCounterset.push_back(curState);
        }
        planSet.push_back(curCounterset);
        /*后移后，判断是否有与之前相同的状态*/
        // cout<<"size:"<<curCounterset.size()<<endl;
        for(int j=0;j<=i;j++){
            /*每次规划中的都要遍历一次*/
            bool isidentical = true;
            for(int k=0;k<countersize;k++){
                // curCounterset[k]->dump();
                // cout<<curCounterset[k]->isOneState(*planSet[j][k])<<endl;
                if(!curCounterset[k]->isOneState(*planSet[j][k])){
                    isidentical=false;
                    break;
                }
            }
            if(isidentical){
                cout<<"这里有相同的状态"<<j<<"->"<<(i+1)<<endl;
                planrepeat[j]=i+1;
                now++;
            }
        }
    }
    
    /*test*/
    // for(int i=0;i<countersize;i++){
    //     cout<<i<<endl;
    //     planSet[plansize][i]->dump();
    // }

    for(int i=0;i<plansize+1;i++){
        string tmp="";
        for(int j=0;j<countersize;j++){
            tmp+=stateToString(planSet[i][j]);
        }
        cout<<tmp<<endl;
    }

    for(int i=0;i<plansize+1;i++){
        cout<<planrepeat[i]<<" ";
    }
    for(int i=0;i<plansize+1;i++){
        if(i>0){
            newplan.push_back(plan[i-1]);
        }
        /*将动作往后移动*/
        while(planrepeat[i]>i){
            i = planrepeat[i];
        }  

    }
    cout<<"重复的次数："<<now<<endl;
    sum+=now;
    // cout<<endl;
    // conputerCounter(newplan);

    for(int i=0;i<planSet.size();i++){
        // State* curState;
        // for(int j=0;j<planSet[i].size();j++){
        //     curState =planSet[i][j];
        //     delete curState;
        // }
        planSet[i].clear();
        planSet[i].shrink_to_fit();
    }
    planSet.clear();
    planSet.shrink_to_fit();

}

// 需要根据一致性初始状态进行简化，否则每次迭代的规划解会失去对整个初始状态的一般性
// 待修改
void Counter::optimizePlantest(Plan plan){
    struct tms start,end;
    times(&start);
    /*test*/
    // cout<<"修改前规划长度:"<<plan.size()<<endl;
    // for(int i=0;i<plan.size();i++){
    //     cout<<plan[i]->get_name()<<" ";        
    // }
    // 初始反例集要和map中的一样
    
    //test
    // for(int i=0;i<counterset_new.size();i++){
    //     cout<<endl<<"第"<<i<<"个状态"<<endl;
    //     for(int j=0;j<counterset_new[i].vars.size();j++){
    //         if(counterset_new[i].vars[j]!=g_variable_domain[j]-1)
    //             cout<<g_variable_name[j]<<"-"<<counterset_new[i].vars[j]<<" ";
    //     }
    // }
    
    Plan tmp_plan = plan;
    int plansize = plan.size(),countersize = counterset_new.size();
    int planrepeat[plansize+10]={0};
    vector<state_var> curStates;
    curStates = counterset_new;
    string statesstring="";
    
    for(int i=0;i<countersize;i++){
        statesstring+="(";
        statesstring+=to_string(i);
        statesstring+=")";
        statesstring+=stateToString2(curStates[i]);
    }
    cout<<"反例集数量:"<<countersize<<endl;
    everyplanvarset.push_back(statesstring);
    statesstring="";
    int now = 0;
    for(int i=0;i<tmp_plan.size();i++){
        // cout<<tmp_plan.size()<<endl;
        bool isApply =true;
        int h;
        for(h=0;h<g_operators.size();h++)
        {
            if(g_operators[h].get_name().compare(tmp_plan[i]->get_name()) == 0) break;
        }

        /*先判断该动作是否所有的状态都适用，不适用的话，直接删除*/
        // for(int j=0;j<countersize;j++){
        //     /*第一步判断是否满足前置条件*/
        //     vector<Prevail> prevail = g_operators[h].get_prevail();
        //     if(prevail.size()==0)
        //         isApply = true;
        //     else{
        //         for(int i=0;i<prevail.size();i++){
        //             if(prevail[i].prev!=curStates[j].vars[prevail[i].var]){
        //                 isApply = false;
        //                 break;
        //             }
        //         }
        //     }
        // }
        // if(!isApply){
        //     // cout<<g_operators[h].get_name()<<"动作不满足"<<endl;
        //     // tmp_plan.erase(tmp_plan.begin()+i);
        //     // unapplyaction++;
        //     // i--;
        //     statesstring="";
        //     continue;
        // }
            
         /*所有的状态后移*/
        // cout<<plan[i]->get_name()<<":"<<endl;
        for(int j=0;j<countersize;j++){
            // isApply = true;
            vector<Prevail> prevail = g_operators[h].get_prevail();
            if(prevail.size()==0)
                isApply = true;
            else{
                for(int k=0;k<prevail.size();k++){
                    if(prevail[k].prev!=curStates[j].vars[prevail[k].var]){
                        isApply = false;
                        break;
                    }
                }
            }
            vector<int> addfacts;
            // vector<Prevail> prevail = g_operators[h].get_prevail();
            if(isApply){    
                applyAction(&curStates[j],g_operators[h]);
            }
            statesstring+="(";
            statesstring+=to_string(j);
            statesstring+=")";
            statesstring+=stateToString2(curStates[j]);
        }
        
        // cout<<i<<endl;
        // cout<<statesstring<<endl;
        everyplanvarset.push_back(statesstring);
        
        /*后移后，判断是否有与之前相同的状态*/
        // cout<<"size:"<<curCounterset.size()<<endl;
        for(int j=0;j<=i;j++){
            /*每次规划中的都要遍历一次*/
            bool isidentical = true;
            if((statesstring.size()==everyplanvarset[j].size())&&(statesstring.compare(everyplanvarset[j])==0)){
                // cout<<"这里有相同的状态"<<j<<"->"<<(i+1)<<endl;
                planrepeat[j]=i+1;
                now++;
            }
        }
        statesstring="";
    }
    // cout<<"长度:"<<everyplanvarset.size()<<endl;
    
    /*test*/
    // for(int i=0;i<countersize;i++){
    //     cout<<i<<endl;
    //     planSet[plansize][i]->dump();
    // }
    // cout<<everyplanvarset[plansize]<<endl;
    // cout<<endl;
    // for(int i=0;i<plansize+1;i++){
    //     cout<<everyplanvarset[i]<<endl;
    // }
    /*使用 LAMA 的标准公理求值器重新计算派生变量。该过程会先恢复各层
      的默认值，再按公理层次达到不动点，避免沿用上一状态的派生值。*/
    for(int k=0;k<curStates.size();k++){
        if(g_axiom_evaluator != 0) {
            State evaluated;
            evaluated.vars = curStates[k].vars;
            g_axiom_evaluator->evaluate(evaluated);
            curStates[k].vars = evaluated.vars;
        }
    }

    /*遍历curstate_验证是否为有效解*/
    int isvalidplan=true;
    for(int i=0;i<curStates.size();i++){
        for(int j=0;j<g_goal.size();j++){
            /*test*/
            // cout<<"当前对比:"<<curStates[i].vars[g_goal[j].first]<<"与"<<g_goal[j].second<<endl;
            if(curStates[i].vars[g_goal[j].first]!=g_goal[j].second){
                isvalidplan=false;
                cout<<"状态"<<i<<"不可解"<<endl;
            }
                
        }

    }
    if(isvalidplan){
        cout<<"规划解能解反例集！"<<endl;
        counterissolvered=true;
    }else{
        cout<<"规划解还不能解反例集！"<<endl;
        counterissolvered=false;
    }
    cout<<endl;
    // for(int i=0;i<tmp_plan.size()+1;i++){
    //     cout<<planrepeat[i]<<" ";
    // }
    for(int i=0;i<tmp_plan.size()+1;i++){
        if(i>0){
            newplan.push_back(tmp_plan[i-1]);
        }
        /*将动作往后移动*/
        while(planrepeat[i]>i){
            i = planrepeat[i];
        } 
    }
    // cout<<"重复的次数："<<now<<endl;
    cout<<"规划解长度"<<newplan.size()<<endl;
    sum+=now;
    // cout<<endl;
    // conputerCounter(newplan);
    everyplanvarset.clear();
    everyplanvarset.shrink_to_fit();

    times(&end);
    int total_ms = (end.tms_utime - start.tms_utime) * 10;
    simplifytime+=total_ms;
}

/*在生成oneof和or时，为实现其中的not a，如果为负数，则为not（var=val）
,为了避开val=0这一情况，在编译时将值减小1，这里再加上1为正确值*/
void Counter::initToSmt(bool isfirst){
    init_smt="(assert (and\n";
    /*1.转换初始状态的SMT公式，并且记录所有的变量*/
    // dump_everything();
    int var_len = g_initial_state->vars.size();
    /*识别其中每个状态都相同的fact*/
    int *isunKnownFact = (int*)calloc(var_len,sizeof(int));
    memset(isunKnownFact,0,var_len);
    
    /*使用oneofcombine得到的oneof*/
    /*目前未使用*/
    if(oneofs.type==1){
        /*第一次循环，识别known_fact*/
        for(int i=0;i<oneofs.lens;i++){
            int nowindex=0;
            for(int j=0;j<oneofs.oneof[i].len;j++){
                for(int k=0;k<oneofs.oneof[i].size[j];k++){
                    isunKnownFact[oneofs.oneof[i].var[nowindex]]=1;
                    /*为unkonwn的fact初始一定要设置为假的*/
                    // g_initial_state->set_var(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]);
                    g_initial_state->negate_var(oneofs.oneof[i].var[nowindex]);
                    nowindex++;
                }
            }
        }
        int state_size=0;
        /*添加known_fact,但要确保不是axiom*/
        for(int i=0;i<var_len;i++){
            if(isunKnownFact[i]==0){
                // cout<<"123:"<<(axiomtovar.find(pair<int,int>(i,g_initial_state->vars[i]))==axiomtovar.end())<<endl;
                if(axiomtovar.find(pair<int,int>(i,g_initial_state->vars[i]))==axiomtovar.end()){
                    string var0 = varToSmt(i,g_initial_state->vars[i],0);
                    variables.insert(var0);
                    init_smt+=" ";
                    init_smt+=var0;
                    init_smt+="\n";
                }
            }else{
                state_size++;
            }
        }
        /*所有状态对应的SMT*/
        vector<string> all_state;
        /*构建oneof的SMT*/
        string first_or=" (or ";
        for(int i=0;i<oneofs.lens;i++){
            int nowindex=0;
            for(int k=0;k<oneofs.oneof[i].len;k++){
                string tmp="";
                if(state_size>1)
                    tmp+="(and ";
                for(int j=0;j<oneofs.oneof[i].size[k];j++){
                    g_initial_state->set_var(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex]);
                    nowindex++;
                }
                for(int j=0;j<var_len;j++){
                    if(isunKnownFact[j]){
                        string var0 = "";
                        if(g_initial_state->vars[j]<0)
                            var0+=varToSmt(j,-(g_initial_state->vars[j]+1),0);
                        else
                            var0+=varToSmt(j,g_initial_state->vars[j],0);
                        if(g_initial_state->vars[j]<0)
                            tmp += "(not ";
                        tmp+=var0;
                        if(g_initial_state->vars[j]<0)
                            tmp += ")";
                        if ((j != var_len - 1) && (state_size > 1))
                            tmp+=" ";
                        variables.insert(var0);
                    }
                }
                if(state_size>1)
                    tmp+=")";
                for(int j=0;j<oneofs.oneof[i].size[k];j++){
                    g_initial_state->negate_var(oneofs.oneof[i].var[nowindex-j-1]);
                }
                // cout<<endl<<tmp;
                first_or+=tmp;
                first_or+=" ";
                all_state.push_back(tmp);
            }
        }
        first_or+=")";
        init_smt+=first_or;
        init_smt+="\n";
        g_initial_state->vars = g_original_values;
        /*构建所有的oneof约束*/
        for(int i=0;i<oneofs.lens-1;i++){
            int j=i+1;
            do{
                string else_or=" (or ";
                else_or+="(not ";
                else_or+=all_state[i];
                else_or+=") ";
                else_or+="(not ";
                else_or+=all_state[j];
                else_or+="))";
                init_smt+=else_or;
                init_smt+="\n";
                j++;
            }while(j<oneofs.lens);
        }
        
    }else{
        
        /*第一次循环，识别known_fact，oneof和or中没有的则为known_fact*/
        /*先识别or中的*/
        for(int i=0;i<oneofs.orlens;i++){
            int nowindex=0;
            /*识别or中的*/
            for(int j=0;j<oneofs.oneof[i].len;j++){
                for(int k=0;k<oneofs.oneof[i].size[j];k++){
                    isunKnownFact[oneofs.oneof[i].var[nowindex]]=1;
                    nowindex++;
                }
            }
        }
        
        /*再识别oneof中的*/
        for(int i=0;i<oneofs.lens;i++){
            int nowindex=0;
            int index = oneofs.orlens+i;
            /*识别or中的*/
            for(int j=0;j<oneofs.oneof[index].len;j++){
                for(int k=0;k<oneofs.oneof[index].size[j];k++){
                    isunKnownFact[oneofs.oneof[index].var[nowindex]]=1;
                    nowindex++;
                }
            }
        }
        int state_size=0;
        /*添加known_fact*/
        for(int i=0;i<var_len;i++){
            if(isunKnownFact[i]==0){
                /*处理时不要这个*/
                if(axiomtovar.find(pair<int,int>(i,g_initial_state->vars[i]))==axiomtovar.end()){
                    string var0 = varToSmt(i,g_initial_state->vars[i],0);
                    variables.insert(var0);
                    // cout<<var0<<endl;
                    init_smt+=" ";
                    init_smt+=var0;
                    init_smt+="\n";
                }
            }else{
                state_size++;
            }
        }
        /*遍历所有的oneof,生存oneof的smt代码*/
        for(int i=0;i<oneofs.lens+oneofs.orlens;i++){
            int nowindex;
            /*判断是否oneof里面参数的变量都是一样的，只需要判定第一个每个oneof中的第一个var*/
            // int is1var = true;
            // nowindex = oneofs.oneof[i].size[0];
            set<int> oneofitem;

            //add
            nowindex=0;
            /*存储oneof中的item，用于识别oneof中的item是否重复*/
            std::map<int,int> items;
            for(int j=0;j<oneofs.oneof[i].len;j++){
                for(int k=0;k<oneofs.oneof[i].size[j];k++){
                    if(items.find(oneofs.oneof[i].var[nowindex])==items.end()){
                        items.insert(pair<int,int>(oneofs.oneof[i].var[nowindex],0));
                    }
                    nowindex++;
                }
            }
            
            /*所有oneof中的item对应的SMT*/
            vector<string> all_state;
            /*构建oneof的SMT*/
            // cout<<"is1var:"<<is1var<<endl;
            string first_or=" (or ";
            nowindex=0;
           /*构造oneof的初始SMT*/
            for(int j=0;j<oneofs.oneof[i].len;j++){
                string tmp="";
                /*为oneof和or叠加的，或者oneof中只有一个var(同一个oneof的nota和a)*/
                if(oneofs.type==3||items.size()==1){
                    for(int m=0;m<oneofs.oneof[i].size[j];m++){
                        string var0="";
                        if(oneofs.oneof[i].val[nowindex]<0)
                            var0+=varToSmt(oneofs.oneof[i].var[nowindex],-(oneofs.oneof[i].val[nowindex]+1),0);
                        else
                            var0+=varToSmt(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex],0);
                        variables.insert(var0);
                        
                        /*小于0是oneof中的『item*/
                        if(oneofs.oneof[i].val[nowindex]<0)
                            tmp+="(not ";
                        tmp+=var0;
                        if(oneofs.oneof[i].val[nowindex]<0)
                            tmp+=")";
                        tmp+=" ";
                        nowindex++;
                    }
                }else if(items.size()>1){
                    tmp+="(and ";
                    nowindex=0;
                    //首先将不同的加上
                    for(int k=0;k<oneofs.oneof[i].len;k++){
                        for(int m=0;m<oneofs.oneof[i].size[k];m++){
                            string var0="";
                            if(k==j){
                                if(oneofs.oneof[i].val[nowindex]<0){
                                    var0+=varToSmt(oneofs.oneof[i].var[nowindex],-(oneofs.oneof[i].val[nowindex]+1),0);
                                }
                                else
                                    var0+=varToSmt(oneofs.oneof[i].var[nowindex],oneofs.oneof[i].val[nowindex],0);
                                items[oneofs.oneof[i].var[nowindex]]=1;
                                variables.insert(var0);
                                
                                if((k==j)&&(oneofs.oneof[i].val[nowindex]<0))
                                    tmp+="(not ";
                                tmp+=var0;
                                if((k==j)&&(oneofs.oneof[i].val[nowindex]<0))
                                    tmp+=")";
                                tmp+=" ";

                            }
                            nowindex++;
                        }
                    }
                    //然后将oneof中其他为默认值的变量加入
                    for(auto &it:items){
                        string var0="";
                        if(it.second==0){
                            var0+=varToSmt(it.first,g_variable_domain[it.first]-1,0);
                            variables.insert(var0);
                            tmp+=var0;
                            tmp+=" ";
                        }else if(it.second==1){
                            it.second=0;
                        }
                    }

                    tmp+=")";
                }

                first_or+=tmp;
                first_or+=" ";
                if(i>=oneofs.orlens)
                all_state.push_back(tmp);
            }
            first_or+=")";
            // cout<<first_or<<endl;
            init_smt+=first_or;
            init_smt+="\n";
            if(i>=oneofs.orlens)
                for(int j=0;j<oneofs.oneof[i].len-1;j++){
                    int k=j+1;
                    do{
                        string else_or=" (or ";
                        else_or+="(not ";
                        else_or+=all_state[j];
                        else_or+=") ";
                        else_or+="(not ";
                        else_or+=all_state[k];
                        else_or+="))";
                        init_smt+=else_or;
                        init_smt+="\n";
                        k++;
                    }while(k<oneofs.oneof[i].len);
                }
            all_state.clear();
        }
    }

    /*只需要第一次的时候计算就行，空间换时间*/
    if(smt_simplifier)
        fix_init_smt = init_smt;

    /*5.*/
    /*添加状态大于1的初始反例*/
    if(open_closed_loop_avoidance&&!isfind&&!isfirst)
        for(std::map<string,state_var>::iterator t=appearcounter.begin();t!=appearcounter.end();t++){
            if(t->second.frequency>1){
                string forbiden_initial=" (not (and ";
                for(int i=0;i<t->second.vars.size();i++){
                    if(isunKnownFact[i]){
                        forbiden_initial+=varToSmt(i,t->second.vars[i],0);
                        forbiden_initial+=" ";
                    }
                }
                forbiden_initial+="))";
                init_smt+=forbiden_initial;
                init_smt+="\n";
            }
        }
    /*如果是寻找初始状态，那么要对之前作为过初始状态的状态进行约束*/
    if(open_closed_loop_avoidance&&isfirst){
        for(std::map<string,state_var>::iterator t=firststate.begin();t!=firststate.end();t++){
            string forbiden_initial=" (not (and ";
            for(int j=0;j<t->second.vars.size();j++){
                if(isunKnownFact[j]){
                    forbiden_initial+=varToSmt(j,t->second.vars[j],0);
                    forbiden_initial+=" ";
                }
            }
            forbiden_initial+="))";
            init_smt+=forbiden_initial;
            init_smt+="\n";
        }
    }


    // cout<<endl<<variables.size()<<endl;
    init_smt+="))";
    // cout<<endl<<init_smt;
    free(isunKnownFact);
}

void Counter::addInitRestriction(bool isfirst){
    int var_len = g_initial_state->vars.size();
    int *isunKnownFact = (int*)calloc(var_len,sizeof(int));
    memset(isunKnownFact,0,var_len);
    for(int i=0;i<oneofs.orlens;i++){
        int nowindex=0;
        /*识别or中的*/
        for(int j=0;j<oneofs.oneof[i].len;j++){
            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                isunKnownFact[oneofs.oneof[i].var[nowindex]]=1;
                nowindex++;
            }
        }
    }
    
    /*再识别oneof中的*/
    for(int i=0;i<oneofs.lens;i++){
        int nowindex=0;
        int index = oneofs.orlens+i;
        /*识别or中的*/
        for(int j=0;j<oneofs.oneof[index].len;j++){
            for(int k=0;k<oneofs.oneof[index].size[j];k++){
                isunKnownFact[oneofs.oneof[index].var[nowindex]]=1;
                nowindex++;
            }
        }
    }
   if(open_closed_loop_avoidance&&!isfind&&!isfirst)
        for(std::map<string,state_var>::iterator t=appearcounter.begin();t!=appearcounter.end();t++){
            if(t->second.frequency>1){
                string forbiden_initial=" (not (and ";
                for(int i=0;i<t->second.vars.size();i++){
                    if(isunKnownFact[i]){
                        forbiden_initial+=varToSmt(i,t->second.vars[i],0);
                        forbiden_initial+=" ";
                    }
                }
                forbiden_initial+="))";
                init_smt+=forbiden_initial;
                init_smt+="\n";
            }
        }
    /*如果是寻找初始状态，那么要对之前作为过初始状态的状态进行约束*/
    if(open_closed_loop_avoidance&&isfirst){
        for(std::map<string,state_var>::iterator t=firststate.begin();t!=firststate.end();t++){
            string forbiden_initial=" (not (and ";
            for(int j=0;j<t->second.vars.size();j++){
                if(isunKnownFact[j]){
                    forbiden_initial+=varToSmt(j,t->second.vars[j],0);
                    forbiden_initial+=" ";
                }
            }
            forbiden_initial+="))";
            init_smt+=forbiden_initial;
            init_smt+="\n";
        }
    }
    free(isunKnownFact);
}


void Counter::addAxiomSmt(pair<int,int> vari,string *pre_smt,int timestep){

}
/*设置为true*/


/*设置为false*/


/*删除当前节点*/
/*type=0:当前设置为true，type=1:当前节点设置为false，type=2:删除当前节点 */
void Counter::deleteRedundancyNode(treeNode* pnow,int type){    
    if(type==0||type==1){
        string pnowname = " ";
        pnowname+=varToSmt(pnow->var, pnow->val, pnow->timestep);
        pnowname += " ";
        string replacement = type == 0 ? " true " : " false ";
        for(int i=0;i<pnow->fathers.size();i++){
            treeNode* cur = pnow->fathers[i];
            size_t pos = 0;
            while ((pos = cur->assert.find(pnowname, pos)) != std::string::npos) {
                cur->assert.replace(pos, pnowname.length(), replacement);
                pos += replacement.length(); // 处理替换后字符串长度变化的情况
            }
            for(int j=0;j<cur->childrens.size();j++){
                if(pnow==cur->childrens[j]){
                    cur->childrens.erase(cur->childrens.begin()+j);
                    break;
                }
            }
        }
        // for(auto ite:pnow->fathers){
        //     size_t pos = 0;
        //     while ((pos = ite->assert.find(pnowname, pos)) != std::string::npos) {
        //         ite->assert.replace(pos, pnowname.length(), replacement);
        //         pos += replacement.length(); // 处理替换后字符串长度变化的情况
        //     }
        //     for(auto ite1:ite->childrens){
        //         if(ite1==pnow){

        //         }
        //     }
        // }

    }else if(type==2){
        //删除pnow,修改父亲和儿子节点指针
        treeNode* p_previous, *p_next=pnow->childrens[0];
        for(int i=0;i<pnow->fathers.size();i++){
            treeNode* cur = pnow->fathers[i];
            for(int j=0;j<cur->childrens.size();j++){
                if(pnow==cur->childrens[j]){
                    string pnowname = " ";
                    pnowname+= varToSmt(pnow->var, pnow->val, pnow->timestep);
                    pnowname += " ";
                    string replacement = " ";
                    replacement+=varToSmt(p_next->var, p_next->val, p_next->timestep);
                    replacement += " ";
                    size_t pos = 0;
                    while ((pos = cur->assert.find(pnowname, pos)) != std::string::npos) {
                        cur->assert.replace(pos, pnowname.length(), replacement);
                        pos += replacement.length(); // 处理替换后字符串长度变化的情况
                    }
                    cur->childrens[j] = p_next;
                    int havethisfather = 0;
                    for(int k=0;k<p_next->fathers.size();k++){
                        if(p_next->fathers[k]==pnow){
                            p_next->fathers[k]=cur;
                            havethisfather=1;
                            break;
                        }
                    }
                    if(havethisfather==0){
                        p_next->fathers.push_back(cur);
                    }

                    // delete pnow;
                    // p_next->fathers[0] = cur;
                    break;

                }
            }
        }
        
        /*替换指向*/
        // for(auto ite:pnow->fathers){
        //     for(auto ite1:ite->childrens){
        //         if(pnow==ite1){
        //             string pnowname = varToSmt(pnow->var,pnow->val,pnow->timestep);
        //             string replacement = varToSmt(p_next->var,p_next->val,p_next->timestep);
        //             size_t pos = 0;
        //             while ((pos = ite->assert.find(pnowname, pos)) != std::string::npos) {
        //                 ite->assert.replace(pos, pnowname.length(), replacement);
        //                 pos += replacement.length(); // 处理替换后字符串长度变化的情况
        //             }
        //             ite1 = p_next;
        //             break;
        //         }
        //     }
        // }
        // /*删除当前节点*/
        // delete pnow;
    }
}


string Counter::regretCurFact(const Operator *a,set<string> *preference_var,pair<int,int> now_facts,set<pair<int,int> > *new_facts,std::map<pair<int,int>,treeNode*> &nowtreeleaf,std::map<pair<int,int>,treeNode*> &newtreeleaf, set< treeNode* > &trash_nodes ,int time_step){
    // cout<<a->get_name()<<"--"<<g_variable_name[now_facts.first] << ": " << now_facts.second<<" "<<time_step<<endl;
    string fact_regret_smt="(or ",add_smt = "(or false ",notdel_smt="(not (or false ";
    string regret_assert;
    string cur_fact = varToSmt(now_facts.first,now_facts.second,time_step);
    string now_fact = varToSmt(now_facts.first,now_facts.second,time_step-1);
    int haveaddfacts=0,havedelfacts=0,del2cur=0;
    set<pair<int,int>> addingfacts;
    addingfacts.insert(pair<int,int>(now_facts.first,now_facts.second));

    bool addistrue = false, delistrue = false;
    if(!smt_simplifier)
        variables.insert(now_fact);

    if(smt_simplifier){
        treeNode *pnow = nowtreeleaf[now_facts];
        if(pnow!=NULL){
            //1.创建新叶子
            treeNode * newtree = new treeNode;
            newtree->var = now_facts.first;
            newtree->val = now_facts.second;
            newtree->assert = "";
            newtree->father = cur_fact;
            newtree->timestep = time_step-1;
            /*添加父节点*/
            newtree->fathers.push_back(pnow);
            // newtree->repeated_fathers.insert(pair<pair<int,int>,int>(pair<int,int>(pnow->var,pnow->val),pnow->timestep));
            if(newtreeleaf.find(pair<int,int>(pair<int,int>(newtree->var,newtree->val)))!=newtreeleaf.end()){
                if(pnow->repeated_childrens.find(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep))==pnow->repeated_childrens.end()){
                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += " ";
                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += cur_fact;
                    /*添加父节点*/
                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->fathers.push_back(pnow);
                    pnow->childrens.push_back(newtreeleaf[pair<int, int>(newtree->var, newtree->val)]);
                    pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
                }
                delete newtree;
            }else{
                trash_nodes.insert(newtree);
                pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
                pnow->childrens.push_back(newtree);
                newtreeleaf.insert(pair<pair<int,int>,treeNode*>(pair<int,int>(newtree->var,newtree->val),newtree));
            }
                
            //2.找到父亲节点，并且赋予，同时加入到newleafnode里面  
        }
        
    }
    new_facts->insert(now_facts);

    vector<PrePost> prepost = a->get_pre_post();
    vector<Prevail> prevail = a->get_prevail();
    
    /*这里还要添加满足前置条件，才能保证这个谓语是，满足这个动作，不然会出现，不满足这个动作的前置条件，但是满足条件影响*/
    /*满足前置条件并且满足条件影响，才能被添加或者被删除*/
    for(int i=0;i<prepost.size();i++){
        if(a->isadd(now_facts.first,now_facts.second,i)){
            if(prepost[i].cond.size()>1)
                    add_smt+="(and ";
            if(prepost[i].cond.size()>0){
                
                for (int j = 0; j < prepost[i].cond.size(); j++)
                {
                    haveaddfacts++;
                    addingfacts.insert(pair<int,int>(prepost[i].cond[j].var,prepost[i].cond[j].prev));
                    string vari = varToSmt(prepost[i].cond[j].var,prepost[i].cond[j].prev,time_step-1);
                    if(!smt_simplifier)
                        variables.insert(vari);
                    add_smt+= vari;
                    add_smt+=" ";
                    
                    if(smt_simplifier&&(now_fact.compare(vari)!=0)){
                        treeNode *pnow = nowtreeleaf[now_facts];
                        if(pnow!=NULL){
                            //1.创建新叶子
                            treeNode *newtree;
                            newtree = new treeNode;
                            newtree->var = prepost[i].cond[j].var;
                            newtree->val = prepost[i].cond[j].prev;
                            newtree->assert = "";
                            newtree->father = cur_fact;
                            newtree->timestep = time_step-1;;
                            newtree->fathers.push_back(pnow);
                            if (newtreeleaf.find(pair<int, int>(newtree->var, newtree->val)) != newtreeleaf.end()){
                                if(pnow->repeated_childrens.find(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep))==pnow->repeated_childrens.end()){
                                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += " ";
                                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += cur_fact;
                                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->fathers.push_back(pnow);
                                    pnow->childrens.push_back(newtreeleaf[pair<int, int>(newtree->var, newtree->val)]);
                                    pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
                                }
                                // pnow->childrens.push_back(newtreeleaf[pair<int, int>(newtree->var, newtree->val)]);
                                delete newtree;
                            }else{
                                trash_nodes.insert(newtree);
                                pnow->childrens.push_back(newtree);
                                newtreeleaf.insert(pair<pair<int, int>, treeNode *>(pair<int, int>(newtree->var, newtree->val), newtree));
                                pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
                            }

                                

                            //2.找到父亲节点，并且赋予，同时加入到newleafnode里面
                            
                            
                        }
                        
                    }
                    new_facts->insert(pair<int,int>(prepost[i].cond[j].var,prepost[i].cond[j].prev));
                }
                /*还需要添加前置条件*/
                // for(int j=0;j<prevail.size();j++){
                //     string vari = varToSmt(prevail[j].var,prevail[j].prev,time_step-1);
                //     // preference_var->insert(vari);
                //     variables.insert(vari);
                //     add_smt+= vari;
                //     add_smt+=" ";
                //     new_facts->insert(pair<int,int>(prevail[j].var,prevail[j].prev));
                // }
            }
            else{
                add_smt+= "true";
                add_smt+=" ";
                addistrue = true;
            }
            if(prepost[i].cond.size()>1)
                add_smt+=") ";
        }
        if(a->isdel(now_facts.first,now_facts.second,i)){
            if(prepost[i].cond.size()>1)
                    notdel_smt+="(and ";
            if(prepost[i].cond.size()>0){
 
                for (int j = 0; j < prepost[i].cond.size(); j++)
                {
                    havedelfacts++;
                    addingfacts.insert(pair<int,int>(prepost[i].cond[j].var,prepost[i].cond[j].prev));
                    string vari = varToSmt(prepost[i].cond[j].var, prepost[i].cond[j].prev, time_step - 1);
                    if(vari.compare(now_fact)==0)
                        del2cur = 1;
                    if(!smt_simplifier)
                        variables.insert(vari);
                    notdel_smt+= vari;
                    notdel_smt+=" ";
                    
                    if(smt_simplifier&&(now_fact.compare(vari)!=0)){
                        treeNode *pnow = nowtreeleaf[now_facts];
                        if(pnow!=NULL){
                            //1.创建新叶子
                            treeNode *newtree;
                            newtree = new treeNode;
                            newtree->var = prepost[i].cond[j].var;
                            newtree->val = prepost[i].cond[j].prev;
                            newtree->assert = "";
                            newtree->father = cur_fact;
                            newtree->timestep = time_step-1;
                            newtree->fathers.push_back(pnow);
                            if(newtreeleaf.find(pair<int,int>(newtree->var,newtree->val))!=newtreeleaf.end()){
                                if(pnow->repeated_childrens.find(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep))==pnow->repeated_childrens.end()){
                                    pnow->childrens.push_back(newtreeleaf[pair<int, int>(newtree->var, newtree->val)]);
                                    pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
                                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += " ";
                                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += cur_fact;
                                    newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->fathers.push_back(pnow);
                                }
                                // pnow->childrens.push_back(newtreeleaf[pair<int,int>(newtree->var,newtree->val)]);
                                delete newtree;
                            }else{
                                trash_nodes.insert(newtree);
                                newtreeleaf.insert(pair<pair<int,int>,treeNode*>(pair<int,int>(newtree->var,newtree->val),newtree));
                                pnow->childrens.push_back(newtree);
                                pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));  
                            }

                            

                            //2.找到父亲节点，并且赋予，同时加入到newleafnode里面
                           
                            
                        }
                    }
                    new_facts->insert(pair<int,int>(prepost[i].cond[j].var,prepost[i].cond[j].prev));
                }
                /*还需要添加前置条件*/
                // for(int j=0;j<prevail.size();j++){
                //     string vari = varToSmt(prevail[j].var,prevail[j].prev,time_step-1);
                //     // preference_var->insert(vari);
                //     variables.insert(vari);
                //     notdel_smt+= vari;
                //     notdel_smt+=" ";
                //     new_facts->insert(pair<int,int>(prevail[j].var,prevail[j].prev));
                // }
            }
            else{
                notdel_smt+= "true";
                notdel_smt+=" ";
                delistrue= true;
            }
            if(prepost[i].cond.size()>1)
                notdel_smt+=") ";
        }
    }
    add_smt+=")";
    notdel_smt+="))";
    // cout<<"add:"<<add_smt<<" del:"<<notdel_smt<<endl<<endl;
    /*提取回归的前置条件*/
    for(int i=0;i<prevail.size();i++){
        string vari = varToSmt(prevail[i].var,prevail[i].prev,time_step-1);
        
        /*前置条件下的,应该归为head下的节点*/
        if(smt_simplifier&&(preference_var->find(vari)==preference_var->end())){
            //1.创建新叶子
            treeNode *newtree ;
            newtree = new treeNode;
            newtree->var = prevail[i].var;
            newtree->val = prevail[i].prev;
            newtree->assert = "";
            newtree->father = "head";
            newtree->timestep = time_step-1;
            newtree->fathers.push_back(head);
            if(newtreeleaf.find(pair<int,int>(newtree->var,newtree->val))!=newtreeleaf.end()){
                newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += " ";
                newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->father += "head";
                newtreeleaf[pair<int, int>(newtree->var, newtree->val)]->fathers.push_back(head);
                head->childrens.push_back(newtreeleaf[pair<int, int>(newtree->var, newtree->val)]);
                delete newtree;
            }else{
                trash_nodes.insert(newtree);
                newtreeleaf.insert(pair<pair<int,int>,treeNode*>(pair<int,int>(newtree->var,newtree->val),newtree));
                head->childrens.push_back(newtree);
                // head->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
            }
            //2.找到父亲节点，并且赋予，同时加入到newleafnode里面
            
            
        }
        preference_var->insert(vari);
        if(!smt_simplifier)
            variables.insert(vari);
        new_facts->insert(pair<int,int>(prevail[i].var,prevail[i].prev));
    }
    fact_regret_smt+="(and ";
    fact_regret_smt+=add_smt;
    fact_regret_smt+=" ";
    fact_regret_smt+=notdel_smt;
    fact_regret_smt+=") ";
    fact_regret_smt+="(and ";
    fact_regret_smt+=now_fact;
    fact_regret_smt+=" ";
    fact_regret_smt+=notdel_smt;
    fact_regret_smt+="))";

    if(smt_simplifier){
        regret_assert="";
        regret_assert+=" (= ";
        regret_assert+=cur_fact;
        regret_assert+=" ";
        regret_assert+=fact_regret_smt;
        regret_assert+=")";
        treeNode *pnow = nowtreeleaf[pair<int,int>(now_facts.first,now_facts.second)];
        if(pnow!=NULL){
            // pnow->timestep = i+1;
            pnow->assert = regret_assert;
            if(addistrue&&!delistrue)
                pnow->istrue = 1;
            if (delistrue)
                pnow->isfalse = 1;
            if(havedelfacts==1&&haveaddfacts==0&&del2cur==1)   
                pnow->isfalse = 1;
        }
        // cout<<addingfacts.size()<<endl;
        if(pnow->istrue==1){
            /*pnow的父亲节点，全部将其设置为true，并且删除这个儿子*/
            deleteRedundancyNode(pnow,0);
        }
        else if (pnow->isfalse == 1)
        {
            deleteRedundancyNode(pnow,1);
            /*pnow的父亲节点，全部将其设置为false，并且删除这个儿子*/
        }
        else if (addingfacts.size() == 1)
        {
            deleteRedundancyNode(pnow,2);
            
            /*如果pnow的父亲节点也只有pnow一个儿子，那么直接将pnow删除*/
        }
        addingfacts.clear();
    }else{
        regret_smt+=" (= ";
        regret_smt+=cur_fact;
        regret_smt+=" ";
        regret_smt+=fact_regret_smt;
        regret_smt+=")\n";
    }

    return regret_assert;
    // cout<<regret_smt<<endl;

}

void Counter::addActionToGoal(Plan plan){
    // dump_everything();
    regret_smt = "(assert (and true ";
    /*构成前置条件和目标的smt公式*/
    string preference = " (not (and ";
    set<string> preference_var;
    set<pair<int,int> > now_facts;
    set<pair<int,int> > new_facts;
    set<treeNode*> trash_nodes;
    int plan_size = plan.size();
    bool haveaxiom = false;
    /*用于创建树*/
    head = new treeNode;
    head->var=0;
    head->val=0;
    head->timestep=1;

    std::map<pair<int,int>,treeNode*> nowtreeleaf;
    std::map<pair<int,int>,treeNode*> newtreeleaf;

    /*添加目标状态:*/
    for(int i = 0; i < g_goal.size(); i++){
        string var_goal = varToSmt(g_goal[i].first,g_goal[i].second,plan_size);
        preference_var.insert(var_goal);
        variables.insert(var_goal);
        now_facts.insert(pair<int, int>(g_goal[i].first, g_goal[i].second));

        if(smt_simplifier){
            treeNode *newtree = new treeNode;
            newtree->var = g_goal[i].first;
            newtree->val = g_goal[i].second;
            newtree->timestep = plan_size;
            newtree->assert = "";
            newtree->father = "head";
            newtree->fathers.push_back(head);
            
            trash_nodes.insert(newtree);
            // if(newtree->repeated_fathers.find(pair<pair<int,int>,int>(pair<int,int>(-1,-1),-1))==newtree->repeated_fathers.end()){
                
            //     newtree->repeated_fathers.insert(pair<pair<int,int>,int>(pair<int,int>(-1,-1),-1));
            // }

            if(head->repeated_childrens.find(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep))==head->repeated_childrens.end()){
                head->childrens.push_back(newtree);
                head->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
            }

            nowtreeleaf.insert(pair<pair<int,int>,treeNode*>(pair<int,int>(newtree->var,newtree->val),newtree));
        }
    }
    /*处理axiom，如果目标是axiom，需要加入其到变量的转换*/
    for(auto now_fact:now_facts){
        // cout<<now_fact.first<<" "<<now_fact.second<<endl;
        if(axiomtovar.find(now_fact)!=axiomtovar.end()){
            haveaxiom = true;
            vector<PrePost> pre_post = axiomtovar[now_fact];
            string vari = varToSmt(now_fact.first,now_fact.second,plan_size);
            variables.insert(vari);
            string axiom_smt="(= ";
            axiom_smt+=vari;
            axiom_smt+=" (or ";
            for(int i=0;i<pre_post.size();i++){
                string one_axiom="(and ";
                string varj = varToSmt(pre_post[i].var,pre_post[i].pre,plan_size);
                // variables.insert(varj);
                // one_axiom+=varj;
                // one_axiom+=" ";
                // new_facts.insert(pair<int,int>(pre_post[i].var,pre_post[i].pre));
                // cout<<"(-["<<ot.second[i].var<<","<<ot.second[i].pre<<"]-";
                for(int j=0;j<pre_post[i].cond.size();j++){
                    varj = varToSmt(pre_post[i].cond[j].var,pre_post[i].cond[j].prev,plan_size);
                    if(!smt_simplifier)
                        variables.insert(varj);
                    one_axiom+=varj;
                    one_axiom+=" ";
                    new_facts.insert(pair<int,int>(pre_post[i].cond[j].var,pre_post[i].cond[j].prev));
                    
                    /*增加叶子*/
                    if(smt_simplifier){
                        treeNode *pnow = nowtreeleaf[pair<int,int>(now_fact.first,now_fact.second)];
                        if(pnow!=NULL){
                            //1.创建新叶子
                            treeNode *newtree = new treeNode;
                            newtree->var = pre_post[i].cond[j].var;
                            newtree->val = pre_post[i].cond[j].prev;
                            newtree->timestep = plan_size;
                            newtree->assert = "";
                            newtree->father = vari;
                            /*添加父节点*/
                            newtree->fathers.push_back(pnow);
                            // newtree->repeated_fathers.insert(pair<pair<int,int>,int>(pair<int,int>(pnow->var,pnow->val),pnow->timestep));
                            // 2.找到父亲节点，并且赋予，同时加入到newleafnode里面
                            if(pnow->repeated_childrens.find(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep))==pnow->repeated_childrens.end()){
                                trash_nodes.insert(newtree);
                                pnow->childrens.push_back(newtree);
                                pnow->repeated_childrens.insert(pair<pair<int,int>,int>(pair<int,int>(newtree->var,newtree->val),newtree->timestep));
                                newtreeleaf.insert(pair<pair<int,int>,treeNode*>(pair<int,int>(newtree->var,newtree->val),newtree));
                            }else{
                                delete newtree;
                            }

                            // pnow->childrens.push_back(newtree);
                        }
                    }
                    // cout<<"["<<ot.second[i].cond[j].var<<","<<ot.second[i].cond[j].prev<<"]-";
                }
                one_axiom+=") ";
                axiom_smt+=one_axiom;
                // cout<<")"<<endl;
            }
            axiom_smt+="))\n";
            // cout<<axiom_smt<<endl;
            
            // 在nowtreeleaf里面找到这个并赋予
            if(smt_simplifier){
                treeNode *pnow = nowtreeleaf[pair<int,int>(now_fact.first,now_fact.second)];
                if(pnow!=NULL)
                    pnow->assert = axiom_smt;
            }
            regret_smt+=axiom_smt;
            // cout<<"->["<<ot.first.first<<"-"<<ot.first.second<<"]"<<endl;
        }else{
            new_facts.insert(now_fact);
        }
    }
    
    if (haveaxiom && smt_simplifier)
    {
        nowtreeleaf.clear();
        nowtreeleaf = newtreeleaf;
        newtreeleaf.clear();
    }

    now_facts.clear();
    now_facts=new_facts;
    new_facts.clear();
    /*从目标状态开始进行回归*/
    for(int i=plan_size-1;i>=0;i--){
        /*对nowfact添加axiom*/ 
        //  cout<<"size:"<<now_facts.size()<<endl;
        
        for(set<pair<int, int> >::iterator iter=now_facts.begin(); iter!=now_facts.end(); iter++){
            string newassert =  regretCurFact(plan[i],&preference_var,pair<int,int>(iter->first,iter->second),&new_facts, nowtreeleaf,newtreeleaf,trash_nodes,i+1);
            // if(smt_simplifier){
            //     treeNode *pnow = nowtreeleaf[pair<int,int>(iter->first,iter->second)];
            //     if(pnow!=NULL){
            //         pnow->timestep = i+1;
            //         pnow->assert = newassert;
            //     }
                
            // }
        }
        now_facts.clear();
        if(smt_simplifier)
            nowtreeleaf.clear();
        
        for(auto new_fact:new_facts){
            // cout<<now_fact.first<<" "<<now_fact.second<<endl;
            now_facts.insert(new_fact);
        }
        if(smt_simplifier)
            nowtreeleaf = newtreeleaf;

        new_facts.clear();
        if(smt_simplifier)
            newtreeleaf.clear();
    }
    /*回归完，对preference进行拼接*/
    if(!smt_simplifier){
        for(set<string>::iterator iter=preference_var.begin(); iter!=preference_var.end(); iter++){
            preference+=*iter;
            preference+="\n ";
        }
        preference+=" ))\n";
        regret_smt+=preference;
        regret_smt+="))";
    }
    
    // cout<<regret_smt<<endl;

    // treeNode *pnow = nowtreeleaf[pair<int, int>(9, 9)];
    // cout << "isnull:" << (pnow == NULL )<< endl;
    // pnow = nowtreeleaf[pair<int,int>(0,0)];
    // cout << "isnull:" << (pnow == NULL )<< endl;
    if(smt_simplifier){
        travelTree(head);
        for(auto ite:trash_nodes){
            delete ite;
        }
        trash_nodes.clear();
    }
        
    // delete head;
    // cout<<"规划长度："<<plan.size()<<endl;
    // for(int i=0;i<plan.size();i++){
    //     cout<<plan[i]->get_name()<<" ";
    // }
    // cout<<endl;
}

class CompareNodes {
public:
    bool operator()(const treeNode* lhs, const treeNode* rhs) const {
        /*小于升序,大于降序*/
        if(lhs->var>rhs->var){
            return true;
        }else if(lhs->var==rhs->var){
            if(lhs->val<rhs->val){
                return true;
            }else if(lhs->val==rhs->val){
                return lhs->timestep>rhs->timestep;
            }
        }
        return false; // 按照值降序排序
    }
};


void Counter::travelTree(treeNode *head){
    int i=0,j=0,nownodes=0,k=0;
    vector<treeNode*> nowstack;
    set<treeNode*,CompareNodes> now_nodes,new_nodes;
    set<string> addingassert;
    vector<int> nodes;

    int flag = 1;
    regret_smt = "(assert (and true ";
    /*构成前置条件和目标的smt公式*/
    string preference = " (not (and ";

    // cout<<"head"<<endl;
    for (auto ite : head->childrens)
    {
        // cout<<varToSmt(ite->var,ite->val,ite->timestep);
        if(ite->istrue==0){
            string prevar = varToSmt(ite->var,ite->val,ite->timestep);
            preference += prevar;
            preference += "\n";
            variables.insert(prevar);
            nowstack.push_back(ite);
            now_nodes.insert(ite);
            j++;
        }
        
    }
    // cout<<endl<<now_nodes.size()<<endl;
    delete head;
    nownodes += j;
    j = 0;

    if(flag==0)
    while (i < nowstack.size())
    {
        if(nowstack[i]->istrue){
            cout << varToSmt(nowstack[i]->var, nowstack[i]->val, nowstack[i]->timestep) << " true (father:";
            for(auto ite :nowstack[i]->fathers){
                cout<<varToSmt(ite->var, ite->val, ite->timestep)<<" ";
            }
            cout<<") "<<endl;
            // cout << varToSmt(nowstack[i]->var, nowstack[i]->val, nowstack[i]->timestep) << " true (father:" << nowstack[i]->father << ")" << nowstack[i]->assert << endl;
        }
        else if(nowstack[i]->isfalse){
            cout << varToSmt(nowstack[i]->var, nowstack[i]->val, nowstack[i]->timestep) << " false (father:";
            for(auto ite :nowstack[i]->fathers){
                 cout<<varToSmt(ite->var, ite->val, ite->timestep)<<" ";
            }
            cout<<") "<<endl;
            // cout << varToSmt(nowstack[i]->var, nowstack[i]->val, nowstack[i]->timestep) << " false (father:" << nowstack[i]->father << ")" << nowstack[i]->assert << endl;
        }
        else{
            cout << varToSmt(nowstack[i]->var, nowstack[i]->val, nowstack[i]->timestep) << "(father:";
            for(auto ite :nowstack[i]->fathers){
                 cout<<varToSmt(ite->var, ite->val, ite->timestep)<<" ";
            }
            cout<<") "<<endl;
            // cout << varToSmt(nowstack[i]->var, nowstack[i]->val, nowstack[i]->timestep) << "(father:" << nowstack[i]->father << ")" << nowstack[i]->assert << endl;
        }
            
        // cout << g_variable_name[nowstack[i]->var] << "-" << "val:" << nowstack[i]->val << "-step:" << nowstack[i]->timestep << "(" << nowstack[i]->father << ")" << endl;
        // j = 0;
        for (auto ite : nowstack[i]->childrens)
        {
            nowstack.push_back(ite);
            j++;
        }
        // nodes.push_back(j);
        i++;
        if(i==nownodes){
            cout << endl;
            nownodes+=j;
            j = 0;
        }
    }
    if(flag==1){
        while(now_nodes.size()>0){
            
            for(auto ite :now_nodes){
                if(addingassert.find(ite->assert)==addingassert.end()){
                    regret_smt += ite->assert;
                    regret_smt += "\n";
                    addingassert.insert(ite->assert);
                    string vari = varToSmt(ite->var, ite->val, ite->timestep);
                    variables.insert(vari);
                }

                // cout<<"hear"<<now_nodes.size()<<endl;
                // if(ite==NULL){
                //     continue;
                // }
                // if(ite->istrue){
                //     cout << varToSmt(ite->var, ite->val, ite->timestep) << " true (father:";
                    
                //     // for(auto ite1 :ite->fathers){
                //     //     if(ite1==head)
                //     //         cout<<"head ";
                //     //     else
                //     //     cout<<varToSmt(ite1->var, ite1->val, ite1->timestep)<<" ";
                //     // }
                //     cout<<") "<<ite->assert<<endl;
                //     // cout << varToSmt(ite->var, ite->val, ite->timestep) << " true (father:" << ite->father << ")" << ite->assert << endl;

                // }
                // else if(ite->isfalse){
                //     cout << varToSmt(ite->var, ite->val, ite->timestep) << " false (father:"  ;
                //     // for(auto ite1 :ite->fathers){
                //     //     if(ite1==head)
                //     //         cout<<"head ";
                //     //     else
                //     //     cout<<varToSmt(ite1->var, ite1->val, ite1->timestep)<<" ";
                //     // }
                //     cout<<") "<<ite->assert<<endl;
                //     // cout << varToSmt(ite->var, ite->val, ite->timestep) << " false (father:" << ite->father << ")" << ite->assert << endl;
                // }
                // else{
                //     // cout<<"hear2"<<endl;
                //     cout << varToSmt(ite->var, ite->val, ite->timestep) << "(father:" ;
                //     // cout<<"hear2"<<endl;
                //     // for(auto ite1 :ite->fathers){
                //     //     // cout<<ite1->var<<endl;
                //     //     // cout<<"hear2"<<endl;
                //     //     if(ite1==head)
                //     //         cout<<"head ";
                //     //     else
                //     //     cout<<varToSmt(ite1->var, ite1->val, ite1->timestep)<<" ";
                //     //     // cout<<"hear2"<<endl;
                //     // }
                    
                //     cout<<") "<<ite->assert<<endl;

                //     // cout << varToSmt(ite->var, ite->val, ite->timestep) << "(father:" << ite->father << ")" << ite->assert << endl;
                // }
                
                /*删除一个节点,需要将所有引用都删除*/
                //删除父亲
                // for(i=0;i<ite->fathers.size();i++){
                //     for(j=0;j<ite->fathers[i]->childrens.size();j++){
                //         if(ite == ite->fathers[i]->childrens[j])
                //             ite->fathers[i]->childrens.erase(ite->fathers[i]->childrens.begin()+j);
                //     }
                // }
                // //删除儿子
                // for(i=0;i<ite->childrens.size();i++){
                //     for(j=0;j<ite->childrens[i]->fathers.size();j++){
                //         if(ite->childrens[i]->fathers[j]==ite)
                //             ite->childrens[i]->fathers.erase(ite->childrens[i]->fathers.begin()+j);
                //     }
                // }

                for (auto ite1 : ite->childrens)
                {
                    new_nodes.insert(ite1);
                }
                // delete ite;
                // ite = NULL;
                
            }
            
            now_nodes.clear();
            now_nodes = new_nodes;
            new_nodes.clear();
            // cout<<endl;
        }
    }

    preference+=" ))\n";
    regret_smt+=preference;
    regret_smt+="))";

    return;
}





void Counter::addRestraintToTime0(){
    sasrestraint_smt = "(assert (and ";
    for(int i=0;i<g_variable_domain.size();i++){
        string ors=" (or ";
        for(int j=0;j<g_variable_domain[i]-1;j++){
            string var0 = varToSmt(i,j,0);
            for(int k=j+1;k<g_variable_domain[i];k++){
                string tmp = " (or (not ";
                string var1 = varToSmt(i,k,0);
                tmp +=var0;tmp+=") (not ";
                tmp+=var1;tmp+="))\n";
                sasrestraint_smt+=tmp;
                variables.insert(var1);
            }
            ors+=var0;ors+=" ";
            variables.insert(var0);
        }
        string var0 = varToSmt(i,g_variable_domain[i]-1,0);
        variables.insert(var0);
        ors+=var0;ors+=")\n";
        sasrestraint_smt+=ors;
    }
    sasrestraint_smt+="))";
    // cout<<sasrestraint_smt<<endl;
}

bool Counter::invokeSMTSolver(){
    std::map<int,int> sample;
    std::vector<int> base_state = g_initial_state->vars;

    clock_t start_clock = clock();
    SMT_counter solver;
    SMT_counter::SolveReport report;
    bool isFind = solver.extractCounter(smt, variables, &sample, &report);
    clock_t end_clock = clock();

    lastcountertime = (int)(((double)(end_clock - start_clock) / CLOCKS_PER_SEC) * 1000.0);
    last_validation_stats_.solver_and_extract_time_ms = lastcountertime;
    last_validation_stats_.requested_solver_backend = report.requested_backend;
    last_validation_stats_.used_solver_backend = report.used_backend;
    last_validation_stats_.requested_solver_available = report.requested_backend_available;
    last_validation_stats_.used_fallback_solver = report.used_fallback_solver;
    last_validation_stats_.result_valid = report.result_valid;
    last_validation_stats_.has_counterexample = isFind;
    last_validation_stats_.smt_variable_count = report.model_const_count > 0 ? report.model_const_count : lastsmtvariables;
    last_validation_stats_.sample_valid = false;
    last_validation_stats_.counterexample_state.clear();
    last_validation_stats_.solver_message = report.error_message;

    if(report.used_fallback_solver) {
        cout << "[SMT] 请求后端 " << smt_solver_backend_name((SMTSolverBackend)report.requested_backend)
             << " 不可用或执行失败，已回退到 "
             << smt_solver_backend_name((SMTSolverBackend)report.used_backend) << endl;
    }
    if(!report.result_valid && !report.error_message.empty()) {
        cout << "[SMT] 求解器返回不可用结果: " << report.error_message << endl;
    }

    cout << isFind << endl;
    if(isFind){
        isfind=false;
        std::vector<int> smt_state = base_state;
        for(int i=0;i<g_initial_state->vars.size();i++){
          int var = indextovar[i];
          if(sample.find(var)!=sample.end()) {
              smt_state[i] = sample[var];
              g_initial_state->set_var(i,sample[var]);
          }
        }
        last_validation_stats_.counterexample_state = smt_state;
        last_validation_stats_.sample_valid = true;

        string statestring = stateToString(g_initial_state);
        if(appearcounter.find(statestring)==appearcounter.end()){
            state_var tmp;
            tmp.frequency=1;
            tmp.vars = g_initial_state->vars;
            appearcounter.insert(pair<string,state_var>(statestring,tmp));
            counterset_new.push_back(tmp);
        }else{
            appearcounter[statestring].frequency++;
            cout<<"已经出现过"<<endl;
        }
        int k=1;
        // for(std::map<string,state_var>::iterator t=appearcounter.begin();t!=appearcounter.end();t++){
        //     cout<<"状态"<<k<<"出现在反例集中的次数："<<t->second.frequency<<endl;
        //     k++;
        // }
        return true;
    }else{
        if(isfind){
            findvalidplan = true;
        }else if(!isfind&&open_closed_loop_avoidance){
            isfind=true;
            int restrictsize = 0;
            for(std::map<string,state_var>::iterator t=appearcounter.begin();t!=appearcounter.end();t++)
                if(t->second.frequency>1){
                    restrictsize++;
                }
            if(restrictsize==0)
                findvalidplan = true;
        }else if(!isfind&&!open_closed_loop_avoidance){
            isfind=true;
            findvalidplan=true;
        }
        return false;
    }
}


bool Counter::conputerCounter(Plan plan,bool isfirst){
    clock_t total_begin_clock = clock();
    last_validation_stats_ = SMTValidationStats();
    smt="";

    clock_t build_begin_clock = clock();
    obtainKnownLiteral(plan);
    /*转换初始状态为SMT公式*/
    /*修改不是每次都调用,只在创建时调用*/
    initToSmt(isfirst); 
    addActionToGoal(plan);
    addRestraintToTime0();
    for(set<string>::iterator iter=variables.begin(); iter!=variables.end(); iter++){
		smt+="(declare-const ";
        smt+=*iter;
        smt+=" Bool)\n";
    }
    lastsmtvariables = variables.size();

    smt += init_smt;
    smt+=regret_smt;
    smt+=sasrestraint_smt;
    clock_t build_end_clock = clock();
    last_validation_stats_.build_time_ms = (int)(((double)(build_end_clock - build_begin_clock) / CLOCKS_PER_SEC) * 1000.0);
    last_validation_stats_.smt_variable_count = lastsmtvariables;

    /*调用z3求解器求反例，并且进行提取*/
    int isvaliplan = false;
    isvaliplan = invokeSMTSolver();
    clearAll();
    clock_t total_end_clock = clock();
    int total_ms = (int)(((double)(total_end_clock - total_begin_clock) / CLOCKS_PER_SEC) * 1000.0);
    total_counter+=total_ms;
    last_validation_stats_.total_time_ms = total_ms;
    last_validation_stats_.has_counterexample = isvaliplan;
    last_validation_stats_.smt_variable_count = lastsmtvariables;
    return isvaliplan;
}

int  Counter::planType(){
    /*1.获取到两个不同的状态*/

    /*2.进行四次调用：分别求解两个状态的解，分别求解两个状态到互相的解*/

    /*3.如果到互相的解有的，那么设置为1，否则，判断这个两个状态的解是否对对方有影响，有那么设置为2，否这设置为3*/
}

void Counter::superCounter(){
    if(oneofs.type==2){
        
        for(int i=0;i<oneofs.lens;i++){
            /*第一步：判断此反例中，oneof的哪个item已经出现*/
            int appearindex=-1;
            int nowindex = 0;
            // cout<<endl;
            // for(int j=0;j<oneofs.oneof[i].len;j++){
            //     cout<<tags.oneof[i].size[j]<<" ";
            // }
            // cout<<endl;
            for(int j=0;j<oneofs.oneof[i].len;j++){
                /*判断是否出现*/
                int flag = 1;
                for(int k=0;k<oneofs.oneof[i].size[j];k++){
                    if(g_initial_state->vars[oneofs.oneof[i].var[nowindex]]!=oneofs.oneof[i].val[nowindex]){
                        flag = 0;
                    }
                    nowindex++;
                }
                if(flag == 1){
                    appearindex = j;
                    break;
                }
            }
            cout<<"appearindex:"<<appearindex<<endl;
            nowindex=0;
            /*第二步：判断这些出现的item，是否已经出现在反例集的tags中，出现那么修改为未出现的
              -1表示已经出现，！=-1表示未出现*/
            if(tags.oneof[i].size[appearindex]==-1){
                int success = 0;
                /*找到未出现过的，进行替换*/
                for(int j=0;j<oneofs.oneof[i].len;j++){
                    if(tags.oneof[i].size[j]==-1){
                        nowindex+=oneofs.oneof[i].size[j];
                    }else{
                        success=1;
                        for(int k=0;k<oneofs.oneof[i].size[j];k++){
                            g_initial_state->vars[oneofs.oneof[i].var[nowindex]] = oneofs.oneof[i].val[nowindex];
                            
                            nowindex++;
                        }
                        tags.oneof[i].size[j]=-1;
                        break;
                    }
                }
                /*要把原来的删除了*/
                if(success==1){
                    nowindex=0;
                    for(int j=0;j<oneofs.oneof[i].len;j++){
                        if(j!=appearindex)
                            nowindex+=oneofs.oneof[i].size[j];
                        else{
                            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                                g_initial_state->vars[oneofs.oneof[i].var[nowindex]] = g_variable_domain[oneofs.oneof[i].var[nowindex]]-1;
                                nowindex++;
                            }
                            break;
                        }
                    }
                }
            }else{
                tags.oneof[i].size[appearindex]=-1;
            }
        }
    }
    string statestring = stateToString(g_initial_state);
    if(appearcounter.find(statestring)==appearcounter.end()){
        state_var tmp;
        tmp.frequency=1;
        tmp.vars = g_initial_state->vars;
        appearcounter.insert(pair<string,state_var>(statestring,tmp));
        /*不出现多次才能保存*/
        counterset_new.push_back(tmp);
    }else{
        appearcounter[statestring].frequency++;
        cout<<"已经出现过"<<endl;
        /*如果出现过，那么再重新计算反例*/
    }
    /*test*/
    int k=1;
    // for( std::map<string,state_var>::iterator t=appearcounter.begin();t!=appearcounter.end();t++){
    //     cout<<"状态"<<k<<"出现在反例集中的次数："<<t->second.frequency<<endl;
    //     k++;
    // }
}

void Counter::selectMinState(){
    if(oneofs.type!=2)
        return;
    vector<int> var_tmp = g_original_values;
    State* current_state = new State;
    State* next_state= new State;
    vector<pair<int,int>> nextgoal;
    vector<pair<int,int>> oneofitem;
    current_state->vars = g_initial_state->vars;
    int var_len = g_initial_state->vars.size();
    int *isunKnownFact = (int*)calloc(var_len,sizeof(int));
    
    memset(isunKnownFact,0,var_len);
    // int oneofi[25][100][100]={0};

    /*只识别oneof中的*/
    // for(int i=0;i<oneofs.lens;i++){
    //     int nowindex=0;
    //     int index = oneofs.orlens+i;
    //     /*识别or中的*/
    //     for(int j=0;j<oneofs.oneof[index].len;j++){
    //         for(int k=0;k<oneofs.oneof[index].size[j];k++){
    //             isunKnownFact[oneofs.oneof[index].var[nowindex]]=1;
    //             g_initial_state->negate_var(oneofs.oneof[index].var[nowindex]);
    //             nowindex++;
    //         }
    //     }
    // }
    // for(int i=0;i<var_len;i++){
    //     if(isunKnownFact[i]){
    //         var_tmp[i] = g_variable_domain[i]-1;
    //         g_original_values[i] = g_variable_domain[i]-1;
    //     }
    // }
    // g_goal.clear();
    for(int i=0;i<oneofs.lens;i++){

        int index = oneofs.orlens+i;        
        int nowindex = 0;
        int i_want;
        if(i==0)
            // i_want = 20;
            i_want=oneofs.oneof[i].len-1;
        else
            // i_want = 20;
            i_want=oneofs.oneof[i].len-1;
        
        for(int m=0;m<i_want;m++){
            for(int k=0;k<oneofs.oneof[index].size[m];k++){   
                nowindex++;
            }
        }
        
        for(int k=0;k<oneofs.oneof[index].size[i_want];k++){   
            
            if(oneofs.oneof[index].val[nowindex]<0){
                // g_initial_state->vars[oneofs.oneof[index].var[nowindex]] = g_variable_domain[oneofs.oneof[index].var[nowindex]]-1;
                nextgoal.push_back(pair<int,int>(oneofs.oneof[index].var[nowindex],g_variable_domain[oneofs.oneof[index].var[nowindex]]-1));
            }

            else{
                nextgoal.push_back(pair<int,int>(oneofs.oneof[index].var[nowindex],oneofs.oneof[index].val[nowindex]));
                // g_initial_state->vars[oneofs.oneof[index].var[nowindex]] = oneofs.oneof[index].val[nowindex];
            }
                
            nowindex++;
        }
        
        // for(int k=0;k<oneofs.oneof[index].size[i_want];k++){   
        //     g_goal.push_back(pair<int,int>(oneofs.oneof[index].var[nowindex],oneofs.oneof[index].val[nowindex]));
        //     // g_initial_state->vars[oneofs.oneof[index].var[nowindex]] = oneofs.oneof[index].val[nowindex];
        //     nowindex++;
        // }
    }

    //先判断子目标是否可达
    State* temp;
    temp = g_initial_state;
    vector<pair<int, int> > tmpgoal;
    
    tmpgoal.insert(tmpgoal.end(),g_goal.begin(),g_goal.end());
    g_goal.clear();
    g_goal.insert(g_goal.begin(),nextgoal.begin(),nextgoal.end());

    BestFirstSearchEngine *subengine;
    subengine = new BestFirstSearchEngine;
    /*再启动一次搜索*/
    subengine->add_heuristic(1, 1);
    subengine->search();
    g_goal.clear();
    g_goal.insert(g_goal.begin(),tmpgoal.begin(),tmpgoal.end());
    // printPlan(subengine->get_plan());
    //再判断子目标是否比原来的目标要小
    //  &&nextgoal.size()<g_goal.size()
    if(subengine->found_solution()){
        g_goal =nextgoal;
    }

    delete subengine;
    // state_var tmp;
    // tmp.vars = g_initial_state->vars;
    // tmp.frequency = -1;
    // counterset_new.push_back(tmp);

    /*old 不适用*/
    // for(int i=0;i<oneofs.lens;i++){
    //     int nowindex=0;
    //     int index = oneofs.orlens+i;
    //     /*识别or中的*/
    //     for(int j=0;j<oneofs.oneof[index].len;j++){
    //         nowindex=0;
    //         for(int m=0;m<j;m++){
    //             for(int k=0;k<oneofs.oneof[index].size[m];k++){   
    //                 nowindex++;
    //             }
    //         }
    //         for(int k=0;k<oneofs.oneof[index].size[j];k++){   
    //             var_tmp[oneofs.oneof[index].var[nowindex]] = oneofs.oneof[index].val[nowindex];
    //             nowindex++;
    //         }
    //         current_state->vars = var_tmp;
    //         var_tmp = g_original_values;
    //         for(int m=j;m<oneofs.oneof[index].len;m++){
    //             if(m==j){
    //                 nextgoal.insert(nextgoal.end(),g_goal.begin(),g_goal.end());
    //             }else
    //                 for(int k=0;k<oneofs.oneof[index].size[m];k++){   
    //                     nextgoal.push_back(pair<int,int>(oneofs.oneof[index].var[nowindex],oneofs.oneof[index].val[nowindex]));
    //                     nowindex++;
    //                 }
                
    //             /*在这里计算规划解长度*/
    //             State* temp;
    //             temp = g_initial_state;
    //             g_initial_state = current_state;
    //             vector<pair<int, int> > tmpgoal;
                
    //             tmpgoal.insert(tmpgoal.end(),g_goal.begin(),g_goal.end());
    //             g_goal.clear();
    //             g_goal.insert(g_goal.begin(),nextgoal.begin(),nextgoal.end());

    //             BestFirstSearchEngine *subengine;
    //             subengine = new BestFirstSearchEngine;
    //             /*再启动一次搜索*/
    //             subengine->add_heuristic(1, 1);
    //             subengine->search();

    //             g_initial_state = temp;
    //             g_goal.clear();
    //             g_goal.insert(g_goal.begin(),tmpgoal.begin(),tmpgoal.end());
    //             nextgoal.clear();
    //             oneofi[i][j][m]=subengine->get_plan().size();
    //         }
    //     }
    // }
    
    // for(int i=0;i<oneofs.lens;i++){
    //     int minindex=0;
    //     int sum = 0,min=0;
    //     int index = oneofs.orlens+i;
    //     /*识别距离最短的参考状态*/
    //     for(int j=0;j<oneofs.oneof[index].len;j++){
    //         sum=0;
    //         for(int m=0;m<j;m++){
    //             sum+=oneofi[i][m][j];
    //         }
    //         for(int m=j+1;m<oneofs.oneof[index].len;m++){
    //             sum+=oneofi[i][j][m];
    //         }
    //         if(j==0){
    //             min = sum;
    //             minindex = 0;
    //         }else{
    //             if(sum<min){
    //                 min = sum;
    //                 minindex = j;
    //             }
    //         }
    //         cout<<j<<":sum:"<<sum<<endl;
    //     }
    //     cout<<"minindex:"<<minindex<<endl;
    //     cout<<endl;
    //     /*改变为距离最小的初始状态*/
        
    //     int nowindex = 0;
    //     for(int m=0;m<minindex;m++){
    //         for(int k=0;k<oneofs.oneof[index].size[m];k++){   
    //             nowindex++;
    //         }
    //     }
    //     for(int k=0;k<oneofs.oneof[index].size[minindex];k++){   
    //         g_initial_state->vars[oneofs.oneof[index].var[nowindex]] = oneofs.oneof[index].val[nowindex];
    //         nowindex++;
    //     }
    // }

    g_initial_state->dump();

    // for(int i=0;i<3;i++){
    //     for(int j=0;j<12;j++){
    //         for(int k=0;k<12;k++){
    //             cout<<oneofi[i][j][k]<<" ";
    //         }
    //         cout<<endl;
    //     }
    //     cout<<endl;
    // }



}


void Counter::testPlanisvalid(Plan plan){
    vector<int> var_tmp = g_original_values;
    vector<pair<int,int>> tmp;
    vector<state_var> curStates;
    int plansize = plan.size();
    int var_len = g_initial_state->vars.size();
    /*识别其中每个状态都相同的fact*/
    int *isunKnownFact = (int*)calloc(var_len,sizeof(int));
    memset(isunKnownFact,0,var_len);
    /*先识别or中的*/
    for(int i=0;i<oneofs.orlens;i++){
        int nowindex=0;
        /*识别or中的*/
        for(int j=0;j<oneofs.oneof[i].len;j++){
            for(int k=0;k<oneofs.oneof[i].size[j];k++){
                isunKnownFact[oneofs.oneof[i].var[nowindex]]=1;
                g_initial_state->negate_var(oneofs.oneof[i].var[nowindex]);
                nowindex++;
            }
        }
    }
    /*再识别oneof中的*/
    for(int i=0;i<oneofs.lens;i++){
        int nowindex=0;
        int index = oneofs.orlens+i;
        /*识别or中的*/
        for(int j=0;j<oneofs.oneof[index].len;j++){
            for(int k=0;k<oneofs.oneof[index].size[j];k++){
                isunKnownFact[oneofs.oneof[index].var[nowindex]]=1;
                g_initial_state->negate_var(oneofs.oneof[index].var[nowindex]);
                nowindex++;
            }
        }
    }

    /*识别*/
    for(int i=0;i<var_len;i++){
        if(isunKnownFact[i]){
            var_tmp[i]=g_variable_domain[i]-1;
        }
    }

    ifstream infile;
    infile.open("belief", ios::in);
    string line;
    while(getline(infile, line)){
        // cout<<line<<endl;
        if(line == "END_BELIEF"){
            state_var newvar;
            newvar.vars = var_tmp;
            newvar.frequency=0;
            curStates.push_back(newvar);
            for(int i=0;i<tmp.size();i++){
                var_tmp[tmp[i].first] = g_variable_domain[tmp[i].first]-1;
            }
            tmp.clear();
        }else{
            int var,val;
            var = -1;		
            for(int i = 0 ; i < g_variable_name.size() ; i++)
            {
                /*读取的name后面有一个空格，长度会+1*/
                if(line.find(g_variable_name[i]) == 0 && line.size() == g_variable_name[i].size()+1)
                {
                    var = i;
                    // cout << g_variable_name[i]<<" ";
                }
            }
            getline(infile, line);
            stringstream ss(line);
            ss >> val;
            // cout<<var<<" "<<val<<endl;
            var_tmp[var]=val;
            tmp.push_back(pair<int,int>(var,val));
        }
    }
    infile.close();
    cout<<curStates.size()<<endl;
    // cout<<endl;
    // for(int i=0;i<curStates.size();i++){
    //     cout<<"第"<<i<<"个状态"<<endl;
    //     for(int j=0;j<curStates[i].vars.size();j++){
    //         if(isunKnownFact[j]&&curStates[i].vars[j]!=g_variable_domain[j]-1)
    //             cout<<g_variable_name[j]<<"-"<<curStates[i].vars[j]<<" ";
    //     }
    //     cout<<g_variable_name[g_goal[0].first]<<"-"<<curStates[i].vars[g_goal[0].first];
    //     cout<<endl;
    // }

    for(int i=0;i<plansize;i++){
         /*所有的状态后移*/
        // cout<<plan[i]->get_name()<<":"<<endl;
        for(int j=0;j<curStates.size();j++){
            int h;
            for(h=0;h<g_operators.size();h++)
            {
                if(g_operators[h].get_name().compare(plan[i]->get_name()) == 0) break;
            }
            State *tmp = new State();
            tmp->vars = curStates[j].vars;
            if(!g_operators[h].is_conformant_applicable(*tmp)){
                cout<<g_operators[h].get_name()<<"动作不满"<<endl;
                return;
            }

            applyAction(&curStates[j],g_operators[h]);
        }
    }

    cout<<endl;
    /*使用标准公理求值器，避免手工单遍求值遗漏层次和默认值复位。*/
    for(int k=0;k<curStates.size();k++){
        if(g_axiom_evaluator != 0) {
            State evaluated;
            evaluated.vars = curStates[k].vars;
            g_axiom_evaluator->evaluate(evaluated);
            curStates[k].vars = evaluated.vars;
        }
    }
    
    // cout<<endl;
    // cout<<"后"<<endl;
    // for(int i=0;i<curStates.size();i++){
    //     cout<<"第"<<i<<"个状态"<<endl;
    //     for(int j=0;j<curStates[i].vars.size();j++){
    //         if(isunKnownFact[j]&&curStates[i].vars[j]!=g_variable_domain[j]-1)
    //             cout<<g_variable_name[j]<<"-"<<curStates[i].vars[j]<<" ";
    //     }
    //     cout<<endl;
    // }
    /*遍历curstate_验证是否为有效解*/
    int isvalidplan=true;
    for(int i=0;i<curStates.size();i++){
        for(int j=0;j<g_goal.size();j++){
            /*test*/
            // cout<<"当前对比:"<<curStates[i].vars[g_goal[j].first]<<"与"<<g_goal[j].second<<endl;
            if(curStates[i].vars[g_goal[j].first]!=g_goal[j].second){
                isvalidplan=false;
                cout<<"状态"<<i<<"不能解决"<<endl;
                for(int k=0;k<curStates[i].vars.size();k++){
                    cout<<g_variable_name[k]<<"-"<<curStates[i].vars[k]<<" ";
                }
                for(int k=0;k<curStates[i].vars.size();k++){
                    cout<<g_variable_name[k]<<"-"<<curStates[i].vars[k]<<" ";
                }
                cout<<endl;
                break;
            }
                
        }

    }
    if(isvalidplan){
        cout<<"规划解能解反例集！"<<endl;
        counterissolvered=true;
    }else{
        cout<<"规划解还不能解反例集！"<<endl;
        counterissolvered=false;
    }

}