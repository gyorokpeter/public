d22p1:{
    map:"#"=trim each "\n"vs x;
    mpdt:{[mpdt]
        if[mpdt[1;0]=-1; mpdt[1;0]:0; mpdt[0]:(enlist count[first mpdt[0]]#0b),mpdt[0]];
        if[mpdt[1;1]=-1; mpdt[1;1]:0; mpdt[0]:0b,/:mpdt[0]];
        if[mpdt[1;0]>=count mpdt[0]; mpdt[0]:mpdt[0],(enlist count[first mpdt[0]]#0b)];
        if[mpdt[1;1]>=count first mpdt[0]; mpdt[0]:mpdt[0],\:0b];
        mpdt[2]:(mpdt[2]+-1+2*mpdt[0]. mpdt[1])mod 4;
        mpdt[0;mpdt[1;0];mpdt[1;1]]:not mpdt[0;mpdt[1;0];mpdt[1;1]];
        mpdt[3]+:mpdt[0;mpdt[1;0];mpdt[1;1]];
        mpdt[1]+:(-1 0;0 1;1 0;0 -1)mpdt 2;
        mpdt
    }/[10000;(map;2#count[map]div 2;0;0)];
    mpdt 3};

d22p1 "..#\n#..\n...";  //5587

d22p2:{
    map:trim each "\n"vs x;
    mpdt:{[mpdt]
        if[mpdt[1;0]=-1; mpdt[1;0]:0; mpdt[0]:(enlist count[first mpdt[0]]#"."),mpdt[0]];
        if[mpdt[1;1]=-1; mpdt[1;1]:0; mpdt[0]:".",/:mpdt[0]];
        if[mpdt[1;0]>=count mpdt[0]; mpdt[0]:mpdt[0],(enlist count[first mpdt[0]]#".")];
        if[mpdt[1;1]>=count first mpdt[0]; mpdt[0]:mpdt[0],\:"."];
        mpdt[2]:(mpdt[2]+(".W#F"!-1 0 1 2)mpdt[0]. mpdt[1])mod 4;
        mpdt[0;mpdt[1;0];mpdt[1;1]]:(".W#F"!"W#F.")mpdt[0;mpdt[1;0];mpdt[1;1]];
        mpdt[3]+:"#"=mpdt[0;mpdt[1;0];mpdt[1;1]];
        mpdt[1]+:(-1 0;0 1;1 0;0 -1)mpdt 2;
        mpdt
    }/[10000000;(map;2#count[map]div 2;0;0)];
    mpdt 3};

d22p2 "..#\n#..\n..."  //2511944
