# CoCo-xroar-variable-profiler

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

NOTE: Before starting the m6809-gdb debugger, you may want to delete the log file `basic_variables_log.log` to avoid having old information from a previous run.

1- start gdb at the appropriate time (before or after RUNning the program, depending on program specifics)

```
$ m6809-gdb -x basic_variables_lookup.gdb -x dump_variable_tables.gdb
```

NOTE: If m6809-gdb fails to connect check the xroar session to make sure it didn't fail to create the listening port 65520 at startup.


### When done with BASIC program

Do not stop the xroar emulator.
Use the CTRL-C in the gdb debugger to stop the run and use the user created `dump-tables` command in gdb to dump the list showing the variables table search order.

<pre><code>
(gdb) dump-tables
Dumping Variable Table (0x1e89 - 0x1ec1)
Var: AA$
Var: BB
Var: C
Var: D
Var: E
Var: FF
Var: GG$
Var: B1
Dumping Array Table (0x1ec1 - 0x1f01)
Arr: A storage: 0x25 (37)
Arr: B$ storage: 0x1b (27)
(gdb)
</code></pre>

Exit gdb.
Exit xroar.

### What to do with the log file once created

Use the following command line to get the list of variables with the number of times accessed in descending order.

```
$ grep "Variable Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
```

<pre><code>
$ grep "Variable Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
      4 Variable Lookup Detected! Name: GG$
      4 Variable Lookup Detected! Name: AA$
      2 Variable Lookup Detected! Name: FF
      2 Variable Lookup Detected! Name: E
      2 Variable Lookup Detected! Name: D
      2 Variable Lookup Detected! Name: C
      2 Variable Lookup Detected! Name: BB
      2 Variable Lookup Detected! Name: B1
</code></pre>

Use the following command line to get the list of arrays with the number of times accessed in descending order.

```
$ grep "Array Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
```

<pre><code>
$ grep "Array Lookup" basic_variables_log.log | sort | uniq -c | sort -n -r
      6 Array Lookup Detected! Name: A
      2 Array Lookup Detected! Name: B$
</code></pre>

# Next Steps

With the new information gathered from the profiling results some changes to the BASIC code might be required. Changing the variable or array declaration order (using DIM at the start of the program, for example) may improve the performance. Retest until satisfied with the results.
