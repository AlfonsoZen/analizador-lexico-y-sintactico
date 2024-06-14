#ifndef TABLA_H
#define TABLA_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAMANO_MAXIMO_TABLA 100

typedef struct {
    char *tokens[TAMANO_MAXIMO_TABLA];
    int clase;
    int contador;
} Tabla;

extern Tabla palabras_reservadas;
extern Tabla operadores;
extern Tabla simbolos_especiales;
extern Tabla numeros;
extern Tabla variables;

int token_existe(Tabla *tabla, const char *token);
void agregar_a_tabla(Tabla *tabla, const char *token);
void imprimir_tabla(Tabla *tabla, const char *nombre_clase);
void finalizar();

#endif
