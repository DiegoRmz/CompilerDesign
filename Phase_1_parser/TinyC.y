%{
 /*
  File: TinyC.y
  Author: Diego A. Rmz
  Description: File to implement the grammar defined at assignment 2
  History:  
        Wed Oct 3 09:07 2018 - File is created
 */
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

void yyerror (char* input);
 /* Removes the warning of yylex() not defined when using C99 */
#if YYBISON
    union YYSTYPE;
    int yylex();     // Should be int yylex(union YYSTYPE *, void *);
#endif
%}

%token INTEGER
%token FLOAT
%token ID
%token SEMI
%token IF
%token THEN
%token ELSE
%token WHILE
%token READ
%token WRITE
%token LPAREN
%token RPAREN
%token DIV
%token DO
%token EQ
%token ASSIGN
%token FLOAT_NUM
%token INT_NUM
%token LBRACE
%token LT
%token MINUS
%token PLUS
%token RBRACE
%token TIMES

%%
program: var_dec stmt_seq   {
                                printf("No errors in this line\n");
                            }
        ;
var_dec: var_dec single_dec
        | /*EMPTY*/
        ;

single_dec: type ID SEMI ;

type: INTEGER 
    | FLOAT 
    ;
stmt_seq: stmt_seq stmt 
        | /*EMPTY*/
        ;

stmt: IF exp THEN stmt  
    | IF exp THEN stmt ELSE stmt
    | WHILE exp DO stmt 
    | variable ASSIGN exp SEMI
    | READ LPAREN variable RPAREN SEMI
    | WRITE LPAREN exp RPAREN SEMI
    | block 
    ;

block: LBRACE stmt_seq RBRACE ;

exp: simple_exp LT simple_exp 
    | simple_exp EQ simple_exp 
    | simple_exp 
    ;

simple_exp: simple_exp PLUS term 
                | simple_exp MINUS term 
                | term 
                ;

term: term TIMES factor 
    | term DIV factor 
    | factor 
    ;

factor: LPAREN exp RPAREN 
        | INT_NUM 
        | FLOAT_NUM 
        | variable ;

variable: ID ;      
%%


/*Function prototype for yylex*/                                           
int yylex();

/*Bison can call flex to have someone else parse the tokens for him*/
#include "lex.yy.c"

/*Definition of yyerror in case it is used*/
void yyerror (char* input){
    printf ("%s\n",input);
}

/*Main entry point for the program*/
int main(){
    yyparse();
    return 0;
}