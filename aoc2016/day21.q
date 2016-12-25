d21p1:{[pw;x]ins:"\n"vs x;
    {[pw;x]
        p:" "vs x;
        $[p[0]~"swap";
            $[p[1]~"position";
                [p1:"J"$p[2];p2:"J"$p[5];t:pw[p1];pw[p1]:pw[p2];pw[p2]:t];
              p[1]~"letter";  
                [p1:pw?p[2;0];p2:pw?p[5;0];t:pw[p1];pw[p1]:pw[p2];pw[p2]:t];
              'p[0]," ",p[1]," unknown"
            ];
          p[0]~"reverse";
            [p1:"J"$p 2;p2:"J"$p 4;pw:(p1#pw),reverse[p1 _(p2+1)#pw],(p2+1)_pw];
          p[0]~"move";
            [p1:"J"$p 2;p2:"J"$p 5;l:pw p1;pw:(p1#pw),(p1+1)_pw;pw:(p2#pw),l,p2 _pw];
          p[0]~"rotate";
            $[p[1]~"left";
                pw:("J"$p[2]) rotate pw;
              p[1]~"right";
                pw:(neg"J"$p[2]) rotate pw;
              p[1]~"based";
                [p1:pw?p[6;0];pw:(neg 1+p1+p1>=4)rotate pw];
              'p[0]," ",p[1]," unknown"
            ];
          'p[0]," unknown"
        ];
        pw}/[pw;ins]};
d21p2:{[pw;x]ins:"\n"vs x;
    {[pw;x]
        p:" "vs x;
        $[p[0]~"swap";
            $[p[1]~"position";
                [p1:"J"$p[2];p2:"J"$p[5];t:pw[p1];pw[p1]:pw[p2];pw[p2]:t];
              p[1]~"letter";  
                [p1:pw?p[2;0];p2:pw?p[5;0];t:pw[p1];pw[p1]:pw[p2];pw[p2]:t];
              'p[0]," ",p[1]," unknown"
            ];
          p[0]~"reverse";
            [p1:"J"$p 2;p2:"J"$p 4;pw:(p1#pw),reverse[p1 _(p2+1)#pw],(p2+1)_pw];
          p[0]~"move";
            [p2:"J"$p 2;p1:"J"$p 5;l:pw p1;pw:(p1#pw),(p1+1)_pw;pw:(p2#pw),l,p2 _pw];
          p[0]~"rotate";
            $[p[1]~"left";
                pw:(neg"J"$p[2]) rotate pw;
              p[1]~"right";
                pw:("J"$p[2]) rotate pw;
              p[1]~"based";
                [p1:pw?p[6;0];op:{t:til[x];t!(1+(2*t)+t>=4)mod x}[count pw]?p1;pw:(1+op+op>=4)rotate pw];
              'p[0]," ",p[1]," unknown"
            ];
          'p[0]," unknown"
        ];
        pw}/[pw;reverse ins]};
d21p1["abcde";"swap position 4 with position 0\nswap letter d with letter b\nreverse positions 0 through 4\nrotate left 1 step\nmove position 1 to position 4\nmove position 3 to position 0\nrotate based on position of letter b\nrotate based on position of letter d"]
d21p2["decab";"swap position 4 with position 0\nswap letter d with letter b\nreverse positions 0 through 4\nrotate left 1 step\nmove position 1 to position 4\nmove position 3 to position 0\nrotate based on position of letter b\nrotate based on position of letter d"]
