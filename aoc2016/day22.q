d22p1:{nt:update `$name,"J"$-1_/:size,"J"$-1_/:used,"J"$-1_/:avail from flip`name`size`used`avail`usepct!flip(" "vs/:2_"\n"vs x)except\:enlist"";
    pair:select from (select nameA:name,used from nt where used>0)cross (select nameB:name,avail from nt) where nameA<>nameB,used<=avail;
    count pair};

expand2:{[wall;w;h;st]
    rc:{[wall;p;b;nb]$[wall . nb;();[p1:$[p~nb;b;p];enlist`pos`blank!(p1;nb)]]};
    res:([]pos:();blank:());
    b:st`blank;
    p:st`pos;
    if[b[0]>0; nb:b+(-1 0); res,:rc[wall;p;b;nb]];
    if[b[0]<w-1; nb:b+(1 0); res,:rc[wall;p;b;nb]];
    if[b[1]>0; nb:b+(0 -1); res,:rc[wall;p;b;nb]];
    if[b[1]<h-1; nb:b+(0 1); res,:rc[wall;p;b;nb]];
    res};

d22p2:{
    nt:update `$name,"J"$-1_/:size,"J"$-1_/:used,"J"$-1_/:avail from flip`name`size`used`avail`usepct!flip(" "vs/:2_"\n"vs x)except\:enlist"";
    gr:(1+"J"$1_last"-"vs string exec last name from nt)cut exec (used,'avail) from nt;
    cstate:([]pos:enlist (count[gr]-1;0);blank:raze til[count gr],/:'where each gr[;;0]=0);
    wall:gr[;;0]>=490;
    vstate:();
    goal:0 0;
    found:0b;
    iter:0;
    while[not found;
        iter+:1;
        vstate,:cstate;
        newstates:raze expand2[wall;count gr;count gr 0] each cstate;
        newstates:distinct newstates except vstate;
        found:goal in newstates[`pos];
        cstate:newstates;
        -1"vstate: ",string[count vstate]," new: ",string count[newstates];
    ];
    iter}
