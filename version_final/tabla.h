#ifndef TABLA_H
#define TABLA_H

#include <stdio.h>

#define TAMANO_MAXIMO_TABLA 100  // Define el tamaño máximo de las tablas

// Declaración de la estructura Tabla
typedef struct Tabla {
    char *tokens[TAMANO_MAXIMO_TABLA];
    int clase;
    int contador;

    void (*init)(struct Tabla*, int, int);
    void (*addToken)(struct Tabla*, const char*);
} Tabla;

// Prototipos de funciones
Tabla* initTable(int clase, int contador);
void imprimir_tabla_CSV(FILE *archivo, Tabla *tabla, const char *nombre_clase);
int buscar_token_en_csv(const char *token);

// Declaración de las tablas globales
extern Tabla *palabras_reservadas;
extern Tabla *operadores;
extern Tabla *simbolos_especiales;
extern Tabla *numeros;
extern Tabla *variables;
extern Tabla *cadenas;
extern Tabla *errores;

#endif  // TABLA_H
