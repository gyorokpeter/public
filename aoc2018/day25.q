x:read0`:d:/projects/github/public/aoc2018/d25.in;

d25p1:{
    pos:"J"$","vs/:x;
    cons:count[pos]#0;
    conssq:0;
    while[0<count unknown:where 0=cons;
        nxt:first unknown;
        conssq+:1;
        queue:enlist nxt;
        while[0<count queue;
            cons[queue]:conssq;
            unknown:where 0=cons;
            dists:min each sum each/:abs pos[queue]-\:/:pos unknown;
            nxts:unknown where dists<=3;
            queue:nxts;
        ];
    ];
    conssq};

d25p1 x
