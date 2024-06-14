%{
#include "y.tab.h"
#include <string.h>
#include <stdio.h>
%}

%option noyywrap
%option yylineno

/* Archivos para las tablas */
FILE *words_file;
FILE *ops_file;
FILE *symbols_file;
FILE *numbers_file;
FILE *vars_file;

%%


"for"                { fprintf(words_file, "for, Palabras Reservadas\n"); return FOR; }
"while"              { fprintf(words_file, "while, Palabras Reservadas\n"); return WHILE; }
"if"                 { fprintf(words_file, "if, Palabras Reservadas\n"); return IF; }
"else"               { fprintf(words_file, "else, Palabras Reservadas\n"); return ELSE; }
"switch"             { fprintf(words_file, "switch, Palabras Reservadas\n"); return SWITCH; }
"case"               { fprintf(words_file, "case, Palabras Reservadas\n"); return CASE; }
"default"            { fprintf(words_file, "default, Palabras Reservadas\n"); return DEFAULT; }
"break"              { fprintf(words_file, "break, Palabras Reservadas\n"); return BREAK; }


"=="                { fprintf(ops_file, "==, Operadores\n"); return IGUALIGUAL; }
"!="                { fprintf(ops_file, "!=", Operadores\n"); return DIFERENTE; }
">"                 { fprintf(ops_file, ">, Operadores\n"); return MAYOR; }
"<"                 { fprintf(ops_file, "<, Operadores\n"); return MENOR; }
">="                { fprintf(ops_file, ">=, Operadores\n"); return MAYORIGUAL; }
"<="                { fprintf(ops_file, "<=, Operadores\n"); return MENORIGUAL; }


"="                 { fprintf(ops_file, "=, Operadores\n"); return ASIGNACION; }


";"                 { fprintf(symbols_file, ";, Símbolos Especiales\n"); return PUNTOYCOMA; }
":"                 { fprintf(symbols_file, ":, Símbolos Especiales\n"); return DOSPUNTOS; }
"("                 { fprintf(symbols_file, "(, Símbolos Especiales\n"); return PARENIZQUIERDO; }
")"                 { fprintf(symbols_file, "), Símbolos Especiales\n"); return PARENDERECHO; }
"{"                 { fprintf(symbols_file, "{, Símbolos Especiales\n"); return LLAVEIZQUIERDA; }
"}"                 { fprintf(symbols_file, "}, Símbolos Especiales\n"); return LLAVEDERECHA; }
"--"                { fprintf(ops_file, "--, Operadores\n"); return DECREMENTO; }
"++"                { fprintf(ops_file, "++, Operadores\n"); return INCREMENTO; }


[a-zA-Z_][a-zA-Z0-9_]* { fprintf(vars_file, "%s, Identificadores\n", yytext); yylval.str = strdup(yytext); return IDENTIFICADOR; }


[0-9]+              { fprintf(numbers_file, "%s, Números\n", yytext); yylval.num = atoi(yytext); return NUMERO; }

[ \t\n]+            { /* Ignorar espacios en blanco */ }


.                   { printf("Error léxico: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
