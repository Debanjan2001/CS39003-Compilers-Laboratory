%{
    #include <bits/stdc++.h>

    #include "asgn5_19CS10048_19CS30014_translator.h"

    extern int yylex();
    void yyerror(const char* s);
    extern string var_type;
    extern vector<label> label_table;
    using namespace std;
%}

%union {
    int intval;
    int instr_num;
    int param_num;
    char* char_val;
    char u_op;
    Expression* exprss;
    Statement* stmt;
    symboltype* type_sym;
    sym* smb;
    Array* Arr;
}


%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY 

%token <smb> IDENTIFIER 
%token <intval> INTEGER_CONSTANT 
%token <char_val>FLOATING_CONSTANT CHARACTER_CONSTANT STRING_LITERAL ENUMERATION_CONSTANT

%token ARROW INC DEC MUL ADD SUB DIV MOD SHIFT_LEFT SHIFT_RIGHT
%token LT GT LTE GTE EQ NEQ BITWISE_XOR BITWISE_OR BITWISE_NOT BITWISE_AND AND OR 
%token COLON SEMICOLON ELLIPSIS ASSIGN 
%token MUL_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ SHIFT_LEFT_EQ SHIFT_RIGHT_EQ BITWISE_AND_EQ BITWISE_XOR_EQ BITWISE_OR_EQ 
%token COMMA HASH 

%start translation_unit

%right "then" ELSE

%type <u_op> unary_operator

%type <param_num> argument_expression_list 
                  argument_expression_list_opt

%type <exprss> 
               expression 
               primary_expression 
               multiplicative_expression 
               additive_expression
               AND_expression
               exclusive_OR_expression
               inclusive_OR_expression
               conditional_expression
               assignment_expression
               expression_statement
               equality_expression
               relational_expression
               shift_expression
               logical_AND_expression
               logical_OR_expression

%type <stmt> 
             iteration_statement
             labeled_statement
             loop_statement
             selection_statement
             jump_statement
             block_item
             block_item_list
             block_item_list_opt
             compound_statement
             statement

%type <type_sym> pointer

%type <smb> initializer

%type <smb> declarator 
            init_declarator 
            direct_declarator

%type <Arr> postfix_expression
            cast_expression
            unary_expression

%type <instr_num> M

%type <stmt> N

%%

M:  %empty
    {
        $$ = nextinstr();
    }
    ;

F:  %empty
    {
        loop_name = "FOR";
    }
    ;

W:  %empty
    {
        loop_name = "WHILE";
    }
    ;

D:  %empty
    {
        loop_name = "DO_WHILE";
    }
    ;

X:  %empty
    {
        string name = ST->name+"."+loop_name+"$"+to_string(table_count);
        table_count++;
        sym* s_table = ST->lookup(name);
        s_table->nested = new symtable(name);
        s_table->nested->parent = ST;
        s_table->name = name;
        s_table->type = new symboltype("block");
        currSymbolPtr = s_table;
    }
    ;

N:  %empty
    {
        $$ = new Statement();
        $$->nextlist = makelist(nextinstr());
        emit("goto", "");
    }
    ;

changetable:    %empty
                {
                    parST = ST;
                    if(currSymbolPtr->nested == NULL) {
                        changeTable(new symtable(""));
                    } else {
                        changeTable(currSymbolPtr->nested);
                        emit("label", ST->name);
                    }
                }
                ;

primary_expression: 
                    IDENTIFIER
                    {
                        $$ = new Expression();
                        $$->loc = $1;
                        $$->type = "not-boolean";
                    }
                    | INTEGER_CONSTANT 
                    {
                        $$ = new Expression();
                        string p = convInt2String($1);
                        $$->loc = gentemp(new symboltype("int"), p);
                        emit("=", $$->loc->name, p);
                    }
                    | FLOATING_CONSTANT 
                    {
                        $$ = new Expression();
                        $$->loc = gentemp(new symboltype("float"), $1);
                        emit("=", $$->loc->name, string($1));
                    }
                    | CHARACTER_CONSTANT
                    {
                        $$ = new Expression();
                        $$->loc = gentemp(new symboltype("char"), $1);
                        emit("=", $$->loc->name, string($1));
                    }
                    | STRING_LITERAL
                    {
                        $$ = new Expression();
                        $$->loc = gentemp(new symboltype("ptr"), $1);
                        $$->loc->type->arrtype = new symboltype("char");
                    }
                    | '(' expression ')'
                    {
                        $$ = $2;
                    }
                    ;

