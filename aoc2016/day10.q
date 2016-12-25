d10:{
    ins:"\n"vs x;
    insp:{p:" "vs x;$[p[0]~"value";(`$"i",p[1];`$p[4],p[5]);(`$p[0],p[1];`$p[5],p[6];`$p[10],p[11])]}each ins;
    state:1!update inp:"J"$1_/:string inp from (flip`inp`loc!flip insp where 2=count each insp);
    moves:1!flip`loc`low`high!flip insp where 3=count each insp;
    res:{[mv;cmst]
        cmps:select loc,asc each inp from 0!`loc xgroup cmst[1] where loc like "bot*",2=count each inp;
        cmv:(select lowv:inp[;0],highv:inp[;1] from cmps),'mv[select loc from cmps];
        :(cmst[0],cmps;cmst[1],1!(select inp:lowv,loc:low from cmv),(select inp:highv,loc:high from cmv));
    }[moves]/[(();state)];
    res}
d10p1:{"J"$3_string exec first loc from d10[x][0] where inp~\:17 61}
d10p2:{prd exec inp from d10[x][1] where loc in`output0`output1`output2}

d10p1"value 61 goes to bot 2\nbot 2 gives low to bot 1 and high to bot 0\nvalue 17 goes to bot 1\nbot 1 gives low to output 1 and high to bot 0\nbot 0 gives low to output 2 and high to output 0\nvalue 2 goes to bot 2"
d10p2"value 61 goes to bot 2\nbot 2 gives low to bot 1 and high to bot 0\nvalue 17 goes to bot 1\nbot 1 gives low to output 1 and high to bot 0\nbot 0 gives low to output 2 and high to output 0\nvalue 2 goes to bot 2"

//OVERVIEW:
//The input is split into "state" and "moves".
//Then we use a repetitive function to generate the next state from the previous, by
//looking up the moves for bots that have 2 chips in the current state.
//The "/" adverb is used in the "converge" sense here, so it stops when returned state
//is identical to the previous, i.e. there are no more moves to make (all chips are
//either in outputs, bots with only one chip, or bots with no move).
//In addition to the current state we also keep the list of comparisons made which is
//required for Part 1.