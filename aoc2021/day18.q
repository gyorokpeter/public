.d18.reduce1:{[xn]
    x:xn 0; n:xn 1;
    depth:sums(x="[")-x="]";
    deep:(5<=depth) and not null n;
    expl:deep?1b;
    if[expl<count[depth];
        left:last where not null expl#n;
        right:(expl+3)+first where not null (expl+3)_n;
        if[not null left; n[left]+:n[expl]];
        if[not null right; n[right]+:n[expl+2]];
        n:((expl-1)#n),0,(expl+4)_n;
        x:((expl-1)#x),"0",(expl+4)_x;
        :(x;n);
    ];
    split:first where 10<=n;
    if[not null split;
        sn:{(floor x%2;ceiling x%2)}n[split];
        n:(split#n),0N,sn[0],0N,sn[1],0N,(split+1)_n;
        x:(split#x),"[0,0]",(split+1)_x;
        :(x;n);
    ];
    xn};

.d18.reduce:{
    n:a:"J"$/:x;
    xn:(x;n);
    red:.d18.reduce1/[xn];
    x:red 0; n:red 1;
    digits:where not null n;
    x[digits]:raze string n[digits];
    x};

.d18.add:{.d18.reduce"[",x,",",y,"]"};
.d18.sum:{.d18.add/[x]};

/.d18.reduce["[[[[[9,8],1],2],3],4]"]~"[[[[0,9],2],3],4]"
/.d18.reduce["[7,[6,[5,[4,[3,2]]]]]"]~"[7,[6,[5,[7,0]]]]"
/.d18.reduce["[[6,[5,[4,[3,2]]]],1]"]~"[[6,[5,[7,0]]],3]"
/.d18.reduce["[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"]~"[[3,[2,[8,0]]],[9,[5,[7,0]]]]"

/.d18.reduce["[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"]~"[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"

/.d18.add["[[[[4,3],4],4],[7,[[8,4],9]]]";"[1,1]"]~"[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
/.d18.sum[("[1,1]";"[2,2]";"[3,3]";"[4,4]")]~"[[[[1,1],[2,2]],[3,3]],[4,4]]"
/.d18.sum[("[1,1]";"[2,2]";"[3,3]";"[4,4]";"[5,5]")]~"[[[[3,0],[5,3]],[4,4]],[5,5]]"
/.d18.sum[("[1,1]";"[2,2]";"[3,3]";"[4,4]";"[5,5]";"[6,6]")]~"[[[[5,0],[7,4]],[5,5]],[6,6]]"

.d18.magn1:{
    x0:x;
    if[0h=type x; x:.z.s each x];
    if[-9h=type x; :x];
    sum 3 2*x};
.d18.magn:{
    xk:.j.k x;
    .d18.magn1 xk};

/.d18.magn["[[9,1],[1,9]]"]=129
/.d18.magn["[[1,2],[[3,4],5]]"]=143
/.d18.magn["[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"]=1384
/.d18.magn["[[[[1,1],[2,2]],[3,3]],[4,4]]"]=445
/.d18.magn["[[[[3,0],[5,3]],[4,4]],[5,5]]"]=791
/.d18.magn["[[[[5,0],[7,4]],[5,5]],[6,6]]"]=1137
/.d18.magn["[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"]=3488

d18p1:{.d18.magn .d18.sum"\n"vs x};
d18p2:{max .d18.magn each raze {x .d18.add/:\:x }"\n"vs x};

/
x:"[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]\n[[[5,[2,8]],4],[5,[[";
x,:"9,9],0]]]\n[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]\n[[[6,[0,7]],[0,9]],[4,[9,[";
x,:"9,0]]]]\n[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]\n[[6,[[7,3],[3,2]]],[[[3,";
x,:"8],[5,7]],4]]\n[[[[5,4],[7,7]],8],[[8,3],8]]\n[[9,3],[[9,9],[6,[4,9]]]]\n";
x,:"[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]\n[[[[5,2],5],[8,[3,7]]],[[5,[7,5]";
x,:"],[4,4]]]";
d18p1 x
d18p2 x

OVERVIEW:
The difficulty is that the explode operation is best done on the string representation since it
ignores the brackets, but it also needs to be able to operate on numbers and those may go above
10 so they can't be kept as characters.
So I manage this by creating a parallel array that contains all the numbers, and keep both the
string and the number array up to date throughout the reduction operations, but in the string the
numbers are only placeholders and only substituted back at the end when all reduction is done.
On the other hand the magnitude is much easier to calculate by first parsing the string as JSON and
then using a recursive function on the tree to evaluate it.
