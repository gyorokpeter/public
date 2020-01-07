{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `genarch in key`;
        system"l ",path,"/../utils/genarch.q";
    ];
    }[];

.assembunny.new:{
    if[not 10h=type x; '"string expected"];
    inp:("\n"vs x except"\r")except enlist"";
    cmds:{a:" "vs x;(`$a[0]),1_a}each inp;
    /cmds:{a:" "vs x;a}each inp;
    regs:`a`b`c`d!4#0;
    (`run;0;cmds;regs;())};

.assembunny.getVal:{[reg;val]if[null v:"J"$val;v:reg[`$val]];v};

.assembunny.altIns:()!();
//1-arg instructions
.assembunny.altIns[`inc]:`dec;
.assembunny.altIns[`dec]:`inc;
.assembunny.altIns[`tgl]:`inc;
.assembunny.altIns[`out]:`inc;  //never actually defined or used in the puzzles
//2-arg instructions
.assembunny.altIns[`jnz]:`cpy;
.assembunny.altIns[`cpy]:`jnz;
//optimized order
.assembunny.altIns:(asc key .assembunny.altIns)#.assembunny.altIns;

.assembunny.v:{[reg;val]if[null v:"J"$val;v:reg[`$val]];v};

.assembunny.fetch:{[ins;ip]
    if[ip<count[ins]-8;
        seq:8#ip _ins;
        if[(seq[;0]~`cpy`jnz`jnz`dec`dec`jnz`inc`jnz) and
            (seq[1 2 5 7;2]~(enlist"2";enlist"6";"-4";"-7")) and
            (seq[2 7;1]~(enlist"1";enlist"1")) and
            (seq[0;2]~seq[4;1]) and (seq[4;1]~seq[5;1]) and
            (seq[1;1]~seq[3;1]);
            :(`div;seq[1;1];seq[0;1];seq[6;1];seq[0;2]);
        ];
    ];
    if[ip<count[ins]-6;
        seq:6#ip _ins;
        if[(seq[;0]~`cpy`inc`dec`jnz`dec`jnz)and (seq[2;1]~seq[3;1]) and (seq[0;2]~seq[2;1])
             and (seq[4;1]~seq[5;1])
            and seq[3 5;2]~("-2";"-5");
            :(`mul;seq[0;1];seq[4;1];seq[1;1];seq[0;2])];
    ];
    if[ip<count[ins]-3;
        seq:3#ip _ins;
        if[(seq[;0]~`dec`inc`jnz)and (seq[0;1]~seq[2;1]) and seq[2;2]~"-2";
            :(`add;seq[0;1];seq[1;1])];
        seq:3#ip _ins;
        if[(seq[;0]~`inc`dec`jnz)and (seq[1;1]~seq[2;1]) and seq[2;2]~"-2";
            :(`add;seq[1;1];seq[0;1])];
    ];
    :ins[ip];
    };

.assembunny.mul:{[ni;reg]va:.assembunny.v[reg;ni[1]];rb:`$ni[2];rt:`$ni[3];rtmp:`$ni[4];reg[rt]+:va*reg[rb];reg[rb,rtmp]:0;reg};
.assembunny.add:{[ni;reg]rs:`$ni[1];rt:`$ni[2];reg[rt]+:reg[rs];reg[rs]:0;reg};

.assembunny.ops:(enlist[`])!(enlist{'"unknown"});
.assembunny.ops[`out]:{[ni;ip;ins;reg]
    v:.assembunny.v[reg;ni 1];
    (ip+1;ins;reg;v)};
.assembunny.ops[`cpy]:{[ni;ip;ins;reg]
    v:.assembunny.v[reg;ni 1];r:`$ni[2];if[r in key reg;reg[r]:v];
    (ip+1;ins;reg)};
.assembunny.ops[`inc]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]+:1];
    (ip+1;ins;reg)};
.assembunny.ops[`dec]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]-:1];
    (ip+1;ins;reg)};
.assembunny.ops[`jnz]:{[ni;ip;ins;reg]
    v:.assembunny.v[reg;ni 1];v2:.assembunny.v[reg;ni 2];if[v>0;ip+:v2-1];
    (ip+1;ins;reg)};
.assembunny.ops[`tgl]:{[ni;ip;ins;reg]
    v:.assembunny.v[reg;ni 1];ti:v+ip;if[ti<count ins;ins[ti;0]:.assembunny.altIns ins[ti;0]];
    (ip+1;ins;reg)};
.assembunny.ops[`mul]:{[ni;ip;ins;reg]
    reg:.assembunny.mul[ni;reg];
    (ip+6;ins;reg)};
