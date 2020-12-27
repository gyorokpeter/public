d7:{a:" bags contain " vs/:"\n"vs x;
    b:{?[x~\:"no other bags.";count[x]#enlist();", "vs/:x]}a[;1];
    c:-1_/:/:" "vs/:/:b;
    (`$a[;0])!c};
d7p1:{
    ac:d7 x;
    d:`$" "sv/:/:1_/:/:ac;
    e:{distinct each x,'raze each x x}/[d];
    sum(`$"shiny gold")in/:e};
d7p2:{
    ac:d7 x;
    d:("J"$ac[;;0]),''`$" "sv/:/:1_/:/:ac;
    g:{[d;x]e:d key x;
        e[;;0]*:value x;
        f:e where 0<count each e;
        ((`$())!0#0),sum(!).'reverse each flip each f}[d]\[enlist[`$"shiny gold"]!enlist 1];
    -1+sum raze value each g};


/
d7p1 x:"\n"sv("light red bags contain 1 bright white bag, 2 muted yellow bags."
             ;"dark orange bags contain 3 bright white bags, 4 muted yellow bags."
             ;"bright white bags contain 1 shiny gold bag."
             ;"muted yellow bags contain 2 shiny gold bags, 9 faded blue bags."
             ;"shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags."
             ;"dark olive bags contain 3 faded blue bags, 4 dotted black bags."
             ;"vibrant plum bags contain 5 faded blue bags, 6 dotted black bags."
             ;"faded blue bags contain no other bags."
             ;"dotted black bags contain no other bags.")

d7p1 x:"\n"sv("shiny gold bags contain 2 dark red bags."
             ;"dark red bags contain 2 dark orange bags."
             ;"dark orange bags contain 2 dark yellow bags."
             ;"dark yellow bags contain 2 dark green bags."
             ;"dark green bags contain 2 dark blue bags."
             ;"dark blue bags contain 2 dark violet bags."
             ;"dark violet bags contain no other bags.")

BREAKDOWN:

COMMON:
The input parsing will be used for both parts.
For the example input of part 1:
q)x
"light red bags contain 1 bright white bag, 2 muted yellow bags.\..

We cut the input into lines:
q)"\n"vs x
"light red bags contain 1 bright white bag, 2 muted yellow bags."
"dark orange bags contain 3 bright white bags, 4 muted yellow bags."
"bright white bags contain 1 shiny gold bag."
..

Each row has a key and value, separated by the "symbol" " bags contain ". So we cut on this.
q)a
"light red"    "1 bright white bag, 2 muted yellow bags."
"dark orange"  "3 bright white bags, 4 muted yellow bags."
"bright white" "1 shiny gold bag."
..

The next step is different depending on whether the value part contains "no other bags." which
corresponds to an empty list, or something else, which corresponds to a list of (count; color)
pairs. For the latter case we need to cut the value part on ", ".
q)b:{?[x~\:"no other bags.";count[x]#enlist();", "vs/:x]}a[;1];
q)b
("1 bright white bag";"2 muted yellow bags.")
("3 bright white bags";"4 muted yellow bags.")
,"1 shiny gold bag."
("2 shiny gold bags";"9 faded blue bags.")
("1 dark olive bag";"2 vibrant plum bags.")
("3 faded blue bags";"4 dotted black bags.")
("5 faded blue bags";"6 dotted black bags.")
()
()

We cut the lists on spaces (2 levels of nesting so /:/: is necessary):
q)" "vs/:/:b
((,"1";"bright";"white";"bag");(,"2";"muted";"yellow";"bags."))
((,"3";"bright";"white";"bags");(,"4";"muted";"yellow";"bags."))
,(,"1";"shiny";"gold";"bag.")
((,"2";"shiny";"gold";"bags");(,"9";"faded";"blue";"bags."))
((,"1";"dark";"olive";"bag");(,"2";"vibrant";"plum";"bags."))
((,"3";"faded";"blue";"bags");(,"4";"dotted";"black";"bags."))
((,"5";"faded";"blue";"bags");(,"6";"dotted";"black";"bags."))
()
()

We remove the final element which could be "bag", "bags", "bag." etc. - we don't care since
exactly one of those is there.

q)c:-1_/:/:" "vs/:/:b
q)c
((,"1";"bright";"white");(,"2";"muted";"yellow"))
((,"3";"bright";"white");(,"4";"muted";"yellow"))
,(,"1";"shiny";"gold")
((,"2";"shiny";"gold");(,"9";"faded";"blue"))
((,"1";"dark";"olive");(,"2";"vibrant";"plum"))
((,"3";"faded";"blue");(,"4";"dotted";"black"))
((,"5";"faded";"blue");(,"6";"dotted";"black"))
()
()

