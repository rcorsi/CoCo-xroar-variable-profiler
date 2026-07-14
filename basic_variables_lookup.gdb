#
#### start debugging session like this:
#
# Session 1 # xroar -gdb -machine coco3 -kbd-translate ...
# e.g.
#     xroar -gdb -machine coco3 -kbd-translate -load-fd0 PACMAN.DSK -joy-left kjoy0
#
#
# Session 2 # m6809-gdb -x basic_variables_lookup.gdb
#
# Notes: If m6809-gdb fails to connect check the xroar session to make sure it
#        didn't fail to create the listening port 65520 at startup.
#
#
####
#

# connect to xroar already running in a different terminal session
target remote 127.0.0.1:65520

# setup the log output
set logging file basic_variables_log.log
set logging enabled on
set pagination off


# 1. Break once we know it is a VARIABLE and not an ARRAY
break *0xb38f

# 2. Printout BASIC variable information
commands
  silent
  printf "Variable Lookup Detected! Name: %c%c%c\n", (char)(*(unsigned char*) 0x0037), (char)(*(unsigned char*) 0x0038 & 0x7f), (char)(*(unsigned char*) 0x0038 & 0x80) ? '$' : ' '
  continue
end

# 1. Break once we know it is an ARRAY
break *0xb404

# 2. Printout BASIC array information
commands
  silent
  printf "Array Lookup Detected! Name: %c%c%c\n", (char)(*(unsigned char*) 0x0037), (char)(*(unsigned char*) 0x0038 & 0x7f), (char)(*(unsigned char*) 0x0038 & 0x80) ? '$' : ' '
  continue
end

info breakpoints
continue