postfix_expression: 
                    primary_expression
                    {
                        $$ = new Array();
                        $$->Array = $1->loc;
                        $$->type = $1->loc->type;
                        $$->loc = $$->Array;
                    }
                    | postfix_expression '[' expression ']'
                    {
                        $$ = new Array();
                        $$->type = $1->type->arrtype;
                        $$->Array = $1->Array;
                        $$->loc = gentemp(new symboltype("int"));
                        $$->atype = "arr";
                        if($1->atype == "arr") {
                            sym* s = gentemp(new symboltype("int"));
                            int sze = computeSize($$->type);
                            string sizestr = convInt2String(sze);
                            emit("*", s->name, $3->loc->name, sizestr);
                            emit("+", $$->loc->name, $1->loc->name, s->name);
                        }
                        else {
                            int size = computeSize($$->type);
                            string sizestr = convInt2String(size);
                            emit("*", $$->loc->name, $3->loc->name, sizestr);
                        }
                    }
                    | postfix_expression '(' argument_expression_list_opt ')'
                    {
                        $$ = new Array();
                        $$-> Array = gentemp($1->type);
                        string str = convInt2String($3);
                        emit("call", $$->Array->name, $1->Array->name, str);
                    }
                    | postfix_expression '.' IDENTIFIER
                    {
                        ;//printf("| Rule: postfix_expression => postfix_expression.IDENTIFIER |\n");
                    }
                    | postfix_expression ARROW IDENTIFIER
                    {
                        ;//printf("| Rule: postfix_expression => postfix_expression->IDENTIFIER |\n");
                    }
                    | postfix_expression INC
                    {
                        $$ = new Array();
                        $$->Array =  gentemp($1->Array->type);
                        emit("=", $$->Array->name, $1->Array->name);
                        emit("+", $1-> Array->name, $1->Array->name, "1");
                    }
                    | postfix_expression DEC
                    {
                        $$ = new Array();
                        $$->Array =  gentemp($1->Array->type);
                        emit("=", $$->Array->name, $1->Array->name);
                        emit("-", $1-> Array->name, $1->Array->name, "1");
                    }
                    | '(' type_name ')' '{' initializer_list '}'
                    {
                        ;//printf("| Rule: postfix_expression => (type_name) { initializer_list } |\n");
                    }
                    | '(' type_name ')' '{' initializer_list COMMA '}'
                    {
                        ;//printf("| Rule: postfix_expression => (type_name) { initializer_list , } |\n");
                    }
                    ;


argument_expression_list:
                            assignment_expression
                            {
                                $$ = 1;
                                emit("param", $1->loc->name);
                            }
                            | argument_expression_list COMMA assignment_expression
                            {
                                $$ = $1 + 1;
                                //update_nextinstr();
                                emit("param", $3->loc->name);
                                //update_nextinstr();
                            }
                            ;

argument_expression_list_opt: 
                                argument_expression_list
                                {
                                    $$ = $1;
                                }
	                            | %empty
                                {
                                    $$ = 0;
                                }
                                ;


unary_expression: 
                    postfix_expression
                    {
                        $$ = $1;
                    }
                    | INC unary_expression
                    {
                        emit("+", $2->Array->name, $2->Array->name, "1");
                        $$ = $2;
                    }
                    | DEC unary_expression
                    {
                        emit("-", $2->Array->name, $2->Array->name, "1");
                        $$ = $2;
                    }
                    | unary_operator cast_expression
                    {
                        $$ = new Array();
                        switch($1)
                        {
                            case '&':
                                $$->Array = gentemp(new symboltype("ptr"));
                                $$->Array->type->arrtype = $2->Array->type;
                                emit("=&", $$->Array->name, $2->Array->name);
                                break;
                            
                            case '*':
                                $$->atype = "ptr";
                                $$->loc = gentemp($2->Array->type->arrtype);
                                $$->Array = $2->Array;
                                emit("=*", $$->loc->name, $2->Array->name);
                                break;
                            
                            case '+':
                                $$ = $2;
                                break;
                            
                            case '-':
                                $$->Array = gentemp(new symboltype($2->Array->type->type));
                                emit("uminus", $$->Array->name, $2->Array->name);
                                break;
                            
                            case '!':
                                $$->Array = gentemp(new symboltype($2->Array->type->type));
                                emit("!", $$->Array->name, $2->Array->name);
                                break;
                        }
                    }
                    | SIZEOF unary_expression
                    {
                        ;//printf("| Rule: unary_expression => sizeof unary_expression |\n");
                    }
                    | SIZEOF '(' type_name ')'
                    {
                        ;//printf("| Rule: unary_expression => sizeof(typename) |\n");
                    }
                    ;

unary_operator: 
                    BITWISE_AND
                    {
                        $$ = '&';
                    }
                    | MUL
                    {
                        $$ = '*';
                    }
                    | ADD
                    {
                        $$ = '+';
                    }
                    | SUB
                    {
                        $$ = '-';
                    }
                    | BITWISE_NOT
                    {
                        $$ = '~';
                    }
                    | '!'
                    {
                        $$ = '!';
                    }
                    ;

cast_expression: 
                    unary_expression
                    {
                        $$ = $1;
                    }
                    | '(' type_name ')' cast_expression
                    {
                        $$ = new Array();
                        $$->Array = convertType($4->Array, var_type);
                    }
                    ;

multiplicative_expression: 
                            cast_expression
                            {
                                $$ = new Expression();
                                if($1->atype == "arr") {
                                    $$->loc = gentemp($1->loc->type);
                                    emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);
                                } 
                                else if($1->atype == "ptr") {
                                    $$->loc = $1->loc;
                                } 
                                else {
                                    $$->loc = $1->Array;
                                }
                            }
                            | multiplicative_expression MUL cast_expression
                            {
                                if(!compareSymbolType($3->Array, $1->loc)) {
                                    yyerror("TYPE MISMATCH");
                                }
                                else {
                                    $$ = new Expression();
                                    $$->loc = gentemp(new symboltype($1->loc->type->type));
                                    emit("*",  $$->loc->name, $1->loc->name, $3->Array->name);
                                }
                            }
                            | multiplicative_expression DIV cast_expression
                            {
                                if(!compareSymbolType($3->Array, $1->loc)) {
                                    yyerror("TYPE MISMATCH");
                                }
                                else {
                                    $$ = new Expression();
                                    $$->loc = gentemp(new symboltype($1->loc->type->type));
                                    emit("/",  $$->loc->name, $1->loc->name, $3->Array->name);
                                }   
                            }
                            | multiplicative_expression MOD cast_expression
                            {
                                if(!compareSymbolType($3->Array, $1->loc)) {
                                    yyerror("TYPE MISMATCH");
                                }
                                else {
                                    $$ = new Expression();
                                    $$->loc = gentemp(new symboltype($1->loc->type->type));
                                    emit("%",  $$->loc->name, $1->loc->name, $3->Array->name);
                                }
                            }
                            ;

