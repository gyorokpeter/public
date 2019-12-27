.intcode.debug:0b;
intcode:{[a;input]
    output:();
    $[a[0]~`pause;
        [ip:a[1];tp:a[2];input:a[4],input;a:a[3]];
        [ip:0;tp:0]
    ];
    run:1b;
    while[run;
        op:a[ip] mod 100;
        argc:(1 2 3 4 5 6 7 8 99!3 3 1 1 2 2 3 3 0)op;
        if[.intcode.debug;-1 string[ip],": "," "sv string a[ip+til 1+argc]];
        if[null argc; '"invalid op ",string[op]];
        argm:argc#(a[ip] div 100 1000 10000)mod 10;
        argv0:a[ip+1+til argc];
        argv:?[argm=1;argv0;a argv0];
        $[op=1; [a[argv0 2]:argv[0]+argv[1]; ip+:1+argc];
          op=2; [a[argv0 2]:argv[0]*argv[1]; ip+:1+argc];
          op=3;[$[tp>=count input; :(`pause;ip;0;a;0#input;output);
            [a[argv0 0]:input[tp]; tp+:1; ip+:1+argc]]];
          op=4; [output,:argv 0; ip+:1+argc];
          op=5; $[argv[0]<>0; ip:argv 1; ip+:1+argc];
          op=6; $[argv[0]=0; ip:argv 1; ip+:1+argc];
          op=7; [a[argv0 2]:0+argv[0]<argv[1]; ip+:1+argc];
          op=8; [a[argv0 2]:0+argv[0]=argv[1]; ip+:1+argc];
          op=99; run:0b;
          '"invalid op"
        ];
    ];
    output};

