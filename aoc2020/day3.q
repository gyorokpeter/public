d3:{[map;slope]"j"$sum"#"=map ./:(reverse[slope]*/:til count[map]div slope 1) mod\:(count map;count map 0)};
d3p1:{map:"\n"vs x;d3[map;3 1]};
d3p2:{map:"\n"vs x;prd d3[map]each(1 1;3 1;5 1;7 1;1 2)};

/
d3p1 x:"..##.......\n"
      ,"#...#...#..\n"
      ,".#....#..#.\n"
      ,"..#.#...#.#\n"
      ,".#...##..#.\n"
      ,"..#.##.....\n"
      ,".#.#.#....#\n"
      ,".#........#\n"
      ,"#.##...#...\n"
      ,"#...##....#\n"
      ,".#..#...#.#"

BREAKDOWN:

COMMON:
This part calculates a path using a given slope. For example:
q)map:"\n"vs x
q)slope:3 1

I prefer to think of coordinates as (x;y) but in the map they are actually in the opposite order.
To generate the coordinates we multiply the slope by 0, 1, ... up to height-1. But the height
might not be the height of the map if the second component of the slope is not 1.
q)count[map]div slope 1
11

"til" generates a list of integers:
q)til count[map]div slope 1
0 1 2 3 4 5 6 7 8 9 10

Then we multiply each of these with the slope. This requires /: (each-right) since the thing we
are multiplying is a list itself.
q)reverse[slope]*/:til count[map]div slope 1
0  0
1  3
2  6
3  9
4  12
5  15
6  18
7  21
8  24
9  27
10 30

The coordinates go off the map, but we can make them wrap around using modulo.
q)(reverse[slope]*/:til count[map]div slope 1) mod\:(count map;count map 0)
0  0
1  3
2  6
3  9
4  1
5  4
6  7
7  10
8  2
9  5
10 8

Then we index into the map using the coordinates:
q)map ./:(reverse[slope]*/:til count[map]div slope 1) mod\:(count map;count map 0)
"..#.##.####"

The answer is the number of elements equal to "#" so we just compare and sum up the booleans.
q)"#"=map ./:(reverse[slope]*/:til count[map]div slope 1) mod\:(count map;count map 0)
00101101111b
q)sum"#"=map ./:(reverse[slope]*/:til count[map]div slope 1) mod\:(count map;count map 0)
7i

PART 1:
We call the function above with the slope "3 1".
q)d3[map;3 1]
7

PART 2:
We call the function with each of the given slopes.
q)d3[map]each(1 1;3 1;5 1;7 1;1 2)
2 7 3 4 2

The answer is the product of this list.
q)prd d3[map]each(1 1;3 1;5 1;7 1;1 2)
336
