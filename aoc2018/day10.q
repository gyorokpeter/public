x:read0`:d:/projects/github/public/aoc2018/d10.in;

d10prep:{
    a:"J"$", "vs/:/:first each/:-1_/:/:1_/:">"vs/:/:"<"vs/:x;
    pos:a[;0];
    spd:a[;1];
    turns:max abs pos[;0]%spd[;0];
    states:pos+/:spd*/:turns+-300+til 400;
    sizes:{max[x[;0]]-min x[;0]}each states;
    delay:where sizes=min sizes;
    (states;delay;-300+turns+delay)};
d10p1:{
    tmp:d10prep x;
    states:tmp 0;
    delay:tmp 1;
    st:"j"$first states delay;
    st:st-\:(min st[;0];min[st[;1]]);
    grid:(1+max st[;0];1+max st[;1])#0;
    msg:" #"flip 0<./[;;+;1][grid;st];
    letters:raze each 6#/:/:flip 8 cut/:msg;
    ocr:enlist[""]!enlist"?";
    ocr["  ##   #  # #    ##    ##    ########    ##    ##    ##    #"]:"A";
    ocr[" #### #    ##     #     #     #     #     #     #    # #### "]:"C";
    ocr["#     #     #     #     #     #     #     #     #     ######"]:"L";
    ocr["#    ###   ###   ## #  ## #  ##  # ##  # ##   ###   ###    #"]:"N";
    ocr["##### #    ##    ##    ###### #  #  #   # #   # #    ##    #"]:"R";
    ocr["######     #     #    #    #    #    #    #     #     ######"]:"Z";
    ocr letters};
d10p2:{last d10prep x};

d10p1 x
d10p2 x
