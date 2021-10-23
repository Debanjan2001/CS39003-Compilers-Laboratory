/*
    CS39003 : Assignment-5
    Name: Pritkumar Godhani + Debanjan Saha
    Roll: 19CS10048 + 19CS30014
*/

#include "asgn5_19CS10048_19CS30014_translator.h"
#include <bits/stdc++.h>
using namespace std;

//----------------------------------------------//
//              global variables                //
//          (Reference from the headers)        //
//----------------------------------------------//
quadArray Q;               // Quad Array
symtable *ST;              // Points to current symbol table
basicType bt;              // basic types
bool debug_on;             // bool for printing debug output
string var_type;           // Stores latest type
symtable *globalST;        // Global Symbol Table
symtable *parST;           // denotes the Parent of the current Symbol Table
sym *currSymbolPtr;        // points to current symbol
long long int table_count; // count of table
string loop_name;          // get the name of the loop
vector<label> label_table; // table to store the labels
// used for debugging
//void printpattern() { cout << ""; }

//--------------------------------------------------------------//
//      Implementation of the Symbol Element Class functions    //
//--------------------------------------------------------------//
sym::sym(string name, string t, symboltype *arrtype, int width)
{
    this->name = name;
    type = new symboltype(t, arrtype, width); // Generate type of symbol
    size = computeSize(type);                 // find the size from the type
    offset = 0;                               // put initial offset as 0
    val = "-";                                // no initial value
    nested = NULL;                            // no nested table
}

//-----------------------------------------------------------//
//      Implementation of the Symbol Type Class functions    //
//-----------------------------------------------------------//
symboltype::symboltype(string type, symboltype *arrtype, int width) // Constructor for a symbol type
{
    this->type = type;
    this->width = width;
    this->arrtype = arrtype;
}

sym *sym::update(symboltype *t)
{
    type = t;                    // Update the new type
    this->size = computeSize(t); // new size
    return this;                 // return the same variable
}

//------------------------------------------------------//
//      Implementation of the Label Symbol functions    //
//------------------------------------------------------//
label::label(string _name, int _addr) : name(_name), addr(_addr) {}

//------------------------------------------------------//
//      Implementation of the Symbol Table functions    //
//------------------------------------------------------//
symtable::symtable(string name) // constructor for a symbol table
{
    this->name = name; // Initialize the name of the symbol table
    count = 0;         // Put count of number of temporary variables as 0
}

sym *symtable::lookup(string name) // Lookup an symbol in the symbol table, whether it exists or not
{
    sym *symbol;
    list<sym>::iterator it; // it is list iterator (pointer) for list of symbols
    it = table.begin();     // start a linear search from the first element in the table
    for (it = table.begin(); it != table.end(); ++it)
    {
        if (it->name == name)
            return &(*it); // if the name of the symbol is found in the table then return the address of the element
    }

    sym *ptr = nullptr;
    if (this->parent)
        ptr = this->parent->lookup(name);
    /**
	 * If the symbol has not been found 
	 * in the symbol table then create 
	 * a new entry for the symbol table
	 * and insert in the table
	 * 
	 * Return the pointer to this 
	 * new element inserted
	 */
    if (ST == this && !ptr)
    {
        symbol = new sym(name);
        table.push_back(*symbol); // push the symbol into the table
        return &table.back();     // return the symbol
    }
    else if (ptr)
        return ptr;
    return nullptr;
}

void symtable::update() // Update the symbol table and the offsets in it
{
    list<symtable *> tb; // list of tables
    int off;
    list<sym>::iterator it; // list iterator for elements in the symbol table
    it = table.begin();
    for (it = table.begin(); it != table.end(); ++it)
    {
        if (it == table.begin())
        {
            it->offset = 0; // initial offset should be 0
            off = it->size;
        }
        else
        {
            it->offset = off;
            off = it->offset + it->size; // subsequent offset is the sum of the current offset and the space occupied by the current element
        }
        if (it->nested != NULL)
            tb.push_back(it->nested);
    }

    list<symtable *>::iterator itr;                // list iterator for the nested tables
    for (itr = tb.begin(); itr != tb.end(); ++itr) // recursively update all the nested tables
    {
        (*itr)->update();
    }
}

