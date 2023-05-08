%{
    #include <stdio.h>
    #include <string.h>
    int lineno =1;
%}

%option noyywrap
%option case-insensitive

%%
"Hello"            { printf("Fount Hello\n"); return 1;}
"Mike"             { printf("Fount Mike\n"); return 2;}
"echo"            { printf("Fount Echo\n"); return 4;}
[[:alpha:]]+       { printf("Fount Random word\n"); return 3;}
.                  { printf("Unkown text\n"); }
<<EOF>>            { return 0;} 

%%

int main(int argc, char *argv[])
{ 
    int token;
    if(argc > 1 ){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            perror ("Error opening file");
            return -1; 
        }
    }
    do{
        token = yylex();
    }while(token != 0);
    fclose(yyin);
    yyterminate();
    
}