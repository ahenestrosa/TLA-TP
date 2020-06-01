#include "statementTranslation.h"

char * processStatement(GenericNode * gn) {
    if (gn->children == NULL){
        return NULL;
    }
    char * childString = process(gn->children->current);
    if (childString == NULL){
        return NULL;
    }
    strcat(childString, ";");
    printf("a statement %s\n", childString);
    return childString;
}