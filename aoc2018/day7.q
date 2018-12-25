x:read0`:d:/projects/github/public/aoc2018/d7.in;
d7p1:{
    e:flip`s`t!flip x[;5 36];
    done:"";
    ts:asc distinct e[`t],e[`s];
    while[0<count e;
        nxt:min ts except e[`t];
        done,:nxt;
        e:select from e where s<>nxt;
        ts:ts except nxt;
    ];
    done,asc ts};

d7p2:{[x;workers;basetime]
    now:0;
    e:flip`s`t!flip x[;5 36];
    work:([]task:"";timeLeft:`int$());
    ts:update cost:basetime+1+(`int$task)-`int$"A" from ([]task:asc distinct e[`t],e[`s]);
    done:"";
    while[(0<count ts) or 0<count work;
        timePassed:$[0<count work;exec min timeLeft from work;0];
        now+:timePassed;
        work:update timeLeft:timeLeft-timePassed from work;
        done,:exec task from work where 0=timeLeft;
        work:delete from work where 0=timeLeft;
        e:select from e where not s in done;
        while[(count[work]<workers) and 0<count ts;
            nxt:first `task xasc select from ts where not task in e[`t];
            work,:`task`timeLeft!nxt[`task`cost];
            ts:select from ts where task<>nxt`task;
        ];
        work:delete from work where task=" ";
    ];
    now};

/
x:"\n"vs"Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.";
workers:2;
basetime:0;
d7p2[x;2;0]
\

d7p1 x
d7p2[x;5;60]
