#include "tabla.h"

// Definiciones globales de las tablas
Tabla palabras_reservadas = {.clase = 0, .contador = 0};
Tabla operadores = {.clase = 1, .contador = 0};
Tabla simbolos_especiales = {.clase = 2, .contador = 0};
Tabla numeros = {.clase = 3, .contador = 0};
Tabla variables = {.clase = 4, .contador = 0};

int token_existe(Tabla *tabla, const char *token) {
    for (int i = 0; i < tabla->contador; i++) {
        if (strcmp(tabla->tokens[i], token) == 0) {
            return 1;  // El token ya existe en la tabla
        }
    }
    return 0;  // El token no existe en la tabla
}

void agregar_a_tabla(Tabla *tabla, const char *token) {
    if (tabla->contador < TAMANO_MAXIMO_TABLA && !token_existe(tabla, token)) {
        tabla->tokens[tabla->contador++] = strdup(token);
    } else {
        fprintf(stderr, "Error: Tabla llena o token ya existe\n");
    }
}

void imprimir_tabla(Tabla *tabla, const char *nombre_clase) {
    printf("%s:\n", nombre_clase);
    for (int i = 0; i < tabla->contador; i++) {
        printf("%d %s\n", i, tabla->tokens[i]);
    }
}

void finalizar() {
    imprimir_tabla(&palabras_reservadas, "Palabra Reservada");
    imprimir_tabla(&operadores, "Operadores");
    imprimir_tabla(&simbolos_especiales, "Símbolos Especiales");
    imprimir_tabla(&numeros, "Tabla Números");
    imprimir_tabla(&variables, "Tabla Variables");
}
