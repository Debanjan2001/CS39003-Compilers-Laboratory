%{
    #include<stdio.h>
    extern int yylex();
    void yyerror(char* s);
%}

%union {
    int intval;
}


%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY 

%token IDENTIFIER INTEGER_CONSTANT FLOATING_CONSTANT CHARACTER_CONSTANT STRING_LITERAL ENUMERATION_CONSTANT

%token ARROW INC DEC MUL ADD SUB EXCLAIM DIV MOD SHIFT_LEFT SHIFT_RIGHT
%token LT GT LTE GTE EQ NEQ BITWISE_XOR BITWISE_OR BITWISE_NOT BITWISE_AND AND OR 
%token COLON SEMICOLON ELLIPSIS ASSIGN 
%token MUL_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ SHIFT_LEFT_EQ SHIFT_RIGHT_EQ BITWISE_AND_EQ BITWISE_XOR_EQ BITWISE_OR_EQ 
%token COMMA HASH 

%nonassoc ')'

%nonassoc ELSE

%start translation_unit
%%
primary_expression: 
                    IDENTIFIER
                    | constant
                    | STRING_LITERAL
                    | '(' expression ')'
                    {printf("| Rule: primary_expression |\n");}
                    ;

constant: 
            INTEGER_CONSTANT 
            | FLOATING_CONSTANT 
            | CHARACTER_CONSTANT
            ;



postfix_expression: 
                    primary_expression
                    | postfix_expression '[' expression ']'
                    | postfix_expression '(' argument_expression_list_opt ')'
                    | postfix_expression '.' IDENTIFIER
                    | postfix_expression ARROW IDENTIFIER
                    | postfix_expression INC
                    | postfix_expression DEC
                    | '(' type_name ')' '{' initializer_list '}'
                    | '(' type_name ')' '{' initializer_list COMMA '}'
                    {printf("| Rule: postfix_expression |\n");}
                    ;


argument_expression_list:
                            assignment_expression
                            | argument_expression_list COMMA assignment_expression
                            {printf("| Rule: argument_expression_list |\n");}
                            ;

argument_expression_list_opt
	: argument_expression_list
	| /* epsilon */
    ;


unary_expression: 
                    postfix_expression
                    | INC unary_expression
                    | DEC unary_expression
                    | unary_operator cast_expression
                    | SIZEOF unary_expression
                    | SIZEOF '(' type_name ')'
                    {printf("| Rule: unary_expression |\n");}
                    ;

unary_operator: 
                    BITWISE_AND
                    | MUL
                    | ADD
                    | SUB
                    | BITWISE_NOT
                    | '!'
                    { printf("| Rule: unary_operator |\n"); }
                    ;

cast_expression: 
                    unary_expression
                    | '(' type_name ')' cast_expression
                    {printf("| Rule: cast_expression |\n");}
                    ;

multiplicative_expression: 
                            cast_expression
                            | multiplicative_expression MUL cast_expression
                            | multiplicative_expression DIV cast_expression
                            | multiplicative_expression MOD cast_expression
                            {printf("| Rule: multiplicative_expression |\n");}
                            ;

additive_expression: 
                        multiplicative_expression
                        | additive_expression ADD multiplicative_expression
                        | additive_expression SUB multiplicative_expression
                        {printf("| Rule: additive_expression |\n");}
                        ;

shift_expression: 
                    additive_expression
                    | shift_expression SHIFT_LEFT additive_expression
                    | shift_expression SHIFT_RIGHT additive_expression
                    {printf("| Rule: shift_expression |\n");}
                    ;

relational_expression:
                        shift_expression
                        | relational_expression LT shift_expression
                        | relational_expression GT shift_expression
                        | relational_expression LTE shift_expression
                        | relational_expression GTE shift_expression
                        {printf("| Rule: relational_expression |\n");}
                        ;

equality_expression: 
                        relational_expression
                        | equality_expression EQ relational_expression
                        | equality_expression NEQ relational_expression
                        {printf("| Rule: equality_expression |\n");}
                        ;

AND_expression: 
                    equality_expression
                    | AND_expression BITWISE_AND equality_expression
                    {printf("| Rule: AND_expression |\n");}
                    ;

exclusive_OR_expression: 
                            AND_expression
                            | exclusive_OR_expression BITWISE_XOR AND_expression
                            {printf("| Rule: exclusive_OR_expression |\n");}
                            ;

inclusive_OR_expression: 
                            exclusive_OR_expression
                            | inclusive_OR_expression BITWISE_OR exclusive_OR_expression
                            {printf("| Rule: inclusive_OR_expression |\n");}
                            ;

