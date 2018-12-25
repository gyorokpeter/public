x:read0`:d:/projects/github/public/aoc2018/d3.in;
d3parse:{"J"$",x"vs'/:": "vs/:last each"@ "vs/:x};
d3p1:{a:d3parse x;b:raze{x[0]+/:til[x[1][0]]cross til[x[1][1]]}each a;sum 1<count each group b};
d3p2:{a:d3parse x;b:{x[0]+/:til[x[1][0]]cross til[x[1][1]]}each a;c:where 1=count each group raze b;first 1+where all each b in c};

d3p1 x
d3p2 x