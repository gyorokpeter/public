d15p1:{[a;b]
    chunksize:1000000;
    start:0;
    total:0;
    while[(0N!start)<40000000;
        as:1_{[a](a*16807)mod 2147483647}\[chunksize;a];
        bs:1_{[b](b*48271)mod 2147483647}\[chunksize;b];
        total+:sum(as mod 65536)=bs mod 65536;
        start+:chunksize;
        a:last as;
        b:last bs;
    ];
    total};

d15p1[65;8921]  //588

d15p2:{[a;b]
    chunksize:100000;
    start:0;
    total:0;
    while[(0N!start)<5000000;
        as:1_{[a]while[[a:(a*16807)mod 2147483647;a mod 4]];a}\[chunksize;a];
        bs:1_{[b]while[[b:(b*48271)mod 2147483647;b mod 8]];b}\[chunksize;b];
        total+:sum(as mod 65536)=bs mod 65536;
        start+:chunksize;
        a:last as;
        b:last bs;
    ];
    total};

d15p2[65;8921]  //309
