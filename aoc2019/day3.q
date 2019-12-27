d3:{a:","vs/:"\n"vs x;
    {sums raze ("J"$1_/:x)#'enlist each("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]}each a};
d3p1:{b:d3 x;min sum each abs b[0]inter b[1]};
d3p2:{b:d3 x;min sum 1+b?\:b[0]inter b[1]};

.d3.test:{
    //input too long to copy-paste into windows terminal
    x:"R1003,D430,L108,D570,R459,U7,L68,D232,L130,U93,R238,U951,L821,U723,L370,U873,L680,U749,R110,U17,R185,U484,R550,U356,L212,U350,L239,D208,R666,U70,L369,U448,R54,D402,R165,D375,L468,U886,L303,U779,L752,U664,L120,U643,R405,D288,L220,U727,L764,D615,R630,U688,R961,U499,L782,D852,L743,U443,R355,U856,L795,U235,L876,D511,L108,U637,R427,D338,L699,D911,L506,D607,L539,U977,R654,D634,L196,U944,R922,D774,R358,U828,L970,D386,R795,U602,R249,U793,L171,D217,L476,D123,L179,U820,R895,D239,R363,D629,L226,D811,R962,D848,R218,D581,R369,D872,L653,D281,R304,D302,R780,U636,L413,D712,L642,D886,R613,U736,L968,D82,R953,U408,L130,U654,R312,U74,L610,D798,R242,D586,L808,D664,L764,U455,R264,U384,L154,D484,R883,D276,L423,U11,L145,U156,L268,U46,R202,U641,R920,D483,R859,U94,L173,D796,R11,D328,R48,D161,L615,D396,R350,D48,R946,D233,R385,D294,R640,D301,R810,D824,L969,D469,R34,U995,R750,D827,R52,U606,R143,U868,L973,U863,L17,U995,L236,U994,R403,D312,R49,U143,L399,U821,R974,U119,R410,D233,R228,D326,R112,D512,L950,D103,L590,U80,R7,U441,L744,U643,L80,D631,L576,U680,R369,U741,L87,D748,R773,U145,R464,U546,R80,D251,L972,U414,L390,U148,L84,D481,L425,U293,L564,U880,R535,U703,R981,U944,R224,D366,R29,U517,R342,U686,L384,D650,R983,D287,L108,U713,L523,U695,R881,D126,R151,U153,R161,D791,L599,D936,L816,U387,R411,U637,L434,D22,L720,U579,L661,D644,L220,U325,R753,D392,L503,U617,R1,D956,L607,U602,L800,D749,L193,U215,L91,U733,L606,U510,L124,D550,R303,D835,R19,D326,R577,U265,L156,D924,L122,D186,R803,U3,R879\nL1003,U603,L675,U828,R671,U925,R466,D707,L39,U1,R686,U946,L438,U626,R714,D365,L336,D624,R673,U672,L729,D965,R824,D533,R513,D914,R829,U275,L424,U10,L244,U158,R779,D590,R116,U714,R662,D989,R869,D547,R817,U315,R439,D29,L599,D870,L645,U656,R845,U19,R960,U669,L632,D567,L340,U856,R955,D314,R452,D896,R574,D162,R240,U302,R668,U706,R394,D24,L422,U884,R804,U576,L802,U400,R405,U676,L344,D628,R672,U580,R710,U536,L712,U738,L266,D212,R552,D229,R265,U835,R152,U784,L478,D87,L783,D327,R728,U590,R408,D397,R363,D654,R501,D583,R445,U897,R888,D480,R455,U593,R906,D506,R985,D361,R361,D619,L462,D873,L248,D348,R540,D578,L274,D472,R254,U647,R54,U681,L33,U343,R913,U120,L64,D849,L953,U407,L64,U744,L482,U240,L82,U69,R480,D796,L137,U527,R428,U67,R123,U688,L985,D944,R583,D804,R331,U328,R906,U376,L966,U433,R863,D931,L315,D9,L77,D141,L738,D661,R742,D44,R383,U78,R106,D301,L186,U907,L304,U786,L256,U718,R861,D145,R694,D721,R607,D418,R358,U600,R228,D139,R476,D451,L49,U616,L491,U8,R371,D735,R669,U388,L905,D282,L430,U491,L775,U891,L831,U350,L247,D609,R489,U266,R468,D748,R134,U187,R882,D315,R344,D363,R349,U525,R831,U644,R207,D563,L1,D946,L559,U789,L187,U370,L284,D910,L394,D560,L705,U661,R272,U109,L12,D554,L670,D169,L375,D100,R382,D491,L53,D916,R152,U82,L236,U845,L860,U732,R327,D190,R888,U722,R770,U993,R509,D970,L225,D756,R444,D992,L746,D35,R329,D452,R728,U575,L325,U414,L709,D844,R692,D575,R132,D520,L506,D384,L581,U36,L336,U849,L944,U450,R138,D186,L613,U805,R32,U763,R210,U556,R125,D499,R729";
    show d3p1 x;
    show d3p2 x;
    };

/
BREAKDOWN:

The two parts use a common function that returns every coordinate along a path.
This also includes input parsing, which results in a list of two lists of strings:
q)x:"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
q)a:","vs/:"\n"vs x;
q)a
("R75";"D30";"R83";"U83";"L12";"D49";"R71";"U7";"L72")
("U62";"R66";"U55";"R34";"D71";"R55";"D58";"R83")

