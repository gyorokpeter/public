d4p1:{r:"\n"vs x;sum{p:"-"vs x;n:raze -1_p;id1:5#raze value asc each group desc count each group n;id2:-1_-6#last p;$[id1~id2;"J"$-7_last p;0]}each r}
d4p2:{r:"\n"vs x;o:{p:"-"vs x;n:raze -1_p;id1:5#raze value asc each group desc count each group n;id2:-1_-6#last p;m:"J"$-7_last[p];$[id1~id2;(m;" "sv`char$97+(-97+m+`long$-1_p)mod 26);()]}each r;o[o[;1]?"northpole object storage";0]}

d4p1"aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]"
d4p2"hqcfqwydw-fbqijys-whqii-huiuqhsx-660[qhiwf]\nbcfhvdczs-cpxsqh-ghcfous-324[chsfb]"

//BREAKDOWN
//For both parts we need to validate the room numbers.
//      x:"aaaaa-bbb-z-y-x-123[abxyz]\n",
//          "a-b-c-d-e-f-g-h-987[abcde]\n",
//          "not-a-real-room-404[oarel]\n",
//          "totally-real-room-200[decoy]"
//We use the "vs" operator to break the multiline string to a list of strings.
//This is used for most puzzles.
//      "\n"vs x
//  "aaaaa-bbb-z-y-x-123[abxyz]"
//  "a-b-c-d-e-f-g-h-987[abcde]"
//  "not-a-real-room-404[oarel]"
//  "totally-real-room-200[decoy]"
//      r:"\n"vs x
//The validation will be done in a lambda so we pick an example from the four lines.
//      x:"not-a-real-room-404[oarel]"
//We break the string along the dashes and store this in "p":
//      "-"vs x
//  "not"
//  ,"a"
//  "real"
//  "room"
//  "404[oarel]"
//      p:"-"vs x
//The room name will be all but the last item razed together:
//      raze -1_p
//  "notarealroom"
//      n:raze -1_p
//Here comes the interesting part: finding the checksum based on letter frequency. The
//first step is to "group" the name:
//      group n
//  n| ,0
//  o| 1 9 10
//  t| ,2
//  a| 3 6
//  r| 4 8
//  e| ,5
//  l| ,7
//  m| ,11
//The "group" function essentially flips the domain and range of an object, so if we pass
//it a vector, it returns a mapping from the elements of the vector to the indices where
//that particular element appears. This can be used to calculate frequency, by counting
//the number of indices in each group:
//      count each group n
//  n| 1
//  o| 3
//  t| 1
//  a| 2
//  r| 2
//  e| 1
//  l| 1
//  m| 1
//We can simply put the frequency map in descending order with the "desc" function:
//      desc count each group n
//  o| 3
//  a| 2
//  r| 2
//  n| 1
//  t| 1
//  e| 1
//  l| 1
//  m| 1
//We need to take the top 5 letters, but in alphabetic order. One way to do this uses the
//"group" function again, so that we get the sets of letters for each frequency:
//      group desc count each group n
//  3| ,"o"
//  2| "ar"
//  1| "ntelm"
//This time we want the letters to be in ascending order within the small lists, not sort
//the whole list like before so we need to use "asc" with the "each" function:
//      asc each group desc count each group n
//  3| `s#,"o"
//  2| `s#"ar"
//  1| `s#"elmnt"
//(The `s# indicates that the elements are sorted, but we can ignore it for this puzzle.)
//To get the 5 most frequent letters in the correct order, we just raze the lists and take
//the first 5 elements:
//      5#raze value asc each group desc count each group n
//  "oarel"
//We store this in the "id1" variable. Meanwhile we also extract the checksum from the
//input string, by taking the last element of "p" and dropping the excess characters:
//      id1:5#raze value asc each group desc count each group n
//      -1_-6#last p
//  "oarel"
//The two checksums shold match if the room is real:
//      id2:-1_-6#last p
//      $[id1~id2;"real";"fake"]
//  "real"
//We need the sum of the room IDs for the real rooms only. Fake rooms contribute nothing to
//the sum so we will just return 0 for the "fake" case. For the "real" case we extract the
//number from the last element of p by dropping the last 7 characters:
//      -7_last p
//  "404"
//We need to cast this to a number to be able to add it:
//      "J"$-7_last p
//  404
//So the actual expression that will return the value for the room is
//      $[id1~id2;"J"$-7_last p;0]
//  404
//Now we apply this sequence of calculations to all rooms:
//      {p:"-"vs x;n:raze -1_p;id1:5#raze value asc each group desc count each group
//          n;id2:-1_-6#last p;$[id1~id2;"J"$-7_last p;0]}each r
//  123 987 404 0
//The final step is to sum them up:
//      sum{p:"-"vs x;n:raze -1_p;id1:5#raze value asc each group desc count each group
//          n;id2:-1_-6#last p;$[id1~id2;"J"$-7_last p;0]}each r
//  1514
//
// Part 2:
//whole input:
//      x:"hqcfqwydw-fbqijys-whqii-huiuqhsx-660[qhiwf]\nbcfhvdczs-cpxsqh-ghcfous-324[chsfb]"
//example input line for the lambda:
//      x:"hqcfqwydw-fbqijys-whqii-huiuqhsx-660[qhiwf]"
//The procedure is the same as part 1 until after we calculated "id1" and "id2".
//      p:"-"vs x
//      n:raze -1_p
//      id1:5#raze value asc each group desc count each group n
//      id2:-1_-6#last p
//We put the ID number in the variable "m" since we will use it twice for this part:
//      m:"J"$-7_last[p]
//This time for the "fake" case we will return an empty list (). For the "real" case we do
//the decryption. We convert the name (except the last part with the ID/checksum) to numbers:
//      `long$-1_p
//  104 113 99 102 113 119 121 100 119
//  102 98 113 105 106 121 115
//  119 104 113 105 105
//  104 117 105 117 113 104 115 120
//We subtract 97 (the ASCII code for "a") and add the room ID:
//      -97+m+`long$-1_p
//  667 676 662 665 676 682 684 663 682
//  665 661 676 668 669 684 678
//  682 667 676 668 668
//  667 680 668 680 676 667 678 683
//We take the modulo 26 (number of letters in the alphabet) and add back the 97:
//      97+(-97+m+`long$-1_p)mod 26
//  114 97 109 112 97 103 105 110 103
//  112 108 97 115 116 105 99
//  103 114 97 115 115
//  114 101 115 101 97 114 99 104
//We cast this back to characters and join them together separated by spaces:
//      " "sv`char$97+(-97+m+`long$-1_p)mod 26
//  "rampaging plastic grass research"
//The return value needs to include the ID number, so we return a two-element list
//consisting of name and ID number.
//      (m;" "sv`char$97+(-97+m+`long$-1_p)mod 26)
//  660
//  "rampaging plastic grass research"
//Putting the operations together, we apply it to each room and store the result in "o":
//      o:{p:"-"vs x;n:raze -1_p;id1:5#raze value asc each group desc count each group
//          n;id2:-1_-6#last p;m:"J"$-7_last[p];$[id1~id2;(m;" "sv`char$97+(-97+m+`long$-1_p)mod
//          26);()]}each r
//  660 "rampaging plastic grass research"
//  324 "northpole object storage"
//      o:{p:"-"vs x;n:raze -1_p;id1:5#raze value asc each group desc count each group
//          n;id2:-1_-6#last p;m:"J"$-7_last[p];$[id1~id2;(m;" "sv`char$97+(-97+m+`long$-1_p)mod
//          26);()]}each r
//This is imprecisely defined in the puzzle description so it needs manually looking at the
//decrypted room names, but the one we are looking for is "northpole object storage".
//We search for this string in the list of names which we get by indexing at depth:
//      o[;1]
//  "rampaging plastic grass research"
//  "northpole object storage"
//      o[;1]?"northpole object storage"
//  1
//We got back the position of the room we are looking for. So we returnt the ID which is the
//first element at the specific index.
//      o[o[;1]?"northpole object storage"]
//  324
//  "northpole object storage"
//      o[o[;1]?"northpole object storage";0]
//  324
