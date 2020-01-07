/
x:read0`:d:/projects/github/public/aoc2018/d19.in;

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

d19common:{[reg;x]
    ipr:"J"$last" "vs x first where x like "#*";
    ins:"SJJJ"$/:" "vs/:x where not x like "#*";
    while[reg[ipr] within (0;count[ins]-1);
        ni:ins reg ipr;
        reg:d16ins[ni 0][ni;reg];
        reg[ipr]+:1;
        if[1=reg ipr; :{sum x where 0=last[x] mod x}1+til max reg]; //cheat
    ];
    reg 0};

d19p1:{d19common[6#0;x]};
d19p2:{d19common[1,5#0;x]};

d19p1 x
d19p2 x
\

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `chronal in key`;
        system"l ",path,"/chronal.q";
    ];
    }[];

d19:{[a;x]
    st:.chronal.runD[.chronal.editRegister[.chronal.new[x];0;a];1b;enlist 1;0b];
    {sum x where 0=last[x] mod x}1+til max .chronal.getRegisters[st]};

d19p1:{d19[0;x]};
d19p2:{d19[1;x]};

/d19p1"#ip 2\naddi 2 16 2\nseti 1 0 4\nseti 1 5 5\nmulr 4 5 1\neqrr 1 3 1\naddr 1 2 2\naddi 2 1 2\naddr 4 0 0\naddi 5 1 5\ngtrr 5 3 1\naddr 2 1 2\nseti 2 6 2\naddi 4 1 4\ngtrr 4 3 1\naddr 1 2 2\nseti 1 7 2\nmulr 2 2 2\naddi 3 2 3\nmulr 3 3 3\nmulr 2 3 3\nmuli 3 11 3\naddi 1 6 1\nmulr 1 2 1\naddi 1 6 1\naddr 3 1 3\naddr 2 0 2\nseti 0 3 2\nsetr 2 3 1\nmulr 1 2 1\naddr 2 1 1\nmulr 2 1 1\nmuli 1 14 1\nmulr 1 2 1\naddr 3 1 3\nseti 0 9 0\nseti 0 5 2"
/d19p2"#ip 2\naddi 2 16 2\nseti 1 0 4\nseti 1 5 5\nmulr 4 5 1\neqrr 1 3 1\naddr 1 2 2\naddi 2 1 2\naddr 4 0 0\naddi 5 1 5\ngtrr 5 3 1\naddr 2 1 2\nseti 2 6 2\naddi 4 1 4\ngtrr 4 3 1\naddr 1 2 2\nseti 1 7 2\nmulr 2 2 2\naddi 3 2 3\nmulr 3 3 3\nmulr 2 3 3\nmuli 3 11 3\naddi 1 6 1\nmulr 1 2 1\naddi 1 6 1\naddr 3 1 3\naddr 2 0 2\nseti 0 3 2\nsetr 2 3 1\nmulr 1 2 1\naddr 2 1 1\nmulr 2 1 1\nmuli 1 14 1\nmulr 1 2 1\naddr 3 1 3\nseti 0 9 0\nseti 0 5 2"

/
OVERVIEW:
This requires a cheat during the VM simulation. The given program sets up a value
in a register and then finds the sum of its divisors using an inefficient algorithm.
We can use the more efficient vector operations to speed up the process, which is
very important to finish part 2 quickly.
I simply assumed that whatever the biggest number in the registers is after reaching
the instrucion at ip=1 is the number whose divisors we are summing, which worked out
well.
After migration to genarch, the cheat can no longer be inside the VM logic,
however we can simply use the debugger API to set a breakpoint on line 1 and extract
the registers to pick up from there.

