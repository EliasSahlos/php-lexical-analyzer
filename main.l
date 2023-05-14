%{
#include <stdio.h>
int var_count = 0;
int if_count = 0;
int if_elif_count = 0;
int if_else_count = 0;
int for_count = 0;
int print_count = 0;
int line_number = 1;
%}

%%

[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=[[:space:]]*[a-zA-Z0-9_]+ { var_count++; }
"if"[[:space:]]+[^:]+:[[:space:]]*\n[[:space:]]+ { if_count++; }
"elif"[[:space:]]+[^:]+:[[:space:]]*\n[[:space:]]+ { if_elif_count++; }
"else"[[:space:]]*:[[:space:]]*\n[[:space:]]+ { if_else_count++; }
"for"[[:space:]]+[^:]+:[[:space:]]*\n[[:space:]]+ { for_count++; }
print       { print_count++; }
\n          { line_number++; }

%%

int main(int argc, char** argv) {
    yyin = fopen("input.txt","r");
    yylex();
    fclose(yyin);
    printf("\n--------------------");
    printf("\nVariable count: %d\n", var_count);
    printf("IF Statement count: %d\n", if_count);
    printf("IF..ELIF.. Statement count: %d\n", if_elif_count);
    printf("IF..ELSE.. Statement count: %d\n", if_else_count);
    printf("FOR Statement count: %d\n", for_count);
    printf("Number of Print :  %d\n", print_count);
    for (int i = 0; i < 100; i++) {
        if (ifLineArr[i] != 0) {
            printf("%d ", ifLineArr[i]);
        }
}
    
    return 0;
}