#ifndef _yy_defines_h_
#define _yy_defines_h_

#define NUMERO 257
#define IDENTIFICADOR 258
#define FOR 259
#define DO 260
#define WHILE 261
#define IF 262
#define ELSE 263
#define SWITCH 264
#define CASE 265
#define DEFAULT 266
#define BREAK 267
#define IGUALIGUAL 268
#define DIFERENTE 269
#define MAYOR 270
#define MENOR 271
#define MAYORIGUAL 272
#define MENORIGUAL 273
#define ASIGNACION 274
#define PUNTOYCOMA 275
#define DOSPUNTOS 276
#define PARENTESISIZQUIERDO 277
#define PARENTESISDERECHO 278
#define LLAVEIZQUIERDA 279
#define LLAVEDERECHA 280
#define DECREMENTO 281
#define INCREMENTO 282
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE {
    int ival;      /* Para almacenar números enteros*/
    char *sval;    /* Para almacenar cadenas*/
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
