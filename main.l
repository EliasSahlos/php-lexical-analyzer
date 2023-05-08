%{
    #include <stdio.h>
    #include <string.h>
    #include "microTokens.h"
    int lineno =1;
    int attr =0;
    int idnum = 0;
%}

%option noyywrap
%option case-insensitive
ws [ \n\t]+
nzdigit [1-9]
digit (0|{nzdigit})
digits {digit}+
optFr (\.{digits})?
optExp ((E|e)(\+|-)?{digits})?
number  ({nzdigit}{digits}*|0){optFr}{optExp}
letter [A-Za-z]
id {letter}({letter}|{digit})*
%%
{ws} {/* do nothing */}
while   { attr=0; return (T_WHILE);}
for     { attr=0; return (T_FOR);}
echo    { attr=0; return (T_ECHO);}
if      { attr=0; return(T_IF);}
then    { attr=0; return(T_THEN);}
else    { attr=0; return(T_ELSE);}
[[:alpha:]]+    { attr=0; return(T_RANDOM);}
.            { printf("Unkown text\n"); }
<<EOF>>      { return 0;} 

%%

int main(int argc, char *argv[])
{
    if(argc > 1 ){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            perror ("Error opening file");
            return -1; 
        }
    }
int token;
while ((token=yylex()) != 0)
{printf("%s <%d,%d> \n",yytext,token,attr);}
fclose(yyin);
yyterminate();
}