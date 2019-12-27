d4:{[a;b]
    ns:string a+til 1+b-a;
    ns:ns where ns~'asc each ns;
    ns:count each/:group each ns;
    ns};
d4p1:{[a;b]sum 1<max each d4[a;b]};
d4p2:{[a;b]sum 2 in/:d4[a;b]};

//d4p1[108457;562041]
//d4p2[108457;562041]

/
BREAKDOWN:

COMMON PARTS:
We take a lower and upper bound as a parameter.
q)a:108457;
q)b:562041;

We generate all the numbers from a to b. This is the q idiom to do it:
q)a+til 1+b-a
108457 108458 108459 108460 108461 108462 108463 108464 108465 108466 108467 108468 108469 108470..

(Since til can only generate numbers starting from 0, we shift it by adding the left bound,
and the number of numbers generated is the difference between the two plus one).

It is easier to perform the following operations on strings, so we save the list of
numbers as strings:
q)ns:string a+til 1+b-a;
q)ns
"108457"
"108458"
"108459"
"108460"
"108461"
"108462"
"108463"
"108464"
"108465"
"108466"
"108467"
"108468"
"108469"
"108470"
"108471"
"108472"
"108473"
..

To keep only the ascending numbers, first we sort the characters within each number:
q)asc each ns
`s#"014578"
`s#"014588"
`s#"014589"
`s#"001468"
`s#"011468"
`s#"012468"
`s#"013468"
`s#"014468"
`s#"014568"
`s#"014668"
`s#"014678"
`s#"014688"
`s#"014689"
`s#"001478"
`s#"011478"
`s#"012478"
`s#"013478"
..

Then we compare this with the original string. ~ would match the whole list, so we use
~' instead to match pairwise.
q)ns~'asc each ns
00000000000000000000000000000000000000000000000000000000000000000000000000000..

We use a common idiom of filtering a list, which is to take the indices where the
condition is true, and then use the resulting index list to index the original list.
q)ns:ns where ns~'asc each ns;
q)ns
`s#"111111"
`s#"111112"
`s#"111113"
`s#"111114"
`s#"111115"
`s#"111116"
`s#"111117"
`s#"111118"
`s#"111119"
`s#"111122"
`s#"111123"
`s#"111124"
`s#"111125"
`s#"111126"
`s#"111127"
`s#"111128"
`s#"111129"
..

Now we want to see the frequency of each character in each string. This can be done by
grouping each string and then couting the groups.
q)group each ns
(`s#,"1")!,0 1 2 3 4 5
`s#"12"!(0 1 2 3 4;,5)
`s#"13"!(0 1 2 3 4;,5)
`s#"14"!(0 1 2 3 4;,5)
`s#"15"!(0 1 2 3 4;,5)
`s#"16"!(0 1 2 3 4;,5)
`s#"17"!(0 1 2 3 4;,5)
`s#"18"!(0 1 2 3 4;,5)
`s#"19"!(0 1 2 3 4;,5)
`s#"12"!(0 1 2 3;4 5)
`s#"123"!(0 1 2 3;,4;,5)
`s#"124"!(0 1 2 3;,4;,5)
`s#"125"!(0 1 2 3;,4;,5)
`s#"126"!(0 1 2 3;,4;,5)
`s#"127"!(0 1 2 3;,4;,5)
`s#"128"!(0 1 2 3;,4;,5)
`s#"129"!(0 1 2 3;,4;,5)
..

We need to use /: on "count each" because the lists we are counting are two levels in.
q)ns:count each/:group each ns;
q)ns
(`s#,"1")!,6
`s#"12"!5 1
`s#"13"!5 1
`s#"14"!5 1
`s#"15"!5 1
`s#"16"!5 1
`s#"17"!5 1
`s#"18"!5 1
`s#"19"!5 1
`s#"12"!4 2
`s#"123"!4 1 1
`s#"124"!4 1 1
`s#"125"!4 1 1
`s#"126"!4 1 1
`s#"127"!4 1 1
`s#"128"!4 1 1
`s#"129"!4 1 1
..

PART 1:
We accept a string if there is any number greater than one in the group counts. In other
words, if the maximum of the counts is greater than one.
q)max each ns
6 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4..

q)1<max each ns
11111111111111111111111111111111111111111111111111111111111111111111111111111..

We can sum the booleans to get the answer:
q)sum 1<max each ns
2779i

PART 2:
This time we only accept the number if 2 appears among the frequencies:
q)2 in/:ns
00000000010000000100000010000010000100010010101111111100000010000010000100010..

Once aain we can sum the booleans:
q)sum 2 in/:ns
1972i
