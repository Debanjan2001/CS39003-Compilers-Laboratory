/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 : Translator
------------------------------------------*/

#include "ass6_19CS10048_19CS30014_translator.h"
#include <sstream>
using namespace std;

// Quad Array
quadArray q;
// Stores latest type
string Type;
// Points to current symbol table
symtable *table;
// points to current symbol
sym *currentSymbol;
// Global Symbol Table
symtable *globalTable;

// Implementation of the Symbol Type Class functions

symboltype::symboltype(string type, symboltype *ptr, int width) : type(type),
                                                                  ptr(ptr),
                                                                  width(width){};

//      Implementation of the quad class functions        //

quad::quad(string result, string arg1, string op, string arg2) : result(result), arg1(arg1), arg2(arg2), op(op){}; // Constructor

quad::quad(string result, int arg1, string op, string arg2) : result(result), arg2(arg2), op(op) // Constructor
{
    stringstream strss;
    strss << arg1;
    string temp_str = strss.str();
    char *intString = (char *)temp_str.c_str();
    string finalstr = string(intString);
    this->arg1 = finalstr;
}

quad::quad(string result, float arg1, string op, string arg2) : result(result), arg2(arg2), op(op)
{
    ostringstream strss; // Create an output stream buffer of string
    strss << arg1;       // convert float to string by passing it into string buffer
    this->arg1 = strss.str();
}

//------------- Helper function to print the quads -----------------
void quad::print()
{

    if (op == "LEFTOP")
        cout << result << " = " << arg1 << " << " << arg2;
    else if (op == "RIGHTOP")
        cout << result << " = " << arg1 << " >> " << arg2;
    else if (op == "EQUAL")
        cout << result << " = " << arg1;
    else if (op == "ADD")
        cout << result << " = " << arg1 << " + " << arg2;
    else if (op == "SUB")
        cout << result << " = " << arg1 << " - " << arg2;
    else if (op == "MULT")
        cout << result << " = " << arg1 << " *" << arg2;
    else if (op == "DIVIDE")
        cout << result << " = " << arg1 << " / " << arg2;
    else if (op == "MODOP")
        cout << result << " = " << arg1 << " % " << arg2;
    else if (op == "XOR")
        cout << result << " = " << arg1 << " ^ " << arg2;
    else if (op == "INOR")
        cout << result << " = " << arg1 << " | " << arg2;
    else if (op == "BAND")
        cout << result << " = " << arg1 << " &" << arg2;
    else if (op == "ADDRESS")
        cout << result << " = &" << arg1;
    else if (op == "PTRR")
        cout << result << " = *" << arg1;
    else if (op == "PTRL")
        cout << "*" << result << " = " << arg1;
    else if (op == "UMINUS")
        cout << result << " = -" << arg1;
    else if (op == "BNOT")
        cout << result << " = ~" << arg1;
    else if (op == "LNOT")
        cout << result << " = !" << arg1;
    else if (op == "LT")
        cout << "if " << arg1 << "<" << arg2 << " goto " << result;
    else if (op == "GT")
        cout << "if " << arg1 << " > " << arg2 << " goto " << result;
    else if (op == "GE")
        cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
    else if (op == "LE")
        cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
    else if (op == "EQOP")
        cout << "if " << arg1 << " == " << arg2 << " goto " << result;
    else if (op == "NEOP")
        cout << "if " << arg1 << " != " << arg2 << " goto " << result;
    else if (op == "GOTOOP")
        cout << "goto " << result;
    else if (op == "ARRR")
        cout << result << " = " << arg1 << "[" << arg2 << "]";
    else if (op == "ARRL")
        cout << result << "[" << arg1 << "]"
             << " = " << arg2;
    else if (op == "RETURN")
        cout << "ret " << result;
    else if (op == "PARAM")
        cout << "param " << result;
    else if (op == "CALL")
        cout << result << " = "
             << "call " << arg1 << ", " << arg2;
    else if (op == "FUNC")
        cout << result << ": ";
    else if (op == "FUNCEND")
        cout << "";
    else
        cout << "op";
    cout << endl;
}

// Implementation of the Quad Array Class functions

void quadArray::print()
{
    cout << setw(31) << setfill('=') << "=" << endl;
    cout << "Quad Translation" << endl;
    cout << setw(31) << setfill('-') << "-" << setfill(' ') << endl;
    vector<quad>::iterator it = Array.begin();
    while (it != Array.end())
    {
        if (it->op == "FUNC")
        {
            cout << "\n";
            it->print();
            cout << "\n";
        }
        else if (it->op == "FUNCEND")
        {
            // do nothing;
        }
        else
        {
            cout << "\t" << setw(4) << it - Array.begin() << ":\t";
            it->print();
        }
        ++it;
    }

    cout << setw(29) << setfill('-') << "-" << endl;
}

