d16:{
    b:"B"$/:y;
    b2:{[len;b]$[len<=count[b];len#b;b,0b,reverse not b]}[x]/[b];
    c:{[b2]$[1=count[b2]mod 2;b2;.[=]'[2 cut b2]]}/[b2];
    c};

d16[20;"10000"]
d16[272;"01110110101001000"]
d16[35651584;"01110110101001000"]

//BREAKDOWN:
//This is a naive solution. Even though the length required for part 2 is large, the
//same solution works and finishes within the 30 second time limit.
//The input is a string so we convert it to booleans first.
//"B"$ converts the entire string but we want one boolean per character so we use the
// /: adverb.
//      "B"$/:"10000"
//  10000b
//The full data stream is generated in an iterative function.
//The exit condition will be exceeding the desired data length.
//      len:20
//      len<=count[b]
//  0b
//For the "false" branch, we construct the new data according to the puzzle statement:
//      b,0b,reverse not b
//  10000011110b
//For the "true" branch, we cut the excess characters from the end of the string:
//      b:10000011110010000111110b
//      count b
//  23
//      len#b
//  10000011110010000111b
//Putting the three parts together:
//      $[len<=count[b];len#b;b,0b,reverse not b]
//We wrap this in a lambda. The length parameter is bound, while the bits parameter
//is iterated using the / adverb in "converge" sense:
//      b2:{[len;b]$[len<=count[b];len#b;b,0b,reverse not b]}[x]/[b]
//      b2
//  10000011110010000111b
//Generating the checksum follows the same pattern. This time the exit condition is that
//the length of the string is odd:
//      1=count[b2]mod 2
//  0b
//The "true" case simply returns the string.
//The "false" case computes the next checksum. To do this we first cut the string into
//pieces of length 2:
//      2 cut b2
//  10b
//  00b
//  00b
//  11b
//  11b
//  00b
//  10b
//  00b
//  01b
//  11b
//Next we check for equality between each pair. One of the possible ways to do this
//is to compose the equals operator with the "." (apply) operator so it operates on
//a two-element list, then use the ' adverb to apply it on each of the two-element
//lists.
//      .[=]'[2 cut b2]
//  0111110101b
//Again, putting together the three parts of the expression:
//      $[1=count[b2]mod 2;b2;.[=]'[2 cut b2]]
//  0111110101b
//We wrap this in a lambda and iterate it using the / adverb in "converge" sense:
//      c:{[b2]$[1=count[b2]mod 2;b2;.[=]'[2 cut b2]]}/[b2]
//      c
//  01100b
//This is the final result. There is no change in the code between part 1 and 2.