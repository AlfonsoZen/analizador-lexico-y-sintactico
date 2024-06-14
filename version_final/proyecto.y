%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabla.h"

// Declaraciones de funciones externas generadas por Flex
extern int yylex(void);
extern int yylineno;
extern char* yytext;
extern FILE *yyin;


// Función para manejar errores sintácticos
void yyerror(const char *s);

void imprimir_tabla_CSV(FILE *archivo, Tabla *tabla, const char *nombre_clase) {
    for (int i = 0; i < tabla->contador; i++) {
        int num = buscar_token_en_csv(tabla->tokens[i]);
        fprintf(archivo, "%s,%d,%d,%s\n", tabla->tokens[i], num, tabla->clase, nombre_clase);
    }
}

// Declaración de uniones y tokens
%}

%union {
    int ival;      // Para almacenar números enteros
    char *sval;    // Para almacenar cadenas
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
        ;

    if_else_statement:
        IF PARENTESISIZQUIERDO comparison PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA ELSE LLAVEIZQUIERDA statement LLAVEDERECHA
        {
            printf("Expression Válida\n");
        }
        // | IF PARENTESISIZQUIERDO comparison PARENTESISDERECHO LLAVEIZQUIERDA statement LLAVEDERECHA ELSE if_else_statement LLAVEIZQUIERDA statement LLAVEDERECHA
        // {
        //     printf("IF ELSE ANIDADO\n");
        // }
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
void yyerror(const char *msg) {
    fprintf(stderr, "Error sintáctico en la línea %d: %s en '%s'\n", yylineno, msg, yytext);
    errores->addToken(errores, yytext);  // Agrega el token a la tabla de errores
}

// Función principal
int main(int argc, char **argv) {
    // Inicializar las tablas globales
    palabras_reservadas = initTable(0, 0);
    operadores = initTable(1, 0);
    simbolos_especiales = initTable(2, 0);
    numeros = initTable(3, 0);
    variables = initTable(4, 0);
    cadenas = initTable(5, 0);
    errores = initTable(6, 0);

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin; // Establece yyin como el archivo de entrada para Flex
    }

    yyparse();  // Llama a la función de análisis sintáctico

    // Imprimir los resultados o procesar las tablas según sea necesario
        FILE *archivo_csv = fopen("tokens.csv", "w");
    if (!archivo_csv) {
        perror("No se pudo abrir el archivo CSV para escritura");
        return 1;
    }

    fprintf(archivo_csv, "Token,Identificador,Clase,Nombre_Clase\n");
    imprimir_tabla_CSV(archivo_csv, palabras_reservadas, "Palabra Reservada");
    imprimir_tabla_CSV(archivo_csv, operadores, "Operadores");
    imprimir_tabla_CSV(archivo_csv, simbolos_especiales, "Símbolos Especiales");
    imprimir_tabla_CSV(archivo_csv, numeros, "Tabla Números");
    imprimir_tabla_CSV(archivo_csv, variables, "Tabla Variables");
    imprimir_tabla_CSV(archivo_csv, cadenas, "Tabla Cadenas");
    imprimir_tabla_CSV(archivo_csv, errores, "Tabla Errores");

    fclose(archivo_csv);

    // Liberar memoria asignada para los tokens
    for (int i = 0; i < errores->contador; i++) {
        free(errores->tokens[i]);
    }

    // Liberar memoria asignada para las tablas
    free(palabras_reservadas);
    free(operadores);
    free(simbolos_especiales);
    free(numeros);
    free(variables);
    free(cadenas);
    free(errores);

    return 0;  // Termina el programa con éxito
}