d10p1:{prd count each group 3,deltas asc"J"$"\n"vs x};
d10p2:{
    a:asc"J"$"\n"vs x;
    b:0,a,3+last a;
    c:{[b;s]if[s[0]>=count[b]-1;:s];s[1;s[0]+1+til(b binr b[s 0]+4)-1+s 0]+:s[1;s 0];(s[0]+1;s[1])}[b]/[(0;1,(count[b]-1)#0)];
    last last c};

/

d10p2 x:"16\n10\n15\n5\n1\n11\n7\n19\n6\n12\n4"
d10p2 x:"28\n33\n18\n42\n31\n14\n46\n20\n48\n47\n24\n23\n49\n45\n19\n38\n39\n11\n1\n32\n25\n35\n8\n17\n7\n9\n4\n2\n34\n10\n3"

BREAKDOWN:

PART 1:
We parse the integers:
q)"J"$"\n"vs x
16 10 15 5 1 11 7 19 6 12 4

We put them in ascending order:
q)asc"J"$"\n"vs x
`s#1 4 5 6 7 10 11 12 15 16 19

We use deltas to find the consecutive differences:
q)deltas asc"J"$"\n"vs x
1 3 1 1 1 3 1 1 3 1 3

We add a 3 to account for the required output:
q)3,deltas asc"J"$"\n"vs x
3 1 3 1 1 1 3 1 1 3 1 3

We check the amount of each number in this list. This is the very common "count each group" idiom.
q)count each group 3,deltas asc"J"$"\n"vs x
3| 5
1| 7

The answer is the product of the counts.
q)prd count each group 3,deltas asc"J"$"\n"vs x
35

OVERVIEW:

PART 2:
An ugly iterative solution that fills up an array with the number of possibilities. It finds the
cutting point up to which the current adapter can be used (therefore changing the puzzle such that
the maximum joltage difference between two adapters is different would be just changing a single
number - note that it's the 4 in the code, for binary search to work correctly). The array is
filled forward and values can increase multiple times in different iterations. Here is an example
of how the array fills up, with the square brackets indicating the current iteration (s[0]).

 0 1 4 5 6 7 10 11 12 15 16 19 22
[1]0 0 0 0 0  0  0  0  0  0  0  0
 1[1]0 0 0 0  0  0  0  0  0  0  0
 1 1[1]0 0 0  0  0  0  0  0  0  0
 1 1 1[1]1 1  0  0  0  0  0  0  0
 1 1 1 1[2]2  0  0  0  0  0  0  0
 1 1 1 1 2[4] 0  0  0  0  0  0  0
 1 1 1 1 2 4 [4] 0  0  0  0  0  0
 1 1 1 1 2 4  4 [4] 4  0  0  0  0
 1 1 1 1 2 4  4  4 [8] 0  0  0  0
 1 1 1 1 2 4  4  4  8  8  0  0  0


