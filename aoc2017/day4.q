d4p1:{sum{all 1=count each group" "vs x}each"\n"vs x};
d4p1 "aa bb cc dd ee"   //1
d4p1 "aa bb cc dd aa"   //0
d4p1 "aa bb cc dd aaa"  //1

d4p2:{sum{all 1=count each group asc each" "vs x}each"\n"vs x};
d4p2 "abcde fghij"  //1
d4p2 "abcde xyz ecdab"  //0
d4p2 "a ab abc abd abf abj" //1
d4p2 "iiii oiii ooii oooi oooo" //1
d4p2 "oiii ioii iioi iiio"  //0

/
BREAKDOWN:
The first step is to split the input into lines:
q)"\n"vs "aa\nbb\ncc"
"aa"
"bb"
"cc"
The interesting part is done in a lambda that is called on each row.
We split the line into words:
q)x:"aa bb cc dd aa"
q)" "vs x
"aa"
"bb"
"cc"
"dd"
"aa"
Then group them:
q)group" "vs x
"aa"| 0 4
"bb"| ,1
"cc"| ,2
"dd"| ,3
Find which indices appear only once:
q)count each group" "vs x
"aa"| 2
"bb"| 1
"cc"| 1
"dd"| 1
q)1=count each group" "vs x
"aa"| 0
"bb"| 1
"cc"| 1
"dd"| 1
Only return true if all of these values are 1:
q)all 1=count each group" "vs x
0b
The overall result is the sum of the above function called for every row.

Part 2:
The only difference is that after splitting the line into words, we also sort each word.
This means the group function will put anagrams into the same group.
q)" "vs x
"abcde"
"xyz"
"ecdab"
q)asc each" "vs x
`s#"abcde"
`s#"xyz"
`s#"abcde"
q)group asc each" "vs x
`s#"abcde"| 0 2
`s#"xyz"  | ,1
The rest is done the same way as Part 1.
