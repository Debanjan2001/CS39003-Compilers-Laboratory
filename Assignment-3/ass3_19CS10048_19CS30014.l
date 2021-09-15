/************    CS39003    *************
/**********   Assignment - 3   **********
/*****  Debanjan Saha, 19CS30014  *******
/***   Pritkumar Godhani, 19CS10048  ****
/***************************************/
%{
    #define KEYWORD 1
    #define IDENTIFIER 2
    #define CONSTANT 3
    #define STRING_LITERAL 4
    #define PUNCTUATOR 5
    #define MULTI_LINE_COMMENT_START 6
    #define MULTI_LINE_COMMENT_END 7
    #define MULTI_LINE_COMMENT_BODY 8
    #define SINGLE_LINE_COMMENT_START 9
    #define SINGLE_LINE_COMMENT_BODY 10
    #define SINGLE_LINE_COMMENT_END 11
    #define INTEGER_CONSTANT 12
    #define FLOATING_CONSTANT 13
    #define CHARACTER_CONSTANT 14
%}

%x  COMMENT
%x  SINGLE_LINE_COMMENT

KEYWORD                 "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary" 


IDENTIFIER_NON_DIGIT    [a-zA-Z_]
DIGIT                   [0-9]
IDENTIFIER              {IDENTIFIER_NON_DIGIT}({IDENTIFIER_NON_DIGIT}|{DIGIT})*


ESCAPE_SEQUENCE         "\\\'"|"\\\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
INTEGER_CONSTANT        [0]+|[1-9]({DIGIT})*
DIGIT_SEQUENCE          [0-9]+
FRACTIONAL_CONSTANT     {DIGIT_SEQUENCE}\.|{DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE} 
EXPONENT_PART           [eE]([+-]?){DIGIT_SEQUENCE}
FLOATING_CONSTANT       ({FRACTIONAL_CONSTANT}({EXPONENT_PART}?))|({DIGIT_SEQUENCE}{EXPONENT_PART}) 


C_CHAR                  [^\n\'\\']|{ESCAPE_SEQUENCE}
C_CHAR_SEQ              ({C_CHAR})+
CHARACTER_CONSTANT      \'({C_CHAR_SEQ})\'
ENUMERATION_CONSTANT    {IDENTIFIER}
CONSTANT                {INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{CHARACTER_CONSTANT}|{ENUMERATION_CONSTANT}


S_CHAR                  [^\n\"\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQ              {S_CHAR}+
STRING_LITERAL          \"({S_CHAR_SEQ})?\"


PUNCTUATOR              "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

%%

{KEYWORD}                   { return KEYWORD; }
{IDENTIFIER}                { return IDENTIFIER; }
{PUNCTUATOR}                { return PUNCTUATOR; }
{STRING_LITERAL}            { return STRING_LITERAL; }
{INTEGER_CONSTANT}          { return INTEGER_CONSTANT; }
{FLOATING_CONSTANT}         { return FLOATING_CONSTANT; }
{CHARACTER_CONSTANT}        { return CHARACTER_CONSTANT; }
{ESCAPE_SEQUENCE}|" "       { /* Ignore Whitespace and Escape Sequence */ }             

"/*"                        { BEGIN(COMMENT); return MULTI_LINE_COMMENT_START; }
<COMMENT>"*/"               { BEGIN(INITIAL); return MULTI_LINE_COMMENT_END; }
<COMMENT>.                  { return MULTI_LINE_COMMENT_BODY; }
<COMMENT>"\n"               { return MULTI_LINE_COMMENT_BODY; }

"//"                        { BEGIN(SINGLE_LINE_COMMENT); return SINGLE_LINE_COMMENT_START; }
<SINGLE_LINE_COMMENT>"\n"   { BEGIN(INITIAL); return SINGLE_LINE_COMMENT_END; }
<SINGLE_LINE_COMMENT>.      { return SINGLE_LINE_COMMENT_BODY;}    

%%
