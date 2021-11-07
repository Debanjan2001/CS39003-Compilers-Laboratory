/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 : Translator header file
------------------------------------------*/

// include guards
#ifndef __TRANSLATE_H
#define __TRANSLATE_H

#include <bits/stdc++.h>

#define CHAR_SIZE 1
#define INT_SIZE 4
#define DOUBLE_SIZE 8
#define POINTER_SIZE 4

using namespace std;

extern char *yytext;
extern int yyparse();

// Class Declarations

// class for an Entry in a symbol table
class sym;
// class for an Entry in quad Array
class quad;
// class for storing type of a symbol in symbol table
class symboltype;
// class for storing Symbol Table
class symtable;
// class for  QuadArray
class quadArray;

extern quadArray q;           // Quad Array
extern symtable *table;       // Current ST
extern sym *currentSymbol;    // Pointer to last seen symbol
extern symtable *globalTable; // Global Symbol Table

//  Definition of the type of symbol
class symboltype
{
    // Type of symbols in symbol table
public:
    symboltype(string type, symboltype *ptr = NULL, int width = 1);
    string type;
    // Size(width) of array
    int width;
    // for 2d rrays and pointers
    symboltype *ptr;
};

//      Definition of the struct of quad element

class quad
{
    // Quad Class
public:
    string op;     // Operator
    string result; // Result
    string arg1;   // Argument 1
    string arg2;   // Argument 2

    void print();                                                         // Print Quad
    quad(string result, string arg1, string op = "EQ", string arg2 = ""); //constructors
    quad(string result, int arg1, string op = "EQ", string arg2 = "");    //constructors
    quad(string result, float arg1, string op = "EQ", string arg2 = "");  //constructors
};

//          Definition of the quad array type

class quadArray
{
    // Array of quads
public:
    // Vector of quads
    vector<quad> Array;
    // Print the quadArray
    void print();
};

//      Definition of structure of each element of the symbol table

class sym
{

public:
    string name;          // Name of the symbol
    symboltype *type;     // Type of the Symbol
    string initial_value; // Symbol initial valus (if any)
    string category;      // global, local or param category
    int size;             // Size of the symbol
    int offset;           // Offset of symbol
    symtable *nested;     // Pointer to nested symbol table

    sym(string name, string t = "INTEGER", symboltype *ptr = NULL, int width = 0); // constructor declaration
    sym *update(symboltype *t);                                                    // A method to update different fields of an existing entry.
    sym *link_to_symbolTable(symtable *t);
};

//          Class defination for the Symbol Table

class symtable
{ // Symbol Table class
public:
    string name;         // Name of Table
    int count;           // Count of temporary variables
    list<sym> table;     // The table of symbols
    symtable *parent;    // Immediate parent of the symbol table
    map<string, int> ar; // activation record
    symtable(string name = "NULL");
    sym *lookup(string name); // Lookup for a symbol in symbol table
    void print();             // Print the symbol table
    void update();            // Update offset of the complete symbol table
};

//          Class defination for the Statements

struct Statement
{
    list<int> nextlist; // Nextlist for statement
};

//          Attributes of the array type element

struct Array
{
    string cat;
    sym *loc;         // Temporary used for computing Array address
    sym *Array;       // Pointer to symbol table
    symboltype *type; // type of the subArray generated
};

//     Defination of the expression type

struct Expression
{
    // type int or bool
    string type;

    // Valid for non-bool type
    // Pointer to the symbol table entry
    sym *loc;

    // Valid for bool type
    // Truelist valid for boolean
    list<int> truelist;
    // Falselist valid for boolean expressions
    list<int> falselist;

    // for statement expression
    list<int> nextlist;
};

/*
gentemp method
-------
it generates a temporary variable and inserts it in the current Symbole table 

Parameters
---------
symbol type * : pointer to the  class of symbol type
init : initial value of the structure

Returns
------
Pointer to the newly created symbol table entry
 */
sym *gentemp(symboltype *t, string init = "");

// Overloaded emit function used by the parser

void emit(string op, string result, string arg1 = "", string arg2 = ""); // emits for adding quads to quadArray
void emit(string op, string result, int arg1, string arg2 = "");         // emits for adding quads to quadArray (arg1 is int)
void emit(string op, string result, float arg1, string arg2 = "");       // emits for adding quads to quadArray (arg1 is float)

//Backpatching and other functions

void backpatch(list<int> lst, int i);

list<int> makelist(int i);

list<int> merge(list<int> &a, list<int> &b);

// Helper functions required for TAC generation

sym *conv(sym *, string);
bool isSameTypeCheck(sym *&s1, sym *&s2);             // Checks if two symbols have same type
bool isSameTypeCheck(symboltype *t1, symboltype *t2); // checks if two symboltype objects have same type

Expression *convInt2Bool(Expression *); // convert (int) to bool
Expression *convBool2Int(Expression *); // convert bool to (int)

void changeTable(symtable *newtable); //for changing the current sybol table
int nextinstr();                      //  the next instruction number

int calculate_size(symboltype *); // Calculate size of any symbol type
string print_type(symboltype *);  // For printing type of symbol recursive printing of type

#endif