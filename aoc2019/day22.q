.d22.shuffle:{[c;x]
    .d22.incr:enlist[0N]!enlist[0#0];
    a:"\n"vs x;
    b:{[c;x]$[x~"deal into new stack";reverse;
      x like "deal with increment*";
        [d:"J"$last" "vs x;if[not d in key .d22.incr; .d22.incr[d]:iasc (d*til c)mod c];@[;.d22.incr[d]]];
      x like "cut*";
        [d:"J"$last" "vs x;$[d>0;{[d;x](d _x),d#x}[d];{[d;x](d#x),d _x}[d]]];
      {'"unknown:",x}[x]]}[c]each a;
    deck:til c;
    {y x}/[deck;b]};

d22p1:{[c;x].d22.shuffle[c;x]?2019};

madd:{[a;b;m](a+b)mod m};
mmul:{[a;b;m]
    b:b mod m;
    r:0;
    while[b>0;
        if[1=b mod 2;r:madd[r;a;m]];
        b:b div 2;
        a:madd[a;a;m];
    ];
    r};
mexp:{[a;b;m]
    r:1;
    while[b>0;
        if[1=b mod 2;r:mmul[r;a;m]];
        b:b div 2;
        a:mmul[a;a;m];
    ];
    r};
minv:{[a;m]
    mexp[a;m-2;m]};

d22p2:{[c;iters;x]
    a:"\n"vs x;
    b:{[c;x]$[x~"deal into new stack";{[c;x]x[1]:mmul[x[1];-1;c];x[0]:madd[x[0];x[1];c];x}[c];
      x like "deal with increment*";
        [d:"J"$last" "vs x;{[c;d;x]x[1]:mmul[x[1];minv[d;c];c];x}[c;d]];
      x like "cut*";
        [d:"J"$last" "vs x;{[c;d;x]x[0]:madd[x[0];mmul[x[1];d;c];c];x}[c;d]];
      {'"unknown:",x}[x]]}[c]each a;

    cycle:{y x}/[0 1;b];
    offsetDiff:cycle 0;
    incrementMul:cycle 1;
    increment:mexp[incrementMul;iters;c];
    offset:mmul[cycle 0;mmul[madd[1;neg increment;c];minv[madd[1;neg incrementMul;c];c];c];c];
    card:madd[offset;mmul[increment;2020;c];c];
    card};

//d22p1[10007;"deal into new stack\ndeal with increment 25\ncut -5919\ndeal with increment 56\ndeal into new stack\ndeal with increment 20\ndeal into new stack\ndeal with increment 53\ncut 3262\ndeal with increment 63\ncut 3298\ndeal into new stack\ncut -4753\ndeal with increment 57\ndeal into new stack\ncut 9882\ndeal with increment 42\ndeal into new stack\ndeal with increment 40\ncut 2630\ndeal with increment 32\ncut 1393\ndeal with increment 74\ncut 2724\ndeal with increment 23\ncut -3747\ndeal into new stack\ncut 864\ndeal with increment 61\ndeal into new stack\ncut -4200\ndeal with increment 72\ncut -7634\ndeal with increment 32\ndeal into new stack\ncut 6793\ndeal with increment 38\ncut 7167\ndeal with increment 10\ncut -9724\ndeal into new stack\ncut 6047\ndeal with increment 37\ncut 7947\ndeal with increment 63\ndeal into new stack\ndeal with increment 9\ncut -9399\ndeal with increment 26\ncut 1154\ndeal with increment 74\ndeal into new stack\ncut 3670\ndeal with increment 45\ncut 3109\ndeal with increment 64\ncut -7956\ndeal with increment 39\ndeal into new stack\ndeal with increment 61\ncut -9763\ndeal with increment 20\ncut 4580\ndeal with increment 30\ndeal into new stack\ndeal with increment 62\ndeal into new stack\ncut -997\ndeal with increment 54\ncut -1085\ndeal into new stack\ncut -9264\ndeal into new stack\ndeal with increment 11\ncut 6041\ndeal with increment 9\ndeal into new stack\ncut 5795\ndeal with increment 26\ncut 5980\ndeal with increment 38\ncut 1962\ndeal with increment 25\ncut -565\ndeal with increment 45\ncut 9490\ndeal with increment 21\ncut -3936\ndeal with increment 64\ndeal into new stack\ncut -7067\ndeal with increment 75\ncut -3975\ndeal with increment 29\ndeal into new stack\ncut -7770\ndeal into new stack\ndeal with increment 12\ncut 8647\ndeal with increment 49"]
//d22p2[119315717514047;101741582076661;"deal into new stack\ndeal with increment 25\ncut -5919\ndeal with increment 56\ndeal into new stack\ndeal with increment 20\ndeal into new stack\ndeal with increment 53\ncut 3262\ndeal with increment 63\ncut 3298\ndeal into new stack\ncut -4753\ndeal with increment 57\ndeal into new stack\ncut 9882\ndeal with increment 42\ndeal into new stack\ndeal with increment 40\ncut 2630\ndeal with increment 32\ncut 1393\ndeal with increment 74\ncut 2724\ndeal with increment 23\ncut -3747\ndeal into new stack\ncut 864\ndeal with increment 61\ndeal into new stack\ncut -4200\ndeal with increment 72\ncut -7634\ndeal with increment 32\ndeal into new stack\ncut 6793\ndeal with increment 38\ncut 7167\ndeal with increment 10\ncut -9724\ndeal into new stack\ncut 6047\ndeal with increment 37\ncut 7947\ndeal with increment 63\ndeal into new stack\ndeal with increment 9\ncut -9399\ndeal with increment 26\ncut 1154\ndeal with increment 74\ndeal into new stack\ncut 3670\ndeal with increment 45\ncut 3109\ndeal with increment 64\ncut -7956\ndeal with increment 39\ndeal into new stack\ndeal with increment 61\ncut -9763\ndeal with increment 20\ncut 4580\ndeal with increment 30\ndeal into new stack\ndeal with increment 62\ndeal into new stack\ncut -997\ndeal with increment 54\ncut -1085\ndeal into new stack\ncut -9264\ndeal into new stack\ndeal with increment 11\ncut 6041\ndeal with increment 9\ndeal into new stack\ncut 5795\ndeal with increment 26\ncut 5980\ndeal with increment 38\ncut 1962\ndeal with increment 25\ncut -565\ndeal with increment 45\ncut 9490\ndeal with increment 21\ncut -3936\ndeal with increment 64\ndeal into new stack\ncut -7067\ndeal with increment 75\ncut -3975\ndeal with increment 29\ndeal into new stack\ncut -7770\ndeal into new stack\ndeal with increment 12\ncut 8647\ndeal with increment 49"]

/
OVERVIEW:
Part 1:
First we compile each instruction into a function that generates the next permutation of
cards from the previous one. For "deal into new stack" this is just reverse, for "cut" we
swap the beginning and end, noting that different logic is needed for negative offsets.
For "deal with increment" we generate a sequence of positions and mod it by the card count
to find where each card ends up, then use iasc to get the permutation.
Finally we apply the list of functions to the initial permutation and find where 2019 appears.

Part 2:
Solution stolen and q-ified from:
https://github.com/mcpower/adventofcode/blob/501b66084b0060e0375fc3d78460fb549bc7dfab/2019/22/a-improved.py
