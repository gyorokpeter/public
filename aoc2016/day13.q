d13p1:{[dx;dy;off]
    state:`state`steps!(1 1; 0);
    targetstate:dx,dy;
    found:0b;
    cstate:enlist state;
    vstate:cstate;
    while[not found;
        newstate:raze{[off;st]
            nc:st[`state]+/:(-1 0;0 -1;1 0;0 1);
            nc:nc where all each nc>=0;
            xc:nc[;0];yc:nc[;1];
            nc:nc where 0=(sum each 0b vs/:(xc*xc)+(3*xc)+(2*xc*yc)+yc+(yc*yc)+off)mod 2;
            :([]state:nc; steps:st[`steps]+1)
        }[off]each cstate;
        found:targetstate in exec state from newstate;
        cstate:select from distinct newstate where not state in exec state from vstate;
        vstate,:cstate;
    ];
    cstate[cstate[`state]?targetstate;`steps]}

d13p2:{[dx;dy;off]
    state:`state`steps!(1 1; 0);
    cstate:enlist state;
    vstate:cstate;
    while[50>exec max steps from vstate;
        newstate:raze{[off;st]
            nc:st[`state]+/:(-1 0;0 -1;1 0;0 1);
            nc:nc where all each nc>=0;
            xc:nc[;0];yc:nc[;1];
            nc:nc where 0=(sum each 0b vs/:(xc*xc)+(3*xc)+(2*xc*yc)+yc+(yc*yc)+off)mod 2;
            :([]state:nc; steps:st[`steps]+1)
        }[off]each cstate;
        cstate:select from distinct newstate where not state in exec state from vstate;
        vstate,:cstate;
    ];
    count vstate}


d13p1[7;4;10]
d13p1[31;39;1364]
d13p2[31;39;1364]