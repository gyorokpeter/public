x:read0`:d:/projects/github/public/aoc2018/d21.in;

//WTF these are still not built in in 2018?!
.q.bitand:{0b sv (0b vs x)and 0b vs y};
.q.bitor:{0b sv (0b vs x)or 0b vs y};

d16ins:()!();
d16ins[`addr]:{[op;reg]reg[op 3]:reg[op 1]+reg[op 2];reg};
d16ins[`addi]:{[op;reg]reg[op 3]:reg[op 1]+op 2;reg};
d16ins[`mulr]:{[op;reg]reg[op 3]:reg[op 1]*reg[op 2];reg};
d16ins[`muli]:{[op;reg]reg[op 3]:reg[op 1]*op 2;reg};
d16ins[`banr]:{[op;reg]reg[op 3]:reg[op 1] bitand reg[op 2];reg};
d16ins[`bani]:{[op;reg]reg[op 3]:reg[op 1] bitand op 2;reg};
d16ins[`borr]:{[op;reg]reg[op 3]:reg[op 1] bitor reg[op 2];reg};
d16ins[`bori]:{[op;reg]reg[op 3]:reg[op 1] bitor op 2;reg};
d16ins[`setr]:{[op;reg]reg[op 3]:reg[op 1];reg};
d16ins[`seti]:{[op;reg]reg[op 3]:op 1;reg};
d16ins[`gtir]:{[op;reg]reg[op 3]:`long$op[1]>reg[op 2];reg};
d16ins[`gtri]:{[op;reg]reg[op 3]:`long$reg[op 1]>op 2;reg};
d16ins[`gtrr]:{[op;reg]reg[op 3]:`long$reg[op 1]>reg[op 2];reg};
d16ins[`eqir]:{[op;reg]reg[op 3]:`long$op[1]=reg[op 2];reg};
d16ins[`eqri]:{[op;reg]reg[op 3]:`long$reg[op 1]=op 2;reg};
d16ins[`eqrr]:{[op;reg]reg[op 3]:`long$reg[op 1]=reg[op 2];reg};

d21p1:{
    reg:6#0;
    ipr:"J"$last" "vs x first where x like "#*";
    ins:"SJJJ"$/:" "vs/:x where not x like "#*";
    while[reg[ipr] within (0;count[ins]-1);
        ni:ins reg ipr;
        reg:d16ins[ni 0][ni;reg];
        reg[ipr]+:1;
        if[reg[ipr]=28;
            :reg first(1_3#ins reg[ipr])except 0;   //cheat
        ];
    ];
    };

d21p2:{
    ipr:"J"$last" "vs x first where x like "#*";
    ins:"SJJJ"$/:" "vs/:x where not x like "#*";
    c:ins[7;1];
    a:65536;
    seen:();
    while[1b;
        b:c;
        cont:1b;
        while[cont;
            b:(((b+(a mod 256))mod 16777216)*65899)mod 16777216;
            cont:a>=256;
            a:a div 256;
        ];
        a:b bitor 65536;
        if[b in seen; :last seen];
        seen,:b;
    ];
    };

d21p1 x
d21p2 x
