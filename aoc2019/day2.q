d2:{[a;n;v]
    a[1 2]:(n;v);
    ip:0;
    while[a[ip]<>99;
        $[a[ip]=1; [a[a ip+3]:a[a ip+1]+a[a ip+2]; ip+:4];
          a[ip]=2; [a[a ip+3]:a[a ip+1]*a[a ip+2]; ip+:4];
          '"invalid op"
        ];
    ];
    a[0]};
d2p1:{a:"J"$","vs x; d2[a;12;2]};
d2p2:{a:"J"$","vs x; 
    b:til[100]d2[a]/:\:til[100];
    c:first raze til[100],/:'where each b=19690720;
    (100*c[0])+c[1]};

//d2p1"1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,5,19,23,1,6,23,27,1,27,10,31,1,31,5,35,2,10,35,39,1,9,39,43,1,43,5,47,1,47,6,51,2,51,6,55,1,13,55,59,2,6,59,63,1,63,5,67,2,10,67,71,1,9,71,75,1,75,13,79,1,10,79,83,2,83,13,87,1,87,6,91,1,5,91,95,2,95,9,99,1,5,99,103,1,103,6,107,2,107,13,111,1,111,10,115,2,10,115,119,1,9,119,123,1,123,9,127,1,13,127,131,2,10,131,135,1,135,5,139,1,2,139,143,1,143,5,0,99,2,0,14,0"

/
OVERVIEW:
This task is uninteresting from a q perspective. It is simply an exercise in
comparing numbers and setting elements in arrays.
For part two we use /:\: to call the interpreter with every pairing of the numbers
from 0 to 99. Then we search for our input in the resulting matrix and prepend the
row number to get the exact coordinates. The answer is then the first coordinate
multipled by 100 and then adding the second coordinate.

WHITEBOXING?
There is no point in whiteboxing today's program.
It starts by doing some dummy operations on address 3, then it grabs the content of
address 1, does a sequence of operations on it by either adding or multiplying
1, 2, 3, 4 or 5 (these come from addresses 5, 6, 9, 10, 13 respectively - due to the
lack of immediate mode which is introduced on day 5 they need to be in memory), then
finally it adds the number at address 2. Finding out the order and arguments to these
operations is equivalent to making a basic intcode interpreter.
Interestingly there is a dummy multiply instruction after the HLT. This is probably
to ensure that the HLT instruction actually stops the program. Otherwise the
multiplication will overwrite the answer with zero.
