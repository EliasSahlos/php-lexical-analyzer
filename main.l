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


["#"][0-9A-Za-z#$%=@!{},`~&*()<>?.:;_|^/+\t\r\n\[\]'-]+[\n]	;



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
"+="		return DELIMETER;
"-="		return DELIMETER;
"**="		return DELIMETER;
"*="		return DELIMETER;
"//="		return DELIMETER;
"/="		return DELIMETER;
"%="		return DELIMETER;
"&="		return DELIMETER;
"|="		return DELIMETER;
"^="		return DELIMETER;
">>="		return DELIMETER;
"<<="		return DELIMETER;


[0-9]*[l|L]	return LITERAL;

([a-fA-F0-9])*|([0]+)|([0-9a-fA-F]*)?	return LITERAL;

\'[ 0-9A-Za-z#$%=@!{},`~&*()<>?.:;_|^/+\t\r\n\[\]"-]*\'	return LITERAL;

["][0-9A-Za-z#$%=@!{},`~&*()<>?.:;_|^/+\t\r\n\[\]'-]*["]	return LITERAL;

[0-9]+([.][0-9]+)?(("e"|"E")[+|-]?[0-9]+)?([+|-][0-9]*("j"|"J"))?	return LITERAL;


[a-zA-Z]+[_]?[a-zA-Z0-9]*	return IDENTIFIER;

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