void symtable::print() // print a symbol table
{
    int next_instr = 0;
    list<symtable *> tb; // list of tables
    for (int lines = 0; lines < 55; lines++)
        cout << "--"; // print lines for the border of the table

    cout << endl;

    cout << "Table Name: " << (this->name);
    generateSpaces(53 - this->name.length());
    cout << " Parent Name: "; // table name
    if (((*this).parent == NULL))
        cout << "NULL" << endl; // If no parent for the current table print NULL
    else
        cout << (*this).parent->name << endl; // print the name for the current table
    for (int lines = 0; lines < 55; lines++)
        cout << "--"; // formatting
    cout << endl;

    //----------- Print the headers for the table --------------
    cout << "Name"; // Name of the entry in the symbol table
    generateSpaces(34);

    cout << "Type"; // Type of the symbol table entry
    generateSpaces(16);

    cout << "Initial Value"; // Initial Value of the symbol table entry
    generateSpaces(7);

    cout << "Size"; // Size of the type of the symbol table entry
    generateSpaces(11);

    cout << "Offset"; // Offset for the current entry in thr symbol table
    generateSpaces(9);

    cout << "Nested" << endl; // Nested symbol table (if any)
    generateSpaces(100);
    cout << endl;
    list<sym>::iterator it;
    for (it = table.begin(); it != table.end(); it++)
    { // iterate through all the elements in the symbol table and print their details

        cout << it->name; // Print name of the symbol entry
        generateSpaces(40 - it->name.length());

        string type_entry = printType(it->type); // Use PrintType to print type of the symbol entry
        cout << type_entry;
        generateSpaces(20 - type_entry.length());

        cout << it->val; // Print initial value of the current symbol table entry
        generateSpaces(20 - it->val.length());

        cout << it->size; // Print size of the current symbol table entry
        generateSpaces(15 - to_string(it->size).length());

        cout << it->offset; // print offset of the current symbol entry
        generateSpaces(15 - to_string(it->offset).length());

        if (it->nested == NULL)
        { // print nested table's name if it exists
            cout << "NULL" << endl;
        }
        else
        {
            cout << it->nested->name << endl;
            tb.push_back(it->nested); // Insert the names of the nested tables that need to be recursively printed
        }
    }

    for (int lines = 0; lines < 110; lines++)
        cout << "-";

    cout << "\n\n";

    list<symtable *>::iterator itr = tb.begin();
    while (itr != tb.end())
    {
        /**
		 * print symbol table that are nested in the 
		 * current symbol table, hence recursively 
		 * print all nested tables
		 */
        (*itr)->print();
        itr++;
    }
}

//--------------------------------------------------//
//      Implementation of the quad functions        //
//--------------------------------------------------//

//----------------Constrtuctors overloaded----------------------

// --------- (string, string, string, string)
quad::quad(string res, string arg1, string op, string arg2)
{
    this->op = op;
    this->arg1 = arg1;
    this->arg2 = arg2;
    this->res = res;
}

// --------- (string, int, string, string)
quad::quad(string res, int arg1, string op, string arg2)
{
    this->op = op;
    this->res = res;
    this->arg1 = convInt2String(arg1);
    this->arg2 = arg2;
}

// --------- (string, int, string, string)
quad::quad(string res, float arg1, string op, string arg2)
{
    this->op = op;
    this->res = res;
    this->arg1 = convFloat2String(arg1);
    this->arg2 = arg2;
}

