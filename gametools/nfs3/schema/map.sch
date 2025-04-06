record linSection
    field powerMin byte
    field powerMax byte
    field nextSection byte
end

record linRow
    field index byte
    field numRecords byte
    field id array byte x 2
    field sections array record linSection x 8
end

record offset
    field offset be int
end

record triggerRec
    field data array byte x 16
end

record lin
    field fourcc array char x 4
    field u1 byte
    field firstSection byte
    field numSections byte
    field recordSize byte
    field u2 array byte x 3
    field numRecords byte
    field records array record linRow xv numSections
    field triggers array record triggerRec xv numRecords
    field offsets array record offset xv numSections
end