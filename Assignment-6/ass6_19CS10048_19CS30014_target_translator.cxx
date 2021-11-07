/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 : Target Translator
------------------------------------------*/

#include "ass6_19CS10048_19CS30014_translator.h"
#include <bits/stdc++.h>

extern FILE *yyin;
extern vector<string> allstr;

using namespace std;

int labelCount = 0;
map<int, int> labelMap;
ofstream out;
vector<quad> quadArr;
string assmfilename = "ass6_19CS10048_19CS30014_";
string inputfile = "ass6_19CS10048_19CS30014_test";

void computeActivationRecord(symtable *ST)
{
    int param = -20;
    int local = -24;

    for (list<sym>::iterator it = ST->table.begin(); it != ST->table.end(); it++)
    {
        if (it->category == "param")
        {
            ST->ar[it->name] = param;
            param += it->size;
        }
        else if (it->name == "return")
            continue;
        else
        {
            ST->ar[it->name] = local;
            local -= it->size;
        }
    }
}

void genAssembly()
{
    quadArr = q.Array;

    for (vector<quad>::iterator it = quadArr.begin(); it != quadArr.end(); it++)
    {
        int i;

        if (it->op == "GOTOOP" || it->op == "LT" || it->op == "GT" || it->op == "LE" || it->op == "GE" || it->op == "EQOP" || it->op == "NEOP")
        {
            i = atoi(it->result.c_str());
            labelMap[i] = 1;
        }
    }

    int count = 0;
    for (map<int, int>::iterator it = labelMap.begin(); it != labelMap.end(); it++)
    {
        it->second = count;
        count += 1;
    }

    list<symtable *> tablelist;
    for (list<sym>::iterator it = globalTable->table.begin(); it != globalTable->table.end(); it++)
    {
        if (it->nested != NULL)
            tablelist.push_back(it->nested);
    }

    for (list<symtable *>::iterator it = tablelist.begin(); it != tablelist.end(); it++)
    {
        computeActivationRecord(*it);
    }

    ofstream assmFile;
    assmFile.open(assmfilename.c_str());

    assmFile << "\t.file    \"test.c\"\n";
    for (list<sym>::iterator it = table->table.begin(); it != table->table.end(); it++)
    {
        if (it->category != "function")
        {
            if (it->type->type == "CHAR")
            {
                if (it->initial_value != "")
                {
                    assmFile << "\t.globl\t" << it->name << endl;
                    assmFile << "\t.type\t" << it->name << ", @object" << endl;
                    assmFile << "\t.size\t" << it->name << ", 1" << endl;
                    assmFile << it->name << ":\n";
                    assmFile << "\t.byte\t" << atoi(it->initial_value.c_str()) << endl;
                }
                else
                {
                    assmFile << "\t.comm\t" << it->name << ", 1, 1\n";
                }
            }

            if (it->type->type == "INT")
            {
                if (it->initial_value != "")
                {
                    assmFile << "\t.globl\t" << it->name << endl;
                    assmFile << "\t.data\n";
                    assmFile << "\t.align 4\n";
                    assmFile << "\t.type\t" << it->name << ", @object" << endl;
                    assmFile << "\t.size\t" << it->name << ", 4" << endl;
                    assmFile << it->name << ":\n";
                    assmFile << "\t.long\t" << it->initial_value << endl;
                }
                else
                {
                    assmFile << "\t.comm\t" << it->name << ", 4, 4" << endl;
                }
            }
        }
    }

    if (allstr.size())
    {
        assmFile << "\t.section\t.rodata" << endl;
        for (vector<string>::iterator it = allstr.begin(); it != allstr.end(); it++)
        {
            assmFile << ".LC" << it - allstr.begin() << ":" << endl;
            assmFile << "\t.string\t" << *it << "\n";
        }
    }

    assmFile << "\t.text\t\n";
    vector<string> params;
    map<string, int> tmap;
    for (vector<quad>::iterator it = quadArr.begin(); it != quadArr.end(); it++)
    {
        if (labelMap.count(it - quadArr.begin()))
        {
            assmFile << ".L" << (2 * labelCount + labelMap.at(it - quadArr.begin()) + 2) << ": " << endl;
        }

        string op = it->op;
        string result = it->result;
        string arg1 = it->arg1;
        string arg2 = it->arg2;
        string s = arg2;

        if (op == "PARAM")
        {
            params.push_back(result);
        }
        else
        {
            assmFile << "\t";
            if (op == "ADD")
            {
                bool flag = true;
                if (s.empty() || ((!isdigit(s[0])) && s[0] != '-' && s[0] != '+'))
                    flag = false;
                else
                {
                    char *p;
                    strtol(s.c_str(), &p, 10);
                    if (*p == 0)
                        flag = true;
                    else
                        flag = false;
                }

                if (flag)
                {
                    assmFile << "addl \t$" << atoi(arg2.c_str()) << ", " << table->ar[arg1] << "(%rbp)";
                }
                else
                {
                    assmFile << "movl \t" << table->ar[arg1] << "(%rbp), "
                             << "%eax" << endl;
                    assmFile << "\tmovl \t" << table->ar[arg2] << "(%rbp), "
                             << "%edx" << endl;
                    assmFile << "\taddl \t%edx, %eax" << endl;
                    assmFile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
                }
            }
            else if (op == "SUB")
            {
                assmFile << "movl \t" << table->ar[arg1] << "(%rbp), "
                         << "%eax" << endl;
                assmFile << "\tmovl \t" << table->ar[arg2] << "(%rbp), "
                         << "%edx" << endl;
                assmFile << "\tsubl \t%edx, %eax" << endl;
                assmFile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "MULT")
            {
                assmFile << "movl \t" << table->ar[arg1] << "(%rbp), %eax" << endl;

                bool flag = true;
                if (s.empty() || ((!isdigit(s[0])) && s[0] != '-' && s[0] != '+'))
                    flag = false;
                else
                {
                    char *p;
                    strtol(s.c_str(), &p, 10);
                    if (*p == 0)
                        flag = true;
                    else
                        flag = false;
                }

                if (flag)
                {
                    assmFile << "\timull \t$" << atoi(arg2.c_str()) << ", %eax" << endl;
                    symtable *t = table;
                    string val;
                    for (list<sym>::iterator it = t->table.begin(); it != t->table.end(); it++)
                    {
                        if (it->name == arg1)
                            val = it->initial_value;
                    }
                    tmap[result] = atoi(arg2.c_str()) * atoi(val.c_str());
                }
                else
                    assmFile << "\timull \t" << table->ar[arg2] << "(%rbp),  %eax" << endl;
                assmFile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "DIVIDE")
            {
                assmFile << "movl \t" << table->ar[arg1] << "(%rbp), "
                         << "%eax" << endl;
                assmFile << "\tcltd" << endl;
                assmFile << "\tidivl \t" << table->ar[arg2] << "(%rbp)" << endl;
                assmFile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "MODOP")
            {
                assmFile << result << " = " << arg1 << " % " << arg2;
            }
            else if (op == "INOR")
            {
                assmFile << result << " = " << arg1 << " | " << arg2;
            }
            else if (op == "XOR")
            {
                assmFile << result << " = " << arg1 << " ^ " << arg2;
            }
            else if (op == "BAND")
            {
                assmFile << result << " = " << arg1 << " & " << arg2;
            }
            else if (op == "LEFTOP")
            {
                assmFile << result << " = " << arg1 << " << " << arg2;
            }
            else if (op == "RIGHTOP")
            {
                assmFile << result << " = " << arg1 << " >> " << arg2;
            }
            else if (op == "EQUAL")
            {
                s = arg1;
                bool flag = true;
                if (s.empty() || ((!isdigit(s[0])) && s[0] != '-' && s[0] != '+'))
                    flag = false;
                else
                {
                    char *p;
                    strtol(s.c_str(), &p, 10);
                    if (*p == 0)
                        flag = true;
                    else
                        flag = false;
                }

                if (flag)
                {
                    assmFile << "movl\t$" << atoi(arg1.c_str()) << ", %eax" << endl;
                }
                else
                {
                    assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                }
                assmFile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "EQUALSTR")
            {
                assmFile << "movq \t$.LC" << arg1 << ", " << table->ar[result] << "(%rbp)";
            }
            else if (op == "EQUALCHAR")
            {
                assmFile << "movb \t$" << atoi(arg1.c_str()) << ", " << table->ar[result] << "(%rbp)";
            }
            else if (op == "EQOP")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                assmFile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
                assmFile << "\tje .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "NEOP")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                assmFile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
                assmFile << "\tjne .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "LT")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                assmFile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
                assmFile << "\tjl .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "GT")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                assmFile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
                assmFile << "\tjg .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "LE")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                assmFile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
                assmFile << "\tjle .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "GE")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %eax" << endl;
                assmFile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
                assmFile << "\tjge .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "GOTOOP")
            {
                assmFile << "jmp .L" << (2 * labelCount + labelMap.at(atoi(result.c_str())) + 2);
            }
            else if (op == "ADDRESS")
            {
                assmFile << "leaq\t" << table->ar[arg1] << "(%rbp), %rax\n";
                assmFile << "\tmovq \t%rax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "PTRR")
            {
                assmFile << "movl\t" << table->ar[arg1] << "(%rbp), %rax\n";
                assmFile << "\tmovl \t(%eax), %eax" << endl;
                assmFile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "PTRL")
            {
                assmFile << "movl\t" << table->ar[result] << "(%rbp), %eax\n";
                assmFile << "\tmovl\t" << table->ar[arg1] << "(%rbp), %edx\n";
                assmFile << "\tmovl\t%edx, (%eax)";
            }
            else if (op == "UMINUS")
            {
                assmFile << "negl\t" << table->ar[arg1] << "(%rbp)";
            }
            else if (op == "BNOT")
            {
                assmFile << result << "= ~" << arg1;
            }
            else if (op == "LNOT")
            {
                assmFile << result << " = !" << arg2;
            }
            else if (op == "ARRR")
            {
                int offset = tmap[arg2] * (-1) + table->ar[arg1];
                assmFile << "movq\t" << offset << "(%rbp), %rax" << endl;
                assmFile << "\tmovq \t%rax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "ARRL")
            {
                int offset = tmap[arg1] * (-1) + table->ar[result];
                assmFile << "movq\t" << table->ar[arg2] << "(%rbp), %rdx" << endl;
                assmFile << "\tmovq\t%rdx, " << offset << "(%rbp)";
            }
            else if (op == "RETURN")
            {
                if (result != "")
                    assmFile << "movl\t" << table->ar[result] << "(%rbp), %eax" << endl;
                else
                    assmFile << "nop";
            }
            else if (op == "PARAM")
            {
                params.push_back(result);
            }
            else if (op == "CALL")
            {
                symtable *t = globalTable->lookup(arg1)->nested;
                int i, j = 0;
                for (list<sym>::iterator it = t->table.begin(); it != t->table.end(); it++)
                {
                    i = distance(t->table.begin(), it);
                    if (it->category == "param")
                    {
                        switch (j)
                        {
                        case 0:
                            assmFile << "movl \t" << table->ar[params[i]] << "(%rbp), %eax\n";
                            assmFile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), %rdi\n";
                            j++;
                            break;

                        case 1:
                            assmFile << "movl \t" << table->ar[params[i]] << "(%rbp), %eax\n";
                            assmFile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), %rsi\n";
                            j++;
                            break;

                        case 2:
                            assmFile << "movl \t" << table->ar[params[i]] << "(%rbp), %eax\n";
                            assmFile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), %rdx\n";
                            j++;
                            break;

                        case 3:
                            assmFile << "movl \t" << table->ar[params[i]] << "(%rbp), %eax\n";
                            assmFile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), %rcx\n";
                            j++;
                            break;

                        default:
                            assmFile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), %rdi" << endl;
                        }
                    }
                    else
                    {
                        break;
                    }
                }
                params.clear();
                assmFile << "\tcall\t" << arg1 << endl;
                assmFile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)";
            }
            else if (op == "FUNC")
            {
                assmFile << ".globl\t" << result << endl;
                assmFile << "\t.type\t" << result << ", @function" << endl;
                assmFile << result << ": \n";
                assmFile << ".LFB" << labelCount << ":" << endl;
                assmFile << "\t.cfi_startproc\n";
                assmFile << "\tpushq \t%rbp" << endl;
                assmFile << "\t.cfi_def_cfa_offset 8" << endl
                         << "\t.cfi_offset 5, -8" << endl;
                assmFile << "\tmovq \t%rsp, %rbp" << endl;
                assmFile << "\t.cfi_def_cfa_register 5" << endl;
                table = globalTable->lookup(result)->nested;
                assmFile << "\tsubq\t$" << table->table.back().offset + 24 << ", %rsp" << endl;

                symtable *t = table;
                int i = 0;
                for (list<sym>::iterator it = t->table.begin(); it != t->table.end(); it++)
                {
                    if (it->category == "param")
                    {
                        switch (i)
                        {
                        case 0:
                            assmFile << "\tmovq\t%rdi, " << table->ar[it->name] << "(%rbp)";
                            i++;
                            break;
                        case 1:
                            assmFile << "\n\tmovq\t%rsi, " << table->ar[it->name] << "(%rbp)";
                            i++;
                            break;
                        case 2:
                            assmFile << "\n\tmovq\t%rdx, " << table->ar[it->name] << "(%rbp)";
                            i++;
                            break;
                        case 3:
                            assmFile << "\n\tmovq\t%rcx, " << table->ar[it->name] << "(%rbp)";
                            i++;
                            break;
                        default:
                            break;
                        }
                    }
                    else
                        break;
                }
            }
            else if (op == "FUNCEND")
            {
                assmFile << "leave\n";
                assmFile << "\t.cfi_restore 5\n"
                         << "\t.cfi_def_cfa 4, 4\n";
                assmFile << "\tret\n";
                assmFile << "\t.cfi_endproc" << endl;
                assmFile << ".LFE" << labelCount++ << ":" << endl;
                assmFile << "\t.size\t" << result << ", .-" << result;
            }
            else
            {
                // assmFile << "op";
            }

            assmFile << endl;
        }
    }
    assmFile << "\t.ident\t\t\"Compiler By : Group 21, CompilerLab, TinyC\" \n";
    assmFile << "\t.section\t.note.GNU-stack,\"\",@progbits\n";
    assmFile.close();
}

template <class T>
ostream &operator<<(ostream &os, const vector<T> &v)
{
    copy(v.begin(), v.end(), ostream_iterator<T>(os, " "));
    return os;
}

int main(int argc, char *argv[])
{
    inputfile = inputfile + string(argv[argc - 1]) + string(".c");
    assmfilename = assmfilename + string(argv[argc - 1]) + string(".s");
    globalTable = new symtable("Global");
    table = globalTable;
    yyin = fopen(inputfile.c_str(), "r");
    yyparse();
    globalTable->update();
    globalTable->print();
    q.print();
    genAssembly();
}