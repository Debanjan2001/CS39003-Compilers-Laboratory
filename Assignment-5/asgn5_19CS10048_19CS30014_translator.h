/*
    CS39003 : Assignment-5
    Name: Pritkumar Godhani + Debanjan Saha
    Roll: 19CS10048 + 19CS30014
*/

// include guards
#ifndef __TRANSLATE_H
#define __TRANSLATE_H

#include <bits/stdc++.h>

extern char *yytext;
extern int yyparse();

using namespace std;

/********************** Class Declarations ******************* */

class sym;        // Class for an entry in ST
class symboltype; // Class for the type of a symbol in ST
class symtable;   // Class for Symboltable
class quad;       // Class for a single entry in the quad Array
class quadArray;  // Class for the Array of quads
class label;      // Class for a single label entry in the label table
class basicType;  // Class for the basic type data
class Expression; // Class for the expression type data storage

/********************** global variables **********************/

// Current Symbol Table
extern symtable *ST;
// Global Symbol Table
extern symtable *globalST;
// parent of the current Symbol Table
extern symtable *parST;
// the latest encountered symbol
extern sym *currSymbolPtr;
// the quad Array
extern quadArray Q;
// the Type ST
extern basicType bt;

// count of instr , commenting out now, may use later
//extern long long int instr_count;

// count of nested tables
extern long long int table_count;

// boolean for printing debug output
extern bool debug_on;

// the name of the loop
extern string loop_name;

// table to store the labels
extern vector<label> label_table;

/*********** Class Definition of each element of symbol table *************/
class sym
{
public:
    string name;      // the name of the symbol
    symboltype *type; // the type of the symbol
    int size;         // the size of the symbol
    int offset;       // the offset of symbol in ST
    symtable *nested; // points to the nested symbol table
    string val;       // initial value of the symbol if specified

    // constructor for symboltable entry
    sym(string, string t = "int", symboltype *ptr = NULL, int width = 0);

    // Class Method to update different fields of a symbol entry in symboltable.
    sym *update(symboltype *);
};

/*********** Class Definition of the type of symbol  *************/

class symboltype
{
public:
    string type;         // stores the type of symbol.
    int width;           // stores the size of Array (if we encounter an Array) and it is 1 in default case
    symboltype *arrtype; // for storing the typr of the array in recursive manner

    // Constructor for symboltype
    symboltype(string, symboltype *ptr = NULL, int width = 1);
};

/*********** Class Definition of the Symbol Table  *************/

class symtable
{
public:
    string name;      // Name of the Table
    int count;        // Count of the temporary variables
    list<sym> table;  // The table of symbols which is essentially a list of sym
    symtable *parent; // Parent ST of the current ST

    // Constructor
    symtable(string name = "NULL");

    // Lookup method for a symbol in ST
    sym *lookup(string);

    // Method to print the ST
    void print();

    // Method to update the ST
    void update();
};

/*********** Class Definition of quad element  *************/

class quad
{
    // A quad has four components:
public:
    // Result
    string res;
    // Operator
    string op;
    // Argument 1
    string arg1;
    // Argument 2
    string arg2;

    //Method to Print the Quad
    void print();
    // Method for printing binary operators
    void type1();
    // Method for printing relational operators and jumps
    void type2();

    //----------Constructors---------------
    quad(string, string, string op = "=", string arg2 = "");
    quad(string, int, string op = "=", string arg2 = "");
    quad(string, float, string op = "=", string arg2 = "");
};

/*********** Class Definition of the quad array type  *************/

class quadArray
{
public:
    // A vector (array) of quads
    vector<quad> Array;
    // Method to print the quadArray
    void print();
};

/*********** Definition of the label symbol  *************/

class label
{
public:
    //  name of the label
    string name;
    // the address the label is pointing to
    int addr;
    // list of dangling goto statements
    list<int> nextlist;

    // Constructor of  label
    label(string _name, int _addr = -1);
};

/*********** Definition of the basic type  *************/
class basicType
{
    // class for  a basic type
public:
    vector<string> type; // type name
    vector<int> size;    // size of the type
    void addType(string, int);
};

/***********  Definition of the expression type  *************/

struct Expression
{
    // pointer to the symbol table entry
    sym *loc;
    // to store whether the expression is of type int or bool or float or char
    string type;
    // truelist for boolean expressions
    list<int> truelist;
    // falselist for boolean expressions
    list<int> falselist;
    // for statement expressions
    list<int> nextlist;
};

/*********** Structure  Definition of the array type element    *************/

struct Array
{
    // for type of Array: may be "ptr" or "arr" type
    string atype;
    // Location to compute address of Array
    sym *loc;
    // pointer to the symbol table entry
    sym *Array;
    // type of the subarr1 generated (important for multidimensional arr1s)
    symboltype *type;
};

struct Statement
{
    // nextlist for Statement with dangling exit
    list<int> nextlist;
};

/*********** Overloaded emit function used by the parser   *************/
void emit(string, string, string arg1 = "", string arg2 = "");
void emit(string, string, int, string arg2 = "");
void emit(string, string, float, string arg2 = "");

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
sym *gentemp(symboltype *, string init = "");

/***********  Backpatching and related functions    *************/
void backpatch(list<int>, int);                // backpatch the dangling instructions with the given address(parameter)
list<int> makelist(int);                       // Make a new list contanining an integer address
list<int> merge(list<int> &l1, list<int> &l2); // Merge two lists into a single list

/*********** Other helper functions required for TAC generation   *************/
label *find_label(string name);

/****** Type checking and Type conversion functions *********/
// helper function to convert integer to string
string convInt2String(int);
// helper function to convert float to string
string convFloat2String(float);
// helper function to convert int expression to boolean
Expression *convInt2Bool(Expression *);
// helper function to convert boolean expression to int
Expression *convBool2Int(Expression *);

// helper function for type conversion
sym *convertType(sym *, string);
// helper function to check for same type of two symbol table entries
bool compareSymbolType(sym *&s1, sym *&s2);
// helper function to check for same type of two symboltype objects
bool compareSymbolType(symboltype *, symboltype *);
// helper function to calculate size of symbol type
int computeSize(symboltype *);
// helper function to change current table
void changeTable(symtable *);

// Returns the next instruction number
int nextinstr();
// Returns the next instruction number
//void update_nextinstr();

/****** Helper function for debugging and printing  *********/
string printType(symboltype *); // print type of symbol

void generateSpaces(int);

// Used for printing debugging output
//void debug();

#endif
// end include guards