perms:{$[0=count x;enlist x;raze x,/:'.z.s each x except/:x]};
d7p1:{a:"J"$","vs x;
    p:perms til 5;
    p2:0(;)/:p;
    rs:first each{[a;ir]$[0=count ir 1;ir;(first intcode[a;(first ir[1]),ir[0]];1_ir 1)]}[a]/'[p2];
    max rs};
d7p2:{
    a:"J"$","vs x;
    ps:perms 5+til 5;
    s:5#enlist a;
    run:{{[x]
        if[1=count x;:x];
        s:x 0;i:x 1;p:x 2;f:x 3;
        s[i]:intcode[s[i];$[0<count p;1#p;()],f];
        f:first last s[i];
        p:1_p;
        i:(1+i)mod 5;
        if[(i=0) and not`pause~first s[4]; :f];
        (s;i;p;f)
    }/[(x;0;y;0)]};
    rs:run[s]each ps;
    max rs};


d7p1whitebox:{
    a:"J"$","vs x;
    jmptbl:10#10_a;
    prgs:reverse each 2 cut/:(-3_/:2_/:5#jmptbl cut a)except\:9;
    oper:(::;+;*)prgs[;;0]mod 10;
    arg:prgs[;;1];
    fns:{('[;])/[x]}each oper@''arg;
    p:perms til 5;
    max {{y x}/[0;x]}each fns p};

d7p2whitebox:{
    a:"J"$","vs x;
    jmptbl:10#10_a;
    prgs:8 cut/:-1_/:-5#jmptbl cut a;
    oper:(::;+;*)prgs[;;2]mod 10;
    arg:raze each (2#/:/:3_/:/:prgs)except\:\:9;
    fns:oper@''arg;
    p:perms til 5;
    max {[fns;x]{y x}/[0;raze flip fns x]}[fns]each p};

//d7p1"3,8,1001,8,10,8,105,1,0,0,21,38,63,72,85,110,191,272,353,434,99999,3,9,102,4,9,9,101,2,9,9,102,3,9,9,4,9,99,3,9,1001,9,4,9,102,2,9,9,1001,9,5,9,1002,9,5,9,101,3,9,9,4,9,99,3,9,1001,9,2,9,4,9,99,3,9,1001,9,3,9,102,2,9,9,4,9,99,3,9,101,2,9,9,102,2,9,9,1001,9,2,9,1002,9,4,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99"

//d7p2whitebox x:"3,8,1001,8,10,8,105,1,0,0,21,38,63,72,85,110,191,272,353,434,99999,3,9,102,4,9,9,101,2,9,9,102,3,9,9,4,9,99,3,9,1001,9,4,9,102,2,9,9,1001,9,5,9,1002,9,5,9,101,3,9,9,4,9,99,3,9,1001,9,2,9,4,9,99,3,9,1001,9,3,9,102,2,9,9,4,9,99,3,9,101,2,9,9,102,2,9,9,1001,9,2,9,1002,9,4,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99"
//d7p2whitebox x:"3,8,1001,8,10,8,105,1,0,0,21,38,59,84,97,110,191,272,353,434,99999,3,9,1002,9,2,9,101,4,9,9,1002,9,2,9,4,9,99,3,9,102,5,9,9,1001,9,3,9,1002,9,5,9,101,5,9,9,4,9,99,3,9,102,5,9,9,101,5,9,9,1002,9,3,9,101,2,9,9,1002,9,4,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,4,9,99,3,9,102,5,9,9,1001,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99"

/
OVERVIEW:
More improvements to Intcode on this day. Part 1 can be done by the existing version from day 5 by
simply running each amplifier in sequence and using the output from each one to pass into the next.
For part 2 a new feature is needed to be able to run multiple instances in parallel. In particular
whenever an instance tries to read past the end of the input tape, it should block and "yield" to
allow more input to arrive. This blocking is implemented by changing the interpretation of both the
input and output of the intcode function. The return value will be a list of integers if the program
terminates, otherwise it will be a general list with `pause as its first element (therefore ret[0]
can be used to distinguish the two), followed by the instruction pointer, tape pointer, input tape,
the contents of the memory and the output. I took the opportunity to cut the input tape to empty
since we will never pause with non-empty input for now. Similarly when such a suspended state is
passed in as the first parameter to intcode, the state is resumed (thus executing the last input
instruction again) instead of starting with a fresh state. Keeping a list of multiple suspended
states also avoids the state sharing between multiple instances.
For part 2 some fiddling is also required to correctly tie the 5 instances together, as well as
passing in the initial input correcly (on the first round each amplifier needs its serial ID, plus
the first one needs an additional 0 input as the starting signal), then passing the output from each
amplifier to the next. This could be done with a while loop or the / iterator as I did. If the last
amplifier halts instead of suspending, a different type is returned to indicate that we should stop.
All of this needs to be done within an each on all of the permutations of til 5 or 5+til 5.
The permutations are generated using this recursive function:
perms:{$[0=count x;enlist x;raze x,/:'.z.s each x except/:x]};
This means for every eleement, generate all the permutations of the remaining elements and then
prepend the skipped element to the beginning of each. For an empty list we return an empty list
of permutations.

WHITEBOXING:
PART 1:
When the program starts, it reads in the "phase setting" which is actually an index into a jump
table that starts at address 10 and contains 10 addresses (5 for part 1 and 5 for part 2).
At each destination there is a small program that first inputs a value, then does some ADD/MUL
instructions between the number and small constants (2, 3, 4, 5) and outputs the result.
The whitebox solution looks like this:
First we get the jump table:
q)jmptbl:10#10_a
q)jmptbl
21 38 63 72 85 110 191 272 353 434
Then we get the first 5 programs by cutting the code on these indices, reversing them and trimming
off the beginning and ending housekeeping code, and dropping the 9's in the arguments such that
only the useful argument remains:
q)prgs:reverse each 2 cut/:(-3_/:2_/:5#jmptbl cut a)except\:9;
q)prgs
(102 3;101 2;102 4)
(101 3;1002 5;1001 5;102 2;1001 4)
,1001 2
(102 2;1001 3)
(101 2;1002 4;1001 2;102 2;101 2)

Then we assign either + or * depending on the last digit of the instruction:
q)oper:(::;+;*)prgs[;;0]mod 10
q)oper
(*;+;*)
(+;*;+;*;+)
,+
(*;+)
(+;*;+;*;+)

We extract the numeric arguments:
q)arg:prgs[;;1];
q)arg
3 2 4
3 5 5 2 4
,2
2 3
2 4 2 2 2

We use q's function composition operator with the / iterator to marry the operators
with the fixed operands, so each line becomes an actual invokable q object that
calculates the respective function:
q)fns:{('[;])/[x]}each oper@''arg;
q)fns
*[3]+[2]*[4]
+[3]*[5]+[5]*[2]+[4]
+[2]
*[2]+[3]
+[2]*[4]+[2]*[2]+[2]

(This is why the reverse was needed: the function returned by the composition operator
applies the first function on the result of the second, the opposite order we find them.)
We get the permutations as usual:
q)p:perms til 5;

But instead of running the intcode VM, we simply use our precomposed functions on each
permutation and take the maximum. Note that the / iterator is used to chain the functions,
and the body is the lambda {y x} since we have a list of functions which is a bit unusual.
q)max {{y x}/[0;x]}each fns p
17790

PART 2:
The program still uses the same lookup table, now using indices 5 to 9 to choose where
to jump. This time each program has 10 sequences of input-process-output instructions,
follwed by a halt. The processing instruction is always either add 1 or 2, or multiply
by 2. So overall each amplifier reads 10 inputs before halting.
We get the 5 programs used for part 2, remove the final HLT instruction, and cut each
program into 8 numbers (the length of each processing sequence):
q)jmptbl:10#10_a;
q)prgs:8 cut/:-1_/:-5#jmptbl cut a;
q)prgs
3 9 1002 9 2 9 4 9 3 9 102  2 9 9 4 9 3 9 101  2 9 9 4 9 3 9 101  2 9 9 4 9 3..
3 9 1001 9 1 9 4 9 3 9 102  2 9 9 4 9 3 9 1001 9 2 9 4 9 3 9 102  2 9 9 4 9 3..
3 9 1001 9 1 9 4 9 3 9 1001 9 1 9 4 9 3 9 1001 9 2 9 4 9 3 9 102  2 9 9 4 9 3..
3 9 1001 9 2 9 4 9 3 9 1002 9 2 9 4 9 3 9 101  1 9 9 4 9 3 9 102  2 9 9 4 9 3..
3 9 1002 9 2 9 4 9 3 9 101  1 9 9 4 9 3 9 101  2 9 9 4 9 3 9 101  1 9 9 4 9 3..

