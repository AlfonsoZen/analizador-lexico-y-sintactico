%{
#include "y.tab.h"
#include "tabla.h"
%}

%%

"for"                { palabras_reservadas->addToken(palabras_reservadas, yytext); return FOR; }
"while"              { palabras_reservadas->addToken(palabras_reservadas, yytext); return WHILE; }
"do"                 { palabras_reservadas->addToken(palabras_reservadas, yytext); return DO; }
"if"                 { palabras_reservadas->addToken(palabras_reservadas, yytext); return IF; }
"else"               { palabras_reservadas->addToken(palabras_reservadas, yytext); return ELSE; }
"switch"             { palabras_reservadas->addToken(palabras_reservadas, yytext); return SWITCH; }
"case"               { palabras_reservadas->addToken(palabras_reservadas, yytext); return CASE; }
"default"            { palabras_reservadas->addToken(palabras_reservadas, yytext); return DEFAULT; }
"break"              { palabras_reservadas->addToken(palabras_reservadas, yytext); return BREAK; }

"=="                { operadores->addToken(operadores, yytext); return IGUALIGUAL; }
"!="                { operadores->addToken(operadores, yytext); return DIFERENTE; }
">"                 { operadores->addToken(operadores, yytext); return MAYOR; }
"<"                 { operadores->addToken(operadores, yytext); return MENOR; }
">="                { operadores->addToken(operadores, yytext); return MAYORIGUAL; }
"<="                { operadores->addToken(operadores, yytext); return MENORIGUAL; }

"="                 { operadores->addToken(operadores, yytext); return ASIGNACION; }
";"                 { simbolos_especiales->addToken(simbolos_especiales, yytext); return PUNTOYCOMA; }
":"                 { simbolos_especiales->addToken(simbolos_especiales, yytext); return DOSPUNTOS; }
"("                 { simbolos_especiales->addToken(simbolos_especiales, yytext); return PARENTESISIZQUIERDO; }
")"                 { simbolos_especiales->addToken(simbolos_especiales, yytext); return PARENTESISDERECHO; }
"{"                 { simbolos_especiales->addToken(simbolos_especiales, yytext); return LLAVEIZQUIERDA; }
"}"                 { simbolos_especiales->addToken(simbolos_especiales, yytext); return LLAVEDERECHA; }
"--"                { operadores->addToken(operadores, yytext); return DECREMENTO; }
"++"                { operadores->addToken(operadores, yytext); return INCREMENTO; }

[a-zA-Z_][a-zA-Z0-9_]* { variables->addToken(variables, yytext); yylval.sval = strdup(yytext); return IDENTIFICADOR; }

[0-9]+              { numeros->addToken(numeros, yytext); yylval.ival = atoi(yytext); return NUMERO; }

[ \t\n]+            { /* Ignorar espacios en blanco */ }

%%

int yywrap() {
    return 1;
}
