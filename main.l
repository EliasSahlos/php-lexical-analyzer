%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int line_number = 1;
int if_count = 0;
int if_elif_count = 0;
int if_else_count = 0;
int for_count = 0;
int print_count = 0;
int input_count = 0;
int for_in_count = 0;
void ret_print(char *token_type);
void yyerror();
%}

white_space [ \t]*
word [a-zA-Z_]
digit [0-9]
alnum ({word}|{digit})
print [ -~]
variable ({word}*)
INT ("0"|[0-9]{digit}*)
FLOAT ("0"|{digit}*("."|","){digit}+)
STRING \"{print}*\"

print_statement ((print|PRINT)"("[^)]")")
input_statement ((input|INPUT)"("[^)]")")
if_statement ((if|IF){white_space}+"("[^)]+")":)
elif_statement ((elif|ELIF){white_space}*"("[^)]*")":)
else_statement ((else|ELSE)*":")
for_statement ((for|FOR)[ \t]+({word}|{digit})+[ \t]+(in|IN)[ \ t]+({word}|{digit}|({word}|{digit}*"("{digit}*")"))+[ \t]*":")

%%

{white_space} ret_print("SPACE");
"if"|"IF" { ret_print("KEYWORD_IF"); if_count++;}
"else"|"ELSE" { ret_print("KEYWORD_ELSE"); }
"elif"|"ELIF" { ret_print("KEYWORD_ELIF"); }
"for"|"FOR" { ret_print("KEYWORD_FOR"); for_count++; }
"return"|"RETURN" { ret_print("KEYWORD_RETURN"); }
"input"|"INPUT" { ret_print("KEYWORD_INPUT"); input_count++;}
"print"|"PRINT" { ret_print("KEYWORD_PRINT"); print_count++;}
"range"|"RANGE" { ret_print("RANGE_KEYWORD"); input_count++;}
"+" { ret_print("ADD_OPERATOR"); }
"-" { ret_print("SUB_OPERATOR"); }
"*" { ret_print("MULTIPLY_OPERATOR"); }
"/" { ret_print("DIVIDER_OPERATOR"); }
"%" { ret_print("MOD_OPERATOR"); }
"++" { ret_print("INCREMENT"); }
"--" { ret_print("DECREMENT"); }
"||" { ret_print("OR_OPERATOR"); }
"&&" { ret_print("AND_OPERATOR"); }
"!"  { ret_print("NOT_OPERATOR"); }
"==" { ret_print("EQUAL_OPERATOR"); }
"!=" { ret_print("NOT_EQUAL_OPERATOR"); }
">" { ret_print("GREATER_OPEATOR"); }
"<" { ret_print("LOWER_OPEATOR"); }
">=" { ret_print("GREATER_EQUAL_OPEATOR"); }
"<=" { ret_print("LOWER_EQUAL_OPEATOR"); }
"(" { ret_print("LEFT_PAR"); }
")" { ret_print("RIGHT_PAR"); }
"]" { ret_print("LEFT_BRACKET"); }
"[" { ret_print("RIGHT_BRACKET"); }
"{" { ret_print("LEFT_CURLY_BRACKET"); }
"}" { ret_print("RIGHT_CURLY_BRACKET"); }
";" { ret_print("SEMICOLON"); }
"." { ret_print("DOT"); }
"," { ret_print("COMMA"); }
"=" { ret_print("ASSIGN"); }
{variable} { ret_print("Variable"); }
{INT} { ret_print("INTEGER"); }
{FLOAT} { ret_print("FLOAT"); }
{STRING} { ret_print("STRING"); }
{print_statement} { ret_print("Print Statement");}
{input_statement} { ret_print("Input Statement"); }
{if_statement} { ret_print("If Statement"); if_count++;}
{elif_statement} { ret_print("Else If Statment"); if_elif_count++;}
{else_statement} { ret_print("Else Statment"); if_else_count++;}
{for_statement} { ret_print("For in Statement"); for_in_count++;}
"\n" { line_number += 1; }
. { yyerror("Unrecognized character"); }

%%

void ret_print(char *token_type)
{
    printf("Line: %d\t yytext: %s\t token: %s\n",line_number, yytext, token_type);
}

void yyerror(char *message)
{
    printf("Error: \"%s\" in line %d. Token: %s\n", message, line_number, yytext);

}

int main(int argc, char *argv[])
{
yyin = fopen("input.txt", "r");
yylex();
fclose(yyin);
printf("\n--------------------\n");
    printf("IF Statement count: %d\n", if_count);
    printf("IF..ELIF..ELSE.. Statement count: %d\n", if_elif_count);
    printf("IF..ELSE.. Statement count: %d\n", if_else_count);
    printf("FOR Statement count: %d\n", for_in_count);
    printf("Number of Print :  %d\n", print_count);
    printf("Number of User Input :  %d\n", input_count);
return 0;
}