additive_expression:
                        multiplicative_expression
                        {
                            $$ = $1;
                        }
                        | additive_expression ADD multiplicative_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc)) {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                $$ = new Expression();
                                $$->loc = gentemp(new symboltype($1->loc->type->type));
                                emit("+",  $$->loc->name, $1->loc->name, $3->loc->name);
                            }
                        }
                        | additive_expression SUB multiplicative_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc)) {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                $$ = new Expression();
                                $$->loc = gentemp(new symboltype($1->loc->type->type));
                                emit("-",  $$->loc->name, $1->loc->name, $3->loc->name);
                            }
                        }
                        ;

shift_expression: 
                    additive_expression
                    {
                        $$ = $1;
                    }
                    | shift_expression SHIFT_LEFT additive_expression
                    {
                        if(!($3->loc->type->type == "int")) {
                            yyerror("TYPE MISMATCH");
                        }
                        else {
                            $$ = new Expression();
                            $$->loc = gentemp(new symboltype("int"));
                            emit("<<", $$->loc->name, $1->loc->name, $3->loc->name);
                        }
                    }
                    | shift_expression SHIFT_RIGHT additive_expression
                    {
                        if(!($3->loc->type->type == "int")) {
                            yyerror("TYPE MISMATCH");
                        }
                        else {
                            $$ = new Expression();
                            $$->loc = gentemp(new symboltype("int"));
                            emit(">>", $$->loc->name, $1->loc->name, $3->loc->name);
                        }
                    }
                    ;

relational_expression:
                        shift_expression
                        {
                            $$ = $1;
                        }
                        | relational_expression LT shift_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc))
                            {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                $$ = new Expression();
                                $$->type = "bool";
                                $$->truelist = makelist(nextinstr());
                                $$->falselist = makelist(nextinstr()+1);
                                emit("<", "", $1->loc->name, $3->loc->name);
                                emit("goto", "");
                            }
                        }
                        | relational_expression GT shift_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc))
                            {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                $$ = new Expression();
                                $$->type = "bool";
                                $$->truelist = makelist(nextinstr());
                                $$->falselist = makelist(nextinstr()+1);
                                emit(">", "", $1->loc->name, $3->loc->name);
                                emit("goto", "");
                            }
                        }
                        | relational_expression LTE shift_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc))
                            {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                $$ = new Expression();
                                $$->type = "bool";
                                $$->truelist = makelist(nextinstr());
                                $$->falselist = makelist(nextinstr()+1);
                                emit("<=", "", $1->loc->name, $3->loc->name);
                                emit("goto", "");
                            }
                        }
                        | relational_expression GTE shift_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc))
                            {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                $$ = new Expression();
                                $$->type = "bool";
                                $$->truelist = makelist(nextinstr());
                                $$->falselist = makelist(nextinstr()+1);
                                emit(">=", "", $1->loc->name, $3->loc->name);
                                emit("goto", "");
                            }
                        }
                        ;

equality_expression: 
                        relational_expression
                        {
                            $$ = $1;
                        }
                        | equality_expression EQ relational_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc))
                            {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                convBool2Int($1);
                                convBool2Int($3);
                                $$ = new Expression();
                                $$->type = "bool";
                                $$->truelist = makelist(nextinstr());
                                $$->falselist = makelist(nextinstr()+1);
                                emit("==", "", $1->loc->name, $3->loc->name);
                                emit("goto", "");
                            }
                        }
                        | equality_expression NEQ relational_expression
                        {
                            if(!compareSymbolType($1->loc, $3->loc))
                            {
                                yyerror("TYPE MISMATCH");
                            }
                            else {
                                convBool2Int($1);
                                convBool2Int($3);
                                $$ = new Expression();
                                $$->type = "bool";
                                $$->truelist = makelist(nextinstr());
                                $$->falselist = makelist(nextinstr()+1);
                                emit("!=", "", $1->loc->name, $3->loc->name);
                                emit("goto", "");
                            }
                        }
                        ;

AND_expression: 
                    equality_expression
                    {
                        $$ = $1;
                    }
                    | AND_expression BITWISE_AND equality_expression
                    {
                        if(!compareSymbolType($1->loc, $3->loc))
                        {
                            yyerror("TYPE MISMATCH");
                        }
                        else {
                            convBool2Int($1);
                            convBool2Int($3);
                            $$ = new Expression();
                            $$->type = "not-boolean";
                            $$->loc = gentemp(new symboltype("int"));
                            emit("&", $$->loc->name, $1->loc->name, $3->loc->name);
                        }
                    }
                    ;

