d5:{0b sv/:(6#0b),/:("FBLR"!0101b)"\n"vs x};
d5p1:{max d5[x]};
d5p2:{s:asc d5[x];-1+s last where 1<deltas s};

/
d5p1 x:"BFFFBBFRRR\nFFFBBBFRRR\nBBFFBBFRLL"

BREAKDOWN:
The idea is that the seat identifiers are simply a binary number representing the seat number,
with F and L standing for 0 and B and R standing for 1.

COMMON:
We cut the input into lines:
q)"\n"vs x
"BFFFBBFRRR"
"FFFBBBFRRR"
"BBFFBBFRLL"

We use the dictionary "FBLR"!0101b to map each letter to the corresponding binary digit.
q)("FBLR"!0101b)"\n"vs x
1000110111b
0001110111b
1100110100b

We add 6 zeros at the beginning to pad these to the nearest available integer type, which as 16
bits.
q)(6#0b),/:("FBLR"!0101b)"\n"vs x
0000001000110111b
0000000001110111b
0000001100110100b

Then we use the magic "0b sv" operator to turn the boolean lists into the corresponding integers.
q)0b sv/:(6#0b),/:("FBLR"!0101b)"\n"vs x
567 119 820h

This logic will be the function d5.

PART 1:

The answer is the maximum of this list.
q)max d5[x]
820h

PART 2:
(Using my own input for the demo)
We get the list of integer seat numbers again:
q)d5[x]
807 411 175 87 819 594 503 33 657 195 512 292 149 471 ..

We put them in ascending order:
q)s:asc d5[x]
q)s
`s#12 13 14 15 16 17 18 19 20 21 22 23 24 25 ..

Now we need to find a break in the middle of the list. We use "deltas" to generate the differences
between consecutive elements:
q)deltas s
12 1 1 1 1 1 1 1 1 1 1 1 1 ..

There should be another number that is greater than 1 somewhere:
q)where 1<deltas s
0 628

The first element is greater than 1 because the seat numbers don't start with 1 but we only need
the second number:
q)last where 1<deltas s
628

Using this as an index into the list reveals the number after the jump:
q)s last where 1<deltas s
641h

So the answer is one less than this number:
q)-1+s last where 1<deltas s
640
