d6p1:{{first key desc count each group x}each flip "\n"vs x}
d6p2:{{first key asc count each group x}each flip "\n"vs x}
d6p1"eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar"
d6p2"eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar"

//BREAKDOWN
//We start by breaking the input into lines:
//      "\n"vs x
//  ("eedadn";"drvtee";"eandsr";"raavrd";"atevrs";"tsrnev";"sdttsa";"rasrtv";"nssdts";
//  "ntnada";"svetve";"tesnvt";"vntsnd";"vrdear";"dvrsen";"enarar")
//We want to check frequency by column, not by row, so we flip the list:
//      flip "\n"vs x
//  ("ederatsrnnstvvde";"eraatsdastvenrvn";"dvnaertssnestdra";"atdvvntrdatnsesr";
//  "desrresttdvvnaea";"nerdsvavsaetdrnr")
//We count the frequency using the "group" operator just like in day 3:
//      count each group "ederatsrnnstvvde"
//  e| 3
//  d| 2
//  r| 2
//  a| 1
//  t| 2
//  s| 2
//  n| 2
//  v| 2
//Part 1: we sort the frequencies in desending order.
//Part 2: we sort the frequencies in ascending order.
//      desc count each group "ederatsrnnstvvde"
//  e| 3
//  d| 2
//  r| 2
//  t| 2
//  s| 2
//  n| 2
//  v| 2
//  a| 1
//We take the first character after sorting - the characters are the keys so we use "key"
//to get the key list from which we get the first element.
//      first key desc count each group "ederatsrnnstvvde"
//  "e"
//This sequence of finding the most frequent character can be wrapped in a lambda and
//applied to each element of the flipped list:
//      {first key desc count each group x}each flip "\n"vs x
//  "easter"
//Similarly for Part 2:
//      {first key asc count each group x}each flip "\n"vs x
//  "advent"
