d8p1:{ins:trim each"\n"vs x;
    rm:{[rm;x]
        reg:rm 0;
        p:" "vs x;
        cond:$[p[5]~"==";=;p[5]~"!=";<>;value p[5]];
        if[cond[0^reg`$p[4];"J"$p[6]];reg[`$p[0]]+:$[p[1]~"dec";-1;1]*"J"$p 2];
        (reg;rm[1],max reg)
    }/[((`$())!`long$();`long$());ins];
    last last rm};

d8p1"b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10"   //1

d8p2:{ins:trim each"\n"vs x;
    rm:{[rm;x]
        reg:rm 0;
        p:" "vs x;
        cond:$[p[5]~"==";=;p[5]~"!=";<>;value p[5]];
        if[cond[0^reg`$p[4];"J"$p[6]];reg[`$p[0]]+:$[p[1]~"dec";-1;1]*"J"$p 2];
        (reg;rm[1],max reg)
    }/[((`$())!`long$();`long$());ins];
    max last rm};

d8p2 "b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10"   //10
