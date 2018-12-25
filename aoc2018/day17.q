x:read0`:d:/projects/github/public/aoc2018/d17.in;

d17common:{
    grid0:{
        a:"J"$first","vs@[;1]"="vs y;b:"J"$".."vs last"="vs y; 
        $[y[0]="x";
            x[b[0]+til 1+b[1]-b[0];a]:"#";
            x[a;b[0]+til 1+b[1]-b[0]]:"#"
        ];
    x}/[2000 2000#".";x];
    grid:grid0;
    xmin:min where 0<sum grid="#";
    xmax:max where 0<sum grid="#";
    ymin:min where 0<sum each grid="#";
    ymax:max where 0<sum each grid="#";
    stack:enlist 0 500;
    while[0<count stack;
        curr:last stack;
        if[ymax>=curr[0];
            $[curr[0]=ymax;
                [grid[curr 0;curr 1]:"|"; stack:-1_stack];
              "."=grid . curr+1 0;
                [bottomEnd:curr 0;
                    while[(bottomEnd<ymax) and grid[bottomEnd+1;curr 1]=".";bottomEnd+:1];
                    stack,:((curr[0]+1)+til bottomEnd-curr 0),\:curr 1;
                ];
              ((grid . curr+1 0) in "#~") and all"#"=grid ./:curr+/:(0 1;0 -1);
                [grid[curr 0;curr 1]:"~";stack:-1_stack];
              ((grid . curr+1 0) in "#~") and any any(grid ./:curr+/:(0 1;0 -1))in/:".|";
                [
                    leftEnd:curr[1];while[(grid[curr 0;leftEnd-1] in".|")and grid[1+curr 0;leftEnd]in"#~";leftEnd-:1];
                    rightEnd:curr[1];while[(grid[curr 0;rightEnd+1] in".|")and grid[1+curr 0;rightEnd]in"#~";rightEnd+:1];
                    $[all"|"=grid ./:((curr 0;leftEnd);(curr 0;rightEnd));
                        stack:-1_stack;
                      all"#"=grid ./:((curr 0;leftEnd-1);(curr 0;rightEnd+1));
                        grid[curr 0;leftEnd+til 1+rightEnd-leftEnd]:"~";
                      [grid[curr 0;leftEnd+til 1+rightEnd-leftEnd]:"|";
                        if[grid[1+curr 0;leftEnd]="."; stack,:enlist(1+curr 0;leftEnd)];
                        if[grid[1+curr 0;rightEnd]="."; stack,:enlist(1+curr 0;rightEnd)];
                      ]
                     ];
                ];
              [if["."=grid . curr;grid[curr 0;curr 1]:$[curr[0]>=ymin;"|";"+"]]; stack:-1_stack]
            ];
        ];
        //show count stack;
        //.[0:;(`:d:/projects/github/public/aoc2018/grid.txt;enlist[.Q.s1 stack],(xmin-1)_/:(2+xmax)#/:(2+ymax)#grid);{show x}];
    ];
    grid};
d17p1:{sum sum sum d17common[x]=/:"~|"};
d17p2:{sum sum d17common[x]="~"};

d17p1 x
d17p2 x
