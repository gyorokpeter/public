d11p1:{max abs sum(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x}

d11p1"ne,ne,ne" //3
d11p1"ne,ne,sw,sw" //0
d11p1"ne,ne,s,s" //2
d11p1"se,sw,se,sw,sw"   //3

d11p2:{max max each abs sums(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x}

d11p2"ne,ne,ne" //3
d11p2"ne,ne,sw,sw" //2
d11p2"ne,ne,s,s" //2
d11p2"se,sw,se,sw,sw"   //3

/
BREAKDOWN:

q)x:"se,sw,se,sw,sw"
First we split the string on commas and turn each piece into a symbol.
q)`$","vs x
`se`sw`se`sw`sw
Next we use a mapping to the coordinate changes each step leads to.
See  https://www.redblobgames.com/grids/hexagons/ for an explanation on hexagonal coordinates
(the section "Distances/Cube coordinates" is most relevant here)
q)(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x
1  -1 0
-1 0  1
1  -1 0
-1 0  1
-1 0  1

Part 1:
The sum function works component-wise, so we will get the coordinate of the final position.
q)sum(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x
-1 -2 3
Since we are looking for the distance from the origin, the result is just the highest
absolute value among the 3 coordinates.
q)max abs sum(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x
3

Part 2:
We use sums instead of sum to get a list of every visited position:
q)sums(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x
1  -1 0
0  -1 1
1  -2 1
0  -2 2
-1 -2 3
This time we want the max of each position (row) rather than each coordinate (column), so we use "max each".
q)max each abs sums(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x
1 1 2 2 3
The maximum of this list is the furthest distance visited.
q)max max each abs sums(`n`ne`se`s`sw`nw!(0 1 -1;1 0 -1;1 -1 0;0 -1 1;-1 0 1;-1 1 0))`$","vs x
3
