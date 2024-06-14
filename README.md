# analizador-lexico-y-sintactico

## Instrucciones de compilación:
- flex proyecto.l
- yacc -d proyecto.y
- gcc lex.yy.c y.tab.c -o proyecto
- ./proyecto entrada.c