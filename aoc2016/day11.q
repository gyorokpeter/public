.d11.statestr:{b:(-2#0b vs x[0]),raze raze(til[.d11.mxc])in/:/:(distinct raze raze x[1])?x[1];0b sv ((64-count b)#0b),b};
.d11.parse:{[lines]
    flcg:{words:4_" "vs x except ",.";
        chi:where words like "microchip";
        ch:`$first each "-"vs/:words[chi-1];
        gni:where words like "generator";
        gn:`$words[gni-1];
    (ch;gn)}each lines;
    els:distinct raze raze flcg;
    flcg:asc each/:els?flcg;
    .d11.mxc:1+max raze raze flcg;
    state:(0;flcg);
    state};
.d11.bfs:{[states;finalstate]
    found:0b;
    while[not found;
        toexpand:select id:i,state,ststr,visited,parent,lastmove,moves from states where not visited;
        states[exec id from toexpand;`visited]:1b;
        newstates:raze{
            fl:x[`state;0];
            ch:x[`state;1;fl;0];
            gn:x[`state;1;fl;1];
            mvf:$[fl=0;enlist 1;fl in 1 2;-1 1;enlist -1];
            mv1c:(enlist each ch)(;)\:`long$();
            mv2c:(enlist each distinct asc each raze ch,/:'ch except/:ch),\:enlist`long$();
            mv1g:(`long$())(;)/:enlist each gn;
            mv2g:enlist[`long$()],/:(enlist each distinct asc each raze gn,/:'gn except/:gn);
            mvcg:enlist each/:ch cross gn;
            mvall:mv1c,mv2c,mv1g,mv2g,mvcg;
            mvall2:mvf cross mvall;
            nst:raze({[state;mfl;mch;mgn]
                if[(mfl=-1)and (state[0]=1);if[0=count raze state[1;0]; :()]];    //don't go down to empty floor 1
                if[(mfl=-1)and (state[0]=2);if[0=count raze raze state[1;0 1]; :()]];    //don't go down to empty floor 1+2
                state[1;state[0];0]:state[1;state[0];0] except mch;
                state[1;state[0];1]:state[1;state[0];1] except mgn;
                state[0]+:mfl;
                state[1;state[0];0]:asc state[1;state[0];0],mch;
                state[1;state[0];1]:asc state[1;state[0];1],mgn;
                if[any(0<count each state[1;;0]except'state[1;;1]) and 0<count each state[1;;1]; :()];  //fried chips
                ([]enlist state;ststr:enlist .d11.statestr state;lastmove:enlist(mfl;mch;mgn))
            }[x`state].)'[mvall2];
            (key[x]except`id)xcols update visited:0b, parent:x`id, moves:1+x`moves from nst
        }each toexpand;
        newstates:cols[states] xcols 0!select last state,last visited,last parent,last lastmove,last moves by ststr from newstates;
        newstates:select from newstates where not ststr in (exec ststr from states);
        found:finalstate in exec state from newstates;
        states:states,newstates;
        -1"states: ",string[count states]," new: ",string[count newstates];
    ];
    states};

d11p1:{
    fl:"\n"vs x;
    state:.d11.parse fl;
    finalstate:(3;(3#enlist(`long$();`long$())),enlist(asc raze state[1;;0];asc raze state[1;;1]));
    states:([]enlist state; ststr:enlist .d11.statestr state;visited:enlist 0b;parent:enlist 0N;lastmove:enlist`$();moves:enlist 0);
    states:.d11.bfs[states;finalstate];
    states[states[`state]?finalstate;`moves]}

d11p2:{
    fl:("\n"vs x),'("     elerium generator elerium- microchip dilithium generator dilithium- microchip";"";"";"");
    state:.d11.parse fl;
    finalstate:(3;(3#enlist(`long$();`long$())),enlist(asc raze state[1;;0];asc raze state[1;;1]));
    states:([]enlist state; ststr:enlist .d11.statestr state;visited:enlist 0b;parent:enlist 0N;lastmove:enlist`$();moves:enlist 0);
    states:.d11.bfs[states;finalstate];
    states[states[`state]?finalstate;`moves]}

d11p1"The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.\nThe second floor contains a hydrogen generator.\nThe third floor contains a lithium generator.\nThe fourth floor contains nothing relevant."
d11p2"\n\n\n"

d11p2 inp
//OVERVIEW:
//We use BFS (breadth first search).
//The state consists of the elevator position (0-3) and the contents of each floor.
//The purpose of "ststr" is to make it quicker to filter out repeated states, since 
//comparing the nested-list-based state is much slower than the integer-based approach.
//Part 2 only differs in the input parsing: we simply add on a mock input string that
//matches the format expected by the parser.
//Optimizations suggested by p_tseng on reddit. The "all pairs are equivalent"
//optimization is done by re-enumerating the numbers in the ststr generation.