d13p1:{v:"J"$trim each/:":"vs/:"\n"vs x;sum prd each v where 0=v[;0]mod 1|2*v[;1]-1}

d13p1"0: 3
    1: 2
    4: 4
    6: 4"   //24

gcd:{$[x<0;.z.s[neg x;y];x=y;x;x>y;.z.s[y;x];x=0;y;.z.s[x;y mod x]]};
lcm:{(x*y)div gcd[x;y]};

d13p2:{
    v:"J"$trim each/:":"vs/:"\n"vs x;
    t:`p xasc ([]d:v[;0];p:1|2*v[;1]-1);
    t2:0!select d:(p-d)mod p by p from t;
    min last {al:x[1];m:x 0;nm:y`p;nbad:y`d;mul:lcm[m;nm];(mul;(raze al+/:m*til mul div m) except raze nbad+/:nm*til mul div nm)}/[(1;enlist 0);t2]};

d13p2"0: 3
    1: 2
    4: 4
    6: 4"   //10
