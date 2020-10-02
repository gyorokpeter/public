\c 2000 2000

//==============================================================================
// UTILITIES
//==============================================================================

ascii85dec:{[str]
    str:(first"~>" vs last"<~" vs str)except"\r\n";
    if["z" in str; "z nyi"];
    if[33>min str; '"bad data (min)"];
    if[117<max str; '"bad data (max)"];
    pad:(5-count[str]mod 5)mod 5;
    str,:pad#"u";
    neg[pad]_raze`char$-4#/:0 0 0 0,/:256 vs/:85 sv/:(`int$5 cut str)-33};

bitand:{0b sv (0b vs x)&0b vs y};
bitxor:{0b sv (0b vs x)<>0b vs y};
LE:{0x00 sv reverse x};

//==============================================================================
// LAYER 1
//==============================================================================

p1:{0b sv/:-1 rotate/:01010101b<>/:0b vs/:x};

//==============================================================================
// LAYER 2
//==============================================================================

p2:{{`char$0b sv/:-1_8 cut raze -1_/:x where 0=(sum each x)mod 2}0b vs/:x};

//==============================================================================
// LAYER 3
//==============================================================================

p3:{x bitxor' count[x]#bitxor'[32#x;"==[ Layer 4/6: Network Traffic ]"]};

//==============================================================================
// LAYER 4
//==============================================================================

p4:{
    a:`byte$x;
    offs:-1_{[a;off]$[off>=count a;off;off+:0x00 sv a[off+2 3]]}[a]\[0];
    b:offs cut a;
    c:b where 0x0a01010a~/:b[;12+til 4];
    d:c where 0x0a0101c8~/:c[;16+til 4];
    cs:{$[x>65536;(x div 65536i)+x mod 65536i;x]}/';
    hcs:cs sum each 0x00 sv/:/:0x0000,/:/:2 cut/:20#/:d;
    e:d where 65535=hcs;
    f:e where 42069=0x00 sv/:0x0000,/:e[;22 23];
    fa:f[;12 13 14 15 16 17 18 19 -1 9],'{x,'((count each x)mod 2)#\:0x00}20_/:f;
    ucs:cs ((0x00 sv/:f[;2 3])-20)+sum each 0x00 sv/:/:0x0000,/:/:2 cut/:fa;
    g:f where 65535=ucs;
    raze`char$28_/:g};

//==============================================================================
// LAYER 5
//==============================================================================

sbox:
    0x637c777bf26b6fc53001672bfed7ab76,
    0xca82c97dfa5947f0add4a2af9ca472c0,
    0xb7fd9326363ff7cc34a5e5f171d83115,
    0x04c723c31896059a071280e2eb27b275,
    0x09832c1a1b6e5aa0523bd6b329e32f84,
    0x53d100ed20fcb15b6acbbe394a4c58cf,
    0xd0efaafb434d338545f9027f503c9fa8,
    0x51a3408f929d38f5bcb6da2110fff3d2,
    0xcd0c13ec5f974417c4a77e3d645d1973,
    0x60814fdc222a908846eeb814de5e0bdb,
    0xe0323a0a4906245cc2d3ac629195e479,
    0xe7c8376d8dd54ea96c56f4ea657aae08,
    0xba78252e1ca6b4c6e8dd741f4bbd8b8a,
    0x703eb5664803f60e613557b986c11d9e,
    0xe1f8981169d98e949b1e87e9ce5528df,
    0x8ca1890dbfe6426841992d0fb054bb16;
invsbox:`byte$iasc sbox;

rcon:{$[x<0x80;`byte$2*x;`byte$bitxor[2i*x;283i]]}\[9;0x01];

mksch:{[ky]first{[nk;wn]w:wn 0;n:wn 1;(w,enlist $[0=n mod nk;
        @[sbox 1 rotate w[count[w]-1];0;bitxor;rcon[n div nk]];
        (nk=8)and 4=n mod 8;sbox w[count[w]-1];
        w[count[w]-1]] bitxor' w[count[w]-nk];n+1)}[count[ky] div 4]/[(16 24 32!40 46 52)count ky;(4 cut ky;0)]};

mixmul:{
    bits:where reverse 0b vs `byte$x;
    part:{x:2i*`int$x;if[x>=256;x:bitxor[x;283i]];`byte$x}\[max bits;y];
    (bitxor/)part bits};

mixcol:{(bitxor/')(2 3 1 1;1 2 3 1;1 1 2 3;3 1 1 2) mixmul'\:x};
mixcols:mixcol each;
unmixcol:{(bitxor/')(14 11 13 9;9 14 11 13;13 9 14 11;11 13 9 14) mixmul'\:x};
unmixcols:unmixcol each;

shiftrows:{flip til[4] rotate' flip x};
unshiftrows:{flip neg[til 4] rotate' flip x};

aes0:{[ksch;inp]
    state:(4 cut inp) bitxor'' 4#ksch;
    state2:{[state;kf]kf bitxor'' mixcols shiftrows sbox state}/[state;4 cut 4_-4_ksch];
    raze (-4#ksch) bitxor'' shiftrows sbox state2};

aes:{[ky;inp]aes0[mksch ky;inp]};

aesd0:{[ksch;out]
    state:(4 cut out) bitxor'' -4#ksch;
    state2:{unmixcols y bitxor'' invsbox unshiftrows x}/[state;reverse 4 cut 4_-4_ksch];
    raze (4#ksch) bitxor'' invsbox unshiftrows state2};

aesd:{[ky;inp]aesd0[mksch ky;inp]};

/aes[0x2b7e151628aed2a6abf7158809cf4f3c;0x3243f6a8885a308d313198a2e0370734]
/aes[0x000102030405060708090a0b0c0d0e0f;0x00112233445566778899aabbccddeeff]
/aesd[0x000102030405060708090a0b0c0d0e0f;0x69c4e0d86a7b0430d8cdb78070b4c55a]
/aes[0x000102030405060708090a0b0c0d0e0f1011121314151617;0x00112233445566778899aabbccddeeff]
/aesd[0x000102030405060708090a0b0c0d0e0f1011121314151617;0xdda97ca4864cdfe06eaf70a0ec0d7191]
/aes[0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;0x00112233445566778899aabbccddeeff]
/aesd[0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;0x8ea2b7ca516745bfeafc49904b496089]

keywrap:{[kek;iv;inp]
    a:iv;
    r:8 cut inp;
    ksch:mksch kek;
    c:{[ksch;arj]a:arj 0;r:arj 1;j:arj 2;
        c:{[ksch;adj;r]a:adj 0; j:adj 2;
            b:aes0[ksch;a,r];
            a:bitxor'[8#b;0x00 vs j+1];
            (a;-8#b;j+1)
        }[ksch]\[(a;0;j);r];
        (first last c;c[;1];last last c)
    }[ksch]/[6;(a;r;0)];
    c[0],raze c[1]};

keyunwrap:{[kek;iv;out]
    a:8#out;
    r:8 cut 8_out;
    ksch:mksch kek;
    c:{[ksch;arj]a:arj 0;r:arj 1;j:arj 2;
        c:{[ksch;adj;r]a:adj 0;j:adj 2;
            b:aesd0[ksch;bitxor'[a;0x00 vs j],r];
            (8#b;-8#b;j-1)
        }[ksch]\[(a;0;j);reverse r];
        (first last c; reverse c[;1];last last c)
    }[ksch]/[6;(a;r;6*count r)];
    iv1:c 0;
    if[not iv1~iv; '"IV doesn't match: expected ",.Q.s1[iv]," found ",.Q.s1[iv1]];
    raze c 1};

/keywrap[0x000102030405060708090A0B0C0D0E0F;0xA6A6A6A6A6A6A6A6;0x00112233445566778899AABBCCDDEEFF]
/keyunwrap[0x000102030405060708090A0B0C0D0E0F;0xA6A6A6A6A6A6A6A6;0x1fa68b0a8112b447aef34bd8fb5a7b829d3e862371d2cfe5]

/keywrap[0x000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;0xA6A6A6A6A6A6A6A6;0x00112233445566778899AABBCCDDEEFF000102030405060708090A0B0C0D0E0F]
/keyunwrap[0x000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;0xA6A6A6A6A6A6A6A6;0x28c9f404c4b810f4cbccb35cfb87f8263f5786e2d80ed326cbc7f0e71a99f43bfb988b9b7a02dd21]

bitinc:{
    //x:0x00ff0405ffff
    p:$[last[x]=0xff;
        last where 1=deltas x=0xff;
        count[x]];
    if[p=0; :count[x]#0x00];
    ((p-1)#x),(`byte$x[p-1]+1),(count[x]-p)#0x00};

p5:{
    x0:`byte$x;
    p:sums[0 32 8 40 16] cut x0;
    ky:keyunwrap[p 0;p 1;p 2];
    `:d:/temp/ky 1: ky;
    ksch:mksch ky;
    ctr:p 3;
    blocks:ceiling count[p 4]%16;
    ctrs:bitinc\[blocks;ctr];
    kys:aes0[ksch] each ctrs;
    `char$bitxor'[count[p 4]#raze kys;p 4]};

//==============================================================================
// LAYER 6
//==============================================================================

fetch:{[state]
    opcode:state[`mem]state`pc;
    oneByteIns:0x0102c1c2c3c4!`HALT`OUT`CMP`ADD`SUB`XOR;
    if[opcode in key oneByteIns; :(enlist oneByteIns opcode;1)];
    if[opcode=0xe1; :((`APTR;state[`mem]1+state`pc);2)];
    fiveByteIns:0x2122!`JEZ`JNZ;
    if[opcode in key fiveByteIns; :((fiveByteIns opcode;LE state[`mem]state[`pc]+1+til 4);5)];
    opcodeBin:0b vs opcode;
    ra:`imm`a`b`c`d`e`f`ptrC;
    rb:`imm`La`Lb`Lc`Ld`ptr`pc;
    if[01b~2#opcodeBin;
        dest:ra 0b sv 00000b,2_-3_opcodeBin;
        src:ra 0b sv 00000b,-3#opcodeBin;
        if[src=`imm;
            :((`MV;dest;state[`mem]1+state`pc);2);
        ];
        :((`MV;dest;src);1);
    ];
    if[10b~2#opcodeBin;
        dest:rb 0b sv 00000b,2_-3_opcodeBin;
        src:rb 0b sv 00000b,-3#opcodeBin;
        if[src=`imm;
            :((`MV;dest;LE state[`mem]state[`pc]+1+til 4);5);
        ];
        :((`MV;dest;src);1);
    ];
    '"unknown instruction: ",.Q.s1 opcode;
    };

insMap:()!();
insMap[`HALT]:{[state;ins]
    state[`running]:0b;
    state};
insMap[`JEZ]:{[state;ins]
    if[state[`f]=0; state[`pc]:ins 1];
    state};
insMap[`JNZ]:{[state;ins]
    if[state[`f]<>0; state[`pc]:ins 1];
    state};
insMap[`CMP]:{[state;ins]
    state[`f]:`long$state[`a]<>state[`b];
    state};
insMap[`ADD]:{[state;ins]
    state[`a]:sum[state`a`b]mod 256;
    state};
insMap[`SUB]:{[state;ins]
    state[`a]:(state[`a]-state`b)mod 256;
    state};
insMap[`XOR]:{[state;ins]
    state[`a]:bitxor[state`a;state`b];
    state};
insMap[`APTR]:{[state;ins]
    state[`ptr]+:ins 1;
    state};
insMap[`MV]:{[state;ins]
    val:$[`ptrC~ins 2;`long$state[`mem]state[`ptr]+state`c;-11h=type ins 2; state ins 2; `long$ins 2];
    $[`ptrC~ins 1;
        state[`mem;state[`ptr]+state`c]:`byte$val;
        state[ins 1]:val
    ];
    state};
insMap[`OUT]:{[state;ins]
    state[`out],:`byte$state[`a];
    state};

p6:{
    state:enlist[`]!enlist(::);
    state[`running]:1b;
    state,:`a`b`c`d`e`f!6#0j;
    state,:`La`Lb`Lc`Ld`ptr`pc!6#0j;
    state,:`mem`out!(`byte$x;`byte$());
    while[state`running;
        inss:fetch[state];
        ins:inss 0;
        state[`pc]+:inss 1;
        if[not ins[0] in key insMap; '"nyi instruction: ",string ins 0];
        state:insMap[ins 0][state;ins];
    ];
    state`out};

//==============================================================================
// GLUE
//==============================================================================

solvers:(::;`p1;`p2;`p3;`p4;`p5;`p6);
{[d;sn](`$":layer",string[1+sn],".txt") 1: res:solvers[sn] ascii85dec d;res}/[raze read0`:onion.txt;til count solvers];
