d1p1:{a:", "vs x;rl:("RL"!1 -1)a[;0];d:sums[rl]mod 4;c:sum ("J"$1_/:a)*(til[4]!(0 -1;1 0;0 1;-1 0))d;sum abs c}
d1p2:{a:", "vs x;rl:("RL"!1 -1)a[;0];d:sums[rl]mod 4;c:sums enlist[0 0],raze ("J"$1_/:a)#'enlist each(til[4]!(0 -1;1 0;0 1;-1 0))d;sum abs first where 1<count each group c}
d1p1"R8, R4, R4, R8"
d1p2"R8, R4, R4, R8"
