define dump-tables
    dont-repeat
    dump-basic-variable-table
end

define dump-basic-variable-table
    dont-repeat
    set $start = *(unsigned short*)0x1B
    set $end = *(unsigned short*)0x1D
    set $ptr = $start
    
    if ($start == $end)
        printf "No variables found in the table.\n"
    end
    
    while ($ptr < $end)
        set $c1 = *(char*)($ptr)
        set $c2 = *(char*)($ptr+1)

        printf "Var: %c%c%c: ", $c1, $c2 & 0x80, $c2 & 0x80 ? '$' : ''
        
        set $ptr = $ptr + 7
    end
end
