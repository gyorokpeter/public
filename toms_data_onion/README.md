# About
This repo contains a solution to Tom's Data Onion (https://www.tomdalling.com/toms-data-onion/) in Q. It was tested on version 1.1.3 of the puzzle which was current at commit time.
To run the code: ```q onion.q``` with a file named ```onion.txt``` in the current directory containing the puzzle including the <~ ~> marks (NOT the HTML page!).

## Comments

As of 2020 there are still no built-in bitwise operators in q. Therefore I have included the boilerplate and inefficient equivalent implementations of ```bitxor```, ```bitand``` and ```LE``` (only these are actually needed for the puzzles).

The ascii85 decode function takes advantage of the base-N conversion feature of the ```vs``` operator.
We can convert the (unshifted) ascii85 bytes from base 85 to an integer and then from integer to base 256 which will be the ASCII output.
A nasty catch is that there is no way to tell ```vs``` to return (at least/exactly) 4 bytes. So I have to left-pad the number with zeros first.

### Layer 1
Rather than invoking bitxor, we can convert the bytes to bit vectors, flip the bits and use the handy ```rotate``` function to do the entire conversion before converting back to bytes.

### Layer 2
This one was a bit more difficult to understand what it's asking for, but the implementation is simple:
we convert bytes to bit vectors, sum them and filter out those with an odd sum. Then we drop the last bit of each bit vector and
raze them together, and then cut them up to vectors of length 8 before converting back to bytes.
There are some odd bits at the end that don't add up to a full byte so we drop the last element.

The ability to raze bit vectors together to move from 7-bit to 8-bit vectors made this much easier than what the equivalent thing would look like in classic languages.

### Layer 3
The implementation is very uninteresting, it just uses bitxor between the input and the key. The interesting part is finding the key.
This is impossible to automate (at least AI is probably not there yet) so I hardcoded the clue that leads to the key.
When I was solving the puzzle I first noticed that the output must start with ```"==[ Layer 4/6: "``` which reveals a good chunk of the key.
Then there are enough equals signs to pad the header to 60 characters, which allowed more of the key to be figured out in the 2nd repetition.
That way only a few characters were missing, which were easy to figure out just by reading the output text.

### Layer 4
Here we use q's ability to index a list of lists to extract columns to a great extent. This works since the header size is constant.

### Layer 5
Good cybersecurity practice suggests "never code your own crypto", however this time I'm not coding it because I want to crypto, I'm solving a programming puzzle.
And it is a good lesson on how AES works anyway.
Notice the usage of ```iasc``` to generate the inverse S-box. The function normally takes a list and returns the list indices to put it into ascending order.
When the input list is a permutation, the output is the inverse permutation.

### Layer 6
This is a relatively simple VM, there are often harder ones on AoC, although it does feature opcodes that need to be broken down to the bit level which makes it a bit more interesting.
