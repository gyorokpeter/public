d9p1:{
    score:0;
    total:0;
    garbage:0b;
    while[0<count x;
        $[
          "<"=first x;
            garbage:1b;
          "!"=first x;
            x:1_x;
          ">"=first x;
            garbage:0b;
          garbage;
            ::;
          "{"=first x;
            [score+:1;total+:score];
          "}"=first x;
            score-:1;
        ::];
        x:1_x;
    ];
    total};

d9p1"{}"    //1
d9p1"{{{}}}"    //6
d9p1"{{},{}}"   //5
d9p1"{{{},{},{{}}}}"    //16
d9p1"{<a>,<a>,<a>,<a>}" //1
d9p1"{{<ab>},{<ab>},{<ab>},{<ab>}}" //9
d9p1"{{<!!>},{<!!>},{<!!>},{<!!>}}" //9
d9p1"{{<a!>},{<a!>},{<a!>},{<ab>}}" //3

d9p2:{
    total:0;
    garbage:0b;
    while[0<count x;
        $[
          not[garbage] and "<"=first x;
            garbage:1b;
          "!"=first x;
            x:1_x;
          ">"=first x;
            garbage:0b;
          garbage;
            total+:1;
          "{"=first x;
            ::;
          "}"=first x;
            ::;
        ::];
        x:1_x;
    ];
    total};

d9p2"<>"    //0
d9p2"<random characters>"   //17
d9p2"<<<<>" //3
d9p2"<{!>}>"    //2
d9p2"<!!>"  //0
d9p2"<!!!>>"    //0
d9p2"<{o\"i!a,<{i<a>"   //10
