x:read0`:d:/projects/github/public/aoc2018/d23.in;

d23p1:{
    ps:"J"$","vs/:first each">"vs/:last each "<"vs/:x;
    rs:"J"$last each"="vs/:x;
    longest:first where rs=max rs;
    sum(sum each abs ps-\:ps longest)<=rs longest};
d23p2:{'"nyi"};

d23p1 x
d23p2 x
