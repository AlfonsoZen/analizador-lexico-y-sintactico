%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(const char *s);
    int yylex(void);
    extern FILE *yyin;

%}

%union {
    int num;
    char *str;
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

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }

    yyparse();
    return 0;
}
