d8:{
    s:6 50#0b;
    ins:"\n"vs x;
    s2:{[s;ins0]
        ci:" "vs ins0; op:first ci;
        $[op~"rect";
            [wh:"x"vs ci[1]; w:"J"$wh 0; h:"J"$wh 1;
                s or (w>til 50) and\:/: (h>til 6)];
          op~"rotate";
            [tg:ci 1;coord:"J"$last"="vs ci 2; amt:"J"$ci 4;
                $[tg~"column";
                    [sa:flip s;sa[coord]:neg[amt] rotate sa[coord];flip sa];
                  tg~"row";
                    [s[coord]:neg[amt] rotate s[coord];s];
                '"unknown target: ",tg]
            ];
         '"unkown instruction: ",op
        ]}/[s;ins];
    s2};
d8p1:{sum sum d8 x};
d8p2:{
    disp:d8 x;
    letter:raze each 5 cut flip disp;
    ocr:enlist[" "]!enlist`boolean$();
    //the OCR is not specified, so only
    //the characters I found are here
    ocr["E"]:111111101001101001100001000000b;
    ocr["F"]:111111101000101000100000000000b;
    ocr["I"]:000000100001111111100001000000b;
    ocr["J"]:000010000001100001111110000000b;
    ocr["K"]:111111001000010110100001000000b;
    ocr["R"]:111111100100100110011001000000b;
    ocr["Y"]:110000001000000111001000110000b;
    ocr?letter};

d8p1"rect 3x2\nrotate column x=1 by 1\nrotate row y=0 by 4\nrotate column x=1 by 4"
d8p2"rect 1x1\nrotate row y=0 by 5\nrect 1x1\nrotate row y=0 by 6\nrect 1x1\nrotate row y=0 by 5\nrect 1x1\nrotate row y=0 by 2\nrect 1x1\nrotate row y=0 by 5\nrect 2x1\nrotate row y=0 by 2\nrect 1x1\nrotate row y=0 by 4\nrect 1x1\nrotate row y=0 by 3\nrect 2x1\nrotate row y=0 by 7\nrect 3x1\nrotate row y=0 by 3\nrect 1x1\nrotate row y=0 by 3\nrect 1x2\nrotate row y=1 by 13\nrotate column x=0 by 1\nrect 2x1\nrotate row y=0 by 5\nrotate column x=0 by 1\nrect 3x1\nrotate row y=0 by 18\nrotate column x=13 by 1\nrotate column x=7 by 2\nrotate column x=2 by 3\nrotate column x=0 by 1\nrect 17x1\nrotate row y=3 by 13\nrotate row y=1 by 37\nrotate row y=0 by 11\nrotate column x=7 by 1\nrotate column x=6 by 1\nrotate column x=4 by 1\nrotate column x=0 by 1\nrect 10x1\nrotate row y=2 by 37\nrotate column x=19 by 2\nrotate column x=9 by 2\nrotate row y=3 by 5\nrotate row y=2 by 1\nrotate row y=1 by 4\nrotate row y=0 by 4\nrect 1x4\nrotate column x=25 by 3\nrotate row y=3 by 5\nrotate row y=2 by 2\nrotate row y=1 by 1\nrotate row y=0 by 1\nrect 1x5\nrotate row y=2 by 10\nrotate column x=39 by 1\nrotate column x=35 by 1\nrotate column x=29 by 1\nrotate column x=19 by 1\nrotate column x=7 by 2\nrotate row y=4 by 22\nrotate row y=3 by 5\nrotate row y=1 by 21\nrotate row y=0 by 10\nrotate column x=2 by 2\nrotate column x=0 by 2\nrect 4x2\nrotate column x=46 by 2\nrotate column x=44 by 2\nrotate column x=42 by 1\nrotate column x=41 by 1\nrotate column x=40 by 2\nrotate column x=38 by 2\nrotate column x=37 by 3\nrotate column x=35 by 1\nrotate column x=33 by 2\nrotate column x=32 by 1\nrotate column x=31 by 2\nrotate column x=30 by 1\nrotate column x=28 by 1\nrotate column x=27 by 3\nrotate column x=26 by 1\nrotate column x=23 by 2\nrotate column x=22 by 1\nrotate column x=21 by 1\nrotate column x=20 by 1\nrotate column x=19 by 1\nrotate column x=18 by 2\nrotate column x=16 by 2\nrotate column x=15 by 1\nrotate column x=13 by 1\nrotate column x=12 by 1\nrotate column x=11 by 1\nrotate column x=10 by 1\nrotate column x=7 by 1\nrotate column x=6 by 1\nrotate column x=5 by 1\nrotate column x=3 by 2\nrotate column x=2 by 1\nrotate column x=1 by 1\nrotate column x=0 by 1\nrect 49x1\nrotate row y=2 by 34\nrotate column x=44 by 1\nrotate column x=40 by 2\nrotate column x=39 by 1\nrotate column x=35 by 4\nrotate column x=34 by 1\nrotate column x=30 by 4\nrotate column x=29 by 1\nrotate column x=24 by 1\nrotate column x=15 by 4\nrotate column x=14 by 1\nrotate column x=13 by 3\nrotate column x=10 by 4\nrotate column x=9 by 1\nrotate column x=5 by 4\nrotate column x=4 by 3\nrotate row y=5 by 20\nrotate row y=4 by 20\nrotate row y=3 by 48\nrotate row y=2 by 20\nrotate row y=1 by 41\nrotate column x=47 by 5\nrotate column x=46 by 5\nrotate column x=45 by 4\nrotate column x=43 by 5\nrotate column x=41 by 5\nrotate column x=33 by 1\nrotate column x=32 by 3\nrotate column x=23 by 5\nrotate column x=22 by 1\nrotate column x=21 by 2\nrotate column x=18 by 2\nrotate column x=17 by 3\nrotate column x=16 by 2\nrotate column x=13 by 5\nrotate column x=12 by 5\nrotate column x=11 by 5\nrotate column x=3 by 5\nrotate column x=2 by 5\nrotate column x=1 by 5"
