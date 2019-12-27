d14:{[t;fuel]
    queue:enlist[`FUEL]!enlist fuel;
    totalOre:0;
    storage:(`$())!`long$();
    while[0<count queue;
        canUse:0^(key[queue]#storage)&queue;
        queue-:canUse;
        storage-:canUse;
        queue:(where queue>0)#queue;
        nxts:update mult:value queue from 0!([]rt:key queue)#t;
        nxts2:update pq:ceiling mult%rq from nxts;
        nxts3:update mats:.[mats;(::;::;0);*;pq] from nxts2;
        nxts4:((`$())!`long$()),sum .[{enlist[y]!enlist[x]}]each exec raze mats from nxts3;
        storage+:(exec rt!pq*rq from nxts3)-queue;
        totalOre+:0^nxts4`ORE;
        queue:`ORE _nxts4;
        ];
    totalOre};

d14p1:{
    a:"JS"$/:/:/:" "vs/:/:/:", "vs/:/:" => "vs/:"\n"vs x;
    t:([rt:a[;1;0;1]]rq:a[;1;0;0];mats:a[;0]);
    d14[t;1]};

d14p2:{
    totalOre:1000000000000;
    a:"JS"$/:/:/:" "vs/:/:/:", "vs/:/:" => "vs/:"\n"vs x;
    t:([rt:a[;1;0;1]]rq:a[;1;0;0];mats:a[;0]);
    u:0; v:1;
    while[d14[t;v]<totalOre; v*:2];
    while[u<=v;
        d:u+(v-u)div 2;
        r:d14[t;d];
        $[r<=totalOre; u:d+1; v:d-1];
    ];
    v};

//d14p1"11 RVCS => 8 CBMDT\n29 QXPB, 8 QRGRH => 8 LGMKD\n3 VPRVD => 6 PMFZG\n1 CNWNQ, 11 MJVXS => 6 SPLM\n13 SPDRZ, 13 PMFZG => 2 BLFM\n8 QWPFN => 7 LWVB\n1 SPLM => 8 TKWQ\n2 QRGRH, 6 CNWNQ => 7 DTZW\n2 DMLT, 1 SPLM, 1 TMDK => 9 NKNS\n1 MJVXS, 1 HLBV => 7 PQCQH\n1 JZHZP, 9 LWVB => 7 MJSCQ\n29 DGFR => 7 QRGRH\n14 XFLKQ, 2 NKNS, 4 KMNJF, 3 MLZGQ, 7 TKWQ, 24 WTDW, 11 CBMDT => 4 GJKX\n4 TKWQ, 1 WLCFR => 4 PDKGT\n2 NKNS => 4 GDKL\n4 WRZST => 9 XFLKQ\n19 DGFR => 4 VPRVD\n10 MJSCQ, 4 QWPFN, 4 QXPB => 2 MLZGQ\n1 JZHZP => 7 QWPFN\n1 XFLKQ => 9 FQGVL\n3 GQGXC => 9 VHGP\n3 NQZTV, 1 JZHZP => 2 NVZWL\n38 WLCFR, 15 GJKX, 44 LGMKD, 2 CBVXG, 2 GDKL, 77 FQGVL, 10 MKRCZ, 29 WJQD, 33 BWXGC, 19 PQCQH, 24 BKXD => 1 FUEL\n102 ORE => 5 DGFR\n17 NWKLB, 1 SBPLK => 5 HRQM\n3 BWXGC => 8 TQDP\n1 TQDP => 2 PSZDZ\n2 MJVXS => 9 WNXG\n2 NBTW, 1 HRQM => 2 SVHBH\n8 CNWNQ, 1 DTZW => 4 RVCS\n4 VHGP, 20 WNXG, 2 SVHBH => 3 SPDRZ\n110 ORE => 5 TXMC\n10 QRGRH => 5 NWKLB\n1 SBPLK => 3 MJVXS\n9 DGFR => 5 RFSRL\n5 LBTV => 3 DMLT\n1 NWKLB, 1 KMNJF, 1 HDQXB, 6 LBTV, 2 PSZDZ, 34 PMFZG, 2 SVHBH => 2 WJQD\n1 RVCS => 5 MKRCZ\n14 NQZTV, 3 FPLT, 1 SJMS => 2 GQGXC\n18 RFSRL, 13 VHGP, 23 NBTW => 5 WTDW\n1 VHGP, 6 TKWQ => 7 QXPB\n1 JZHZP, 1 CNWNQ => 5 KMNJF\n109 ORE => 9 BWXGC\n2 CNWNQ, 1 PDKGT, 2 KMNJF => 5 HDQXB\n1 PDKGT, 18 WRZST, 9 MJSCQ, 3 VHGP, 1 BLFM, 1 LGMKD, 7 WLCFR => 2 BKXD\n11 MLJK => 6 FPLT\n8 DGFR, 2 TXMC, 3 WJRC => 9 SJMS\n2 SBPLK => 1 LBTV\n22 QWPFN => 4 WRZST\n5 WRZST, 22 WNXG, 1 VHGP => 7 NBTW\n7 RVCS => 9 TMDK\n1 DGFR, 14 TXMC => 5 JZHZP\n2 JZHZP => 3 SBPLK\n19 PDKGT => 8 HLBV\n195 ORE => 6 WJRC\n6 GQGXC => 8 CNWNQ\n1 NVZWL, 4 GQGXC => 2 CBVXG\n1 NVZWL, 1 KMNJF => 8 WLCFR\n153 ORE => 4 MLJK\n1 BWXGC => 6 NQZTV"

/
OVERVIEW / semi-breakdown:

The input is deeply nested so we need a lot of each-right (/:) during input parsing.
a:"JS"$/:/:/:" "vs/:/:/:", "vs/:/:" => "vs/:"\n"vs x;
The parsed input is put in a table with the output type (rt), output count (rq) and
the required materials (mats).
t:([rt:a[;1;0;1]]rq:a[;1;0;0];mats:a[;0]);
In other languages this simulation might best be done using recursion. However q doesn't
like recursion as flow control structure (there is a 2000 stack limit). So we use a
top-down solution instead.
We maintain a queue (what we need) and a storage (what we have as a by-product).
Queue starts at the number of fuel we need. Storage starts out empty.

During every iteration:
We check if any item in the storage can be used to fulfill any needs.
canUse:0^(key[queue]#storage)&queue;
queue-:canUse;
storage-:canUse;
queue:(where queue>0)#queue;

We fetch the rules corresponding to the items we need and add the needed number as a
new column (mult).
nxts:update mult:value queue from 0!([]rt:key queue)#t;

We find out how many times we need to use the recipe (pq).
nxts2:update pq:ceiling mult%rq from nxts;

We multiply the materials by the number of times the recipe was used.
nxts3:update mats:.[mats;(::;::;0);*;pq] from nxts2;

We convert the material lists to dictionaries and add them together.
nxts4:((`$())!`long$()),sum .[{enlist[y]!enlist[x]}]each exec raze mats from nxts3;

We add any excess materials produced to storage.
storage+:(exec rt!pq*rq from nxts3)-queue;

We add the amount of ore produced to the ongoing total.
totalOre+:0^nxts4`ORE;

We remove the ORE element to avoid problems and take the next set of needed materials:
queue:`ORE _nxts4;

Notice that the entire queue is replaced in each iteration. This is characteristic to
well-written "vector BFS" in q. Other languages would process element after element.

At the end of the iteration, we return the accumulated ore amount.

PART 1:
We do the above simulation for 1 fuel.

PART 2:
We do a binary search using the familiar formula, plugging in the simulation for
retrieving the value:
u:0; v:1;
while[d14[t;v]<totalOre; v*:2];
while[u<=v;
    d:u+(v-u)div 2;
    r:d14[t;d];
    $[r<=totalOre; u:d+1; v:d-1];
];
After this, v will contain the highest argument for which ore is less than or equal to totalOre.
