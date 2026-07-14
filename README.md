# CoCo-xroar-variable-counter

This repo provides a way to profile the access of Tandy CoCo BASIC variables for programs requiring performance improvements.
When a variable is encountered by the BASIC interpreter a linear search for the variable is performed in the variable table.
Knowing the most used variables allows the writer of the program to use the DIM statement to define those variables first so that they are at the top of the variable table search order.
When no optimization of the variable order is performed, the table will be built based on the order that the variables are encountered in the BASIC program.

Information from the "Unravelled Series" of books (e.g. "BASIC Unravelled") was used to help create the profiling scripts.

## Following are needed

- disk image of BASIC program under test
- gdb profiling script from this repo [basic_variables_lookup.gdb](basic_variables_lookup.gdb)
- xroar along with required roms

https://www.6809.org.uk/xroar/

- m6809-gdb

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


## Steps

### In one terminal session start xroar

```
$ xroar -gdb -machine coco3 -kbd-translate -load-fd0 PACMAN.DSK -joy-left kjoy0
```

### In another terminal session start gdb

```
$ m6809-gdb -x basic_variables_lookup.gdb -x dump_variable_tables.gdb
```

NOTE: If m6809-gdb fails to connect check the xroar session to make sure it didn't fail to create the listening port 65520 at startup.


