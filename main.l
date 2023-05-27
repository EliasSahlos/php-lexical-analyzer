%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "microTokens.h"

int line_number = 1;
int if_count = 0;
int if_elif_count = 0;
int if_else_count = 0;
int for_count = 0;
int mult_for_count = 0;
int print_statement_count = 0;
int input_statement_count = 0;
int for_in_count = 0;
int function_statemnt_count = 0;
int type_errors = 0;
int variable_declaration_count = 0;
int return_statement_count = 0;
int add_operation_count = 0;
int minus_operation_count = 0;
int multiply_operation_count = 0;
int divide_operation_count = 0;
int table_declaration_count = 0;

int error_count = 0;
int MAX_ERRORS = 3;

void ret_print(char *token_type);
void yyerror();
%}

white_space [ \t]*
word [a-zA-Z_]
digit [0-9]
alnum ({word}|{digit})
vardig ({variable}|{digit})
print [ -~]
variable ({word}*)
INT ("0"|[0-9]{digit}*)
FLOAT ("0"|{digit}*("."|","){digit}+)
STRING \"{print}*\"

table_declaration ({variable}+{white_space}"="{white_space}+"["+{STRING}+"]")
input_statement (({variable}|{alnum})+{white_space}"="{white_space}+(input|INPUT)+"("+")")
variable_declaration ({word}+{white_space}"="{white_space}+({word}|{alnum}|{variable})*)
print_statement ((print|PRINT){white_space}"("+{STRING}+")")
if_statement ((if|IF){white_space}+"("[^)]+")":)
elif_statement ((elif|ELIF){white_space}*"("[^)]*")":)
else_statement ((else|ELSE)+":")
for_statement ((for|FOR)[ \t]+({alnum})+[ \t]+(in|IN)[ \ t]+({alnum}|({alnum}*"("{digit}*")"))+[ \t]*":")
multiply_for ({for_statement})([ \n]*[ \t]+({for_statement}))+
function_statement ((def|DEF){white_space}({variable}|{alnum})"("{variable}")":)
return_statement ((return|RETURN)+"("+{variable}+")")
add_operation ({variable}+{white_space}"="{white_space}+{variable}+{white_space}"+"{white_space}+({vardig}))
minus_operation ({variable}+{white_space}"="{white_space}+{variable}+{white_space}"-"{white_space}+({vardig}))
multiply_operation ({variable}+{white_space}"="{white_space}+{variable}+{white_space}"*"{white_space}+({vardig}))
divide_operation ({variable}+{white_space}"="{white_space}+{variable}+{white_space}"/"{white_space}+({vardig}))
%%

{white_space} ret_print("SPACE");
"if"|"IF" { ret_print("T_IF"); if_count++; return T_IF;}
"else"|"ELSE" { ret_print("T_ELSE"); return T_ELSE;}
"elif"|"ELIF" { ret_print("T_ELIF"); return T_ELIF; }
"for"|"FOR" { ret_print("T_FOR"); for_count++; return T_FOR; }
"return"|"RETURN" { ret_print("KEYWORD_RETURN"); }
"input"|"INPUT" { ret_print("KEYWORD_INPUT"); }
"print"|"PRINT" { ret_print("KEYWORD_PRINT"); }
"range"|"RANGE" { ret_print("RANGE_KEYWORD"); }
"def"|"DEF" { ret_print("DEF_KEYWORD"); }

{table_declaration} { ret_print("Table Declaration"); table_declaration_count++; }
{return_statement} { ret_print("Return Statement"); return_statement_count++; }
{variable_declaration} { ret_print("Variable Declaration"); variable_declaration_count++;}
{variable} { ret_print("Variable"); }
{INT} { ret_print("INTEGER"); }
{FLOAT} { ret_print("FLOAT"); }
{STRING} { ret_print("STRING"); }
{print_statement} { ret_print("Print Statement"); print_statement_count++;}
{input_statement} { ret_print("Input Statement"); input_statement_count++;}
{if_statement} { ret_print("If Statement"); if_count++;}
{elif_statement} { ret_print("Else If Statement"); if_elif_count++;}
{else_statement} { ret_print("Else Statement"); if_else_count++;}
{for_statement} { ret_print("For in Statement"); for_in_count++;}
{multiply_for}  { ret_print("Multiply For Statement"); mult_for_count++;}
{function_statement} { ret_print("Function Statement"); function_statemnt_count++;}
{add_operation} { ret_print("Add Operation"); add_operation_count++; }
{minus_operation} { ret_print("Minus Operation"); minus_operation_count++; }
{multiply_operation} { ret_print("Multiply Operation"); multiply_operation_count++; }
{divide_operation} { ret_print("Divide Operation"); divide_operation_count++; }
"\n" { line_number += 1; }
. { yyerror("Unrecognized character"); type_errors++;}

%%

void ret_print(char *token_type)
{
    printf("Line: %d\t yytext: %s\t token: %s\n",line_number, yytext, token_type);
}

void yyerror(char *message)
{

    printf("Error: \"%s\" in line %d. Token: %s\n", message, line_number, yytext);
    error_count++;

    if (error_count >= MAX_ERRORS) {
        printf("Exceeded maximum error count. Terminating program.\n");
        exit(1);
    }
}


int main(int argc, char *argv[])
{
    
    yyin = fopen("input.py", "r");
      
    printf("--------------------------------------------------------------------\n");
    printf("\t\t\tPROGRAM INFORMATION\t\t\t\n");
    printf("--------------------------------------------------------------------\n");
    yylex();
    fclose(yyin);

    printf("\n----------------------------------------------------\n"); 
    printf("\t\tCODE STATISTICS\t\t\n");
    printf("----------------------------------------------------\n");
    printf("|IF Statements|\n");
    printf("---------------------\n");
    printf("IF Statement count: %d\n", if_count);
    printf("IF..ELIF..ELSE.. Statement count: %d\n", if_elif_count);
    printf("IF..ELSE.. Statement count: %d\n", if_else_count);
    printf("\n");
    printf("|FOR Statements|\n");
    printf("---------------------\n");
    printf("FOR Statement count: %d\n", for_in_count);
    printf("Multiply For Statement count: %d\n", mult_for_count);

    printf("\n");
    printf("|User Interaction Statements|\n");
    printf("---------------------\n");
    printf("Number of Print :  %d\n", print_statement_count);
    printf("Number of User Input :  %d\n", input_statement_count);
    printf("\n");
    printf("|Math Statements|\n");
    printf("---------------------\n");
    printf("Add Operations :  %d\n", add_operation_count);
    printf("Minus Operations :  %d\n", minus_operation_count);
    printf("Multiply Operations :  %d\n", multiply_operation_count);
    printf("Divide Operations :  %d\n", divide_operation_count);
    printf("\n");
    printf("|Other Information|\n");
    printf("---------------------\n");
    printf("Functions :  %d\n", function_statemnt_count);
    printf("Variable Declaration :  %d\n", variable_declaration_count);
    printf("Table Declaration :  %d\n", table_declaration_count);
    printf("Return Statement :  %d\n", return_statement_count);

    printf("\n");
    printf("|Program Errors|\n");
    printf("---------------------\n");
    printf("Typing Errors :  %d\n", type_errors);
    printf("\n");
}

    