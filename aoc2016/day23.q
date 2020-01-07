/
.d23.v:{[reg;val]if[null v:"J"$val;v:reg[`$val]];v};
.d23.tgl:{(("cpy";"inc";"dec";"jnz";"tgl")!("jnz";"dec";"inc";"cpy";"inc"))x};

.d23.fetch:{[ins;ip]
    if[ip<count[ins]-6;
        seq:6#ip _ins;
        if[(seq[;0]~("cpy";"inc";"dec";"jnz";"dec";"jnz"))and (seq[2;1]~seq[3;1]) and (seq[0;2]~seq[2;1])
             and (seq[4;1]~seq[5;1])
            and seq[3 5;2]~("-2";"-5");
            :("mul";seq[0;1];seq[4;1];seq[1;1];seq[0;2])];
    ];
    if[ip<count[ins]-3;
        seq:3#ip _ins;
        if[(seq[;0]~("dec";"inc";"jnz"))and (seq[0;1]~seq[2;1]) and seq[2;2]~"-2";
            :("add";seq[0;1];seq[1;1])];
        seq:3#ip _ins;
        if[(seq[;0]~("inc";"dec";"jnz"))and (seq[1;1]~seq[2;1]) and seq[2;2]~"-2";
            :("add";seq[1;1];seq[0;1])];
    ];
    :ins[ip];
    };

.d23.mul:{[ni;reg]ra:`$ni[1];rb:`$ni[2];rt:`$ni[3];rtmp:`$ni[4];reg[rt]+:reg[ra]*reg[rb];reg[rb,rtmp]:0;reg};
.d23.add:{[ni;reg]rs:`$ni[1];rt:`$ni[2];reg[rt]+:reg[rs];reg[rs]:0;reg};

.d23.ops:(enlist[""])!(enlist{'"unknown"});
.d23.ops["cpy"]:{[ni;ip;ins;reg]
    v:.d23.v[reg;ni 1];r:`$ni[2];if[r in key reg;reg[r]:v];
    (ip+1;ins;reg)};
.d23.ops["inc"]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]+:1];
    (ip+1;ins;reg)};
.d23.ops["dec"]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]-:1];
    (ip+1;ins;reg)};
.d23.ops["jnz"]:{[ni;ip;ins;reg]
    v:.d23.v[reg;ni 1];v2:.d23.v[reg;ni 2];if[v>0;ip+:v2-1];
    (ip+1;ins;reg)};
.d23.ops["tgl"]:{[ni;ip;ins;reg]
    v:.d23.v[reg;ni 1];ti:v+ip;if[ti<count ins;ins[ti;0]:.d23.tgl ins[ti;0]];
    (ip+1;ins;reg)};
.d23.ops["mul"]:{[ni;ip;ins;reg]
    reg:.d23.mul[ni;reg];
    (ip+5;ins;reg)};
.d23.ops["add"]:{[ni;ip;ins;reg]
    reg:.d23.add[ni;reg];
    (ip+3;ins;reg)};

d23:{[ins;reg]
    ip:0;
    while[ip<count ins;
        ni:.d23.fetch[ins;ip];
        op:.d23.ops[ni[0]];
        if[null op; 'ni[0]," unknown"];
        res:op[ni;ip;ins;reg];
        ip:res[0];
        ins:res[1];
        reg:res[2];
    ];
    reg};

d23p1:{
    ins:" "vs/:"\n"vs x;
    reg:d23[ins;`a`b`c`d!7 0 0 0];
    reg`a};
d23p2:{
    ins:" "vs/:"\n"vs x;
    reg:d23[ins;`a`b`c`d!12 0 0 0];
    reg`a};

d23p1 "cpy 2 a\ntgl a\ntgl a\ntgl a\ncpy 1 a\ndec a\ndec a"
d23p2 "cpy 2 a\ntgl a\ntgl a\ntgl a\ncpy 1 a\ndec a\ndec a"

\

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `assembunny in key`;
        system"l ",path,"/assembunny.q";
    ];
    }[];

d23:{[n;x]
    st:.assembunny.new x;
    st:.assembunny.editRegister[st;`a;n];
    st:.assembunny.run st;
    .assembunny.getRegisters[st]`a};
d23p1:{d23[7;x]};
d23p2:{d23[12;x]};

//d23p1 "cpy a b\ndec b\ncpy a d\ncpy 0 a\ncpy b c\ninc a\ndec c\njnz c -2\ndec d\njnz d -5\ndec b\ncpy b c\ncpy c d\ndec d\ninc c\njnz d -2\ntgl c\ncpy -16 c\njnz 1 c\ncpy 74 c\njnz 88 d\ninc a\ninc d\njnz d -2\ninc c\njnz c -5"
//d23p2 "cpy a b\ndec b\ncpy a d\ncpy 0 a\ncpy b c\ninc a\ndec c\njnz c -2\ndec d\njnz d -5\ndec b\ncpy b c\ncpy c d\ndec d\ninc c\njnz d -2\ntgl c\ncpy -16 c\njnz 1 c\ncpy 74 c\njnz 88 d\ninc a\ninc d\njnz d -2\ninc c\njnz c -5"

/
OVERVIEW:
Although there is not much change from day 12, the code had to be refactored a lot
to avoid the 'branch error, and optimizations added for some multiplication and
addition sequences.

After the migration to genarch, this becomes very quick as well.
The program calculates n! and adds a constant that is the product of two smaller
constants. The difficulty is that due to the lack of add/mul instructions, it would
take too long to increment all the numbers to their desired values. Thus it is
important to optimize sequences that correspond to add and multiply.

Also interesting is what the toggle does. There is only one tgl instruction in the
program, and that takes a number that goes down by 2 every iteration. In the code 
following the toggle, every second instruction is in its toggled state and the tgl
simply "decodes" it. The starting value for the toggle target will be out of bounds
initially, especially for part 2 where it starts at 20 (2*12-2) but this is no
problem because those are simply ignored. On the last iteration of the loop that
calculates the factorial, the toggle ends up toggling the jnz instruction that
jumps back to the start of the loop, which is originally a "jnz 1, c" so it would
normally always jump, however the toggle turns it into a cpy so it no longer jumps
back. Note that the optimizations need to be aware that the instructions making up
an optimizable sequence may be toggled in or out, as it happens with the "decoding"
process which uncovers a potential "add" optimization. My solution uses a fetch
step that looks ahead to see if the instructions about to be executed form a known
sequence and returns a pseudo-opcode if they do. This might be slower than going
through the code on tgl instructions only, however it's simpler and doesn't have
a too large performance penalty.
