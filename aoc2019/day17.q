{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    system"l ",path,"/intcode.q";
    }[];

d17p1:{a:"J"$","vs x;
    r:("\n"vs`char$intcode[a;()])except enlist"";
    -1 r;
    r1:"#"=".",/:-1_/:r;
    r2:"#"=(1_/:r),\:".";
    r3:"#"=(1_r),enlist count[first r]#".";
    r4:"#"=enlist[count[first r]#"."],(-1_r);
    cr:all("#"=r;r1;r2;r3;r4);
    sum(*).'raze til[count cr],/:'where each cr};

d17p2:{a:"J"$","vs x;
    a[0]:2;
    r:("\n"vs`char$.intcode.out a:intcode[a;()])except enlist"";
    botPos:first raze til[count r],/:'where each r in "^><v";
    botDir:"^>v<"?r . botPos;
    visited:(0#0b)r;
    visited[botPos 0;botPos 1]:1b;
    path:();
    dirs:(-1 0;0 1;1 0;0 -1);
    run:1b;
    while[run;
        move:0;
        nxt:botPos+dirs botDir;
        while["#"=r . nxt;
            move+:1;
            botPos:nxt;
            visited[nxt 0;nxt 1]:1b;
            nxt:botPos+dirs botDir;
        ];
        if[0<move;
            path,:enlist string move;
        ];
        -1 .[r;botPos;:;"*"];
        nxts:botPos+/:dirs;
        nxts:nxts where "#"=r ./:nxts;
        nxts:nxts where not visited ./:nxts;
        if[0=count nxts; run:0b];
        if[run;
            nxt:first nxts;
            nxtDir:dirs?nxt-botPos;
            turn:(nxtDir-botDir)mod 4;
            $[turn=1; [path,:enlist enlist"R";botDir:(botDir+1)mod 4];
              turn in 2 3; [path,:enlist enlist"L";botDir:(botDir-1)mod 4];
              '"stuck"];
        ];
    ];
    findAbc:{[prefixes;path]
        if[0=count path; :enlist prefixes];
        if[path~enlist""; :enlist prefixes];
        cpath:","sv path;
        match:where prefixes~'(count each prefixes)#\:cpath;
        res:raze .z.s[prefixes] each ","vs/:(1+count each prefixes)[match]_\:cpath;
        if[3>count prefixes;
            poss:({x where 20>=count each x}{x,",",y}\[first path;1_path])except prefixes;
            res,:raze .z.s[;path] each prefixes,/:enlist each poss;
        ];
        res};
    abcs:findAbc[();path];
    if[0=count abcs; '"no ABC found?!"];
    abc:first abcs;
    pa:abc[0];
    pb:abc[1];
    pc:abc[2];
    pg:ssr[;pa;"A"]ssr[;pb;"B"]ssr[;pc;"C"]","sv path;
    -1 allInput:"\n"sv(pg;pa;pb;pc;enlist"n";"");
    //-1 " "sv string `long$allInput;
    r:intcode[a;`long$allInput];
    last r};

d17p1whitebox:{
    a:"J"$","vs x;
    r:a[935] cut".#"(where 1182_(first a[11 12]except 0 1)#a)mod 2;
    //rest same as regular part1
    r1:"#"=".",/:-1_/:r;
    r2:"#"=(1_/:r),\:".";
    r3:"#"=(1_r),enlist count[first r]#".";
    r4:"#"=enlist[count[first r]#"."],(-1_r);
    cr:all("#"=r;r1;r2;r3;r4);
    sum(*).'raze til[count cr],/:'where each cr};

d17p2whitebox:{
    a:"J"$","vs x;
    w:a[935];
    cend:(first a[11 12]except 0 1);
    r:w cut(where 1182_cend#a)mod 2;
    tilePos:raze til[count r],/:'where each r;
    cx:tilePos[;1];
    cy:tilePos[;0];
    sum(1+cend+cx+cy*w+cx)+til count tilePos};

.d17.test:{
    x:"1,330,331,332,109,4928,1102,1182,1,16,1101,0,1483,24,101,0,0,570,1006,570,36,102,1,571,0,1001,570,-1,570,1001,24,1,24,1106,0,18,1008,571,0,571,1001,16,1,16,1008,16,1483,570,1006,570,14,21101,58,0,0,1106,0,786,1006,332,62,99,21102,1,333,1,21102,1,73,0,1106,0,579,1101,0,0,572,1102,0,1,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,1002,574,1,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1105,1,81,21101,340,0,1,1106,0,177,21102,1,477,1,1106,0,177,21101,514,0,1,21101,0,176,0,1105,1,579,99,21101,184,0,0,1105,1,579,4,574,104,10,99,1007,573,22,570,1006,570,165,102,1,572,1182,21102,1,375,1,21101,0,211,0,1106,0,579,21101,1182,11,1,21102,222,1,0,1105,1,979,21102,1,388,1,21102,233,1,0,1105,1,579,21101,1182,22,1,21101,0,244,0,1106,0,979,21102,1,401,1,21102,255,1,0,1105,1,579,21101,1182,33,1,21101,0,266,0,1106,0,979,21101,0,414,1,21101,277,0,0,1105,1,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,0,1182,1,21101,313,0,0,1105,1,622,1005,575,327,1102,1,1,575,21101,327,0,0,1106,0,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,18,50,0,109,4,2101,0,-3,587,20102,1,0,-1,22101,1,-3,-3,21102,0,1,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1105,1,597,109,-4,2106,0,0,109,5,2102,1,-4,630,20102,1,0,-2,22101,1,-4,-4,21101,0,0,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,652,21001,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21102,702,1,0,1106,0,786,21201,-1,-1,-1,1106,0,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21101,731,0,0,1105,1,786,1105,1,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21101,0,756,0,1105,1,786,1105,1,774,21202,-1,-11,1,22101,1182,1,1,21101,774,0,0,1105,1,622,21201,-3,1,-3,1106,0,640,109,-5,2106,0,0,109,7,1005,575,802,20102,1,576,-6,20101,0,577,-5,1105,1,814,21101,0,0,-1,21101,0,0,-5,21101,0,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,53,-3,22201,-6,-3,-3,22101,1483,-3,-3,2101,0,-3,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21102,1,1,-1,1105,1,924,1205,-2,873,21102,35,1,-4,1106,0,924,1202,-3,1,878,1008,0,1,570,1006,570,916,1001,374,1,374,1201,-3,0,895,1102,2,1,0,2101,0,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,921,21001,0,0,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,53,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,65,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1101,0,1,575,21101,973,0,0,1105,1,786,99,109,-7,2105,1,0,109,6,21101,0,0,-4,21102,0,1,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1106,0,1041,21102,-4,1,-2,1106,0,1041,21102,1,-5,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,1202,-2,1,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,2102,1,-2,0,1106,0,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1106,0,989,21101,0,439,1,1106,0,1150,21101,477,0,1,1106,0,1150,21102,514,1,1,21102,1149,1,0,1105,1,579,99,21101,1157,0,0,1106,0,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,2102,1,-5,1176,2101,0,-4,0,109,-6,2105,1,0,14,7,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,9,50,1,1,1,50,11,44,1,7,1,44,1,7,1,44,1,7,1,44,1,7,1,44,1,7,1,34,11,7,1,34,1,17,1,34,1,17,1,34,1,17,1,34,1,17,9,26,1,25,1,26,1,25,1,26,1,25,1,24,9,19,1,24,1,1,1,5,1,19,1,14,13,5,1,19,1,14,1,9,1,7,1,19,1,14,1,9,1,7,1,19,1,14,1,9,1,7,1,19,1,14,1,9,1,7,1,19,1,3,12,9,1,7,1,19,1,3,1,9,12,7,1,19,11,3,1,18,1,23,1,5,1,3,1,18,11,13,1,5,1,3,1,28,1,13,1,5,1,3,1,28,1,11,13,28,1,11,1,1,1,5,1,32,1,1,13,5,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,5,13,32,1,1,1,5,1,3,1,40,13,42,1,5,1,34,13,5,1,52,1,52,1,52,1,52,1,52,1,42,11,42,1,52,1,52,1,52,1,52,1,52,1,52,1,52,1,26";
    show d17p1 x;
    show d17p2 x;
    show d17p1whitebox x;
    show d17p2whitebox x;
    };

//d17p1compare:{distinct (d17p1 x;d17p1whitebox x)};
//d17p2compare:{distinct (d17p2 x;d17p2whitebox x)};
//d17p2compare x:"1,330,331,332,109,4928,1102,1182,1,16,1101,0,1483,24,101,0,0,570,1006,570,36,102,1,571,0,1001,570,-1,570,1001,24,1,24,1106,0,18,1008,571,0,571,1001,16,1,16,1008,16,1483,570,1006,570,14,21101,58,0,0,1106,0,786,1006,332,62,99,21102,1,333,1,21102,1,73,0,1106,0,579,1101,0,0,572,1102,0,1,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,1002,574,1,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1105,1,81,21101,340,0,1,1106,0,177,21102,1,477,1,1106,0,177,21101,514,0,1,21101,0,176,0,1105,1,579,99,21101,184,0,0,1105,1,579,4,574,104,10,99,1007,573,22,570,1006,570,165,102,1,572,1182,21102,1,375,1,21101,0,211,0,1106,0,579,21101,1182,11,1,21102,222,1,0,1105,1,979,21102,1,388,1,21102,233,1,0,1105,1,579,21101,1182,22,1,21101,0,244,0,1106,0,979,21102,1,401,1,21102,255,1,0,1105,1,579,21101,1182,33,1,21101,0,266,0,1106,0,979,21101,0,414,1,21101,277,0,0,1105,1,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,0,1182,1,21101,313,0,0,1105,1,622,1005,575,327,1102,1,1,575,21101,327,0,0,1106,0,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,18,50,0,109,4,2101,0,-3,587,20102,1,0,-1,22101,1,-3,-3,21102,0,1,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1105,1,597,109,-4,2106,0,0,109,5,2102,1,-4,630,20102,1,0,-2,22101,1,-4,-4,21101,0,0,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,652,21001,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21102,702,1,0,1106,0,786,21201,-1,-1,-1,1106,0,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21101,731,0,0,1105,1,786,1105,1,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21101,0,756,0,1105,1,786,1105,1,774,21202,-1,-11,1,22101,1182,1,1,21101,774,0,0,1105,1,622,21201,-3,1,-3,1106,0,640,109,-5,2106,0,0,109,7,1005,575,802,20102,1,576,-6,20101,0,577,-5,1105,1,814,21101,0,0,-1,21101,0,0,-5,21101,0,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,53,-3,22201,-6,-3,-3,22101,1483,-3,-3,2101,0,-3,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21102,1,1,-1,1105,1,924,1205,-2,873,21102,35,1,-4,1106,0,924,1202,-3,1,878,1008,0,1,570,1006,570,916,1001,374,1,374,1201,-3,0,895,1102,2,1,0,2101,0,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,921,21001,0,0,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,53,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,65,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1101,0,1,575,21101,973,0,0,1105,1,786,99,109,-7,2105,1,0,109,6,21101,0,0,-4,21102,0,1,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1106,0,1041,21102,-4,1,-2,1106,0,1041,21102,1,-5,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,1202,-2,1,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,2102,1,-2,0,1106,0,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1106,0,989,21101,0,439,1,1106,0,1150,21101,477,0,1,1106,0,1150,21102,514,1,1,21102,1149,1,0,1105,1,579,99,21101,1157,0,0,1106,0,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,2102,1,-5,1176,2101,0,-4,0,109,-6,2105,1,0,14,7,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,1,5,1,46,9,50,1,1,1,50,11,44,1,7,1,44,1,7,1,44,1,7,1,44,1,7,1,44,1,7,1,34,11,7,1,34,1,17,1,34,1,17,1,34,1,17,1,34,1,17,9,26,1,25,1,26,1,25,1,26,1,25,1,24,9,19,1,24,1,1,1,5,1,19,1,14,13,5,1,19,1,14,1,9,1,7,1,19,1,14,1,9,1,7,1,19,1,14,1,9,1,7,1,19,1,14,1,9,1,7,1,19,1,3,12,9,1,7,1,19,1,3,1,9,12,7,1,19,11,3,1,18,1,23,1,5,1,3,1,18,11,13,1,5,1,3,1,28,1,13,1,5,1,3,1,28,1,11,13,28,1,11,1,1,1,5,1,32,1,1,13,5,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,9,1,7,1,32,1,1,1,5,13,32,1,1,1,5,1,3,1,40,13,42,1,5,1,34,13,5,1,52,1,52,1,52,1,52,1,52,1,42,11,42,1,52,1,52,1,52,1,52,1,52,1,52,1,52,1,26"
//d17p2compare x:"1,330,331,332,109,3448,1101,0,1182,16,1101,0,1439,24,101,0,0,570,1006,570,36,102,1,571,0,1001,570,-1,570,1001,24,1,24,1105,1,18,1008,571,0,571,1001,16,1,16,1008,16,1439,570,1006,570,14,21102,58,1,0,1105,1,786,1006,332,62,99,21102,1,333,1,21101,73,0,0,1106,0,579,1102,1,0,572,1102,1,0,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,1002,574,1,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1105,1,81,21102,340,1,1,1105,1,177,21101,0,477,1,1105,1,177,21102,514,1,1,21102,176,1,0,1105,1,579,99,21101,184,0,0,1106,0,579,4,574,104,10,99,1007,573,22,570,1006,570,165,101,0,572,1182,21101,0,375,1,21101,0,211,0,1105,1,579,21101,1182,11,1,21102,1,222,0,1106,0,979,21102,1,388,1,21101,233,0,0,1106,0,579,21101,1182,22,1,21101,244,0,0,1105,1,979,21102,401,1,1,21102,255,1,0,1106,0,579,21101,1182,33,1,21101,266,0,0,1105,1,979,21102,1,414,1,21101,277,0,0,1105,1,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,0,1182,1,21102,1,313,0,1105,1,622,1005,575,327,1101,0,1,575,21102,327,1,0,1106,0,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,40,18,0,109,4,2101,0,-3,587,20101,0,0,-1,22101,1,-3,-3,21101,0,0,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1105,1,597,109,-4,2105,1,0,109,5,1201,-4,0,629,21002,0,1,-2,22101,1,-4,-4,21101,0,0,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,653,20101,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21102,1,702,0,1106,0,786,21201,-1,-1,-1,1105,1,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21102,1,731,0,1106,0,786,1105,1,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21101,0,756,0,1105,1,786,1106,0,774,21202,-1,-11,1,22101,1182,1,1,21101,0,774,0,1106,0,622,21201,-3,1,-3,1105,1,640,109,-5,2105,1,0,109,7,1005,575,802,20101,0,576,-6,20101,0,577,-5,1106,0,814,21101,0,0,-1,21101,0,0,-5,21101,0,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,41,-3,22201,-6,-3,-3,22101,1439,-3,-3,1201,-3,0,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21101,1,0,-1,1106,0,924,1205,-2,873,21102,1,35,-4,1106,0,924,2102,1,-3,878,1008,0,1,570,1006,570,916,1001,374,1,374,1202,-3,1,895,1102,1,2,0,2101,0,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,922,20102,1,0,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,41,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,49,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1102,1,1,575,21101,973,0,0,1105,1,786,99,109,-7,2106,0,0,109,6,21102,0,1,-4,21102,0,1,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1106,0,1041,21101,0,-4,-2,1105,1,1041,21101,-5,0,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,2101,0,-2,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,2101,0,-2,0,1105,1,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1106,0,989,21101,439,0,1,1106,0,1150,21101,0,477,1,1106,0,1150,21101,0,514,1,21101,1149,0,0,1105,1,579,99,21102,1157,1,0,1106,0,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,2102,1,-5,1176,1201,-4,0,0,109,-6,2106,0,0,0,7,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,23,5,6,1,5,1,23,1,3,1,6,1,5,1,23,1,3,1,6,1,5,1,23,1,3,1,6,11,17,11,8,1,3,1,17,1,1,1,3,1,3,1,8,7,11,7,3,1,3,1,12,1,1,1,11,1,3,1,5,1,3,1,12,1,1,1,11,1,3,1,5,1,3,1,12,1,1,1,11,1,3,1,5,1,3,1,12,7,7,1,1,13,14,1,3,1,7,1,1,1,1,1,5,1,18,13,1,1,1,1,5,7,16,1,9,1,1,1,28,1,5,7,28,1,5,1,3,1,30,1,3,7,30,1,3,1,1,1,34,1,3,1,1,1,34,1,3,1,1,1,28,13,28,1,5,1,3,1,30,1,5,5,30,1,40,7,40,1,40,1,1,1,38,1,1,1,38,1,1,1,38,1,1,1,38,7,36,1,3,1,36,11,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,1,5,1,34,7,12"
//d17p2compare x:"1,330,331,332,109,2780,1102,1,1182,16,1102,1417,1,24,101,0,0,570,1006,570,36,101,0,571,0,1001,570,-1,570,1001,24,1,24,1105,1,18,1008,571,0,571,1001,16,1,16,1008,16,1417,570,1006,570,14,21101,58,0,0,1105,1,786,1006,332,62,99,21102,333,1,1,21101,73,0,0,1106,0,579,1101,0,0,572,1101,0,0,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,102,1,574,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1106,0,81,21102,340,1,1,1106,0,177,21102,1,477,1,1106,0,177,21102,514,1,1,21101,0,176,0,1106,0,579,99,21101,184,0,0,1106,0,579,4,574,104,10,99,1007,573,22,570,1006,570,165,102,1,572,1182,21101,375,0,1,21101,211,0,0,1105,1,579,21101,1182,11,1,21102,222,1,0,1105,1,979,21101,0,388,1,21102,233,1,0,1106,0,579,21101,1182,22,1,21102,244,1,0,1105,1,979,21101,0,401,1,21102,1,255,0,1106,0,579,21101,1182,33,1,21101,0,266,0,1105,1,979,21101,0,414,1,21102,1,277,0,1105,1,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,0,1182,1,21101,313,0,0,1105,1,622,1005,575,327,1101,1,0,575,21101,327,0,0,1106,0,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,20,18,0,109,4,2102,1,-3,587,20102,1,0,-1,22101,1,-3,-3,21101,0,0,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1106,0,597,109,-4,2105,1,0,109,5,1202,-4,1,629,21002,0,1,-2,22101,1,-4,-4,21102,0,1,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,653,20102,1,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21101,0,702,0,1105,1,786,21201,-1,-1,-1,1105,1,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21102,1,731,0,1106,0,786,1106,0,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21101,0,756,0,1106,0,786,1106,0,774,21202,-1,-11,1,22101,1182,1,1,21101,0,774,0,1106,0,622,21201,-3,1,-3,1105,1,640,109,-5,2105,1,0,109,7,1005,575,802,21002,576,1,-6,20101,0,577,-5,1106,0,814,21102,1,0,-1,21101,0,0,-5,21101,0,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,47,-3,22201,-6,-3,-3,22101,1417,-3,-3,2102,1,-3,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21101,1,0,-1,1105,1,924,1205,-2,873,21102,35,1,-4,1106,0,924,1201,-3,0,878,1008,0,1,570,1006,570,916,1001,374,1,374,1201,-3,0,895,1102,2,1,0,2102,1,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,922,20102,1,0,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,47,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,29,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1101,0,1,575,21102,973,1,0,1105,1,786,99,109,-7,2105,1,0,109,6,21101,0,0,-4,21102,1,0,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1106,0,1041,21101,0,-4,-2,1105,1,1041,21101,-5,0,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,2102,1,-2,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,2101,0,-2,0,1106,0,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1105,1,989,21101,439,0,1,1105,1,1150,21101,477,0,1,1106,0,1150,21101,0,514,1,21101,1149,0,0,1106,0,579,99,21101,1157,0,0,1106,0,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,1201,-5,0,1176,1202,-4,1,0,109,-6,2106,0,0,36,5,42,1,3,1,42,1,3,1,42,1,3,1,6,5,23,13,6,1,3,1,23,1,7,1,10,1,3,1,23,1,7,1,10,1,3,1,23,1,7,1,10,13,13,5,5,1,14,1,7,1,13,1,1,1,1,1,5,1,14,1,7,1,13,1,1,1,1,1,1,11,8,1,7,1,13,1,1,1,1,1,1,1,3,1,5,1,8,1,7,1,13,1,1,1,1,7,5,1,8,1,7,1,13,1,1,1,3,1,9,1,8,1,3,5,13,1,1,7,7,1,8,1,3,1,17,1,5,1,1,1,7,1,8,13,9,1,1,5,1,1,7,1,12,1,7,1,9,1,1,1,5,1,7,1,12,13,5,1,1,1,5,13,16,1,9,1,1,1,13,1,3,1,12,5,5,5,1,1,13,1,3,1,12,1,9,1,5,1,13,1,3,1,12,1,9,1,5,1,13,5,12,1,9,1,5,1,30,1,5,7,3,1,30,1,9,1,1,1,3,1,30,11,1,1,3,1,42,1,3,1,42,5,18"
//d17p2compare x:"1,330,331,332,109,3762,1101,1182,0,16,1101,0,1467,24,101,0,0,570,1006,570,36,101,0,571,0,1001,570,-1,570,1001,24,1,24,1105,1,18,1008,571,0,571,1001,16,1,16,1008,16,1467,570,1006,570,14,21102,58,1,0,1105,1,786,1006,332,62,99,21101,0,333,1,21102,1,73,0,1106,0,579,1101,0,0,572,1102,1,0,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,102,1,574,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1106,0,81,21101,0,340,1,1106,0,177,21102,477,1,1,1105,1,177,21101,0,514,1,21102,1,176,0,1106,0,579,99,21102,1,184,0,1105,1,579,4,574,104,10,99,1007,573,22,570,1006,570,165,101,0,572,1182,21101,0,375,1,21102,1,211,0,1106,0,579,21101,1182,11,1,21101,0,222,0,1106,0,979,21102,388,1,1,21101,0,233,0,1105,1,579,21101,1182,22,1,21102,1,244,0,1105,1,979,21101,401,0,1,21101,0,255,0,1105,1,579,21101,1182,33,1,21101,266,0,0,1105,1,979,21101,0,414,1,21101,277,0,0,1105,1,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,1182,0,1,21102,1,313,0,1105,1,622,1005,575,327,1101,0,1,575,21102,1,327,0,1105,1,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,0,8,0,109,4,2102,1,-3,587,20102,1,0,-1,22101,1,-3,-3,21101,0,0,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1105,1,597,109,-4,2105,1,0,109,5,1201,-4,0,630,20102,1,0,-2,22101,1,-4,-4,21101,0,0,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,653,20101,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21102,702,1,0,1105,1,786,21201,-1,-1,-1,1106,0,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21102,1,731,0,1106,0,786,1105,1,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21101,0,756,0,1105,1,786,1105,1,774,21202,-1,-11,1,22101,1182,1,1,21102,1,774,0,1106,0,622,21201,-3,1,-3,1106,0,640,109,-5,2105,1,0,109,7,1005,575,802,20101,0,576,-6,20101,0,577,-5,1106,0,814,21102,0,1,-1,21101,0,0,-5,21101,0,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,45,-3,22201,-6,-3,-3,22101,1467,-3,-3,1202,-3,1,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21101,1,0,-1,1106,0,924,1205,-2,873,21101,35,0,-4,1106,0,924,1201,-3,0,878,1008,0,1,570,1006,570,916,1001,374,1,374,1201,-3,0,895,1102,1,2,0,2102,1,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,921,21002,0,1,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,45,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,51,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1102,1,1,575,21101,973,0,0,1105,1,786,99,109,-7,2106,0,0,109,6,21102,1,0,-4,21102,0,1,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1105,1,1041,21101,-4,0,-2,1106,0,1041,21101,0,-5,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,2101,0,-2,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,2101,0,-2,0,1106,0,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1105,1,989,21101,0,439,1,1106,0,1150,21102,1,477,1,1106,0,1150,21102,514,1,1,21102,1149,1,0,1105,1,579,99,21102,1157,1,0,1105,1,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,1201,-5,0,1176,2101,0,-4,0,109,-6,2105,1,0,12,13,32,1,11,1,32,1,5,9,30,1,5,1,5,1,1,1,30,1,5,1,5,1,1,1,30,1,5,1,5,1,1,1,30,1,5,1,5,1,1,1,30,1,5,1,5,1,1,1,18,13,5,7,1,1,44,1,44,1,44,1,44,1,1,1,42,1,1,1,42,9,38,1,5,1,38,1,5,1,38,1,5,1,38,1,5,1,38,1,5,1,36,7,1,1,36,1,1,1,3,1,1,1,36,1,1,1,3,1,1,1,36,1,1,1,3,1,1,1,36,1,1,9,34,1,5,1,1,1,1,1,34,9,1,1,40,1,3,1,32,9,3,1,32,1,11,1,32,1,11,1,1,7,24,1,11,1,1,1,5,1,16,5,3,1,11,1,1,1,5,1,16,1,3,1,3,1,11,1,1,1,5,1,16,1,3,1,3,1,9,9,1,1,16,1,3,1,3,1,9,1,1,1,1,1,3,1,1,1,16,9,9,1,1,9,20,1,13,1,3,1,3,1,22,1,13,1,3,5,22,1,13,1,30,9,5,1,38,1,5,1,36,9,36,1,1,1,40,9,36,1,1,1,1,1,3,1,36,1,1,1,1,1,3,1,36,1,1,1,1,1,3,1,36,5,3,1,38,1,5,1,38,7,12"
//d17p2compare x:"1,330,331,332,109,5242,1101,1182,0,16,1102,1521,1,24,102,1,0,570,1006,570,36,102,1,571,0,1001,570,-1,570,1001,24,1,24,1106,0,18,1008,571,0,571,1001,16,1,16,1008,16,1521,570,1006,570,14,21101,0,58,0,1105,1,786,1006,332,62,99,21102,333,1,1,21101,73,0,0,1106,0,579,1101,0,0,572,1102,0,1,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,101,0,574,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1105,1,81,21102,340,1,1,1106,0,177,21101,0,477,1,1106,0,177,21102,1,514,1,21102,176,1,0,1105,1,579,99,21102,184,1,0,1106,0,579,4,574,104,10,99,1007,573,22,570,1006,570,165,102,1,572,1182,21101,375,0,1,21101,0,211,0,1105,1,579,21101,1182,11,1,21102,222,1,0,1106,0,979,21102,1,388,1,21102,1,233,0,1106,0,579,21101,1182,22,1,21101,244,0,0,1106,0,979,21101,0,401,1,21102,255,1,0,1105,1,579,21101,1182,33,1,21101,0,266,0,1106,0,979,21102,1,414,1,21102,277,1,0,1106,0,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,1182,0,1,21101,313,0,0,1105,1,622,1005,575,327,1101,1,0,575,21102,327,1,0,1106,0,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,60,24,0,109,4,2101,0,-3,586,21002,0,1,-1,22101,1,-3,-3,21102,1,0,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1105,1,597,109,-4,2105,1,0,109,5,2101,0,-4,629,21002,0,1,-2,22101,1,-4,-4,21102,1,0,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,653,20101,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21102,1,702,0,1106,0,786,21201,-1,-1,-1,1106,0,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21101,731,0,0,1106,0,786,1105,1,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21101,756,0,0,1105,1,786,1106,0,774,21202,-1,-11,1,22101,1182,1,1,21102,774,1,0,1106,0,622,21201,-3,1,-3,1106,0,640,109,-5,2105,1,0,109,7,1005,575,802,20101,0,576,-6,21002,577,1,-5,1105,1,814,21101,0,0,-1,21101,0,0,-5,21102,0,1,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,61,-3,22201,-6,-3,-3,22101,1521,-3,-3,2101,0,-3,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21102,1,1,-1,1106,0,924,1205,-2,873,21102,35,1,-4,1106,0,924,2102,1,-3,878,1008,0,1,570,1006,570,916,1001,374,1,374,2101,0,-3,895,1101,2,0,0,2101,0,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,922,20101,0,0,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,61,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,61,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1101,0,1,575,21102,1,973,0,1106,0,786,99,109,-7,2105,1,0,109,6,21101,0,0,-4,21102,0,1,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1106,0,1041,21101,-4,0,-2,1106,0,1041,21101,-5,0,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,2101,0,-2,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,1201,-2,0,0,1105,1,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1106,0,989,21101,439,0,1,1105,1,1150,21102,1,477,1,1106,0,1150,21102,1,514,1,21101,1149,0,0,1106,0,579,99,21101,1157,0,0,1105,1,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,2101,0,-5,1176,1202,-4,1,0,109,-6,2105,1,0,24,13,48,1,11,1,48,1,11,1,48,1,11,1,48,1,3,13,44,1,3,1,7,1,3,1,44,1,3,1,7,1,3,1,44,1,3,1,7,1,3,1,44,1,3,1,7,7,42,1,3,1,11,1,1,1,40,7,11,7,36,1,1,1,17,1,3,1,30,9,17,1,3,1,30,1,5,1,19,1,3,1,30,1,5,1,19,1,3,1,30,1,5,1,19,1,3,1,30,1,5,1,19,7,28,1,5,1,23,1,1,1,28,1,5,1,23,13,18,1,5,1,25,1,9,1,18,1,5,1,25,1,9,1,18,1,5,1,25,1,9,1,16,9,25,1,9,1,16,1,1,1,31,1,9,1,10,9,31,13,8,1,5,1,43,1,10,1,5,1,43,1,10,1,5,1,43,1,10,1,5,1,43,1,10,1,5,1,43,1,2,9,5,1,35,9,2,1,13,1,35,1,10,1,13,1,35,1,10,1,13,1,35,1,10,1,13,13,23,1,10,1,25,1,23,1,10,13,13,1,23,1,22,1,13,1,23,1,22,1,13,1,23,1,22,1,13,1,23,1,22,1,13,1,23,1,22,1,13,1,23,1,22,1,13,1,17,7,22,1,31,1,28,7,25,1,34,1,25,1,34,1,25,1,34,1,25,1,34,1,17,9,34,1,17,1,42,1,17,1,42,1,17,1,42,7,11,1,48,1,11,1,48,1,11,1,48,1,11,1,48,1,11,1,48,1,11,1,48,1,11,1,48,1,11,1,48,13,24"

/
OVERVIEW:

PART 1:
We shift the matrix in all 4 directions (and add empty space to fill it up) then take the
intersection of all five versions to find the intersections in the path. Then we find
the coordinates of the intersections and do the required operations on them.

PART 2:
This consists of two sub-parts. First we construct the program to trace the
entire path. This requires a while loop, where we first move forward as far as we
can, then check if it's possible to turn to a square that we haven't visited. Once
there is no such square the program is complete.
Then we find the combination of A,B,C that can be used to make the master program.
We use a recursive function for this. The function takes the candidate prefixes and
the remaining path. If the path is empty, we return the candidate prefixes as a valid
solution. Otherwise we try to do two things: 1) check if the candidate prefixes match
the beginning of the path, and if they do, recurse with the remaining path, 2) if
there are still open candidate prefix slots remaining (i.e. we have less than 3),
generate a list of new potential candidate prefixes up to length 20 and recurse with
each in turn added to the candidate prefix list.
Finally we feed the 4 programs into the intcode program and return the last output.

WHITEBOXING:

Part 1:
The map is stored in the code with run-length encoding. There is a list of numbers and
each number describes how many tiles of the same state follow, starting with space tiles
(if the top left tile is a platform tile, there is a zero in the encoding to indicate
the initial sequence of zero space tiles).

We split the encoding out of the code:
q)1182_(first a[11 12]except 0 1)#a
0 7 34 1 5 1 34 1 5 1 34 1 5 1 34 1 5..

q has a nuke that we can use to expand the run length encoding. Although it is not often
used for this purpose, the "where" function actually repeats every index as many times
as the value of the respective element of the list. For boolean values this results
in the familiar "return the true indices" behavior, however it works just as well on
integers, such as this RLE scenario, creating sequences of the given lengths:
q)where 1182_(first a[11 12]except 0 1)#a
1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 4 4 4 4 4 5 6 6..

Now we only need to fix the values. Since we know they alternate between space and
platform, we can modulo by 2:
q)(where 1182_(first a[11 12]except 0 1)#a)mod 2
1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 ..

And use list indexing to map these to the corresponding ASCII characters:
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0..
q)".#"(where 1182_(first a[11 12]except 0 1)#a)mod 2
"#######..................................#.....#.......................

Then we need to cut this string into a rectangle, looking up the width from the code:
q)r:a[935] cut".#"(where 1182_(first a[11 12]except 0 1)#a)mod 2;
q)r
"#######.................................."
"#.....#.................................."
"#.....#.................................."
"#.....#.................................."
..

From here the solution proceeds like regular part 1.

Part 2:
This is more interesting as we can completely bypass the requirement to program the
robot by generating the score (the "dust counter") directly.
It turns out that the score is composed of multiple values added together:
- The offset in memory of where the tile is found (after the code decodes the RLE).
This is always found at the end of the RLE, in row major order, so the value is
(y*w)+x.
- The x and y coordinates multiplied together plus one.
- A running counter starting at 0.
This is only how the code does it, of course in q we can use a closed vector formula.
After getting all the tile positions can use the following:
q)cx:tilePos[;1];
q)cy:tilePos[;0];
q)sum(1+cend+cx+cy*w+cx)+til count path
