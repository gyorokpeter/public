d19p1:{pr:(1+til x)!x#1;
    while[1<count pr;
        odd:1=count[pr] mod 2;
        pr:(2 cut key pr)[;0]!sum each 2 cut value pr;
        if[(1<count pr)and odd;
            pr[last key pr]+:first value pr;
             pr _: first key pr;
        ];
    ];
    first key pr};
d19p2:{pr:1+til x;
    nxt:0;
    while[1<c:count pr;
        nxtc:(c+2) div 3;
        nxts:(nxt+til nxtc)mod c;
        tgts:(nxt+(c div 2)+til[nxtc]+(til[nxtc]+c mod 2)div 2)mod c;
        pr:pr except pr tgts;
        nxt-:count where tgts<nxt;
        nxt:(nxt+nxtc)mod count pr;
    ];
    first pr};

d19p1 5
d19p1 6
d19p1 3012210
d19p2 5
d19p2 6
d19p2 3012210

