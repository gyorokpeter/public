/
d18p1:{
    reg:(`char$(`int$"a")+til 26)!26#0;
    ip:0;
    ins:trim each"\n"vs x;
    val:{[reg;expr]$[expr like "[a-z]";reg[first expr];"J"$expr]};
    while[1b;
        ni:ins[ip];
        op:`$3#ni;
        param:" "vs 4_ni;
        ip+:1;
        $[op=`snd; snd:val[reg;param 0];
          op=`set; reg["C"$param 0]:val[reg;param 1];
          op=`add; reg["C"$param 0]+:val[reg;param 1];
          op=`mul; reg["C"$param 0]*:val[reg;param 1];
          op=`mod; reg["C"$param 0]:reg["C"$param 0]mod val[reg;param 1];
          op=`rcv; if[reg["C"$param 0]>0; :snd];
          op=`jgz; if[reg["C"$param 0]>0; ip+:val[reg;param 1]-1];
        '"invalid instruction"];
    ];
    };

d18p1"set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2"   //4


.d18.new:{[id]
    res:`reg`ip`inBuf`outBuf`blocked!((`char$(`int$"a")+til 26)!26#0;0;();();0b);
    res[`reg;"p"]:id;
    res};

.d18.val:{[reg;expr]$[expr like "[a-z]";reg[first expr];"J"$expr]};

.d18.step:{[ins;prog]
    ni:ins[prog[`ip]];
    op:`$3#ni;
    param:" "vs 4_ni;
    prog[`ip]+:1;
    $[op=`snd; prog[`outBuf],:.d18.val[prog[`reg];param 0];
      op=`set; prog[`reg;"C"$param 0]:.d18.val[prog[`reg];param 1];
      op=`add; prog[`reg;"C"$param 0]+:.d18.val[prog[`reg];param 1];
      op=`mul; prog[`reg;"C"$param 0]*:.d18.val[prog[`reg];param 1];
      op=`mod; prog[`reg;"C"$param 0]:prog[`reg;"C"$param 0]mod .d18.val[prog[`reg];param 1];
      op=`rcv; $[0<count prog[`inBuf]; 
            [prog[`reg;"C"$param 0]:first prog[`inBuf]; prog[`inBuf]:1_prog[`inBuf];prog[`blocked]:0b];
            [prog[`ip]-:1; prog[`blocked]:1b]];
      op=`jgz; if[.d18.val[prog[`reg];param 0]>0; prog[`ip]+:.d18.val[prog[`reg];param 1]-1];
    '"invalid instruction"];
    prog};

d18p2:{
    prog0:.d18.new[0];
    prog1:.d18.new[1];
    total:0;
    ins:trim each"\n"vs x;
    while[1b;
        while[not prog0`blocked; prog0:.d18.step[ins;prog0]];
        while[not prog1`blocked; prog1:.d18.step[ins;prog1]];
        prog0[`inBuf],:prog1[`outBuf];
        total+:count prog1[`outBuf];
        prog1[`outBuf]:();
        prog1[`inBuf],:prog0[`outBuf];
        prog0[`outBuf]:();
        if[0<count prog0[`inBuf]; prog0[`blocked]:0b];
        if[0<count prog1[`inBuf]; prog1[`blocked]:0b];
        if[all (prog0`blocked;prog1`blocked);
            :total;
        ];
    ];
    };

d18p2"snd 1
    snd 2
    snd p
    rcv a
    rcv b
    rcv c
    rcv d"  //3
\

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `duet in key`;
        system"l ",path,"/duet.q";
    ];
    }[];

d18p1:{last .duet.getOutput .duet.run .duet.new[x]};
d18p2:{
    st0:.duet.new[x];
    st1:.duet.editRegister[st0;`p;1];
    totalOut1:0;
    run:1b;
    while[run;
        st0:.duet.run st0;
        st1:.duet.run st1;
        out0:.duet.getOutput st0;
        out1:.duet.getOutput st1;
        totalOut1+:count out1;
        st0:.duet.clearOutput st0;
        st1:.duet.clearOutput st1;
        st0:.duet.addInput[st0;out1];
        st1:.duet.addInput[st1;out0];
        run:0<count[out0]+count[out1];
    ];
    totalOut1};

//d18p1 "set i 31\nset a 1\nmul p 17\njgz p p\nmul a 2\nadd i -1\njgz i -2\nadd a -1\nset i 127\nset p 952\nmul p 8505\nmod p a\nmul p 129749\nadd p 12345\nmod p a\nset b p\nmod b 10000\nsnd b\nadd i -1\njgz i -9\njgz a 3\nrcv b\njgz b -1\nset f 0\nset i 126\nrcv a\nrcv b\nset p a\nmul p -1\nadd p b\njgz p 4\nsnd a\nset a b\njgz 1 3\nsnd b\nset f 1\nadd i -1\njgz i -11\nsnd a\njgz f -16\njgz a -19"
//d18p2 "set i 31\nset a 1\nmul p 17\njgz p p\nmul a 2\nadd i -1\njgz i -2\nadd a -1\nset i 127\nset p 952\nmul p 8505\nmod p a\nmul p 129749\nadd p 12345\nmod p a\nset b p\nmod b 10000\nsnd b\nadd i -1\njgz i -9\njgz a 3\nrcv b\njgz b -1\nset f 0\nset i 126\nrcv a\nrcv b\nset p a\nmul p -1\nadd p b\njgz p 4\nsnd a\nset a b\njgz 1 3\nsnd b\nset f 1\nadd i -1\njgz i -11\nsnd a\njgz f -16\njgz a -19"

/
OVERVIEW:

Just the usual VM simulation.

After porting to GenArch, it turns out that for part 1, the usual method of running
until it blocks for input is OK, then we can just take the last output as the answer.
No need to use the alleged behavior of the rcv instruction doing nothing with a zero
argument (at least for my input).
For part 2, the same convention of blocking when input is needed makes it easy to
run two instances in "parallel" and pass data between them.
