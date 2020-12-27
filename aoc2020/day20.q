d20:{
    ts:("\n"vs/:"\n\n"vs x)except\:enlist"";
    tid:"J"$-1_/:last each" "vs/:first each ts;
    tc:1_/:ts;
    tco:enlist[`...]!enlist tc;
    tco[`f..]:flip each tc;
    tco[`.r.]:reverse each tc;
    tco[`fr.]:reverse each tco[`f..];
    tco[`..m]:reverse each/:tco[`...];
    tco[`.rm]:reverse each/:tco[`.r.];
    tco[`f.m]:reverse each/:tco[`f..];
    tco[`frm]:reverse each/:tco[`fr.];
    tw:count tc[0;0];
    mw:`long$sqrt count tid;
    align:{a:(x{c:count y;til[c],/:'where each (x~/:\:y) and til[c]<>/:\:til[c]}/:\:y);
        (enlist[(`;0N)]!enlist()),exec t by s from{([]s:x[;0 2];t:x[;1 3])}raze raze raze{key[x],/:'''value x}{key[x],/:''value x}each a};
    nr:align[tco[;;;tw-1];tco[;;;0]];
    nd:align[tco[;;tw-1];tco[;;0]];
    queue:(enlist each key[nr] inter key[nd]),\:(count[tc]-1)#enlist[()];
    while[0<count queue;
        nl:where ()~/:first queue;
        if[0=count nl;
            :(mw;tid;queue;tco);
        ];
        ni:nl first where{x=min x}(nl div mw)+nl mod mw;
        poss:$[(0<ni mod mw) and 0<ni div mw; nr[queue[;ni-1]]inter'nd queue[;ni-mw];
            0<ni mod mw; nr queue[;ni-1];
            0<ni div mw; nd queue[;ni-mw];
            '"???"];
        //not filtering for repeated tiles as it was not needed for my input
        queue:raze@[;ni;:;]/:'[queue;poss];
    ];
    '"not found"};
d20p1:{r:d20 x;mw:r 0;prd r[1]r[2;0;;1](0;mw-1;mw*mw-1;(mw*mw)-1)};
d20p2:{r:d20 x;
    mw:r 0;
    queue:r 2;
    tco:(-1_/:/:/:1_/:/:/:-1_/:/:1_/:/:r 3);
    imgs:{[tco;mw;x]raze raze each/:flip each mw cut tco ./:x}[tco;mw]each queue;
    pattern:("                  # ";
             "#    ##    ##    ###";
             " #  #  #  #  #  #   ");
    pattern2:where each"#"=pattern;
    findMonster:{[pw;pattern2;img]
        m:{[pw;img;p2]where each all each/:"#"=img@/:\:(p2+/:til[count[img 0]-pw])}[pw]'[0 1 2_'img,/:(();enlist"";("";""));pattern2];
        count raze (inter')/[m]}[count pattern 0;pattern2];
    monster:max findMonster each imgs;
    (sum sum imgs[0]="#")-monster*count raze pattern2};

/
d20p1 x:"\n"sv(
    "Tile 2311:";"..##.#..#.";"##..#.....";"#...##..#.";"####.#...#";"##.##.###.";"##...#.###";".#.#.#..##";"..#....#..";"###...#.#.";"..###..###";""
    ;"Tile 1951:";"#.##...##.";"#.####...#";".....#..##";"#...######";".##.#....#";".###.#####";"###.##.##.";".###....#.";"..#.#..#.#";"#...##.#..";""
    ;"Tile 1171:";"####...##.";"#..##.#..#";"##.#..#.#.";".###.####.";"..###.####";".##....##.";".#...####.";"#.##.####.";"####..#...";".....##...";""
    ;"Tile 1427:";"###.##.#..";".#..#.##..";".#.##.#..#";"#.#.#.##.#";"....#...##";"...##..##.";"...#.#####";".#.####.#.";"..#..###.#";"..##.#..#.";""
    ;"Tile 1489:";"##.#.#....";"..##...#..";".##..##...";"..#...#...";"#####...#.";"#..#.#.#.#";"...#.#.#..";"##.#...##.";"..##.##.##";"###.##.#..";""
    ;"Tile 2473:";"#....####.";"#..#.##...";"#.##..#...";"######.#.#";".#...#.#.#";".#########";".###.#..#.";"########.#";"##...##.#.";"..###.#.#.";""
    ;"Tile 2971:";"..#.#....#";"#...###...";"#.#.###...";"##.##..#..";".#####..##";".#..####.#";"#..#.#..#.";"..####.###";"..#.#.###.";"...#.#.#.#";""
    ;"Tile 2729:";"...#.#.#.#";"####.#....";"..#.#.....";"....#..#.#";".##..##.#.";".#.####...";"####.#.#..";"##.####...";"##..#.##..";"#.##...##.";""
    ;"Tile 3079:";"#.#.#####.";".#..######";"..#.......";"######....";"####.#..#.";".#...#.##.";"#.#####.##";"..#.###...";"..#.......";"..#.###...")

OVERVIEW:

COMMON:
We pre-generate all 8 transformed forms of each tile. The transformations are any combination of
flip, reverse and reverse each. We then try to match up which tile in which transformation can be
next to which other one. This is essentially a comparison across 4 dimensions (the transformations
and the tile IDs). We only care about which tiles can go to the right and below of each tile.
Then we do a BFS to try to fill in the grid. We start from the top left, but instead of going line
by line, we go in diagonals going down and left. The reason for this is that tiles in the middle
have two constraints, while those on the edges only have one. By going in diagonals we ensure that
we get to the inner tiles early which greatly reduces the search space. At the end of the BFS we
will end up with the possible maps in the form of (transformation;tileID) pairs for each cell -
note that all 8 orientations of the map will be returned which will be useful for part 2.

PART 1:
We run the above algorithm and read out the tile IDs required for the answer. Since we only need
the corner tile IDs, it doesn't matter which of the found maps we use for this.

PART 2:
After finding the maps, we first cut down the edges from the tile maps.
    tco:(-1_/:/:/:1_/:/:/:-1_/:/:1_/:/:r 3);
Then we merge the individual tiles after looking them up into a single image for each map.
    imgs:{[tco;mw;x]raze raze each/:flip each mw cut tco ./:x}[tco;mw]each queue;
We take the sea monster pattern and find which indices in each row must be filled to match. To
actually match the pattern, we take a rolling window of 3 consecutive rows and try each starting
index to add to the indices in the pattern and then see if after applying the indices to the image
we only get "#" characters. Since the pattern has 3 rows, we have to take the intersection of 3
lists of matches. After finding the number of monsters, we simply subtract the number multiplied
by the length of the pattern from the total number of "#" tiles.