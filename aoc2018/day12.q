x:read0`:d:/projects/github/public/aoc2018/d12.in;

d12step:{[rules;state]
    pos:-2+state 0;
    plants:"....",state[1],"....";
    gen:1+state 2;
    sect:4_{5#1_x,y}\[" ";plants];
    newplants:"."^rules sect;
    ends:{(first x;last x)}where "#"=newplants;
    pos+:ends 0;
    newplants2:ends[0]_(1+ends[1])#newplants;
    posDelta:pos-state 0;
    changed:not state[1]~newplants2;
    state:(pos;newplants2;gen;posDelta;changed);
    state};

d12p1:{
    init:last" "vs first x;
    rules:{x[;0]!x[;1;0]}" => "vs/:2_x;
    state:(0;init;0;0;1b);
    endstate:d12step[rules]/[20;state];
    sum endstate[0]+where "#"=endstate 1};
d12p2:{
    init:last" "vs first x;
    rules:{x[;0]!x[;1;0]}" => "vs/:2_x;
    state:(0;init;0;0;1b);
    endstate:d12step[rules]/[last;state];
    limit:50000000000;
    gensLeft:limit-endstate 2;
    endpos:endstate[0]+gensLeft*endstate 3;
    sum endpos+where "#"=endstate 1};

/
x:"\n"vs"initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #"
\

d12p1 x
d12p2 x
