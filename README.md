# CoCo-xroar-variable-counter

This repo provides a way to profile the access of Tandy CoCo BASIC variables for programs requiring performance improvements.
When a variable is encountered by the BASIC interpreter a linear search for the variable is performed in the variable table.
Knowing the most used variables allows the writer of the program to use the DIM statement to define those variables first so that they are at the top of the variable table search order.
When no optimization of the variable order is performed, the table will be built based on the order that the variables are encountered in the BASIC program.

Information from the "Unravelled Series" of books (e.g. "BASIC Unravelled") was used to help create the profiling scripts.

Note: A Linux environment was used to create this information, but most of it could be used on other platforms with appropriate modifications.

## Following are needed

- disk image of BASIC program under test
- gdb profiling scripts from this repo:
   - [basic_variables_lookup.gdb](basic_variables_lookup.gdb)
   - [dump_variable_tables.gdb](dump_variable_tables.gdb)
- xroar emulator for Dragon/CoCo computers, along with required roms

https://www.6809.org.uk/xroar/

- m6809-gdb debugger

https://www.6809.org.uk/dragon/m6809-gdb.shtml

### Dependencies for building m6809-gdb from source

Following packages are needed on Ubuntu (already mentioned on the project page)

```
sudo apt install libgmp-dev libmpfr-dev libexpat1-dev
```

these are also needed (but not mentioned on the project page)

```
sudo apt install bison flex libreadline-dev
```

## How to use the profiling scripts

Two terminal sessions are needed

### First Terminal session

1- Start xroar and provide the program needing profiling

```
$ xroar -gdb -machine coco3 -kbd-translate -load TEST.BAS
```

or

```
$ xroar -gdb -machine coco3 -kbd-translate -load-fd0 PACMAN.DSK -joy-left kjoy0
```

2- Use DIR and LOAD commands to load from Disk Image (e.g. -load-fd0 PACMAN.DSK).

3- Or if a local file (e.g. -load TEST.BAS) was passed, then use the CLOAD command to load it into the interpreter.

4- Running the BASIC program could be the next step, but depending on how the BASIC program works and at what point of the run you want to start capturing variable access you may decide to start the gdb debugger before RUNning the BASIC program or delay it to when the BASIC program has passed some initial not performance sensitive section.

### Second Terminal session

1- start gdb at the appropriate time (before or after RUNning the program, depending on program specifics)

```
$ m6809-gdb -x basic_variables_lookup.gdb -x dump_variable_tables.gdb
```

NOTE: If m6809-gdb fails to connect check the xroar session to make sure it didn't fail to create the listening port 65520 at startup.


### When done with BASIC program

Do not stop the xroar emulator.
Use the CTRL-C in the gdb debugger to stop the run and use `dump-tables` in gdb to dump the list showing the variables table search order.

Exit gdb.
Exit xroar.

### What to do with the log file once created

Get the list of variables with the number of times accessed in descending order.

```
$ grep "Variable Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
```

```output
$ grep "Variable Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
      4 Variable Lookup Detected! Name: GG$
      4 Variable Lookup Detected! Name: AA$
      2 Variable Lookup Detected! Name: FF
      2 Variable Lookup Detected! Name: E
      2 Variable Lookup Detected! Name: D
      2 Variable Lookup Detected! Name: C
      2 Variable Lookup Detected! Name: BB
      2 Variable Lookup Detected! Name: B1
```

Get a list of array variables in most to least accessed arrays.

```
$ grep "Array Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
```

```
$ grep "Array Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
      6 Array Lookup Detected! Name: A
      2 Array Lookup Detected! Name: B$
```

# Next Steps

With the new information from the profiling results some changes to the BASIC code might be required. Changing the order may improve the performance. Retest until satisfied with the results.
