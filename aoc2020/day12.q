d12p1:{
    a:"\n"vs x;
    d:first each a;
    p:"J"$1_/:a;
    rel:where d in "FLR";
    drel:d rel;
    prel:p rel;
    f:(1+\(prel div 90)*("LR"!-1 1)drel)mod 4;
    pa:sum prel*(drel="F")*(0 1;1 0;0 -1;-1 0)f;
    ab:where d in "NESW";
    dabs:d ab;
    pabs:p ab;
    pb:sum pabs*("NESW"!(0 1;1 0;0 -1;-1 0))dabs;
    sum abs pa+pb};
d12p2:{
    a:"\n"vs x;
    d:first each a;
    p:"J"$1_/:a;
    st:(0 0;10 1);
    op:()!();
    op["N"]:{x[1;1]+:y;x};
    op["E"]:{x[1;0]+:y;x};
    op["S"]:{x[1;1]-:y;x};
    op["W"]:{x[1;0]-:y;x};
    op["L"]:{x[1]:sum((90 180 270!((0 1;-1 0);(-1 0;0 -1);(0 -1;1 0)))y)*x[1];x};
    op["R"]:{x[1]:sum((270 180 90!((0 1;-1 0);(-1 0;0 -1);(0 -1;1 0)))y)*x[1];x};
    op["F"]:{x[0]+:y*x[1];x};
    est:{y[x;z]}/[st;op d;p];
    sum abs est 0};

/
d12p1 x:"F10\nN3\nF7\nR90\nF11"

OVERVIEW:
Both parts are straightforward simulations.

PART 1:
For this part it is possible to separate the absolute and relative commands and then add together
the results. For the relative commands we first calculate the direction the ship will face after
each command, and then combine the distances from F commands with the current directions as of
those commands to figure out the positions of the ship. For absolute commands we simply map them
to coordinate changes and add them together.

PART 2:
This is very similar to a VM implementation. We have a list of opcodes and a state consisting of
two points. Individual handler functions update the state based on the opcode.
