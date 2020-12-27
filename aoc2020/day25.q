d25:{pk:"J"$"\n"vs x;
    b:7;c:1;
    while[b<>pk 0; c+:1; b:(b*7) mod 20201227];
    d:e:pk 1;
    do[c-1;e:(e*d) mod 20201227];
    e};

/
d25 x:"5764801\n17807724"

OVERVIEW:
Straightforward iterative search. Just one of the two loop sizes is enough to find the answer.