sym::sym(string name, string t, symboltype *ptr, int width) : name(name)
{
    type = new symboltype(t, ptr, width);
    nested = NULL;
    initial_value = "";
    category = "";
    offset = 0;
    size = calculate_size(type);
}

sym *sym::update(symboltype *t)
{
    type = t;
    this->size = calculate_size(t);
    return this;
}

symtable::symtable(string name) : name(name), count(0) {}

void symtable::print()
{
    list<symtable *> tablelist;
    cout << setw(119) << setfill('=') << "=" << endl;
    cout << "Symbol Table: " << setfill(' ') << left << setw(50) << this->name;
    cout << right << setw(25) << "Parent: ";
    if (this->parent != NULL)
        cout << this->parent->name;
    else
        cout << "null";
    cout << endl;
    cout << setw(119) << setfill('-') << "-" << endl;
    cout << setfill(' ') << left << setw(14) << "Name";
    cout << left << setw(24) << "Type";
    cout << left << setw(14) << "Category";
    cout << left << setw(29) << "Initial Value";
    cout << left << setw(11) << "Size";
    cout << left << setw(11) << "Offset";
    cout << left << "Nested" << endl;
    cout << setw(119) << setfill('-') << "-" << setfill(' ') << endl;

    for (list<sym>::iterator it = table.begin(); it != table.end(); it++)
    {
        cout << left << setw(14) << it->name;
        string stype = print_type(it->type);
        cout << left << setw(24) << stype;
        cout << left << setw(14) << it->category;
        cout << left << setw(29) << it->initial_value;
        cout << left << setw(11) << it->size;
        cout << left << setw(11) << it->offset;
        cout << left;
        if (it->nested == NULL)
        {
            cout << "null" << endl;
        }
        else
        {
            cout << it->nested->name << endl;
            tablelist.push_back(it->nested);
        }
    }

    cout << setw(119) << setfill('-') << "-" << setfill(' ') << endl;
    cout << endl;
    for (list<symtable *>::iterator iterator = tablelist.begin(); iterator != tablelist.end();
         ++iterator)
    {
        (*iterator)->print();
    }
}

void symtable::update()
{
    list<symtable *> tablelist;
    int off = 0;
    list<sym>::iterator it = table.begin();
    while (it != table.end())
    {
        it->offset = off;
        off = it->offset + it->size;
        if (it->nested != NULL)
            tablelist.push_back(it->nested);

        it++;
    }

    list<symtable *>::iterator itr = tablelist.begin();
    while (itr != tablelist.end())
    {
        (*itr)->update();
        ++itr;
    }
}

sym *symtable::lookup(string name)
{
    sym *mysym;

    list<sym>::iterator it = table.begin();
    while (it != table.end())
    {
        if (it->name == name)
            return &*it;

        ++it;
    }

    mysym = new sym(name);
    mysym->category = "local";
    table.push_back(*mysym);
    return &table.back();
}

//  Overloaded emit function used by the parser

void emit(string op, string result, string arg1, string arg2)
{
    q.Array.push_back(*(new quad(result, arg1, op, arg2)));
}

void emit(string op, string result, int arg1, string arg2)
{
    q.Array.push_back(*(new quad(result, arg1, op, arg2)));
}

void emit(string op, string result, float arg1, string arg2)
{
    q.Array.push_back(*(new quad(result, arg1, op, arg2)));
}

sym *conv(sym *s, string t)
{
    sym *temp = gentemp(new symboltype(t));
    if (s->type->type == "DOUBLE")
    {
        if (t == "INTEGER")
        {
            emit("EQUAL", temp->name, "double2int(" + s->name + ")");
            return temp;
        }
        else if (t == "CHAR")
        {
            emit("EQUAL", temp->name, "double2char(" + s->name + ")");
            return temp;
        }

        return s;
    }
    else if (s->type->type == "CHAR")
    {
        if (t == "INTEGER")
        {
            emit("EQUAL", temp->name, "char2int(" + s->name + ")");
            return temp;
        }

        if (t == "DOUBLE")
        {
            emit("EQUAL", temp->name, "char2double(" + s->name + ")");
            return temp;
        }

        return s;
    }
    else if (s->type->type == "INTEGER")
    {
        if (t == "DOUBLE")
        {
            emit("EQUAL", temp->name, "int2double(" + s->name + ")");
            return temp;
        }
        else if (t == "CHAR")
        {
            emit("EQUAL", temp->name, "int2char(" + s->name + ")");
            return temp;
        }

        return s;
    }

    return s;
}

