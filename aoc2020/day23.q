d23:{[cups;moves;rlen;rmode;x]
    c:-1+"J"$/:x;
    c,:count[c]_til cups;
    right:c((c?til count c)+1)mod count c;
    curr:first c;
    round:0;
    do[moves;
        round+:1;
        move:1_right\[3;curr];
        dest:first ((curr-1+til 4)mod count c)except move;
        after:right last move;
        aftd:right dest;
        right[(curr;dest;last move)]:(after;first move;aftd);
        curr:right curr;
        if[0=round mod 10000; show round];
    ];
    $[rmode=`mult;prd;raze string@]1+1_right\[$[0=rlen;count[c]-1;rlen];0]};
d23p1:{d23[0;100;0;`str;x]};
d23p2:{d23[1000000;10000000;2;`mult;x]};

/
d23p1 x:"389125467"
d23p1 x:"496138527"

d23p2 x:"389125467"
d23p2 x:"496138527"

OVERVIEW:

A generic function takes care of both parts. It takes a couple of parameters to control the
behavior:
- cups: the number of cups, used to expand the list if the input is too short (part 2 only)
- moves: the number of moves
- rlen: how many cups to check when returning the result, 0 means all but "1"
- rmode: `mult multiplies the checked cups together, `str converts them to string
- x: the input as a string

The core logic is the same for both parts, the parameters only matter for the setup and the
returning of the result. We use an array to represent the right neighbor of each cup. We decrease
the cup numbers by one to avoid leaving a gap in the array. With this representation each step
takes constant time since we only need to update 3 numbers in the array: the next cup after the
current cup, the last of the moved cups and the destination cup.
Still this ends up being a killer with a large number of moves, since there is no way to further
optimize the sequential array updates.
