/************    CS39003    *************
/**********   Assignment - 3   **********
/*****  Debanjan Saha, 19CS30014  *******
/***   Pritkumar Godhani, 19CS10048  ****
/***************************************/
#include <stdio.h>

int main(){

    int token;
    while(token = yylex()){

        switch (token){

            case KEYWORD:
                printf("<KEYWORD, %d, %s>\n",token, yytext); 
                break;
            
            case IDENTIFIER:
                printf("<IDENTIFIER, %d, %s>\n",token, yytext); 
                break;

            case INTEGER_CONSTANT:
                printf("<INTEGER_CONSTANT, %d, %s>\n",token, yytext); 
                break;

            case FLOATING_CONSTANT:
                printf("<FLOATING_CONSTANT, %d, %s>\n",token, yytext); 
                break;

            case CHARACTER_CONSTANT:
                printf("<CHARACTER_CONSTANT, %d, %s>\n",token, yytext); 
                break;

            case STRING_LITERAL:
                printf("<STRING_LITERAL, %d, %s>\n",token, yytext); 
                break;

            case PUNCTUATOR:
                printf("<PUNCTUATOR, %d, %s>\n",token, yytext); 
                break;

            case SINGLE_COMMENT_START:
                printf("<SINGLE_LINE_COMMENT_START, %d, %s>\n",token, yytext); 
                break;

            case SINGLE_COMMENT:
                printf("<SINGLE_COMMENT_CONTINUE, %d, %s>\n",token, yytext); 
                break;

            case SINGLE_COMMENT_END:
                printf("<SINGLE_LINE_COMMENT_END, %d, %s>\n",token, yytext); 
                break;

            case MULTI_COMMENT_START:
                printf("<MULTI_LINE_COMMENT_START, %d, %s>\n",token, yytext); 
                break;

            case MULTI_COMMENT:
                printf("<MULTI_LINE_COMMENT_CONTINUE, %d, %s>\n",token, yytext); 
                break;

            case MULTI_COMMENT_END:
                printf("<MULTI_LINE_COMMENT_END, %d, %s>\n",token, yytext); 
                break;

            default:
                break;
        }
    }

    return 0;
}