exclusive_OR_expression: 
                            AND_expression
                            {
                                $$ = $1;
                            }
                            | exclusive_OR_expression BITWISE_XOR AND_expression
                            {
                                if(!compareSymbolType($1->loc, $3->loc))
                                {
                                    yyerror("TYPE MISMATCH");
                                }
                                else {
                                    convBool2Int($1);
                                    convBool2Int($3);
                                    $$ = new Expression();
                                    $$->type = "not-boolean";
                                    $$->loc = gentemp(new symboltype("int"));
                                    emit("^", $$->loc->name, $1->loc->name, $3->loc->name);
                                }
                            }
                            ;

inclusive_OR_expression: 
                            exclusive_OR_expression
                            {
                                $$ = $1;
                            }
                            | inclusive_OR_expression BITWISE_OR exclusive_OR_expression
                            {
                                if(!compareSymbolType($1->loc, $3->loc))
                                {
                                    yyerror("TYPE MISMATCH");
                                }
                                else {
                                    convBool2Int($1);
                                    convBool2Int($3);
                                    $$ = new Expression();
                                    $$->type = "not-boolean";
                                    $$->loc = gentemp(new symboltype("int"));
                                    emit("|", $$->loc->name, $1->loc->name, $3->loc->name);
                                }
                            }
                            ;

logical_AND_expression: 
                            inclusive_OR_expression
                            {
                                $$ = $1;
                            }
                            | logical_AND_expression AND M inclusive_OR_expression
                            {
                                convInt2Bool($1);
                                convInt2Bool($4);
                                $$ = new Expression();
                                $$->type = "bool";
                                backpatch($1->truelist, $3);
                                $$->truelist = $4->truelist;
                                $$->falselist = merge($1->falselist, $4->falselist);
                            }
                            ;

logical_OR_expression: 
                        logical_AND_expression
                        {printf("| Rule: logical_OR_expression => logical_AND_expression |\n");}
                        | logical_OR_expression OR M logical_AND_expression
                        {
                            convInt2Bool($1);
                            convInt2Bool($4);
                            $$ = new Expression();
                            $$->type = "bool";
                            backpatch($1->falselist, $3);
                            $$->falselist = $4->falselist;
                            $$->truelist = merge($1->truelist, $4->truelist);
                        }
                        ;

conditional_expression: 
                        logical_OR_expression
                        {
                            $$ = $1;
                        }
                        | logical_OR_expression N '?' M expression N COLON M conditional_expression
                        {
                            $$->loc = gentemp($5->loc->type);
                            $$->loc->update($5->loc->type);
                            emit("=", $$->loc->name, $9->loc->name);
                            list<int> l = makelist(nextinstr());
                            emit("goto", "");
                            backpatch($6->nextlist, nextinstr());
                            emit("=", $$->loc->name, $5->loc->name);
                            list<int> m = makelist(nextinstr());
                            l = merge(l, m);
                            emit("goto", "");
                            backpatch($2->nextlist, nextinstr());
                            convInt2Bool($1);
                            backpatch($1->truelist, $4);
                            backpatch($1->falselist, $8);
                            backpatch(l, nextinstr());   
                        }
                        ;

assignment_expression: 
                        conditional_expression
                        {
                            $$ = $1;
                        }
                        | unary_expression assignment_operator assignment_expression
                        {
                            if($1->atype == "arr") {
                                $3->loc = convertType($3->loc, $1->type->type);
                                emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);
                            }
                            else if($1->atype == "ptr") {
                                emit("*=", $1->Array->name, $3->loc->name);
                            }
                            else {
                                $3->loc = convertType($3->loc, $1->Array->type->type);
                                emit("=", $1->Array->name, $3->loc->name);
                            }

                            $$ = $3;

                        }
                        ;

assignment_operator: 
	ASSIGN
    {
        ;//printf("| Rule: assignment_operator => = |\n");
    }
	| MUL_EQ
    {
        ;//printf("| Rule: assignment_operator => *= |\n");
    }
	| DIV_EQ
    {
        ;//printf("| Rule: assignment_operator => /= |\n");
    }
	| MOD_EQ
    {
        ;//printf("| Rule: assignment_operator => modulo |\n");
    }
	| ADD_EQ
    {
        ;//printf("| Rule: assignment_operator => += |\n");
    }
	| SUB_EQ
    {
        ;//printf("| Rule: assignment_operator => -= |\n");
    }
	| SHIFT_LEFT_EQ
    {
        ;//printf("| Rule: assignment_operator => <<= |\n");
    }
	| SHIFT_RIGHT_EQ
    {
        ;//printf("| Rule: assignment_operator => >>= |\n");
    }
	| BITWISE_AND_EQ
    {
        ;//printf("| Rule: assignment_operator => &= |\n");
    }
	| BITWISE_XOR_EQ
    {
        ;//printf("| Rule: assignment_operator => ^= |\n");
    }
	| BITWISE_OR_EQ
	{
        ;//printf("| Rule: assignment_operator => |= |\n");
    }
	;

expression: 
            assignment_expression
            {
                $$ = $1;
            }
            | expression COMMA assignment_expression
            {
                ;//printf("| Rule: expression =>  expression , assignment_expression |\n");
            }
            ;

constant_expression: 
                    conditional_expression
                    {
                        ;//printf("| Rule: constant_expression => conditional_expression |\n");
                    }
                    ;   

declaration: 
	declaration_specifiers init_declarator_list_opt SEMICOLON
	{
        ;//printf("| Rule: declaration => declaration_specifiers init_declarator_list_opt ; |\n");
    }
	;

