x:read0`:d:/projects/github/public/aoc2018/d4.in;
d4prep:{
    ts:"P"$ssr[;"1518";4#string .z.D]each 16#/:1_/:x;
    es:([]minute:("j"$"n"$ts)div "j"$"n"$00:01;e:x) iasc ts;
    es2:update et:first each where each count each/:e ss/:\:("begins";"falls";"wakes"),
        gn:fills"J"$first each " "vs/:last each"#"vs/:e from es;
    es3:select gn,minute,et from es2 where et>0;
    esg:0!select minute by gn,et from es3;
    gm:{[esg;g]
        r:select from esg where gn=g;
        `g`m!(g;raze{x[0]+til each x[1]-x[0]}exec minute from r)
    }[esg]each exec distinct gn from esg;
    gm};
d4p1:{
    gm:d4prep[x];
    topg:first select g,m from (update cm:count each m from gm) where cm=max cm;
    topg[`g]*{first where x=max x}count each group topg[`m]
    };
d4p2:{
    gm:d4prep[x];
    gmf:ungroup(select g from gm),'exec{{{`m`f!(key x;value x)}(where x=max x)#x}count each group x}each m from gm;
    exec first g*m from gmf where f=max f};

d4p1 x
d4p2 x
