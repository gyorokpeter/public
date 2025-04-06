record musDefault
    field data array byte repeat
end

record musHeader
    field magic array byte x 4
    field data array byte repeat
end

record musCount
    field cnt int
end

record musData
    field cnt int
    field curLeft short
    field prevLeft short
    field curRight short
    field prevRight short
    field data array byte repeat
end

record musEnd
end

record tag
    field fourcc array char x 4
    field size recSize int
    field data case fourcc
        "SCHl" musHeader
        "SCCl" musCount
        "SCDl" musData
        "SCEl" musEnd
        default musDefault
    end
end

record mus
    field tags array record tag repeat
end