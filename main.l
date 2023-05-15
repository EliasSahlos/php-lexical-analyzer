%{
    #include <stdio.h>
    #include <string.h>
    #include "microTokens.h"
    int lineno =1;
    int attr =0;
    int idnum = 0;
    int tab_count = 0;
    int var_count = 0;
    int if_count = 0;
    int if_elif_count = 0;
    int if_else_count = 0;
    int for_count = 0;
    int print_count = 0;
    int line_number = 1;

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



{ws} {tab_count++}

"and"		return KEYWORD;
"assert"	return KEYWORD;
"as"		return KEYWORD;
"break"		return KEYWORD;
"class"		return KEYWORD;
"continue"	return KEYWORD;
"def"		return KEYWORD;
"del"		return KEYWORD;
"elif"		return KEYWORD;
"else"		return KEYWORD;
"exec"		return KEYWORD;
"except"	return KEYWORD;
"finally"	return KEYWORD;
"for"		return KEYWORD;
"from"		return KEYWORD;
"global"	return KEYWORD;
"if"		return KEYWORD;
"import"	return KEYWORD;
"in"		return KEYWORD;
"is"		return KEYWORD;
"lambda"	return KEYWORD;
"not"		return KEYWORD;
"or"		return KEYWORD;
"pass"		return KEYWORD;
"print"		return KEYWORD;
"raise"		return KEYWORD;
"return"	return KEYWORD;
"try"		return KEYWORD;
"while"		return KEYWORD;
"with"		return KEYWORD;
"yield"		return KEYWORD;


"=="	return OPERATOR;
"!="	return OPERATOR;
"<<"	return OPERATOR;
">>"	return OPERATOR;
"<="	return OPERATOR;
">="	return OPERATOR;
"<>"	return OPERATOR;
[<]		return OPERATOR;
[>]		return OPERATOR;
[~]		return OPERATOR;
[%]		return OPERATOR;
[\^]	return OPERATOR;
[|]		return OPERATOR;
[&]		return OPERATOR;
"//"	return OPERATOR;
[/]		return OPERATOR;
"**"	return OPERATOR;
[*]		return OPERATOR;
[-]		return OPERATOR;
[+]		return OPERATOR;


[=]		return DELIMETER;
[,]		return DELIMETER;
":"		return DELIMETER;
"("     return DELIMETER;
")"		return DELIMETER;
"["		return DELIMETER;
"]"		return DELIMETER;
"{"     return DELIMETER;
"}"		return DELIMETER;
"@"		return DELIMETER;
"'"		return DELIMETER;
"."		return DELIMETER;
"`"		return DELIMETER;
";"		return DELIMETER;
"+="	return DELIMETER;
"-="	return DELIMETER;
"**="	return DELIMETER;
"*="	return DELIMETER;
"//="	return DELIMETER;
"/="	return DELIMETER;
"%="	return DELIMETER;
"&="	return DELIMETER;
"|="	return DELIMETER;
"^="	return DELIMETER;
">>="	return DELIMETER;
"<<="	return DELIMETER;


"if"[[:space:]]+[^:]+:[[:space:]]*\n[[:space:]]+ { if_count++; }
"elif"[[:space:]]+[^:]+:[[:space:]]*\n[[:space:]]+ { if_elif_count++; }
"else"[[:space:]]*:[[:space:]]*\n[[:space:]]+ { if_else_count++; }
"for"[[:space:]]+[^:]+:[[:space:]]*\n[[:space:]]+ { for_count++; }
print { print_count++;}


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

printf("\n--------------------");
printf("IF Statement count: %d\n", if_count);
printf("IF..ELIF.. Statement count: %d\n", if_elif_count);
printf("IF..ELSE.. Statement count: %d\n", if_else_count);
printf("FOR Statement count: %d\n", for_count);

    
return 0;

yyterminate();

}