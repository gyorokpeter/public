{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `turinglock in key`;
        system"l ",path,"/turinglock.q";
    ];
    }[];

d23p1:{
    a:.turinglock.new[x];
    a:.turinglock.run[a];
    .turinglock.getRegisters[a]`b};

d23p2:{
    a:.turinglock.editRegister[.turinglock.new[x];`a;1];
    a:.turinglock.run[a];
    .turinglock.getRegisters[a]`b};

//d23p1"jio a, +18\ninc a\ntpl a\ninc a\ntpl a\ntpl a\ntpl a\ninc a\ntpl a\ninc a\ntpl a\ninc a\ninc a\ntpl a\ntpl a\ntpl a\ninc a\njmp +22\ntpl a\ninc a\ntpl a\ninc a\ninc a\ntpl a\ninc a\ntpl a\ninc a\ninc a\ntpl a\ntpl a\ninc a\ninc a\ntpl a\ninc a\ninc a\ntpl a\ninc a\ninc a\ntpl a\njio a, +8\ninc b\njie a, +4\ntpl a\ninc a\njmp +2\nhlf a\njmp -7"

/
OVERVIEW:

The main program is not interesting at all. The interpreter in turinglock.q does the
heavy lifting, this solution simply uses the GenArch API.

The program given as input first puts a number into register a using a sequence of tpl's
and inc's (a different number depending on the initial value on a), and then computes the
elements of the Collatz sequence, accumulating the length of the sequence in b.
This explains the odd choice of instructions: tpl, inc and half are the only arithmetic
operations needed to compute the elements, jio is used as the terminating condition
and initially to distinguish between parts 1 and 2, and jie is used to decide between the
two branches of the Collatz function. The unconditional jmp instruction is probably only to
enable the simple construction of loops without the use of workaround instructions.