.assembunny.ops[`div]:{[ni;ip;ins;reg]
    rs:`$ni 1;divisor:.assembunny.v[reg;ni 2];quot:`$ni 3;rem:`$ni 4;
    result:reg[rs] div divisor;
    remainder:divisor-reg[rs] mod divisor;
    reg[quot]+:result;
    reg[rem]:remainder;
    reg[rs]:0;
    (ip+8;ins;reg)};
.assembunny.ops[`add]:{[ni;ip;ins;reg]
    reg:.assembunny.add[ni;reg];
    (ip+3;ins;reg)};

.assembunny.runD:{[st;d;bp;step]
    ip:st[1];
    while[ip within (0;count[st 2]-1);
        ni:.assembunny.fetch[st[2];ip];
        op:.assembunny.ops[ni[0]];
        if[null op; 'ni[0]," unknown"];
        res:op[ni;ip;st[2];st[3]];
        ip:res[0];
        st[2]:res[1];
        st[3]:res[2];
        if[4=count res; st[4],:res[3]];
        if[d;if[$[step;1b;ip in bp]; st[0]:`break;st[1]:ip; :st]];
    ];
    st[0]:`halt;
    st[1]:ip;
    st};

.assembunny.run:{[st].assembunny.runD[st;0b;();0b]};

.genarch.addPlaceholders`assembunny;
.assembunny.resume:{[st]st[0]:`run;st};
.assembunny.isRunning:{[st]st[0]=`run};
.assembunny.isTerminated:{[st]st[0]=`halt};
.assembunny.getIp:{[st]st[1]};
.assembunny.getRegisters:{[st]st[3]};
.assembunny.getOutput:{[st]st[4]};
.assembunny.clearOutput:{[st]st[4]:();st};
.assembunny.getImmediate:{[st;ip;slot]"J"$st[2;ip;slot]};
.assembunny.editRegister:{[st;reg;val]if[not reg in key st[3];'"unknown register"];st[3;reg]:val;st};

.assembunny.ipValid:{[st;ip]
    ip within (0;count[st 2]-1)};

.assembunny.disasmOne:{[st;ip;cutPoints]
    cmd:.assembunny.fetch[st[2];ip];
    op:cmd 0;
    delta:1^(`div`mul`add!8 6 3)op;
    ((ip;`int$();cmd 0;1_cmd);ip+delta)};

.assembunny.analyzeEffects:{[st]
    r:st[3];
    ip:st[1];
    cmd:.assembunny.fetch[st[2];ip];
    op:cmd 0;
    inArgs:();
    outArgs:();
    inVals:();
    if[op in `inc`dec;
        inArgs,:enlist`$"r.",cmd[1];
        inVals,:enlist r[`$cmd[1]];
    ];
    if[op in `cpy`tgl`jnz`out`add`mul`div;
        $[cmd[1] in string key r;[
            inArgs,:enlist`$"r.",cmd[1];
            inVals,:enlist r[`$cmd[1]];
        ];[
            inArgs,:enlist`$"i.",string[ip],".1";
            inVals,:enlist"J"$cmd[1];
        ]];
    ];
    if[op in`add`mul`div`jnz;
        $[cmd[2] in string key r;[
            inArgs,:enlist`$"r.",cmd[2];
            inVals,:enlist r[`$cmd[2]];
        ];[
            inArgs,:enlist`$"i.",string[ip],".2";
            inVals,:enlist"J"$cmd[2];
        ]];
    ];
    argDisp:string inVals;
    outArgDisp:();
    if[op in `inc`dec;
        outArgs,:enlist`$"r.",cmd[1];
        outArgDisp,:enlist cmd[1];
    ];
    if[op=`add;
        outArgs,:enlist`$"r.",cmd[2];
        outArgDisp,:enlist cmd[2];
    ];
    if[op in`mul`div;
        outArgs,:enlist`$"r.",cmd[3];
        outArgDisp,:enlist cmd[3];
    ];
    if[op=`cpy;
        ref:cmd[2];
        $[ref in string key r;
            [
                outArgs,:enlist`$"r.",ref;
                outArgDisp,:enlist ref;
            ];[
                outArgs,:enlist`;
                outArgDisp,:enlist "INVALID";
            ]
        ];
    ];
    res:`memRead`memWrite!(inArgs;outArgs);
    if[op in`jnz`tgl;
        res[`jumpTarget]:ip+last inVals;
        res[`jumpTaken]:$[op=`jnz;0<>inVals[0];0b];
        argDisp[count[argDisp]-1]:string res`jumpTarget;
    ];
    res[`effInstr]:string[op]," ",(", "sv argDisp),$[0<count outArgDisp;" => ",", "sv outArgDisp;""];
    res};

.genarch.register`assembunny;