//------------- Helper function to print the quads -----------------
void quad::print()
{
    ///////////////////////////////////////
    //          BINARY OPERATORS         //
    ///////////////////////////////////////

    int next_instr = 0;
    if (op == "+")
        this->type1();
    else if (op == "-")
        this->type1();
    else if (op == "*")
        this->type1();
    else if (op == "/")
        this->type1();
    else if (op == "%")
        this->type1();
    else if (op == "|")
        this->type1();
    else if (op == "^")
        this->type1();
    else if (op == "&")
        this->type1();

    ///////////////////////////////////////
    //       RELATIONAL OPERATORS        //
    ///////////////////////////////////////

    else if (op == "==")
        this->type2();
    else if (op == "!=")
        this->type2();
    else if (op == "<=")
        this->type2();
    else if (op == "<")
        this->type2();
    else if (op == ">")
        this->type2();
    else if (op == ">=")
        this->type2();
    else if (op == "goto")
        cout << "goto " << res;

    ///////////////////////////////////////
    //         SHIFT OPERATORS           //
    ///////////////////////////////////////

    else if (op == ">>")
        this->type1();
    else if (op == "<<")
        this->type1();

    //----- Asignment operator --------
    else if (op == "=")
        cout << res << " = " << arg1;

    ///////////////////////////////////////
    //         SHIFT OPERATORS           //
    ///////////////////////////////////////

    else if (op == "=&")
        cout << res << " = &" << arg1;
    else if (op == "=*")
        cout << res << " = *" << arg1;
    else if (op == "*=")
        cout << "*" << res << " = " << arg1;
    else if (op == "uminus")
        cout << res << " = -" << arg1;
    else if (op == "~")
        cout << res << " = ~" << arg1;
    else if (op == "!")
        cout << res << " = !" << arg1;

    ///////////////////////////////////////
    //         OTHER OPERATORS           //
    ///////////////////////////////////////

    else if (op == "=[]")
        cout << res << " = " << arg1 << "[" << arg2 << "]";
    else if (op == "[]=")
        cout << res << "[" << arg1 << "]"
             << " = " << arg2;
    else if (op == "return")
        cout << "return " << res;
    else if (op == "param")
        cout << "param " << res;
    else if (op == "call")
        cout << res << " = "
             << "call " << arg1 << ", " << arg2;
    else if (op == "label")
        cout << res << ": ";
    else
        cout << "Unable to find the operator" << op;
    cout << endl;
}

void quad::type1() // Printing binary operators
{
    cout << res << " = " << arg1 << " " << op << " " << arg2;
}

void quad::type2() // Printing relation operators and jumps
{
    cout << "if " << arg1 << " " << op << " " << arg2 << " goto " << res;
}

//------------------------------------------------------//
//      Implementation of the Basic Type functions      //
//------------------------------------------------------//
void basicType::addType(string t, int s) // Add new trivial type to type Symbol table
{
    type.push_back(t);
    size.push_back(s);
}

//--------------------------------------------------------------//
//        Implementation of the Quad Array Class functions      //
//--------------------------------------------------------------//
void quadArray::print() // print the quad Array i.e the list of TAC
{
    for (int lines = 0; lines < 55; ++lines)
        cout << "--";
    cout << endl;

    cout << "Three Address Code (TAC): " << endl; // print all the three address codes TAC
    for (int lines = 0; lines < 55; ++lines)
        cout << "--";
    cout << endl;

    int counter = 0;
    vector<quad>::iterator it; // vector iterator to iterate through all the TAC in the array
    for (it = Array.begin(); it != Array.end(); ++it, counter++)
    {
        if (it->op == "label") // print the label if it is the operator
        {
            cout << endl;
            cout << counter << ": ";
            it->print();
        }
        else
        {
            // otherwise give 4 spaces and then print
            cout << counter << ": ";
            generateSpaces(4);
            it->print();
        }
    }

    // End TAC
    for (int lines = 0; lines < 55; ++lines)
        cout << "--";
    cout << endl;
}

void generateSpaces(int n) // Generate required number of spaces
{
    for (int i = 0; i < n; i++)
    {
        cout << " ";
    }
}

string convInt2String(int a) // helper function to convert int to string
{
    return to_string(a);
}

string convFloat2String(float x) // Take float as input and produce string as output
{
    std::ostringstream buff;
    buff << x;
    return buff.str();
}

//------------------------------------------------------------------//
//          Overloaded emit function used by the parser             //
//------------------------------------------------------------------//

//----------------- Emit a three address code TAC and add it to the Quad Array ------------
void emit(string op, string res, string arg1, string arg2)
{
    quad *myQuad = new quad(res, arg1, op, arg2);
    Q.Array.push_back(*myQuad);
}

void emit(string op, string res, int arg1, string arg2)
{
    quad *myQuad = new quad(res, arg1, op, arg2);
    Q.Array.push_back(*myQuad);
}

void emit(string op, string res, float arg1, string arg2)
{
    quad *myQuad = new quad(res, arg1, op, arg2);
    Q.Array.push_back(*myQuad);
}

