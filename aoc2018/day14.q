d14p1:{
    c:"J"$x;
    r:3 7;
    curr0:0;
    curr1:1;
    while[count[r]<10+c;
        d0:r curr0;
        d1:r curr1;
        r,:"J"$/:string d0+d1;
        curr0:(1+curr0+d0)mod count r;
        curr1:(1+curr1+d1)mod count r;
    ];
    raze string 10#c _r};
d14p2:{
    c:"J"$/:x;
    r:3 7;
    curr0:0;
    curr1:1;
    cc:count c;
    while[1b;
        d0:r curr0;
        d1:r curr1;
        ds:"J"$/:string d0+d1;
        r,:ds;
        if[count[c]<=count[r];
            if[c~neg[cc]#r; :count[r]-cc];
            if[2=count ds;if[c~-1_(-1+neg cc)#r; :count[r]-cc+1]];
        ];
        curr0:(1+curr0+d0)mod count r;
        curr1:(1+curr1+d1)mod count r;
    ];
    };

d14p1"047801"
d14p2"047801"
