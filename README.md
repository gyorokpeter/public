# public
This repo contains the solutions to Advent of Code in Q.

# What is Q?

Q is a programming language, and it's the best one I currently know, which I will justify below. Q has features that make it very productive, and its weaknesses usually don't get in my way.

The Q interpreter is owned by Kx Systems.

Resources:

* Official documentation: http://code.kx.com/
* Playlist with an overview of Q features by Jeff Borror (author of Q for Mortals): https://www.youtube.com/playlist?list=PLypX5sYuDqvrwBD2EMWadIMiTqJZmVsqm
* If you know Python, check this out (and read it in the opposite direction): https://github.com/BodonFerenc/Python-For-Q-Developers/wiki

## Result: here and now

This is one of the most important advantages of Q, although some languages like JavaScript and Python also have it. My experience is that developing code and productionizing code are two distinct activities, with the latter also including such trivial aspects as making sure that the code makes a coherent function (e.g. no misnaming variables between lines), it can get its input from somewhere, and it's in a file at all. With traditional languages like C++ you have to blend these two activities together in the sense that by the time you are done with the development, you will have spent most of the time on the productionizing even if you won't use the code at all.

In contrast, in Q you can type in expressions to view their value, create and modify global variables, turn some code into a function etc. and not have to wait for a lengthy compilation process. If you want to test your code on different data - just change some variables and run it again. No need to recompile or write an I/O mechanism to get the data to your code. This makes it very easy to test out new ideas quickly.

## Open interface
Besides typing instructions at the console, Q has a simple interface that allows it to receive instructions via its own IPC protocol or HTTP. The default behavior of both of these allows evaluation of arbitrary expressions. Using tools like KDB Studio this makes it even easier to fiddle with code, since the console is one line but tools can provide a method to send multi-line code.

It is also possible to modify the state and the code in a running application, to fix bugs or add new features without having to restart it and lose any state or triggering any adverse effect of the app shutting down.

The IPC and HTTP handler code can be rewritten. I especially like the latter since it makes writing a custom HTTP server piece of cake. It's out-of-the-box, no need to install special packages, just write a function that takes the query/headers and returns the HTTP response. Simple and effective, and there is also a library that makes generating HTML code easier.

## Minimalist syntax
Q keeps syntactic elements to a minimum. Functions are a prime example: the simplest do-nothing function is just {}, no keywords required such as "def" or "function". The parameter list can be omitted if it is empty or implicit - the latter meaning that the variable names "x", "y" and "z" can be used to refer to the parameters. Q also allows saving on syntax by having operators that operate on lists/dictionaries just as they do on atomic values (e.g. the addition operator can do atom+atom, atom+list, list+atom, list+list, dictionary+dictionary etc.). There are much less loops in Q code because they are taken care of by the operators, and where more control is needed, adverbs can be used to modify functions (e.g. apply pairwise to two lists, apply to the left argument paired with each element in the right argument etc.).

## Simple type system
Q has some atomic types, sequential containers (lists) and associative containers (dictionaries). From the data perspective this makes the choice of data type for a particular value very simple. No need to declare record/struct types or think about parameterizing template types. Want to pair up the elements of two lists? You have the result before even thinking about what type it is. This is a huge time saver when you have nested data structures with various types at each level.

There are also tables and keyed tables. But they can simply be interpreted as a list of records and a mapping from records to records respectively, with dictionaries taking the role of records.

## Code is data
In Q "function" is a type just like int or list. A variable can hold a function, a function can take other functions as parameters and invoke them, and it can return a function as well. There are also projections which are just functions with some arguments hardcoded. No time wasted declaring function prototypes.

## Full transparency
If you want to display the value of a variable, you just type its name. No need to provide print operators or implement toString, because Q has all that built-in. It works for all of the built-in types, and there is nice formatting for matrices, dictionaries, tables etc. You won't get the opaque (HASH=@0xff243234) or "[Object Window]" printouts, you can see the object instantly. At the very least you can check the type of the top level and drill down from there using the uniform indexing syntax. Naturally, for functions you get the code of the function as the printout.

No selfish keywords like "private" that hide away the interesting details. If you want to look at how it works, you can (and you can change it as well, if you accept the consequences).

## Small working set / powerful built-in functions
You don't have to spend half of the time looking up the definition of the myriad different functions that do the same thing in a slightly different way. Q has a small but powerful set of built-in operators and standard functions. There are short-named but very high-level functions like "vs", "sv" (split a string on a delimiter and join strings together respectively), "ssr" (string search and replace), "group" (it groups things... very useful once you see it in action), "xasc" (sort a table by column(s), but in C++ terms it would mean sort an array of records using specific field(s) as the sort key, without needing to make a new comparator for every combination of keys). There is also SQL-like "select...from...where" and such, but you don't need a database for that, as mentioned above a table is just a list of records and you can put one together anywhere in your code. A bit like LINQ in C#.

Fewer but more versatile functions means fewer lookups in the reference docs, which translates to more time spent on writing code. However, just reading the Q reference and experimenting with all of those functions and operators is a fun activity in itself.

# Q sadness
There are arbitrary limits on functions, like the number of arguments, local variables, constants, references to global variables and the amount of code in a branch. These can be worked around but this only adds a risk of introducing bugs and making code harder to follow.

No bitwise operators (not, and, or, xor, shl, shr). They can be simulated using the "split to boolean list" operator, calling the logical operators on that, and converting the result back to integer. But this has performance impact.

No hash table and binary tree/heap. Once again these can be simulated but more slowly. There is a way to achieve constant/logarithmic lookup on a list or table that has a specific property, but there is no way to insert into them with the same efficienty.

Poor performance on certain types of tasks, such as generating recursive sequences (especially if modulo arithmetic is involved), or accessing random positions in multi-dimensional lists, which could be relevant for "dynamic programming" solutions where the index depends on the value of an element.

The C plugin API is terrible. Not only are you back to the world of linked data structures, pointer arithmetic and manual memory management, Q throws in its own reference counting system with only partial docs available on when to add or subtract references and when the API functions do so. The useful "duplicate object" function is missing even though copy-on-write works just fine in Q code so the interpreter has functionality to do it. The header is full of one- and two-letter aliases, with all the possible case combinations meaning something different. And yet there is no universal binding to OS functions, you have to use this API to provide wrappers.
