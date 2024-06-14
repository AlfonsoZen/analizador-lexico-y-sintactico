%{
#include "tabla.h"
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


%}

%%
"for"                {  add_token_to_table(&reserved_words, yytext); return FOR; }
"while"              {  add_token_to_table(&reserved_words, yytext); return WHILE; }
"do"                 {  add_token_to_table(&reserved_words, yytext); return DO; }
"if"                 {  add_token_to_table(&reserved_words, yytext); return IF; }
"else"               {  add_token_to_table(&reserved_words, yytext); return ELSE; }
"switch"             {  add_token_to_table(&reserved_words, yytext); return SWITCH; }
"case"               {  add_token_to_table(&reserved_words, yytext); return CASE; }
"default"            {  add_token_to_table(&reserved_words, yytext); return DEFAULT; }
"break"              {  add_token_to_table(&reserved_words, yytext); return BREAK; }

"="                 { add_token_to_table(&special_symbols, yytext); return ASIGNACION; }
";"                 { add_token_to_table(&special_symbols, yytext); return PUNTOYCOMA; }
":"                 { add_token_to_table(&special_symbols, yytext); return DOSPUNTOS; }
"("                 { add_token_to_table(&special_symbols, yytext); return PARENTESISIZQUIERDO; }
")"                 { add_token_to_table(&special_symbols, yytext); return PARENTESISDERECHO; }
"{"                 { add_token_to_table(&special_symbols, yytext); return LLAVEIZQUIERDA; }
"}"                 { add_token_to_table(&special_symbols, yytext); return LLAVEDERECHA; }
"--"                { add_token_to_table(&special_symbols, yytext); return DECREMENTO; }
"++"                { add_token_to_table(&special_symbols, yytext); return INCREMENTO; }

"=="                { add_token_to_table(&operators, yytext); return IGUALIGUAL; }
"!="                { add_token_to_table(&operators, yytext); return DIFERENTE; }
">"                 { add_token_to_table(&operators, yytext); return MAYOR; }
"<"                 { add_token_to_table(&operators, yytext); return MENOR; }
">="                { add_token_to_table(&operators, yytext); return MAYORIGUAL; }
"<="                { add_token_to_table(&operators, yytext); return MENORIGUAL; }


[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); add_token_to_table(&variables, yytext); return IDENTIFICADOR; }
[0-9]+              { yylval.num = atoi(yytext); add_token_to_table(&numbers, yytext); return NUMERO; }
[ \t\n]+            { /* Ignorar espacios en blanco */ }
%%


// Función de envoltura para Flex
int yywrap(void) { 
    return 1; 
}