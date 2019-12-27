d16p1:{
    a:`float$"J"$/:x;
    m:`float$1_/:(1+count[a])#/:raze each flip(1+til count a)#'/:0 1 0 -1;
    do[100;a:(abs m mmu a)mod 10];
    raze string 8#a};
d16p2:{
    off:"J"$7#x;
    a:(off-10000*count[x])#"J"$/:x;
    b:reverse {sums[x]mod 10}/[100;reverse a];
    raze string 8#b};

//d16p1"59775675999083203307460316227239534744196788252810996056267313158415747954523514450220630777434694464147859581700598049220155996171361500188470573584309935232530483361639265796594588423475377664322506657596419440442622029687655170723364080344399753761821561397734310612361082481766777063437812858875338922334089288117184890884363091417446200960308625363997089394409607215164553325263177638484872071167142885096660905078567883997320316971939560903959842723210017598426984179521683810628956529638813221927079630736290924180307474765551066444888559156901159193212333302170502387548724998221103376187508278234838899434485116047387731626309521488967864391"

/
BREAKDOWN:

Part 1:
We convert the input into numbers and cast them into floats. This is because for an
unexplained reason the mmu (matrix multiply) operator doesn't work on anything else.
q)x:"12345678"
q)a:`float$"J"$/:x
1 2 3 4 5 6 7 8f

Now we build up a matrix that can be used to multiply the input vector to get the next
state. We start with the four items in the period:
q)0 1 0 -1
0 1 0 -1

We duplicate each item by the row index plus 1:
q)1+til count a
1 2 3 4 5 6 7 8
q)(1+til count a)#'/:0 1 0 -1
,0  0 0   0 0 0    0 0 0 0     0 0 0 0 0      0 0 0 0 0 0       0 0 0 0 0 0 0        0 0 0 0 0 0 0 0
,1  1 1   1 1 1    1 1 1 1     1 1 1 1 1      1 1 1 1 1 1       1 1 1 1 1 1 1        1 1 1 1 1 1 1 1
,0  0 0   0 0 0    0 0 0 0     0 0 0 0 0      0 0 0 0 0 0       0 0 0 0 0 0 0        0 0 0 0 0 0 0 0
,-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1

We flip this such that the items corresponding to a row in the final matrix are in the correct place:
q)flip(1+til count a)#'/:0 1 0 -1
0                       1                       0                       -1
0  0                    1  1                    0  0                    -1 -1
0  0  0                 1  1  1                 0  0  0                 -1 -1 -1
0  0  0  0              1  1  1  1              0  0  0  0              -1 -1 -1 -1
0  0  0  0  0           1  1  1  1  1           0  0  0  0  0           -1 -1 -1 -1 -1
0  0  0  0  0  0        1  1  1  1  1  1        0  0  0  0  0  0        -1 -1 -1 -1 -1 -1
0  0  0  0  0  0  0     1  1  1  1  1  1  1     0  0  0  0  0  0  0     -1 -1 -1 -1 -1 -1 -1
0  0  0  0  0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0  0  0  0  0  -1 -1 -1 -1 -1 -1 -1 -1

We raze each row to remove the extra level of nesting:
q)raze each flip(1+til count a)#'/:0 1 0 -1
0 1 0 -1
0 0 1 1 0 0 -1 -1
0 0 0 1 1 1 0 0 0 -1 -1 -1
0 0 0 0 1 1 1 1 0 0 0 0 -1 -1 -1 -1
0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 -1 -1 -1 -1 -1
0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1
0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 -1
0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 -1 -1

We use the take operator to resize each row to the length of the input. However
we actually need to take an extra element and drop the first element to get the exact
matrix we need.
q)(count[a])#/:raze each flip(1+til count a)#'/:0 1 0 -1
0 1 0 -1 0 1 0  -1
0 0 1 1  0 0 -1 -1
0 0 0 1  1 1 0  0
0 0 0 0  1 1 1  1
0 0 0 0  0 1 1  1
0 0 0 0  0 0 1  1
0 0 0 0  0 0 0  1
0 0 0 0  0 0 0  0
q)1_/:(1+count[a])#/:raze each flip(1+til count a)#'/:0 1 0 -1
1 0 -1 0 1 0  -1 0
0 1 1  0 0 -1 -1 0
0 0 1  1 1 0  0  0
0 0 0  1 1 1  1  0
0 0 0  0 1 1  1  1
0 0 0  0 0 1  1  1
0 0 0  0 0 0  1  1
0 0 0  0 0 0  0  1

And cast to float to allow mmu to be used on it:
q)m:`float$1_/:(1+count[a])#/:raze each flip(1+til count a)#'/:0 1 0 -1
q)m:`float$1_/:(1+count[a])#/:raze each flip(1+til count a)#'/:0 1 0 -1
q)m
1 0 -1 0 1 0  -1 0
0 1 1  0 0 -1 -1 0
0 0 1  1 1 0  0  0
0 0 0  1 1 1  1  0
0 0 0  0 1 1  1  1
0 0 0  0 0 1  1  1
0 0 0  0 0 0  1  1
0 0 0  0 0 0  0  1

Now do 100 iterations, performing an abs and a mod 10 after the matrix multiplication:
q)do[100;a:(abs m mmu a)mod 10]
q)a
2 3 8 4 5 6 7 8f

Then convert to string and raze. This is to ensure that any leading zeros are preserved.
q)raze string 8#a
"23845678"

PART 2:
This is not a general solution. It only works on input that abuses the fact that the
2nd half of the vector is the partial sums counting back from the end of the vector
(mod 10). Therefore we only need the end of the extended input starting from the
message offset.
First we parse the message offset:
q)x:"03036732577212944063491565474664"
q)off:"J"$7#x;
q)off
303673

Then we take the necessary number of items from the back of the vector. Note that when
taking a negative amount from a vector, we start from the back, and taking more elements
than the length of the list will cause it to wrap around.

q)off-10000*count[x]
-16327
q)a:(off-10000*count[x])#"J"$/:x
q)a
q)a
5 4 7 4 6 6 4 0 3 0 3 6 7 3 2 5 7 7 2 1 2 9 4 4 0 6 3 4 9 1 5 6 5 4 7 4 6 6 4..

Now comes the main iteration. It can be done using the / iterator, but first we need
to reverse the vector since sums works only forward, and also reverse after getting the result.
q)b:reverse {sums[x]mod 10}/[100;reverse a]
q)b
8 4 4 6 2 0 2 6 8 6 4 0 2 8 6 6 0 6 4 0 0 0 0 0 6 2 8 2 8 6 6 0 8 4 4 6 2 0 2..

Finally we extract the solution like in part 1:
q)raze string 8#b
"84462026"
