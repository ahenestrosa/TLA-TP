#ifndef __SYMBOLTABLE_H__
#define __SYMBOLTABLE_H__

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_VARIABLES 100
#define MAX_NAME_LENGTH 32

typedef enum {
    STRING,
    INTEGER,
    DOUBLE
} VarType;

typedef struct symvar{
    char name[32];
    VarType type;
    void * value;
} symvartype;

symvartype * symlook(char * name, symvartype * symvartable);
symvartype * symAddInt(char * name, symvartype * symvartable);
symvartype * symAddString(char * name,  symvartype * symvartable);
symvartype * symAddDouble(char * name, symvartype * symvartable);
symvartype * symSetInt(char * name, int value, symvartype * symvartable);
symvartype * symSetString(char * name, char * value, symvartype * symvartable);
symvartype * symSetDouble(char * name, double value, symvartype * symvartable);



#endif