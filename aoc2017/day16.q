gcd:{$[x<0;.z.s[neg x;y];x=y;x;x>y;.z.s[y;x];x=0;y;.z.s[x;y mod x]]};
lcm:{(x*y)div gcd[x;y]};

.d16.getTransform:{[x;y]
    {[pl;ni]
        $[ni[0]="s";pl[0]:neg["J"$1_ni] rotate pl[0];
          ni[0]="x";[pos:"J"$"/"vs 1_ni;pl[0;pos]:pl[0;reverse pos]];
          ni[0]="p";[pos:pl[1]?"C"$"/"vs 1_ni;pl[1;pos]:pl[1;reverse pos]];
        ::];
    pl}/[(til count x;x!x);","vs y]};

d16p1:{
    transform:.d16.getTransform[x;y];
    transform[1] x transform[0]};

d16p1["abcde";"s1,x3/4,pe/b"] //"baedc"
d16p1["abcdefghijklmnop";"pa/g,pc/g"]    //"cbgdefahijklmnop"

d16p2:{
    transform:.d16.getTransform[x;y];
    orderPeriod:lcm/[count each (transform[0]\)each til count x];
    order:transform[0]/[z mod orderPeriod;til count x];
    permPeriod:lcm/[count each (transform[1]\)each x];
    perm:transform[1]/[z mod permPeriod;x];
    perm order};


d16p2["abcde";"s1,x3/4,pe/b";2] //"ceadb"
d16p2["abcdefghijklmnop";"pa/g,pc/g";1000000000]    //"cbgdefahijklmnop" and runs instantly

/
BREAKDOWN:
The idea is to convert the set of instructions into a single transformation (actually two transformations,
one for the positions from the s/x instructions, and one for the letters from the p instructions).
Part 1 is calling this transformation once. Part 2 is calculating the period of the transformation
and applying only as much as required. The periods are calculated by piecewise checking the period of
each letter/position and taking the least common multiple of those. Also note that the periods of the
positions and the letters and the positions could be different but they are independent in forming the solution.

gcd and lcm are helper functions to calculate greatest common divisor and least common multiple.

.d16.getTransform converts a series of commands into a single transformation.
First we split the input on commas:
q)","vs "s1,x3/4,pe/b"
"s1"
"x3/4"
"pe/b"
Then we do the equivalent of a "for loop" using the / adverb.
The starting value is the identity transformation:
The identity for the positions in the string x is "til count x". (0 1 2 ... n-1).
The identity for the characters in the string x is "x!x" (each character maps to itself).
The "body" of the loop is expressed as a function that takes the current "loop variable" in the
first argument and the next list element in the second argument. Whatever we return from the function
becomes the value of the first parameter in the next iteration. However this only works for one parameter,
so since we have two values we pack them into a two-element list.
Inside the function, we examine the first character of the string (ni[0]) in a branching instruction.

If the command is "s", we extract the length of the rotation:
q)ni:"s13"
q)"J"$1_ni
13
Then we use this value to rotate the position part of the mapping. Note that it's the output that is rotated
by the given number, not the mapping. To get the correct mapping we rotate it by the negation of the number.
q)pl[0]
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
q)neg["J"$1_ni] rotate pl[0]
3 4 5 6 7 8 9 10 11 12 13 14 15 0 1 2

If the command is "x", we swap two positions in the position mapping.
We extract the two positions from the string:
q)ni:"x3/4"
q)"J"$"/"vs 1_ni
3 4
Since we refer to this value twice we store it in a variable named "pos".
Then we swap the two respective values in the mapping.
q)pos:"J"$"/"vs 1_ni
q)pl[0]
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
q)pl[0;pos]:pl[0;reverse pos]
q)pl[0]
0 1 2 4 3 5 6 7 8 9 10 11 12 13 14 15
The "reverse" function comes in handy for swapping the two indices returned by parsing the command.

