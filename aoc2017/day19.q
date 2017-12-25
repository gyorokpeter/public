.d19.followPath:{
    map:"\n"vs x;
    dir:2;
    dirsteps:(-1 0;0 1;1 0;0 -1);
    pos:(0;first where map[0]<>" ");
    steps:1;
    letters:"";
    while[1b;
        nxtp:pos+dirsteps dir;
        if[" "=map . nxtp;
            nxtdirs:(dir+1 -1)mod 4;
            nxtps:pos+/:dirsteps nxtdirs;
            dir:first nxtdirs where " "<>map ./: nxtps;
            if[null dir; :(letters;steps)];
            nxtp:pos+dirsteps dir;
        ];
        if[(ch:map . nxtp) within "AZ";
            letters,:ch;
        ];
        pos:nxtp;
        steps+:1;
    ];
    };

d19p1:{.d19.followPath[x][0]};
d19p2:{.d19.followPath[x][1]};

d19p1
    "     |          \n",
    "     |  +--+    \n",
    "     A  |  C    \n",
    " F---|----E|--+ \n",
    "     |  |  |  D \n",
    "     +B-+  +--+ \n"    //ABCDEF

d19p2
    "     |          \n",
    "     |  +--+    \n",
    "     A  |  C    \n",
    " F---|----E|--+ \n",
    "     |  |  |  D \n",
    "     +B-+  +--+ \n"    //38
