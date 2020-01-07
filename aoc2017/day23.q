/
d23p1:{
    reg:(`char$(`int$"a")+til 8)!8#0;
    ip:0;
    ins:trim each"\n"vs x;
    val:{[reg;expr]$[expr like "[a-z]";reg[first expr];"J"$expr]};
    mulcnt:0;
    while[ip<count ins;
        ni:ins[ip];
        op:`$3#ni;
        param:" "vs 4_ni;
        ip+:1;
        $[
          op=`set; reg["C"$param 0]:val[reg;param 1];
          op=`sub; reg["C"$param 0]-:val[reg;param 1];
          op=`mul; [reg["C"$param 0]*:val[reg;param 1];mulcnt+:1];
          op=`jnz; if[reg["C"$param 0]<>0; ip+:val[reg;param 1]-1];
        '"invalid instruction"];
    ];
    mulcnt};

d23p1 "set b 79
    set c b
    jnz a 2
    jnz 1 5
    mul b 100
    sub b -100000
    set c b
    sub c -17000
    set f 1
    set d 2
    set e 2
    set g d
    mul g e
    sub g b
    jnz g 2
    set f 0
    sub e -1
    set g e
    sub g b
    jnz g -8
    sub d -1
    set g d
    sub g b
    jnz g -13
    jnz f 2
    sub h -1
    set g b
    sub g c
    jnz g 2
    jnz 1 3
    sub b -17
    jnz 1 -23"  //5929
\

d23p2:{
    startval:100000+100*"J"$last" "vs first"\n"vs x;
    nums:startval+til[1001]*17;
    cnt:count nums;
    d:2;
    while[d<startval;
        nums:nums where 0<>nums mod d;
        d+:1;
    ];
    cnt-count nums};

d23p2 "set b 79
    set c b
    jnz a 2
    jnz 1 5
    mul b 100
    sub b -100000
    set c b
    sub c -17000
    set f 1
    set d 2
    set e 2
    set g d
    mul g e
    sub g b
    jnz g 2
    set f 0
    sub e -1
    set g e
    sub g b
    jnz g -8
    sub d -1
    set g d
    sub g b
    jnz g -13
    jnz f 2
    sub h -1
    set g b
    sub g c
    jnz g 2
    jnz 1 3
    sub b -17
    jnz 1 -23"  //907

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `duet in key`;
        system"l ",path,"/arch1.q";
    ];
    }[];

d23p1:{.arch1.getMulCount .arch1.run .arch1.new[x]};

//d23p1 "set b 79\nset c b\njnz a 2\njnz 1 5\nmul b 100\nsub b -100000\nset c b\nsub c -17000\nset f 1\nset d 2\nset e 2\nset g d\nmul g e\nsub g b\njnz g 2\nset f 0\nsub e -1\nset g e\nsub g b\njnz g -8\nsub d -1\nset g d\nsub g b\njnz g -13\njnz f 2\nsub h -1\nset g b\nsub g c\njnz g 2\njnz 1 3\nsub b -17\njnz 1 -23"

/
OVERVIEW:

Part 1 is straightforward VM simulation.
In the GenArch version I had to include a special "MUL counter" in the state and a
function to retrieve it just because that's what the challenge asks for.

The VM is not used for part 2. It is meant to be an optimization challenge but it
is just as simple to reverse engineer so I'm making the whitebox solution the
official one.