If the command is "p", we swap two positions in the character mapping.
This works similarly to the above, except we use "C"$ to parse (since the indexes are characters).
Also due to how dictionary lookup works, we need to find the indices in the keys of the dictionary
using the ? operator. We could have done that for the position mapping too but it doesn't matter that much
as opposed to the character mapping which is easier to apply in the end if we do it this way.
The difference is only visible after multiple "p" commands, such as d16p1["abcdefghijklmnop";"pa/g,pc/g"].
Not using ? gives the wrong order.
"-1 .Q.s1 something" prints a linear version of a value to the console, instead of the normal formatted
output. The dictionary would fill too many lines when formatted. Also it returns the -1 so I add a
semicolon to the end of the line to discard the result.
q)ni:"pe/b"
q)"C"$"/"vs 1_ni
"eb"
q)-1 .Q.s1 pl[1];
"abcdefghijklmnop"!"abcdefghijklmnop"
q)pl[1]?"C"$"/"vs 1_ni
"eb"
q)pos:pl[1]?"C"$"/"vs 1_ni
q)pl[1;pos]:pl[1;reverse pos]
q)-1 .Q.s1 pl[1];
"abcdefghijklmnop"!"aecdbfghijklmnop"

Part 1:
We apply the returned transformation on the input.
q)x:"abcde"
q)y:"s1,x3/4,pe/b"
q)transform:.d16.getTransform[x;y];
q)transform
4 0 1 3 2
"abcde"!"aecdb"
q)transform[1] x transform[0]
"baedc"

Part 2:
Note that the number 1000000000 is too large to evaluate the transformation that many times.
(Nevertheless it can be done within an hour after the above transform trick.)
However, since we are only applying the same 16-element permutations over and over,
there will be cycles in the generated values. The position and character mappings
are independent for this purpose. So we can first calculate the period of the position mapping,
find the requested iteration (e.g. 1000000000) modulo the period, and only do the transformation
that many times. Then we can do the same for the character mapping. Combining the two
gives the final answer.

To get the period for the position mapping, we calculate it for each index.
(This is a bit wasteful but it's only 16 elements so not that much.)
We use the scan (\) adverb on the position mapping to follow each index until it wraps back to
the initial position.
q)transform[0]
4 0 1 3 2
q)(transform[0]\)each til count x
0 4 2 1
1 0 4 2
2 1 0 4
,3
4 2 1 0
The period of each index is the number of elements in each of these lists.
q)count each (transform[0]\)each til count x
4 4 4 1 4
The period is the least common multiple of the individual periods. This is where the "lcm" helper
function comes in. We just fold it over the list using the over (/) adverb, just like how
"sum" is functionally equivalent to "+/".
q)orderPeriod:lcm/[count each (transform[0]\)each til count x];
q)orderPeriod
4
To get the final order we count how many times we have to apply it:
q)z
2
q)z mod orderPeriod
2
(z should be 1000000000 for the puzzle input.)
Then we apply the position mapping this many times to the identity mapping using "iterate" (also the / adverb):
q)order:transform[0]/[z mod orderPeriod;til count x];
q)order
2 4 0 3 1

The calculation of the character mapping works the same way.

q)-1 .Q.s1 transform[1];
"abcde"!"aecdb"
q)(transform[1]\)each x
,"a"
"be"
,"c"
,"d"
"eb"
q)count each (transform[1]\)each x
1 2 1 1 2
q)permPeriod:lcm/[count each (transform[1]\)each x]
q)permPeriod
2
q)perm:transform[1]/[z mod permPeriod;x]
q)perm
"abcde"
Finally we apply the position mapping to the result of the character mapping.
q)perm order
"ceadb"

In this puzzle we used 4 different versions of "looping":
{[x;y]}/[startingValue;list]   iterate over list
{[x;y]}/[list]   fold over list
{[x]}/[num;startingValue]   iterate a given number of times
{[x]}/[startingValue]   iterate until no change or returning starting value
All of these work with / and \, the difference is that / returns only the final
value and \ returns all the immediate values in a list.