{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `html in key`;
        system"l ",path,"/../utils/html.q";
    ];
    }[];

.intcode.debug:0b;
.intcode.keepOutput:0b;
.intcode.breakOnExit:0b;
.intcode.breakpoints:();
.intcode.recordPoints:();
intcode:{[a;input]
    output:`long$();
    mode:`run;
    $[-11h=type a[0];
        //(`pause;ip;tp;mo;a;input;output)
        [mode:a[0];ip:a[1];tp:a[2];mo:a[3];input:a[5],input;if[.intcode.keepOutput;output:a 6];  a:a[4]];
        [ip:0;tp:0;mo:0]
    ];
    run:1b;
    while[run;
        op:a[ip] mod 100;
        argc:(1 2 3 4 5 6 7 8 9 99!3 3 1 1 2 2 3 3 1 0)op;
        if[null argc; '"invalid op ",string[op]];
        if[.intcode.debug;-1 string[ip],": "," "sv string a[ip+til 1+argc]];
        argm:argc#(a[ip] div 100 1000 10000)mod 10;
        argv0:a[ip+1+til argc];
        arga:?[2>argm;argv0;argv0+mo];
        mm:max 0,arga where 1<>argm;
        if[mm>=count a; a,:(1+mm-count a)#0];
        argv:?[argm=1;argv0;a arga];
        $[op=1; [a[arga 2]:argv[0]+argv[1]; ip+:1+argc];
          op=2; [a[arga 2]:argv[0]*argv[1]; ip+:1+argc];
          op=3;[$[tp>=count input; :(`pause;ip;0;mo;a;0#input;output);
            [a[arga 0]:input[tp]; tp+:1; ip+:1+argc]]];
          op=4; [output,:argv 0; ip+:1+argc];
          op=5; $[argv[0]<>0; ip:argv 1; ip+:1+argc];
          op=6; $[argv[0]=0; ip:argv 1; ip+:1+argc];
          op=7; [a[arga 2]:0+argv[0]<argv[1]; ip+:1+argc];
          op=8; [a[arga 2]:0+argv[0]=argv[1]; ip+:1+argc];
          op=9; [mo+:argv 0; ip+:1+argc];
          op=99; run:0b;
          '"invalid op"
        ];
        if[run and ip in .intcode.breakpoints; :(`break;ip;0;mo;a;tp _input;output)];
        if[run and ip in .intcode.recordPoints; .intcode.trace,:enlist(`record;ip;0;mo;a;tp _input;output);];
        if[run and mode=`step; :(mode;ip;0;mo;a;tp _input;output)];
    ];
    $[.intcode.breakOnExit;(`halt;ip;0;mo;a;tp _input;output);output]};

.intcode.out:{$[0h=type x;x[6];x]};

.html.commandHandlers[`intcode]:`.intcode.gui;

.intcode.origCode:();
.intcode.debugState:(::);
.intcode.trace:();
.intcode.traceMax:50000;
.intcode.tracePtr:0N;
.intcode.tempLineage:"";
.intcode.new:{(`pause;0;0;0;x;0#0;0#0)};
.intcode.argstr:{$[x[0]=`abs;"[",$[x[1] in key .intcode.label;.intcode.label[x 1];string[x 1]],"]";x[0]=`imm;string[x 1];"[RB",$[x[1]>0;"+",string[x 1];x[1]<0;string[x 1];""],"]"]};
.intcode.instrstr:{string[x 2]," ",","sv .intcode.argstr each x[3]};
.intcode.label:(`long$())!();
.intcode.gui:{
    if[`code in key x;
        .intcode.origCode:"J"$","vs x`code;
        .intcode.debugState:.intcode.new[.intcode.origCode];
        .intcode.tempLineage:"";
        :.html.fastredirect["intcode"];
    ];
    if[(::)~.intcode.debugState;
        :.html.page["intcode";"intcode: ",.h.htac[`form;enlist[`method]!enlist"post";
            .h.htac[`input;enlist[`name]!enlist"code";""]
            ,.h.htac[`input;enlist[`type]!enlist"submit";""]]];
    ];
    if[`new in key x;
        .intcode.origCode:();
        .intcode.debugState:(::);
        .intcode.trace:();
        .intcode.breakpoints:();
        .intcode.label:(`long$())!();
        .intcode.tempLineage:"";
        :.html.fastredirect["intcode"];
    ];
    if[`reset in key x;
        .intcode.debugState:.intcode.new[.intcode.origCode];
        .intcode.trace:();
        :.html.fastredirect["intcode"];
    ];
    if[`em in key x;
        addr:"J"$x[`em];
        if[x[`v;0]="@";
            lbl:1_x`v;
            if[count .intcode.label;if[lbl in value .intcode.label; '"dup label: ",lbl]];
            .intcode.label[addr]:lbl;
            if[1=count x`v; .intcode.label:enlist[addr] _.intcode.label];
            .intcode.label:{(asc key x)#x}.intcode.label;
            :.html.fastredirect["intcode"];
        ];
        val:"J"$x[`v];
        if[null addr;'"bad em"];
        if[null val;'"bad v"];
        .intcode.debugState[4;addr]:val;
        :.html.fastredirect["intcode"];
    ];
    if[`ni in key x;
        .intcode.debugState[0]:`step;
        .intcode.keepOutput:1b;
        .intcode.debugState:intcode[.intcode.debugState;()];
        .intcode.keepOutput:0b;
        :.html.fastredirect["intcode"];
    ];
    if[`bp in key x;
        addr:"J"$x[`bp];
        if[null addr;'"bad bp"];
        .intcode.breakpoints:asc distinct $[addr in .intcode.breakpoints;except;,][.intcode.breakpoints;addr];
        :.html.fastredirect["intcode"];
    ];
    if[`tb in key x;
        if[.intcode.tracePtr>0;
            .intcode.tracePtr-:1;
            .intcode.debugState:.intcode.trace .intcode.tracePtr;
        ];
        :.html.fastredirect["intcode"];
    ];
    if[`tf in key x;
        if[(0<count .intcode.trace)and .intcode.tracePtr<count[.intcode.trace]-1;
            .intcode.tracePtr+:1;
            .intcode.debugState:.intcode.trace .intcode.tracePtr;
        ];
        :.html.fastredirect["intcode"];
    ];
    if[`tr in key x;
        addr:"J"$x[`tr];
        if[null addr;'"bad addr"];
        if[not addr within (0;count[.intcode.trace]-1); '"bad index"];
        if[(0<count .intcode.trace);
            .intcode.tracePtr:addr;
            .intcode.debugState:.intcode.trace .intcode.tracePtr;
        ];
        :.html.fastredirect["intcode"];
    ];
    if[`run in key x;
        .intcode.trace:();
        .intcode.breakOnExit:1b;
        .intcode.keepOutput:1b;
        .intcode.debugState[0]:`pause;
        .intcode.debugState:intcode[.intcode.debugState;()];
        .intcode.keepOutput:0b;
        .intcode.breakOnExit:0b;
        :.html.fastredirect["intcode"];
    ];
    if[`trace in key x;
        .intcode.breakOnExit:1b;
        .intcode.keepOutput:1b;
        .intcode.debugState[0]:`step;
        .intcode.trace:();
        while[.intcode.debugState[0]=`step;
            .intcode.trace,:enlist .intcode.debugState;
            if[count[.intcode.trace]>.intcode.traceMax; .intcode.trace:neg[.intcode.traceMax]#.intcode.trace; .Q.gc[]];
            .intcode.debugState:intcode[.intcode.debugState;()];
        ];
        if[.intcode.debugState[0]=`break;.intcode.trace,:enlist .intcode.debugState];
        .intcode.tracePtr:count[.intcode.trace]-1;
        .intcode.keepOutput:0b;
        .intcode.breakOnExit:0b;
        :.html.fastredirect["intcode"];
    ];
    if[`input in key x;
        .intcode.debugState[5],:"J"$" "vs ssr[x[`input];",";" "];
        :.html.fastredirect["intcode"];
    ];
    if[`lineage in key x;
        if[0=count .intcode.trace;'"must trace first"];
        addr:"J"$x[`lineage];
        if[null addr;'"bad address"];
        .intcode.tempLineage:.intcode.renderLineage[addr;.intcode.tracePtr];
        :.html.fastredirect["intcode"];
    ];
    if[`hist in key x;
        if[0=count .intcode.trace;'"must trace first"];
        addr:"J"$x[`hist];
        if[null addr;'"bad address"];
        c:count .intcode.trace;
        .intcode.tempLineage:exec enlist'[0;0;i;string[i],'": ",/:string addr] from ([]addr:.intcode.trace[;4;addr]);
        :.html.fastredirect["intcode"];
    ];
    if[`histOut in key x;
        if[0=count .intcode.trace;'"must trace first"];
        outc:count each .intcode.trace[;6];
        outd:where 1=deltas outc;
        .intcode.tempLineage:exec enlist'[0;0;outd-1;string[outd-1],'": ",/:string cont] from ([]cont:last each .intcode.trace[outd;6]);
        :.html.fastredirect["intcode"];
    ];
    ip:.intcode.debugState[1];
    memall:.intcode.debugState 4;
    das:.intcode.disasm[memall;enlist ip];
    ci:das where das[;0]=ip;
    rb:.intcode.debugState 3;
    arga:raze{[rb;x]{[rb;ao;x]($[x[0]=`imm;ao;x[0]=`abs;x[1];x[0]=`rel;rb+x[1]];x[2])}[rb]'[x[0]+1+til count x[3];x[3]]}[rb]each ci;
    argv:{[memall;x]if[x[1]=`in; x[0]:memall[x 0]];x}[memall]each arga;
    jdest:$[any `JNZ`JZ in ci[;2]; enlist last[argv][0];()];
    expl:(raze string ci[;2])," ",","sv .intcode.argstr each ((`in`out!`imm`abs)argv[;1]),'argv;
    jtaken:0b;
    lineageDisp:"";
    if[0<count .intcode.tempLineage;
        lineageDisp:"\n"sv {(x[0]#" "),.h.ha["?tr=",string[x 2];"&gt;"],$[x[2]=.intcode.tracePtr;.h.htc[`b];::]x[3]}each .intcode.tempLineage;
    ];
    if[count jdest;
        jtaken:$[`JZ=ci[0;2];argv[0;0]=0;`JNZ=ci[0;2];argv[0;0]<>0;0b];
        expl,:" ",$[jtaken;"jump IS taken";"jump is NOT taken"];
    ];
    if[count[memall]<=mxa:max rb,arga[;0];
        memall,:(1+mxa-count[memall])#0;
    ];
    .html.page["intcode";
        .h.htac[`style;enlist[`type]!enlist"text/css";"body{font-family:Courier New;font-size:16px}td{padding-right:30px}"
            ,".ip{background:rgb(255,255,128)}.top{height:4vh}.pl{float:left;width:48%;height:93vh;overflow:auto}.pr{float:right;width:48%;height:93vh;overflow:auto}"
            ,".jd{background:rgb(",$[jtaken;"192,255,192";"192,192,192"],")}"
            ,(","sv"[data-addr='",/:string[arga[;0] where arga[;1]=`in],\:"']"),"{background:rgb(0,255,0)}"
            ,(","sv"[data-addr='",/:string[arga[;0] where arga[;1]=`out],\:"']"),"{border:solid 2px rgb(255,0,0)}"
            ,"[data-addr='",string[rb],"']{font-weight:bold}"
        ]
        ,.h.htac[`div;enlist[`class]!enlist"top";""
            ,.h.ha["intcode?new=1";"new"]," "
            ,.h.ha["intcode?reset=1";"reset"]," "
            ,.h.ha["intcode?ni=1";"next"]," "
            ,.h.ha["intcode?run=1";"continue"]
            ," ",.h.ha["intcode?trace=1";"trace"]
            ,$[count .intcode.trace;""
                ,$[.intcode.tracePtr>0;" ",.h.ha["?tb=1";"&lt;&lt"];""]
                ," ",.h.ha["?tr=",string[.intcode.tracePtr];string[.intcode.tracePtr],"/",string[count[.intcode.trace]-1]]
                ,$[.intcode.tracePtr<count[.intcode.trace]-1;" ",.h.ha["?tf=1";"&gt;&gt"];""]
                ;""
            ]
            ,"<br>"
        ]
        ,.h.htac[`div;enlist[`class]!enlist"pl";.h.htc[`table;raze{[jd;x].h.htac[`tr;$[.intcode.debugState[1]=x[0];enlist[`class]!enlist"ip";
                x[0] in jd;enlist[`class]!enlist"jd";()!()]]""
            ,.h.htc[`td;.h.ha["?bp=",string[x 0];"(",$[x[0]in .intcode.breakpoints;"x";" "],")"]]
            ,.h.htc[`td;string[x 0]]
            ,.h.htc[`td;" "sv{.h.htac[`span;(`$("class";"data-addr"))!("mem";string x);string[y]]}'[x[0]+til count x 1;x 1]]
            ,.h.htc[`td;.intcode.instrstr[x]]
            }[jdest]each das]]
        ,.h.htac[`div;enlist[`class]!enlist"pr";""
            ,expl,"<br>"
            ,"RB=",string[.intcode.debugState 3],"<br>"
            ,"IN=",(" "sv string[.intcode.debugState 5]),.h.htc[`form;.h.htac[`input;enlist[`name]!enlist"input";""],.h.htac[`input;enlist[`type]!enlist"submit";""]]
            ,"OUT=",(" "sv string[.intcode.debugState 6]),"<br>"
            ,"MEM=",(" "sv {.h.htac[`span;(`$("class";"data-addr"))!("mem";string x);$[x in key .intcode.label;.intcode.label[x],"=";""],string[y]]}'[til count memall;memall])
            ,"<br><br>",.h.htc[`form;"Lineage: ",.h.htac[`input;enlist[`name]!enlist"lineage";""],.h.htac[`input;enlist[`type]!enlist"submit";""]]
            ,.h.htc[`form;"History: ",.h.htac[`input;enlist[`name]!enlist"hist";""],.h.htac[`input;enlist[`type]!enlist"submit";""]]
            ,.h.htc[`form;.h.htac[`input;`name`type`value!("histOut";"hidden";enlist"1");""],.h.htac[`input;`type`value!("submit";"output history");""]]
            ,.h.htc[`pre;lineageDisp]
        ]
        ,.h.htac[`script;enlist[`type]!enlist"text/javascript";"changemem=a=>{var r=prompt('value or @label at '+a);if(r)window.location+='?em='+a+'&v='+r};"
            ,"for(var i of document.getElementsByClassName('mem'))i.onclick=e=>changemem(e.target.dataset.addr);"
            ,"document.getElementsByClassName('ip')[0].scrollIntoView({block: 'center'})"]
    ]};

.intcode.disasmOne:{[ip;mem;cutPoints]
    op:mem[ip] mod 100;
    argc:(1 2 3 4 5 6 7 8 9 99!3 3 1 1 2 2 3 3 1 0)op;
    $[null argc;
        [
            :(ip;enlist[mem ip];`INVALID;());
        ];
      any (ip<cutPoints) and (ip+1+argc)>cutPoints;
        [
            :(ip;enlist[mem ip];`INVALID;());
        ];
        [
            argm:`abs`imm`rel argc#(mem[ip] div 100 1000 10000)mod 10;
            argdir:argc#`in;
            intc:0^mem[ip+til 1+argc];
            opc:(1 2 3 4 5 6 7 8 9 99!`ADD`MUL`IN`OUT`JNZ`JZ`LT`EQ`ARB`HLT)op;
            if[opc in `ADD`MUL`IN`LT`EQ; argdir[argc-1]:`out];
            :(ip;intc;opc;argm,'(1_intc),'argdir);
        ]
    ];
    };

.intcode.disasm:{[a;cutPoints]
    ip:0;
    res:();
    while[ip<count a;
        nxt:.intcode.disasmOne[ip;a;cutPoints];
        res,:enlist nxt;
        ip+:count[nxt 1];
    ];
    res};

.intcode.getLineage:{[addr;cycle0]
    /addr:223
    /cycle0:60
    cycle:cycle0;
    deps:([]depFrom:();depTo:();val:`long$();instr:();cycle:`long$());
    queue:enlist (addr;cycle);
    cycle-:1;
    while[cycle>=0;
        state:.intcode.trace[cycle];
        ip:state[1];
        rb:state[3];
        ins:.intcode.disasmOne[ip;state[4];0#0];
        args:ins 3;
        if[`out=last last args;
            arga:raze{[rb;ao;x]($[x[0]=`imm;ao;x[0]=`abs;x[1];x[0]=`rel;rb+x[1]])}[rb]'[ip+1+til count args;args];
            inaddr:-1_arga;
            srcs:queue where queue[;0]=last arga;
            tgts:inaddr,\:cycle;
            deps,:([]depFrom:srcs)cross([]depTo:enlist tgts)cross([]val:.intcode.trace[cycle+1;4;last arga];instr:enlist .intcode.instrstr[ins];enlist cycle);
            queue:(queue except srcs),$[count srcs;distinct tgts;()];
        ];
        cycle-:1;
    ];
    /deps,:([]depFrom:queue; depTo:enlist each queue[;0],\:-1;val:.intcode.trace[0;4;queue[;0]];instr:"initial state of [",/:string[queue[;0]],\:"]");
    deps,:([]depFrom:queue; depTo:count[queue]#enlist();val:.intcode.trace[0;4;queue[;0]];instr:"initial state of [",/:string[queue[;0]],\:"]";cycle:0);
    deps};

.intcode.renderLineage:{[addr;cycle0]
    /addr:754; cycle0:20342
    /lineage0:1!update enlist each instr from .intcode.getLineage[addr;cycle0]
    lineage0:.intcode.getLineage[addr;cycle0];
    lineage:1!select depFrom, depTo,data:enlist each enlist'[0;depFrom[;0];cycle;(instr,'" = ",/:string[val])] from lineage0;
    leaf:()!();
    while[1b;
        leaf,:exec depFrom!data from lineage where 0=count each depTo;
        if[0=count lineage[(addr;cycle0);`depTo]; :lineage[(addr;cycle0);`data]];
        lineage:delete from lineage where 0=count each depTo;
        lineage:update ndepTo:depTo except\:key leaf from lineage;
        /lineage:update instr:((instr),'" ",/:/:raze each {x iasc count each x}each leaf@/:depTo inter\:key leaf) from lineage where 0=count each ndepTo;
        lineage:update data:(data,'.[;(::;::;0);+;1]raze each {x iasc count each x}each leaf@/:depTo) from lineage where 0=count each ndepTo;
        lineage:delete ndepTo from (update depTo:ndepTo from lineage where 0=count each ndepTo);
    ];
    };
