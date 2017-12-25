d2p1:{r:value each "\n"vs x;sum(max each r)-min each r};
d2p1 "5 1 9 5
      7 5 3
      2 4 6 8"   //18

d2p2:{r:value each "\n"vs x;sum{(%). first{x where (x[;0]<>x[;1])and 0=x[;0]mod x[;1]}(x cross x)}each r};
d2p2 "5 9 2 8
      9 4 7 3
      3 8 6 5" //9

/
BREAKDOWN:

Input parsing:
Since each line of the input conforms to the syntax of a Q list, we can simply call value on them after breaking the input to lines using "\n"sv.
q)value each "\n"vs "5 1 9 5\n7 5 3\n2 4 6 8"
(5 1 9 5j;7 5 3j;2 4 6 8j)

Part 1:
This is just writing down what the puzzle is asking us to do:
q)r:value each "\n"vs "5 1 9 5\n7 5 3\n2 4 6 8"
q)max each r
9 7 8j
q)min each r
1 3 2j
q)(max each r)-min each r
8 4 6j
q)sum(max each r)-min each r
18j

Part 2:
This will be done in a function that is applied to one line.
q)x:5 9 2 8j
We generate each pairing of the numbers in the list:
q)x cross x
(5 5j;5 9j;5 2j;5 8j;9 5j;9 9j;9 2j;9 8j;2 5j;2 9j;2 2j;2 8j;8 5j;8 9j;8 2j;8 8j)
Then we find the pairs where the second element divides the first, using x[;0] to index the first item of each pair
and x[;1] to index the second element of each pair:
q)x:x cross x
q)0=x[;0]mod x[;1]
1000010000100011b
We also need to filter out pairs where the two elemens match, since "cross" includes those:
q)x[;0]<>x[;1]
0111101111011110b
q)x where (x[;0]<>x[;1])and 0=x[;0]mod x[;1]
enlist 8 2j
The result should be the single pair that is evenly divisible, so we can just take the first (the only) element.
q)x:5 9 2 8j
q)first{x where (x[;0]<>x[;1])and 0=x[;0]mod x[;1]}(x cross x)
8 2j
One way to do division on a two-element list is to use the "." operator with the division operator.
q)(%). first{x where (x[;0]<>x[;1])and 0=x[;0]mod x[;1]}(x cross x)
4f
Once we have this value for all rows, we sum them together.
q)r:(5 9 2 8;9 4 7 3;3 8 6 5)
q)sum{(%). first{x where (x[;0]<>x[;1])and 0=x[;0]mod x[;1]}(x cross x)}each r
9f
