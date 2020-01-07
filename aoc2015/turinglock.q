{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `genarch in key`;
        system"l ",path,"/../utils/genarch.q";
    ];
    }[];

.turinglock.new:{
    if[not 10h=type x; '"string expected"];
    inp:("\n"vs x except"\r")except enlist"";
    cmds:{a:" "vs x;(`$a[0]),", "vs" "sv 1_a}each inp;
    regs:`a`b!0 0;
    (`run;0;cmds;regs)};

.turinglock.runD:{[st;d;bp;step]
    ip:st[1];
    r:st[3];
    while[ip within (0;count[st 2]-1);
        cmd:st[2][ip];
        op:cmd 0;
        $[op=`hlf;
            [r[`$cmd 1]:r[`$cmd 1]div 2;ip+:1];
          op=`tpl;
            [r[`$cmd 1]*:3;ip+:1];
          op=`inc;
            [r[`$cmd 1]+:1;ip+:1];
          op=`jmp;
            ip+:"J"$cmd 1;
          op=`jie;
            ip+:$[0=r[`$cmd 1]mod 2; "J"$cmd 2;1];
          op=`jio;
            ip+:$[1=r[`$cmd 1]; "J"$cmd 2;1];
          '"unknown instruction ",cmd[0]
        ];
        if[d;if[$[step;1b;ip in bp]; :(`break;ip;st[2];r)]];
    ];
    st[0]:`halt;
    st[1]:ip;
    st[3]:r;
    st};

.turinglock.run:{[st].turinglock.runD[st;0b;();0b]};

.genarch.addPlaceholders`turinglock;
.turinglock.resume:{[st]st[0]:`run;st};
.turinglock.isRunning:{[st]st[0]=`run};
.turinglock.isTerminated:{[st]st[0]=`halt};
.turinglock.getIp:{[st]st[1]};
.turinglock.getRegisters:{[st]st[3]};
.turinglock.editRegister:{[st;reg;val]if[not reg in key st[3];'"unknown register"];st[3;reg]:val;st};

.turinglock.ipValid:{[st;ip]
    ip within (0;count[st 2]-1)};

.turinglock.disasmOne:{[st;ip;cutPoints]
    cmd:st[2][ip];
    op:cmd 0;
    ((ip;`int$();cmd 0;1_cmd);ip+1)};

.turinglock.analyzeEffects:{[st]
    ip:st[1];
    cmd:st[2][ip];
    op:cmd 0;
    inArgs:();
    outArgs:();
    inVals:();
    if[op in `hlf`tpl`inc`jie`jio;
        inArgs,:enlist`$"r.",cmd[1];
        inVals,:enlist st[3][`$cmd[1]];
    ];
    argDisp:string inVals;
    outArgDisp:();
    if[op in `hlf`tpl`inc;
        outArgs,:enlist`$"r.",cmd[1];
        outArgDisp,:enlist cmd[1];
    ];
    res:`memRead`memWrite!(inArgs;outArgs);
    if[op in `jmp`jie`jio;
        res[`jumpTarget]:ip+"J"$last cmd;
        res[`jumpTaken]:$[op=`jie;0=inVals[0]mod 2;
            op=`jio;1=inVals[0];
            1b];
        argDisp,:enlist string res`jumpTarget;
    ];
    res[`effInstr]:string[op]," ",(", "sv argDisp),$[0<count outArgDisp;" => ",", "sv outArgDisp;""];
    res};

.genarch.register`turinglock;
