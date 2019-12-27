d12p1:{[x;step]
    p:"J"$last each/:"="vs/:/:","vs/:-1_/:1_/:"\n"vs x;
    v:count[p]#enlist 0 0 0;
    pv:{[pv]
        dv:sum each signum pv[0]-\:/:pv[0];
        (pv[0]+pv[1]+dv;pv[1]+dv)
    }/[step;(p;v)];
    sum prd sum each/:abs pv};

//d12p1["<x=9, y=13, z=-8>\n<x=-3, y=16, z=-17>\n<x=-4, y=11, z=-10>\n<x=0, y=-2, z=-2>";1000]

d12a:{[p]
    path:{[pv]
        dv:sum each signum pv[0]-\:/:pv[0];
        (pv[0]+pv[1]+dv;pv[1]+dv)
    }\[(p;count[p]#0)];
    count path};

gcd:{$[x<0;.z.s[neg x;y];x=y;x;x>y;.z.s[y;x];x=0;y;.z.s[x;y mod x]]};
lcm:{(x*y)div gcd[x;y]};

d12p2:{
    p:"J"$last each/:"="vs/:/:","vs/:-1_/:1_/:"\n"vs x;
    lcm/[d12a each flip p]};

//d12p2["<x=9, y=13, z=-8>\n<x=-3, y=16, z=-17>\n<x=-4, y=11, z=-10>\n<x=0, y=-2, z=-2>"]

/
OVERVIEW:
This is straightforward simulation. To calculate the velocity differences we take the
signum of the difference between each pair of planets and add them for each planet.
For part 1 we use the / iterator with a step count as we know upfront how many times
we have to iterate. 
For part 2 we use a helper function that is similar to the one in part 1 but it uses
\ and the "repeat until no change" sense (which will also stop if we return to the
initial value). Since we get back a list of all the values, we take the count of them
to get the period. The trick is to call this function on each coordinate separately,
since they are independent so their periods may be determined individually and then
the overall period is the least common multiple of the coordinates' periods.
