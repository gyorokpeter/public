d21:{t:{`$([]ing:" "vs/:x[;0];al:", "vs/:-1_/:x[;1])}" (contains "vs/:"\n"vs x;
    poss:raze exec ing{`ing`al!(x;y)}/:'al from t;
    poss2:select inter/[ing] by al from poss;
    (t;poss2)};
d21p1:{r:d21 x;t:r 0;poss2:r 1;
    count raze[t`ing] except (exec raze ing from poss2)};
d21p2:{r:d21 x; poss2:r 1;
    ingm:([al:`$()]ing:`$());
    while[0<count poss2;
        ingm,:select al, first each ing from poss2 where 1=count each ing;
        poss2:key[ingm]_poss2;
        poss2:update ing:ing except\:(exec ing from ingm) from poss2;
    ];
    exec ","sv string ing from`al xasc ingm};

/
d21p2 x:"\n"sv("mxmxvkd kfcds sqjhc nhms (contains dairy, fish)"
              ;"trh fvjkl sbzzf mxmxvkd (contains dairy)"
              ;"sqjhc fvjkl (contains soy)"
              ;"sqjhc mxmxvkd sbzzf (contains fish)")

OVERVIEW:

For this day, actually figuring out what is being asked for is probably more difficult than
actually implementing it.

COMMON:
We parse the input into a table with two columns, ing and al (ingredients and allergen).
Both are symbol lists.
q)t:{`$([]ing:" "vs/:x[;0];al:", "vs/:-1_/:x[;1])}" (contains "vs/:"\n"vs x;
q)t
ing                       al
-------------------------------------
`mxmxvkd`kfcds`sqjhc`nhms `dairy`fish
`trh`fvjkl`sbzzf`mxmxvkd  ,`dairy
`sqjhc`fvjkl              ,`soy
`sqjhc`mxmxvkd`sbzzf      ,`fish

We "ungroup" the table on the al column. The built-in "ungroup" function can't do this so it must
be done by explicitly writing out the operation.
q)poss:raze exec ing{`ing`al!(x;y)}/:'al from t;
q)poss
ing                       al
-------------------------------
`mxmxvkd`kfcds`sqjhc`nhms dairy
`mxmxvkd`kfcds`sqjhc`nhms fish
`trh`fvjkl`sbzzf`mxmxvkd  dairy
`sqjhc`fvjkl              soy
`sqjhc`mxmxvkd`sbzzf      fish

Then we find out the intersection of ingredients for each allergen.
q)poss2:select inter/[ing] by al from poss;
q)poss2
al   | ing
-----| --------------
dairy| ,`mxmxvkd
fish | `mxmxvkd`sqjhc
soy  | `sqjhc`fvjkl

PART 1:
We take all the ingredients from the poss2 table and subtract them from the ingredients in the
initial table, then count the result.
q)raze[t`ing] except (exec raze ing from poss2)
`kfcds`nhms`trh`sbzzf`sbzzf
q)count raze[t`ing] except (exec raze ing from poss2)
5

PART 2:
We use an iterative method to figure out which allergen maps to which ingredient. We check which
elements in poss2 have only one element. These can be added to the map, the corresponding lines
removed from poss2 and the known ingredients removed from the other rows as well, which will leave
other allergens unambiguous for the next iteration.
q)ingm
al   | ing
-----| -------
dairy| mxmxvkd
fish | sqjhc
soy  | fvjkl

Once we have all ingredients, we sort by allergen name, then turn the ingredients back to strings
and join them with commas.
q)exec ","sv string ing from`al xasc ingm
"mxmxvkd,sqjhc,fvjkl"
