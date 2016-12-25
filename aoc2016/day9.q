d9p1:{first({if[0=count y;:(x;y)];
    if[not "(" in y;:(x+count y;"")];
    l:y?"(";
    if[l>0; :(x+l;l _y)];
    r:1+y?")";
    ctrl:r#y;
    y:r _y;
    num:"J"$"x"vs 1_-1_ctrl;
    x+:prd[num];
    y:num[0]_y;
    (x;y)}.)/[(0;x except " \t\n")]}
d9p2:{first({if[0=count y;:(x;y)];
    if[not "(" in y;:(x+count y;"")];
    l:y?"(";
    if[l>0; :(x+l;l _y)];
    r:1+y?")";
    ctrl:r#y;
    y:r _y;
    num:"J"$"x"vs 1_-1_ctrl;
    txt:num[0]#y;
    x+:num[1]*first (.z.s .)/[(0;txt)];
    y:num[0]_y;
    (x;y)}.)/[(0;x except " \t\n")]}

d9p1"ADVENT"
d9p1"A(1x5)BC"
d9p1"(3x3)XYZ"
d9p1"A(2x2)BCD(2x2)EFG"
d9p1"(6x1)(1x3)A"
d9p1"X(8x2)(3x3)ABCY"

d9p2"(3x3)XYZ"
d9p2"X(8x2)(3x3)ABCY"
d9p2"(27x12)(20x12)(13x14)(7x10)(1x12)A"
d9p2"(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
