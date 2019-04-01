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

#include "headers/symboltable.h"
#include "headers/types.h"


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
  char * name;
  tableEntryNPtr *symp;
}

%token <char * >INTEGER
%token <char * > REAL
%token <name> ID

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
%token <dval> FLOAT_NUM
%token <ival> INT_NUM
%token LBRACE
%token LT
%token MINUS
%token PLUS
%token RBRACE
%token TIMES


/* Solve for the dangling else */
%nonassoc THEN
%nonassoc ELSE

 /* To avoid ambiguities in the grammar assign associativity */
 /* and preference on the operators */
 
%nonassoc UMINUS

%type <symp> var_dec
%type <symp> single_dec
%type <name> type
%type <symp> variable
%type <symp> factor
%type <symp> term
%type <symp> exp
%type <symp> simple_exp
%type <symp> stmt_seq
%type <symp> stmt
%type <symp> block
%%

program: var_dec stmt_seq   {
                                printf("The program is syntactically correct!\n");

                                if($1->type == error  || $2->type == error)
                                    printf("There were semantic errors in the program\n");
                                else
                                    printf("The program is also semantically correct!\n");
                            }
        ;
var_dec: var_dec single_dec {
                                $$ = $2;
                            }
        |   {
                $$ = createTempEntry(empty);
            }
        ;

single_dec: type ID SEMI {
                            if(definitionTypesOk(&$$, $2, $1)){ } //continue normally
                         }
    ;

type: INTEGER { $$ = "INTEGER"; }
    | REAL { $$ = "REAL"; }
    ;
stmt_seq: stmt_seq stmt {
                            if ($1->type == empty && $2->type == empty){
                                $$ = createTempEntry(empty);
                                // Continue
                            } else {
                                $$ = createTempEntry(error);
                            }
                        }
        | { $$ = createTempEntry(empty); }
        ;

stmt: IF exp THEN stmt  {
                            if ($2->type == boolean){
                                $$ = createTempEntry(empty);
                                // Continue
                            } else {
                                $$ = createTempEntry(error); 
                            }
                        }
    | IF exp THEN stmt ELSE stmt{
                                    if ($2->type == boolean){
                                        if ($4->type == empty && $6->type == empty){
                                            $$ = createTempEntry(empty);
                                        } else {
                                            $$ = createTempEntry(error);
                                        }
                                    } else {
                                        $$ = createTempEntry(error);
                                    }
                                }
    | WHILE exp DO stmt {
                            if ($2->type == boolean){
                                $$ = createTempEntry(empty);
                                // Continue
                            } else {
                                $$ = createTempEntry(error); 
                            }
                        }
    | variable ASSIGN exp SEMI  {
                                    if (checkTypesOfAssignment(&$$,$1,$3)) {
                                        $$ = createTempEntry(empty);
                                        // Continue
                                    } else {
                                        $$ = createTempEntry(error); 
                                    }
                                }
    | READ LPAREN variable RPAREN SEMI  {
                                            if ($3->type == real || $3->type == integer) {
                                                $$ = createTempEntry(empty);
                                                // Continue;
                                            } else {
                                                $$ = createTempEntry(error); 
                                                printf("The variable must be an integer or float type\n");
                                            }
                                        }
    | WRITE LPAREN exp RPAREN SEMI  {
                                        if ($3->type == real || $3->type == integer) {
                                            $$ = createTempEntry(empty);
                                            // Continue;
                                        } else {
                                            $$ = createTempEntry(error); 
                                            printf("The variable must be an integer or float type\n");
                                        }
                                    }
    | block { $$ = $1; }
    ;

block: LBRACE stmt_seq RBRACE { $$ = $2;}
;

exp: simple_exp LT simple_exp   {
                                    if (checkRelationalOperations(&$$,$1,$3)) {
                                        // Continue
                                    }
                                }                
    | simple_exp EQ simple_exp  {
                                    if (checkRelationalOperations(&$$,$1,$3)) {
                                        // Continue
                                    }
                                }
    | simple_exp    {
                        $$ = $1;
                    }   
    ;

simple_exp: simple_exp PLUS term    {
                                        if (checkMathematicalOperations(&$$,$1,$3)) {
                                        
                                        } 
                                    }                                
                | simple_exp MINUS term %prec UMINUS{
                                                        if (checkMathematicalOperations(&$$,$1,$3)) {
                                                        
                                                        }
                                                    }
                | term  { $$ = $1; } 
                ;

term: term TIMES factor {
                            if (checkMathematicalOperations(&$$,$1,$3)) {
                            
                            }
                        }       
    | term DIV factor   {
                            if (checkMathematicalOperations(&$$,$1,$3)) {
                            
                            }
                        }
    | factor    { $$ = $1; }
    ;

factor: LPAREN exp RPAREN   { $$ = $2; }
        | INT_NUM   {
                        $$ = createTempEntry(integer);
                    }
        | FLOAT_NUM {
                        $$ = createTempEntry(real);
                    }
        | variable  { $$ = $1; }
        ;

