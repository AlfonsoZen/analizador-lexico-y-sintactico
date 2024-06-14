%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAMANO_MAXIMO_TABLA 100  // Define el tamaño máximo de las tablas

extern int yylex(void);    // Declara la función yylex, generada por Flex
extern int yyparse(void);  // Declara la función yyparse, generada por Yacc
extern int yylineno;       // Declara la variable yylineno, lleva la cuenta del número de línea
extern FILE *yyin;         // Archivo de entrada para el lexer

typedef struct {
    char *tokens[TAMANO_MAXIMO_TABLA];  // Arreglo de punteros a cadenas
    int clase;                          // Clase de los tokens en la tabla
    int contador;                       // Contador de tokens en la tabla
} Tabla;

// Inicialización de las tablas
Tabla palabras_reservadas = { .clase = 0, .contador = 0 };
Tabla operadores = { .clase = 1, .contador = 0 };
Tabla simbolos_especiales = { .clase = 2, .contador = 0 };
Tabla numeros = { .clase = 3, .contador = 0 };
Tabla variables = { .clase = 4, .contador = 0 };
Tabla cadenas = { .clase = 5, .contador = 0 };
Tabla errores = { .clase = 6, .contador = 0 };

void yyerror(const char *s);  // Para manejar errores sintácticos

// Función para verificar si un token ya existe en la tabla
int token_existe(Tabla *tabla, const char *token) {
    for (int i = 0; i < tabla->contador; i++) {
        if (strcmp(tabla->tokens[i], token) == 0) {
            return 1;  // El token ya existe en la tabla
        }
    }
    return 0;  // El token no existe en la tabla
}

// Función para buscar el identificador de un token en el archivo CSV
int buscar_token_en_csv(const char *token) {
    FILE *archivo = fopen("Clases.csv", "r");
    if (!archivo) {
        perror("No se pudo abrir el archivo CSV");
        return 0;
    }

    char linea[100];
    while (fgets(linea, sizeof(linea), archivo)) {
        // Dividir la línea en tokens separados por comas
        char *token_csv = strtok(linea, ",");
        if (token_csv && strcmp(token_csv, token) == 0) {
            // El token coincide, obtener el identificador
            char *valor1 = strtok(NULL, ",");
            if (valor1) {
                int num = atoi(valor1);  // Convertir el primer valor a entero
                fclose(archivo);
                return num;
            }
        }
    }

    // Si se llega aquí, el token no fue encontrado
    fclose(archivo);
    return 0;  // Se retorna 0 como identificador no encontrado
}

// Función para agregar tokens a una tabla
void agregar_a_tabla(Tabla *tabla, const char *token) {
    if (tabla->contador < TAMANO_MAXIMO_TABLA) {  // Verifica si la tabla no está llena
        if (!token_existe(tabla, token)) {  // Verifica si el token ya existe en la tabla
            tabla->tokens[tabla->contador++] = strdup(token);  // Duplica el token y lo agrega a la tabla
        }
    } else {
        fprintf(stderr, "Error: Tabla llena\n");  // Imprime un mensaje de error si la tabla está llena
    }
}

// Función para imprimir una tabla en el archivo CSV
void imprimir_tabla_CSV(FILE *archivo, Tabla *tabla, const char *nombre_clase) {
    for (int i = 0; i < tabla->contador; i++) {
        int num = buscar_token_en_csv(tabla->tokens[i]);
        fprintf(archivo, "%s,%d,%d,%s\n", tabla->tokens[i], num, tabla->clase, nombre_clase);
    }
}

//Función para imprimir tablas en la terminal
void imprimir_tabla(Tabla *tabla, const char *nombre_clase){
    printf("%s \n", nombre_clase);
    for (int i = 0; i < tabla -> contador; i++) {
        printf("%d %s\n", i, tabla ->tokens[i]);
    }
}

// Función para imprimir todas las tablas al final del análisis
void finalizar() {
    FILE *archivo = fopen("tokens.csv", "w");
    if (!archivo) {
        perror("No se pudo abrir el archivo CSV");
        return;
    }
    fprintf(archivo, "Token,Identificador,Clase,Nombre_Clase\n");

    imprimir_tabla_CSV(archivo, &palabras_reservadas, "Palabra Reservada");
    imprimir_tabla_CSV(archivo, &operadores, "Operadores");
    imprimir_tabla_CSV(archivo, &simbolos_especiales, "Símbolos Especiales");
    imprimir_tabla(&numeros, "Tabla Números");
    imprimir_tabla(&variables, "Tabla Variables");
    imprimir_tabla(&cadenas, "Tabla Cadenas");
    imprimir_tabla(&errores, "Tabla Errores");

    fclose(archivo);
}

%}

// Declaración de uniones y tokens
%union {
    int ival;      // Para almacenar números enteros
    char *sval;    // Para almacenar cadenas
}

%token <ival> NUMBER      // Declara el token NUMBER que almacena un entero
%token <sval> IDENTIFIER  // Declara el token IDENTIFIER que almacena una cadena
%token IF ELSE WHILE FOR PRINTF // Declara los tokens para las palabras clave
%token LPAREN RPAREN LBRACE RBRACE  // Declara los tokens para los paréntesis y llaves
%token SEMICOLON COMPARE OPERATE SPACE CADENA // Declara los tokens para el punto y coma, operadores de comparación, operadores, espacio y cadenas

%%

// Reglas de la gramática
programa:
    sentencias 
    ;

sentencias:
    sentencias sentencia
    | sentencia
    ;

sentencia:
    sentencia_control
    | sentencia_expresion SEMICOLON
    ;

sentencia_control:
    IF LPAREN condicion RPAREN LBRACE sentencias RBRACE
    | IF LPAREN condicion RPAREN LBRACE sentencias RBRACE ELSE LBRACE sentencias RBRACE
    | WHILE LPAREN condicion RPAREN LBRACE sentencias RBRACE
    | FOR LPAREN operacion SEMICOLON condicion SEMICOLON variable SPACE RPAREN LBRACE sentencias RBRACE
    ;

operacion:
    variable OPERATE variable
    | operacion OPERATE variable
    ;

condicion:
    variable COMPARE variable 
    | variable
    ;

sentencia_expresion:
    operacion 
    | variable 
    | PRINTF LPAREN CADENA RPAREN
    ;

variable:
    IDENTIFIER
    | NUMBER
    | CADENA
    ;

%%

// Función para manejar errores sintácticos
void yyerror(const char *msg) {
    fprintf(stderr, "Error sintáctico en la línea %d: %s en '%s'\n", yylineno, msg, yytext);
    agregar_a_tabla(&errores, yytext);  // Agrega el token a la tabla de errores
}

// Función principal
int main(void) {
    const char *nombre_archivo = "prueba.txt";  // Nombre del archivo de entrada
    FILE *archivo = fopen(nombre_archivo, "r");  // Abre el archivo de entrada
    if (!archivo) {  // Verifica si el archivo se abrió correctamente
        perror("No se pudo abrir el archivo");
        return 1;  // Termina con error si no se pudo abrir el archivo
    }
    yyin = archivo;  // Establece yyin como el archivo de entrada para Flex
    yyparse();  // Llama a la función de análisis sintáctico
    fclose(archivo);  // Cierra el archivo de entrada

    finalizar();  // Imprime todas las tablas en un solo archivo CSV

    return 0;  // Termina el programa con éxito
}