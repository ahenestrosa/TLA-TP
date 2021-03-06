#ifndef __NODE_H__
#define __NODE_H__
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "translation/symboltable.h"
#define LENGTH 5000
#define MAX_CONCAT 5   

typedef enum {
    NODE_LIST = 0,
    NODE_FUNCTIONS,
    NODE_ENTRYPOINT,
    NODE_HYPERSTATEMENT,
    NODE_HYPERSTATEMENTS,
    NODE_INBLOCKSTATEMENTS,
    NODE_INBLOCKSTATEMENT,
    NODE_IFSENTENCE,
    NODE_IFSENTENCE_ELSE,
    NODE_ELSETRAIN,
    NODE_WHILE,
    NODE_STATEMENT,
    NODE_VARDECLARATION,
    NODE_VARDECLASSIGNMENT,
    NODE_FOREACH,
    NODE_FOREACHBODY,
    NODE_BLOCK,
    NODE_ASSIGNMENT,

    NODE_LITERAL,
    NODE_VARIABLE,
    NODE_VARIABLE_ASSIGNMENT,
    NODE_VARIABLE_REF,  
    NODE_ARRAYLITERAL,
    NODE_STRING_LITERAL,

    NODE_OPERATION,
    NODE_G_OPERATION,

    NODE_EXPRESSION,
    NODE_G_EXPRESSION,

    NODE_INT,
    NODE_DOUBLE,
    NODE_STR,
    NODE_ARR_INT,
    NODE_ARR_DOUBLE,

    NODE_NUMLIST,

    NODE_PRINT,
    NODE_GET_INT,
    NODE_GET_DOUBLE,
    NODE_GET_STRING,

    NODE_ARRAY_ACCESS,

    NODE_EXIT,

} NodeType;

// Information about the node itinfo
typedef struct NodeInfo {
    NodeType type;
    VarType varType;
    int isMeta;
    int line;
} NodeInfo;

// List of nodes
typedef struct NodeList {
    NodeInfo info;                          // Information about the type of node
    struct GenericNode * current;           // The current node with information
    struct NodeList * next;                 // The next node on the list
} NodeList;

// This is used so as to enable polymorphism and reduce
// code size

typedef struct GenericNode {
    NodeInfo info;
    char * value;
    struct GenericNode * parent;
    NodeList * children;
} GenericNode;

// Node for a functions section
typedef struct FunctionsNode {
    NodeInfo info;                  // Information about the type of node
    NodeList * functions;           // List of functions declared
} FunctionsNode;

NodeList * createNodeList(GenericNode * node, int line);
NodeList * addToNodeList(NodeList * nodeList, GenericNode * node);
NodeList * prependToNodeList(NodeList * nodeList, GenericNode * node);

GenericNode * newGenericNode(NodeType type, char * value, int line);
GenericNode * newGenericNodeWithChildren(NodeType type, char * value, int line, int childrenCound, ...);

void changeDescendantVarType(GenericNode * gn, char * varName, VarType targetVarType, int isMeta);
void changeDescendantVarTypeForList(NodeList * nl, char * varName, VarType targetVarType, int isMeta);

int hasDescendantOfType(GenericNode * gn, NodeType nodeType);

void freeGenericNode(GenericNode * GenericNode);
void freeNodeList (NodeList * nl);

void printGenericNode(GenericNode * gn, int tabs);
void printNodeList (NodeList * nl, int tabs);

#endif