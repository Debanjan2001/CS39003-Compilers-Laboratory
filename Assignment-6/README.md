## Assignment-6 :: TinyC Compiler

---

-   Author1 - Debanjan Saha, 19CS30014
-   Author2 - Pritkumar Godhani, 19CS10048

---

## Group :: 35

## FILES INCLUDED ::

    1. ass6_19CS10048_19CS30014.y : Main Bison File
    2. ass6_19CS10048_19CS30014.l : Main Flex File
    3. ass6_19CS10048_19CS30014_translator.h : Functions & Data Structure used in IR Generation header File
    4. ass6_19CS10048_19CS30014_translator.cxx : Definitions of Functions declared in above header file for Intermediate Code Generation.
    5. ass6_19CS10048_19CS30014_target_translator.cxx : Definitions of Functions in translator.h for x86_84 Assembly Code Generation
    6. ass6_19CS10048_19CS30014_test[1,2,3,4,5,6] : Test Files
    7. ass2_19CS30014.c : Library Functions for I/O without system interrupts
    7. Makefile : A makefile to compile the above files and run the test files.

> TO RUN ::

```
make
```

> To run the i-th test from test file [1-6]

```
./test<i>
```

> TO CLEAN FILES FROM A PREVIOUS RUN

```
make clean
```

### OUTPUT FILES GENERATED ::

1. ass6_19CS10048_19CS30014_quads[1,2,3,4,5,6] : Text files containing the translated TAC and the Symbol Tables used for the TAC generation.
2. ass6_19CS10048_19CS30014_test[1,2,3,4,5,6].s & .o : Assembly and Object Code Files for respective test cases.
3. test[1,2,3,4,5,6] : Executable Files for respective test cases.
4. Some other intermediate files.

## STATUS ::

-   The make command exeutes without error on the Authors' system.
-   UBUNTU 18.04 LTS On a INTEL x86_64 System
-   GCC VERSION : (Ubuntu 10.1.0-2ubuntu1~18.04) 10.1.0
-   FLEX VERSION : 2.6.4
-   BISON VERSION : (GNU Bison) 3.0.4
-   MAKE VERSION : GNU Make 4.1
