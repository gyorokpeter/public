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
