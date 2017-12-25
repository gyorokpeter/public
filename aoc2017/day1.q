d1p1:{sum 0,"J"$/:x where x=1 rotate x};
d1p1 "1122"   //3
d1p1 "1111"   //4
d1p1 "1234"   //0
d1p1 "91212129"   //9

d1p2:{sum 0,"J"$/:x where x=(count[x]div 2) rotate x};
d1p2 "1212"   //6
d1p2 "1221"   //0
d1p2 "123425" //4
d1p2 "123123" //12
d1p2 "12131415" //4

/
BREAKDOWN:
The trick in both parts is to rotate the list and compare it to the original.
q)x:"93112239"
q)1 rotate x
"31122399"
q)x=1 rotate x
00101001b

The comparison will only be true for numbers that match the next number on the list.
So we filter out to only keep those numbers:
q)x where x=1 rotate x
enlist "9"

Then we parse each character as a number and sum them up.
We need to use the /: adverb with the parse operation as normally it would parse the
whole string as a single number but now we want to parse the individual characters.
q)"J"$/:x where x=1 rotate x
1 2 9j
q)sum"J"$/:x where x=1 rotate x
12j

There is one more catch: if the sum is empty, the list returned by the filtering will
have the wrong type. This can be overcome by prepending a 0 to the list before summing.
q)x:"1234"
q)sum"J"$/:x where x=1 rotate x
()
q)sum 0,"J"$/:x where x=1 rotate x
0j

Part 2 is the same as part 1 except we rotate by half the length of the list, which is
expressed as count[x] div 2.