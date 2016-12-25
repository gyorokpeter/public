.d17.expand:{[pass;st]
    nc:st[`state]+/:(0 -1;0 1;-1 0;1 0);
    np:st[`path],/:"UDLR";
    valid1:(all each nc>=0)and all each nc<=3;
    valid2:0x0b<=("X"$/:raze string md5 pass,st`path)@til 4;
    valid:where valid1 & valid2;
    nc:nc valid;
    np:np valid;
    :([]state:nc; path:np)
    };
d17p1:{[pass]
    state:`state`path!(0 0; "");
    targetstate:3 3;
    found:0b;
    cstate:enlist state;
    while[not found;
        newstate:raze .d17.expand[pass]each cstate;
        if[0=count newstate; '"impossible"];
        found:targetstate in exec state from newstate;
        cstate:newstate;
    ];
    cstate[cstate[`state]?targetstate;`path]};
d17p2:{[pass]
    state:`state`path!(0 0; "");
    targetstate:3 3;
    found:0b;
    cstate:enlist state;
    longest:0;
    while[0<count cstate;
        newstate:raze .d17.expand[pass]each cstate;
        if[0<count newstate;
            found:targetstate in exec state from newstate;
            if[found; longest:count exec first path from newstate];
        ];
        cstate:select from distinct newstate where not targetstate~/: exec state from newstate;
    ];
    longest};

d17p1"ihgpwlah"
d17p1"kglvqrro"
d17p1"ulqzkmiv"
d17p1"pslxynzg"

d17p2"ihgpwlah"
d17p2"kglvqrro"
d17p2"ulqzkmiv"
d17p2"pslxynzg"
