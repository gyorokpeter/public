/
d12:{[ins;reg]
    ip:0;
    while[ip<count ins;
        ni:ins[ip];
        ip+:1;
        $[ni[0]~"cpy";[v:"J"$ni[1];if[null v;v:reg[`$ni 1]];reg[`$ni 2]:v];
          ni[0]~"inc";[r:`$ni[1];reg[r]+:1];
          ni[0]~"dec";[r:`$ni[1];reg[r]-:1];
          ni[0]~"jnz";[v:"J"$ni[1];if[null v;v:reg[`$ni 1]];if[v>0;ip+:("J"$ni 2)-1]];
        'ni[0]," unknown"];
    ];
    reg};
d12p1:{
    ins:" "vs/:"\n"vs x;
    reg:d12[ins;`a`b`c`d!4#0];
    reg`a};
d12p2:{
    ins:" "vs/:"\n"vs x;
    reg:d12[ins;`a`b`c`d!0 0 1 0];
    reg`a};
\

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `assembunny in key`;
        system"l ",path,"/assembunny.q";
    ];
    }[];


d12p1:{
    st:.assembunny.new x;
    st:.assembunny.run st;
    .assembunny.getRegisters[st]`a};
d12p2:{
    st:.assembunny.new x;
    st:.assembunny.editRegister[st;`c;1];
    st:.assembunny.run st;
    .assembunny.getRegisters[st]`a};


//d12p1"cpy 1 a\ncpy 1 b\ncpy 26 d\njnz c 2\njnz 1 5\ncpy 7 c\ninc d\ndec c\njnz c -2\ncpy a c\ninc a\ndec b\njnz b -2\ncpy c b\ndec d\njnz d -6\ncpy 18 c\ncpy 11 d\ninc a\ndec d\njnz d -2\ndec c\njnz c -5"
//d12p2"cpy 1 a\ncpy 1 b\ncpy 26 d\njnz c 2\njnz 1 5\ncpy 7 c\ninc d\ndec c\njnz c -2\ncpy a c\ninc a\ndec b\njnz b -2\ncpy c b\ndec d\njnz d -6\ncpy 18 c\ncpy 11 d\ninc a\ndec d\njnz d -2\ndec c\njnz c -5"

/d12p1 "cpy 41 a\ninc a\ninc a\ndec a\njnz a 2\ndec a"
/d12p2 "cpy 41 a\ninc a\ninc a\ndec a\njnz a 2\ndec a"

/
OVERVIEW:

This is a straight-up VM implementation.
The genarch-compatible VM from day 25 that includes all optimizations results
in much faster execution than the naive initial implementation.
