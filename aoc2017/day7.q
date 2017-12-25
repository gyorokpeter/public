d7p1:{d:raze{$[x like "*->*";[t:`$trim each ","vs last "->"vs x;t!count[t]#`$first[" "vs trim x]];()]}each"\n"vs x;first value[d]except key[d]};

d7p1"pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)"  //`tknk


d7p2:{
    d:raze{$[x like "*->*";[t:`$trim each ","vs last "->"vs x;t!count[t]#`$first[" "vs trim x]];()]}each"\n"vs x;
    w:raze{x:trim x;p:" "vs x;enlist[`$p[0]]!enlist "J"$1_-1_p[1]}each"\n"vs x;
    .d7.tw:()!();
    root:first value[d]except key[d];
    {[d;w;x]c:where d=x;.z.s[d;w]each c;.d7.tw[x]:w[x]+sum 0,.d7.tw[c]}[d;w]root;
    .d7.bal:()!();
    {[d;w;x]c:where d=x;:.d7.bal[x]:$[0=count c;1b;(1=count distinct .d7.tw[c]) and all .z.s[d;w]each c]}[d;w][root];
    {[d;w;x]c:where d=x;$[1=count nx:where not .d7.bal c;:.z.s[d;w;c nx 0];[ew:{first where x=max x}count each group ws:.d7.tw c;di:first where ws<>ew;w[c di]+ew-ws di]]}[d;w][root]
    };

d7p2"pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)"  //60
