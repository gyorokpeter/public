d3p1:{s:asc each value each"\n"vs x;sum s[;2]<s[;0]+s[;1]}
d3p2:{s:asc each 3 cut raze flip value each "\n"vs x;sum s[;2]<s[;0]+s[;1]}

d3p1"5 10 25\n5 25 10\n25 5 10\n3 4 5"
d3p2"101 301 501\n102 302 502\n103 303 503\n201 401 601\n202 402 602\n203 403 603"

//BREAKDOWN
//Input parsing:
//      x:"5 10 25\n5 25 10\n25 5 10\n3 4 5"
//We use the "vs" operator to break the multiline string to a list of strings.
//This is used for most puzzles.
//      "\n"vs x
//  "5 10 25"
//  "5 25 10"
//  "25 5 10"
//  "3 4 5"
//
//Since each line is a valid list literal, we can just use "value" to parse them.
//We also need to use "each" since we want to apply the function to each string individually.
//      value each"\n"vs x
//  5  10 25
//  5  25 10
//  25 5  10
//  3  4  5
//
// Part 1:
//We need to find the lines where there is a way to label the 3 numbers with the letters
//a, b and c in some order such that a+b<c. This implies a<c and b<c, i.e. c is the biggest
//of the three numbers. We could either compare the sums of two numbers to the third in all
//three ways, or just sort the numbers in ascending order and do one comparison to the
//biggest number. Once again we need to use "each" since we are sorting the numbers inside
//the triangles instead of sorting the list of triangles.
//      asc each value each"\n"vs x
//  5 10 25
//  5 10 25
//  5 10 25
//  3 4  5
//We store this in the variable "s".
//      s:asc each value each"\n"vs x
//To do the actual check of the triangle sides, all we have to do is add the first element
//of each list to the second element and compared to the third. We use indexing at depth and
//the "penetration" propert of the "+" and "<" operators to achieve this.
//      s[;0]
//  5 5 5 3
//      s[;1]
//  10 10 10 4
//      s[;2]
//  25 25 25 5
//      s[;2]<s[;0]+s[;1]
//  0001b
//The last result is a boolean list telling us which triangle is valid. Since boolean values
//can work as the integers 0 and 1, all we have to do is sum the list. This is the final
//result.
//      sum s[;2]<s[;0]+s[;1]
//  1i
//
// Part 2:
//The only difference is the input parsing. We start like part 1:
//      x:"101 301 501\n102 302 502\n103 303 503\n201 401 601\n202 402 602\n203 403 603"
//      value each"\n"vs x
//  101 301 501
//  102 302 502
//  103 303 503
//  201 401 601
//  202 402 602
//  203 403 603
//The values in the wrong order! However we can fix that by flipping (transposing) the
//matrix:
//      flip value each "\n"vs x
//  101 102 103 201 202 203
//  301 302 303 401 402 403
//  501 502 503 601 602 603
//But now each row has (in this case) 6 elements instead of 3. So we first raze the matrix:
//      raze flip value each "\n"vs x
//  101 102 103 201 202 203 301 302 303 401 402 403 501 502 503 601 602 603
//And since now we have a vector instead of the matrix, we can cut it into lists of 3
//elements to get a matrix of the proper shape:
//      3 cut raze flip value each "\n"vs x
//  101 102 103
//  201 202 203
//  301 302 303
//  401 402 403
//  501 502 503
//  601 602 603
//From this point we continue where we left off in Part 1.
//      s:asc each 3 cut raze flip value each "\n"vs x
//      sum s[;2]<s[;0]+s[;1]
//  6i