sym *convertType(sym *s, string rettype) // convert symbol s into the required return type
{
    sym *mySymbol = gentemp(new symboltype(rettype));
    if (s->type->type == "char") // if type char
    {
        if (rettype == "int") // converting char to int
        {
            emit("=", mySymbol->name, "char2int(" + (*s).name + ")");
            return mySymbol;
        }
        if (rettype == "double") // or converting to double
        {
            emit("=", mySymbol->name, "char2double(" + (*s).name + ")");
            return mySymbol;
        }
        return s;
    }
    else if (s->type->type == "float") // if type float
    {
        if (rettype == "int") // converting float to int
        {
            emit("=", mySymbol->name, "float2int(" + (*s).name + ")");
            return mySymbol;
        }
        else if (rettype == "char") // or converting to char
        {
            emit("=", mySymbol->name, "float2char(" + (*s).name + ")");
            return mySymbol;
        }
        return s;
    }
    else if (s->type->type == "int") // if type int
    {
        if (rettype == "float") // converting int to float
        {
            emit("=", mySymbol->name, "int2float(" + (*s).name + ")");
            return mySymbol;
        }
        else if (rettype == "char") // or converting to char
        {
            emit("=", mySymbol->name, "int2char(" + (*s).name + ")");
            return mySymbol;
        }
        return s;
    }
    return s;
}

void changeTable(symtable *newtable) // Change current symbol table
{
    ST = newtable;
}

bool compareSymbolType(sym *&s1, sym *&s2) // Check if the symbols have same type or not
{
    symboltype *myType1 = s1->type; // get the basic type of symbol 1
    symboltype *myType2 = s2->type; // get the basic type of symbol 2
    bool checker = false;

    if (compareSymbolType(myType1, myType2))
        checker = true; // check if the two types are already equal
    else if (s1 = convertType(s1, myType2->type))
        checker = true; // check if one can be converted to the other then convert them
    else if (s2 = convertType(s2, myType1->type))
        checker = true; // check if one can be converted to the other then convert them

    if (checker)
        return true; // if the two types are compatible return true
    else
        return false; // else return false
}

bool compareSymbolType(symboltype *t1, symboltype *t2) // Check if the symbol types are same or not
{
    int checker = 0;
    if (t1 == NULL && t2 == NULL)
        checker = 1; // if both symbol types are NULL
    else if (t1 == NULL || t2 == NULL || t1->type != t2->type)
        checker = 2; // if only one of them is NULL or if base type isn't same

    if (checker == 1)
        return true;
    else if (checker == 2)
        return false;
    else
        return compareSymbolType(t1->arrtype, t2->arrtype); // otherwise check their Array type
}

//-------------------------------------------------------------//
//            Backpatching and related functions               //
//-------------------------------------------------------------//
void backpatch(list<int> list1, int addr) // backpatching
{
    string myStr = convInt2String(addr); // get string form of the address

    for (list<int>::iterator itr = list1.begin(); itr != list1.end(); ++itr)
    {
        Q.Array[*itr].res = myStr; // do the backpatching
    }
}

list<int> makelist(int init)
{
    list<int> newlist(1, init); // make a new list
    return newlist;             // return the newly created list
}

list<int> merge(list<int> &a, list<int> &b)
{
    a.merge(b); // merge two existing lists
    return a;   // return the merged list
}

//----------------------------------------------------------------------//
//          Other helper functions required for TAC generation          //
//----------------------------------------------------------------------//

//------------- Type checking and Type conversion functions -------------

Expression *convBool2Int(Expression *e) // Convert any Expression to bool using standard procedure
{
    if (e->type == "bool")
    {
        e->loc = gentemp(new symboltype("int")); // use general goto statements and standard procedure
        backpatch(e->truelist, nextinstr());
        emit("=", e->loc->name, "true");
        int nxt = nextinstr() + 1;
        string myStr = convInt2String(nxt);
        emit("goto", myStr);
        backpatch(e->falselist, nextinstr());
        emit("=", e->loc->name, "false");
    }
    return e;
}

Expression *convInt2Bool(Expression *e) // Convert any Expression to bool using standard procedure
{
    if (e->type != "bool")
    {
        e->falselist = makelist(nextinstr()); // update the falselist
        emit("==", "", e->loc->name, "0");    // emit general goto statements
        e->truelist = makelist(nextinstr());  // update the truelist
        emit("goto", "");
    }
    return e;
}