declaration_specifiers: 
                        storage_class_specifier declaration_specifiers_opt
                        {
                            ;//printf("| Rule: declaration_specifiers => storage_class_specifier declaration_specifiers_opt |\n");
                        }
                        | type_specifier declaration_specifiers_opt
                        {
                            ;//printf("| Rule: declaration_specifiers => type_specifier declaration_specifiers_opt |\n");
                        }
                        | type_qualifier declaration_specifiers_opt
                        {
                            ;//printf("| Rule: declaration_specifiers => type_qualifier declaration_specifiers_opt |\n");
                        }
                        | function_specifier declaration_specifiers_opt
                        {
                            ;//printf("| Rule: declaration_specifiers => function_specifier declaration_specifiers_opt |\n");
                        }
                        ;

declaration_specifiers_opt: 
                            declaration_specifiers
                            {
                                ;
                            }
                            | %empty /* epsilon */
                            {
                                ;
                            }
                            ;

init_declarator_list: 
                        init_declarator
                        {
                            ;//printf("| Rule: init_declarator_list => init_declarator |\n");
                        }
                        | init_declarator_list COMMA init_declarator
                        {
                            ;//printf("| Rule: init_declarator_list =>  init_declarator_list , init_declarator |\n");
                        }
	                    ;

init_declarator_list_opt:
	                        init_declarator_list
                            {
                                ;
                            }
	                        | %empty /* epsilon */
                            {
                                ;
                            }
	                        ;

init_declarator: 
	            declarator
                {
                    $$ = $1;
                }
	            | declarator ASSIGN initializer
	            {
                    if($3->val != "") {
                        $1->val = $3->val;
                    }
                    emit("=", $1->name, $3->name);
                }
	            ;

storage_class_specifier: 
                        EXTERN
                        {
                            ;//printf("| Rule: storage_class_specifier => extern |\n");
                        }
                        | STATIC
                        {
                            ;//printf("| Rule: storage_class_specifier => static |\n");
                        }
                        | AUTO
                        {
                            ;//printf("| Rule: storage_class_specifier => auto |\n");
                        }
                        | REGISTER
                        {
                            ;//printf("| Rule: storage_class_specifier => register |\n");
                        }
                        ;

type_specifier:
                VOID
                {
                    var_type = "void";
                }
                | CHAR
                {
                    var_type = "char";
                }
                | SHORT
                {
                    ;
                }
                | INT
                {
                    var_type = "int";
                }
                | LONG
                {
                    ;
                }
                | FLOAT
                {
                    var_type = "float";
                }
                | DOUBLE
                {
                    ;
                }
                | SIGNED
                {
                    ;
                }
                | UNSIGNED
                {
                    ;
                }
                | _BOOL
                {
                    ;
                }
                | _COMPLEX
                {
                    ;
                }
                | _IMAGINARY
                {
                    ;
                }
                | enum_specifier
                {
                    ;
                }
                ;

specifier_qualifier_list: 
                        type_specifier specifier_qualifier_list_opt
                        {
                            ;//printf("| Rule: specifier_qualifier_list => type_specifier specifier_qualifier_list_opt |\n");
                        }
                        | type_qualifier specifier_qualifier_list_opt
                        {
                            ;//-printf("| Rule: specifier_qualifier_list => type_qualifier specifier_qualifier_list_opt |\n");
                        }
                        ;

specifier_qualifier_list_opt: 
                            specifier_qualifier_list
                            {
                                ;
                            }
                            | %empty /* epsilon */
                            {
                                ;
                            }
                            ;


enum_specifier: 
                ENUM identifier_opt '{' enumerator_list '}'
                {
                    ;//printf("| Rule: enum_specifier => enum identifier_opt { enumerator_list } |\n");
                }
                | ENUM identifier_opt '{' enumerator_list COMMA '}'
                {
                    ;//printf("| Rule: enum_specifier =>  enum identifier_opt { enumerator_list , } |\n");
                }
                | ENUM IDENTIFIER
                {
                    ;//printf("| Rule: enum_specifier =>  enum IDENTIFIER |\n");
                }
                ;

identifier_opt:
                IDENTIFIER
                {
                    ;
                }
                | %empty /* epsilon */
                {
                    ;
                }
                ;

enumerator_list: 
                enumerator
                {
                    ;//printf("| Rule: enumerator_list => enumerator |\n");
                }
                | enumerator_list COMMA enumerator
                {
                    ;//printf("| Rule: enumerator_list => enumerator_list , enumerator |\n");
                }
                ;

enumerator: 
            ENUMERATION_CONSTANT
            {
                ;//printf("| Rule: enumerator => ENUMERATION_CONSTANT |\n");
            }
            | ENUMERATION_CONSTANT ASSIGN constant_expression
            {
                ;//printf("| Rule: enumerator => ENUMERATION_CONSTANT = constant_expression |\n");
            }
            ;

type_qualifier: 
                CONST
                {
                    ;//printf("| Rule: type_qualifier => const |\n");
                }
                | RESTRICT
                {
                    ;//printf("| Rule: type_qualifier => restrict |\n");
                }
                | VOLATILE
                {
                    ;//printf("| Rule: type_qualifier => volatile|\n");
                }
                ;

function_specifier: 
                    INLINE
                    {
                        ;//printf("| Rule: function_specifier => inline |\n");
                    }
                    ;

