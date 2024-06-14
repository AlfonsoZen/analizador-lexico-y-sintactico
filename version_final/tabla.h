#ifndef TABLE_H
#define TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TABLE_SIZE 100

typedef struct {
    char *tokens[MAX_TABLE_SIZE];
    int class;
    int count;
} Table;

extern Table reserved_words;
extern Table operators;
extern Table special_symbols;
extern Table numbers;
extern Table variables;

// Agrega un token a la tabla si no existe aún
void add_token_to_table(Table *table, const char *token);

// Imprime el contenido de una tabla en la consola
void print_table(Table *table, const char *class_name);

// Imprime todas las tablas al finalizar el programa
void finalize();

#endif
