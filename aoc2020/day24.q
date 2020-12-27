d24:{ins:"J"$/:/:ssr/[;("ne";"nw";"sw";"se";"e";"w");"124503"]each"\n"vs x;
    where 1=(count each group sum each(1 0;1 1;0 1;-1 0;-1 -1;0 -1)ins)mod 2};
d24p1:{count d24 x};
d24p2:{c:d24 x;
    st:{[c]
        nb:raze(1 0;1 1;0 1;-1 0;-1 -1;0 -1)+/:\:c;
        nbs:count each group nb;
        (c inter where nbs within 1 2) union ((where 2=nbs) except c)}/[100;c];
    count st};

/
d24p1 x:"\n"sv("sesenwnenenewseeswwswswwnenewsewsw"
              ;"neeenesenwnwwswnenewnwwsewnenwseswesw"
              ;"seswneswswsenwwnwse"
              ;"nwnwneseeswswnenewneswwnewseswneseene"
              ;"swweswneswnenwsewnwneneseenw"
              ;"eesenwseswswnenwswnwnwsewwnwsene"
              ;"sewnenenenesenwsewnenwwwse"
              ;"wenwwweseeeweswwwnwwe"
              ;"wsweesenenewnwwnwsenewsenwwsesesenwne"
              ;"neeswseenwwswnwswswnw"
              ;"nenwswwsewswnenenewsenwsenwnesesenew"
              ;"enewnwewneswsewnwswenweswnenwsenwsw"
              ;"sweneswneswneneenwnewenewwneswswnese"
              ;"swwesenesewenwneswnwwneseswwne"
              ;"enesenwswwswneneswsenwnewswseenwsese"
              ;"wnwnesenesenenwwnenwsewesewsesesew"
              ;"nenewswnwewswnenesenwnesewesw"
              ;"eneswnwswnwsenenwnwnwwseeswneewsenese"
              ;"neswnwewnwnwseenwseesewsenwsweewe"
              ;"wseweeenwnesenwwwswnew")

OVERVIEW:

PART 1:
To represent a hexagonal grid we use the standard coordinate system but with the y axis tilted to
the left, so positive y becomes "nw" and negative y becomes "se". To parse the input we use ssr to
replace each direction with a number from 0 to 5, but starting with the two-letter ones to avoid
chopping them in half by prematurely replacing any "e" or "w". Then we map the numbers to the
coordinate changes and sum them up to find up the final coordinates where they end up. The answer
to part 1 is the number of coordinates that appear an odd number of times on the list of sums.

PART 2:
We generate the coordinates like in part 1. Then the simulation is much like day 17 where we only
keep track of the coordinates, except that the coordinates of the neighbors are now calculated
with a different set of offsets.