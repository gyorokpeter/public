d18p1:{sum {value ssr/[reverse x;"().";".()"]}each"\n"vs x};
d18p2e:{
    x:x except" ";
    while[any x in"(+*";
        level:sums(x="(")-(" ",-1_x)=")";
        split:0,where 0<>deltas level=max level;
        p:split cut x;
        ci:1+2*til count[p] div 2;
        p[ci]:string prd each value each/:"*"vs/:p[ci]except\:"()";
        x:raze p;
    ];
    "J"$x};
d18p2:{sum d18p2e each "\n"vs x};

/
d18p1 x:"1 + (2 * 3) + (4 * (5 + 6))"
d18p1 x:"2 * 3 + (4 * 5)"
d18p1 x:"5 + (8 * 3 + 9 + 3 * 4 * 3)"
d18p1 x:"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
d18p1 x:"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"

d18p2 x:"1 + 2 * 3 + 4 * 5 + 6"
d18p2 x:"1 + (2 * 3) + (4 * (5 + 6))"
d18p2 x:"2 * 3 + (4 * 5)"
d18p2 x:"5 + (8 * 3 + 9 + 3 * 4 * 3)"
d18p2 x:"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
d18p2 x:"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"

OVERVIEW:

PART 1:
This might count as a cheat. We reverse the string, replace the parentheses with the opposite ones
and then evaluate the resulting string. Since all the numbers are single digits, the reversal
won't break any of the numbers. And due to the right-to-left evaluation order the reversed string
will exactly yield the desired result.

PART 2:
We iteratively evaluate the innermost parentheses and substitute the result. The sums function
allows finding the nesting level (by mapping "(" to 1 and ")" to -1). Within each pair of
parentheses we can cut on "*" and evaluate the remaining subexpressions which will all be
additions, then multiply the results together. We also must not forget to remove the parentheses.
The expression is turned back into a sting in every iteration.