int nextinstr()
{
    return Q.Array.size(); // next instruction will be 1+last index and lastindex=size-1. hence return size
}

/*void update_nextinstr()
{
    instr_count++;
    if (debug_on == 1)
    {
        cout << "Current Line Number:" << instr_count << endl;
        cout << "Press [ENTER] to continue:";
        cin.get();
    }
}*/

/*void debug()
{
    if (debug_on == 1)
        cout << instr_count << endl;
}*/

/**
 * GENTEMP
 * -------
 * generates a temporary variable 
 * and insert it in the current 
 * Symbole table 
 * 
 * Parameter
 * ---------
 * symbol type * : pointer to the 
 *                 class of symbol type
 * init : initial value of the structure
 * 
 * Return
 * ------
 * Pointer to the newly created symbol 
 * table entry
 */
sym *gentemp(symboltype *t, string str_new)
{                                                           // generate temp variable
    string my_gen_name = "t" + convInt2String(ST->count++); // generate name of temporary variable
    sym *mySymbol = new sym(my_gen_name);
    mySymbol->type = t;
    mySymbol->size = computeSize(t); // calculate the size of the current symbol
    mySymbol->val = str_new;
    ST->table.push_back(*mySymbol); // push the newly created symbol in the Symbol table
    return &ST->table.back();
}

label *find_label(string _name)
{
    vector<label>::iterator itr;
    while (itr != label_table.end())
    {
        if (itr->name == _name)
            return &(*itr);
        ++itr;
    }
    return nullptr;
}

//----------------------------------------------------------------------//
//           Other helper function for debugging and printing           //
//----------------------------------------------------------------------//

int computeSize(symboltype *t) // calculate size function
{
    if (t->type.compare("arr") == 0)
        return t->width * computeSize(t->arrtype); // recursive for arrays (Multidimensional arrays)

    if (t->type.compare("void") == 0)
        return bt.size[1];

    if (t->type.compare("char") == 0)
        return bt.size[2];

    if (t->type.compare("int") == 0)
        return bt.size[3];

    if (t->type.compare("float") == 0)
        return bt.size[4];

    if (t->type.compare("ptr") == 0)
        return bt.size[5];

    if (t->type.compare("func") == 0)
        return bt.size[6];

    return -1;
}

string printType(symboltype *t) // Print type of variable(imp for multidimensional arrays)
{
    if (t == NULL)
        return bt.type[0];

    if (t->type.compare("void") == 0)
        return bt.type[1];

    if (t->type.compare("char") == 0)
        return bt.type[2];

    if (t->type.compare("int") == 0)
        return bt.type[3];

    if (t->type.compare("float") == 0)
        return bt.type[4];

    if (t->type.compare("ptr") == 0)
        return bt.type[5] + "(" + printType(t->arrtype) + ")"; // recursive for ptr

    if (t->type.compare("arr") == 0)
    {
        string myStr = convInt2String(t->width); // recursive for arrays
        return bt.type[6] + "(" + myStr + "," + printType(t->arrtype) + ")";
    }

    if (t->type.compare("func") == 0)
        return bt.type[7];

    if (t->type.compare("block") == 0)
        return bt.type[8];

    return "NA";
}

int main()
{

    ////////////////////////////////////////
    //             BASIC TYPES            //
    ////////////////////////////////////////

    bt.addType("null", 0); // Add base types initially
    bt.addType("void", 0);
    bt.addType("char", 1);
    bt.addType("int", 4);
    bt.addType("float", 8);
    bt.addType("ptr", 4);
    bt.addType("block", 0);
    bt.addType("arr", 0);
    bt.addType("func", 0);

    label_table.clear();

    //instr_count = 0;                   // count of instr (used for sanity check)
    table_count = 0;                   // count of nested table
    debug_on = 0;                      // debugging is off
    globalST = new symtable("Global"); // Global Symbol Table
    ST = globalST;
    parST = nullptr;
    loop_name = "";

    yyparse();          // initialize parse
    globalST->update(); // update the global Symbol Table
    cout << "\n";

    Q.print();         // print the three address codes
    globalST->print(); // print all Symbol Tables
};
