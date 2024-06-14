%{
    #include "y.tab.h"
    #include <string.h>
%}

%%

"for"                { return FOR; }
"while"              { return WHILE; }
"do"                 { return DO; }
"if"                 { return IF; }
"else"               { return ELSE; }
"switch"             { return SWITCH; }
"case"               { return CASE; }
"default"            { return DEFAULT; }
"break"              { return BREAK; }

"=="                { return IGUALIGUAL; }
"!="                { return DIFERENTE; }
">"                 { return MAYOR; }
"<"                 { return MENOR; }
">="                { return MAYORIGUAL; }
"<="                { return MENORIGUAL; }

"="                 { return ASIGNACION; }
";"                 { return PUNTOYCOMA; }
":"                 { return DOSPUNTOS; }
"("                 { return PARENTESISIZQUIERDO; }
")"                 { return PARENTESISDERECHO; }
"{"                 { return LLAVEIZQUIERDA; }
"}"                 { return LLAVEDERECHA; }
"--"                { return DECREMENTO; }
"++"                { return INCREMENTO; }

[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFICADOR; }
[0-9]+              { yylval.num = atoi(yytext); return NUMERO; }
[ \t\n]+            { /* Ignorar espacios en blanco */ }
.                   { printf("Error léxico: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
