%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
}

/* Archivos para las tablas */
extern FILE *words_file;
extern FILE *ops_file;
extern FILE *symbols_file;
extern FILE *numbers_file;
extern FILE *vars_file;
%}

%union {
    char *str;
    int num;
}

%token FOR WHILE IF ELSE SWITCH CASE DEFAULT BREAK
%token IGUALIGUAL DIFERENTE MAYOR MENOR MAYORIGUAL MENORIGUAL
%token ASIGNACION PUNTOYCOMA DOSPUNTOS PARENIZQUIERDO PARENDERECHO LLAVEIZQUIERDA LLAVEDERECHA
%token DECREMENTO INCREMENTO
%token <str> IDENTIFICADOR
%token <num> NUMERO

%start programa

%%

programa:
    sentencias
    ;

sentencias:
    /* epsilon */
    | sentencia
    | sentencias sentencia
    ;

sentencia:
    sentencia_for
    | sentencia_while
    | sentencia_if
    | sentencia_switch
    ;

sentencia_for:
    FOR PARENIZQUIERDO for_interior PARENDERECHO bloque
    ;

for_interior:
    expresion_opcional PUNTOYCOMA expresion_opcional PUNTOYCOMA expresion_opcional 
    ;

sentencia_while:
    WHILE PARENIZQUIERDO expresion PARENDERECHO bloque
    ;

sentencia_if:
    IF PARENIZQUIERDO expresion PARENDERECHO bloque
    | IF PARENIZQUIERDO expresion PARENDERECHO bloque ELSE bloque
    ;

sentencia_switch:
    SWITCH PARENIZQUIERDO expresion PARENDERECHO LLAVEIZQUIERDA lista_casos LLAVEDERECHA
    ;

lista_casos:
    caso
    | lista_casos caso
    ;

caso:
    CASE expresion DOSPUNTOS sentencias BREAK PUNTOYCOMA
    | DEFAULT DOSPUNTOS sentencias
    ;

bloque:
    LLAVEIZQUIERDA sentencias LLAVEDERECHA
    | sentencia
    ;

expresion_opcional:
    /* epsilon */
    | expresion
    ;

expresion:
    IDENTIFICADOR
    | NUMERO
    | IDENTIFICADOR ASIGNACION expresion
    | expresion IGUALIGUAL expresion
    | expresion DIFERENTE expresion
    | expresion MAYOR expresion
    | expresion MENOR expresion
    | expresion MAYORIGUAL expresion
    | expresion MENORIGUAL expresion
    | IDENTIFICADOR INCREMENTO
    | IDENTIFICADOR DECREMENTO
    | PARENIZQUIERDO expresion PARENDERECHO
    ;

%%

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo de entrada>\n", argv[0]);
        return 1;
    }

    FILE *archivo_entrada = fopen(argv[1], "r");
    if (!archivo_entrada) {
        perror("fopen");
        return 1;
    }
    yyin = archivo_entrada;

    words_file = fopen("words.csv", "w");
    ops_file = fopen("ops.csv", "w");
    symbols_file = fopen("symbols.csv", "w");
    numbers_file = fopen("numbers.csv", "w");
    vars_file = fopen("vars.csv", "w");

    yyparse();
    yylex();

    fclose(words_file);
    fclose(ops_file);
    fclose(symbols_file);
    fclose(numbers_file);
    fclose(vars_file);

    fclose(archivo_entrada);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
}
