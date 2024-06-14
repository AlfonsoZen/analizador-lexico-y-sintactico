%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla.h"


#define TAMANO_MAXIMO_TABLA 100  // Define el tamaño máximo de las tablas

extern int yylex(void);    // Declara la función yylex, generada por Flex
extern int yyparse(void);  // Declara la función yyparse, generada por Yacc
extern int yylineno;       // Declara la variable yylineno, lleva la cuenta del número de línea
extern FILE *yyin;         // Archivo de entrada para el lexer

void yyerror(const char *s);  // Para manejar errores sintácticos


%}

// Declaración de uniones y tokens
%union {
    int num;      // Para almacenar números enteros
    char *str;    // Para almacenar cadenas
}


%token <num> NUMERO
%token <str> IDENTIFICADOR

%token FOR DO WHILE IF ELSE SWITCH CASE DEFAULT BREAK

%token IGUALIGUAL DIFERENTE MAYOR MENOR MAYORIGUAL MENORIGUAL
%token ASIGNACION PUNTOYCOMA DOSPUNTOS
%token PARENTESISIZQUIERDO PARENTESISDERECHO LLAVEIZQUIERDA LLAVEDERECHA
%token DECREMENTO INCREMENTO

%%
    program:
        statement_list
        ;

    statement_list:
        statement_list statement
        | statement
        ;

    statement:
        expression
        | for_statement
        | while_statement
        | do_while_statement
        | if_statement
        | if_else_statement
        | switch_statement
        ;

    for_statement:
        FOR PARENTESISIZQUIERDO assigned PUNTOYCOMA comparison PUNTOYCOMA counter PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA 
        {
            printf("Expression Válida\n");
        }
        ;

    while_statement:
        WHILE PARENTESISIZQUIERDO comparison PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA 
        {
            printf("Expression Válida\n");
        }
        ;

    do_while_statement:
        DO LLAVEIZQUIERDA statement LLAVEDERECHA WHILE PARENTESISIZQUIERDO comparison PARENTESISDERECHO
        {
            printf("Expression Válida\n");
        }
        ;

    if_statement:
        IF PARENTESISIZQUIERDO comparison PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA
        {
            printf("Expression Válida\n");
        }
        | IF PARENTESISIZQUIERDO comparison PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA ELSE LLAVEIZQUIERDA statement LLAVEDERECHA
        {
            printf("Expression Válida\n");
        }
        ;

    if_else_statement:
        | IF PARENTESISIZQUIERDO comparison PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA ELSE if_statement LLAVEIZQUIERDA statement LLAVEDERECHA
        {
            printf("IF ELSE ANIDADO\n");
        }
        ;

    switch_statement:
        SWITCH PARENTESISIZQUIERDO IDENTIFICADOR PARENTESISDERECHO LLAVEIZQUIERDA case_statement default_statement LLAVEDERECHA
        {
            printf("Expression Válida\n");
        }

    case_statement:
        CASE NUMERO DOSPUNTOS expression BREAK PUNTOYCOMA
        | CASE NUMERO DOSPUNTOS expression BREAK PUNTOYCOMA case_statement

    default_statement:
        DEFAULT DOSPUNTOS expression BREAK PUNTOYCOMA

    assigned:
        IDENTIFICADOR ASIGNACION NUMERO
        | IDENTIFICADOR ASIGNACION IDENTIFICADOR

    comparison:
        IDENTIFICADOR IGUALIGUAL NUMERO 
        | IDENTIFICADOR DIFERENTE NUMERO 
        | IDENTIFICADOR MAYOR NUMERO 
        | IDENTIFICADOR MENOR NUMERO 
        | IDENTIFICADOR MAYORIGUAL NUMERO 
        | IDENTIFICADOR MENORIGUAL NUMERO 

    counter: 
        IDENTIFICADOR INCREMENTO 
        | IDENTIFICADOR DECREMENTO  

    expression: 
        assigned PUNTOYCOMA
        | comparison PUNTOYCOMA
        | counter PUNTOYCOMA 

%%

// Función para manejar errores sintácticos
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

// Función principal
int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    
    yyparse();  // Llama a la función de análisis sintáctico

    finalize();  // Imprime todas las tablas en un solo archivo CSV

    return 0;  // Termina el programa con éxito
}