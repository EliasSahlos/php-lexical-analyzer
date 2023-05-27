%{
    #include <stdio.h>
    #include <stdlib.h>

int error_count = 0;

void yyerror(const char* msg) {
    printf("Error: %s\n", msg);
    error_count++;

    if (error_count > 3) {
        printf("Too many errors. Program terminated.\n");
        yyabort();
    }
}

int main() {
    yyparse();

    if (error_count == 0) {
        printf("No errors. Program finished successfully.\n");
    } else {
        printf("Total errors: %d\n", error_count);
    }

    return 0;
}
%}

%token <token_type> INTEGER
%token <token_type> PLUS
%token <token_type> MINUS
%token <token_type> EOF

%%

program:
    /* empty */
    | program statement EOF
    ;

statement:
    expression '\n' {
        printf("Expression: %d\n", $1);
    }
    ;

expression:
    INTEGER PLUS INTEGER {
        $$ = $1 + $3;
    }
    | INTEGER MINUS INTEGER {
        $$ = $1 - $3;
    }
    ;

%%

void yyerror(const char* msg) {
    printf("Error: %s\n", msg);
    error_count++;

    if (error_count > 3) {
        printf("Too many errors. Program terminated.\n");
        yyabort();
    }
}

int main() {
    yyparse();

    if (error_count == 0) {
        printf("No errors. Program finished successfully.\n");
    } else {
        printf("Total errors: %d\n", error_count);
    }

    return yyparse();

    return 0;
}

