d25p1:{
    lines:" "vs/:trim each "\n"vs x;
    startState:`$-1_lines[0;3];
    steps:"J"$lines[1;5];
    rules:raze{([state:`$-1_x[1;2];input:01b]write:"B"$-1_/:x[3 7;4];move:(`left`right!-1 1)`$-1_/:x[4 8;6];nextState:`$-1_/:x[5 9;4])}each 10 cut 2_lines;
    finalState:{[rules;sht]
        rule:rules[(sht 0;sht[2;sht 1])];
        sht[2;sht 1]:rule`write;
        sht[1]+:rule`move;
        sht[0]:rule`nextState;
        if[sht[1]<0; sht[1]+:count[sht[2]]; sht[2]:(count[sht[2]]#0b),sht[2]];
        if[sht[1]>=count sht[2]; sht[2],:count[sht[2]]#0b];
        sht
    }[rules]/[steps;(startState;50;100#0b)];
    sum finalState[2]};

d25p1"Begin in state A.
    Perform a diagnostic checksum after 6 steps.

    In state A:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state B.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state B.

    In state B:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A."   //3