variable: ID    {
                    if(variableDefOk(&$$, $1)){} //continue
                }
                ;      
%%

/*Function prototype for yylex*/                                           
int yylex();

/*Bison can call flex to have someone else parse the tokens for him*/
#include "lex.yy.c"

/*Definition of yyerror in case it is used*/
void yyerror (char * input){
    printf ("%s\n",input);
}

/* Function to check variable definition was ok on types */
int variableDefOk(tableEntryNPtr **ss, char * identifier){
    entry_p entry = getEntry(identifier, symTable);

    if(entry == NULL){
        printf("Variable not defined %s\n",identifier);
        printf("At line: %d\n",yylineno);
        entry = createTempEntry(error),

        *ss = entry;

        return 0;
    }else{
        *ss = entry;

        return 1;
    }
}

/* Function to check definitions are ok */
int definitionTypesOk(tableEntryNPtr **ss, char * identifier, char * typeTranslateable){
    entry_p existentEntry = getEntry(identifier,symTable);

    //Not on the table
    if(!existentEntry || existentEntry->refCounter == 0){
        existentEntry->refCounter++;    //Found once, to avoid duplicities
        entry_p n = createTempEntry(translateStringType(typeTranslateable));
        *ss = n;
        return 1;
    }else{
        printf("Cannot redefine variables, variable is already defined: %s\n",identifier);
        printf("Line: %d\n",yylineno);
        existentEntry = createTempEntry(error);
        *ss = existentEntry;

        return 0;
    }
}

/* Function to verify the integrity of the types during relational operations */
int checkMathematicalOperations(tableEntryNPtr **ss, entry_p s1, entry_p s2){
    entry_p sp = createTempEntry(undefined);

    *ss = sp;

    if(s1->type == s2->type){
        sp->type = s1->type;
        return 1;
    }else{
        //Type conversion
        if(s1->type == integer && s2->type == real){
            sp->type = real;
            printf("Semantic warning: conversion of types: integer to float\n");
            return 1;
        }else if(s1->type == real && s2->type == integer){
            sp->type = real;
            printf("Semantic warning: conversion of types: float to integer\n");
            return 1;
        }else{
            sp->type = error;
            printf("Semantic error: Cannot convert types, at line: %d\n",yylineno);
            return 0;
        }
    }
}

int checkRelationalOperations(tableEntryNPtr **ss, entry_p s1, entry_p s2){
    entry_p sp = createTempEntry(undefined);

    *ss = sp;

    if(s1->type == s2->type){
        sp->type = boolean;
        return 1;
    }else{
        //Type conversion
        if(s1->type == integer && s2->type == real){
            sp->type = boolean;
            printf("Semantic warning: comparison of types: integer to float\n");
            return 1;
        }else if(s1->type == real && s2->type == integer){
            sp->type = boolean;
            printf("Semantic warning: comparison of types: float to integer\n");
            return 1;
        }else{
            sp->type = error;
            printf("Semantic error: Cannot eval expression, at line: %d\n",yylineno);
            return 0;
        }
    }
}

int checkTypesOfAssignment(tableEntryNPtr **ss, entry_p s1, entry_p s2){
    entry_p sp = createTempEntry(undefined);

    *ss = sp;

    if(s1->type == s2->type){
        sp->type = empty;
        return 1;
    }else{
        //Type conversion
        if(s1->type == integer && s2->type == real){
            sp->type = error;
            printf("Semantic error (variable %s): cannot assign float to integer, at line: %d\n",
            s1->variableName, yylineno);
            return 0;
        }else if(s1->type == real && s2->type == integer){
            sp->type = empty;

            return 1;
        }else{
            sp->type = error;
            printf("Semantic error: Cannot assign types, at line: %d\n", yylineno);
            return 0;
        }
    }
}

enum tinyCTypes translateStringType(char * type){
    if(strcmp("INTEGER",type) == 0)
        return integer;
    if(strcmp("REAL",type) == 0)
        return real;
    if(strcmp("BOOLEAN",type) == 0)
        return boolean;
    if(strcmp("ERROR",type) == 0)
        return error;
    if(strcmp("EMPTY",type) == 0)
        return empty;
    
    return undefined;
}

entry_p getEntry(char * key, GHashTable *theTable){
    if(!theTable){
        printf("The table is null, can't work!\n");
        return NULL;
    }

    if(g_hash_table_contains(theTable, key)){
        return g_hash_table_lookup(theTable,key);
    }else{
        return NULL;
    }
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
        theEntry->refCounter = 0;
    }

    return theEntry;
}   

entry_p createTempEntry(enum tinyCTypes type){
    union val value;
    value.provisionalVal = 0;
    return newTableEntry("temp",-1,0,value, type);
}

gboolean offerEntryAtTable(entry_p theEntry, GHashTable *theTable){
    entry_p existsEntry = getEntry(theEntry->variableName, theTable);

    if(!existsEntry){
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