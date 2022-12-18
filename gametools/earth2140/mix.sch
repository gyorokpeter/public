record palette
    field palette array byte x 768
end

record mix
    field magic array char x 10 //"MIX FILE  "
    field dataSize int
    field entryCount int
    field dataOffset int
    field paletteCount int
    field paletteIndexBase int
    field u5 int
    field magic2 array char x 5 //"ENTRY"
    field entry array int xv entryCount
    field magic3 array char x 5 //" PAL "
    field palettes array record palette xv paletteCount
    field magic4 array char x 5 //"DATA "
    field data array byte repeat
end
