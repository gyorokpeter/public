.imm.reloadGems:{.imm.gems:1!update reso:?[1<count each reso;`$"|"vs/:reso;count[i]#enlist`$()] from("SJ*J*BS*";enlist",")0:`$":",.imm.dataPath,"/gems.csv"};
.imm.reloadGems[];

.imm.resoStars:1 2 5!(1 1;1 2 2;2 2 2 5 5);
.imm.resoRanks:1 2 5!(4 8;4 6 8;4 5 6 7 8);

{
    t:select from .imm.gems where 0<count each reso;
    bad:select from (select id,bad:reso except\:(exec id from .imm.gems)from t)where 0<count each bad;
    if[count bad;row:first bad;'string[row`id]," has unknown resonance gems: ",", "sv string row`bad];
    t:update tmp:.imm.gems[([]id:reso)][;`star] from t;
    t:update tmp2:.imm.resoStars star from t;
    if[count bad:select from t where not tmp~'tmp2;
        row:first 0!bad;
        'string[row`id]," has reso in the wrong star order: reso=",.Q.s1[row`reso]," act stars=",.Q.s1[row`tmp]," ex stars=",.Q.s1[row`tmp2];
    ];
    }[]

.imm.resoSetBonus:([star:`long$();setBonus:`$()]text:());
.imm.resoSetBonus[(1;`att);`text]:"*10: Primary Attack damage increased by 3%\n*20: Skill damage increased by 2%";
.imm.resoSetBonus[(1;`def);`text]:"*10: Damage taken while moving decreased by 3%\n*20: Damage taken while suffering loss of control decreased by 4%";
.imm.resoSetBonus[(1;`mock);`text]:"*10: Damage taken while suffering loss of control decreased by 4%\n*20: Damage done to enemies suffering loss of control increased by 5%";
.imm.resoSetBonus[(2;`att);`text]:"*10: Primary Attack damage increased by 3%\n*30: Skill damage increased by 2%\n*50: Damage done increased by 1% per party member";
.imm.resoSetBonus[(2;`def);`text]:"*10: Damage taken while moving decreased by 3%\n*30: Damage taken while suffering loss of control decreased by 4%"
    ,"\n*50: Block Chance increased by 2%";
.imm.resoSetBonus[(5;`att);`text]:"*20: Primary Attack damage increased by 3%\n*40: Skill damage increased by 2%\n*60: Damage done increased by 1% per party member"
    ,"\n*160: Damage to full Life enemies increased by 5%\n*260: Damage increased 4% to enemies below 30% Life";

.imm.or:{[opts]
    if[1=count opts;:first opts];
    "??? (",(", "sv -1_opts)," or ",last[opts],")"};

.imm.gemLink:{[name;titleSuffix]
    name,$[0=count titleSuffix;"";titleSuffix,"|",name]};

.imm.genWikiForGem:{[gem]
    details:.imm.gems gem;
    resoUp:"";
    if[count details`reso;
        resoUp,:"'''",details[`name],"''' requires the following Legendary Gems to activate Resonance set bonuses after [[Awakening]]:\n";
        resoDetails:.imm.gems([]id:details`reso);
        resoDetails2:update resoRank:string .imm.resoRanks[details`star] from resoDetails;
        if[not details`orderKnown;
            t:update tmp:count[i]#enlist .imm.resoStars[details`star] from resoDetails2;
            t:update tmp:.imm.resoRanks[details`star]where each star=tmp from t;
            resoDetails2:delete tmp from update resoRank:.imm.or each string tmp from t;
        ];
        resoUp,:raze exec ("*[[",/:.imm.gemLink'[name;titleSuffix],'"]] (",/:string[star],'"-star, unlocks at Rank ",/:resoRank,\:")\n") from resoDetails2;
        sb:.imm.resoSetBonus[details`star`setBonus;`text];
        if[count sb;resoUp,:"The following Resonance set bonuses can be activated after reaching the needed Resonance from the above gems:\n",sb,"\n"];
    ];
    resoDown:"";
    resoReqs:select from .imm.gems where gem in/:reso;
    if[count resoReqs;
        resoDown,:"The following Legendary Gems require '''",details[`name],"''' to activate Resonance set bonuses after Awakening:\n";
        resoReqs2:update resoRankSort:?[orderKnown;.imm.resoRanks[star]@'reso?\:gem;0W] from resoReqs;
        resoReqs2:update resoRankKnown:string[.imm.resoRanks[star]@'reso?\:gem] from resoReqs2;
        resoReqs2:update resoRankUnknown:.imm.or each string .imm.resoRanks[star]@'where each details[`star]=.imm.resoStars star from resoReqs2;
        resoReqs2:`star`resoRankSort xasc resoReqs2;
        resoDown,:raze exec ("*[[",/:.imm.gemLink'[name;titleSuffix],'"]] (",/:string[star],'"-star, at Rank ",/:?[orderKnown;resoRankKnown;resoRankUnknown],\:")\n") from resoReqs2;
    ];
    r:$[count resoUp;enlist resoUp;()];
    r,:$[count resoDown;enlist resoDown;()];
    result:"==Awakening==\n","\n"sv r;
    result};

.imm.saveGemPage:{[gem]
    if[not gem in key .imm.gems;'"unknown gem: ",string gem];
    page:.imm.genWikiForGem gem;
    out:`$":",.imm.dataPath,"/gems/",string[.imm.gems[gem;`ord]],"-",string[gem],".txt";
    if[-11h=type key out;
        oldPage:"\n"sv read0 out;
        if[oldPage~page; :(::)];
    ];
    out 0:"\n"vs page;
    out};

.imm.saveGemPages:{
    ids:exec id from .imm.gems;
    {(where not null x)#x}ids!.imm.saveGemPage each ids};

//gem:`los
//.imm.saveGemPage`night
//.imm.genWikiForGem`los
//.imm.reloadGems[];.imm.saveGemPages[]