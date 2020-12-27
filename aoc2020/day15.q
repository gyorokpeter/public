d15:{[n;x]ns:"J"$","vs x;
    arr:(1+max[ns])#0N;
    arr[-1_ns]:1+til count[ns]-1;
    c:n-count ns;
    num:last ns;
    step:count[ns];
    do[c;
        nxt:0^step-arr[num];
        if[count[arr]<=num;arr,:num#0N];
        arr[num]:step;
        num:nxt;
        step+:1;
    ];
    num};
d15p1:{d15[2020;x]};
d15p2:{d15[30000000;x]};

/
d15p1 x:"0,3,6"
d15p1 x:"1,3,2"
d15p1 x:"2,1,3"
d15p1 x:"1,2,3"
d15p1 x:"2,3,1"
d15p1 x:"3,2,1"
d15p1 x:"3,1,2"

d15p2 x:"0,3,6"

OVERVIEW:

BOTH PARTS:
We use an array to keep track of which number was said on which turn. I made sure that the turn
numbers are human-friendly for easier debugging. We start with an array big enough for the highest
number and whenever we want to say a number that doesn't fit into the array we simply add as many
elements as that number. Doubling the size is sometimes not enough.

This puzzle is a killer because of the sequential array operations which are simply not possible
to express in any way that makes it faster.