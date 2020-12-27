d11p1:{
    a:"\n"vs x;
    a:{[a]
        occ:a="#";
        rc:count occ;
        cc:count occ 0;
        r:enlist(cc+2)#0b;
        b:-1_raze {-1 1 0 rotate/:\:x}each -1 1 0 rotate\:r,(0b,/:occ,\:0b),r;
        c:1_-1_1_/:-1_/:sum b;
        a:{[c;x]?[(x="L")and c=0;"#";?[(x="#")and c>=4;"L";x]]}'[c;a];
        a}/[a];
    sum sum "#"=a};
d11p2:{
    a:"\n"vs ssr[x;".";" "];
    a:{[a]
        rc:count a;
        cc:count a 0;
        em:(rc;cc)#" ";
        emr:enlist cc#" ";
        al:"#"={prev fills x}each a;
        ar:"#"={reverse prev fills reverse x}each a;
        au:"#"=flip {prev fills x}each flip a;
        ad:"#"=flip {reverse prev fills reverse x}each flip a;
        aur:"#"=next each -1_emr,cc _/:til[rc] rotate'fills neg[til rc] rotate'em,'a;
        aul:"#"=prev each -1_emr,cc#/:neg[til rc] rotate'fills til[rc]rotate'a,'em;
        adr:"#"=next each 1_(reverse cc _/:til[rc] rotate'fills neg[til rc] rotate'em,'reverse a),emr;
        adl:"#"=prev each 1_(reverse cc#/:neg[til rc] rotate'fills til[rc] rotate'reverse a,'em),emr;
        occ:sum (al;ar;au;ad;aul;aur;adl;adr);
        a:{[c;x]?[(x="L")and c=0;"#";?[(x="#")and c>=5;"L";x]]}'[occ;a];
    a}/[a];
    sum sum "#"=a};

/
d11p2 x:"\n"sv("L.LL.LL.LL"
              ;"LLLLLLL.LL"
              ;"L.L.L..L.."
              ;"LLLL.LL.LL"
              ;"L.LL.LL.LL"
              ;"L.LLLLL.LL"
              ;"..L.L....."
              ;"LLLLLLLLLL"
              ;"L.LLLLLL.L"
              ;"L.LLLLL.LL")

OVERVIEW:

PART 1:
The basic idea is similar to the well-known APL implementation of Conway's Game of Life. We rotate
the matrix by -1, 1 and 0 along both axes (in this order, such that rotation by 0 0 comes last and
is easy to drop). Then we sum the rotated matrices to get the number of neighbors of each cell and
apply the rules to generate the next state.

PART 2:
This adds a lot of complication due to the "line of sight" rules. q provides the handy "fills"
function that replaces null values in a list with the previous non-null value and therefore can
implement line of sight, but in one direction only. Also for the char type, space counts as null
so we replace the dots with spaces to make processing easier. Since fills only works in one
direction, we need to appropriately flip, reverse or "shear" the matrix to make sure the fill goes
in the right direction, then perform the opposite transformation to get back to the original
matrix. For shearing, we put a duplicate empty matrix next to the original one (either left or
right depending on which direction we want to fill) and then rotate each row by an increasing
number such that cells that were on the same diagonal will end up in the same column. After the
fill we do the opposite rotations so we end up with diagonal line of sight. We then sum the result
of the 8 different combinations of transformed fills and evaluate the rule on the resulting counts.
