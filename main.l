%{
#include <stdio.h>
int var_count = 0;
int if_count = 0;
int for_count = 0;
int echo_count = 0;
int line_number = 1;
int php_open = 0;
int php_close = 0;
%}

%%

"\<\?php"           { php_open = 1; }
"\?\>"              { php_close = 1; }
(\$[a-zA-Z0-9_]+)   { var_count++; }
if                  { if_count++; }
for                 { for_count++; }
echo                { echo_count++; }
\n                  { line_number++; }

%%

void checkPHPValidation(){
  if (php_open != 1 || php_close != 1) {
        printf("Error: Code is not between <?php and ?> \n");
        printf("Please write your code between <?php //Your Code Here.. // ?> and rerun the program. \n");
        exit(1);
    }
}


int main(int argc, char** argv) {
    yyin = fopen("input.txt","r");
    yylex();
    fclose(yyin);
    checkPHPValidation();
    printf("\n--------------------");
    printf("\nVariable count: %d\n", var_count);
    printf("IF Statement count: %d\n", if_count);
    printf("FOR Statement count: %d\n", for_count);
    printf("Number of Echo :  %d\n", echo_count);
    printf("Number of PHP OPENINGS :  %d\n", php_open);
    printf("Number of PHP CLOSINGS :  %d\n", php_close);
    
    return 0;
}