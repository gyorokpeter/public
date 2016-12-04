d16p1:{t:uj/[{d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x];exec first i+1 from t where children in 0N 3,cats in 0N 7,samoyeds in 0N 2,pomeranians in 0N 3,akitas in 0N 0,vizslas in 0N 0,goldfish in 0N 5,trees in 0N 3,cars in 0N 2,perfumes in 0N 1}
d16p2:{t:uj/[{d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x];exec first i+1 from t where children in 0N 3,(cats=0N) or cats>7,samoyeds in 0N 2,(pomeranians=0N)or pomeranians<3,akitas in 0N 0,vizslas in 0N 0,(goldfish=0N)or goldfish<5,(trees=0N)or trees>3,cars in 0N 2,perfumes in 0N 1}

//BREAKDOWN
//The puzzle description screams "database".
//We are going to store the known info in a table and then query it for the answer.
//(The following 4 lines are part of the same command)
//      x:"Sue 1: akitas: 9, children: 3, samoyeds: 9\n",
//        "Sue 2: cats: 6, trees: 0, cars: 4\n",
//        "Sue 3: pomeranians: 3, perfumes: 1, vizslas: 0\n",
//        "Sue 4: goldfish: 0, vizslas: 0, samoyeds: 2"
//We use the "vs" operator to break the multiline string to a list of strings.
//This is used for most puzzles.
//      "\n"vs x
//  "Sue 1: akitas: 9, children: 3, samoyeds: 9"
//  "Sue 2: cats: 6, trees: 0, cars: 4"
//  "Sue 3: pomeranians: 3, perfumes: 1, vizslas: 0"
//  "Sue 4: goldfish: 0, vizslas: 0, samoyeds: 2"
//We will do the processing of each line in a lambda. For example on the first line:
//      x:"Sue 1: akitas: 9, children: 3, samoyeds: 9"
//We need to chop off the "Sue XXX:" part and turn the other parts into key-value pairs.
//The numbers after "Sue" carry no info since they can be calculated from the row index.
//First we split the line by spaces:
//      " "vs x
//  "Sue"
//  "1:"
//  "akitas:"
//  "9,"
//  "children:"
//  "3,"
//  "samoyeds:"
//  ,"9"
//We drop the two first elements to keep only the useful data:
//      2_" "vs x
//  "akitas:"
//  "9,"
//  "children:"
//  "3,"
//  "samoyeds:"
//  ,"9"
//We store this temporary result in "d". Then we pair up the keys and values:
//      d:2_" "vs x
//      0N 2#d
//  "akitas:"   "9,"
//  "children:" "3,"
//  "samoyeds:" ,"9"
//(Another way to write this would be "2 cut d".) We store this in "d2".
//      d2:0N 2#d
//Then we need to turn this value into a dictionary. First we take the numbers:
//      d2[;1]
//  "9,"
//  "3,"
//  ,"9"
//There are still commas in there, which we remove (we need to remove it from each
//string, hence the use of the \: "each-left" adverb):
//      d2[;1]except\:","
//  ,"9"
//  ,"3"
//  ,"9"
//Now we can cast them to numbers:
//      "J"$(d2[;1]except\:",")
//  9 3 9
//For the key side, we take the key strings:
//      d2[;0]
//  "akitas:"
//  "children:"
//  "samoyeds:"
//Once again we have superfluous characters (colons) but this is more predictable,
//so we just drop the last character of each string (using the /: "each-right" adverb)
//      -1_/:d2[;0]
//  "akitas"
//  "children"
//  "samoyeds"
//We cast them to symbols since they will be our record "field" names:
//      `$-1_/:d2[;0]
//  `akitas`children`samoyeds
//We link together the keys and vaues into a dictionary:
//      (`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")
//  akitas  | 9
//  children| 3
//  samoyeds| 9
//We need to enlist the dictionary to make a one-row table. The reason for this will
//be apparent only with the next step.
//      enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")
//  akitas children samoyeds
//  ------------------------
//  9      3        9
//So we are done with the processing of one row. We put this in a lambda and apply it to
//all rows (using the initial value of x from the beginning):
//      {d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x
//  +`akitas`children`samoyeds!(,9;,3;,9)
//  +`cats`trees`cars!(,6;,0;,4)
//  +`pomeranians`perfumes`vizslas!(,3;,1;,0)
//  +`goldfish`vizslas`samoyeds!(,0;,0;,2)
//We now have a one-row table for each row. To merge them together, either we could
//define an empty schema and insert the small tables into it, or use the union join (uj)
//operator. The latter is more elegant since it works no matter what the table columns are.
//Union join works between two tables. This is why we needed to enlist the dictionaries
//in the lambda, and for the same reason we need to use it with the "over" adverb (/) so
//it will accumulate all the small tables into one big table. Missing data will be
//filled with nulls.
//      uj/[{d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x]
//  akitas children samoyeds cats trees cars pomeranians perfumes vizslas goldfish
//  ------------------------------------------------------------------------------
//  9      3        9
//                           6    0     4
//                                           3           1        0
//                  2                                             0       0
//We store this table to the variable "t":
//      t:uj/[{d:2_" "vs x;d2:0N 2#d;enlist(`$-1_/:d2[;0])!"J"$(d2[;1]except\:",")}each"\n"vs x]
//
// Part 1:
//Now that we have our data table, getting the answer is a matter of putting together the
//right query.
//      exec first i+1 from t where
//           children in 0N 3,
//           cats in 0N 7,
//           samoyeds in 0N 2,
//           pomeranians in 0N 3,
//           akitas in 0N 0,
//           vizslas in 0N 0,
//           goldfish in 0N 5,
//           trees in 0N 3,
//           cars in 0N 2,
//           perfumes in 0N 1
//  3
//Notice that for each constraint in the where clause, we need to allow the corresponding field
//to be null. So we check for e.g. "children in 0N 3" instead of "children=3".
//An equivalent phrasing would be "3=3^children", filling the nulls with 3 so that they match.
//We are interested in the index number, so instead of "select" we just "exec i+1" (the row
//index starts from zero while the puzzle answer starts from one). We take the "first i+1"
//because a well-formed input will have exactly one row that matches the constraints.
//
// Part 2:
//The table is the same, but the query is different due to the changed constraints:
//      exec first i+1 from t where
//          children in 0N 3,
//          (cats=0N) or cats>7,
//          samoyeds in 0N 2,
//          (pomeranians=0N)or pomeranians<3,
//          akitas in 0N 0,vizslas in 0N 0,
//          (goldfish=0N)or goldfish<5,
//          (trees=0N)or trees>3,
//          cars in 0N 2,
//          perfumes in 0N 1
//  4
//Once again we need to allow nulls in the columns where the new constraints allow a greater/
//smaller value than the number in the constraint. We could use the "fill" operator as well
//(e.g. 7<8^cats so that nulls are filled with a value that matches), or for the
//pomeranians and goldfish conditions, (ab)use the fact that null is the smallest value so
//"pomeranians<3" will match nulls on its own.
