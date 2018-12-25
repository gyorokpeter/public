x:read0`:d:/projects/github/public/aoc2018/d6.in;
d6prep:{
    c:reverse each"J"$", "vs/:x;
    c1:c-\:-1+min c;
    sz:2+max c1;
    grid:til[first sz],/:\:til[last sz];
    dist: sum each/:/:abs grid-\:\:/:c1;
    dist};
d6p1:{
    dist:d6prep x;
    md:min dist;
    dist=\:md;
    closest:where each/:(flip each flip[dist=\:md]);
    unique:?'[1=count each/:closest;first each/:closest;0N];
    finite:til[count c1] except unique[0],last[unique],unique[;0],last each unique;
    finiteDist:sum each sum each unique=/:finite;
    max finiteDist};
d6p2:{[x;rng]
    dist:d6prep x;
    sum sum sum[dist]<rng};

d6p1 x
d6p2[x;10000]
