.finos.dep.include"config.q";
.finos.dep.loadModule"qbinparse";
.finos.dep.loadScriptIn["qbinparse";"qbinparse.q"];
.finos.dep.loadScriptIn["qutils";"html.q"];
.h.ty[`wav]:"application/wav";

.nfs3.outdir:.finos.dep.resolvePath"data";
.nfs3.schemadir:.finos.dep.resolvePath"schema";

.nfs3.eaTable:0x00 sv/:(
  0x00000000;
  0x000000F0;
  0x000001CC;
  0x00000188;
  0x00000000;
  0x00000000;
  0xFFFFFF30;
  0xFFFFFF24;
  0x00000000;
  0x00000001;
  0x00000003;
  0x00000004;
  0x00000007;
  0x00000008;
  0x0000000A;
  0x0000000B;
  0x00000000;
  0xFFFFFFFF;
  0xFFFFFFFD;
  0xFFFFFFFC);
.nfs3.intTrunc:{r:0x00 sv 4_0x00 vs x;$[null r;-2147483648;r]};
.nfs3.shifts:(2*)\[31;1];

.nfs3.convertBlock:{[compression;audio]
    if[0=compression;
        outs:flip 2 cut LE each 2 cut audio`data;
        :((audio[`curLeft`curRight],outs 0);(audio[`prevLeft`prevRight],outs 1));
    ];
    if[7<>compression;'"unsupported compression"];
    curLeft:audio`curLeft;
    prevLeft:audio`prevLeft;
    curRight:audio`curRight;
    prevRight:audio`prevRight;
    outSize:audio`cnt;
    adata:audio`data;
    outL:outR:();
    i:0;
    samples:0;
    blockSize:0x1c;
    while[samples<outSize;
        a:adata[i]; i+:1;
        coeffCurleft:.nfs3.eaTable[a div 16];
        coeffPrevleft:.nfs3.eaTable[4+a div 16];
        coeffCurRight:.nfs3.eaTable[a mod 16];
        coeffPrevRight:.nfs3.eaTable[4+a mod 16];
        a:adata[i]; i+:1;
        dleft:8+a div 16i;
        dright:8+a mod 16i;
        limit:min (samples+blockSize;outSize);
        while[samples<limit;
            a:adata[i]; i+:1;
            left:a div 16;
            right:a mod 16;
            left:(.nfs3.intTrunc left*.nfs3.shifts 0x1c)div shifts dleft;
            right:(.nfs3.intTrunc right*.nfs3.shifts 0x1c)div shifts dright;
            left:32767i&-32768i|(left+(curLeft*coeffCurleft)+(prevLeft*coeffPrevleft)+0x80)div 256;
            right:32767i&-32768i|(right+(curRight*coeffCurRight)+(prevRight*coeffPrevRight)+0x80)div 256;
            prevLeft:curLeft;
            curLeft:left;
            prevRight:curRight;
            curRight:right;
            outL,:`short$left;
            outR,:`short$right;
            samples+:1;
        ];
    ];
    (outL;outR)};

.nfs3.convertSection:{[sect]
    header:sect[0;`data];
    if[not 0x50540000~header`magic;{'x}"header magic number mismatch"];
    header3:header`data;
    if[not 0x000102060165fd~7#header3;{'x}"unknown header pattern"];
    headerOut:(`$())!`int$();
    i:7;
    while[i<count header3;
        curr:header3 i;
        $[curr=0x85;
            [cnt:header3[i+1];headerOut[`numSamples]:256 sv header3[i+2+til cnt];i+:cnt+2];
          curr=0x82;
            [cnt:header3[i+1];headerOut[`channels]:256 sv header3[i+2+til cnt];i+:cnt+2];
          curr=0x83;
            [cnt:header3[i+1];headerOut[`compression]:256 sv header3[i+2+til cnt];i+:cnt+2];
          curr=0x8a;
            [cnt:header3[i+1];headerOut[`unknown8a]:256 sv header3[i+2+til cnt];i+:cnt+2];
          curr=0xff;
            i+:5;
          {'x}"unknown field in header"
        ];
    ];
    audios:(::)each(sect where sect[;`fourcc]~\:"SCDl")[;`data];
    //audio:audios 0
    r:raze each flip .nfs3.convertBlock[0^headerOut`compression]each audios;
    r};

