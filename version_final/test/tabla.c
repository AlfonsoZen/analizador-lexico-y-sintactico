#include "tabla.h"

// Definiciones globales de las tablas
Table reserved_words = {.class = 0, .count = 0};
Table operators = {.class = 1, .count = 0};
Table special_symbols = {.class = 2, .count = 0};
Table numbers = {.class = 3, .count = 0};
Table variables = {.class = 4, .count = 0};

// Agrega un token a la tabla si no existe aún
void add_to_table(Table *table, const char *token) {
    if (table->count < MAX_TABLE_SIZE) {
        table->tokens[table->count++] = strdup(token);
    } else {
        fprintf(stderr, "Error: Table full or token already exists\n");
    }
}

// Imprime el contenido de una tabla en la consola
void print_table(Table *table, const char *class_name) {
    printf("%s:\n", class_name);
    for (int i = 0; i < table->count; i++) {
        printf("%d %s\n", i, table->tokens[i]);
    }
}

// Imprime todas las tablas al finalizar el programa
void finalize() {
    print_table(&reserved_words, "Reserved Words");
    print_table(&operators, "Operators");
    print_table(&special_symbols, "Special Symbols");
    print_table(&numbers, "Numbers Table");
    print_table(&variables, "Variables Table");
}
