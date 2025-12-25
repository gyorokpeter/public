.imm.slotNames:("****";enlist",")0:`$":",.imm.dataPath,"/slotnames.csv";
.imm.legItemPage:{[row]
    r:();
    slotNames:select from .imm.slotNames where slotname~\:row`essSlot;
    slotName:first slotNames;
    r,:enlist"";
    r,:enlist"======PAGE: ",row[`essName],"======";
    r,:enlist"{{DILegItemHeader|",row[`class],"|",slotName[`nameTop],"|",row[`skill],"}}";
    r,:enlist"==Stats==";
    r,:enlist"{{DILegendStat}}";
    r,:enlist"*'''Legendary'''<br/>",row[`essDescr];
    r,:enlist"{{C|Legendary ",row[`class]," ",slotName[`nameBottom]," (Diablo Immortal)}}";
    r};
.imm.procLegendaryItems:{
    skills:exec skill by class from("**";enlist",")0:`$":",.imm.dataPath,"/skills.csv";
    src:read0`$":",.imm.dataPath,"/leg_item_input.txt";
    src:ssr[;"’";"'"]each src except enlist"";
    cls:7 cut src;
    clsname:cls[;0];
    ess:trim 1_/:cls;
    essName:first each/:" ("vs/:/:first each/:": "vs/:/:ess;
    essDescr:last each/:": "vs/:/:ess;
    essSlot:-1_/:/:last each/:" ("vs/:/:first each/:": "vs/:/:ess;
    items:update class:clsname j from ungroup([]j:til count cls;essName;essDescr;essSlot);
    items:update skill:{y first where{x=min x}first each x ss/:y except enlist""}'[essDescr;skills class]from items;
    updInfo:();
    updInfo,:enlist"======UPDATE INFO======";
    updInfo,:{"**'''[[",x[`class],"]]''': ",", "sv "[[",/:x[`essName],\:"]]"}each 0!select essName by class from items;
    updInfo,:raze .imm.legItemPage each items;
    (`$":",.imm.dataPath,"/leg_item_output.txt")0:updInfo;
    };

/
.imm.procLegendaryItems[]