#include "tabla.h"
#include <stdlib.h>
#include <string.h>

// Función para inicializar los campos de la estructura
void init(Tabla* self, int clase, int contador) {
    self->clase = clase;
    self->contador = contador;
}

// Función para agregar un token a la estructura
void addToken(Tabla* self, const char* token) {
    if (self->contador < TAMANO_MAXIMO_TABLA) {
        self->tokens[self->contador] = strdup(token); // Usamos strdup para hacer una copia del token
        self->contador++;
    } else {
        printf("Error: No se pueden agregar más tokens, la tabla está llena.\n");
    }
}

// Función para imprimir una tabla en el archivo CSV
void imprimir_tabla_CSV(FILE *archivo, Tabla *tabla, const char *nombre_clase) {
    for (int i = 0; i < tabla->contador; i++) {
        // Suponemos que buscar_token_en_csv ya está implementada y retorna el número correspondiente
        int num = buscar_token_en_csv(tabla->tokens[i]);
        fprintf(archivo, "%s,%d,%d,%s\n", tabla->tokens[i], num, tabla->clase, nombre_clase);
    }
}

// Constructor para inicializar la estructura
Tabla* initTable(int clase, int contador) {
    Tabla* newTabla = (Tabla*)malloc(sizeof(Tabla));
    if (newTabla == NULL) {
        printf("Error al asignar memoria\n");
        return NULL;
    }

    // Inicializar los métodos
    newTabla->init = init;
    newTabla->addToken = addToken;

    // Inicializar los campos
    newTabla->init(newTabla, clase, contador);

    return newTabla;
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
        // Eliminar el salto de línea al final de la línea, si existe
        linea[strcspn(linea, "\r\n")] = 0;

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