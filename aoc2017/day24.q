.d24.expandOne:{[pins;line]
    nextPin:last last line[`pins];
    nxt:update reverse each pins from (select pins,j:i from ([]pins) where not line`visited, nextPin in/:pins) where nextPin<>first each pins;
    ([]pins:line[`pins],/:enlist each nxt[`pins];visited:@[line[`visited];;:;1b]each nxt[`j])};

.d24.expand:{[pins;part;st]
    queue:raze .d24.expandOne[pins] each st[0];
    if[0=count queue; :(queue;st[1])];
    (queue;max $[part=2;();st[1]],sum each sum each/:exec pins from queue)};

.d24.solve:{[part;x]
    pins:asc each"J"$"/"vs/:trim each "\n"vs x;
    start:0=first each pins;
    queue:([]pins:enlist each pins where start; visited:til[count pins]=/:where start);
    st:.d24.expand[pins;part]/[(queue;0)];
    last st};

d24p1:{.d24.solve[1;x]};
d24p2:{.d24.solve[2;x]};

d24p1"0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10"   //31

d24p2"0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10"   //19
