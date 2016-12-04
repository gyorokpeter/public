d2p1:{
    row:"\n"vs x;
    rc:("UDLR"!(0 -1;0 1;-1 0;1 0))row;
    pos:{{0|2&x+y}/[x;y]}\[1 1;rc];
    raze string 1+pos[;0]+3*pos[;1]};
d2p2:{
    row:"\n"vs x;
    rc:("UDLR"!(0 -1;0 1;-1 0;1 0))row;
    pos:{{n:x+y;$[(00100b;01110b;11111b;01110b;00100b). n;n;x]}/[x;y]}\[0 2;rc];
    raze flip[("  1  ";" 234 ";"56789";" ABC ";"  D  ")]./:pos};
d2p1"ULL\nRRDDD\nLURDL\nUUUUD"
d2p2"ULL\nRRDDD\nLURDL\nUUUUD"
