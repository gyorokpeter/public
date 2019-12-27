.z.ph:{
    qry:x[0];
    1 "get ",.Q.s qry;
    cmdpar:"?"vs qry;
    .html.genZPHPP cmdpar};

.z.pp:{
    qry:x[0];
    1 "post ",.Q.s qry;
    cmdpar:" "vs qry;
    .html.genZPHPP cmdpar};

.html.try:.
.html.tryDebug:{[x;y;z].[x;y]}; //.html.try:.html.tryDebug

.html.commandHandlers:()!();

.html.genZPHPP:{[cmdpar]
    cmd:`$first cmdpar;
    par:.html.topar last cmdpar;
    if[not cmd in key .html.commandHandlers; :"wtf"];
    res:.html.try[{(1b;.html.commandHandlers[x][y])};(cmd;par);{(0b;x)}];
    if[not first res; :.h.hy[`htm].h.htc[`pre]["'",last res]];
    last res};

.html.topar:{{(`$x[;0])!.h.uh each ssr[;"+";" "]each x[;1]}"="vs/:"&"vs x};

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

.html.es:{ssr[x;"&";"&amp;"]};
.html.unes:{ssr[;"&amp;";"&"]ssr[;"&apos;";"'"]ssr[x;"&quot;";"\""]};
