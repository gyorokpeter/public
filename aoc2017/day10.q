bitxor:{0b sv <>[0b vs x;0b vs y]};

d10p1:{[chain;x]
    lens:"J"$trim each ","vs x;
    s:{[s;len]idx:(s[1]+til len)mod c:count s 0;s[0;idx]:reverse s[0;idx];s[1]:(s[1]+len+s[2])mod c;s[2]+:1;s}/[(til chain;0;0);lens];
    prd s[0;0 1]};

d10p1[5;"3, 4, 1, 5"] //12
d10p1[256;"230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167"] //2928

d10p2:{[x]
    lens:(`long$x),17 31 73 47 23;
    sp:first{[s;len]idx:(s[1]+til len)mod c:count s 0;s[0;idx]:reverse s[0;idx];s[1]:(s[1]+len+s[2])mod c;s[2]+:1;s}/[(til 256;0;0);raze 64#enlist lens];
    dense:(bitxor/) each 16 cut sp;
    raze string`byte$dense};

d10p2""         //"a2582a3a0e66e6e86e3812dcb672a272"
d10p2"AoC 2017" //"33efeb34ea91902bb2f59c9920caa6cd"
d10p2"1,2,3"    //"3efbe78a8d82f29979031a4aa0b16a9d"
d10p2"1,2,4"    //"63960835bcdc130f0b66d7ff4f6a5a8e"
d10p2"230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167"   //"0c2f794b2eb555f7830766bf8fb65a16"
