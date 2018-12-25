x:read0`:d:/projects/github/public/aoc2018/d18.in;

d18step:{[map]
    treeAdj:(1_3 msum (1_/:3 msum/:(map,\:".")="|"),enlist count[first map]#0)-map="|";
    yardAdj:(1_3 msum (1_/:3 msum/:(map,\:".")="#"),enlist count[first map]#0)-map="#";
    map:?'[(map=".");
        ?'[treeAdj>=3;"|";map];
        ?'[(map="|");?'[yardAdj>=3;"#";map];
            ?'[(treeAdj>=1) and (yardAdj>=1);"#";"."]]];
    map};

d18p1:{
    map:x;
    map:d18step/[10;map];
    prd sum each sum each map=/:"|#"};
d18p2:{ 
    map:x;
    res:{map:d18step last x;$[any x[1] like raze map;(0b;x[1];map);(1b;x[1],enlist raze map;map)]}/[first;(1b;enlist raze map;map)];
    repeat:first where res[1] like raze res[2];
    period:count[res 1]-repeat;
    finalState:repeat+(1000000000-count[res 1])mod period;
    finalMap:res[1][finalState];
    prd sum each finalMap=/:"|#"};

d18p1 x
d18p2 x
