d14p1:{ins:"\n"vs x;
    st:{[st;x]$[x like "mask*";st[0]:(28#0N),"J"$/:last" "vs x;
        st[1;"J"$last"["vs first"]"vs x]:0b sv 1=(0b vs "J"$last" "vs x)^st[0]];
        st}/[(();()!());ins];
    sum st 1};
d14p2:{ins:"\n"vs x;
    st:{[st;x]$[x like "mask*";[m:last" "vs x;st[0]:28+where m="1";st[1]:28+where m="X"];
        [d:"j"$0b vs"J"$last"["vs first"]"vs x;d[st[0]]:1;
            d:0b sv/:1=@[d;st[1];:;]each{x cross 0 1}/[count[st[1]]-1;0 1];
            st[2;d]:"J"$last" "vs x]];
        st}/[(();();()!());ins];
    sum st 2};


/
d14p1 x:"\n"sv("mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
               ;"mem[8] = 11"
               ;"mem[7] = 101"
               ;"mem[8] = 0")

d14p2 x:"\n"sv("mask = 000000000000000000000000000000X1001X"
               ;"mem[42] = 100"
               ;"mask = 00000000000000000000000000000000X0XX"
               ;"mem[26] = 1")

OVERVIEW:

PART 1:
Straighforward iterative simulation.

PART 2:
Also an iterative simulation. To generate the list of addresses for a given mask, we use the
cross function iteratively. 01b cross 01b generates all 4 combinations of 2 bits. If we want more
bits then we have to repeatedly apply the operator using the / iterator.