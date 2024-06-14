#include "tabla.h"

int main() {
    // Ejemplo de uso de las funciones definidas en tabla.h y tabla.c
    
    // Agregar algunos tokens a las tablas
    add_to_table(&reserved_words, "if");
    add_to_table(&reserved_words, "else");
    add_to_table(&operators, "+");
    add_to_table(&operators, "-");
    add_to_table(&special_symbols, "(");
    add_to_table(&special_symbols, ")");
    add_to_table(&numbers, "123");
    add_to_table(&numbers, "456");
    add_to_table(&variables, "x");
    add_to_table(&variables, "y");

    // Imprimir todas las tablas al finalizar
    finalize();

    return 0;
}