declarator: 
            pointer direct_declarator
            {
                symboltype *t = $1;
                while(t->arrtype != NULL) {
                    t = t->arrtype;
                }
                t->arrtype = $2->type;
                $$ = $2->update($1);
            }
            | direct_declarator 
            {
                ;
            }
            ;

direct_declarator: 
                    IDENTIFIER
                    {
                        $$ = $1->update(new symboltype(var_type));
                        currSymbolPtr = $$;
                    }
                    | '(' declarator ')'
                    {
                        $$ = $2;
                    }
                    | direct_declarator '['  type_qualifier_list assignment_expression ']'
                    {
                        ;//printf("| Rule: direct_declarator =>  direct_declarator [  type_qualifier_list_opt assignment_expression_opt ] |\n");
                    }
                    | direct_declarator '['  type_qualifier_list ']'
                    {
                        ;
                    }
                    | direct_declarator '[' assignment_expression ']'
                    {
                        symboltype *t=  $1->type;
                        symboltype *prev = NULL;
                        while(t->type == "arr") {
                            prev = t;
                            t = t->arrtype;
                        }

                        if(prev == NULL) {
                            int temp = atoi($3->loc->val.c_str());
                            symboltype* s = new symboltype("arr", $1->type, temp);
                            $$ = $1->update(s);
                        }
                        else {
                            prev->arrtype = new symboltype("arr", t, atoi($3->loc->val.c_str()));
                            $$ = $1->update($1->type);
                        }
                    }
                    | direct_declarator '[' ']'
                    {
                        symboltype *t=  $1->type;
                        symboltype *prev = NULL;
                        while(t->type == "arr") {
                            prev = t;
                            t = t->arrtype;
                        }

                        if(prev == NULL) {
                            symboltype* s = new symboltype("arr", $1->type, 0);
                            $$ = $1->update(s);
                        }
                        else {
                            prev->arrtype = new symboltype("arr", t, 0);
                            $$ = $1->update($1->type);
                        }
                    }
                    | direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']'
                    {
                        ;//printf("| Rule: direct_declarator =>  direct_declarator [ static type_qualifier_list_opt assignment_expression ] |\n");
                    }
                    | direct_declarator '[' type_qualifier_list_opt MUL ']'
                    {
                        ;//printf("| Rule: direct_declarator =>  direct_declarator [ type_qualifier_list_opt * ] |\n");
                    }
                    | direct_declarator '(' changetable parameter_type_list ')'
                    {
                        ST->name = $1->name;
                        if($1->type->type != "void") {
                            sym* s = ST->lookup("return");
                            s->update($1->type);
                        }
                        $1->nested = ST;
                        ST->parent = globalST;
                        changeTable(globalST);
                        currSymbolPtr = $$;
                    }
                    | direct_declarator '(' identifier_list ')'
                    {
                        ;//printf("| Rule: direct_declarator =>  direct_declarator ( identifier_list_opt ) |\n");
                    }
                    | direct_declarator '(' changetable ')'
                    {
                        ST->name = $1->name;
                        if($1->type->type != "void") {
                            sym* s = ST->lookup("return");
                            s->update($1->type);
                        }
                        $1->nested = ST;
                        ST->parent = globalST;
                        changeTable(globalST);
                        currSymbolPtr = $$;
                    }
                    ;

pointer: 
        MUL type_qualifier_list_opt
        {
            $$ = new symboltype("ptr");
        }
        | MUL type_qualifier_list_opt pointer
        {
            $$ = new symboltype("ptr", $3);
        }
        ;

type_qualifier_list: 
                    type_qualifier
                    {
                        ;//printf("| Rule: type_qualifier_list => type_qualifier |\n");
                    }
                    | type_qualifier_list type_qualifier
                    {
                        ;//printf("| Rule: type_qualifier_list => type_qualifier_list type_qualifier |\n");
                    }
                    ;


type_qualifier_list_opt: 
                        type_qualifier_list
                        {
                            ;
                        }
                        | %empty /* epsilon */
                        {
                            ;
                        }
                        ;


parameter_type_list: 
                    parameter_list
                    {
                        ;//printf("| Rule: parameter_type_list => parameter_list |\n");
                    }
                    | parameter_list COMMA ELLIPSIS
                    {
                        ;//printf("| Rule: parameter_type_list =>  parameter_list , ... |\n");
                    }
                    ;

parameter_list: 
                parameter_declaration
                {
                    ;//printf("| Rule: parameter_list => parameter_declaration |\n");
                }
                | parameter_list COMMA parameter_declaration
                {
                    ;//printf("| Rule: parameter_list =>  parameter_list , parameter_declaration |\n");
                }
                ;

parameter_declaration: 
                        declaration_specifiers declarator
                        {
                            ;//printf("| Rule: parameter_declaration => declaration_specifiers declarator |\n");
                        }
                        | declaration_specifiers
                        {
                            ;//printf("| Rule: parameter_declaration => declaration_specifiers |\n");
                        }
                        ;

identifier_list: 
                IDENTIFIER
                {
                    ;//printf("| Rule: identifier_list => IDENTIFIER |\n");
                }
                | identifier_list COMMA IDENTIFIER
                {
                    ;//printf("| Rule: identifier_list => identifier_list , IDENTIFIER |\n");
                }
                ;

