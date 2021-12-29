d8p1:{
    a:" "vs/:/:" | "vs/:"\n"vs ssr[x;"|\n";"| "];
    sum sum(count each/:a[;1])in 2 3 4 7};
d8p2:{
    a:" "vs/:/:" | "vs/:"\n"vs ssr[x;"|\n";"| "];
    f:{
        //x:a[0]
        c:x[0] iasc count each x[0];  //2 3 4 5 5 5 6 6 6 7
                                      //1 7 4 [235] [069] 8
        top:first c[1]except c[0];
        right:c[1]except top;
        r2:asc count each group raze[c 6 7 8] inter right;
        topRight:first key r2;
        bottomRight:last key r2;
        tlm:c[2]except c[1];
        tlm2:asc count each group raze[c 6 7 8] inter tlm;
        middle:first key tlm2;
        topLeft:last key tlm2;
        bl:asc count each group raze[c 3 4 5] except raze[c 1 2];
        bottomLeft:first key bl;
        bottom:last key bl;
        map:(top;topLeft;topRight;middle;bottomLeft;bottomRight;bottom)!"abcdefg";
        map2:("abcefg";"cf";"acdeg";"acdfg";"bcdf";"abdfg";"abdefg";"acf";"abcdefg";"abcdfg")!til 10;
        10 sv map2 asc each map x[1]};
    sum f each a};

/
x:"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe\n"
x,:"edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc\n"
x,:"fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg\n"
x,:"fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb\n"
x,:"aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea\n"
x,:"fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb\n"
x,:"dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe\n"
x,:"bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef\n"
x,:"egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb\n"
x,:"gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
d8p1 x
d8p2 x

BREAKDOWN:

PART 1:
We split on " | " and then on spaces inside the elements. I also added a ssr to convert a "|\n"
sequence into "| " just to be able to copy-paste the example.
q)a:" "vs/:/:" | "vs/:"\n"vs ssr[x;"|\n";"| "]
q)a
("be";"cfbegad";"cbdgef";"fgaecd";"cgeb";"fdcge";"agebfd";"fecdb";"fabcd";"ed..
("edbfga";"begcd";"cbg";"gc";"gcadebf";"fbgde";"acbgfd";"abcde";"gfcbed";"gfe..
("fgaebd";"cg";"bdaec";"gdafb";"agbcfd";"gdcbef";"bgcad";"gfac";"gcb";"cdgabe..

The answer to part 1 is simple, we just take the counts of the items on the right and find which
of those are in the set 2 3 4 7:
q)count each/:a[;1]
7 5 6 4
6 3 7 2
2 2 6 3
...
q)(count each/:a[;1])in 2 3 4 7
1001b
0111b
1101b
...
q)sum sum(count each/:a[;1])in 2 3 4 7
26i

PART 2:
I hardcoded one kind of reasoning to find which digit is which. There are probably many ways.

The decoding is done in a function that is called for every line. So "x" will represent a single
line:
q)x
("be";"cfbegad";"cbdgef";"fgaecd";"cgeb";"fdcge";"agebfd";"fecdb";"fabcd";"ed..
("fdgacbe";"cefdb";"cefbgd";"gcbe")

We order the digits by segment count. The "iasc" function is useful for "ordering list X by
in ascending order of Y".
q)c:x[0] iasc count each x[0]
q)c
"be"
"edb"
"cgeb"
"fdcge"
"fecdb"
"fabcd"
"cbdgef"
"fgaecd"
"agebfd"
"cfbegad"

Based on the segment counts of each digit, we know that they must be in the order
    1 7 4 [235] [069] 8 (the square brackets indicate those may be in any order).
The "top" segment is found in 7 but not in 1:
q)top:first c[1]except c[0];
q)top
"d"

The "right" segments are those that are in 7 and are not the "top" segment:
q)right:c[1]except top;
q)right
"eb"

We count how many times the "right" segments appear in 0, 6 and 9:
q)r2:asc count each group raze[c 6 7 8] inter right;
q)r2
b| 2
e| 3

The "top right" segment appears twice (in 0 and 9) while "bottom right" appears in all three:
q)topRight:first key r2;
q)topRight
"b"
q)bottomRight:last key r2;
q)bottomRight
"e"

The "top left" and "middle" segments appear in 4 but not in 7:
q)tlm:c[2]except c[1]
q)tlm
"cg"

We check how many times these segments appear in 0, 6 and 9:
tlm2:asc count each group raze[c 6 7 8] inter tlm;
q)tlm2:asc count each group raze[c 6 7 8] inter tlm;
q)tlm2
c| 2
g| 3

The "middle" segment appears twice (in 6 and 9) while "top left" appears in all three:
q)middle:first key tlm2;
q)middle
"c"
q)topLeft:last key tlm2;
q)topLeft
"g"

The "bottom" and "bottom left" segments appear in 2, 3 and 5 but not in 7 and 4:
q)bl:asc count each group raze[c 3 4 5] except raze[c 1 2]
q)bl
a| 1
f| 3

The "bottom left" segment appears once (in 2) while "bottom" appears in all three:
q)bottomLeft:first key bl;
q)bottomLeft
"a"
q)bottom:last key bl;
q)bottom
"f"

We create a mapping to a standard ordering of the segments:
q)map:(top;topLeft;topRight;middle;bottomLeft;bottomRight;bottom)!"abcdefg";
q)map
d| a
g| b
b| c
c| d
a| e
e| f
f| g

Then another mapping from the standard segments to the digits:
q)map2:("abcefg";"cf";"acdeg";"acdfg";"bcdf";"abdfg";"abdefg";"acf";"abcdefg";"abcdfg")!til 10
q)map2
"abcefg" | 0
"cf"     | 1
"acdeg"  | 2
"acdfg"  | 3
"bcdf"   | 4
"abdfg"  | 5
"abdefg" | 6
"acf"    | 7
"abcdefg"| 8
"abcdfg" | 9

We use the mappings to convert the digits on the right:
q)asc each map x[1]
`s#"abcdefg"
`s#"acdfg"
`s#"abcdfg"
`s#"bcdf"
q)map2 asc each map x[1]
8 3 9 4

Then we use the "digits to number" feature of sv to convert it to base 10:
q)10 sv map2 asc each map x[1]
8394

The answer is the sum of the above function applied to all the lines:
q)sum f each a
61229
