/
.d25.v:{[reg;val]if[null v:"J"$val;v:reg[`$val]];v};
.d25.tgl:{(("cpy";"inc";"dec";"jnz";"tgl";"out")!("jnz";"dec";"inc";"cpy";"inc";"inc"))x};

.d25.fetch:{[ins;ip]
    if[ip<count[ins]-8;
        seq:8#ip _ins;
        if[(seq[;0]~("cpy";"jnz";"jnz";"dec";"dec";"jnz";"inc";"jnz")) and
            (seq[1 2 5 7;2]~(enlist"2";enlist"6";"-4";"-7")) and
            (seq[2 7;1]~(enlist"1";enlist"1")) and
            (seq[0;2]~seq[4;1]) and (seq[4;1]~seq[5;1]) and
            (seq[1;1]~seq[3;1]);
            :("div";seq[1;1];seq[0;1];seq[6;1];seq[0;2]);
        ];
    ];
    if[ip<count[ins]-6;
        seq:6#ip _ins;
        if[(seq[;0]~("cpy";"inc";"dec";"jnz";"dec";"jnz"))and (seq[2;1]~seq[3;1]) and (seq[0;2]~seq[2;1])
             and (seq[4;1]~seq[5;1])
            and seq[3 5;2]~("-2";"-5");
            :("mul";seq[0;1];seq[4;1];seq[1;1];seq[0;2])];
    ];
    if[ip<count[ins]-3;
        seq:3#ip _ins;
        if[(seq[;0]~("dec";"inc";"jnz"))and (seq[0;1]~seq[2;1]) and seq[2;2]~"-2";
            :("add";seq[0;1];seq[1;1])];
        seq:3#ip _ins;
        if[(seq[;0]~("inc";"dec";"jnz"))and (seq[1;1]~seq[2;1]) and seq[2;2]~"-2";
            :("add";seq[1;1];seq[0;1])];
    ];
    :ins[ip];
    };

.d25.mul:{[ni;reg]va:.d25.v[reg;ni[1]];rb:`$ni[2];rt:`$ni[3];rtmp:`$ni[4];reg[rt]+:va*reg[rb];reg[rb,rtmp]:0;reg};
.d25.add:{[ni;reg]rs:`$ni[1];rt:`$ni[2];reg[rt]+:reg[rs];reg[rs]:0;reg};

.d25.ops:(enlist[""])!(enlist{'"unknown"});
.d25.ops["out"]:{[ni;ip;ins;reg]
    v:.d25.v[reg;ni 1];.d25.stdout,:v;
    (ip+1;ins;reg)};
.d25.ops["cpy"]:{[ni;ip;ins;reg]
    v:.d25.v[reg;ni 1];r:`$ni[2];if[r in key reg;reg[r]:v];
    (ip+1;ins;reg)};
.d25.ops["inc"]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]+:1];
    (ip+1;ins;reg)};
.d25.ops["dec"]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]-:1];
    (ip+1;ins;reg)};
.d25.ops["jnz"]:{[ni;ip;ins;reg]
    v:.d25.v[reg;ni 1];v2:.d25.v[reg;ni 2];if[v>0;ip+:v2-1];
    (ip+1;ins;reg)};
.d25.ops["tgl"]:{[ni;ip;ins;reg]
    v:.d25.v[reg;ni 1];ti:v+ip;if[ti<count ins;ins[ti;0]:.d25.tgl ins[ti;0]];
    (ip+1;ins;reg)};
.d25.ops["mul"]:{[ni;ip;ins;reg]
    reg:.d25.mul[ni;reg];
    (ip+6;ins;reg)};
.d25.ops["div"]:{[ni;ip;ins;reg]
    rs:`$ni 1;divisor:.d25.v[reg;ni 2];quot:`$ni 3;rem:`$ni 4;
    reg[quot]+:reg[rs] div divisor;
    reg[rem]:1+(reg[rs]-1) mod divisor;
    reg[rs]:0;
    (ip+8;ins;reg)};
.d25.ops["add"]:{[ni;ip;ins;reg]
    reg:.d25.add[ni;reg];
    (ip+3;ins;reg)};

d25:{[ins;reg]
    .d25.stdout:();
    ip:0;
    ic:0;
    while[ip<count ins;
        ic+:1;
        ni:.d25.fetch[ins;ip];
        op:.d25.ops[ni[0]];
        if[null op; 'ni[0]," unknown"];
        res:op[ni;ip;ins;reg];
        ip:res[0];
        ins:res[1];
        reg:res[2];
    ];
    .d25.stdout};

d25p1:{[x]
    ins:" "vs/:"\n"vs x;
    d25[ins;`a`b`c`d!0 0 0 0];
    `char$.d25.stdout};
part1:d25p1 `char$read1`:D:/projects/github/public/aoc2016/bonuschallenge.txt;
\

{
    path:"/"sv -1_"/"vs ssr[;"\\";"/"]first -3#value .z.s;
    if[not `assembunny in key`;
        system"l ",path,"/assembunny.q";
    ];
    .d25.input:`char$read1`$path,"/bonuschallenge.txt";
    }[];

part1:`char$.assembunny.getOutput .assembunny.run .assembunny.new[.d25.input];

.d25.w:50;
.d25.h:6;

d8:{
    s:(.d25.h,.d25.w)#0b;
    ins:("\n"vs x) except enlist"";
    s2:{[s;ins0]
        ci:" "vs ins0; op:first ci;
        $[op~"rect";
            [wh:"x"vs ci[1]; w:"J"$wh 0; h:"J"$wh 1;
                s or (w>til .d25.w) and\:/: (h>til .d25.h)];
          op~"rotate";
            [tg:ci 1;coord:"J"$last"="vs ci 2; amt:"J"$ci 4;
                $[tg~"column";
                    [sa:flip s;sa[coord]:neg[amt] rotate sa[coord];flip sa];
                  tg~"row";
                    [if[coord<count s;s[coord]:neg[amt] rotate s[coord]];s];
                '"unknown target: ",tg]
            ];
         '"unkown instruction: ",op
        ]}/[s;ins];
    s2};

d8p2:{[inp]
    disp:d8 inp;
    letter:raze each 5 cut flip disp;
    ocr:enlist[" "]!enlist`boolean$();
    //the OCR is not specified, so only
    //the characters I found are here
    ocr[" "]:000000000000000000000000000000b;
    ocr["0"]:000000011110100001011110000000b;
    ocr["1"]:000000010001111111000001000000b;
    ocr["2"]:010001100011100101011001000000b;
    ocr["7"]:100000100011101100110000000000b;
    ocr["A"]:011111100100100100011111000000b;
    ocr["C"]:011110100001100001010010000000b;
    ocr["E"]:111111101001101001100001000000b;
    ocr["F"]:111111101000101000100000000000b;
    ocr["I"]:000000100001111111100001000000b;
    ocr["J"]:000010000001100001111110000000b;
    ocr["K"]:111111001000010110100001000000b;
    ocr["R"]:111111100100100110011001000000b;
    ocr["Y"]:110000001000000111001000110000b;
    ocr["o"]:000110001001001001000110000000b;
    ocr?letter};

d8p2 part1
