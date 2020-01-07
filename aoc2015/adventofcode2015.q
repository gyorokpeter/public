//25
{inp:"J"$((" "vs x)16 18)except\:",.";{[row;col]n:(1+sum til col)+sum (col-1)+til row;{(x*252533)mod 33554393}/[n-1;20151125]}. inp}
//24
{inp:"J"$"\n"vs x;
    goal:sum[inp] div 3;
    c:0;found:0b;
    while[not found;
        c+:1;
        subsets:{[csum;maxsum;maxn;x]
            $[(csum>maxsum);
                ();
              (0=maxn) or (0=count x);
                enlist`long$();
              raze(
                x[0],/:.z.s[csum+x[0];maxsum;maxn-1;1_x];
                .z.s[csum;maxsum;maxn;1_x]
              )
            ]}[0;goal;c;inp];
        subsets:subsets where goal=sum each subsets;
        if[0<count subsets;
            found:1b;
        ];
    ];
    min prd each subsets}
{inp:"J"$"\n"vs x;
    goal:sum[inp] div 4;
    c:0;found:0b;
    while[not found;
        c+:1;
        subsets:{[csum;maxsum;maxn;x]
            $[(csum>maxsum);
                ();
              (0=maxn) or (0=count x);
                enlist`long$();
              raze(
                x[0],/:.z.s[csum+x[0];maxsum;maxn-1;1_x];
                .z.s[csum;maxsum;maxn;1_x]
              )
            ]}[0;goal;c;inp];
        subsets:subsets where goal=sum each subsets;
        if[0<count subsets;
            found:1b;
        ];
    ];
    min prd each subsets}
