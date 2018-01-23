d20p1:{
    ps:trim each"\n"vs x;
    pd:", "vs/:ps;
    ptcl:([]pos:"J"$","vs/:3_/:-1_/:pd[;0];spd:"J"$","vs/:3_/:-1_/:pd[;1];accl:"J"$","vs/:3_/:-1_/:pd[;2]);
    ptcl2:`pos xasc select j:i,sum each abs pos from {x:update spd:spd+accl from x;x:update pos:pos+spd from x;x}/[50000;ptcl];
    exec first j from ptcl2};

d20p2:{
    ps:trim each"\n"vs x;
    pd:", "vs/:ps;
    ptcl:([]pos:"J"$","vs/:3_/:-1_/:pd[;0];spd:"J"$","vs/:3_/:-1_/:pd[;1];accl:"J"$","vs/:3_/:-1_/:pd[;2]);
    ptcl2:`pos xasc select j:i,sum each abs pos from {x:update spd:spd+accl from x;x:update pos:pos+spd from x;select from x where 1=(count;i) fby pos}/[50000;ptcl];
    exec first j from ptcl2};
