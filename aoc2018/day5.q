x:read0`:d:/projects/github/public/aoc2018/d5.in;
d5p1:{
    s:first x;
    pairs:{l:lower x;(x,'l),l,'x}`char$(`int$"A")+til 26;
    while[1b;
        ns:{ssr[x;y;""]}/[s;pairs];
        if[count[s]=count[ns]; :count ns];
        s:ns;
    ];
    };
d5p2:{
    s:first x;
    as:s except/:{x,'lower x}`char$(`int$"A")+til 26;
    rs:d5p1 each enlist each as;
    min rs};

d5p1 x
d5p2 x
