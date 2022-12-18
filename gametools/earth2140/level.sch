record unit //size=12
    field index byte
    field player byte
    field typ byte
    field u1 byte
    field x short
    field y short
    field flags short
    field u2 byte
    field disabled byte
end

record building //size=10
    field index byte
    field player byte
    field typ short
    field x short
    field y short
    field flags short
end

record lvobj    //size=10
    field index short
    field typ short
    field x short
    field y short
    field sprite short
end

record player   //size=2388
    field index byte
    field u1 array byte x 1212
    field u2 int
    field u3 int
    field mask int
    field enemies int
    field u4 array byte x 3
    field faction int
    field u5 array byte x 36
    field money int
    field u6 int
    field u7 int
    field u8 array byte x 1104
end

record level
    field title array char x 31
    field mask array short x 16384              //0x0000001f
    field tiles array byte x 16384              //0x0000801f
    field u1 array byte x 12                    //0x0000c01f
    field units array record unit x 256         //0x0000c02b
    field u2 array byte x 3070                  //0x0000cc2b
    field buildings array record building x 256 //0x0000d829
    field lvobjs array record lvobj x 256       //0x0000e229
    field u3 array byte x 2558                  //0x0000ec29
    field width int                             //0x0000f627
    field height int                            //0x0000f62b
    field u4 array byte x 36                    //0x0000f62f
    field tileset int                           //0x0000f653
    field players array record player x 6       //0x0000f657
    field u5 array byte x 19547                 //0x00012e4f
end