logical_AND_expression: 
                            inclusive_OR_expression
                            | logical_AND_expression AND inclusive_OR_expression
                            {printf("| Rule: logical_AND_expression |\n");}
                            ;

logical_OR_expression: 
                        logical_AND_expression
                        | logical_OR_expression OR logical_AND_expression
                        {printf("| Rule: logical_OR_expression |\n");}
                        ;

conditional_expression: 
                        logical_OR_expression
                        | logical_OR_expression '?' expression COLON conditional_expression
                        {printf("| Rule: conditional_expression |\n");}
                        ;

assignment_expression: 
                        conditional_expression
                        | unary_expression assignment_operator assignment_expression
                        {printf("| Rule: assignment_expression |\n");}
                        ;

assignment_operator: 
	ASSIGN
	| MUL_EQ
	| DIV_EQ
	| MOD_EQ
	| ADD_EQ
	| SUB_EQ
	| SHIFT_LEFT_EQ
	| SHIFT_RIGHT_EQ
	| BITWISE_AND_EQ
	| BITWISE_XOR_EQ
	| BITWISE_OR_EQ
	{printf("| Rule: assignment_operator |\n");}
	;

expression: 
            assignment_expression
            | expression COMMA assignment_expression
            {printf("| Rule: expression |\n");}
            ;

constant_expression: 
                    conditional_expression
                    {printf("| Rule: constant_expression |\n");}
                    ;   

declaration: 
	declaration_specifiers init_declarator_list_opt SEMICOLON
	{printf("| Rule: declaration |\n");}
	;

declaration_specifiers: 
                        storage_class_specifier declaration_specifiers_opt
                        | type_specifier declaration_specifiers_opt
                        | type_qualifier declaration_specifiers_opt
                        | function_specifier declaration_specifiers_opt
                        {printf("| Rule: declaration_specifiers |\n");}
                        ;

declaration_specifiers_opt: 
                            declaration_specifiers
                            | /* epsilon */
                            ;

init_declarator_list: 
                    init_declarator
                    | init_declarator_list COMMA init_declarator
                    {printf("| Rule: init_declarator_list |\n");}
	                ;

init_declarator_list_opt:
	init_declarator_list
	| /* epsilon */
	;

init_declarator: 
	declarator
	| declarator ASSIGN initializer
	{printf("| Rule: init_declarator |\n");}
	;

storage_class_specifier: 
                        EXTERN
                        | STATIC
                        | AUTO
                        | REGISTER
                        {printf("| Rule: storage_class_specifier |\n");}
                        ;

type_specifier:
                VOID
                | CHAR
                | SHORT
                | INT
                | LONG
                | FLOAT
                | DOUBLE
                | SIGNED
                | UNSIGNED
                | _BOOL
                | _COMPLEX
                | _IMAGINARY
                | enum_specifier
                {printf("| Rule: type_specifier |\n");}
                ;

specifier_qualifier_list: 
                        type_specifier specifier_qualifier_list_opt
                        | type_qualifier specifier_qualifier_list_opt
                        {printf("| Rule: specifier_qualifier_list |\n");}
                        ;

specifier_qualifier_list_opt: 
                            specifier_qualifier_list
                            | /* epsilon */
                            ;


enum_specifier: 
                ENUM identifier_opt '{' enumerator_list '}'
                | ENUM identifier_opt '{' enumerator_list COMMA '}'
                | ENUM IDENTIFIER
                {printf("| Rule: enum_specifier |\n");}
                ;

identifier_opt:
                IDENTIFIER
                | /* epsilon */
                ;

enumerator_list: 
                enumerator
                | enumerator_list COMMA enumerator
                {printf("| Rule: enumerator_list |\n");}
                ;

enumerator: 
            ENUMERATION_CONSTANT
            | ENUMERATION_CONSTANT ASSIGN constant_expression
            {printf("| Rule: enumerator |\n");}
            ;

type_qualifier: 
                CONST
                | RESTRICT
                | VOLATILE
                {printf("| Rule: type_qualifier |\n");}
                ;

function_specifier: 
                    INLINE
                    {printf("| Rule: function_specifier |\n");}
                    ;

declarator: 
            pointer_opt direct_declarator
            {printf("| Rule: declarator |\n");}
            ;

direct_declarator: 
                    IDENTIFIER
                    | '(' declarator ')'
                    | direct_declarator '['  type_qualifier_list_opt assignment_expression_opt ']'
                    | direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']'
                    | direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
                    | direct_declarator '[' type_qualifier_list_opt MUL ']'
                    | direct_declarator '(' parameter_type_list ')'
                    | direct_declarator '(' identifier_list_opt ')'
                    {printf("| Rule: direct_declarator |\n");}
                    ;

pointer: 
        MUL type_qualifier_list_opt
        | MUL type_qualifier_list_opt pointer
        {printf("| Rule: pointer |\n");}
        ;

