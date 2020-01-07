.z.ph:{
    qry:x[0];
    1 "get ",.Q.s qry;
    cmdpar:"?"vs qry;
    par:.html.topar "?"sv 1_cmdpar;
    .html.genZPHPP[first cmdpar;par]};

.z.pp:{
    qry:x[0];
    cmdp:" "vs qry;
    cmdroot:cmdp 0;
    1 "post ",.Q.s cmdroot;
    cmdpar:" "sv 1_cmdp;
    ct:x[1;`$"Content-Type"];
    par:$[ct like "multipart/form-data*";
        [
            bound:last"boundary="vs ct;
            parts:first(("--",bound,"--\r\n") vs cmdpar);
            parts2:-2_/:(("--",bound,"\r\n") vs parts)except enlist"";
            parts3:{p:"\r\n\r\n"vs x;({first"\""vs@[;1]"name=\""vs first x where x like "*name=*"}"\r\n"vs p[0];p[1])}each parts2;
            (`$parts3[;0])!parts3[;1]
        ];
        .html.topar last "?"sv cmdpar
    ];
    .html.genZPHPP[cmdroot;par]};

.html.try:{-105!(x;y;{[z;e;bt]z e,"\n",.Q.sbt bt}[z])};
.html.tryDebug:{[x;y;z].[x;y]}; //.html.try:.html.tryDebug

.html.commandHandlers:()!();

.html.genZPHPP:{[cmd0;par]
    cmd:`$cmd0;
    if[not cmd in key .html.commandHandlers; :"wtf"];
    res:.html.try[{(1b;.html.commandHandlers[x][y])};(cmd;par);{(0b;x)}];
    if[not first res; :.h.hy[`htm].h.htc[`pre]["'",last res]];
    last res};

.html.topar:{{(`$x[;0])!.h.uh each ssr[;"+";" "]each x[;1]}"="vs/:("&"vs x)except enlist""};

.html.page:{[title;body]
    :.h.hy[`htm;"<!DOCTYPE html>",.h.htc[`html].h.htc[`head;.h.htc[`title;title],
        "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"],
        .h.htc[`body;body]];
    };

.html.table:{[t]
    t:0!t;
    .h.htac[`table;enlist[`border]!enlist enlist"1";
        .h.htc[`tr;raze .h.htc[`th]each string cols t]
        ,raze {.h.htc[`tr;raze .h.htc[`td]each {$[10h=type x;x;.Q.s1 x]}each value x]}each t
    ]};

.html.fastredirect:{.html.page["Redirecting...";.h.htc[`script;"window.location='",x,"'"]]};

.html.es:{ssr/[x;"&<>";("&amp;";"&lt;";"&gt;")]};
.html.unes:{ssr[;"&amp;";"&"]ssr[;"&apos;";"'"]ssr[x;"&quot;";"\""]};
