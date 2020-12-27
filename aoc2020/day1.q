d1p1:{a:"J"$"\n"vs x;prd a where a in 2020-a};
d1p2:{a:"J"$"\n"vs x;prd a where (2020-a) in raze a+/:a};

/

d1p1 x:"1721\n979\n366\n299\n675\n1456"
d1p2 x:"1721\n979\n366\n299\n675\n1456"

BREAKDOWN:
q)x:"1721\n979\n366\n299\n675\n1456"

PART 1:
First we convert the input into a list of integers:
q)a:"J"$"\n"vs x
q)a
1721 979 366 299 675 1456

We subtract the list from 2020.
q)2020-a
299 1041 1654 1721 1345 564

Now if a number b appears in the list 2020-a, that means b=2020-a, or a+b=2020.
To check which number it is, we use "in", which checks each element of the list on the left in turn:
q)a in 2020-a
100100b

The elements where this returns true are those that add up to 2020. So we use "where" to find the indices:
q)where a in 2020-a
0 3

And we use this as an index to the original list:
q)a where a in 2020-a
1721 299

The answer is the product of the resulting list.
q)prd a where a in 2020-a
514579

PART 2:
We generate the variable "a" like before. This time we pairwise add together the elements of a in
all possible combinations. If a number b+c appears in this list as well as 2020-a, that means
b+c=2020-a, so a+b+c=2020. To create the pairwise sums of the list, we can use the + operator with
/: which in effect means add the list on the left to each element on the right, while "adding a list
to a number" itself is done by adding the number to each element.
q)a+/:a
3442 2700 2087 2020 2396 3177
2700 1958 1345 1278 1654 2435
2087 1345 732  665  1041 1822
2020 1278 665  598  974  1755
2396 1654 1041 974  1350 2131
3177 2435 1822 1755 2131 2912

Since this list has two levels of nesting we need to raze to flatten it:
q)raze a+/:a
3442 2700 2087 2020 2396 3177 2700 1958 1345 1278 1654 2435 2087 1345 732 665 1041 1822 2020 1278 665..

Now we can check which elements of (2020-a) appear among the sums:
q)(2020-a) in raze a+/:a
011010b

Similarly to part 1 we pick out the corresponding elements from the list and multiply them.,
q)prd a where (2020-a) in raze a+/:a
241861950
