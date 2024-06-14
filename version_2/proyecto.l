%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.c"

extern Tabla palabras_reservadas;
extern Tabla operadores;
extern Tabla simbolos_especiales;
extern Tabla numeros;
extern Tabla variables;
extern Tabla cadenas;
extern Tabla errores;


void agregar_a_tabla(Tabla *tabla, const char *token);  // Declaración de la función para agregar tokens a las tablas
%}

%option lex-compat  

%%

"if"        { agregar_a_tabla(&palabras_reservadas, yytext); return IF; }
"else"      { agregar_a_tabla(&palabras_reservadas, yytext); return ELSE; }
"while"     { agregar_a_tabla(&palabras_reservadas, yytext); return WHILE; }
"for"       { agregar_a_tabla(&palabras_reservadas, yytext); return FOR; }
"printf"    { agregar_a_tabla(&palabras_reservadas, yytext); return PRINTF; }
"("         { agregar_a_tabla(&simbolos_especiales, yytext); return LPAREN; }
")"         { agregar_a_tabla(&simbolos_especiales, yytext); return RPAREN; }
"{"         { agregar_a_tabla(&simbolos_especiales, yytext); return LBRACE; }
"}"         { agregar_a_tabla(&simbolos_especiales, yytext); return RBRACE; }
";"         { agregar_a_tabla(&simbolos_especiales, yytext); return SEMICOLON; }
[-+=*/]     { agregar_a_tabla(&operadores, yytext); return OPERATE; }
[<>]        { agregar_a_tabla(&operadores, yytext); return COMPARE; }
"=="        { agregar_a_tabla(&operadores, yytext); return COMPARE; }
"<="        { agregar_a_tabla(&operadores, yytext); return COMPARE; }
">="        { agregar_a_tabla(&operadores, yytext); return COMPARE; }
"++"        { agregar_a_tabla(&operadores, yytext); return SPACE; }
"--"        { agregar_a_tabla(&operadores, yytext); return SPACE; }
\"([^"\\]|\\.)*\"  { agregar_a_tabla(&cadenas, yytext); return CADENA; }
[0-9]+      { yylval.ival = atoi(yytext); agregar_a_tabla(&numeros, yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); agregar_a_tabla(&variables, yytext); return IDENTIFIER; }
[\t \n]     { /* Ignorar espacios en blanco */ }
.           { printf("Token incorrecto: %s\n", yytext); agregar_a_tabla(&errores, yytext); }

%%
// Función de envoltura para Flex
int yywrap(void) { 
    return 1; 
}