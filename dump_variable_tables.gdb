define dump-tables
    dont-repeat
    dump-basic-variable-table
    dump-basic-array-table
end

define dump-basic-variable-table
    dont-repeat
    set $start = *(unsigned short*)0x1B
    set $end = *(unsigned short*)0x1D
    set $ptr = $start

    printf "Dumping Variable Table (0x%x - 0x%x)\n", $start, $end
    
    if ($start == $end)
        printf "No variables found in the table.\n"
    end
    
    while ($ptr < $end)
        set $c1 = *(char*)($ptr)
        set $c2 = *(char*)($ptr+1)

        printf "Var: %c%c%c\n", $c1, $c2 & 0x7f, $c2 & 0x80 ? '$' : 0x0
        
        set $ptr = $ptr + 7
    end
end

define dump-basic-array-table
    dont-repeat
    set $start = *(unsigned short*)0x1D
    set $end = *(unsigned short*)0x1F
    set $ptr = $start

    printf "Dumping Array Table (0x%x - 0x%x)\n", $start, $end

    if ($start == $end)
        printf "No arrays found in the table.\n"
    end

    while ($ptr < $end)
        set $c1 = *(char*)($ptr)
        set $c2 = *(char*)($ptr+1)

        set $array_space = *(unsigned short*)($ptr+2)

        printf "Arr: %c%c%c storage: 0x%x (%d)\n", $c1, $c2 & 0x7f, $c2 & 0x80 ? '$' : 0x0, $array_space, $array_space

        set $ptr = $ptr + $array_space
    end
end
