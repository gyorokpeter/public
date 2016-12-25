d20p1:{
    lim:asc "J"$"-"vs/:"\n"vs x;
    r:{$[x within y;y[1]+1;x]}/[0;lim];
    r};
d20p2:{
    lim:asc "J"$"-"vs/:"\n"vs x;
    r:{if[x[0]<y[0];x[1]+:y[0]-x[0]];x[0]:max[x[0],y[1]+1];x}/[0 0;lim];
    r[1]+4294967296-r[0]};

d20p1"5-8\n0-2\n4-7"
d20p2"0-10\n1-2"
