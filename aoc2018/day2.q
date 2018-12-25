x:read0`:d:/projects/github/public/aoc2018/d2.in;
d1p1:{prd sum{2 3 in count each group x}each x};
d1p2:{first raze {[x;n]a:(n#/:x),'(n+1)_/:x;where 1<count each group a}[x]each til count first x};

d1p1 x
d1p2 x
