d22p1:{decks:"J"$1_/:"\n"vs/:"\n\n"vs x;
    while[0<prd count each decks;
        $[decks[0;0]>decks[1;0];
            decks:((1_decks[0]),decks[0;0],decks[1;0];1_decks[1]);
            decks:(1_decks[0];(1_decks[1]),decks[1;0],decks[0;0])];
        ];
    cards:reverse raze decks;
    sum(1+til count cards)*cards};
d22p2:{decks:"J"$1_/:"\n"vs/:"\n\n"vs x;
    memo:();
    stack:();
    round:0;
    while[0<prd count each decks;
        round+:1;
        $[first enlist[decks] in memo;
            decks:(decks[0];`long$());
          any(first each decks)>-1+count each decks;
            [memo,:enlist decks;
            $[decks[0;0]>decks[1;0];
                decks:((1_decks[0]),decks[0;0],decks[1;0];1_decks[1]);
                decks:(1_decks[0];(1_decks[1]),decks[1;0],decks[0;0])];
            ];
          [stack:stack,enlist(memo;decks);memo:();decks:decks[;0]#'1_/:decks]];
        if[0<count stack;if[any 0=count each decks;
            winner:first where 0<count each decks;
            memo:first last stack;
            decks:last last stack;
            memo,:enlist decks;
            stack:-1_stack;
            moveCards:decks[winner;0],decks[1-winner;0];
            decks:(1_/:decks);
            decks[winner],:moveCards;
        ]];
    ];
    cards:reverse raze decks;
    sum(1+til count cards)*cards};

/
OVERVIEW:

A straightforward simulation.
For part 2 we don't use actual recursion but maintain a stack using a list that gets the visited
game states and the decks pushed into it. Part 2 is slow due to all the array shuffling and the
lack of a hashed data structure to check for already visited states.