d17p1:{
    bpv:{[step;bpv]
        pos:bpv[1]:(bpv[1]+step) mod count buf:bpv[0];
        bpv[0]:((pos+1)#buf),bpv[2],(pos+1) _buf;
        bpv[1]:pos+1;
        bpv[2]+:1;
        bpv}[x]/[2017;(enlist 0;0;1)];
    bpv[0;(bpv[1]+1)mod count bpv[0]]};

d17p1 3 //638

d17p2:{
    bpv:{[step;bpv]
        pos:bpv[1]:(bpv[1]+step) mod bpv[2];
        if[pos=0;bpv[0]:bpv[2]];
        bpv[1]:pos+1;
        bpv[2]+:1;
        bpv}[x]/[50000000;(0N;0;1)];
    bpv[0]};

d17p2 370   //11162912
