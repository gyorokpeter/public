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
    s2}
d8p1:{sum sum d8 x}
d8p2:{
    disp:d8 inp;
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
    ocr?letter}

d8p1"rect 3x2\nrotate column x=1 by 1\nrotate row y=0 by 4\nrotate column x=1 by 4"
d8p2 inp    //only works with actual puzzle input