We figure out the operator by looking at index 2 in each small piece:
q)oper:(::;+;*)prgs[;;2]mod 10;
q)oper
* * + + + + * + + *
+ * + * + + * + + +
+ + + * * * * * + +
+ * + * + * * + * *
* + + + + * + * * +

We find the numeric arguments - they are at index 3 or 4, and they are not 9:
q)arg:raze each (2#/:/:3_/:/:prgs)except\:\:9;
q)arg
2 2 2 2 1 2 2 2 1 2
1 2 2 2 2 2 2 2 2 1
1 1 2 2 2 2 2 2 2 2
2 2 1 2 2 2 2 2 2 2
2 1 2 1 2 2 2 2 2 2

Like in part 1 we marry the operators with the operands, creating projections, however
this time we don't compose them:
q)fns:oper@''arg;
q)fns
*[2] *[2] +[2] +[2] +[1] +[2] *[2] +[2] +[1] *[2]
+[1] *[2] +[2] *[2] +[2] +[2] *[2] +[2] +[2] +[1]
+[1] +[1] +[2] *[2] *[2] *[2] *[2] *[2] +[2] +[2]
+[2] *[2] +[1] *[2] +[2] *[2] *[2] +[2] *[2] *[2]
*[2] +[1] +[2] +[1] +[2] *[2] +[2] *[2] *[2] +[2]

To execute these in the correct order, we need to go in columns from left to right.
This means we have to flip and raze this matrix, then the operations will be in the
right order. However we need the permutations first:
q)p:perms til 5;

We still permute the numbers of 0 to 4 as in part 1, not from 5 to 9 as in the
blackbox solution. The number offset of 5 is no longer relevant at this point.
Finally we iteratively apply the flipped and razed function list with a starting
value of 0 on each permutation and take the maximum:

q)max {[fns;x]{y x}/[0;raze flip fns x]}[fns]each p
19384820
