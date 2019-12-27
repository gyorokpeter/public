d24p1:{
    a:"#"="\n"vs x;
    hist:();
    while[1b;
        a1:0b,/:-1_/:a;
        a2:(1_/:a),\:0b;
        a3:(1_a),enlist(count first a)#0b;
        a4:enlist[(count first a)#0b],(-1_a);
        adj:a1+a2+a3+a4;
        a:(a*adj=1)+(not[a]*(adj>=1) and adj<=2);
        n:{y+2*x}/[reverse raze a];
        if[n in hist; :n];
        hist,:n;
    ];
    };

.d24.updGrid:{[g3]
    a:g3[1];
    a1:0b,/:-1_/:a;
    a2:(1_/:a),\:0b;
    a3:(1_a),enlist(count first a)#0b;
    a4:enlist[(count first a)#0b],(-1_a);
    adj:a1+a2+a3+a4;
    adj[;0]+:g3[0;2;1];
    adj[;4]+:g3[0;2;3];
    adj[0;]+:g3[0;1;2];
    adj[4;]+:g3[0;3;2];
    adj[2;1]+:sum g3[2;;0];
    adj[2;3]+:sum g3[2;;4];
    adj[1;2]+:sum g3[2;0;];
    adj[3;2]+:sum g3[2;4;];
    adj[2;2]:0;
    a:(a and adj=1)or(not[a] and (adj>=1) and adj<=2);
    a};

d24p2:{[c;x]
    a:"#"="\n"vs x;
    empty:a<>a;
    gs:enlist a;
    do[c;
        gs:(2#enlist empty),gs,2#enlist empty;
        gs:.d24.updGrid each 3#/:til[count[gs]-2]_\:gs;
        while[0=sum sum first gs; gs:1_gs];
        while[0=sum sum last gs; gs:-1_gs];
    ];
    sum sum sum gs};

//d24p1"#####\n.#.##\n#...#\n..###\n#.##."
//d24p2[200;"#####\n.#.##\n#...#\n..###\n#.##."]

/
OVERVIEW:

We generate the number of neighbors of each cell. For part 1 this is dune using vector
shifting and adding the planes together. For part 2 the neighbors from adjacent layers
are added in. To do this we first add 2 empty planes at the beginning and end of the
plane list, then run the same function on each 3-long slice of the resulting list.
We also cut off the empty planes at the ends to avoid the list growing too quickly.
