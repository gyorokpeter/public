x:read0`:d:/projects/github/public/aoc2018/d24.in;

d24parse:{
    split:first where 0=count each x;
    armyraw:(1_split#x;(2+split)_x);
    a:{(`size`hp`damage`dtype`initiative!"JJJSJ"${x[0 4,count[x]-6 5 1]}" "vs x),
        (`weak`immune!`$(();())),
        {` _ (`$x[;0])!`$(2_/:x)except\:\:","}" "vs/:"; "vs first")"vs("("vs x)1}each/:armyraw;
    army:raze ([]faction:`$x[0,1+split]except\:" :"),/:'a;
    army};
d24common:{[boost;army]
    -1"boost=",string boost;
    army:update damage:damage+boost from army where faction=`ImmuneSystem;
    while[1<count exec distinct faction from army;
        prevArmy:army:update j:i from `power`initiative xdesc update power:size*damage from army;
        nxt:0;
        targetSel:([]s:`long$();t:`long$();initiative:`long$());
        while[nxt<count army;
            attackType:army[nxt;`dtype];
            targets:`epower`power`initiative xdesc select initiative,j,power,epower:?[attackType in/:immune;0;?[attackType in/:weak;2;1]]*army[nxt;`power] from army
                where faction<>army[nxt;`faction],not j in exec t from targetSel;
            if[0<count targets;
                if[0<exec first epower from targets;
                    targetSel,:`s`t`initiative!nxt,first[targets][`j],army[nxt;`initiative];
                ];
            ];
            nxt+:1;
        ];
        nxt:0;
        targetSel:`initiative xdesc targetSel;
        while[nxt<count targetSel;
            ts:targetSel[nxt];
            if[(0<army[ts`s;`size]) and 0<army[ts`t;`size];
                attackType:army[ts`s;`dtype];
                epower:army[ts`s;`damage]*army[ts`s;`size]*$[attackType in army[ts`t;`immune];0;$[attackType in army[ts`t;`weak];2;1]];
                army[ts`t;`size]:0|army[ts`t;`size]-epower div army[ts`t;`hp];
            ];
            nxt+:1;
        ];
        army:select from army where size>0;
        if[army~prevArmy; show army;:(0b;0)];
    ];
    show army;
    -1"";
    (`ImmuneSystem=first exec faction from army;exec sum size from army)};
d24p1:{last d24common[0;d24parse x]};
d24p2:{
    army:d24parse x;
    boost:0;
    while[not first res:d24common[boost;army];
        boost+:1;
    ];
    last res};

d24p1 x
d24p2 x