.nfs3.wavs:enlist[`]!enlist(::);

.nfs3.convertMusic:{[track]
    /track:`atlatech
    /track:`show1
    src:`$":",.nfs3.srcDir,"/",string[track],".mus";
    data:.binp.parse[.binp.compileSchema`$":",.nfs3.schemadir,"/mus.sch";read1 src;`mus][`tags];
    if[not"SCHl"~data[0;`fourcc];{'x}"header not first in file?!"];
    sects:(where data[;`fourcc]~\:"SCHl")cut data;
    /sect:sects 0
    wavs:.nfs3.mkWav2 ./:.nfs3.convertSection each sects;
    .nfs3.wavs[track]:`char$wavs;
    (`$":",.nfs3.outdir,"/",string[track])set wavs};

.nfs3.loadWavs:{[track]
    wavs:get`$":",.nfs3.outdir,"/",string[track];
    .nfs3.wavs[track]:`char$wavs;
    };

.nfs3.maps:enlist[`]!enlist(::);
.nfs3.triggers:enlist[`]!enlist(::);

.nfs3.loadMap:{[track;mode]
    /track:`losttech
    /mode:`lin;
    /mode:`map;
    src:`$":",.nfs3.srcDir,"/",string[track],".",string[mode];
    /blocks:get`$":",.nfs3.outdir,"/",string track;
    data:.binp.parse[.binp.compileSchema`$":",.nfs3.schemadir,"/map.sch";read1 src;`lin];
    succ:exec`int$numRecords#'sections from data`records;
    .nfs3.maps[track]:succ;
    triggersRaw:`int$data[`triggers;`data];
    triggers:triggersRaw;
    if[1<count triggers;
        triggers:flip {x where 1<count each distinct each x}flip triggers;
        triggers:triggers where 1<count each distinct each triggers;
    ];
    queue:([]power:0 50 100)cross([]seq:`int$enlist each til count succ);
    loops:();
    while[count queue;
        nxts:update isLoop:nextSection in'seq from raze{x,/:y}'[queue;succ exec last each seq from queue];
        nxts:select from nxts where power within' (powerMin,'powerMax);
        newLoops:select from nxts where isLoop;
        if[count newLoops;
            newLoops:update cp:seq?'nextSection from newLoops;
            newLoops:update seq:cp _'seq,prefix:cp#'seq from newLoops;
            newLoops:update (seq?'min each seq)rotate'seq from newLoops;
            loops:loops,select power,seq,prefix from newLoops;
        ];
        queue:select power, seq:(seq,'nextSection) from nxts where not isLoop;
    ];
    loops:0!select prefixes:distinct prefix by power,seq from loops;
    loopMembers:exec raze seq from loops;
    orphan:`int$til[count succ]except loopMembers;
    loops:update prefixes:distinct each prefixes@'where each(first each/:prefixes)in\:orphan from loops;
    prefixLength:exec max c by s from {([]s:first each x;c:count each x)}exec raze prefixes from loops;
    loops:update prefixes@'where each (count each/:prefixes)=prefixLength first each/:prefixes from loops;
    notIntros:raze{where 1<count each group raze x}each exec prefixes from loops;
    loops:update prefixMembers:{asc distinct raze x}each prefixes from loops;
    loops:update prefixes:prefixes@'where each not(first each/:prefixes)in\:notIntros from loops;

    lgrp:first each exec s by t from ungroup update s:i from ([]t:distinct each flip triggers);
    loopOut:`grp`power xasc delete prefixMembers from update asc each prefixes, grp:first each (lgrp[seq],'lgrp prefixMembers)except\:0N from loops;
    orphan:`int$til[count succ]except exec (raze[seq],raze[prefixMembers]) from loops;
    .nfs3.triggers[track]:`start`triggersRaw`triggers`loops`orphans!`int$(data`firstSection;triggersRaw;triggers;loopOut;orphan);
    };

.nfs3.process:{[track]
    -1"processing: ",string track;
    $[track in key `$":",.nfs3.outdir;.nfs3.loadWavs track;.nfs3.convertMusic track];
    .nfs3.loadMap[track;`map];
    };

.nfs3.mkWav:{[data]
    rec:enlist[`]!enlist(::);
    rec[`id1]:"RIFF";
    rec[`size]:count[data]+36;
    rec[`id2]:"WAVE";
    rec[`id3]:"fmt ";
    rec[`size2]:16i;
    rec[`format]:1h;
    rec[`channels]:2h;
    rec[`frequency]:22050i;
    rec[`bytePerSec]:88200i;
    rec[`bytePerBloc]:4h;
    rec[`bitsPerSample]:16h;
    rec[`id4]:"data";
    rec[`size3]:count data;
    rec[`data]:data;
    .binp.unparse[.binp.compileSchema`$":",.nfs3.schemadir,"/wav.sch";rec;`wav]};
.nfs3.mkWav2:{[left;right].nfs3.mkWav raze unLE each raze (`short$left),'(`short$right)};

.nfs3.home:{
    .html.page["NFS3 Music Player"]
        raze{.h.ha["/song?track=",string x;string x],"<br>"}each key .nfs3.maps
    };

.nfs3.song:{[par]
    if[not`track in key par;'"missing track"];
    track:`$par`track;
    if[not track in key .nfs3.wavs; '"track missing from wavs"];
    if[not track in key .nfs3.maps; '"track missing from maps"];
    sx:string[count .nfs3.wavs track];
    .html.page["NFS3 Music Player"]
        .h.htac[`script;enlist[`type]!enlist"text/javascript";"\n"
            ,"map=",.j.j[.nfs3.maps[track]],";\n"
            ,"aCtx=null;function ac(){if(aCtx)return;aCtx=new AudioContext()};ac();\n"
            ,"ei=document.getElementById.bind(document);"
            ,"curr=0;currEnd=0;playing=false;"
            ,"async function lda(i){var resp=await fetch('/section?track=",string[track],"&id='+i);return await aCtx.decodeAudioData(await resp.arrayBuffer())}"
            ,"function bgcol(i,c){for(item of document.getElementsByClassName('block'+i))item.style.background=c}"
            ,"function findNext(i){p=ei('power').value;for(r of map[i]){if(p>=r.powerMin && p<=r.powerMax)return r.nextSection}}"
            ,"blocks=new Array(",sx,");for(i=0;i<",sx,";++i){lda(i).then((j => b => blocks[j]=b)(i))}"
            /,"function play(i){ei('aud'+i).play();ei('btn'+i).style.background='red'}"
            ,"function play(i){buf=blocks[i];"
            ,"    if(!buf){console.error('no buf for block '+i);stop();return}"
            ,"    playing=true;curr=i;src=aCtx.createBufferSource();"
            ,"    src.buffer=buf;src.connect(aCtx.destination);\n"
            ,"    now=aCtx.currentTime;prevEnd=currEnd;dur=buf.duration;if(currEnd>now){currEnd+=dur}else{currEnd=now+dur};\n"
            ,"    next=findNext(i);to=setTimeout(playNext,1000*(currEnd-now)-200,i);src.start(prevEnd);bgcol(i,'red')}\n"
            ,"function playNext(){bgcol(curr,null);play(next)}"
            ,"function start(i){next=i;bgcol(i,'yellow');if(!playing)play(next)}"
            ,"function startP(i,p){ei('power').value=p;start(i)}"
            ,"function stop(){if(playing){src.stop(0);clearTimeout(to);playing=false;bgcol(curr,null);ac()}}"
        ],"\n"
        ,raze[{sx:string x;
            .h.hta[`input;`id`type`class`value`onclick!("btn",sx;"button";"block",sx;sx;"start(",sx,")")]
                /,.h.htac[`audio;`id`src`onended!("aud",sx;"/section?track=atlatech&id=",sx;"end(",sx,")");""]
                }each til count .nfs3.wavs track]
                ,"<br>"
                ,.h.hta[`input;`type`value`onclick!("button";"start";"start(",string[.nfs3.triggers[track;`start]],")")]
                ,.h.hta[`input;`type`value`onclick!("button";"stop";"stop()")],"<br>"
                ,"Power: ",.h.hta[`input;`id`type`value`min`max`onchange!("power";"range";enlist"0";enlist"0";"100";"next=findNext(curr)")],"<br>"
                ,"Loops<br>"
                ,raze[{s:string[first x`seq];.h.hta[`input;`type`value`onclick!("button";s;"startP(",s,",",string[x`power],")")]
                    ,"(",string[x`power],") ",(" "sv {.h.htac[`span;enlist[`class]!enlist"block",x;x]}each string x`seq)
                    ,(" "sv {[p;s].h.hta[`input;`type`value`onclick!("button";first s;"startP(",first[s],",",string[p],")")]
                        ,(" "sv {.h.htac[`span;enlist[`class]!enlist"block",x;x]}each s)}[x`power]each string x`prefixes)
                    ,"<br>"}each .nfs3.triggers[track;`loops]]
                ,"Orphans<br>"
                ,raze[{s:string x;.h.hta[`input;`type`value`onclick!("button";s;"start(",s,")")],"<br>"}each .nfs3.triggers[track;`orphans]]
                /,.h.htc[`table;raze{raze .h.htc[`tr]{.h.htc[`td].h.hta[`input;`type`value`onclick!("button";x;"start(",x,")")]} each string x}each .nfs3.triggers[track;`triggers]]
    };

.nfs3.section:{[par]
    if[not`track in key par;'"missing track"];
    if[not`id in key par;'"missing id"];
    track:`$par`track;
    id:"J"$par`id;
    if[not track in key .nfs3.wavs; '"invalid track"];
    if[not id within 0,-1+count .nfs3.wavs[track]; '"invalid id"];
    .h.hy[`wav;.nfs3.wavs[track;id]]};

.html.commandHandlers[`]:`.nfs3.home;
.html.commandHandlers[`song]:`.nfs3.song;
.html.commandHandlers[`section]:`.nfs3.section;

.nfs3.process each`hometech`homerock`losttech`lostrock`atlatech`atlarock`alpitech`alpirock`emprtech`emprrock;
.nfs3.process each`$"show",/:string 1+til 7;
