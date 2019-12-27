d18p1:{ /solves both part 1 and 2 as long as the map is already pre-processed with the extra robots for part 2
    map:"\n"vs x;
    starts:raze til[count map],/:'where each"@"=map;
    allKeys:asc x where x within "az";

    queue:([]ci:starts[;0];cj:starts[;1];doors:count[starts]#enlist"");
    parent:starts!count[starts]#enlist[(0N;0N)];
    needKey:enlist[" "]!enlist"";
    while[0<count queue;
        nxts:raze{update nci:ci+-1 0 1 0,ncj:cj+0 1 0 -1 from 4#enlist x}each queue;
        nxts:update ntile:map'[nci;ncj] from nxts;
        nxts:select from nxts where not ntile="#", not (nci,'ncj) in key parent;
        nxts:update doors:asc each distinct each (doors,'lower ntile) from nxts where lower[ntile] within "az";
        parent,:exec (nci,'ncj)!(ci,'cj) from nxts;
        needKey,:exec ntile!doors except' ntile from nxts where ntile within "az";
        queue:select ci:nci, cj:ncj, doors from nxts;
    ];

    startps:starts,raze til[count map],/:'where each map within "az";
    queue:([]ci:startps[;0];cj:startps[;1]; sc:(raze string til count starts),count[starts]_map ./:startps);
    parent:(exec (;;)'[ci;cj;sc] from queue)!count[queue]#enlist[0N 0N,enlist" "];
    paths:([s:"";t:""]path:();plen:`long$());
    while[0<count queue;
        nxts:raze{update nci:ci+-1 0 1 0,ncj:cj+0 1 0 -1 from 4#enlist x}each queue;
        nxts:update ntile:map'[nci;ncj] from nxts;
        nxts:select from nxts where not ntile="#", not (;;)'[nci;ncj;sc] in key parent;
        parent,:exec (;;)'[nci;ncj;sc]!(ci,'cj) from nxts;
        pths:update path:-1_/:/:reverse each -2_/:{[p;x]p[x],-1#x}[parent]\'[(;;)'[nci;ncj;sc]] from select from nxts where ntile within "az";
        paths:paths upsert select s:sc, t:ntile, plen:count each path, path from pths;
        queue:select ci:nci, cj:ncj, sc from nxts where not ntile within "az";
    ];

    queue:([]pos:enlist raze string til count starts;kys:enlist"";tplen:enlist 0);
    visited:([]pos:();kys:());
    while[0<count queue;
        minl:exec min tplen from queue;
        if[0<count found:select from queue where tplen=minl, count[allKeys]=count each kys; :exec first tplen from found];
        toExpand:select from queue where tplen=minl;
        visited,:delete tplen from toExpand;
        nxts:raze{[paths;needKey;e]
            raze{[paths;needKey;e;p]
                nxpos:select t,plen from paths where s=e[`pos;p], all each needKey[t] in e`kys;
                update npos:.[pos;(::;p);:;nxpos[`t]],tplen+nxpos[`plen], kys:asc each distinct each (kys,'nxpos[`t]) from count[nxpos]#enlist e
            }[paths;needKey;e]each til count e`pos
        }[paths;needKey]each toExpand;
        nxts:select from nxts where not ([]pos:npos;kys) in visited;
        queue:(delete from queue where tplen=minl),select pos:npos, kys, tplen from nxts;
        queue:0!select min tplen by kys,pos from queue;
    ];
    "not found"};

d18p2:{ /expects a 81x81 map
    x[3237 3238 3239 3319 3320 3321 3401 3402 3403]:"@#@###@#@";
    d18p1 x};

.d18.test:{
    x:"#################################################################################\n#.....#...........#....s..#.....#.......#...#...#...#...#.......#...........#...#\n#.#.#.#####.#.#####.#####.#.#####.#####.#.#.#.#.#.###.#.#.#.###.#.#.#########.#.#\n#.#.#.......#.#.........#.#.......#...#.#.#...#...#...#...#...#.#.#...#.......#.#\n#.#.#########.#.#########.#.#######.###.#.#####.###.#########.###.###.#.#######.#\n#l#...#...#...#...#.......#...#.....#...#.#.#...#...#.......#...#.#...#.#.......#\n#.###.#.###.#####.#.#########.###.#.#.###.#.#.###.#######.#.###.#.#.#.#.#.#####.#\n#.#...#...Z.#.#...#...#...........#.#...#.#.#.#.#.......#.#...#...#.#.#.#.....#.#\n#.#.#####.###.#.#####.###########.#####.#.#.#.#.#######.#.#########.###.#####M###\n#.#.#...#.#...#.....#.......#.....#...#.#.#...........#.#.......#...#...#...#...#\n#E#.#.#.#.###.#####.#######.#######.#.#.#.#######.#####.#.###.#.#.###.###.#####.#\n#.#...#.#.....#.....#.....#...#.....#.#.#.....#...#.....#.#.#.#.#...#.#.......#.#\n#.#####.#######.#########.###.#.#####.#.#.###.#####.#####.#.#.#####.#.#######.#.#\n#.#...#.........#...........#.#...#.....#...#.......#...#...#.....#.#.......#.#.#\n#.###.###########.#.#######.#.###.#####.###.#####.###.#.#####.#.#.#.#######.#.#.#\n#...#.....#x....#.#.#.....#.#...#.....#.#.#.#...#.....#.#...#.#.#.#.....L.#...#.#\n###.#.#.#.###.#.#.###.###.###.#.#####.#.#.#.#.#.#######.#.#.###.#.#####.#####.#.#\n#.#.#.#.#...#.#...#...#.#...#.#.#.....#.#...#.#..b....#...#.....#.#...#.......#.#\n#.#.###.###.#.###.#.###.###.###.#.#####.#.###C#######.#############.#.#########.#\n#.#...#o#...#.#.#.#.#.....#.....#.....#.#..f#.#.....#.........#.....#.#.....#...#\n#.###.#.###.#.#.#.#.#####.#######.###.#####.#.#####.#########B#.#####.#.###.#.#.#\n#...#.#...#...#.#.#.#...#.......#...#...#...#.....#.........#.#.#.......#...#.#.#\n#.#.#.###.#####.#.#.###.###.###.#######.#.#######.#####.###.###.#.#######.###.#.#\n#.#.#.....#.....#.#...#...#...#.........#.#...N.#c....#...#t..P.#...#...#.....#.#\n#.#########.#####.#.#####.###.#####.#####.#.#########H###.###########.#.#.#######\n#.........#..g....#.....#...#.#.....#...#.#...#.....#...#.#...........#.#.#.....#\n#.#####.###.###########.###.#.#######.#.#.###.#.#.#####.#.#.###########.###.###.#\n#...#.#...#...#...#.....#...#.#.......#.#.#...#.#.......#...#.......#.#.......#.#\n###.#.###.###.###.#.#####.###.#.#######.#.#.#.#.#########.#####V###.#.#########.#\n#.#.#.#.....#.#...#.......#.#...#...#...#...#.#......y#.#.#.....#.#...#.I.....#.#\n#.#.#.#.#.###.#.###########.#.###.###.#.#####.#######.#.#.#.#####.###.#.#####.#.#\n#.....#.#.#...#.......#.......#...#...#.#.....#.#.....#.....#...#...#.#.#.......#\n#.#####.###.#######.#.#.#######.#.#.#####.#####.#.#############.#.#.#.#.#########\n#.#.#a..#...#.....#.#...#.......#.#.....#.#.....#...#..j#.......#.#.#.#.....#...#\n#.#.#.#.#.###.###.#.###########.#.#####.#.#.#######.#.#.###.#####.#.#.#####.#.#.#\n#.#.#.#.#.....#...#.#...........#...#...#.#.......#...#...#.....#.#..d....#...#.#\n#.#.#F#.#######.###.#.#########.#####.###.#.###.#########.#####.#.#############.#\n#.#.#.#.......#...#...#.........#...#...#.#...#.....#.#...#...#...#...#...#...U.#\n#.#.#.###########.###############.#.###.#.#######.#.#.#.###.#.#####.#.#.#.#.###.#\n#...#.............................#...............#...#.....#..q....#...#..r#...#\n#######################################.@.#######################################\n#.........#.....#.........#.........#.........#...........#.........#.........#.#\n#.#######.#.#.###.#####.#.#####.###.#.#.#.#####.###.#######.#####.###.###.###.#G#\n#.#.....#.#.#.......#...#.......#.#.#.#.#.#.....#.#.......#.#.....#.A...#...#...#\n#.#.###.#.###.#######.###########.#.###.#.#.#####.#######.#.#.#####.#######.###.#\n#.#...#.#...#.#...#...#.......#.....#...#.........#.....#.#.#.......#.....#...#.#\n#.#####.###.#.###.#.#.#.#####.#.#####.#.###########.###.#.#.#########.###.###.#.#\n#.....#.....#.....#.#.#.#.#...#.#...#.#.#...#.....#.#.#.#...#.....#...#.......#.#\n#.###.#.#########.#.###.#.#.###.#.#.#.#.#.#.#.###.#.#.#.#.###.###.#.#X#########.#\n#w..#.#.#.....#...#...#.#.#.#.....#n..#.#.#.#.#.#...#.#.#.#...#...#.#.#...#...#.#\n###.#.#.###.###.#####.#.#.#.#############.#.#.#.#####.#.#.#.###.###.#.#.#.#.###.#\n#...#.#...#.#...#...#...#.#.#...........#.#...#.......#.#.#.#.#.#...#.#.#.#.....#\n#.###.###.#.#.###.#######.#.#.#########.#.###########.#.###.#.#.###.###.#.#######\n#.#...#.#.#.....#.........#...........#.#...#.........#.....#.#...#...#.#.......#\n#.#.###.#.#####.#####.#########.#######.#.#.#.###############.###.###.#.#######.#\n#.#.#.#..m#...#.......#...#...#.#...#...#.#.#...#.......#.......#...#...#.#.....#\n###.#.#.###.#.#########.#.#.#.###.#.#.#.#.#.###.#.#####.#.###.#####.#.###.#.#####\n#...#...#...#...........#...#.....#...#.#.#...#.#.#.#...#...#.....#.#.#...#.....#\n#.###.###.#.###########################.#.###.#.#.#.#.###.#######.#.#.#.#O#####.#\n#p#.#.#...#.#...J.......#...#.......#...#...#.#.....#.....#.....#.#.#...#...#...#\n#.#.#K#.###.#.#####.###.#.#.#.#####.#.#####.#.#############.###.#.#.#######.#.#.#\n#.#.#.#...#.#.#.....#.#...#.#.#.....#...#.#.#...#.........#.#...#.#...#.#e..#.#.#\n#.#.#.#.#.#.#.###.###.#####.###.#######.#.#.###.#.#######.#.#####.###.#.#.###.#.#\n#.#.#.#.#.#.#...#...#h..#.#.Q.#.....#...#.#.#.#.#...#...#.#.#.#.....#.#.#...#.#.#\n#.#.#.###.#.###.#######.#.###.#.###.#.###.#.#.#.###.###.#.#.#.#.#.#.#.#.#.###.#.#\n#.#.#.#...#...#.....Y...#...#.#.#.#...#.#...#.#.........#.#.#...#.#.#.#...#...#.#\n#.#.#.#.###.#############.###.#.#.#####.#.###.###########.#.###.#.#.#.#####.###.#\n#.#.....#...#.........#.R...#.#.#.......#.#...#.....#.....#...#.#.#.#.......#...#\n#.#######.###.###.#####.###.#.#.#.#####.#.#.#.#.###.#.#.#####.#.#.#.#########.###\n#.....#...#...#.#.#...#.#.#...#.#...#.#.#.#.#.#.#.....#.#.....#.#.#.#......k#...#\n#.###.#####.###.#.#.#.#.#.#####.###.#.#.#.#.#.#.#.#######.#####.#.###.#.###.###.#\n#...#.#.....#...#...#.#.......#...#...#.#.#.#.#.#.#.#.....#...#.#.#...#.#.....#.#\n###.#.#.#####D#.#####.#######.###.#.###.#.#.#.#.#.#.#.#####.###.#.#.###.#######.#\n#...#...#.....#i#.........#.#.#...#.#...#.#.#.#.#...#...#.......#...#.#.......#.#\n#.#######.#######.#######.#.#.#.#####.#.#.###.#.###.###.#.###########.#######.#.#\n#.#...#.........#...#.......#.#.......#.#.....#...#...#.#.#.......#.........#..z#\n#.#T#.###.#####.###.#########.#########.#####.###.#####.#.#####.#.###.#####.#####\n#...#...#.#...#.#...#...#...#.........#.#...#.#.#.#...#.#.....#.#...#.#.....#...#\n#######.###.#.#.#.###.#.#.#.#########.#.#.#.#.#.#.#.#.#.#####.#S###.###W###.#.#.#\n#...........#...#.....#...#..u........#.#.#....v#...#...#.......#.......#.....#.#\n#################################################################################";
    show d18p1 x;
    show d18p2 x;
    };

/
OVERVIEW:

The solution is broken down into three sub-tasks:
1. BFS to find which key is required to get to which other keys. We start from the
robot location and record any doors encountered (we pass right through). When a key
is found, we record which doors were seen up to that point.
2. BFS to simplify the map. We are only interested in paths between keys (and paths
starting from the robot location). So we start the BFS with every key and the start
location in the queue, and whenever we encounter a key, we record the found path.
We don't care about paths leading back to the start.
A huge optimization here is stopping each BFS immediately after finding a key. This
way we will only have path lengths between adjacent keys, but it decreases the
branching factor for the third task.
3. Dijkstra's algorithm to collect all keys. The state is the current key plus
the set of keys collected. We use the data collected from the first two sub-tasks
to figure out which keys we can move to and how long the path is.
As expected in q, we use a vector version of Dijkstra's algorithm. There is no
priority queue, instead pruning is done in every iteration by dropping duplicated
rows using group by, only keeping the minimal paths. Sorting the table with xasc and
then doing a group by on it is more efficient than the equivalent filtering using fby.

PART 2:
The solution is the same with minor modifications.
The BFS's will each start with all of the robot locations, but they still calculate
the same information. We need to distinguish between each start location, rather than
using the generic symbol "@" which may confuse the algorithms into thinking that
they are connected.
For the 3rd sub-task, the state is also changed to not consist of only one character
for the "current key" but a string with each character corresponding to the current
key of the respective robot. When expanding the states, we need to consider moving
each robot, therefore there is a doubly-nested lambda here.

The function d18p1 will solve both part 1 and 2 assuming the map is preprocessed to
contain the desired number of start locations (it will actually work with up to 10
starting locations). The original d18p1 that only handles one robot is commented
out at the top. d18p2 only serves to format the large puzzle input for part 2 by
modifying the center of the map.
