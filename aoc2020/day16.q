d16p1:{s:"\n\n"vs x;
    rule:asc"J"$"-"vs/:raze " or "vs/:last each": "vs/:"\n"vs s[0];
    tk:"J"$","vs/:1_"\n"vs s[2];
    sum raze tk@'{where not any x}each tk within\:/:\:rule};
d16p2:{s:"\n\n"vs x;
    rule:ungroup{([]field:`$x[;0];range:"J"$"-"vs/:/:" or "vs/:x[;1])}": "vs/:"\n"vs s[0];
    tk:"J"$","vs/:1_"\n"vs s[2];
    tk:tk where {all any x} each tk within\:/:\:rule[`range];
    fmap:count[first tk]#`;
    a:rule[`field]where each/:tk within/:\:\:rule[`range];
    while[any null fmap;
        poss:(inter')/[a];
        uniq:where 1=count each poss;
        fmap[uniq]:poss[uniq;0];
        miss:where null fmap;
        a[;miss]:a[;miss] except\:\:fmap;
    ];
    ytk:"J"$","vs last"\n"vs s[1];
    prd ytk where fmap like "departure*"};

/
d16p1 x:"\n"sv("class: 1-3 or 5-7"
              ;"row: 6-11 or 33-44"
              ;"seat: 13-40 or 45-50"
              ;""
              ;"your ticket:"
              ;"7,1,14"
              ;""
              ;"nearby tickets:"
              ;"7,3,47"
              ;"40,4,50"
              ;"55,2,20"
              ;"38,6,12")

d16p2 x:"\n"sv("class: 0-1 or 4-19"
              ;"row: 0-5 or 8-19"
              ;"seat: 0-13 or 16-19"
              ;""
              ;"your ticket:"
              ;"11,12,13"
              ;""
              ;"nearby tickets:"
              ;"3,9,18"
              ;"15,1,5"
              ;"5,14,9")

OVERVIEW:

This day was mostly about input parsing which simply involves a lot of "vs" in q.

PART 1:
We parse the rules into a list of lists. Each element is one field and each subelement is a range.
It turns out that in the actual input there are always two ranges for each rule, but this code
would handle any of them as long as they are separated with " or ".
Then we also parse the tickets into a matrix and use "within" to match each number with each rule.
This requires the iterator combination tk within\:/:\:rule. This makes sure that every number in
every ticket is matched to every rule. Then we figure out which are the cells that only contain
false values which means they didn't match any rule.

PART 2:
This time we parse the rules into a table and ungroup them, such that each range gets its own row
with the matching label. Like in part 1 we figure out the invalid values but this time we simply
drop them from the ticket list. Then we make a matrix of which rule matches which field in each
ticket. We then intersect each column in the matrix which will result in the possible labels for
each field. If there is a field with only one label it means we have found a field that is not
ambiguous. We iteratively narrow down which field is which by keeping a map of the
known fields and removing them from the matrix. We then take the intersections again. This way we
eventually end up with a complete mapping of all fields.