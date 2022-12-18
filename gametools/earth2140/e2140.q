.e2140.extractWd:{[wdFile;destDir]
    raw:read1 wdFile;
    parsed:.binp.parse[.binp.compileSchema"\n"sv read0 .Q.dd[.e2140.currDir;`wd.sch];raw;`wd];
    fileNames:-1_"\000"vs parsed`names;
    conts:exec (dataOffset,'dataLength) sublist\: raw from parsed`dir;
    .Q.dd[destDir]'[`$fileNames] 1:' conts};

.e2140.extractWdDef:{[wd]
    .e2140.extractWd[.Q.dd[.e2140.rootDir;`$string[wd],".wd"];.Q.dd[.e2140.rootDir;`dataExtracted,wd]]};

.e2140.extractImg:{[fnStem]
    fnDat:`$string[fnStem],".dat";
    fnPal:`$string[fnStem],".pal";
    dat:read1 fnDat;
    pal:read1 fnPal;
    palette:LE each(reverse each 3 cut pal),\:0x00;
    hdr:6#dat;
    img:6_dat;
    mt:LE each 2 cut hdr;
    w:mt 0;
    h:mt 1;
    fnBmp:`$string[fnStem],".bmp";
    fnBmp 1: .img.imgToBmp palette w cut img};
.e2140.extractImgDef:{[img].e2140.extractImg .Q.dd[.e2140.rootDir;`dataExtracted`graph`graph,img]};

.e2140.getSprites:{[mixBase]
    raw:read1`$string[mixBase],".mix";
    parsed:.binp.parse[.binp.compileSchema"\n"sv read0 .Q.dd[.e2140.currDir;`mix.sch];raw;`mix];
    palettes0:$[count parsed`palettes;parsed[`palettes][`palette];()];
    palettes:{LE each (reverse each 3 cut x),\:0x00}each palettes0;
    datas:parsed[`entry] cut parsed`data;
    wh:LE each/:2 cut/:4#/:datas;
    itypes:datas[;4];
    palInd:(`int$datas[;5])-parsed`paletteIndexBase;
    imgs:6_/:datas;
    palettedIdx:where 1=itypes;
    imgs[palettedIdx]:(palettes[palInd]@'imgs)palettedIdx;
    segmentedIdx:where 9=itypes;
    if[count segmentedIdx;
        imgs2:imgs[segmentedIdx];
        hdrs:LE each/:4 cut/:36#/:imgs2;
        sclCounts:hdrs[;3];
        segmentssize:hdrs[;4];
        datas2:36_/:imgs2;
        scl:(LE each/:2 cut/:(2*sclCounts-1)#'datas2)div 2i;
        datas2a:(2*sclCounts)_'datas2;
        sclOffs:LE each/:(2 cut/:(2*sclCounts-1)#'datas2a),\:\:0x0000;
        datas2b:(2*sclCounts)_'datas2a;
        segments:-1_/:2 cut/:segmentssize#'datas2b;
        datas2c:segmentssize _'datas2b;
        imgs2a:scl cut' segments;
        pads:`int$imgs2a[;;;0];
        pixel0s:pads#'''0x00;
        takes:`int$imgs2a[;;;1];
        pixel1s:((sums each/:takes)-'takes[;;0]) cut'' sclOffs cut' datas2c;
        imgs2b:raze each/:pixel0s,'''pixel1s;
        imgs2c:imgs2b,''(wh[;0]-count each/:imgs2b)#''0x00;
        imgs[segmentedIdx]:raze each palettes[palInd segmentedIdx] @'imgs2c;
    ];
    rawIdx:where 2=itypes;
    imgs[rawIdx]:{(8i*x mod 32i)+(1024i*(x div 32i)mod 64i)+524288i*(x div 2048i)}(LE each/:(2 cut/:imgs[rawIdx]),\:\:0x0000);
    imgs2:wh[;0]cut'imgs;
    imgs2};

.e2140.getSpritesDef:{[mix]
    mixBase:`$string[.e2140.rootDir],"/dataExtracted/mix/",string mix;
    .e2140.getSprites mixBase};

.e2140.exportSprites:{[mixBase]
    imgs2:.e2140.getSprites mixBase;
    bmps:.img.imgToBmp each imgs2;
    (`$(string[mixBase],"/"),/:string[til count bmps],\:".bmp")1:'bmps};

.e2140.exportSpritesDef:{[mix]
    mixBase:`$string[.e2140.rootDir],"/dataExtracted/mix/",string mix;
    .e2140.exportSprites mixBase};

.e2140.tiles:.e2140.getSpritesDef each `$"sprt",/:string til 7;

.e2140.loadLevels:{
    levelsRoot:.Q.dd[.e2140.rootDir;`dataExtracted`level`data];
    levelFiles:{x where lower[x] like "*.dat"}key levelsRoot;
    .e2140.levels:levelFiles!{.binp.parse[.binp.compileSchema"\n"sv read0 .Q.dd[.e2140.currDir;`level.sch];read1 x;`level]} each .Q.dd[.e2140.levelsRoot]each levelFiles;
    };

.e2140.renderLevel:{[fn]
    if[not fn in key .e2140.levels; '"unknown level"];
    level:.e2140.levels[fn];
    tiles:level[`height]#flip level[`width]#128 cut level`tiles;
    tileset:.e2140.tiles level[`tileset];
    (`$":d:/temp/",(-3_string[fn]),"bmp") 1: .img.imgToBmp raze each raze flip each tileset tiles};
