%{
    /*
     * File: TinyC.lex
     * Author: Jay Ramirez
     * Description:
     *      The following code is the description of a lexical analizer for the language "TinyC"
     *
     * Version: 1.0
     * References: Stack Overflow, lots of university pages about the use of flex, and
     *              professor Abelardo's code, Diego A Rmz Tinyc parser
     * 2018-09-03 01:41:43
     */
    #include <stdlib.h>  /*This code passes directly to the lex.yy.c file*/
    int lineNumber = 0;
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
";" {
        printf("Got a semicolon\n");
        return SEMI;
    }
"int"   {
            printf("Got int\n");
            return INTEGER;
        }

"float" {
            printf("Got float\n");
            return FLOAT;
        }

"if"    {
            printf("Got an if\n");
            return IF;
        }

"then"  {
            printf("Got a then\n");
            return THEN;
        }

"else"  {
            printf("Got an else\n");
            return ELSE;
        }

"while" {
            printf("Got a while\n");
            return WHILE;
        }
"do"    {
            printf("Got a do\n");
            return DO;
        }
"read"  {
            printf("Got a read\n");
            return READ;
        }
"write" {
            printf("Got a write\n");
            return WRITE;
        }
"{"     {
            printf("Got lbrace\n");
            return LBRACE;
        }
"}"     {
            printf("Got an rbrace\n");
            return RBRACE;
        }
"("     {
            printf("Got lparen\n");
            return LPAREN;
        }
")"     {
            printf("Got rparen\n");
            return RPAREN;
        }
"<"     {
            printf("Got LT\n");
            return LT;
        }
"="     {
            printf("Got eq\n");
            return EQ;
        }
"+" {
        printf("Got a plus\n");
        return PLUS;
    }
"-"   { 
        printf("Got a minus\n");
        return MINUS;
      }
"*"     {
            printf("Got times\n");
            return TIMES;
        }
"/"   {
        printf("Got a div\n");
        return DIV;
      }
":="    {
            printf("Got an assign\n");
            return ASSIGN;
        }
{obased_digit}{zbased_digit}*|{octalb_digit}+|0(x|X){hexab_digit}+|[+-]?{zbased_digit}* {
                                                                                            printf("Got a digit\n");
                                                                                            return INT_NUM; 
                                                                                        }
[1-9][0-9]*|0(c|C)[0-7]+|0(x|X)[0-9A-Fa-f]+|[+-]?[0-9]*"."[0-9]+([eE][-+]?[0-9]+)?  {
                                                                                        printf("Got a digit\n");
                                                                                        return FLOAT_NUM;
                                                                                    }
[A-Za-z_][A-Za-z0-9_]*  {
                            printf("Got a variable id\n");
                            return ID;
                        }
{new_line}  {
    lineNumber++;
}
.   {
        printf("Got this %s",yytext);
        return yytext[0];
    }
%%