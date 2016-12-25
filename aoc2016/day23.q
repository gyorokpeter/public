.d23.v:{[reg;val]if[null v:"J"$val;v:reg[`$val]];v};
.d23.tgl:{(("cpy";"inc";"dec";"jnz";"tgl")!("jnz";"dec";"inc";"cpy";"inc"))x};

.d23.fetch:{[ins;ip]
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

.d23.mul:{[ni;reg]ra:`$ni[1];rb:`$ni[2];rt:`$ni[3];rtmp:`$ni[4];reg[rt]+:reg[ra]*reg[rb];reg[rb,rtmp]:0;reg};
.d23.add:{[ni;reg]rs:`$ni[1];rt:`$ni[2];reg[rt]+:reg[rs];reg[rs]:0;reg};

.d23.ops:(enlist[""])!(enlist{'"unknown"});
.d23.ops["cpy"]:{[ni;ip;ins;reg]
    v:.d23.v[reg;ni 1];r:`$ni[2];if[r in key reg;reg[r]:v];
    (ip+1;ins;reg)};
.d23.ops["inc"]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]+:1];
    (ip+1;ins;reg)};
.d23.ops["dec"]:{[ni;ip;ins;reg]
    r:`$ni[1];if[r in key reg;reg[r]-:1];
    (ip+1;ins;reg)};
.d23.ops["jnz"]:{[ni;ip;ins;reg]
    v:.d23.v[reg;ni 1];v2:.d23.v[reg;ni 2];if[v>0;ip+:v2-1];
    (ip+1;ins;reg)};
.d23.ops["tgl"]:{[ni;ip;ins;reg]
    v:.d23.v[reg;ni 1];ti:v+ip;if[ti<count ins;ins[ti;0]:.d23.tgl ins[ti;0]];
    (ip+1;ins;reg)};
.d23.ops["mul"]:{[ni;ip;ins;reg]
    reg:.d23.mul[ni;reg];
    (ip+5;ins;reg)};
.d23.ops["add"]:{[ni;ip;ins;reg]
    reg:.d23.add[ni;reg];
    (ip+3;ins;reg)};

d23:{[ins;reg]
    ip:0;
    while[ip<count ins;
        ni:.d23.fetch[ins;ip];
        op:.d23.ops[ni[0]];
        if[null op; 'ni[0]," unknown"];
        res:op[ni;ip;ins;reg];
        ip:res[0];
        ins:res[1];
        reg:res[2];
    ];
    reg};

d23p1:{
    ins:" "vs/:"\n"vs x;
    reg:d23[ins;`a`b`c`d!7 0 0 0];
    reg`a};
d23p2:{
    ins:" "vs/:"\n"vs x;
    reg:d23[ins;`a`b`c`d!12 0 0 0];
    reg`a};

d23p1 "cpy 2 a\ntgl a\ntgl a\ntgl a\ncpy 1 a\ndec a\ndec a"
d23p2 "cpy 2 a\ntgl a\ntgl a\ntgl a\ncpy 1 a\ndec a\ndec a"

//OVERVIEW:
//Although there is not much change from day 12, the code had to be refactored a lot
//to avoid the 'branch error, and optimizations added for some multiplication and
//addition sequences.