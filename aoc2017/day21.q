.d21.break:{[pattern;size]
    blocks:flip each size cut/:/:size cut pattern;
    blocks};

.d21.advance:{[rule;pattern]
    blocks:.d21.break[pattern;$[0=count[pattern] mod 2;2;3]];
    pattern:raze raze each/:flip each rule blocks;
    pattern};

.d21.rotate:{[ruleline]
    k:ruleline[0]; v:ruleline[1]; fk:flip k; rk:reverse k; rfk:reverse fk;
    (k;rk;reverse each k;reverse each rk;fk;rfk;reverse each fk;reverse each rfk)(;)\:v};

d21p1:{[x;y]
    pattern:(".#.";"..#";"###");
    rawrule:"/"vs/:/:" => "vs/:trim each "\n"vs x;
    rule:{x[;0]!x[;1]}distinct rawrule,raze .d21.rotate each rawrule;
    pattern:.d21.advance[rule]/[y;pattern];
    sum sum pattern="#"};
