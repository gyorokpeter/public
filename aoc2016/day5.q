d5p1:{    
    gh:{[str;nf]
        if[8<=count last nf;:nf];
        step:100000;
        n:first nf;
        hs:md5 each str,/:string n+til step;
        n2:where{(x[;0]=0)&(x[;1]=0)&(x[;2]<16)}hs;
        (n+step;last[nf],hs n2)
        }[x]/[(0;())];
    (raze each string[8#gh 1])[;5]
    }
d5p2:{    
    res:{[str;nf]
        if[not"_"in last nf;:nf];
        step:100000;
        n:first nf;
        hs:md5 each str,/:string n+til step;
        n2:where{(x[;0]=0)&(x[;1]=0)&(x[;2]<16)}hs;
        pw:{p:y[2]mod 16;if[p within 0 7;if["_"=x p;x[p]:raze[string y][6]]];x}/[last nf;hs n2];
        (n+step;0N!pw)
        }[x]/[(0;"________")];
    last res}

d5p1"abc"
d5p1"uqwqemis"
d5p2"abc"
d5p2"uqwqemis"
