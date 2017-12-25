{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    system"l ",path,"/day10.q";
    }[];

d14p1:{
    hs:d10p2 each x,/:"-",/:string til 128;
    sum sum raze each(-4#/:0b vs/:til 16)"X"$/:/:hs};

d14p1"flqrgnkx" //8108

d14p2:{
    hs:d10p2 each x,/:"-",/:string til 128;
    grid:raze each(-4#/:0b vs/:til 16)"X"$/:/:hs;
    first{[st]
        grid:st[1];
        fst:raze til[count grid],/:'where each grid;
        if[0=count fst; :st];
        start:first fst;
        st[0]+:1;
        queue:enlist start;
        while[0<count queue;
            grid:.[;;:;0b]/[grid;queue];
            queue:{[grid;x]x where .[grid]'[x]}[grid;distinct raze queue+/:\:(-1 0;0 -1;1 0;0 1)];
        ];
        st[1]:grid;
        st
    }/[(0;grid)]};

d14p2"flqrgnkx" //1242
