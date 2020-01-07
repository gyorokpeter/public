/
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
\

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `chronal in key`;
        system"l ",path,"/chronal.q";
    ];
    }[];

d21p1:{st:.chronal.runD[.chronal.new x;1b;28;0b];
    .chronal.getRegisters[st]st[2;28;1]};

d21p2:{
    xs:trim each "\n"vs x;
    ipr:"J"$last" "vs xs first where xs like "#*";
    ins:"SJJJ"$/:" "vs/:xs where not xs like "#*";
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
        a:.chronal.bitor[b;65536];
        if[b in seen; :last seen];
        seen,:b;
    ];
    };

//d21p2"#ip 4\nseti 123 0 2\nbani 2 456 2\neqri 2 72 2\naddr 2 4 4\nseti 0 0 4\nseti 0 8 2\nbori 2 65536 5\nseti 2238642 0 2\nbani 5 255 3\naddr 2 3 2\nbani 2 16777215 2\nmuli 2 65899 2\nbani 2 16777215 2\ngtir 256 5 3\naddr 3 4 4\naddi 4 1 4\nseti 27 3 4\nseti 0 8 3\naddi 3 1 1\nmuli 1 256 1\ngtrr 1 5 1\naddr 1 4 4\naddi 4 1 4\nseti 25 4 4\naddi 3 1 3\nseti 17 2 4\nsetr 3 9 5\nseti 7 9 4\neqrr 2 0 3\naddr 3 4 4\nseti 5 0 4"
//d21p2"#ip 2\nseti 123 0 3\nbani 3 456 3\neqri 3 72 3\naddr 3 2 2\nseti 0 0 2\nseti 0 6 3\nbori 3 65536 4\nseti 2176960 8 3\nbani 4 255 1\naddr 3 1 3\nbani 3 16777215 3\nmuli 3 65899 3\nbani 3 16777215 3\ngtir 256 4 1\naddr 1 2 2\naddi 2 1 2\nseti 27 7 2\nseti 0 9 1\naddi 1 1 5\nmuli 5 256 5\ngtrr 5 4 5\naddr 5 2 2\naddi 2 1 2\nseti 25 7 2\naddi 1 1 1\nseti 17 2 2\nsetr 1 7 4\nseti 7 9 2\neqrr 3 0 1\naddr 1 2 2\nseti 5 9 2"

/
OVERVIEW:
For part 1, it is enough to see that on instruction 28, the value of register 0 is
checked against another register. If they match, the program exits. So putting the
correct number in register 0 results in the fastest exit. We can simulate the VM
until instruction 28 and find out what number is being compared to.
Part 2 requires a whiteboxed solution. It turns out that the number check is done
with numbers in sequence which eventually loops around. To run for the longest time,
we have to put in the number that is the last before the repetition. Due to the
inefficient method used in the code, it is better to reimplement the formula that
matches the logic of the program.

Like day 19, genarch requires the usage of a breakpoint to stop the program on line
28. Part 2 is unaffected as it's a whitebox solution.
