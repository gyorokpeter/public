d12p1:{m:{("J"$x[;0])!"J"$", "vs/:x[;1]}" <-> "vs/:trim each "\n"vs x;count{[m;x]asc distinct x,raze m x}[m]/[enlist 0]};

d12p1"0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5" //6

d12p1 inp

d12p2:{m:{("J"$x[;0])!"J"$", "vs/:x[;1]}" <-> "vs/:trim each "\n"vs x;
    g:0;
    while[0<count m;
        g+:1;
        grp:{[m;x]asc distinct x,raze m x}[m]/[enlist first key m];
        m:grp _m;
    ];
    g};

d12p2"0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5" //2

/
BREAKDOWN:

Input parsing:
The input is parsed into a dictionary with the left side of the "<->" as the key and the right side as the value.
The latter requires removing the commas between the numbers. I prefer using trim to allow indenting the input lines.
q)x:"0 <-> 2\n1 <-> 1\n2 <-> 0, 3, 4\n3 <-> 2, 4\n4 <-> 2, 3, 6\n5 <-> 6\n6 <-> 4, 5"
q)trim each "\n"vs x
trim each "\n"vs x
"0 <-> 2"
"1 <-> 1"
"2 <-> 0, 3, 4"
"3 <-> 2, 4"
"4 <-> 2, 3, 6"
"5 <-> 6"0| ,2
1| ,1
2| 0 3 4
3| 2 4
4| 2 3 6
5| ,6
6| 4 5
"6 <-> 4, 5"
q)" <-> "vs/:trim each "\n"vs x
,"0" ,"2"
,"1" ,"1"
,"2" "0, 3, 4"
,"3" "2, 4"
,"4" "2, 3, 6"
,"5" ,"6"
,"6" "4, 5"
q){("J"$x[;0])}" <-> "vs/:trim each "\n"vs x
0 1 2 3 4 5 6
q){"J"$", "vs/:x[;1]}" <-> "vs/:trim each "\n"vs x
,2
,1
0 3 4
2 4
2 3 6
,6
4 5
q)m:{("J"$x[;0])!"J"$", "vs/:x[;1]}" <-> "vs/:trim each "\n"vs x
q)m
0| ,2
1| ,1
2| 0 3 4
3| 2 4
4| 2 3 6
5| ,6
6| 4 5

Finding a group:
This uses the "converge" sense of the / adverb. We start with a single element and then
keep adding everything that is directly reachable from the already seen elements
until the result doesn't change. For example an intermediate step may look like:
q)x:0 2
q)m x
,2
0 3 4
q)raze m x
2 0 3 4
q)x,raze m x
0 2 2 0 3 4
q)distinct x,raze m x
0 2 3 4
q)asc distinct x,raze m x
`s#0 2 3 4
The whole is wrapped in a function and called with the / adverb:
q){[m;x]asc distinct x,raze m x}[m]/[enlist 0]
`s#0 2 3 4 5 6

Part 1:
We generate a group starting with item 0 and return the count.
q)count{[m;x]asc distinct x,raze m x}[m]/[enlist 0]
6

Part 2:
Instead of constantly using item 0, we take the first remaining key in the map.
After generating the group, we remove it from the map.
q)grp:{[m;x]asc distinct x,raze m x}[m]/[enlist first key m];
q)m:grp _m;
q)m
1| 1
This is done in a while loop. The loop exits when the map is empty. We keep track of the number of groups
generated so we can return it.
