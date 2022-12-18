record dirent
    field dataOffset int    //relative to the beginning of the file
    field dataLength int
    field u3 array byte x 12
    field nameOffset int    //relative to the beginning of the "names" field in wd
end

record wd
    field n int
    field dir array record dirent xv n
    field n2 int
    field names array char xv n2
    field data array byte repeat
end