We return a dictionary with the keys converted to symbols, but the other values remain strings.
The code for parts 1 and 2 will continue processing.
q)(`$a[;0])!c
light red   | ((,"1";"bright";"white");(,"2";"muted";"yellow"))
dark orange | ((,"3";"bright";"white");(,"4";"muted";"yellow"))
bright white| ,(,"1";"shiny";"gold")
muted yellow| ((,"2";"shiny";"gold");(,"9";"faded";"blue"))
shiny gold  | ((,"1";"dark";"olive");(,"2";"vibrant";"plum"))
dark olive  | ((,"3";"faded";"blue");(,"4";"dotted";"black"))
vibrant plum| ((,"5";"faded";"blue");(,"6";"dotted";"black"))
faded blue  | ()
dotted black| ()

PART 1:
We only need the colors of the contained bags, so we drop the numbers:
q)1_/:/:ac
light red   | (("bright";"white");("muted";"yellow"))
dark orange | (("bright";"white");("muted";"yellow"))
bright white| ,("shiny";"gold")
muted yellow| (("shiny";"gold");("faded";"blue"))
shiny gold  | (("dark";"olive");("vibrant";"plum"))
dark olive  | (("faded";"blue");("dotted";"black"))
vibrant plum| (("faded";"blue");("dotted";"black"))
faded blue  | ()
dotted black| ()

We merge the colors back into whole strings:
q)" "sv/:/:1_/:/:ac
light red   | ("bright white";"muted yellow")
dark orange | ("bright white";"muted yellow")
bright white| ,"shiny gold"
muted yellow| ("shiny gold";"faded blue")
shiny gold  | ("dark olive";"vibrant plum")
dark olive  | ("faded blue";"dotted black")
vibrant plum| ("faded blue";"dotted black")
faded blue  | ()
dotted black| ()

And we cast them to symbols. Note that all of this still preserves the dictionary.
q)d:`$" "sv/:/:1_/:/:ac;
q)d
light red   | `bright white`muted yellow
dark orange | `bright white`muted yellow
bright white| ,`shiny gold
muted yellow| `shiny gold`faded blue
shiny gold  | `dark olive`vibrant plum
dark olive  | `faded blue`dotted black
vibrant plum| `faded blue`dotted black
faded blue  | `symbol$()
dotted black| `symbol$()

We would like to find the transitive closure of each color. This can be done by applying the
dictionary to itself and razing and deduplicating the results until it no longer changes.

One step of this might look like:
We apply the dictionary to itself:
q)d d
light red   | (,`shiny gold;`shiny gold`faded blue)
dark orange | (,`shiny gold;`shiny gold`faded blue)
bright white| ,`dark olive`vibrant plum
muted yellow| (`dark olive`vibrant plum;`symbol$())
shiny gold  | (`faded blue`dotted black;`faded blue`dotted black)
dark olive  | (`symbol$();`symbol$())
vibrant plum| (`symbol$();`symbol$())
faded blue  | ()
dotted black| ()

We raze the resulting lists:
q)raze each d d
light red   | `shiny gold`shiny gold`faded blue
dark orange | `shiny gold`shiny gold`faded blue
bright white| `dark olive`vibrant plum
muted yellow| `dark olive`vibrant plum
shiny gold  | `faded blue`dotted black`faded blue`dotted black
dark olive  | `symbol$()
vibrant plum| `symbol$()
faded blue  | ()
dotted black| ()

We join the original elements to the results:
q)d,'raze each d d
light red   | `bright white`muted yellow`shiny gold`shiny gold`faded blue
dark orange | `bright white`muted yellow`shiny gold`shiny gold`faded blue
bright white| `shiny gold`dark olive`vibrant plum
muted yellow| `shiny gold`faded blue`dark olive`vibrant plum
shiny gold  | `dark olive`vibrant plum`faded blue`dotted black`faded blue`dotted black
dark olive  | `faded blue`dotted black
vibrant plum| `faded blue`dotted black
faded blue  | `symbol$()
dotted black| `symbol$()

Then we take the distinct sets:
q)distinct each d,'raze each d d
light red   | `bright white`muted yellow`shiny gold`faded blue
dark orange | `bright white`muted yellow`shiny gold`faded blue
bright white| `shiny gold`dark olive`vibrant plum
muted yellow| `shiny gold`faded blue`dark olive`vibrant plum
shiny gold  | `dark olive`vibrant plum`faded blue`dotted black
dark olive  | `faded blue`dotted black
vibrant plum| `faded blue`dotted black
faded blue  | `symbol$()
dotted black| `symbol$()

Now we wrap this into a function:
    {distinct each x,'raze each x x}

The "until it no longer changes" part is taken care of by the / iterator.
q)e:{distinct each x,'raze each x x}/[d];
q)e
light red   | `bright white`muted yellow`shiny gold`faded blue`dark olive`vibrant plum`dotted black
dark orange | `bright white`muted yellow`shiny gold`faded blue`dark olive`vibrant plum`dotted black
bright white| `shiny gold`dark olive`vibrant plum`faded blue`dotted black
muted yellow| `shiny gold`faded blue`dark olive`vibrant plum`dotted black
shiny gold  | `dark olive`vibrant plum`faded blue`dotted black
dark olive  | `faded blue`dotted black
vibrant plum| `faded blue`dotted black
faded blue  | `symbol$()
dotted black| `symbol$()

