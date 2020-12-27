mulInv:{[a;b]
    if[b=1; :1];
    b0:b; x0:0; x1:1;
    while[a>1;
        q:a div b;
        t:b; b:a mod b; a:t;
        t:x0; x0:x1-q*x0; x1:t;
    ];
    if[x1<0; x1+:b0];
    x1};
//eqs:list of (n;a) pairs where x === a (mod n)
lc:{[eqs]
    prod:prd eqs[;0];
    p:prod div eqs[;0];
    sum[eqs[;1]*mulInv'[p;eqs[;0]]*p]mod prod};
d13p1:{
    p:"\n"vs x;
    st:"J"$p 0;
    per:("J"$","vs p 1)except 0N;
    nxt:neg[st] mod per;
    take:first where nxt=min nxt;
    nxt[take]*per[take]};
d13p2:{
    p:"\n"vs x;
    per:"J"$","vs p 1;
    ind:where not null per;
    per2:per ind;
    lc[per2,'neg[ind]mod per2]};

/
d13p1 x:"939\n7,13,x,x,59,x,31,19"
d13p2 x:"x\n7,13,x,x,59,x,31,19"
d13p2 x:"x\n17,x,13,19"
d13p2 x:"x\n67,7,59,61"
d13p2 x:"x\n67,x,7,59,61"
d13p2 x:"x\n67,7,x,59,61"
d13p2 x:"x\n1789,37,47,1889"

OVERVIEW:

PART 1:
We use the modulo operator to find the next departure of each bus and find the minimum of the
results.

PART 2:
I wanted to reuse the chinese remainder theorem implementation from 2016 day 15 but it turned out
that the code had an integer overflow problem. So I looked up another algorithm and recoded it in
q. Apart from being able to use vector operations on some parts it's not very interesting.
