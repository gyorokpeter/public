x:read0`:d:/projects/github/public/aoc2018/d20.in;

d20expand:{[re;pl;nxt]
    $[nxt[`cur]>=count re;
        (();());
      re[nxt`cur] in "NESW";
        [
            endcur:nxt`cur;while[re[endcur]in"NESW";endcur+:1];
            sect:nxt[`cur]_endcur#re;
            path:sums enlist[nxt`pos],("NESW"!(-1 0;0 1;1 0;0 -1))sect;
            edges:flip`s`t!flip asc each{-2#x,enlist y}\[1#path;1_path];
            (edges;enlist`pos`cur!(last path;endcur))
        ];
      re[nxt`cur]="(";
        [
            spl:pl[nxt`cur];
            endcur:nxt`cur; while[pl[endcur]>=spl;endcur+:1];
            split:where (pl=spl) and re="|";
            split2:split where split within (nxt`cur;endcur);
            (();([]pos:(1+count split2)#enlist nxt`pos;cur:1+nxt[`cur],split2))
        ];
      re[nxt`cur]=")";
        [
            (();enlist`pos`cur!(nxt`pos;1+nxt`cur))
        ];
      re[nxt`cur]="|";
        [
            spl:pl[nxt`cur];
            endcur:nxt`cur; while[pl[endcur]>=spl;endcur+:1];
            (();enlist`pos`cur!(nxt`pos;endcur))
        ];
        '"nyi"
    ]};

d20getEdges:{
    if[0=type x;x:first x];
    re:1_-1_x;
    pl:sums("()"!1 -1)re;
    stack:([]pos:enlist 0 0;cur:0);
    edges:([]s:();t:());
    while[0<count stack;
        s1:update p:-1^pl cur from stack;
        nxts:(delete p from select from s1 where p=max p);
        rss:d20expand[re;pl] each nxts;
        edges:distinct edges,raze first each rss;
        stack:distinct(delete p from select from s1 where p<>max p),raze last each rss;
    ];
    edges};

d20common:{
    edges:d20getEdges[x];
    queue:enlist 0 0;
    visited:();
    gen:-1;
    targets:0;
    while[0<count queue;
        visited,:queue;
        nxts:((exec t from edges where s in queue),exec s from edges where t in queue)except visited;
        gen+:1;
        if[1000<=gen; targets+:count queue];
        queue:nxts;
    ];
    (gen;targets)};
d20p1:{first d20common x};
d20p2:{last d20common x};

d20p1 x:"^WNE$"
d20p1 x:"^ENWWW(NEEE|SSE(EE|N))$"
d20p1"^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$";
d20p1"^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$";
d20p1"^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$";

d20p1 x
d20p2 x
