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
