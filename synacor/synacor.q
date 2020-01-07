{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `genarch in key`;
        system"l ",path,"/../utils/genarch.q";
    ];
    }[];

.synacor.new:{
    mem:{x[;0]+256*x[;1]}2 cut x;
    if[count[mem]<32768; mem,:(32768-count[mem])#0];
    //(sta;ip;tp;regs;mem;stack;input;output)
    (`run;0;0;8#0;mem;`long$();"";"")};

.synacor.semantics:()!();
.synacor.semantics[`HLT]:();
.synacor.semantics[`SET]:(enlist"o";enlist"i");
.synacor.semantics[`PUSH]:enlist enlist"i";
.synacor.semantics[`POP]:enlist enlist"o";
.synacor.semantics[`EQ]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`GT]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`JMP]:enlist"ji";
.synacor.semantics[`JT]:(enlist"i";"ji");
.synacor.semantics[`JF]:(enlist"i";"ji");
.synacor.semantics[`ADD]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`MUL]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`MOD]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`AND]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`OR]:(enlist"o";enlist"i";enlist"i");
.synacor.semantics[`NOT]:(enlist"o";enlist"i");
.synacor.semantics[`LOAD]:(enlist"o";"im");
.synacor.semantics[`STO]:("om";enlist"i");
.synacor.semantics[`CALL]:enlist"ji";
.synacor.semantics[`RET]:();
.synacor.semantics[`OUT]:enlist"ci";
.synacor.semantics[`IN]:enlist enlist"o";
.synacor.semantics[`NOP]:();

