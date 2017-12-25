d6p1:{c:count x;l:enlist x;while[[p:first where x=max x;n:x[p];x[p]:0;x+:n div c;x[(p+1+til n mod c)mod c]+:1;not x in l];l,:enlist x];count l};

d6p1 0 2 7 0    //5

d6p2:{c:count x;l:enlist x;while[[p:first where x=max x;n:x[p];x[p]:0;x+:n div c;x[(p+1+til n mod c)mod c]+:1;not x in l];l,:enlist x];count[l]-l?x};

d6p2 0 2 7 0    //4
