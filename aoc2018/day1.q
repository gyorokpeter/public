x:read0`:d:/projects/github/public/aoc2018/d1.in;
d1p1:{sum "J"$x};
d1p2:{d:"J"$x;while[1b;r:where not null asc group[sums d][;1];if[0<count r; :first r];d,:d]};
d1p1 input
d1p2 input