%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int yylex();
extern int yylineno;
void yyerror(const char *s);
%}

%union {
    int ival;
    char *sval;
}

%token <sval> IDENTIFIER
%token <ival> NUMBER
%type <ival> expr

%token INT RETURN SEMICOLON EQUALS LBRACE RBRACE MAIN LPAREN RPAREN
%token PLUS MINUS MULTIPLY DIVIDE COMMA

%%
program: INT MAIN LPAREN RPAREN LBRACE statements RBRACE
        {
            printf("Parsed a main function with statements.\n");
        };

statements: statement
           | statements statement
           ;

statement: declaration SEMICOLON
         {
            printf("Parsed a declaration statement.\n");
         }
         | assignment SEMICOLON
         {
            printf("Parsed an assignment statement.\n");
         }
         | return_statement SEMICOLON
         {
            printf("Parsed a return statement.\n");
         }
         ;

declaration: INT var_list
            {
                printf("Parsed integer declaration(s).\n");
            }
           ;

var_list: IDENTIFIER
        | var_list COMMA IDENTIFIER
        ;

assignment: IDENTIFIER EQUALS expr
           {
               printf("Assignment to %s\n", $1);
           }
           ;

expr: NUMBER
    {
        printf("Number: %d\n", $1);
    }
    | IDENTIFIER
    {
        printf("Variable: %s\n", $1);
    }
    | expr PLUS expr
    {
        printf("Addition operation\n");
    }
    | expr MINUS expr
    {
        printf("Subtraction operation\n");
    }
    | expr MULTIPLY expr
    {
        printf("Multiplication operation\n");
    }
    | expr DIVIDE expr
    {
        printf("Division operation\n");
    }
    ;

return_statement: RETURN NUMBER
                 {
                     printf("Return statement with value %d\n", $2);
                 };

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
}

int main() {
    char filepath[256];

    printf("Please enter the path to the desired file: ");
    fflush(stdout);

    if (fgets(filepath, sizeof(filepath), stdin) == NULL) {
        fprintf(stderr, "Error reading file path\n");
        exit(1);
    }

    filepath[strcspn(filepath, "\n")] = 0;

    FILE *file = fopen(filepath, "r");
    if (!file) {
        perror(filepath);
        exit(1);
    }

    yyin = file;
    yyparse();
    fclose(file);

    return 0;
}