type_name: 
            specifier_qualifier_list
            {
                ;//printf("| Rule: type_name => specifier_qualifier_list |\n");
            }
            ;

initializer: 
            assignment_expression
            {
                $$ = $1->loc;
            }
            | '{' initializer_list '}'
            {
                ;//printf("| Rule: initializer => { initializer_list } |\n");
            }
            | '{' initializer_list COMMA '}'
            {
                ;//printf("| Rule: initializer => { initializer_list , } |\n");
            }
            ;

initializer_list: 
                    designation_opt initializer
                    {
                        ;//printf("| Rule: initializer_list => designation_opt initializer |\n");
                    }
                    | initializer_list COMMA designation_opt initializer
                    {
                        ;//printf("| Rule: initializer_list => initializer_list , designation_opt initializer |\n");
                    }
                    ;

designation_opt:
                designation 
                {
                    ;
                }
                | %empty /* epsilon */
                {
                    ;
                }
                ;

designation: 
	        designator_list ASSIGN
	        {
                ;//printf("| Rule: designation => designator_list = |\n");
            }
	        ;

designator_list: 
                designator
                {
                    ;//printf("| Rule: designator_list => designator |\n");
                }
                | designator_list designator
                {
                    ;//printf("| Rule: designator_list => designator_list designator |\n");
                }
                ;

designator: 
	'[' constant_expression ']'
    {
        ;//printf("| Rule: designator => [ constant_expression ] |\n");
    }
	| '.' IDENTIFIER
	{
        ;//printf("| Rule: designator => . IDENTIFIER |\n");
    }
	;

statement: 
            labeled_statement
            {
                ;//printf("| Rule: statement => labeled_statement |\n");
            }
            | compound_statement
            {
                $$ = $1;
            }
            | expression_statement
            {
                $$ = new Statement();
                $$->nextlist = $1->nextlist;
            }
            | selection_statement
            {
                $$ = $1;
            }
            | iteration_statement
            {
                $$ = $1;
            }
            | jump_statement
            {
                $$ = $1;
            }
            ;

loop_statement: 
                labeled_statement
                {
                    ;
                }
                | expression_statement
                {
                    $$ = new Statement();
                    $$->nextlist = $1->nextlist;
                }
                | selection_statement
                {
                    $$ = $1;
                }
                | iteration_statement
                {
                    $$ = $1;
                }
                | jump_statement
                {
                    $$ = $1;
                }
                ;

labeled_statement: 
                    IDENTIFIER COLON M statement
                    {
                        $$ = $4;
                        label *s = find_label($1->name);
                        if(s != nullptr) {
                            s->addr = $3;
                            backpatch(s->nextlist, s->addr);
                        }
                        else {
                            s = new label($1->name);
                            s->addr = nextinstr();
                            s->nextlist = makelist($3);
                            label_table.push_back(*s);
                        }
                    }
                    | CASE constant_expression COLON statement
                    {
                        ;//printf("| Rule: labeled_statement => case constant_expression : statement |\n");
                    }
                    | DEFAULT COLON statement
                    {
                        ;//printf("| Rule: labeled_statement => default : statement |\n");
                    }
                    ;

compound_statement: 
                    '{' X changetable block_item_list_opt '}'
                    {
                        $$ = $4;
                        changeTable(ST->parent);
                    }
                    ;


block_item_list: 
                block_item
                {
                    $$ = $1;
                }
                | block_item_list M block_item
                {
                    $$ = $3;
                    backpatch($1->nextlist, $2);
                }
                ;

block_item_list_opt: 
                    block_item_list
                    {
                        $$ = $1;
                    }
                    | %empty /* epsilon */
                    {
                        $$ = new Statement();
                    }
                    ;

block_item: 
            declaration
            {
                $$ = new Statement();
            }
            | statement
            {
                $$ = $1;
            }
            ;

expression_statement: 
                        expression SEMICOLON
                        {
                            $$ = $1;
                        }
                        | SEMICOLON 
                        {
                            $$ = new Expression();
                        }
                        ;

selection_statement: 
                    IF '(' expression N ')' M statement N %prec "then"
                    {
                        backpatch($4->nextlist, nextinstr());
                        convInt2Bool($3);
                        $$ = new Statement();
                        backpatch($3->truelist, $6);
                        list<int> temp = merge($3->falselist, $7->nextlist);
                        $$->nextlist = merge($8->nextlist, temp);
                    }
                    | IF '(' expression N ')' M statement N ELSE M statement
                    {
                        backpatch($4->nextlist, nextinstr());
                        convInt2Bool($3);
                        $$ = new Statement();
                        backpatch($3->truelist, $6);
                        backpatch($3->falselist, $10);
                        list<int> temp = merge($7->nextlist, $8->nextlist);
                        $$->nextlist = merge($11->nextlist, temp);
                    }
                    | SWITCH '(' expression ')' statement
                    {
                        ;//printf("| Rule: selection_statement => switch ( expression ) statement |\n");
                    }
                    ;

