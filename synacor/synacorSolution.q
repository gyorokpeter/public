{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `synacor in key`;
        system"l ",path,"/synacor.q";
    ];
    .synsolve.bin:read1`$":",path,"/challenge.bin";
    }[];

.synsolve.solutionPart1:("take tablet";
    "use tablet";
    "doorway";
    "north";
    "north";
    "bridge";
    "continue";
    "down";
    "east";
    "take empty lantern";
    "west";
    "west";
    "passage";
    "ladder";
    "west";
    "south";
    "north";
    "take can";
    "west";
    "ladder";
    "use can";
    "use lantern";
    "darkness";
    "continue";
    "west";
    "west";
    "west";
    "west";
    "north";
    "take red coin";
    "north";
    "west";
    "take blue coin";
    "up";
    "take shiny coin";
    "down";
    "east";
    "east";
    "take concave coin";
    "down";
    "take corroded coin";
    "up";
    "west";
    "use blue coin";
    "use red coin";
    "use shiny coin";
    "use concave coin";
    "use corroded coin";
    "north";
    "take teleporter";
    "use teleporter";
    "take business card";
    "take strange book");

.synsolve.solutionPart2:("use teleporter";
    "north";
    "north";
    "north";
    "north";
    "north";
    "north";
    "north";
    "east";
    "take journal";
    "west";
    "north";
    "north";
    "take orb";
    "north";
    "east";
    "east";
    "north";
    "west";
    "south";
    "east";
    "east";
    "west";
    "north";
    "north";
    "east";
    "vault";
    "take mirror";
    "use mirror");

.synsolve.tillCode1:{
    st:.synacor.new[.synsolve.bin];
    st:.synacor.addInput[st;"\n"sv 1#.synsolve.solutionPart1];
    st:.synacor.run[st];
    st:.synacor.clearOutput[st];
    st:.synacor.addInput[st;"\n"sv 1#1_.synsolve.solutionPart1];
    st:.synacor.run[st];
    -1 .synacor.getOutput st};

.synsolve.tillCode2:{
    st:.synacor.new[.synsolve.bin];
    st:.synacor.addInput[st;"\n"sv 16#.synsolve.solutionPart1];
    st:.synacor.run[st];
    st:.synacor.clearOutput[st];
    st:.synacor.addInput[st;"\n"sv 1#16_.synsolve.solutionPart1];
    st:.synacor.run[st];
    -1 .synacor.getOutput st};

.synsolve.tillCode3:{
    st:.synacor.new[.synsolve.bin];
    st:.synacor.addInput[st;"\n"sv -3_.synsolve.solutionPart1];
    st:.synacor.run[st];
    st:.synacor.clearOutput[st];
    st:.synacor.addInput[st;"\n"sv 1#-3#.synsolve.solutionPart1];
    st:.synacor.run[st];
    -1 .synacor.getOutput st};

.synsolve.tillCode4:{
    st:.synacor.new[.synsolve.bin];
    st:.synacor.addInput[st;"\n"sv .synsolve.solutionPart1];
    st:.synacor.run[st];
    st:.synacor.clearOutput[st];
    st:.synacor.editRegister[st;7;25734];
    st:.synacor.editMemory[st;5485;6];
    st:.synacor.editMemory[st;5489;21];
    st:.synacor.editMemory[st;5490;21];
    st:.synacor.addInput[st;"\n"sv 1#.synsolve.solutionPart2];
    st:.synacor.run[st];
    -1 .synacor.getOutput st};

.synsolve.tillCode5:{
    st:.synacor.new[.synsolve.bin];
    st:.synacor.addInput[st;"\n"sv .synsolve.solutionPart1];
    st:.synacor.run[st];
    st:.synacor.editRegister[st;7;25734];
    st:.synacor.editMemory[st;5485;6];
    st:.synacor.editMemory[st;5489;21];
    st:.synacor.editMemory[st;5490;21];
    st:.synacor.addInput[st;"\n"sv -1_.synsolve.solutionPart2];
    st:.synacor.run[st];
    st:.synacor.clearOutput[st];
    st:.synacor.addInput[st;"\n"sv -1#.synsolve.solutionPart2];
    st:.synacor.run[st];
    -1 .synacor.getOutput st};

.synsolve.solve:{
    st:.synacor.new[.synsolve.bin];
    st:.synacor.addInput[st;"\n"sv .synsolve.solutionPart1];
    st:.synacor.run[st];
    -1 .synacor.getOutput st;
    st:.synacor.editRegister[st;7;25734];
    st:.synacor.editMemory[st;5485;6];
    st:.synacor.editMemory[st;5489;21];
    st:.synacor.editMemory[st;5490;21];
    st:.synacor.addInput[st;"\n"sv .synsolve.solutionPart2];
    st:.synacor.run[st];
    -1 .synacor.getOutput st};

.synsolve.coinPuzzle:{
    first{x where 399={x[0]+(x[1]*x[2]*x[2])+(x[3]*x[3]*x[3])-x[4]}each x}{$[1>=count x; enlist x;raze x,/:'.z.s each x except/:x]}2 3 5 7 9};
//.synsolve.coinPuzzle[]    //9 2 5 7 3j

.synsolve.ackermann:{[p]
    nums:til 32768;
    a0:1 rotate nums;
    a1:(p+1) rotate nums;
    a2:((1+nums)+p*2+nums)mod 32768;
    a3:32768{[a2;a3p]a2[a3p]}[a2]\a2[p];
    a4:2{[a3;a4p]a3[a4p]}[a3]\a3[p];
    a4[1]};

.synsolve.teleporterPuzzle:{
    r:({[step;tofind;start;found]if[found;:(start;found)];ack:.synsolve.ackermann each (0N!start)+til step;if[tofind in ack;
        :(start+ack?tofind;1b)];(start+step;0b)}[100;6].)/[(0;0b)];
    r};

//.synsolve.teleporterPuzzle[]  //(25734j;1b) after running for 360 seconds

.synsolve.vault:
    ((*; 8; -; 1);
     (4; *; 11;*);
     (+; 4; -; 18);
     (22;-; 9; *));

.synsolve.vaultPuzzle:{
    queue:enlist`ci`cj`val!3 0 22;
    parent:enlist[0 3 22]!enlist 0N 0N 0N;
    while[0<count queue;
        if[0<count found:select from queue where ci=0, cj=3, val=30;
            end:value first found;
            path:reverse -1_parent\[end];
            :((-1 0;0 1;1 0;0 -1)!`north`east`south`west)1_deltas 2#/:path;
        ];
        nxts:ungroup update nci:ci+\:-1 0 1 0, ncj:cj+\:0 1 0 -1 from queue;
        nxts:delete from nxts where not[nci within 0 3] or not[ncj within 0 3];
        nxts:delete from nxts where nci=3,ncj=0;
        nxts:update nval:value each (string[val],'string .synsolve.vault'[nci;ncj]) from nxts;
        nxts:delete from nxts where nci=0,ncj=3, nval<>30;
        if[exec 7h=type nval from nxts;
            nxts:delete from nxts where nval<=0;
        ];
        nxts:delete from nxts where enlist'[nci;ncj;nval] in key parent;
        parent,:exec enlist'[nci;ncj;nval]!enlist'[ci;cj;val] from nxts;
        queue:select ci:nci, cj:ncj, val:nval from nxts;
    ];
    '"not found"};

//.synsolve.vaultPuzzle[]   `north`east`east`north`west`south`east`east`west`north`north`east after 20 seconds
