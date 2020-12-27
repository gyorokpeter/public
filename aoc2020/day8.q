d8in:{a:" "vs/:"\n"vs x;
    ins:(`$a[;0]),'"J"$a[;1];
    ins};
d8step:{[ins;state]
    if[state[`ip]=count ins; state[`term]:1b; :state];
    if[not state[`ip] within 0,count[ins]-1; fail:1b; :state];
    state[`visited;state`ip]:1b;
    ci:ins[state`ip];
    if[`changedIns in key state;if[state[`changedIns]=state[`ip];
        ci[0]:(`nop`jmp`acc!`jmp`nop`changedAcc)ci[0];
    ]];
    $[ci[0]=`nop; state[`ip]+:1;
      ci[0]=`acc; [state[`acc]+:ci[1]; state[`ip]+:1];
      ci[0]=`jmp; state[`ip]+:ci 1;
    state[`fail]:1b];
    state};
d8p1:{
    ins:d8in x;
    state:`acc`ip`visited`term`fail!(0;0;count[ins]#0b;0b;0b);
    while[not state[`visited][state`ip];
        state:d8step[ins;state];
    ];
    state`acc};
d8p2:{
    ins:d8in x;
    queue:enlist `acc`ip`visited`term`fail`changedIns!(0;0;count[ins]#0b;0b;0b;0N);
    while[0<count queue;
        queue:delete from queue where (visited@'ip) or fail;
        queue,:update changedIns:ip from select from queue where null changedIns;
        queue:d8step[ins] each queue;
        succ:select from queue where term;
        if[0<count succ; :exec first acc from succ];
    ];
    '"no solution found"};

/
d8p2 x:"nop +0\nacc +1\njmp +4\nacc +3\njmp -3\nacc -99\nacc +1\njmp -4\nacc +6"

OVERVIEW:
This is a straightforward simulation, much less complex than the VMs from previous years.

PART 1:
We simply simulate the instructions and extract the result.

PART 2:
We use a kind of BFS where the state consists of the VM state plus the index of the changed
instruction which starts as null. Every time we execute an instruction, we branch off based on
whether the current instruction is the changed one (only if it was null in the curent state). The
simulation also needs to take the possible changed instruction into account. A jump to an invalid
position or trying to change an acc instruction sets the "fail" flag which then indicates that
the BFS should discard that state. Additionally we keep track of the visited addresses for each
state and if we ever reach an already visited address we discard the state.