We find which of the lists contain "shiny gold".
q)(`$"shiny gold")in/:e
light red   | 1
dark orange | 1
bright white| 1
muted yellow| 1
shiny gold  | 0
dark olive  | 0
vibrant plum| 0
faded blue  | 0
dotted black| 0

The answer is the sum of these values. It works just as well on a dictionary as on a list.
q)sum(`$"shiny gold")in/:e
4i

PART 2:
We still find the color names and turn them into symbols:
q)`$" "sv/:/:1_/:/:ac
light red   | `bright white`muted yellow
dark orange | `bright white`muted yellow
bright white| ,`shiny gold
muted yellow| `shiny gold`faded blue
shiny gold  | `dark olive`vibrant plum
dark olive  | `faded blue`dotted black
vibrant plum| `faded blue`dotted black
faded blue  | `symbol$()
dotted black| `symbol$()

But we also take the numbers and turn them into integers:
q)("J"$ac[;;0])
light red   | 1 2
dark orange | 3 4
bright white| ,1
muted yellow| 2 9
shiny gold  | 1 2
dark olive  | 3 4
vibrant plum| 5 6
faded blue  | `long$()
dotted black| `long$()

We pair up each number with the corresponding color. This requires ,'' due to the nesting involved.
q)d:("J"$ac[;;0]),''`$" "sv/:/:1_/:/:ac;
q)d
light red   | ((1;`bright white);(2;`muted yellow))
dark orange | ((3;`bright white);(4;`muted yellow))
bright white| ,(1;`shiny gold)
muted yellow| ((2;`shiny gold);(9;`faded blue))
shiny gold  | ((1;`dark olive);(2;`vibrant plum))
dark olive  | ((3;`faded blue);(4;`dotted black))
vibrant plum| ((5;`faded blue);(6;`dotted black))
faded blue  | ()
dotted black| ()

We will once again iterate through a function. The input will be the state which is a dictionary
mapping colors to the number of bags we need of that color. Initially this will be a single shiny
gold bag:
q)x:enlist[`$"shiny gold"]!enlist 1

We index into the dictionary to find what bags we need for the colors we have (the keys of x):
q)e:d key x
q)e
1 `dark olive   2 `vibrant plum

We multiply the numbers in each row by the number of bags we have:
q)e[;;0]*:value x;
q)e
1 `dark olive   2 `vibrant plum

(Still the same because we multiplied by 1 this time.)
We filter down to the non-empty rows:
q)f:e where 0<count each e
q)f
1 `dark olive   2 `vibrant plum

Then we need to build another dictionary that matches the input. Right now the lists are in (num;
color) pairs. We flip them to get all the numbers in one list and all the colors in another:

q)flip each f
1          2            dark olive vibrant plum

Then we also reverse them such that the colors are first (as they should be the keys):
q)reverse each flip each f
dark olive vibrant plum 1          2

We turn these into dictionaries using the ! operator (similar to day 4):
q)(!).'reverse each flip each f
dark olive vibrant plum
-----------------------
1          2

And we sum the dictionaries to get just one:
q)sum(!).'reverse each flip each f
dark olive  | 1
vibrant plum| 2

But we also need to make sure to return the correct type if the result would be empty. This is a
common problem when using general lists, including the result of "each". The solution is to
prepend a dictionary with the correct type:
q)((`$())!0#0),sum(!).'reverse each flip each f
dark olive  | 1
vibrant plum| 2

Finally we can wrap this in a function, but since we need access to d, that will also need to be a
parameter that will immediately be bound to it.
        {[d;x]e:d key x;
        e[;;0]*:value x;
        f:e where 0<count each e;
        ((`$())!0#0),sum(!).'reverse each flip each f}[d]
We will now iterate this function until we get an empty result (which will not change any more).
But we need the intermediate results so we iterate with \.
    g:{[d;x]e:d key x;
        e[;;0]*:value x;
        f:e where 0<count each e;
        ((`$())!0#0),sum(!).'reverse each flip each f}[d]\[enlist[`$"shiny gold"]!enlist 1];

The result will look like:
q)g
(,`shiny gold)!,1
`dark olive`vibrant plum!1 2
`faded blue`dotted black!13 16
(`symbol$())!`long$()

So we have a list of dictionaries, but we only care about the values.
q)value each g
,1
1 2
13 16
`long$()

And we can raze and sum these to get the total count.
q)sum raze value each g
33

However this is one more than the answer because it includes the initial state. So we subtract 1.
q)-1+sum raze value each g
32
