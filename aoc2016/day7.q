d7p1:{sum{
        c:"]"vs/:("["vs "]",x);
        m:{if[4>count x;:0b];any (x="   ",-3_x)&(0b,-1_x=" ",-1_x)&differ x}each/:c;
        not[any m[;0]]and any m[;1]
    }each"\n"vs x}

d7p2:{sum{
        c:"]"vs/:("["vs "]",x);
        s:{if[count[x]<3;:(();())];
            p:where(x="  ",-2_x)&differ x;
            (3#/:(p-2) _\:x;3#/:2#/:(p-1) _\:x)}each/:c;
        any raze[s[;1;0]]in raze s[;0;1]
    }each"\n"vs x}

d7p1"abba[mnop]qrst\nabcd[bddb]xyyx\naaaa[qwer]tyui\nioxxoj[asdfgh]zxcvbn"
d7p2"aba[bab]xyz\nxyx[xyx]xyx\naaa[kek]eke\nzazbz[bzb]cdb[aaa]aaa"
