.d24.expand:{[wall;st]
    pos:st`cpos;
    newpos:();
    if[pos[0]>0; newpos,:enlist pos+(-1 0)];
    if[pos[0]<count[row]-1; newpos,:enlist pos+(1 0)];
    if[pos[1]>0; newpos,:enlist pos+(0 -1)];
    if[pos[1]<count[row 0]-1; newpos,:enlist pos+(0 1)];
    newpos:newpos where not wall ./: newpos;
    ([]src:st`src;dst:st`dst;cpos:newpos;dstpos:count[newpos]#enlist st`dstpos)};

d24:{[constr;permsPP;x]
    nums:asc x except"#.\n";
    row:"\n"vs x;
    numpos:{raze raze til[count x],/:'where each x}each row=/:nums;
    wall:"#"=row;
    tbl0:([]src:til count nums)cross ([]dst:til count nums);
    tbl:?[tbl0;constr;0b;()];
    cstate:update cpos:numpos src,dstpos:numpos dst from tbl;
    vstate:delete from cstate;
    dstmap:(enlist())!(enlist 0N);
    iter:0;
    while[0<count cstate;
        iter+:1;
        vstate,:cstate;
        newstate:distinct raze .d24.expand[wall] each cstate;
        newstate:select from newstate where not ([]src;dst;cpos) in (select src,dst,cpos from vstate);
        -1"vstate: ",string[count vstate]," new: ",string count newstate;
        found:select from newstate where cpos~'dstpos;
        dstmap[found[`src],'found[`dst]]:iter;
        newstate:{[t;f]delete from t where src=f`src,dst=f`dst}/[newstate;found];
        vstate:{[t;f]delete from t where src=f`src,dst=f`dst}/[vstate;found];
        cstate:newstate;
    ];
    perms:{$[1=count x;enlist x;raze x,/:'.z.s each x except/:x]}1+til count[nums]-1;
    min ('[sum;{[d;x;y]d asc[x,y]}[dstmap]':[0;]])each permsPP perms};

d24p1:{d24[enlist(<;`src;`dst);::;x]};
d24p2:{d24[enlist(or;(<;`src;`dst);(and;(<;0;`src);(=;0;`dst)));{x,\:0};x]};

d24p1 "###########\n#0.1.....2#\n#.#######.#\n#4.......3#\n###########"
d24p2 "###########\n#0.1.....2#\n#.#######.#\n#4.......3#\n###########"

//OVERVIEW:
//This puzzle has two parts, the first is finding pairwise the shortest paths between
//the target nodes, which can be done by BFS, and then finding the shortest sequence,
//which is the travelling salesman problem, but brute forcing is OK since there are
//only 7 points.
//There are only two minor changes necessary for part 2. First the BFS must also
//search for paths from the targets back to 0. Second, the TSP calculation must take
//into account the return path, so permutations are suffixed with a 0.
//These two pieces of code are passed in to avoid code duplication.
