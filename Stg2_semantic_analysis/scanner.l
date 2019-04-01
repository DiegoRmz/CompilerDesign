%option yylineno
%{
    /*
     * File: scanner.l
     * Author: Diego A Rmz
     * Description:
     *      The following code is the description of a lexical analizer for the language "TinyC"
     *
     * Version: 1.0
     * References: Stack Overflow, lots of university pages about the use of flex, and
     *              professor Abelardo's code, Diego A Rmz Tinyc parser
     * Revision history:
     * 2018-09-03 01:41:43 -- File created Tinycj.l
     * 2019-02-16          -- Rules compacted to make the file easier to manage
     */
    #include <string.h>

    int scopeDepth = 0;
    char * currentKeyForLine;   //Just a pointer to the latest key found, can be useful for an assign
    enum tinyCTypes currentType = undefined;

%}
/*Rules declaration section*/
zbased_digit [0-9]
obased_digit [1-9]
hexab_digit  [0-9A-Fa-f]
octalb_digit 0(c|C)[0-7]
white_space " "
tabs        \t
new_line    \n
%%
[ \t] /*Ignore whitespace*/
"//"    {
            char c;
            while((c=input()) != '\n'){
                //eat comment
            }
        }
"/*"    {
            char charr;
            while((charr=input()) != EOF){
                if(charr == '*'){
                    charr = input();

                    if(charr == '/')
                        break;                        

                    else if(charr == EOF){
                        printf("Malformed comment\n");
                        return -1;
                    }
                }
            }
        }
"int"|"float" {
        char *val = strndup(yytext,(size_t)yyleng);

        if(strcmp(val,"int") == 0){
            currentType = integer;
            return INTEGER;
        }else if(strcmp(val,"float") == 0){
            currentType = real;
            return REAL;
        }
    }
"if"|"then"|"else"|"while"|"do" {
        char *val = strndup(yytext,(size_t)yyleng);

        if(strcmp(val,"if") == 0){
            return IF;
        }else if(strcmp(val,"then") == 0){
            return THEN;
        }else if(strcmp(val,"else") == 0){
            return ELSE;
        }else if(strcmp(val,"while") == 0){
            return WHILE;
        }else if(strcmp(val,"do") == 0){
            return DO;
        }
    }
"read"|"write" {
        char *val = strndup(yytext,(size_t)yyleng);

        if(strcmp(val,"read") == 0){
            return READ;
        }
        else{
            return WRITE;
        }
    }
":=" {
        return ASSIGN;
     }
"("|")"|"{"|"}"|";" {
        if(strcmp(yytext,"(") == 0){
            return LPAREN;
        }else if(strcmp(yytext,")") == 0){
            return RPAREN;
        }else if(strcmp(yytext,"{") == 0){
            scopeDepth++;
            return LBRACE;
        }else if(strcmp(yytext,"}") == 0){
            scopeDepth--;
            return RBRACE;
        }else if(strcmp(yytext,";") == 0){
            return SEMI;
        }
    }
"<"|"=" {
        if(strcmp(yytext,"<") == 0){
            return LT;
        }else{
            return EQ;
        }
    }
"+"|"-"|"*"|"/" {
        if(strcmp(yytext,"+") == 0){
            return PLUS;
        }else if(strcmp(yytext,"-") == 0){
            return MINUS;
        }else if(strcmp(yytext,"*") == 0){
            return TIMES;
        }else if(strcmp(yytext,"/") == 0){
            return DIV;
        }
    }

{obased_digit}{zbased_digit}*|{octalb_digit}+|0(x|X){hexab_digit}+|[+-]?{zbased_digit}* {       
                                                                                yylval.dval = atoi(yytext); 
                                                                                return FLOAT_NUM;                           
                                                                                        }
[1-9][0-9]*|0(c|C)[0-7]+|0(x|X)[0-9A-Fa-f]+|[+-]?[0-9]*"."[0-9]+([eE][-+]?[0-9]+)?  {
                                                                                        yylval.ival = atoi(yytext);
                                                                                        return INT_NUM;         
                                                                                    }
[A-Za-z_][A-Za-z0-9_]* {
        union val value;
        value.provisionalVal = 0;
        
        entry_p entry = newTableEntry(strdup(yytext), scopeDepth, yylineno, value, currentType);

        offerEntryAtTable(entry, symTable);

        yylval.name = strdup(yytext);
        return ID;
    }
{new_line} {

    }
.   {
        printf("There was a mistake\n");
        return yytext;
    }
%%