.synacor.argc:count each value .synacor.semantics;
.synacor.opn:key .synacor.semantics;
.synacor.fetch:{[reg;x]$[x within 0 32767; x; x within 32768 32775; reg[x-32768];'"invalid number "+string x]};

.synacor.runD:{[st;d;bp;step]
    ip:st[1];
    tp:st[2];
    reg:st[3];
    mem:st[4];
    stack:st[5];
    input:st[6];
    output:st[7];
    run:1b;
    while[run;
        op:mem[ip];
        argc:.synacor.argc op;
        if[null argc; {'x}"invalid op ",string[op]];
        argv:mem[ip+1+til argc];
        $[op=0;[-1"executing HLT instruction";st[0]:`halt; run:0b];   //halt
          op=1;[reg[mem[ip+1]-32768]:.synacor.fetch[reg;mem[ip+2]];ip+:3];   //set register
          op=2;[stack:.synacor.fetch[reg;mem[ip+1]],stack;ip+:2]; //push
          op=3;[reg[mem[ip+1]-32768]:first stack; stack:1_stack;ip+:2]; //pop
          op=4;[reg[mem[ip+1]-32768]:`long$.synacor.fetch[reg;mem[ip+2]]=.synacor.fetch[reg;mem[ip+3]];ip+:4]; //eq
          op=5;[reg[mem[ip+1]-32768]:`long$.synacor.fetch[reg;mem[ip+2]]>.synacor.fetch[reg;mem[ip+3]];ip+:4]; //gt
          op=6;[ip:.synacor.fetch[reg;mem[ip+1]]]; //jmp
          op=7;[ip:$[.synacor.fetch[reg;mem[ip+1]]<>0;mem[ip+2];ip+3]]; //jump if true
          op=8;[ip:$[.synacor.fetch[reg;mem[ip+1]]=0;mem[ip+2];ip+3]]; //jump if false
          op=9;[reg[mem[ip+1]-32768]:(.synacor.fetch[reg;mem[ip+2]]+.synacor.fetch[reg;mem[ip+3]])mod 32768;ip+:4]; //add
          op=10;[reg[mem[ip+1]-32768]:(.synacor.fetch[reg;mem[ip+2]]*.synacor.fetch[reg;mem[ip+3]])mod 32768;ip+:4]; //mult
          op=11;[reg[mem[ip+1]-32768]:.synacor.fetch[reg;mem[ip+2]] mod .synacor.fetch[reg;mem[ip+3]];ip+:4]; //mod
          op=12;[reg[mem[ip+1]-32768]:0b sv((0b vs .synacor.fetch[reg;mem[ip+2]]) and 0b vs .synacor.fetch[reg;mem[ip+3]]);ip+:4]; //and
          op=13;[reg[mem[ip+1]-32768]:0b sv((0b vs .synacor.fetch[reg;mem[ip+2]]) or 0b vs .synacor.fetch[reg;mem[ip+3]]);ip+:4]; //or
          op=14;[reg[mem[ip+1]-32768]:(0b sv(not 0b vs .synacor.fetch[reg;mem[ip+2]]))mod 32768;ip+:3]; //not
          op=15;[reg[mem[ip+1]-32768]:mem[.synacor.fetch[reg;mem[ip+2]]];ip+:3]; //rmem
          op=16;[addr:.synacor.fetch[reg;mem[ip+1]];mem[addr]:.synacor.fetch[reg;mem[ip+2]];ip+:3]; //wmem
          op=17;[stack:(ip+2),stack;ip:.synacor.fetch[reg;mem[ip+1]]]; //call
          op=18;[ip:first stack; stack:1_stack]; //ret
          op=19;[output,:`char$.synacor.fetch[reg;mem[ip+1]];ip+:2]; //out
          op=20;$[tp>=count input; [st[0]:`needInput; run:0b];[reg[mem[ip+1]-32768]:`long$input tp; tp+:1;ip+:2]]; //in
          op=21;[ip+:1]; //noop
          '"invalid instruction"
        ];
        if[d;if[$[step;1b;ip in bp]; if[st[0]=`run;st[0]:`break]; run:0b]];
    ];
    st[1]:ip;
    st[2]:tp;
    st[3]:reg;
    st[4]:mem;
    st[5]:stack;
    st[6]:input;
    st[7]:output;
    st};

.synacor.run:{[st]
    st[6]:st[2]_st[6];  //cut input
    st[2]:0;            //reset tape pointer
    st[7]:"";           //cut output
    .synacor.runD[st;0b;();0b]};

.synacor.runI:{[st;input]
    .synacor.run[.synacor.addInput[st;input]]};

.genarch.addPlaceholders`synacor;
.synacor.resume:{[st]st[0]:`run;st};
.synacor.isRunning:{[st]st[0]=`run};
.synacor.isTerminated:{[st]st[0]=`halt};
.synacor.needsInput:{[st]st[0]=`needInput};
.synacor.getIp:{[st]st[1]};
.synacor.getRegisters:{[st]st[3]};
.synacor.getStackPointer:{[st]0N};
.synacor.getInput:{[st]st[2]_st[6]};
.synacor.addInput:{[st;input]st[6],:input,"\n";st};
.synacor.getOutput:{[st]st[7]};
.synacor.clearOutput:{[st]st[7]:"";st};
.synacor.getMemory:{[st]st[4]};
.synacor.getStack:{[st]st[5]};
.synacor.ipValid:{[st;ip]ip within 0,count[st 4]-1};
.synacor.editMemory:{[st;addr;val]st[4;addr]:val;st};
.synacor.editRegister:{[st;r;v]st[3;r]:v;st};

.synacor.disasmOne:{[st;ip;hints]
    cutPoints:$[`cutPoints in key hints; hints`cutPoints;0#0];
    cutPoints:asc distinct cutPoints,st 1;
    labels:$[`memLabels in key hints; hints`memLabels;(0#0)!`$()];
    mem:st[4];
    op:mem[ip];
    argc:.synacor.argc op;
    $[null argc;
        [
            :((ip;enlist[mem ip];`INVALID;());ip+1);
        ];
      any (ip<cutPoints) and (ip+1+argc)>cutPoints;
        [
            :((ip;enlist[mem ip];`INVALID;());ip+1);
        ];
        [
            opc:.synacor.opn op;
            intc:mem[ip+til 1+argc];
            argv:1_intc;
            sem:.synacor.semantics opc;
            argChar:"c" in/:sem;
            argMem:"m" in/:sem;
            argstr:{[argChar;argMem;argv]
                s:$[argv>=32768;"r",string[argv-32768];argChar;.Q.s1`char$argv;string argv];
                if[argMem; s:"[",s,"]"];
                s}'[argChar;argMem;argv];
            :((ip;intc;opc;argstr);ip+count intc);
        ]
    ];
    };

.synacor.jumpConditions:()!();
.synacor.jumpConditions[`CALL]:{1b};
.synacor.jumpConditions[`JMP]:{1b};
.synacor.jumpConditions[`JT]:{0<>x[0]};
.synacor.jumpConditions[`JF]:{0=x[0]};

.synacor.analyzeEffects:{[st]
    r:st[3];
    ip:st[1];
    mem:st[4];
    op:mem[ip];
    opc:.synacor.opn op;
    inArgs:();
    outArgs:();
    inVals:();
    sem:.synacor.semantics opc;
    argc:.synacor.argc op;
    args:mem[ip+1+til argc];
    inArgIdx:where "i" in/:sem;
    isReg:args[inArgIdx]>=32768;
    isChar:"c" in/:sem[inArgIdx];
    isMem:"m" in/:sem[inArgIdx];
    inArgs,:{[r;ip;x;y;z;m]$[x;$[m;r y-32768;`$"r.",string y-32768];$[m;y;ip+z]]}[r;ip]'[isReg;args inArgIdx;1+inArgIdx;isMem];
    inVals,:{[r;mem;m;x;y]$[m;mem;::]$[x;r[y-32768];y]}[r;mem]'[isMem;isReg;args inArgIdx];
    argDisp:{$[x;.Q.s1`char$y;string y]}'[isChar;inVals];
    outArgDisp:();
    outArgIdx:where "o" in/:sem;
    ref:args outArgIdx;
    isReg:ref>=32768;
    isMem:"m" in/:sem[outArgIdx];
    outArgs,:{[r;m;x;y]$[x;$[m;r y-32768;`$"r.",string y-32768];$[m;y;`]]}[r]'[isMem;isReg; args outArgIdx];
    outArgDisp,:{[r;m;x;y]$[x;$[m;"[",string[r y-32768],"]";"r",string y-32768];$[m;"[",string[y],"]";"INVALID"]]}[r]'[isMem;isReg; args outArgIdx];
    res:`memRead`memWrite!(inArgs;outArgs);
    jumpArgIdx:where "j" in/:sem;
    if[0<count jumpArgIdx;
        res[`jumpTarget]:inVals inArgIdx?jumpArgIdx;
        res[`jumpTaken]:.synacor.jumpConditions[opc][inVals];
    ];
    res[`effInstr]:string[opc]," ",(", "sv argDisp),$[0<count outArgDisp;" => ",", "sv outArgDisp;""];
    res};

.genarch.register`synacor;