Both paths are traced the same way, so I use a lambda with each to process them.
This is one run of the lambda:
q)x:("R75";"D30";"R83";"U83";"L12";"D49";"R71";"U7";"L72")

We take the first character of every string, which are the directions:
q)x[;0]
"RDRULDRUL"

Then we map these to movement vectors. The vectors are in a dictionary with the
direction as key and the coordinates as value:
q)"URDL"!(0 -1;1 0;0 1;-1 0)
U| 0  -1
R| 1  0
D| 0  1
L| -1 0

Invoking the dictionary with the list of directions as an adgument results in a list
of the coordinates corresponding to each direction:
q)("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]
1  0
0  1
1  0
0  -1
-1 0
0  1
1  0
0  -1
-1 0

Now we want to duplicate every coordinate by the number of steps. To do this first we
chop off the direction from the instructions, leaving the number:
q)1_/:x
"75"
"30"
"83"
"83"
"12"
"49"
"71"
,"7"
"72"

Then we convert these strings to numbers:
q)("J"$1_/:x)
75 30 83 83 12 49 71 7 72

As now we have two lists, one with the step counts and one with the direction vectors,
we would like to apply "duplication" pairwise between the two lists. The # operator
(take) can do duplication as long as the right argument is a one-element list. In q
the main way to create a one-element list is the enlist function. Since we want each
element to be put in its own list instead of just creating a wrapper around the whole
list, we use enlist each.
q)enlist each("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]
1 0
0 1
1 0
0 -1
-1 0
0 1
1 0
0 -1
-1 0
(Visually not distinct from the un-enlisted version but I promise it's not the same!)

Now we can do the pairwise duplication. The # operator must be modified with '
("each" iterator) so that it applies pairwise, rather than on the entire lists.

q)("J"$1_/:x)#'enlist each("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]
(1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;..
(0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;..
(1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;..
(0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0..
(0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;..
(0 -1;0 -1;0 -1;0 -1;0 -1;0 -1;0 -1)
(-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-1 0;-..

There are so many steps that they don't fit on the screen, but they have been duplicated
exactly by the number of steps for the respective instruction. Now we raze all of this
into a single list:

q)raze("J"$1_/:x)#'enlist each("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]
1  0
1  0
1  0
..
1  0
1  0
0  1
0  1
0  1
0  1
..

And another neat q trick is to get the partial sums of this list, which results in the
list of the visited coordinates:
q)sums raze("J"$1_/:x)#'enlist each("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]
1   0
2   0
3   0
4   0
5   0
6   0
..
149 -11
148 -11
147 -11
146 -11
145 -11

Remember that this was all part of a lambda that we apply to both sets of instructions:
q)a:","vs/:"\n"vs"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
q){sums raze("J"$1_/:x)#'enlist each("URDL"!(0 -1;1 0;0 1;-1 0))x[;0]}each a
(1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0;13 0;14 0;15 0;16 0;17 0;18 0;19 0;..
(0 -1;0 -2;0 -3;0 -4;0 -5;0 -6;0 -7;0 -8;0 -9;0 -10;0 -11;0 -12;0 -13;0 -14;0 -15;0 -16..

Now we have our helper function d3, which parses the input and traces both paths.

PART 1:
First we generate the paths:
q)b:d3"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"

We check the intersections using the actual set intersection operator:
q)b[0] inter b[1]
158 12
146 -46
155 -4
155 -11

To get the distance from the origin first we take the absolute values of the coordinates:
q)abs b[0] inter b[1]
158 12
146 46
155 4
155 11

Then add them together. Note the use of sum each, instead of just sum, which would
add the matching coordinates of the different points together, while we actually want
to add together the two coordinates of the same point.
q)sum each abs b[0] inter b[1]
170 192 159 166

The answer is the minimum of this list.
q)min sum each abs b[0] inter b[1]
159

PART 2:
We start by getting the intersections again:
q)b[0] inter b[1]
158 12
146 -46
155 -4
155 -11

Now we want to find each intersection in both paths. The ? operator can do this find
operator, however since we have a lists of lists to search in, we need to use the
\: iterator such that it will search in both lists. Using it without \: would mean
it would compare the whole paths to the intersections, which wouldn't match.
q)b?\:b[0]inter b[1]
205 289 340 471
403 333 384 377

This returns the number of steps until each intersection. However we also need to count
the starting point so we add 1 to each element (+ is atomic so no iterator needed):

q)1+b?\:b[0]inter b[1]
206 290 341 472
404 334 385 378

Then we add together the two lists, so each element in the result will be the total
steps across both paths to reach that particular intersection:

q)sum 1+b?\:b[0]inter b[1]
610 624 726 850

The final answer is the minimum of these step counts:
q)min sum 1+b?\:b[0]inter b[1]
610
