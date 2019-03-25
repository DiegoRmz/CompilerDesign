%{
 /*
  File: parser.y
  Author: Diego A. Rmz
  Description: File to implement the grammar defined in Programming Languages
               for the tiny c language
  History:  
        Wed Oct 3 09:07 2018 - File is created as TinyC.y
        2019-02-16 - File modifed and renamed to parser.y
 */
#include <glib.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "symboltable.h"

void yyerror (char* input);
 /* Removes the warning of yylex() not defined when using C99 */

#if YYBISON
    union YYSTYPE;
    int yylex();     // Should be int yylex(union YYSTYPE *, void *);
#endif

GHashTable * symTable;
%}

%union {
  float dval;
  int ival;
  struct _sym_entry *symp;
}

%token INTEGER
%token REAL
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
                                printf("The program is syntactically correct!\n");
                            }
        ;
var_dec: var_dec single_dec
        | /*EMPTY*/
        ;

single_dec: type ID SEMI ;

type: INTEGER
    | REAL
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
    | block ;

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
        | variable 
        ;

variable: ID ;      
%%

/*Function prototype for yylex*/                                           
int yylex();

/*Bison can call flex to have someone else parse the tokens for him*/
#include "lex.yy.c"

/*Definition of yyerror in case it is used*/
void yyerror (char * input){
    printf ("%s\n",input);
}

entry_p newTableEntry(char * variableName, int scope, int lineFoundAt, union val value, enum tinyCTypes type){
    //Memory for the struct
    entry_p theEntry = malloc(sizeof(tableEntry));
    
    if(theEntry){
        theEntry->variableName = strdup(variableName);
        theEntry->scope = scope;
        theEntry->lineFoundAt = lineFoundAt;
        theEntry->type = type;
        theEntry->value = value;
    }

    return theEntry;
}   

gboolean offerEntryAtTable(entry_p theEntry, GHashTable *theTable){
    //If it wasn't found, attempt insertion
    if(!g_hash_table_lookup(theTable, theEntry->variableName)){
        g_hash_table_insert(theTable, strdup(theEntry->variableName),theEntry);
        return TRUE;
    }

    return FALSE;
}

void printItem(gpointer key, gpointer value, gpointer user_data){
    entry_p e = (entry_p)value;

    if(e->type == real){
        printf(user_data,(char *)key,e->lineFoundAt, e->scope, "Real number");
    }else if(e->type == integer){
        printf(user_data,(char *)key,e->lineFoundAt, e->scope, "Integer");
    }else{
        printf(user_data,(char *)key,e->lineFoundAt, e->scope,"Undefined");
    }
    
}

void printTable(GHashTable *hashTable){
    g_hash_table_foreach(hashTable,(GHFunc)printItem,"Key/variable name: %s, Found at: %d, scope depth: %d, Type: %s\n");    
}


/*Main entry point for the program*/
int main(){
    //Table uses the default glib string hash function and string
    symTable = g_hash_table_new ( g_str_hash, g_str_equal);
    //comparison function
    yyparse();

    printTable(symTable);
    return 0;
}