bool isSameTypeCheck(sym *&s1, sym *&s2)
{
    // Check if the symbols have same type or not
    symboltype *type1 = s1->type;
    symboltype *type2 = s2->type;
    if (isSameTypeCheck(type1, type2))
        return true;
    else if (s1 = conv(s1, type2->type))
        return true;
    else if (s2 = conv(s2, type1->type))
        return true;
    else
        return false;
}

bool isSameTypeCheck(symboltype *t1, symboltype *t2)
{
    // Check if the symbol types are same or not
    if (t1 != NULL || t2 != NULL)
    {
        if (t1 == NULL)
            return false;
        if (t2 == NULL)
            return false;
        if (t1->type == t2->type)
            return isSameTypeCheck(t1->ptr, t2->ptr);
        else
            return false;
    }

    return true;
}

// Backpatching and related functions

void backpatch(list<int> l, int addr)
{
    stringstream strs;
    strs << addr;
    string temp_str = strs.str();
    char *intStr = (char *)temp_str.c_str();                      // convert  string stream to char array
    string str = string(intStr);                                  // create a string stream of the integer address
    for (list<int>::iterator it = l.begin(); it != l.end(); it++) // iterate through all the dangline quads
    {                                                             // backpatch the statement with the current address
        q.Array[*it].result = str;
    }
}

list<int> makelist(int i)
{
    list<int> l(1, i); // make a list with the currrent address
    return l;          // return the list
}

list<int> merge(list<int> &a, list<int> &b)
{
    a.merge(b); // merge the list b into list a
    return a;   // return the merged list
}

// Other helper functions required for TAC generation

Expression *convInt2Bool(Expression *e)
{
    if (e->type != "BOOL")
    {
        e->falselist = makelist(nextinstr());
        emit("EQOP", "", e->loc->name, "0");
        e->truelist = makelist(nextinstr());
        emit("GOTOOP", "");
    }

    return e;
}

Expression *convBool2Int(Expression *e)
{
    if (e->type == "BOOL")
    {
        e->loc = gentemp(new symboltype("INTEGER"));
        backpatch(e->truelist, nextinstr());
        emit("EQUAL", e->loc->name, "true");
        stringstream strs;
        strs << nextinstr() + 1;
        string temp_str = strs.str();
        char *intStr = (char *)temp_str.c_str();
        string str = string(intStr);
        emit("GOTOOP", str);
        backpatch(e->falselist, nextinstr());
        emit("EQUAL", e->loc->name, "false");
    }

    return e;
}

void changeTable(symtable *newtable)
{
    // Change current symbol table
    table = newtable;
}

int nextinstr()
{
    return q.Array.size();
}

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

sym *gentemp(symboltype *t, string init)
{
    char n[10];
    sprintf(n, "t%02d", table->count++);
    sym *s = new sym(n);
    s->type = t;
    s->size = calculate_size(t);
    s->initial_value = init;
    s->category = "temp";
    table->table.push_back(*s);
    return &table->table.back();
}

int calculate_size(symboltype *t)
{
    if (t->type == "VOID")
        return 0;
    else if (t->type == "ARR")
        return t->width * calculate_size(t->ptr);
    else if (t->type == "PTR")
        return POINTER_SIZE;
    else if (t->type == "CHAR")
        return CHAR_SIZE;
    else if (t->type == "FUNC")
        return 0;
    else if (t->type == "DOUBLE")
        return DOUBLE_SIZE;
    else if (t->type == "INTEGER")
        return INT_SIZE;
    return -1;
}

string print_type(symboltype *t)
{
    if (t == NULL)
        return "null";
    if (t->type == "VOID")
        return "void";
    else if (t->type == "CHAR")
        return "char";
    else if (t->type == "INTEGER")
        return "integer";
    else if (t->type == "DOUBLE")
        return "double";
    else if (t->type == "PTR")
        return "ptr(" + print_type(t->ptr) + ")";
    else if (t->type == "ARR")
    {
        stringstream strs;
        strs << t->width;
        string temp_str = strs.str();
        char *intStr = (char *)temp_str.c_str();
        string str = string(intStr);
        return "arr(" + str + ", " + print_type(t->ptr) + ")";
    }
    else if (t->type == "FUNC")
        return "function";
    else
        return "_";
}