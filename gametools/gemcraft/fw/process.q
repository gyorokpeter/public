zlibPath:`$":",.gcfw.qutilsPath,"zlibk";
zlibUncompress:zlibPath 2:(`k_zlib_uncompress;1);

.gcfw.prepare:{
    //generate the decoded level data from the JSON that was generated according to README.md
    //this only needs to be called once (or whenever levels.json is updated)
    proc:{
        tbl:(uj/){$[x~enlist"-";enlist enlist[`missing]!enlist 1b;enlist .j.k `char$zlibUncompress `byte$base64decode x]}each x;
        tbl:update epicCreatures:count[i]#enlist() from tbl where 0n~/:epicCreatures;
        tbl};

    levels:.j.k first read0`$":",.gcfw.dataPath,"/levels.json";
    levels[`stageDatasJ`stageDatasE`stageDatasT]:proc each levels[`stageDatasJ`stageDatasE`stageDatasT];
    (`$":",.gcfw.dataPath,"/levelsProc.json") 0:enlist .j.j levels;

    levelsIron:.j.k first read0`$":",.gcfw.dataPath,"/levelsIron.json";
    levelsIron[`stageDatasJ]:proc levelsIron[`stageDatasJ];
    (`$":",.gcfw.dataPath,"/levelsProcIron.json") 0:enlist .j.j levelsIron;
    };

.gcfw.load:{
    //load the decoded level data
    //this needs to be called before using the functions further down
    .gcfw.levels:.j.k first read0`$":",.gcfw.dataPath,"/levelsProc.json";
    .gcfw.levelsIron:.j.k first read0`$":",.gcfw.dataPath,"/levelsProcIron.json";

    .gcfw.stageMetas:update orbDrops:("+"vs/:orbDrops)except\:enlist"", "+"vs/:stashDrops from .gcfw.levels[`stageMetas];
    .gcfw.stageMetasIron:update orbDrops:("+"vs/:orbDrops)except\:enlist"", "+"vs/:stashDrops from .gcfw.levelsIron[`stageMetas];
    .gcfw.orbUnlocks:raze{([]target:x[`orbDrops];source:count[x`orbDrops]#enlist x`strId)}each select strId,{3_/:x where x like "FLD*"}each orbDrops from .gcfw.stageMetas;
    .gcfw.orbUnlocksIron:raze{([]target:x[`orbDrops];source:count[x`orbDrops]#enlist x`strId)}each select strId,{3_/:x where x like "FLD*"}each orbDrops from .gcfw.stageMetasIron;
    .gcfw.stashJ:{``Journey any x like "WIZSTASH*"}each .gcfw.levels[`stageDatasJ;;`buildings];
    .gcfw.stashE:{``Endurance any x like "WIZSTASH*"}each .gcfw.levels[`stageDatasE;;`buildings];
    .gcfw.stashT:{``Trial any x like "WIZSTASH*"}each .gcfw.levels[`stageDatasT;;`buildings];
    .gcfw.stashUnlocks:((raze{([]target:x[`stashDrops];source:count[x`stashDrops]#enlist x`strId)}each
        select strId,{3_/:x where x like "FLD*"}each stashDrops from .gcfw.stageMetas)
        lj 1!select source:strId, unlockMode:.gcfw.stashJ^.gcfw.stashE^.gcfw.stashT from .gcfw.stageMetas);
    .gcfw.stashUnlocksIron:`target xcols raze
        {$[0<count x`stashDrops;([]ironSource:enlist x`strId;target:enlist 3_first value x`stashDrops;ironUnlockStash:first key x`stashDrops);()]}each
        select strId, {(where x like "FLD*")#x}each`Iron`Brass`Bronze!/:stashDrops from .gcfw.stageMetasIron;

    .gcfw.priv.extractGiveGt:{givegt:x where x like "GIVEGT*";$[0<count givegt;6+"J"$1_","vs first givegt;0#0j]};
    .gcfw.priv.extractGiveSpells:{givegt:x where x like "SPELLS,*";$[0<count givegt;"J"$1_","vs first givegt;0#0j]};
    .gcfw.spellAvailability:1!(select strId from .gcfw.stageMetas)
        ,'([]spellsJ:.gcfw.priv.extractGiveGt each .gcfw.levels[`stageDatasJ;`initScript])
        ,'([]spellsT:.gcfw.priv.extractGiveSpells each .gcfw.levels[`stageDatasT;`initScript]);
    .gcfw.spellAvailabilityIron:1!(select strId from .gcfw.stageMetasIron)
        ,'([]spellsJ:.gcfw.priv.extractGiveGt each .gcfw.levelsIron[`stageDatasJ;`initScript]);

    .gcfw.layouts:1!(select strId from .gcfw.stageMetas)
        ,'(select layoutJ:layout from .gcfw.levels[`stageDatasJ])
        ,'(select layoutE:layout from .gcfw.levels[`stageDatasE])
        ,'(select layoutT:layout from .gcfw.levels[`stageDatasT])
        ,'(select layoutI:layout from .gcfw.levelsIron[`stageDatasJ]);

    .gcfw.monsterDataJ:1!(select strId from .gcfw.stageMetas),'(::)each .gcfw.levels[`stageDatasJ;;`monsterData];
    .gcfw.monsterDataE:1!(select strId from .gcfw.stageMetas),'(::)each .gcfw.levels[`stageDatasE;;`monsterData];
    .gcfw.monsterDataT:1!(select strId from .gcfw.stageMetas),'(enlist[`manaOnKillMult]!enlist 1f),/:`monsterEntryRndSeed _/:.gcfw.levels[`stageDatasT;;`monsterData];
    .gcfw.monsterDataI:1!(select strId from .gcfw.stageMetas),'{asc[key x]#x}each(enlist[`manaOnKillMult]!enlist 1f),/:.gcfw.levelsIron[`stageDatasJ;;`monsterData];
    };

//constants

.gcfw.priv.spellLinks:("[[File:GcFwFreeze.png|Freeze|29px|link=Freeze]]";
    "[[File:GcFwWhiteout.png|Whiteout|29px|link=Whiteout]]";
    "[[File:GcFwIceShards.png|Ice Shards|29px|link=Ice Shards]]";
    "[[File:GcFwBolt.png|Bolt|29px|link=Bolt]]";
    "[[File:GcFwBeam.png|Beam|29px|link=Beam]]";
    "[[File:GcFwBarrage.png|Barrage|29px|Barrage]]");

.gcfw.priv.gemNames:("Critical Hit";"Mana Leech";"Bleeding";"Armor Tearing";"Poison";"Slowing");

.gcfw.priv.gemLinks:("[[File:Yellow(GCFW).png|Yellow - Critical Hit|29px|link=Critical Hit]]";
    "[[File:Orange(GCFW).png|Yellow - Mana Leech|29px|link=Mana Leech]]";
    "[[File:Red(GCFW).png|Red - Bleeding|29px|link=Bleeding]]";
    "[[File:Purple(GCFW).png|Purple - Armor Tearing|29px|link=Armor Tearing]]";
    "[[File:Green(GCFW).png|Green - Poison|29px|link=Poison]]";
    "[[File:Blue(GCFW).png|Blue - Slowing|29px|link=Slowing]]");

.gcfw.priv.buildingLinks:("[[File:GcFwWallIcon.png|Wall|29px|link=Wall]]";
    "[[File:GcFwTowerIcon.png|Tower|29px|link=Tower]]";
    "[[File:GcFwAmplifierIcon.png|Amplifier|29px|link=Amplifier]]";
    "[[File:GcFwTrapIcon.png|Trap|29px|link=Trap]]";
    "[[File:GcFwLanternIcon.png|Lantern|29px|link=Lantern]]";
    "[[File:GcFwPylonIcon.png|Pylon|29px|link=Pylon]]");

.gcfw.trialSkillPoints:.Q.A!count[.Q.A]#3;
.gcfw.trialSkillPoints["ABCDEHI"]:9;
.gcfw.trialSkillPoints["FGJKLM"]:7;
.gcfw.trialSkillPoints["NOPUXYZ"]:5;

.gcfw.treeShapes:""!();
.gcfw.treeShapes["a"]:( " * ";
                        "***";
                        " * ");
.gcfw.treeShapes["b"]:( "***";
                        "***";
                        "***");
.gcfw.treeShapes["c"]:( "  *  ";
                        " *** ";
                        "*****";
                        " *** ";
                        "  *  ");
.gcfw.treeShapes["d"]:( " *** ";
                        "*****";
                        "*****";
                        "*****";
                        " *** ");
.gcfw.treeShapes["e"]:( "  ***  ";
                        " ***** ";
                        "*******";
                        "*******";
                        "*******";
                        " ***** ";
                        "  ***  ");
.gcfw.treeShapes["f"]:( "  *****  ";
                        " ******* ";
                        "*********";
                        "*********";
                        "*********";
                        "*********";
                        "*********";
                        " ******* ";
                        "  *****  ");
.gcfw.treeShapes["g"]:.gcfw.treeShapes["a"];
.gcfw.treeShapes["h"]:.gcfw.treeShapes["b"];
.gcfw.treeShapes["i"]:.gcfw.treeShapes["c"];
.gcfw.treeShapes["j"]:.gcfw.treeShapes["d"];
.gcfw.treeShapes["k"]:.gcfw.treeShapes["e"];
.gcfw.treeShapes["l"]:.gcfw.treeShapes["f"];
.gcfw.treeShapes["m"]:.gcfw.treeShapes["a"];
.gcfw.treeShapes["n"]:.gcfw.treeShapes["b"];
.gcfw.treeShapes["o"]:.gcfw.treeShapes["c"];
.gcfw.treeShapes["p"]:.gcfw.treeShapes["d"];
.gcfw.treeShapes["q"]:.gcfw.treeShapes["e"];
.gcfw.treeShapes["r"]:.gcfw.treeShapes["f"];
.gcfw.treeShapes["s"]:.gcfw.treeShapes["a"];
.gcfw.treeShapes["t"]:.gcfw.treeShapes["b"];
.gcfw.treeShapes["u"]:.gcfw.treeShapes["c"];
.gcfw.treeShapes["v"]:.gcfw.treeShapes["d"];
.gcfw.treeShapes["w"]:.gcfw.treeShapes["e"];
.gcfw.treeShapes["x"]:.gcfw.treeShapes["f"];

.gcfw.objectInfo:([objtype:`$()]code:();sizes:();offsets:());
.gcfw.objectInfo[`AMP]:`code`sizes!(enlist"A";enlist 2 2);
.gcfw.objectInfo[`NEST]:`code`sizes!(enlist"N";enlist 5 5);
.gcfw.objectInfo[`ORB]:`code`sizes!(enlist"O";enlist 2 2);
.gcfw.objectInfo[`BEACON]:`code`sizes!(enlist"C";enlist 2 2);
.gcfw.objectInfo[`GEMSEAL]:`code`sizes!(enlist"G";enlist 2 2);
.gcfw.objectInfo[`TOWNHOUSE]:`code`sizes!(enlist"D";8#(4 3;3 4));
.gcfw.objectInfo[`DWELLING]:`code`sizes!(enlist"D";24#(3 2;2 3));
.gcfw.objectInfo[`DH]:`code`sizes!(enlist"H";(1 1;2 1;1 2;2 1;1 2;1 1;1 1;1 1;1 1;2 1;1 2;2 1;1 2;2 1;1 2;1 1;2 1;1 2;2 1;1 2;1 1;2 1;1 2;1 1;2 1;1 2;1 1;2 1;1 2;2 1;1 2));
.gcfw.objectInfo[`SLEEPINGHIVE]:`code`sizes!(enlist"I";enlist 4 4);
.gcfw.objectInfo[`WIZSTASH]:`code`sizes!(enlist"W";enlist 3 2);
.gcfw.objectInfo[`TOWER]:`code`sizes!(enlist"T";enlist 2 2);
.gcfw.objectInfo[`SPF_TOWER]:`code`sizes!(enlist"S";enlist 2 2);
.gcfw.objectInfo[`SHRINE]:`code`sizes!(enlist"U";enlist 3 3);
.gcfw.objectInfo[`LANTERN]:`code`sizes!(enlist"L";enlist 2 2);
.gcfw.objectInfo[`ALLOYSTASH]:`code`sizes!(".:;";enlist 2 2);
.gcfw.objectInfo[`MANASHARD]:`code`sizes!(enlist"M";(2 2;3 3;5 5));
.gcfw.objectInfo[`BARRICADE]:`code`sizes!(enlist"B";enlist 2 2);
.gcfw.objectInfo[`PYLON]:`code`sizes!(enlist"P";enlist 2 2);
.gcfw.objectInfo[`TRAP]:`code`sizes!(enlist"R";enlist 2 2);
.gcfw.objectInfo[`OLDWALL]:`code`sizes!(enlist"Z";enlist 1 1);
.gcfw.objectInfo[`WALL]:`code`sizes!(enlist"Z";enlist 1 1);
.gcfw.objectInfo[`SHRUB]:`code`sizes!(enlist"Z";enlist 1 1);
.gcfw.objectInfo[`BROKEN_ORB_BASE]:`code`sizes!(enlist"E";enlist 2 2);
.gcfw.objectInfo[`WIZTOWER]:`code`sizes!(enlist"Q";enlist 7 7);
.gcfw.objectInfo[`JAROFWASPS]:`code`sizes!(enlist"J";enlist 2 2);
.gcfw.objectInfo[`WARMTHSPELL]:`code`sizes!(enlist"F";enlist 2 2);
.gcfw.objectInfo[`SNOWYPIT]:`code`sizes`offsets!(enlist"K";enlist 10 10;enlist -4 -4);
.gcfw.objectInfo[`MONSTEREGG]:`code`sizes!(enlist"V";enlist 1 1);
.gcfw.objectInfo[`TOMB]:`code`sizes!(enlist"Y";enlist 4 4);
.gcfw.objectInfo[`WIZLOCK]:`code`sizes!(enlist"a";(3 1;1 3));
.gcfw.objectInfo[`WATCHTOWER]:`code`sizes!(enlist"b";enlist 3 3);
.gcfw.objectInfo[`POSSESSIONOBELISK]:`code`sizes!(enlist"c";enlist 3 3);

.gcfw.waveHpMultIron:.Q.A!26#0.9;
.gcfw.waveHpMultIron["WSV"]%:0.9;
.gcfw.waveHpMultIron["QRSTUVWXYZ"]*:1.4;
.gcfw.waveHpMultIron["JKMNO"]*:3.4;
.gcfw.waveHpMultIron["GLP"]*:4f;
.gcfw.waveHpMultIron["ABCDEFHI"]*:6.4;
.gcfw.waveHpMultIron["U"]*:0.88%0.9;
.gcfw.waveHpMultIron["XZ"]*:0.87%0.9;
.gcfw.waveHpMultIron["NO"]*:0.73%0.9;
.gcfw.waveHpMultIron["LMP"]*:0.65%0.9;
.gcfw.waveHpMultIron["K"]*:0.5%0.9;
.gcfw.waveHpMultIron["ABCDEFGHIJ"]*:0.45%0.9;

.gcfw.waveNumAddIron:.Q.A!26#12;
.gcfw.waveNumAddIron["QRSTUVWXYZ"]:3;
.gcfw.waveNumAddIron["JKMNO"]:7;
.gcfw.waveNumAddIron["GLP"]:9;

.gcfw.hpIncrementIron:.Q.A!26#1.08;
.gcfw.hpIncrementIron["QRSTUVWXYZ"]:1.075;
.gcfw.hpIncrementIron["JKMNO"]:1.077;
.gcfw.hpIncrementIron["GLP"]:1.079;
.gcfw.hpIncrementIron["A"]:1.088;

.gcfw.armorIncrementIron:.Q.A!26#1.065;
.gcfw.armorIncrementIron["QRSTUVWXYZ"]:1.05;
.gcfw.armorIncrementIron["JKMNO"]:1.052;
.gcfw.armorIncrementIron["GLP"]:1.06;
.gcfw.armorIncrementIron["A"]:1.075;

.gcfw.traits:("Adaptive Carapace";"Dark Masonry";"Swarmling Domination";
    "Overcrowd";"Corrupted Banishment";"Awakening";"Insulation";"Hatred";
    "Swarmling Parasites";"Haste";"Thick Air";"Vital Link";"Giant Domination";
    "Strength in Numbers";"Ritual");

.gcfw.skills:("Mana Stream";"True Colors";"Fusion";"Orb of Presence";"Resonance";"Demolition";
    "Critical Hit";"Mana Leech";"Bleeding";"Armor Tearing";"Poison";"Slowing";
    "Freeze";"Whiteout";"Ice Shards";"Bolt";"Beam";"Barrage";
    "Fury";"Amplifiers";"Pylons";"Lanterns";"Traps";"Seeker Sense");

//helper functions
.gcfw.addTree:{[layoutR;tt;tl]
    //tt:treeType[0]; tl:treeLoc[0]
    shape:.gcfw.treeShapes[tt];
    tl[0]-:count[shape] div 2;
    tl[1]-:count[first shape] div 2;
    layoutR[tl[0]+til count shape;tl[1]+til count first shape]^:shape;
    layoutR};

.gcfw.addObject:{[layout;object]
    p:","vs object;
    objtype:`$first p;
    if[not objtype in key .gcfw.objectInfo; {'x}"unknown objtype: ",.Q.s1 object];
    i:"J"$p 2;
    j:"J"$p 1;
    k:"J"$p 3;
    oi:.gcfw.objectInfo[objtype];
    ind:$[1<count oi`sizes; k;0];
    if[objtype=`WIZLOCK; ind:"J"$p 4];
    size:oi[`sizes][ind];
    width:size 0;
    height:size 1;
    codes:oi`code;
    if[0<count oi`offsets;
        offset:oi[`offsets][ind];
        i+:offset 0;
        j+:offset 1;
    ];
    code:$[1=count codes; first codes; codes[k]];
    layout[i+til height;j+til width]:code;
    layout};

.gcfw.convertLayout:{[layout;objects]
    layout:ssr/[;("€";"%";"$");"Z"] each layout;
    pad:4;
    padS:pad#" ";
    row:count[first layout]#" ";
    layout1:padS,/:((pad#enlist row),layout,pad#enlist row),\:padS;
    layoutR:""layout1;
    treeLoc:raze(til count layout1),/:'where each layout1 in key .gcfw.treeShapes;
    treeType:layout1 ./:treeLoc;
    layoutR:.gcfw.addTree/[layoutR;treeType;treeLoc];
    layout1:.[;;:;" "]/[layout1;treeLoc];
    pathChars:"#ABCDEFGIJHKLMNOPQSTUVY";
    layoutR^:?'[(layout1="Z");"Z";" "];
    layout1:?'[(layout1="Z");" ";layout1];
    layoutR^:?'[(layout1="=");"+";" "];
    layout1:?'[(layout1="=");" ";layout1];
    layoutR^:?'[(layout1="@");"@";" "];
    layout1:?'[(layout1="@");" ";layout1];
    layoutR^:`char$32+3*layout1 in\:pathChars;
    layout1:?'[(layout1 in\:pathChars);" ";layout1];
    unknown:distinct raze[layout1]except" ";
    if[0<count unknown; '"unknown character in layout: ",unknown];
    layoutR:pad _/:neg[pad]_/:pad _neg[pad]_layoutR;
    layoutR:.gcfw.addObject/[layoutR;objects];
    layoutR};

.gcfw.resolveDrop:{[iron;x]
    $[x like "SPT*";(3_x)," skill points";
      x like "SHC*";(3_x)," shadow cores";
      x like "JPG*";"Journey page ",3_x;
      x like "MTL*";"Map tile ",.Q.A[25-"J"$3_x];
      x like "SKT*";"'''[[",.gcfw.skills["J"$(3_x)],"]]''' skill";
      x like "TRS*";"'''[[Battle Traits (GCFW)#",.gcfw.traits["J"$(3_x)],"|",.gcfw.traits["J"$(3_x)],"]]''' battle trait";
      x like "FLD*";"[[Field ",(3_x)," (GCFW)",$[iron;"#Iron Wizard mode";""],"|Field ",(3_x),"]]";
      x like "TAL*";[d:"J"$"/"vs 3_x;"Rarity ",string[d 1]," ",("edge";"corner";"inner")[d 2]," [[Talisman (GCFW)|talisman]] fragment"];
      '"unknown drop type ",x]};

.gcfw.resolveEpic:{[epic]
    p:","vs epic;
    pt:p 0;
    wave:"J"$p 1;
    res:$[not null wave;"Wave ",string[wave],": ";""];
    res,$[pt~"FCORRUPTSHARDS";
        "[[The Forgotten]]'s mana shard corruption";
      pt~"FWAVEBUFF";
        "[[The Forgotten]]'s wave buff";
      pt~"APPARITION";
        "[[Apparition]]";
      pt~"GUARDIAN";
        "[[Guardian]]";
      pt~"SPECTER";
        "[[Specter]]";
      pt~"SPIRE";
        "[[Spire]]";
      pt~"SHADOW";
        "[[Shadow]]";
      pt~"SHADOWFLYTHROUGH";
        "Shadow flying through";
      pt~"WRAITH";
        "[[Wraith]]";
      pt~"WALLBREAKER";
        "[[Wallbreaker]]";
      pt~"SWARMQUEEN";
        "[[Swarm Queen]]";
      pt~"WIZARDHUNTER";
        "[[Wizard Hunter]]";
      pt~"GATEKEEPER";
        "[[Gatekeeper]]";
      pt~"SPFDOWN";
        "[[Spiritforge]] shield destroyed";
      pt~"DISABLERANDOMEVENTS";
        "Random special entities are disabled";
    '"unknown epic type: ",epic]};

.gcfw.processInitOne:{[res;instr]
    p:","vs instr;
    pt:first p;
    $[pt~"GIVEGT";[
        gems:"J"$1_p;
        res[`tableAddenda],:
            "\n|-\n! Initial gem types\n|",$[count gems;raze .gcfw.priv.gemLinks gems;"None"];
        ];
      pt~"SPELLS";[
        spells:"J"$1_p;
        trialGems:(spells-6)inter til 6;
        res2:"";
        res2,:"\n|-\n! Available gem types\n|",raze[$[count trialGems;.gcfw.priv.gemLinks trialGems;"None"]];
        trialSpells:(spells)inter til 6;
        res2,:"\n|-\n! Available spells\n|",raze[$[count trialSpells;.gcfw.priv.spellLinks trialSpells;"None"]];
        trialBuildings:(spells-12)inter til 6;
        res2,:"\n|-\n! Available buildings\n|",raze[$[count trialBuildings;.gcfw.priv.buildingLinks trialBuildings;"None"]];
        res[`tableAddenda],:res2;
        ];
      pt~"MANA";
        res[`tableAddenda],:"\n|-\n! Starting mana\n|",p 1;
      pt~"TRAITS";[
        traits:"J"$"/"vs/:1_p;
        res[`tableAddenda],:"\n|-\n! Traits set\n|","<br>"sv{t:.gcfw.traits[x 0];"[[Battle Traits (GCFW)#",t,"|",t,"]] level ",string[x 1]}each traits;
        ];
      pt~"MANAMULTREPL";
        res[`tableAddenda],:"\n|-\n! Mana replenish multiplier\n|",p 1;
      pt~"CREGEM";
        res[`startingGems],:enlist p 1;
      pt~"PUTGEM";
        res[`startingGems],:enlist p 3;
      pt~"ORBLETS";
        res[`tableAddenda],:"\n|-\n! [[Orblet]]s\n|",p 1;
      '"unknown init instruction: ",instr
    ];
    res};

.gcfw.processInit:{[init]
    .gcfw.processInitOne/[`tableAddenda`startingGems!("";());init]};

.gcfw.processStartingGemsOne:{[gem]
    "+"sv{"g",string[1+"J"$x[0]]," ",.gcfw.priv.gemNames"J"$x 1}each 2 cut gem};

.gcfw.processStartingGems:{[gems]
    "<br>"sv .gcfw.processStartingGemsOne each gems};

//the main function for generating the wiki page for a field
.gcfw.genWikiPage:{[strId0]
    ind:.gcfw.stageMetas[`strId]?strId0;
    res:"'''Field ",strId0,"''' is a field in [[GemCraft Lost Chapter: Frostborn Wrath]].";
    if[strId0 like "W1";res,:" It is the first field that is automatically entered when starting a new game."];
    res,:"\n\n==Standard modes==\n";
    res,:"<div style=\"overflow:hidden\">\n";
    unlock:select from .gcfw.orbUnlocks where target~\:strId0;
    if[0<count unlock;
        res,:"Field ",strId0," can be unlocked by beating field ",raze[{"[[Field ",x," (GCFW)|",x,"]]"}each exec source from unlock],".";
    ];
    unlock2s:select from .gcfw.stashUnlocks where target~\:strId0;
    if[0<count unlock2s;
        if[1<count unlock2s; '"ambiguous unlock"];
        unlock2:first unlock2s;
        res,:"Field ",strId0," can be unlocked on field ",{"[[Field ",x," (GCFW)|",x,"]]"}[unlock2`source]
            ," by opening the [[Wizard Stash]] in ",string[unlock2`unlockMode]," mode.";
    ];
 
    initJ:.gcfw.processInit .gcfw.levels[`stageDatasJ;ind;`initScript];
    initE:.gcfw.processInit .gcfw.levels[`stageDatasE;ind;`initScript];
    initT:.gcfw.processInit .gcfw.levels[`stageDatasT;ind;`initScript];

    res,:"\n{| class=\"wikitable\" style=\"float:right; margin:0 0 0.5em 1em;\"";
    spells:.gcfw.spellAvailability[strId0];
    monsterDataJ:.gcfw.monsterDataJ[strId0];
    monsterDataE:.gcfw.monsterDataE[strId0];
    monsterDataT:.gcfw.monsterDataT[strId0];
    journeyBld:.gcfw.levels[`stageDatasJ;ind;`buildings];
    stashMode:$[any journeyBld like "WIZSTASH*";`journey;`endurance];
    res,:"\n|-\n! colspan=2 | Journey mode";
    res,:initJ[`tableAddenda];
    if[0<count initJ[`startingGems];res,:"\n|-\n! Starting gems\n|",.gcfw.processStartingGems initJ[`startingGems]];
    res,:"\n|-\n! Waves\n|",string monsterDataJ`wavesNum;
    res,:"\n|-\n! First wave HP\n|",string monsterDataJ`hpFirstWave;
    res,:"\n|-\n! HP increment\n|",string monsterDataJ`hpMult;
    res,:"\n|-\n! Armor increment\n|",string monsterDataJ`armorIncrement;
    orbDrops:.gcfw.stageMetas[ind;`orbDrops];
    res,:"\n|-\n! Reward\n|",$[count orbDrops;"<br>"sv .gcfw.resolveDrop[0b] each orbDrops;"None"];
    if[stashMode=`journey;
        res,:"\n|-\n! Stash reward\n|","<br>"sv .gcfw.resolveDrop[0b] each .gcfw.stageMetas[ind;`stashDrops];
    ];
    res,:"\n|-\n! colspan=2 | Endurance mode";
    res,:initE[`tableAddenda];
    if[0<count initE[`startingGems];res,:"\n|-\n! Starting gems\n|",.gcfw.processStartingGems initE[`startingGems]];
    res,:"\n|-\n! Armor increment\n|",string monsterDataE`armorIncrement;
    if[stashMode=`endurance;
        res,:"\n|-\n! Stash reward\n|","<br>"sv .gcfw.resolveDrop[0b] each .gcfw.stageMetas[ind;`stashDrops];
    ];
    res,:"\n|-\n! colspan=2 | Trial mode";
    res,:initT[`tableAddenda];
    if[0<count initT[`startingGems];res,:"\n|-\n! Starting gems\n|",.gcfw.processStartingGems initT[`startingGems]];
    res,:"\n|-\n! Waves\n|",string monsterDataT`wavesNum;
    res,:"\n|-\n! First wave HP\n|",string monsterDataT`hpFirstWave;
    res,:"\n|-\n! HP increment\n|",string monsterDataT`hpMult;
    res,:"\n|-\n! Armor increment\n|",string monsterDataT`armorIncrement;
    if[1<>monsterDataT`manaOnKillMult;
        res,:"\n|-\n! Mana on kill multiplier\n|",string monsterDataT`manaOnKillMult;
    ];
    res,:"\n|-\n! Reward\n|",string[.gcfw.trialSkillPoints first strId0]," skill points";
    res,:"\n|}\n";
    layouts:.gcfw.layouts[strId0];
    
    res,:"</div>\n";
    res,:"===Layout===\n";
    res,:"<div style=\"overflow:hidden\">\n";
    res,:"<tabber>\n";
    res,:"Journey mode=";
    res,:"{{GcFwDiagram|\n";
    res,:raze[.gcfw.convertLayout[layouts`layoutJ;journeyBld],\:"\n"];
    res,:"}}\n";
    res,:"|-|\n";
    res,:"Endurance mode=";
    res,:"{{GcFwDiagram|\n";
    res,:raze[.gcfw.convertLayout[layouts`layoutE;.gcfw.levels[`stageDatasE;ind;`buildings]],\:"\n"];
    res,:"}}\n";
    res,:"|-|\n";
    res,:"Trial mode=";
    res,:"{{GcFwDiagram|\n";
    res,:raze[.gcfw.convertLayout[layouts`layoutT;.gcfw.levels[`stageDatasT;ind;`buildings]],\:"\n"];
    res,:"}}\n";
    res,:"</tabber>\n";
    res,:"</div>\n";
    epicJ:.gcfw.levels[`stageDatasJ;ind;`epicCreatures] except enlist"";
    epicE:.gcfw.levels[`stageDatasE;ind;`epicCreatures] except enlist"";
    epicT:.gcfw.levels[`stageDatasT;ind;`epicCreatures] except enlist"";
    epicres:"";
    if[0<count epicJ;
        epicres,:"====Journey mode====\n";
        epicres,:raze("* ",/:.gcfw.resolveEpic each epicJ except enlist""),\:"\n";
    ];
    if[0<count epicE;
        epicres,:"====Endurance mode====\n";
        epicres,:raze("* ",/:.gcfw.resolveEpic each epicE except enlist""),\:"\n";
    ];
    if[0<count epicT;
        epicres,:"====Trial mode====\n";
        epicres,:raze("* ",/:.gcfw.resolveEpic each epicT except enlist""),\:"\n";
    ];
    if[0<count epicres;
        res,:"===Special===\n";
        res,:epicres;
    ];

    res,:"\n==Iron Wizard mode==\n";
    res,:"<div style=\"overflow:hidden\">\n";
    initI:.gcfw.processInit .gcfw.levelsIron[`stageDatasJ;ind;`initScript];
    unlock:select from .gcfw.orbUnlocksIron where target~\:strId0;
    if[0<count unlock;
        res,:"Field ",strId0," can be unlocked by beating field ",raze[{"[[Field ",x," (GCFW)#Iron Wizard mode|",x,"]]"}each exec source from unlock],".";
    ];
    unlock2s:select from .gcfw.stashUnlocksIron where target~\:strId0;
    if[0<count unlock2s;
        if[1<count unlock2s; '"ambiguous unlock"];
        unlock2:first unlock2s;
        res,:"Field ",strId0," can be unlocked on field ",{"[[Field ",x," (GCFW)#Iron Wizard mode|",x,"]]"}[unlock2`ironSource]
            ," by opening the ",string[unlock2`ironUnlockStash]," Stash.";
    ];
    if[(0=sum count each (unlock;unlock2s)) and not strId0 like "W1";
        res,:"This field exists in the game data but is not unlockable in Iron Wizard mode.";
    ];
    res,:"\n{| class=\"wikitable\" style=\"float:right; margin:0 0 0.5em 1em;\"";
    res,:"\n|-\n! colspan=2 | Iron Wizard mode";
    spells:.gcfw.spellAvailabilityIron[strId0];
    initI:.gcfw.processInit .gcfw.levelsIron[`stageDatasJ;ind;`initScript];
    monsterDataI:.gcfw.monsterDataI[strId0];
    res,:initI[`tableAddenda];
    if[0<count initI[`startingGems];res,:"\n|-\n! Starting gems\n|",.gcfw.processStartingGems initI[`startingGems]];
    res,:"\n|-\n! Waves\n|",string .gcfw.waveNumAddIron[first strId0]+monsterDataI`wavesNum;
    res,:"\n|-\n! First wave HP\n|",string floor .gcfw.waveHpMultIron[first strId0]*monsterDataI`hpFirstWave;
    res,:"\n|-\n! HP increment\n|",string .gcfw.hpIncrementIron first strId0;
    res,:"\n|-\n! Armor increment\n|",string .gcfw.armorIncrementIron first strId0;
    orbDrops:.gcfw.stageMetasIron[ind;`orbDrops];
    res,:"\n|-\n! Reward\n|",$[count orbDrops;"<br>"sv .gcfw.resolveDrop[1b] each orbDrops;"None"];
    res,:"\n|-\n! Stash rewards\n|","<br>"sv ("'''Iron:''' ";"'''Brass:''' ";"'''Bronze:''' "),'.gcfw.resolveDrop[1b] each .gcfw.stageMetasIron[ind;`stashDrops];
    res,:"\n|}\n";
    res,:"</div>\n";
    res,:"===Layout===\n";
    res,:"<div style=\"overflow:hidden\">\n";
    res,:"{{GcFwDiagram|\n";
    res,:raze[.gcfw.convertLayout[layouts`layoutI;.gcfw.levelsIron[`stageDatasJ;ind;`buildings]],\:"\n"];
    res,:"}}\n";
    res,:"</div>\n";
    epicI:.gcfw.levelsIron[`stageDatasJ;ind;`epicCreatures];
    epicres:"";
    if[0<count epicJ;
        epicres,:raze("* ",/:.gcfw.resolveEpic each epicI except enlist""),\:"\n";
    ];
    if[0<count epicres;
        res,:"===Special===\n";
        res,:epicres;
    ];
    res};
.gcfw.saveWikiPage:{-1 x;t:.gcfw.genWikiPage[x];(`$":",.gcfw.dataPath,"/fieldWikis/",x,".txt")0:enlist t;t};
.gcfw.saveWikiPageAll:{.gcfw.saveWikiPage each exec strId from .gcfw.stageMetas};
//.gcfw.saveWikiPage"A5"
//.gcfw.saveWikiPageAll[]

//strId0:"A5";
//ind:.gcfw.stageMetas[`strId]?strId0;
//layout:.gcfw.layouts[strId0;`layoutJ]
//.gcfw.levels[`stageDatasJ;ind;`buildings]
//.gcfw.levelsIron[`stageDatasJ;ind;`buildings]
//.gcfw.levels[`stageDatasJ;ind;`initScript]
