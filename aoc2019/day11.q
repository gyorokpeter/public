{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    system"l ",path,"/intcode.q";
    }[];

ocr:enlist[""]!enlist" ";
ocr[" **  *  * *  * **** *  * *  * "]:"A";
ocr["***  *  * ***  *  * *  * ***  "]:"B";
ocr[" **  *  * *    *    *  *  **  "]:"C";
ocr["**** *    ***  *    *    **** "]:"E";
ocr["**** *    ***  *    *    *    "]:"F";
ocr[" **  *  * *    * ** *  *  *** "]:"G";
ocr["*  * *  * **** *  * *  * *  * "]:"H";
ocr["  **    *    *    * *  *  **  "]:"J";
ocr["*  * * *  **   * *  * *  *  * "]:"K";
ocr["*    *    *    *    *    **** "]:"L";
ocr["***  *  * *  * ***  *    *    "]:"P";
ocr["***  *  * *  * ***  * *  *  * "]:"R";
ocr["*  * *  * *  * *  * *  *  **  "]:"U";
ocr["*   **   * * *   *    *    *  "]:"Y";
ocr["****    *   *   *   *    **** "]:"Z";

d11:{[x;st]
    a:"J"$","vs x;
    grid:enlist enlist st;
    cursor:0 0;
    dir:0;
    run:1b;
    path:();
    while[run;
        a:intcode[a;enlist grid . cursor];
        ins:last a;
        run:first[a]~`pause;
        if[run;
            path,:enlist cursor;
            grid:.[grid;cursor;:;first ins];
            dir:(dir+(2*last[ins])-1)mod 4;
            cursor+:(-1 0;0 1;1 0;0 -1)dir;
            if[cursor[0]<0; grid:(abs[cursor 0]#enlist count[first grid]#0),grid; path[;0]+:abs cursor[0];cursor[0]:0];
            if[cursor[0]>=count grid; grid:grid,(1+cursor[0]-count grid)#enlist count[first grid]#0];
            if[cursor[1]<0; grid:(abs[cursor 1]#0),/:grid; path[;1]+:abs cursor 1;cursor[1]:0];
            if[cursor[1]>=count first grid; grid:grid,\:(1+cursor[1]-count first grid)#0];
        ];
    ];
    (grid;count distinct path)};

d11p1:{last d11[x;0]};
d11p2:{grid:" *"first d11[x;1];
    grid:40#/:(min grid?\:"*")_/:grid;
    ocr raze each flip 5 cut/:grid};

d11p1whitebox:{
    a:"J"$","vs x;
    ind:where a in 108 1008;
    ind:-1_ind where a[ind+3]=10;
    compBuffer:raze a[ind+\:1 2]except\:8;
    ind:where a=1007;
    ind:ind where a[ind+\:1 3]~\:9 10;
    iter:a[first[ind]+2];
    grid:enlist enlist 0;
    cursor:0 0;
    dir:0;
    path:();
    do[1+10*iter;
        $[0=count path;
            out:1 0;
            [   
                input:grid . cursor;
                out:(1-input;compBuffer[0]=input);
                compBuffer:(1_compBuffer),input;
            ]
        ];
        path,:enlist cursor;
        grid:.[grid;cursor;:;first out];
        dir:(dir+(2*last[out])-1)mod 4;
        cursor+:(-1 0;0 1;1 0;0 -1)dir;
        if[cursor[0]<0; grid:(abs[cursor 0]#enlist count[first grid]#0),grid; path[;0]+:abs cursor[0];cursor[0]:0];
        if[cursor[0]>=count grid; grid:grid,(1+cursor[0]-count grid)#enlist count[first grid]#0];
        if[cursor[1]<0; grid:(abs[cursor 1]#0),/:grid; path[;1]+:abs cursor 1;cursor[1]:0];
        if[cursor[1]>=count first grid; grid:grid,\:(1+cursor[1]-count first grid)#0];
    ];
    count distinct path};

d11p2whitebox:{
    a:"J"$","vs x;
    ns:a where a>100000;
    seq1:raze each flip @[;(0 3;1 2)]each 4 cut raze -40#/:0b vs/:ns 0 1;
    seq2:raze each flip @[;(1 2;0 3)]each 4 cut reverse raze -40#/:0b vs/:ns 2 3;
    seq3:raze each flip @[;(0 3;1 2)]each 4 cut raze -40#/:0b vs/:ns 4 5;
    grid:" *"seq1,seq2,seq3;
    ocr raze each flip 5 cut/:grid};

//d11p1"3,8,1005,8,299,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,28,1006,0,85,1,106,14,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,58,1,1109,15,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,84,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,105,1006,0,48,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,130,1006,0,46,1,1001,17,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,160,2,109,20,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,185,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,207,1006,0,89,2,1002,6,10,1,1007,0,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,241,2,4,14,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,267,1,1107,8,10,1,109,16,10,2,1107,4,10,101,1,9,9,1007,9,1003,10,1005,10,15,99,109,621,104,0,104,1,21101,0,387239486208,1,21102,316,1,0,1106,0,420,21101,0,936994976664,1,21102,327,1,0,1105,1,420,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,29192457307,1,21102,1,374,0,1106,0,420,21101,0,3450965211,1,21101,0,385,0,1106,0,420,3,10,104,0,104,0,3,10,104,0,104,0,21102,1,837901103972,1,21101,408,0,0,1106,0,420,21102,867965752164,1,1,21101,0,419,0,1105,1,420,99,109,2,22102,1,-1,1,21102,40,1,2,21102,451,1,3,21102,1,441,0,1106,0,484,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,446,447,462,4,0,1001,446,1,446,108,4,446,10,1006,10,478,1102,0,1,446,109,-2,2105,1,0,0,109,4,1201,-1,0,483,1207,-3,0,10,1006,10,501,21101,0,0,-3,22101,0,-3,1,22102,1,-2,2,21101,1,0,3,21101,520,0,0,1106,0,525,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,548,2207,-4,-2,10,1006,10,548,21201,-4,0,-4,1105,1,616,22101,0,-4,1,21201,-3,-1,2,21202,-2,2,3,21101,0,567,0,1106,0,525,22101,0,1,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,586,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,608,21202,-1,1,1,21102,608,1,0,106,0,483,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0"

//d11p1compare:{distinct (d11p1 x;d11p1whitebox x)};
//d11p2compare:{distinct (d11p2 x;d11p2whitebox x)};
//d11p2compare x:"3,8,1005,8,299,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,28,1006,0,85,1,106,14,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,58,1,1109,15,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,84,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,105,1006,0,48,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,130,1006,0,46,1,1001,17,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,160,2,109,20,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,185,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,207,1006,0,89,2,1002,6,10,1,1007,0,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,241,2,4,14,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,267,1,1107,8,10,1,109,16,10,2,1107,4,10,101,1,9,9,1007,9,1003,10,1005,10,15,99,109,621,104,0,104,1,21101,0,387239486208,1,21102,316,1,0,1106,0,420,21101,0,936994976664,1,21102,327,1,0,1105,1,420,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,29192457307,1,21102,1,374,0,1106,0,420,21101,0,3450965211,1,21101,0,385,0,1106,0,420,3,10,104,0,104,0,3,10,104,0,104,0,21102,1,837901103972,1,21101,408,0,0,1106,0,420,21102,867965752164,1,1,21101,0,419,0,1105,1,420,99,109,2,22102,1,-1,1,21102,40,1,2,21102,451,1,3,21102,1,441,0,1106,0,484,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,446,447,462,4,0,1001,446,1,446,108,4,446,10,1006,10,478,1102,0,1,446,109,-2,2105,1,0,0,109,4,1201,-1,0,483,1207,-3,0,10,1006,10,501,21101,0,0,-3,22101,0,-3,1,22102,1,-2,2,21101,1,0,3,21101,520,0,0,1106,0,525,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,548,2207,-4,-2,10,1006,10,548,21201,-4,0,-4,1105,1,616,22101,0,-4,1,21201,-3,-1,2,21202,-2,2,3,21101,0,567,0,1106,0,525,22101,0,1,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,586,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,608,21202,-1,1,1,21102,608,1,0,106,0,483,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0"
//d11p2compare x:"3,8,1005,8,326,1106,0,11,0,0,0,104,1,104,0,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,28,2,1104,14,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,55,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1001,8,0,77,2,103,7,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,0,8,10,4,10,102,1,8,102,1006,0,76,1,6,5,10,1,1107,3,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,135,1,1002,8,10,2,1101,3,10,1006,0,97,1,101,0,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,172,1006,0,77,1006,0,11,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,201,1006,0,95,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1002,8,1,226,2,3,16,10,1,6,4,10,1006,0,23,1006,0,96,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,261,1,3,6,10,2,1006,3,10,1006,0,78,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,101,0,8,295,1006,0,89,1,108,12,10,2,103,11,10,101,1,9,9,1007,9,1057,10,1005,10,15,99,109,648,104,0,104,1,21102,1,838365918100,1,21102,343,1,0,1106,0,447,21102,387365315476,1,1,21102,354,1,0,1106,0,447,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,0,179318254811,1,21102,401,1,0,1106,0,447,21102,1,97911876839,1,21101,0,412,0,1106,0,447,3,10,104,0,104,0,3,10,104,0,104,0,21101,838345577320,0,1,21101,435,0,0,1106,0,447,21102,1,838337188628,1,21101,0,446,0,1105,1,447,99,109,2,21202,-1,1,1,21101,40,0,2,21102,478,1,3,21101,0,468,0,1106,0,511,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,473,474,489,4,0,1001,473,1,473,108,4,473,10,1006,10,505,1102,1,0,473,109,-2,2106,0,0,0,109,4,2102,1,-1,510,1207,-3,0,10,1006,10,528,21101,0,0,-3,21202,-3,1,1,22101,0,-2,2,21101,1,0,3,21102,1,547,0,1106,0,552,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,575,2207,-4,-2,10,1006,10,575,22102,1,-4,-4,1105,1,643,22102,1,-4,1,21201,-3,-1,2,21202,-2,2,3,21101,0,594,0,1105,1,552,21201,1,0,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,613,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,635,22102,1,-1,1,21101,635,0,0,106,0,510,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0"
//d11p2compare x:"3,8,1005,8,339,1106,0,11,0,0,0,104,1,104,0,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,29,2,1108,11,10,1,1,20,10,2,107,6,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,62,1006,0,29,1006,0,12,1,1101,5,10,1,2,20,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1001,8,0,99,1006,0,30,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1001,8,0,124,1006,0,60,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,149,2,1007,2,10,1,1105,10,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,178,1,1108,15,10,1,1101,5,10,1,109,8,10,1006,0,20,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,215,1006,0,61,1006,0,16,2,1105,15,10,1006,0,50,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,250,1,1003,10,10,1,9,19,10,2,1004,6,10,2,1106,2,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,289,1,1103,13,10,2,105,17,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,318,101,1,9,9,1007,9,1086,10,1005,10,15,99,109,661,104,0,104,1,21101,0,825599304340,1,21101,356,0,0,1106,0,460,21101,0,937108545948,1,21102,1,367,0,1106,0,460,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,21628980315,1,21101,0,414,0,1105,1,460,21101,0,3316673539,1,21101,425,0,0,1106,0,460,3,10,104,0,104,0,3,10,104,0,104,0,21102,988753428840,1,1,21102,1,448,0,1106,0,460,21102,825544569700,1,1,21102,459,1,0,1106,0,460,99,109,2,21202,-1,1,1,21102,1,40,2,21102,491,1,3,21102,481,1,0,1105,1,524,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,486,487,502,4,0,1001,486,1,486,108,4,486,10,1006,10,518,1101,0,0,486,109,-2,2105,1,0,0,109,4,2102,1,-1,523,1207,-3,0,10,1006,10,541,21102,0,1,-3,21201,-3,0,1,22102,1,-2,2,21102,1,1,3,21102,560,1,0,1106,0,565,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,588,2207,-4,-2,10,1006,10,588,22101,0,-4,-4,1105,1,656,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21102,1,607,0,1106,0,565,22102,1,1,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,626,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,648,21202,-1,1,1,21101,0,648,0,105,1,523,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0"
//d11p2compare x:"3,8,1005,8,351,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,102,1,8,28,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,51,1006,0,85,2,1109,8,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,80,1,2,2,10,1,1007,19,10,1,1001,13,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,113,1,2,1,10,1,1109,17,10,1,108,20,10,2,1005,3,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,151,2,5,19,10,1,104,19,10,1,109,3,10,1006,0,78,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,189,1006,0,3,2,1004,1,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,1001,8,0,218,1,1008,6,10,1,104,8,10,1006,0,13,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,251,1006,0,17,1006,0,34,1006,0,24,1006,0,4,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,285,1006,0,25,2,1103,11,10,1006,0,75,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,316,2,1002,6,10,1006,0,30,2,106,11,10,1006,0,21,101,1,9,9,1007,9,1072,10,1005,10,15,99,109,673,104,0,104,1,21101,0,937151009684,1,21101,0,368,0,1105,1,472,21102,386979963796,1,1,21102,379,1,0,1106,0,472,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,179410325723,0,1,21101,426,0,0,1106,0,472,21101,0,179355823195,1,21102,437,1,0,1106,0,472,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,825460785920,1,21101,460,0,0,1105,1,472,21102,1,838429614848,1,21102,1,471,0,1105,1,472,99,109,2,21202,-1,1,1,21102,40,1,2,21102,1,503,3,21101,493,0,0,1105,1,536,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,498,499,514,4,0,1001,498,1,498,108,4,498,10,1006,10,530,1101,0,0,498,109,-2,2106,0,0,0,109,4,2101,0,-1,535,1207,-3,0,10,1006,10,553,21101,0,0,-3,21202,-3,1,1,22101,0,-2,2,21101,0,1,3,21101,572,0,0,1105,1,577,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,600,2207,-4,-2,10,1006,10,600,21202,-4,1,-4,1106,0,668,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21102,619,1,0,1105,1,577,22102,1,1,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,638,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,660,22101,0,-1,1,21101,660,0,0,106,0,535,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0"
//d11p2compare x:"3,8,1005,8,310,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,28,1,105,11,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,55,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,76,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,102,1,8,98,1,1004,7,10,1006,0,60,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,127,2,1102,4,10,1,1108,7,10,2,1102,4,10,2,101,18,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,166,1006,0,28,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,190,1006,0,91,1,1108,5,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,1002,8,1,220,1,1009,14,10,2,1103,19,10,2,1102,9,10,2,1007,4,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,258,2,3,0,10,1006,0,4,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,286,1006,0,82,101,1,9,9,1007,9,1057,10,1005,10,15,99,109,632,104,0,104,1,21102,1,838479487636,1,21102,327,1,0,1106,0,431,21102,1,932813579156,1,21102,1,338,0,1106,0,431,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,0,179318033447,1,21101,385,0,0,1105,1,431,21101,248037678275,0,1,21101,0,396,0,1105,1,431,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,709496558348,1,21102,419,1,0,1105,1,431,21101,825544561408,0,1,21101,0,430,0,1106,0,431,99,109,2,22101,0,-1,1,21101,40,0,2,21102,462,1,3,21101,0,452,0,1106,0,495,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,457,458,473,4,0,1001,457,1,457,108,4,457,10,1006,10,489,1101,0,0,457,109,-2,2106,0,0,0,109,4,2101,0,-1,494,1207,-3,0,10,1006,10,512,21101,0,0,-3,22101,0,-3,1,22101,0,-2,2,21101,1,0,3,21102,531,1,0,1105,1,536,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,559,2207,-4,-2,10,1006,10,559,22101,0,-4,-4,1106,0,627,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21102,578,1,0,1105,1,536,22101,0,1,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,597,21102,0,1,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,619,21201,-1,0,1,21102,1,619,0,105,1,494,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0"

/
OVERVIEW:
The OCR is the same as the one from day 8.

COMMON PARTS:
The d11 function takes a program and the color of the initial panel as parameters.
We keep track of the grid, which starts only as a single panel, but is expanded
whenever the cursor moves past an edge. When this happens at the top or left edge,
we also have to push the grid down/right after adding a blank row, which also means
pushing the coordinates of the cursor and the path. Once we are done we return the
painted grid and the number of distinct elements in the path.

PART 1:
The second element of the return value from d11 is the answer to part 1.

PART 2:
We replace black with " " and white with "*". We also cut off any empty columns on
the left and make sure that the grid is 40 wide (we can't just cut off all empty
columns on the right since some letters have all blanks there).
Then we cut the grid up like we did with Day 8 and perform OCR on it.

WHITEBOXING:
PART 1:
The first pair of outputs is hardcoded as 1 0. Then there is a sequence of 10 inputs
follwed by a pair of outputs each. The first output (the panel color) is the inverse
of the input color. The second output (turn direction) is obtained by comparing the
input to a hardcoded value. However, right after this, the constant is overwritten
to the input. This means after the first run, the output is compared to the input 10
inputs ago. The whole loop runs a certain number times, for a total of 10N+1 inputs.
There are junk instructions thrown in between the inputs within a loop, probably to
make sure that it's not possible to get the initial comparison values by a simple
a[x+i*y] kind of indexing.
To find the initial values, we look for instructions that look like EQ [8],x,[10]
(the two arguments may be reversed).

We look for EQ (108 or 1008) instructions:
q)ind
27 56 82 104 129 158 184 206 239 265 467

We check if the 3rd arg is [10] as there may be stray indices, also we drop the last
one because it is valid but not in part 1:
q)ind:-1_ind where a[ind+3]=10;
q)ind
27 56 82 104 129 158 184 206 239

We populate the compare buffer by taking the two values after the instruction index
and filtering out the 8s:
q)compBuffer:raze a[ind+\:1 2]except\:8;
q)compBuffer
1 0 0 1 0 0 0 1 1

Now to find the number of iterations, we look for a LT instruction:
q)ind:where a=1007;
q)ind
224 291

We check if the arguments are [9] and [10] since the others are stray indices:
q)ind:ind where a[ind+\:1 3]~\:9 10;
q)ind
,291

The period is the 2nd argument to this instruction:
q)iter:a[first[ind]+2];
q)iter
1003

The rest is similar to the blackbox solution, with the only difference being that we
directly produce the output using the logic above and the constants that we extracted.

    do[1+10*iter;
        $[0=count path;
            out:1 0;
            [   
                input:grid . cursor;
                out:(1-input;compBuffer[0]=input);
                compBuffer:(1_compBuffer),input;
            ]
        ];
    ...

PART 2:
Curiously the whiteboxed solution for this day is very different for the two parts,
even though for the normal blackbox solution the simulation is common and only the
small post-processing steps are different.
The intcode program has completely different logic for the two parts. When it finds
a non-zero first input, it jumps to a separate part of the program that drwas the ID
for part 2. The ID is stored as a bitmap in 6 large numbers, which are then decoded
and printed in a meandering pattern. The first large number starts at the top left,
and the first four bits correspond to a 2x2 square in the order top left, bottom left,
bottom right, top left. There are 40 bits per large number, so the first one fills
half of the top two rows of the ID. The second large number completes the first rows.
The ID is drawn in a "boustrophedon" way, so the next two large numbers are painted
from right to left with the ordering of the pixels inside the 2x2 squares reversed.
Finally the last two large numbers are painted from left to right like the first two.

To find the bitmaps, all we have to do is find very large numbers in the intcode:
q)ns:a where a>100000
q)ns
387239486208 936994976664 29192457307 3450965211 837901103972 867965752164

We reorder the bits in each number in the way described above:
q)seq1:raze each flip @[;(0 3;1 2)]each 4 cut raze -40#/:0b vs/:ns 0 1;
q)seq2:raze each flip @[;(1 2;0 3)]each 4 cut reverse raze -40#/:0b vs/:ns 2 3;
q)seq3:raze each flip @[;(0 3;1 2)]each 4 cut raze -40#/:0b vs/:ns 4 5;
q)seq1
0110001100011001000011100011000011011110b
1001010010100101000010010100100001010000b
q)seq2
1001010000100101000010010100000001011100b
1111010110111101000011100101100001010000b
q)seq3
1001010010100101000010100100101001010000b
1001001110100101111010010011100110011110b

We put them together to form the final grid:
q)grid:" *"seq1,seq2,seq3;
q)grid
" **   **   **  *    ***   **    ** **** "
"*  * *  * *  * *    *  * *  *    * *    "
"*  * *    *  * *    *  * *       * ***  "
"**** * ** **** *    ***  * **    * *    "
"*  * *  * *  * *    * *  *  * *  * *    "
"*  *  *** *  * **** *  *  ***  **  **** "

From here the post-processing is the same as the blackbox solution.
