#include "tabla.h"

int main() {
    // Ejemplo de uso de las funciones definidas en tabla.h y tabla.c
    
    // Agregar algunos tokens a las tablas
    agregar_a_tabla(&palabras_reservadas, "if");
    agregar_a_tabla(&palabras_reservadas, "else");
    agregar_a_tabla(&operadores, "+");
    agregar_a_tabla(&operadores, "-");
    agregar_a_tabla(&simbolos_especiales, "(");
    agregar_a_tabla(&simbolos_especiales, ")");
    agregar_a_tabla(&numeros, "123");
    agregar_a_tabla(&numeros, "456");
    agregar_a_tabla(&variables, "x");
    agregar_a_tabla(&variables, "y");

    // Imprimir todas las tablas
    finalizar();

    return 0;
}
