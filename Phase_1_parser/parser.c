#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;

//Function prototype for yyparse
void yyparse(void);

int main(){
    yyparse();
    return 0;
}