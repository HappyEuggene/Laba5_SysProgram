%option noyywrap
%option yylineno

%{
#include "parser.tab.h" // This might be y.tab.h based on your setup
extern int yylineno;
%}

%%

"int"       { return INT; }
"main"      { return MAIN; }
"return"    { return RETURN; }
","         { return COMMA; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULTIPLY; }
"/"         { return DIVIDE; }
[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; }
";"         { return SEMICOLON; }
"="         { return EQUALS; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.sval = strdup(yytext); return IDENTIFIER; }

[\t\n\r]+   { /* ignore whitespace */ }
.           { /* ignore other characters */ }

%%
