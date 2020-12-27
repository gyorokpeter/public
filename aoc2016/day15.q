//extended Euclidean algorithm
xe:{[a;b]
    if[a<b; :xe[b;a][0 2 1]];
    rst0:a,1 0;
    rst1:b,0 1;
    q:a;
    while[rst1[0]<>0;
        q:rst0[0] div rst1[0];
        rst2:rst0-q*rst1;
        rst0:rst1;rst1:rst2;
    ];
    rst0};
//linear congruence - this does NOT work for large numbers, check 2020d13 instead
lc:{[eq1;eq2]
    m:xe[eq1 0;eq2 0];
    (eq1[0]*eq2[0];((eq1[1]*m[2]*eq2[0])+(eq2[1]*m[1]*eq1[0]))mod eq1[0]*eq2[0])};
d15:{
    d:"J"$(" "vs/:"\n"vs x except".")[;3 11];
    d2:d[;0],'(neg d[;1]+1+til count d)mod d[;0];
    last lc/[d2]};
d15p1:{d15 x};
d15p2:{d15 x,"\n   11        0"};

inp:"Disc #1 has 17 positions; at time=0, it is at position 15.\n",
    "Disc #2 has 3 positions; at time=0, it is at position 2.\n",
    "Disc #3 has 19 positions; at time=0, it is at position 4.\n",
    "Disc #4 has 13 positions; at time=0, it is at position 2.\n",
    "Disc #5 has 7 positions; at time=0, it is at position 2.\n",
    "Disc #6 has 5 positions; at time=0, it is at position 0.";

d15p1 inp
d15p2 inp

//OVERVIEW:
//The disks form a linear congruence system. Luckily all the periods are primes.
//Due to the constant rotation of the disks we have to add the index number to
//their initial state (starting with 1). Furthermore we are looking for the number
//of seconds until the next alignment, not the time since the last alignment which
//would be the solution to the straight linear congruences.
//The implementation of the extended Euclidean algorithm (xe) and the Chinese remainder
//theorem (lc) is straightforward. In xe we can vectorize the computation of the
//remainder and factors since the same operation is applied to all three.