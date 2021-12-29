d14:{[steps;x]
    a:"\n\n"vs x;
    s:a 0;
    r:{x[;0]!raze x[;1]}" -> "vs/:"\n"vs a[1];
    pair:count each group 2#/:til[count[s]-1]_\:s;
    do[steps;
        k:key pair; v:value pair; rk:r[k];
        npair:([]ch:(k[;0],'rk),(rk,'k[;1]);n:v,v);
        pair:exec sum n by ch from npair;
    ];
    chr0:([]ch:key[pair][;0]; n:value pair);
    chr1:([]ch:key[pair][;1]; n:value pair);
    chr2:([]ch:first[s],last s;n:1);
    chr:exec sum[n]div 2 by ch from chr0,chr1,chr2;
    {max[x]-min x}asc chr};
d14p1:{d14[10;x]};
d14p2:{d14[40;x]};

/
x:"NNCB\n\nCH -> B\nHH -> N\nCB -> H\nNH -> C\nHB -> C\nHC -> B\nHN -> ";
x,:"C\nNN -> C\nBH -> H\nNC -> B\nNB -> B\nBN -> B\nBB -> N\nBC -> B\nCC";
x,:" -> N\nCN -> C";
d14p1 x
d14p2 x

BREAKDOWN:
The idea is to store the number of pairs of characters, which makes it easy to keep track of the
counts across generations.
We cut the input on "\n\n" to get the two sections.
The first section is the initial string.
We cut the second section to lines, then cut each line on " -> " and form a dictionary.
q)a:"\n\n"vs x;
q)s:a 0;
q)r:{x[;0]!raze x[;1]}" -> "vs/:"\n"vs a[1];
q)r
"CH"| B
"HH"| N
"CB"| H
...

We initialize the pair counter from the initial string. To do this we take substrings from all
positions (except the last) and keep the first two characters:
q)til[count[s]-1]
0 1 2
q)til[count[s]-1]_\:s
"NNCB"
"NCB"
"CB"
q)2#/:til[count[s]-1]_\:s
"NN"
"NC"
"CB"
q)pair:count each group 2#/:til[count[s]-1]_\:s
q)pair
"NN"| 1
"NC"| 1
"CB"| 1

Next comes the actual iteration. The number of steps will be a parameter for the function.
In the first step, we take the dictionary apart and find what character will be inserted into each
pair:
q)k:key pair; v:value pair; rk:r[k];
q)rk
"CBH"

We generate the new pairs as a table. The first column will be the first characters of each pair
concatenated with the inserted characters, followed by the inserted characters concatenated with
the last characters of each pair. The second column is the list of counts for the pairs repeated
twice.
q)npair:([]ch:(k[;0],'rk),(rk,'k[;1]);n:v,v);
q)npair
ch   n
------
"NC" 1
"NB" 1
"CH" 1
"CN" 1
"BC" 1
"HB" 1

We collapse this into a dictionary again by summing the counts by the pairs:
q)pair:exec sum n by ch from npair;
q)pair
"BC"| 1
"CH"| 1
"CN"| 1
"HB"| 1
"NB"| 1
"NC"| 1

After all the steps are done, we will end up with the final counts for each pair:
q)pair
"BB"| 812
"BC"| 120
"BH"| 81
"BN"| 735
"CB"| 115
...

We now need to turn this back into a count for the individual characters. If we take the first
character of each pair and match it to the count for the pair, and then do the same for the last
character of each pair, we counted every character twice with the exception of the first and last
character in the string, since those only occur in one pair instead of two. After compensating for
this we divide the counts of the characters by two.
q)chr0:([]ch:key[pair][;0]; n:value pair);
q)chr0
ch n
------
B  812
B  120
B  81
B  735
C  115
...
q)chr1
ch n
------
B  812
C  120
H  81
N  735
...
q)chr2:([]ch:first[s],last s;n:1);
q)chr2
ch n
----
N  1
B  1
q)chr:exec sum[n]div 2 by ch from chr0,chr1,chr2;
q)chr
B| 1749
C| 298
H| 161
N| 865

To get the answer we subtract the minimum of this dictionary from the maximum.
q){max[x]-min x}asc chr
1588