pointer_opt: 
            pointer
            | /* epsilon */
            ;

assignment_expression_opt: 
	assignment_expression
	| /* epsilon */
	;

identifier_list_opt
	: identifier_list
	| /* epsilon */
	;


type_qualifier_list: 
                    type_qualifier
                    | type_qualifier_list type_qualifier
                    {printf("| Rule: type_qualifier_list |\n");}
                    ;


type_qualifier_list_opt: 
                        type_qualifier_list
                        | /* epsilon */
                        ;


parameter_type_list: 
                    parameter_list
                    | parameter_list COMMA ELLIPSIS
                    {printf("| Rule: parameter_type_list |\n");}
                    ;

parameter_list: 
                parameter_declaration
                | parameter_list COMMA parameter_declaration
                {printf("| Rule: parameter_list |\n");}
                ;

parameter_declaration: 
                        declaration_specifiers declarator
                        | declaration_specifiers
                        {printf("| Rule: parameter_declaration |\n");}
                        ;

identifier_list: 
                IDENTIFIER
                | identifier_list COMMA IDENTIFIER
                {printf("| Rule: identifier_list |\n");}
                ;

type_name: 
            specifier_qualifier_list
            {printf("| Rule: type_name |\n");}
            ;

initializer: 
            assignment_expression
            | '{' initializer_list '}'
            | '{' initializer_list COMMA '}'
            {printf("| Rule: initializer |\n");}
            ;

initializer_list: 
                    designation_opt initializer
                    | initializer_list COMMA designation_opt initializer
                    {printf("| Rule: initializer_list |\n");}
                    ;

designation_opt:
                designation
                | /* epsilon */
                ;

designation: 
	designator_list ASSIGN
	{printf("| Rule: designation |\n");}
	;

designator_list: 
                designator
                | designator_list designator
                {printf("| Rule: designator_list |\n");}
                ;

designator: 
	'[' constant_expression ']'
	| '.' IDENTIFIER
	{printf("| Rule: designator |\n");}
	;

statement: 
            labeled_statement
            | compound_statement
            | expression_statement
            | selection_statement
            | iteration_statement
            | jump_statement
            {printf("| Rule: statement |\n");}
            ;

labeled_statement: 
                    IDENTIFIER COLON statement
                    | CASE constant_expression COLON statement
                    | DEFAULT COLON statement
                    {printf("| Rule: labeled_statement |\n");}
                    ;

compound_statement: 
                    '{' block_item_list_opt '}'
                    {printf("| Rule: compound_statement |\n");}
                    ;


block_item_list: 
                block_item
                | block_item_list block_item
                {printf("| Rule: block_item_list |\n");}
                ;

block_item_list_opt: 
                    block_item_list
                    | /* epsilon */
                    ;

block_item: 
            declaration
            | statement
            {printf("| Rule: block_item |\n");}
            ;

expression_statement: 
                        expression_opt SEMICOLON
                        {printf("| Rule: expression_statement |\n");}
                        ;

expression_opt: 
                expression
                | /* epsilon */
                ;

selection_statement: 
                    IF '(' expression ')' statement
                    | IF '(' expression ')' statement ELSE statement
                    | SWITCH '(' expression ')' statement
                    {printf("| Rule: selection_statement |\n");}
                    ;

iteration_statement:
                    WHILE '(' expression ')' statement
                    | DO statement WHILE '(' expression ')' SEMICOLON
                    | FOR '(' expression_opt SEMICOLON expression_opt SEMICOLON expression_opt ')' statement
                    | FOR '(' declaration expression_opt SEMICOLON expression_opt ')' statement
                    {printf("| Rule: iteration_statement |\n");}
                    ;

jump_statement: 
                GOTO IDENTIFIER SEMICOLON
                | CONTINUE SEMICOLON
                | BREAK SEMICOLON
                | RETURN expression_opt SEMICOLON
                {printf("| Rule: jump_statement |\n");}
                ;

translation_unit: 
                external_declaration
                | translation_unit external_declaration
                {printf("| Rule: translation_unit |\n");}
                ;

external_declaration: 
                    function_definition
                    | declaration
                    {printf("| Rule: external_declaration |\n");}
                    ;

function_definition: 
                    declaration_specifiers declarator declaration_list_opt compound_statement
                    {printf("| Rule: function_definition |\n");}
                    ;

declaration_list_opt: 
                    declaration_list
                    | /* epsilon */
                    ;

declaration_list: 
                declaration
                | declaration_list declaration
                {printf("| Rule: declaration_list |\n");}
                ;

%%

void yyerror(char* s)
{
    printf("Detected Error: %s\n", s);
}