#include <iostream>
#include <map>
#include <vector>
#include <string>
#include <sstream>
#include <cstring>
#include <limits>

using namespace std;

typedef pair<string,string> pss;
struct ruleitem {
    int cost;
    int leftSide;
    int rightSideFirst;
    int rightSideSecond;
};
typedef pair<int, int> pii;

map <string,int> sym;
vector <string> syms;
int termnum = 0;

string to_string(int num) {
    ostringstream ss;
    ss << num;
    return ss.str();
}

int intern(string s) {
    if(sym.count(s)) return sym[s];
    else {
        int result = termnum;
        sym[s] = termnum;
        syms.push_back(s);
        ++termnum;
        return result;
    }
}

vector<int> strToTerm(string s) {
    vector<int> result;
    string termname="";
    for (char c: s) {
        if (c>='A' && c<='Z') {
            if(termname.size() > 0) {
                result.push_back(intern(termname));
            }
            termname = "";
        }
        termname += c;
    }
    if(termname.size() > 0) {
        result.push_back(intern(termname));
    }
    return result;
}

int main() {
    string s;
    vector<pss> rule;
    string prevs="", pprevs = "";
    while (cin >> s) {
        if (prevs == "=>") {
            rule.push_back({pprevs,s});
        }
        pprevs = prevs;
        prevs = s;
    }
    string orig = s;
    
    vector<int> orign = strToTerm(orig);
    int termcount = termnum;

    vector<ruleitem> rule2;
    for (auto r: rule) {
        ruleitem ri;
        ri.cost = 1;
        ri.leftSide = strToTerm(r.first)[0];
        vector<int> right = strToTerm(r.second);
        string tempRuleName = r.first + r.second;
        int tempRuleNr = 1;
        for (int i=0; i<right.size()-2; ++i) {
            int tempRuleId = intern(tempRuleName+to_string(tempRuleNr));
            ++tempRuleNr;
            ri.rightSideFirst = right[i];
            ri.rightSideSecond = tempRuleId;
            rule2.push_back(ri);
            ri = ruleitem();
            ri.leftSide = tempRuleId;
            ri.cost = 0;
        }
        ri.rightSideFirst = right[right.size()-2];
        ri.rightSideSecond = right[right.size()-1];
        rule2.push_back(ri);
    }
    
    int n = orign.size();
    int ntcount = syms.size();
    int dim1 = ntcount;
    int dim2 = (n)*dim1;
    int dim3 = (n+1)*dim2;
    vector<int> P(dim3,-1);
    for (int i=0; i<n; ++i) {
        P[1*dim2+i*dim1+orign[i]] = 0;
    }
    for (int i = 2; i<=n; ++i)
    //for (int i=2;i<=3;++i)
        for (int j=0; j<=n-i; ++j)
            for (int k = 1; k<=i-1; ++k)
                for (int r=0; r<rule2.size(); ++r) {
                    const ruleitem &rl = rule2[r];
                    int vOld = P[k*dim2+j*dim1+rl.rightSideFirst];
                    int vNew = P[(i-k)*dim2+(j+k)*dim1+rl.rightSideSecond];
                    if (vOld > -1 && vNew > -1) {
                        int dOld = P[i*dim2+j*dim1+rl.leftSide];
                        if (dOld == -1) dOld = numeric_limits<int>::max();
                        int dNew = min(dOld, vOld+vNew+rl.cost);
                        //cout << syms[rl.leftSide] << " => " << syms[rl.rightSideFirst] << " " << syms[rl.rightSideSecond] << endl;
                        //cout << "P[" << k << "," << j << "," << syms[rl.rightSideFirst] << "] = " << vOld << endl;
                        //cout << "P[" << (i-k) << "," << (j+k) << "," << syms[rl.rightSideSecond] << "] = " << vNew << endl;
                        //cout << "P[" << i << "," << j << "," << syms[rl.leftSide] << "] <- " << dNew << endl;
                        P[i*dim2+j*dim1+rl.leftSide] = dNew;
                    }
                }
    
    for (int i=0; i<dim1; ++i) {
        if (syms[i] == "e")
            cout << P[n*dim2+0*dim1+i] << endl;
    }
    return 0;
}