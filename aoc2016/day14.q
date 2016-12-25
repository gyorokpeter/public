d14:{[hash;str]
    gh:{[hash;str;nf]
        if[64<=count last nf;:nf];
        step:1000;
        stretch:1000;
        n:first nf;
        hs:nf[1],hash each str,/:string (count[nf 1]+0N!n)+til step+stretch-count nf[1];
        n2:{raze string not differ x} each hs;
        three:first each n2 ss\:"11";
        five:first each n2 ss\:"1111";
        ti:where not null three;
        tc:(ti+n)!hs[ti]@'three ti;
        fi:where not null five;
        fc:(fi+n)!hs[fi]@'five fi;
        a:where each fc=/:tc;
        ki:where any each a within' (n+1+ti),'n+ti+stretch;
        ki2:ki where ki within n,n+step-1;
        (n+step;step _ hs;0N!last[nf],ki2)
        }[hash;str]/[(0;();())];
    last[gh][63]};
d14p1:d14['[raze;'[string;md5]]];
d14p2:d14['[raze;'[string;md5]]/[2017;]];

d14p1"qzyelonm"
d14p2"qzyelonm"