//23
//see day23.q
//22
{inp:" "vs/:"\n"vs x;
    bhp:"J"$inp[0;2];
    bdmg:"J"$inp[1;1];
    queue:enlist`hp`mp`bhp`totalmp`shield`poison`recharge`bdmg!(50;500;bhp;0;0;0;0;bdmg);
    visited:0#queue;
    comefrom::([]old:();new:();spell:());
    expand:{
        if[0<x`recharge; x[`mp]+:101; x[`recharge]-:1];
        if[0<x`shield; x[`shield]-:1];
        if[0<x`poison; x[`bhp]-:3; x[`poison]-:1];
        if[x[`bhp]=0; x[`bhp:0]; :enlist x,enlist[`spell]!enlist`];
        res:enlist (x+`mp`bhp`totalmp!-53 -4 53),enlist[`spell]!enlist`missile;
        res,:enlist (x+`hp`mp`bhp`totalmp!2 -73 -2 73),enlist[`spell]!enlist`drain;
        if[0=x`shield; res,:enlist (x+`mp`totalmp!-113 113),`shield`spell!(6;`shield)];
        if[0=x`poison; res,:enlist (x+`mp`totalmp!-173 173),`poison`spell!(6;`poison)];
        if[0=x`recharge; res,:enlist (x+`mp`totalmp!-229 229),`recharge`spell!(5;`recharge)];
        res:delete from res where mp<0;
        res:update bhp:bhp-3, poison:poison-1 from res where poison>0;
        res:update shield:shield-1 from res where shield>0;
        res:update mp:mp+101, recharge:recharge-1 from res where recharge>0;
        res:update bhp:0|bhp from res;
        res:update hp:hp-1|(bdmg-?[shield>0;7;0]) from res where bhp>0;
        res:delete from res where hp<=0;
    res};
    while[0<count queue;
        ind:exec first i from queue where totalmp=min totalmp;
        nxt:queue[ind];
        queue:delete from queue where i=ind;
        if[0>=nxt`bhp;
            spell:`$();
            oldind:visited?nxt;
            while[oldind<>-1; row:first select from comefrom where new=oldind; spell:row[`spell],spell; oldind:row[`old]];
            show spell;
        :nxt`totalmp];
        newrows:distinct expand[nxt];
        newrowsNS:delete spell from newrows;
        nrind:where not newrowsNS in visited;
        visited,:newrowsNS nrind;
        queue,:newrowsNS nrind;
        oldind:$[nxt in visited; visited?nxt; -1];
        comefrom,:([]old:oldind; new:visited?newrowsNS nrind;spell:newrows[nrind;`spell]);
    ];
    '"impossible";
    }
{inp:" "vs/:"\n"vs x;
    bhp:"J"$inp[0;2];
    bdmg:"J"$inp[1;1];
    queue:enlist`hp`mp`bhp`totalmp`shield`poison`recharge`bdmg!(50;500;bhp;0;0;0;0;bdmg);
    visited:0#queue;
    comefrom::([]old:();new:();spell:());
    expand:{
        x[`hp]-:1;
        if[0<x`recharge; x[`mp]+:101; x[`recharge]-:1];
        if[0<x`shield; x[`shield]-:1];
        if[0<x`poison; x[`bhp]-:3; x[`poison]-:1];
        if[x[`bhp]=0; x[`bhp:0]; :enlist x,enlist[`spell]!enlist`];
        res:enlist (x+`mp`bhp`totalmp!-53 -4 53),enlist[`spell]!enlist`missile;
        res,:enlist (x+`hp`mp`bhp`totalmp!2 -73 -2 73),enlist[`spell]!enlist`drain;
        if[0=x`shield; res,:enlist (x+`mp`totalmp!-113 113),`shield`spell!(6;`shield)];
        if[0=x`poison; res,:enlist (x+`mp`totalmp!-173 173),`poison`spell!(6;`poison)];
        if[0=x`recharge; res,:enlist (x+`mp`totalmp!-229 229),`recharge`spell!(5;`recharge)];
        res:delete from res where mp<0;
        res:update bhp:bhp-3, poison:poison-1 from res where poison>0;
        res:update shield:shield-1 from res where shield>0;
        res:update mp:mp+101, recharge:recharge-1 from res where recharge>0;
        res:update bhp:0|bhp from res;
        res:update hp:hp-1|(bdmg-?[shield>0;7;0]) from res where bhp>0;
        res:delete from res where hp<=0;
    res};
    while[0<count queue;
        ind:exec first i from queue where totalmp=min totalmp;
        nxt:queue[ind];
        queue:delete from queue where i=ind;
        if[0>=nxt`bhp;
            spell:`$();
            oldind:visited?nxt;
            while[oldind<>-1; row:first select from comefrom where new=oldind; spell:row[`spell],spell; oldind:row[`old]];
            show spell;
        :nxt`totalmp];
        newrows:distinct expand[nxt];
        newrowsNS:delete spell from newrows;
        nrind:where not newrowsNS in visited;
        visited,:newrowsNS nrind;
        queue,:newrowsNS nrind;
        oldind:$[nxt in visited; visited?nxt; -1];
        comefrom,:([]old:oldind; new:visited?newrowsNS nrind;spell:newrows[nrind;`spell]);
    ];
    '"impossible";
    }
//21
{inp:" "vs/:"\n"vs x;
    bhp:"J"$inp[0;2];
    bdmg:"J"$inp[1;1];
    barm:"J"$inp[2;1];
    wp:([]cost:8 10 25 40 74;dmg:4 5 6 7 8; arm:0);
    arm:([]cost:13 31 53 75 102;dmg:0;arm:1 2 3 4 5);
    ring:([]cost:25 50 100 20 40 80;dmg:1 2 3 0 0 0;arm:0 0 0 1 2 3);
    wa:raze(enlist each wp),/:\:(enlist[()],enlist each arm);
    wag:raze wa,/:\:enlist[()],(enlist each ring),ring distinct asc each raze til[count ring],/:'til[count ring] except/:til count ring;
    stat:sum each wag;
    stat:update win:(ceiling bhp%(1|dmg-barm))<=ceiling 100%1|bdmg-arm from stat;
    exec min cost from stat where win}
{inp:" "vs/:"\n"vs x;
    bhp:"J"$inp[0;2];
    bdmg:"J"$inp[1;1];
    barm:"J"$inp[2;1];
    wp:([]cost:8 10 25 40 74;dmg:4 5 6 7 8; arm:0);
    arm:([]cost:13 31 53 75 102;dmg:0;arm:1 2 3 4 5);
    ring:([]cost:25 50 100 20 40 80;dmg:1 2 3 0 0 0;arm:0 0 0 1 2 3);
    wa:raze(enlist each wp),/:\:(enlist[()],enlist each arm);
    wag:raze wa,/:\:enlist[()],(enlist each ring),ring distinct asc each raze til[count ring],/:'til[count ring] except/:til count ring;
    stat:sum each wag;
    stat:update win:(ceiling bhp%(1|dmg-barm))<=ceiling 100%1|bdmg-arm from stat;
    exec max cost from stat where not win}
//20
{MAX:x div 10;l:0,MAX#10;n:1;while[n<=MAX;n+:1;l[n*1+til (MAX div n)]+:n*10;];first where l>=x}
{MAX:x div 10;l:0,MAX#11;n:1;while[n<=MAX;n+:1;l[n*1+{min[count[x],50]#x}til (MAX div n)]+:n*11;];first where l>=x}
34000000
//19
{inp:"\n"vs x;rep:(" "vs/:-2_inp)[;0 2];orig:last inp;rps:orig ss/:rep[;0];count distinct raze{[orig;pos;old;new](pos#\:orig),'new,/:(pos+count[old]) _\:orig}[orig]'[rps;rep[;0];rep[;1]]}
{inp:"\n"vs x;rep:flip `old`new!flip(" "vs/:-2_inp)[;0 2];
    rep:`newc xdesc update newc:count each new from rep;
    orig:last inp;
    r:{[rep;str]
        pos:str ss/:rep[`new];
        rule:first where 0<count each pos;
        if[null rule; :str];
        old:rep[rule;`old];
        new:rep[rule;`new];
        rpos:last pos[rule];
        :(rpos # str),old,(rpos+count new)_str;
    }[rep]\[orig];
    count[r]-1}
//19p2 cheater version
{{count[x]-1+(sum x in`Ar`Rn)+2*sum x=`Y}`${(where x within "AZ")cut x}last"\n"vs x}
//18
{g:"#"="\n"vs x;
    r:{c:0b,/:(enlist[count[x]#0b],x,enlist[count[x]#0b]),\:0b;
    nb:1_-1_1_/:-1_/:sum{[c;dxy]dxy[1]rotate dxy[0] rotate/:c}[c]each(-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1);
    (x&nb in\: 2 3)|(not x)&nb=3}/[100;g];
    sum sum r}
{g:"#"="\n"vs x;
    s:count g;g[0;0]:g[0;s-1]:g[s-1;0]:g[s-1;s-1]:1b;
    r:{s:count x;
    c:0b,/:(enlist[s#0b],x,enlist[s#0b]),\:0b;
    nb:1_-1_1_/:-1_/:sum{[c;dxy]dxy[1]rotate dxy[0] rotate/:c}[c]each(-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1);
    ng:(x&nb in\: 2 3)|(not x)&nb=3;
    ng[0;0]:ng[0;s-1]:ng[s-1;0]:ng[s-1;s-1]:1b;ng}/[100;g];
    sum sum r}
//17
{c:desc"J"$"\n"vs x;count{[v;c]$[0=v;:enlist();0=count c;();[rv:c rc:til count c;raze rv,/:'.z.s'[v-rv;(1+rc)_\:c]]]}[150;c]}
{c:desc"J"$"\n"vs x;count where {x=min x}count each{[v;c]$[0=v;:enlist();0=count c;();[rv:c rc:til count c;raze rv,/:'.z.s'[v-rv;(1+rc)_\:c]]]}[150;c]}
//16
//see day16.q
//15
{d:"J"$(" "vs/:"\n"vs x)[;2 4 6 8]except\:\:",";c:{$[y=1;enlist enlist x;raze(til 1+x),/:'.z.s[;y-1]each x-til 1+x]}[100;count d];max prd each 0|sum each c*\:d}
{d:"J"$(" "vs/:"\n"vs x)[;2 4 6 8 10]except\:\:",";c:{$[y=1;enlist enlist x;raze(til 1+x),/:'.z.s[;y-1]each x-til 1+x]}[100;count d];c2:{x where 500=last each x}sum each c*\:d;max prd each 0|4#/:c2}
//14
{[time;x]d:{p:" "vs x;s:"J"$p[3];t:"J"$p[6];r:"J"$p[13];(s;t;r)}each"\n"vs x;max((time div d[;1]+d[;2])*d[;0]*d[;1])+(d[;1]&time mod d[;1]+d[;2])*d[;0]}[2503]
{[time;x]d:{p:" "vs x;s:"J"$p[3];t:"J"$p[6];r:"J"$p[13];(s;t;r)}each"\n"vs x;w:raze{[d;t]ds:((t div d[;1]+d[;2])*d[;0]*d[;1])+(d[;1]&t mod d[;1]+d[;2])*d[;0];where ds=max ds}[d]each 1+til time;max count each group w}[2503]
//13
{l:" "vs/:"\n"vs x;c:{x!til count x}distinct`$l[;0],-1_/:l[;10];;m:(c `$(l[;0](;)'-1_/:l[;10]))!(`gain`lose!1 -1)[`$l[;2]]*"J"$l[;3];p:{$[1>=count x; enlist x;raze x,/:'.z.s each x except/:x]}til count c;max{[m;x]sum x[0]{[m;s;d]m[(s;d)]+m[(d;s)]}[m]': 1_x}[m]each p,'p[;0]}
{l:" "vs/:"\n"vs x;c:{x!til count x}distinct`$l[;0],-1_/:l[;10];;m:(c `$(l[;0](;)'-1_/:l[;10]))!(`gain`lose!1 -1)[`$l[;2]]*"J"$l[;3];p:{$[1>=count x; enlist x;raze x,/:'.z.s each x except/:x]}til count c;max{[m;x]sum x[0]{[m;s;d]m[(s;d)]+m[(d;s)]}[m]': 1_x}[m]each p}
//12
{{$[type[x] in -9 9h; sum x;type[x] in 0 98 99h;sum 0f,raze .z.s each x;type[x]=10h;0f;'.Q.s1[x]]}.j.k x}
{{$[type[x] in -9 9h; sum x;type[x] in 0 98h;sum 0f,raze .z.s each x;type[x]=99h;$[any"red"~/:value x;0f;sum 0f,raze .z.s each x];type[x]=10h;0f;'.Q.s1[x]]}.j.k x}
//11
{t:(`long$x)-97;t:first({[t;s]if[s;:(t;s)];t[count[t]-1]+:1;t:{p:x?26;if[p<count x;x[p]:0;x[p-1]+:1];x}/[t];(t;(1<count distinct t where not differ t)and(not any 8 11 14 in t)and(1 in deltas -2,where 1=deltas -2,t))}.)/[(t;0b)];`char$97+t}
{t:(`long$x)-97;t:{[t]t:first({[t;s]if[s;:(t;s)];t[count[t]-1]+:1;t:{p:x?26;if[p<count x;x[p]:0;x[p-1]+:1];x}/[t];(t;(1<count distinct t where not differ t)and(not any 8 11 14 in t)and(1 in deltas -2,where 1=deltas -2,t))}.)/[(t;0b)]}/[2;t];`char$97+t}
//10
{count{raze{string[count x],first[x]}each(where differ[x])cut x}/[40;x]}
{count{raze{string[count x],first[x]}each(where differ[x])cut x}/[50;x]}
//9
{l:" "vs/:"\n"vs x;c:{x!til count x}distinct`$l[;0],l[;2];m:(c `$l[;0 2])!"J"$l[;4];p:{$[1>=count x; enlist x;raze x,/:'.z.s each x except/:x]}til count c;min{[m;x]sum x[0]{[m;s;d]m[asc(s;d)]}[m]': 1_x}[m]each p}
{l:" "vs/:"\n"vs x;c:{x!til count x}distinct`$l[;0],l[;2];m:(c `$l[;0 2])!"J"$l[;4];p:{$[1>=count x; enlist x;raze x,/:'.z.s each x except/:x]}til count c;max{[m;x]sum x[0]{[m;s;d]m[asc(s;d)]}[m]': 1_x}[m]each p}
//8
{sum{2+sum sum 1 1 3*(ssr[;"\\\"";"\001"]ssr[;"\\\\";"\000"][x])=/:"\000\001\\"}each x}
{sum{2+sum x in"\\\""}each x}
//7
{memo::()!();n:raze{p:" "vs x;w:`$last p;c:`$p count[p]-4;inp:$[4<count p;enlist p 0;()],enlist[p count[p]-3];enlist[w]!enlist c,inp}each"\n"vs x;
    {[n;w]if[10h=type w;if[not null num:"I"$w;:num];w:`$w];op:n[w];
    if[w in key memo; :memo[w]];
    :memo[w]:$[
    `=c:op 0;.z.s[n;op 1];
    `AND=c;0b sv(0b vs .z.s[n;op 1])and(0b vs .z.s[n;op 2]);
    `OR=c;0b sv(0b vs .z.s[n;op 1])or(0b vs .z.s[n;op 2]);
    `NOT=c;(65536i+0b sv not 0b vs .z.s[n;op 1])mod 65536i;
    `LSHIFT=c;(.z.s[n;op 1]*`int$2 xexp .z.s[n;op 2])mod 65536i;
    `RSHIFT=c;.z.s[n;op 1]div `int$2 xexp .z.s[n;op 2];
  0Ni]}[n;`a]}
{memo::()!();n:raze{p:" "vs x;w:`$last p;c:`$p count[p]-4;inp:$[4<count p;enlist p 0;()],enlist[p count[p]-3];enlist[w]!enlist c,inp}each"\n"vs x;
    calc:{[n;w]if[10h=type w;if[not null num:"I"$w;:num];w:`$w];op:n[w];
    if[w in key memo; :memo[w]];
    :memo[w]:$[
    `=c:op 0;.z.s[n;op 1];
    `AND=c;0b sv(0b vs .z.s[n;op 1])and(0b vs .z.s[n;op 2]);
    `OR=c;0b sv(0b vs .z.s[n;op 1])or(0b vs .z.s[n;op 2]);
    `NOT=c;(65536i+0b sv not 0b vs .z.s[n;op 1])mod 65536i;
    `LSHIFT=c;(.z.s[n;op 1]*`int$2 xexp .z.s[n;op 2])mod 65536i;
    `RSHIFT=c;.z.s[n;op 1]div `int$2 xexp .z.s[n;op 2];
  0Ni]};
    a:calc[n;`a];memo::enlist[`b]!enlist a; calc[n;`a]}
//6
{sum sum{[b;cmd]c:" "vs cmd;c1:`$raze -3_c;p:-3#c;p0:"I"$","vs p 0;p1:"I"$","vs p 2;(p0[1]#b),({[a;b;c;r](a#r),$[`turnon=c;(1+b-a)#1b;`turnoff=c;(1+b-a)#0b;not(a _(1+b)#r)],((1+b)_r)}[p0 0;p1 0;c1]each(p0[1]_(1+p1[1])#b)),((1+p1[1])_b)}/[1000 1000#0b;"\n"vs x]}
{sum sum{[b;cmd]c:" "vs cmd;c1:`$raze -3_c;p:-3#c;p0:"I"$","vs p 0;p1:"I"$","vs p 2;(p0[1]#b),({[a;b;c;r](a#r),(0|$[`turnon=c;1;`turnoff=c;-1;2]+(a _(1+b)#r)),((1+b)_r)}[p0 0;p1 0;c1]each(p0[1]_(1+p1[1])#b)),((1+p1[1])_b)}/[1000 1000#0;"\n"vs x]}
//5
{sum{(3<=sum x in"aeiou")and(1<=sum=':[x])and 0=sum count each ss[x]each("ab";"cd";"pq";"xy")}each "\n"vs x}
{sum{(0<count{x where 2<=(last each x)-first each x}{x where 2<=count each x}ss[x]each 2#/:(til[-1+count x])_\:x)and 0<sum(2_x)=-2_x}each "\n"vs x}
//4
{{[str;nf]if[last nf;:nf];step:100000;n:first nf;n2:first where{(x[0]=0) and (x[1]=0) and (x[2]<16)}each md5 each str,/:string til n+step;$[null n2;(n+step;0b);(n2;1b)]}[x]/[(0;0b)]}
{{[str;nf]if[last nf;:nf];step:100000;n:first nf;n2:first where{(x[0]=0) and (x[1]=0) and (x[2]=0)}each md5 each str,/:string til n+step;$[null n2;(n+step;0b);(n2;1b)]}[x]/[(0;0b)]}
//3
{count distinct enlist[(0;0)],sums(">^<v"!(1 0;0 -1;-1 0;0 1))x}
{count distinct raze {enlist[(0;0)],sums(">^<v"!(1 0;0 -1;-1 0;0 1))x}each flip 0N 2#x}
//2
{sum{a:"J"$"x"vs x;a0:a[0]*a[1];a1:a[1]*a[2];a2:a[0]*a[2]; min[(a0;a1;a2)]+2*a0+a1+a2}each "\n"vs x}
{sum{a:"J"$"x"vs x;prd[a]+2*min[(a[0]+a[1];a[0]+a[2];a[1]+a[2])]}each "\n"vs x}
//1
{sum("()"!1 -1)x}
{1+(sums("()"!1 -1)x)?-1}
