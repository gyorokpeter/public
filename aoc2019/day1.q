d1a:{0|(x div 3)-2};
d1b:{"J"$"\n"vs x};
d1p1:(')[sum;](')[d1a;d1b];
d1p2:{sum sum 1_d1a\[d1b x]};

/d1p1"51753\n53456\n128133\n118219\n136490\n113318\n134001\n99775\n84746\n68712\n104274\n72530\n101517\n65533\n98719\n100215\n144296\n114166\n62930\n118494\n144800\n97604\n112836\n73074\n62591\n99278\n94544\n73035\n146631\n148331\n144573\n121956\n94088\n60092\n126397\n117285\n122292\n77413\n145860\n76968\n64790\n58479\n94035\n148441\n78999\n74329\n145182\n129497\n106765\n67046\n58702\n123344\n63866\n121123\n126808\n115190\n86467\n136359\n148718\n88225\n126185\n82745\n142546\n149788\n137524\n114690\n68075\n60244\n127157\n123719\n87843\n107714\n51281\n92123\n146495\n50761\n130708\n53103\n75289\n121675\n61726\n70674\n101755\n97736\n100141\n81085\n55493\n73071\n85321\n119965\n147313\n105201\n107107\n130007\n67834\n137614\n140848\n64038\n106078\n71447"

/
BREAKDOWN:
The solution is split into 4 different functions.
d1b is for input parsing. This formula will reappear in most solutions.
vs means vector from string. It can be used to split a string based on a delimiter.
Sometimes we want to apply it at depth. In that case we put as many /: after vs
as the number of levels we want to go down.
The input is assumed to be a single string:
q)x:"51753\n53456\n128133\n118219\n136490\n113318"

First we split the string along the newlines to get a list of strings, one per number:
q)"\n"vs x
"51753"
"53456"
"128133"
"118219"
"136490"
"113318"

Then we apply "J"$ to convert each of them to a number (the type long, to be exact):
q)"J"$"\n"vs x
51753 53456 128133 118219 136490 113318

This is all wrapped up into the function d1b:
q)d1b:{"J"$"\n"vs x};

(This is d1b and not d1a because I got it by refactoring an earlier version of the code.)
d1a does the actual interesting calculation. Let's start with the numbers from above:
q)x:51753 53456 128133 118219 136490 113318

Remember that in q most operations are vector-based. So to divide every number by 3 we can:
q)x div 3
17251 17818 42711 39406 45496 37772

And to subtract 2, remembering that the default order would be right-to-left:
q)(x div 3)-2
17249 17816 42709 39404 45494 37770

Finally there is 0| at the beginning but we will come back to this later.
We wrap this calculation in the function d1a:
d1a:{0|(x div 3)-2};

For part 1, all we need to do is parse the input, do the calculation and sum the result.
One way to write this is to just chain the functions from right to left:
q)x:"51753\n53456\n128133\n118219\n136490\n113318"
q)sum d1a d1b x
200442

There is an alternative way, although it's syntactically not as pretty.
In q the ' operator can be used to compose two functions. However it needs to be in
parentheses otherwise it will mean something different. So to compose d1a and d1b:
q)(')[d1a;d1b]

And to compose sum with this composed function:
q)(')[sum;(')[d1a;d1b]]

Which means the same as:
q)(')[sum;](')[d1a;d1b]

To test the resulting function:
q)d1p1:(')[sum;](')[d1a;d1b];
q)d1p1"51753\n53456\n128133\n118219\n136490\n113318"
200442

Part 2 is still made up of the same primitives but combined in a different way.
Now we want to repeat d1a until the result no longer changes. In other languages
you might use a while loop. In q you have iterators which loop implicitly.
In particular we use \, which has multiple meanings, one of which is
"repeat until no change". The / operator does everything that \ does. The only
difference is that \ returns the intermediate results while / only returns the final result.
So if we use these operators on d1a, it will calculate the next item in the fuel sequence.
We need to be careful to avoid negative weights. This is where the 0| operation in d1a
comes in. It simply means choose the higher number between 0 and the result of the operation
on the right. So if a weight would go below zero, the function will return zero instead.
This means if we keep applying the function, it is guaranteed to reach zero and stay there,
at which point \ finds that there is no change and returns. The result is a list of lists:
q)x:51753 53456 128133 118219 136490 113318
q)d1a\[x]
51753 53456 128133 118219 136490 113318
17249 17816 42709  39404  45494  37770
5747  5936  14234  13132  15162  12588
1913  1976  4742   4375   5052   4194
635   656   1578   1456   1682   1396
209   216   524    483    558    463
67    70    172    159    184    152
20    21    55     51     59     48
4     5     16     15     17     14
0     0     3      3      3      2
0     0     0      0      0      0

However we still have the original weights at the beginning, which are not to be included
in the answer. We can get rid of them by dropping the first element using 1_ .
q)1_d1a\[x]
17249 17816 42709 39404 45494 37770
5747  5936  14234 13132 15162 12588
1913  1976  4742  4375  5052  4194
635   656   1578  1456  1682  1396
209   216   524   483   558   463
67    70    172   159   184   152
20    21    55    51    59    48
4     5     16    15    17    14
0     0     3     3     3     2
0     0     0     0     0     0

Now we need to sum all these numbers. A single sum operation will add together the lists,
so the result is a list with each element corresponding to the sum of a column:
q)sum 1_d1a\[x]
25844 26696 64033 59078 68211 56627

But we can sum this list again:
q)sum sum 1_d1a\[x]
300489

In the full part 2 solution, we need to start by parsing the string using d1b.
q)x:"51753\n53456\n128133\n118219\n136490\n113318"
q)sum sum 1_d1a\[d1b x]
300489
