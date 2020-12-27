d2:{update "J"$"-"vs/:num, first each ch from flip`num`ch`pw!flip" "vs/:"\n"vs x};
d2p1:{exec count i from d2[x] where (sum each pw=ch)within' num};
d2p2:{exec count i from d2[x] where 1=sum each ch=pw@'num-1};


/d2p1 x:"1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc"

/
BREAKDOWN:

q)x:"1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc"

COMMON:
The input parsing is a bit more interesting as we prepare for both parts.
First we break the input into lines as usual:
q)"\n"vs x
"1-3 a: abcde"
"1-3 b: cdefg"
"2-9 c: ccccccccc"

Then we break each line along the spaces. We need to use vs with /: this time since we have a
list of strings:
q)" "vs/:"\n"vs x
"1-3" "a:" "abcde"
"1-3" "b:" "cdefg"
"2-9" "c:" "ccccccccc"

We turn this into a table using the low-level way, by making a dictionary and flipping it:
q)`num`ch`pw!flip" "vs/:"\n"vs x
num| "1-3"   "1-3"   "2-9"
ch | "a:"    "b:"    "c:"
pw | "abcde" "cdefg" "ccccccccc"
q)flip`num`ch`pw!flip" "vs/:"\n"vs x
num   ch   pw
----------------------
"1-3" "a:" "abcde"
"1-3" "b:" "cdefg"
"2-9" "c:" "ccccccccc"

We need to process the columns a bit. In the ch column we take the first character only:
q)update first each ch from flip`num`ch`pw!flip" "vs/:"\n"vs x
num   ch pw
--------------------
"1-3" a  "abcde"
"1-3" b  "cdefg"
"2-9" c  "ccccccccc"

In the num column we first split the values by dashes (there is of course only one per line):
q)update "-"vs/:num, first each ch from flip`num`ch`pw!flip" "vs/:"\n"vs x
num       ch pw
------------------------
,"1" ,"3" a  "abcde"
,"1" ,"3" b  "cdefg"
,"2" ,"9" c  "ccccccccc"

Then we convert the numbers into the actual number type ("J" or long in this case):
q)update "J"$"-"vs/:num, first each ch from flip`num`ch`pw!flip" "vs/:"\n"vs x
num ch pw
------------------
1 3 a  "abcde"
1 3 b  "cdefg"
2 9 c  "ccccccccc"

Now we have a table that can be more easily used to answer the questions in both parts.

PART 1:

q)d2[x]
num ch pw
------------------
1 3 a  "abcde"
1 3 b  "cdefg"
2 9 c  "ccccccccc"

First we find the number of times "ch" appears in "pw". Note that a char=string comparison
automatically causes the char to be matched against each character in the string.

q)update x:ch=pw from d2[x]
num ch pw          x
-----------------------------
1 3 a  "abcde"     10000b
1 3 b  "cdefg"     00000b
2 9 c  "ccccccccc" 111111111b

To find the number of matches, we simply sum the boolean values. It should be "sum each", as we
are summing each row, while plain "sum" would sum each column which is not what we want.

q)update x:sum each ch=pw from d2[x]
num ch pw          x
--------------------
1 3 a  "abcde"     1
1 3 b  "cdefg"     0
2 9 c  "ccccccccc" 9

And finally we check if the count is within the given numbers. Once again we have to use an
iterator (') because within needs a list of length 2, but "num" is the entire column, so we
want to walk over the elements in it.

q)update x:(sum each ch=pw) within' num from d2[x]
num ch pw          x
--------------------
1 3 a  "abcde"     1
1 3 b  "cdefg"     0
2 9 c  "ccccccccc" 1

But this whole "update" business was just to show the intermediate values, what we really want
is to filter the table based on where this value is true:

q)select from d2[x] where (sum each ch=pw) within' num
num ch pw
------------------
1 3 a  "abcde"
2 9 c  "ccccccccc"

And in fact we don't even need the actual values, just their count, so we use "exec count i".
q)exec count i from d2[x] where (sum each ch=pw) within' num
2

PART 2:

q)d2[x]
num ch pw
------------------
1 3 a  "abcde"
1 3 b  "cdefg"
2 9 c  "ccccccccc"

This time we are using num as an index into pw. We use the @ indexing operator with each (') to
pair up each password with the corresponding number pair. Also we subtract 1 from num because
list indexing is 0-based.
q)update x:pw@'num-1 from d2[x]
num ch pw          x
-----------------------
1 3 a  "abcde"     "ac"
1 3 b  "cdefg"     "ce"
2 9 c  "ccccccccc" "cc"

Then we check how many times ch appears in the result of the indexing, similar to part 1:
q)update x:sum each ch=pw@'num-1 from d2[x]
num ch pw          x
--------------------
1 3 a  "abcde"     1
1 3 b  "cdefg"     0
2 9 c  "ccccccccc" 2

This time we are looking for the rows where the count is equal to 1:
q)update x:1=sum each ch=pw@'num-1 from d2[x]
num ch pw          x
--------------------
1 3 a  "abcde"     1
1 3 b  "cdefg"     0
2 9 c  "ccccccccc" 0

And like in part 1 we only care about the number of rows where this condition is true:
q)exec count i from d2[x] where 1=sum each ch=pw@'num-1
1
