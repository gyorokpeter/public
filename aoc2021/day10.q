d10p1:{
    a:"\n"vs x;
    b:{{ssr[;;""]/[x;("[[]]";"()";"{}";"<>")]}/[x]}each a;
    sum(")]}>"!3 57 1197 25137)(first each b inter\:")]}>")except" "};
d10p2:{
    a:"\n"vs x;
    b:{{ssr[;;""]/[x;("[[]]";"()";"{}";"<>")]}/[x]}each a;
    c:b where not any each ")]}>" in/:b;
    med 5 sv/:("([{<"!1+til 4)reverse each c};

/
x:"[({(<(())[]>[[{[]{<()<>>\n[(()[<>])]({[<{<<[]>>(\n{([(<{}[<>[]}>{[]{[(<(";
x,:")>\n(((({<>}<{<{<>}{[]{[]{}\n[[<[([]))<([[{}[[()]]]\n[{[{({}]{}}([{[{{{}}";
x,:"([]\n{<[[]]>}<{[{[{[]{()[[[]\n[<(<(<(<{}))><([]([]()\n<{([([[(<>()){}]>(<";
x,:"<{{\n<{([{{}}[<[[[<>{}]]]>[]]"
d10p1 x
d10p2 x

BREAKDOWN:
We split the input into lines:

q)a:"\n"vs x;
q)a
"[({(<(())[]>[[{[]{<()<>>"
"[(()[<>])]({[<{<<[]>>("
"{([(<{}[<>[]}>{[]{[(<()>"
...

PART 1:
The "ssr" function can be used to replace a character sequence with another. Combined with the /
iterator, it can replace multiple sequences - in this case all the pairs of matching brackets. The
only thing to watch out for is [], which has special meaning and so must be specified as [[]].
Also ssr only passes through the string once, and each replacement may open up new pairs of
brackets to remove, so we need to iterate it with another / until the input no longer changes:
q)b
"[({([[{{"
"({[<{("
"{([(<[}>{{[("

After all the replacements, the only closing brackets left over are those that are mismatched, so
we filter to those:
b inter\:")]}>"
q)b inter\:")]}>"
""
""
"}>"
""

And take the first of these:
q)first each b inter\:")]}>"
"  } )] )> "

Since taking the first element of an empty list returns a null (in this case a space) we also need
to get rid of those:
q)(first each b inter\:")]}>")except" "
"})])>"

Then we apply a mapping to find the scores and sum them up.
q)(")]}>"!3 57 1197 25137)(first each b inter\:")]}>")except" "
1197 3 57 3 25137
q)sum(")]}>"!3 57 1197 25137)(first each b inter\:")]}>")except" "
26397

PART 2:
We do the replacements like before. But this time we remove the lines with any closing bracket:
q)c:b where not any each ")]}>" in/:b;
q)c
"[({([[{{"
"({[<{("
"((((<{<{{"
"<{[{[{{[["
"<{(["

The matching brackets will be the same types but in reverse order:
q)reverse each c
"{{[[({(["
"({<[{("
"{{<{<(((("
"[[{{[{[{<"
"[({<"

And in fact we don't even need to generate the closing brackets, we can just apply the scoring to
the opening ones:
q)("([{<"!1+til 4)reverse each c
3 3 2 2 1 3 1 2
1 3 4 2 3 1
3 3 4 3 4 1 1 1 1
...

We then use the "interpret as base X number" feature of "sv" to calculate the scores:
q)5 sv/:("([{<"!1+til 4)reverse each c
288957 5566 1480781 995444 294

And luckily q has a "med" function to get the median:
q)med 5 sv/:("([{<"!1+til 4)reverse each c
288957f