iteration_statement:
                    WHILE W '(' X changetable M expression ')' M loop_statement
                    {
                        $$ = new Statement();
                        convInt2Bool($7);
                        backpatch($10->nextlist, $6);
                        backpatch($7->truelist, $9);
                        $$->nextlist = $7->falselist;
                        string str = convInt2String($6);
                        emit("goto", str);
                        loop_name = "";
                        changeTable(ST->parent);
                    }
                    | WHILE W '(' X changetable M expression ')' '{' M block_item_list_opt '}'
                    {
                        $$ = new Statement();
                        convInt2Bool($7);
                        backpatch($11->nextlist, $6);
                        backpatch($7->truelist, $10);
                        $$->nextlist = $7->falselist;
                        string str = convInt2String($6);
                        emit("goto", str);
                        loop_name = "";
                        changeTable(ST->parent);
                    }
                    | DO D M loop_statement M WHILE '(' expression ')' SEMICOLON
                    {
                        $$ = new Statement();
                        convInt2Bool($8);
                        backpatch($8->truelist, $3);
                        backpatch($4->nextlist, $5);
                        $$->nextlist = $8->falselist;
                        loop_name = "";
                    }
                    | DO D '{' M block_item_list_opt '}' M WHILE '(' expression ')' SEMICOLON
                    {
                        $$ = new Statement();
                        convInt2Bool($10);
                        backpatch($10->truelist, $4);
                        backpatch($5->nextlist, $7);
                        $$->nextlist = $10->falselist;
                        loop_name = "";
                    }
                    | FOR F '(' X changetable declaration M expression_statement M expression N ')' M loop_statement
                    {
                        $$ = new Statement();
                        convInt2Bool($8);
                        backpatch($8->truelist, $13);
                        backpatch($11->nextlist, $7);
                        backpatch($14->nextlist, $9);
                        string str = convInt2String($9);
                        emit("goto", str);
                        $$->nextlist = $8->falselist;
                        loop_name = "";
                        changeTable(ST->parent);
                    }
                    | FOR F '(' X changetable expression_statement M expression_statement M expression N ')' M loop_statement
                    {
                        $$ = new Statement();
                        convInt2Bool($8);
                        backpatch($8->truelist, $13);
                        backpatch($11->nextlist, $7);
                        backpatch($14->nextlist, $9);
                        string str = convInt2String($9);
                        emit("goto", str);
                        $$->nextlist = $8->falselist;
                        loop_name = "";
                        changeTable(ST->parent);
                    }
                    | FOR F '(' X changetable declaration M expression_statement M expression N ')' M '{' block_item_list_opt '}'
                    {
                        $$ = new Statement();
                        convInt2Bool($8);
                        backpatch($8->truelist, $13);
                        backpatch($11->nextlist, $7);
                        backpatch($15->nextlist, $9);
                        string str = convInt2String($9);
                        emit("goto", str);
                        $$->nextlist = $8->falselist;
                        loop_name = "";
                        changeTable(ST->parent);
                    }
                    | FOR F '(' X changetable expression_statement M expression_statement M expression N ')' M '{' block_item_list_opt '}'
                    {
                        $$ = new Statement();
                        convInt2Bool($8);
                        backpatch($8->truelist, $13);
                        backpatch($11->nextlist, $7);
                        backpatch($15->nextlist, $9);
                        string str = convInt2String($9);
                        emit("goto", str);
                        $$->nextlist = $8->falselist;
                        loop_name = "";
                        changeTable(ST->parent);
                    }
                    ;

jump_statement: 
                GOTO IDENTIFIER SEMICOLON
                {
                    $$ = new Statement();
                    label *l = find_label($2->name);
                    if(l) {
                        emit("goto", "");
                        list<int> lst = makelist(nextinstr());
                        l->nextlist = merge(l->nextlist, lst);
                        if(l->addr != -1) {
                            backpatch(l->nextlist, l->addr);
                        }
                        else {
                            l = new label($2->name);
                            l->nextlist = makelist(nextinstr());
                            emit("goto", "");
                            label_table.push_back(*l);
                        }
                    }
                }
                | CONTINUE SEMICOLON
                {
                    $$ = new Statement();
                }
                | BREAK SEMICOLON
                {
                    $$ = new Statement();
                }
                | RETURN expression SEMICOLON
                {
                    $$ = new Statement();
                    emit("return", $2->loc->name);
                }
                | RETURN SEMICOLON 
                {
                    $$ = new Statement();
                    emit("return", "");
                }
                ;

translation_unit: 
                external_declaration
                {
                    ;//printf("| Rule: translation_unit => external_declaration|\n");
                }
                | translation_unit external_declaration
                {
                    ;//printf("| Rule: translation_unit => translation_unit external_declaration |\n");
                }
                ;

external_declaration: 
                    function_definition
                    {
                        ;//printf("| Rule: external_declaration => function_definition |\n");
                    }
                    | declaration
                    {
                        ;//printf("| Rule: external_declaration => declaration |\n");
                    }
                    ;

function_definition: 
                    declaration_specifiers declarator declaration_list_opt changetable '{' block_item_list_opt '}'
                    {
                        int next_instr = 0;
                        ST->parent = globalST;
                        table_count = 0;
                        label_table.clear();
                        changeTable(globalST);
                    }
                    ;

declaration_list_opt: 
                    declaration_list
                    {
                        ;
                    }
                    | %empty /* epsilon */
                    {
                        ;
                    }
                    ;

declaration_list: 
                declaration
                {
                    ;//printf("| Rule: declaration_list => declaration |\n");
                }
                | declaration_list declaration
                {
                    ;//printf("| Rule: declaration_list => declaration_list declaration |\n");
                }
                ;

%%

void yyerror(const char* s)
{
    printf("ERROR DETECTED: %s\n", s);
}