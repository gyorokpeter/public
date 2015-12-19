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
{t:uj/[{d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x];exec first i+1 from t where children in 0N 3,cats in 0N 7,samoyeds in 0N 2,pomeranians in 0N 3,akitas in 0N 0,vizslas in 0N 0,goldfish in 0N 5,trees in 0N 3,cars in 0N 2,perfumes in 0N 1}
{t:uj/[{d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x];exec first i+1 from t where children in 0N 3,(cats=0N) or cats>7,samoyeds in 0N 2,(pomeranians=0N)or pomeranians<3,akitas in 0N 0,vizslas in 0N 0,(goldfish=0N)or goldfish<5,(trees=0N)or trees>3,cars in 0N 2,perfumes in 0N 1}
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
sum("()"!1 -1)
{1+(sums("()"!1 -1)x)?-1}
