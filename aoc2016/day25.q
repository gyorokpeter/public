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
    while[36>count .d25.stdout;
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
    a:0;
    while[not (36#0 1)~d25[ins;`a`b`c`d!a,0 0 0];
        a+:1;
    ];
    a};
d25p1dirtycheater:{2730-prd"J"$(" "vs/:"\n"vs x)[1 2;1]};

d25p1"cpy a d\ncpy 9 c\ncpy 282 b\ninc d\ndec b\njnz b -2\ndec c\njnz c -5\ncpy d a\njnz 0 0\ncpy a b\ncpy 0 a\ncpy 2 c\njnz b 2\njnz 1 6\ndec b\ndec c\njnz c -4\ninc a\njnz 1 -7\ncpy 2 b\njnz c 2\njnz 1 4\ndec b\ndec c\njnz 1 -4\njnz 0 0\nout b\njnz a -19\njnz 1 -21"