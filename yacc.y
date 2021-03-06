%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
    #include "translation/symboltable.h"
    #include "node.h"
    #include "translation/translation.h"
    #include "translation/declTranslation.h"

    void yyerror(GenericNode ** codeRootNode, char *s);
    int yylex();
    
    extern int yylineno;

    extern char * translate_program(GenericNode * gn, void (*error_fun)(GenericNode **, char *));

    GenericNode * codeRootNode;
%}

%start entrypoint


%union {
    char character;
    int integer;
    double decimal;
    char string[5000];
    struct GenericNode * node;
    struct NodeList * nodelist;
}

%parse-param {struct GenericNode ** codeRootNode}

%token<string> IF ELSE_IF ELSE WHILE
%token<string> FOREACH RIGHT_ARROW
%token<string> COMMA SEMICOLON DOT
%token<string> INT STR DOUBLE
%token<string> EQ GT GE LT LE NE
%token<string> NUMBER_LITERAL STRING_LITERAL
%token<string> VAR
%token<string> ADD SUBS PROD DIV MODULE CROSS SPROD
%token<string> AND OR NOT
%token<string> OPEN_B CLOSE_B OPEN_P CLOSE_P OPEN_BRACK CLOSE_BRACK
%token<string> PRINT
%token<string> START END
%token<string> DEFINE PASSING
%token<string> ASSIGN_EQ
%token<string> INT_ARR DOUBLE_ARR
%token<string> GET_INT GET_DOUBLE GET_STRING
%token<string> EXIT

%type<node> entrypoint
%type<nodelist> hyperstatements
%type<node> hyperstatement
%type<node> expression
%type<node> generalexpression
%type<node> generaloperation
%type<node> operation
%type<node> unity
%type<node> expunity
%type<node> ifsentence
%type<node> statement
%type<node> block 
%type<nodelist> inblockstatements
%type<node> inblockstatement
%type<node> foreach foreachbody
%type<node> assignment vardeclassignment vardeclaration
%type<node> type literal
%type<node> while print
%type<node> elsetrain
%type<node> arrayliteral
%type<nodelist> numlist
%type<node> arraccess
%type<node> getfunctions
%type<node> exit

%%

entrypoint: 	
        START hyperstatements END 	{
        // create node for hyprestatements
        GenericNode * hyperstatements = newGenericNode(NODE_HYPERSTATEMENTS, 0, yylineno);
        hyperstatements->children = $2;
        *codeRootNode = newGenericNodeWithChildren(NODE_ENTRYPOINT, 0, yylineno, 1, hyperstatements); $$ = *codeRootNode;
        }
        |       START END       		{
                *codeRootNode = newGenericNode(NODE_ENTRYPOINT, 0, yylineno); $$ = *codeRootNode;
                }
        ;

hyperstatements: 	hyperstatement hyperstatements 	{$$ = prependToNodeList($2, $1);}
        |       	hyperstatement 			{$$ = createNodeList($1, yylineno);}
        ;

hyperstatement:	statement SEMICOLON 	{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |       block   		{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |       ifsentence        	{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |      	while   		{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        ;

inblockstatements:	inblockstatement inblockstatements 	{$$ = prependToNodeList($2, $1);}
        | 		inblockstatement 			{$$ = createNodeList($1, yylineno);}
        ;
inblockstatement:	statement SEMICOLON 	{$$ = newGenericNodeWithChildren(NODE_INBLOCKSTATEMENT, 0, yylineno, 1, $1);}
        |       	ifsentence        	{$$ = newGenericNodeWithChildren(NODE_INBLOCKSTATEMENT, 0, yylineno, 1, $1);}
        |       	while   		{$$ = newGenericNodeWithChildren(NODE_INBLOCKSTATEMENT, 0, yylineno, 1, $1);}
        ;

ifsentence:	IF OPEN_P generalexpression CLOSE_P block
                {$$ = newGenericNodeWithChildren(NODE_IFSENTENCE, 0, yylineno, 2, $3, $5);}
        |       IF OPEN_P generalexpression CLOSE_P block elsetrain
                {$$ = newGenericNodeWithChildren(NODE_IFSENTENCE_ELSE, 0, yylineno,3, $3, $5, $6);}
        ;

elsetrain:	ELSE block
                {$$ = newGenericNodeWithChildren(NODE_ELSETRAIN, "ELSE", yylineno, 1, $2);}
        |       ELSE_IF OPEN_P generalexpression CLOSE_P block
                {$$ = newGenericNodeWithChildren(NODE_ELSETRAIN, "ELSE_IF_1", yylineno, 2, $3, $5);}
        |       ELSE_IF OPEN_P generalexpression CLOSE_P block elsetrain
                {$$ = newGenericNodeWithChildren(NODE_ELSETRAIN, "ELSE_IF_2", yylineno, 3, $3, $5, $6);}
        ;

while:	WHILE OPEN_P generalexpression CLOSE_P block
        {$$ = newGenericNodeWithChildren(NODE_WHILE, 0, yylineno, 2, $3, $5);}
        ;

statement:	
                generalexpression       {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       assignment              {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       vardeclaration          {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       vardeclassignment       {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       foreach                 {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       print                   {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       getfunctions            {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       exit                    {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        ;

vardeclaration:
                type VAR {
                GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
                $$ = newGenericNodeWithChildren(NODE_VARDECLARATION, 0, yylineno, 2, $1, varNode);}
        |       type  VAR OPEN_BRACK NUMBER_LITERAL CLOSE_BRACK
                {
                GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
                $$ = newGenericNodeWithChildren(NODE_VARDECLARATION, 0, yylineno, 3, $1, varNode, $4);
                }
        ;

vardeclassignment: 
        type VAR ASSIGN_EQ generaloperation {
            GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
            $$ = newGenericNodeWithChildren(NODE_VARDECLASSIGNMENT, 0, yylineno, 3, $1, varNode, $4);
        }
        | type VAR ASSIGN_EQ literal {
            GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
            $$ = newGenericNodeWithChildren(NODE_VARDECLASSIGNMENT, 0, yylineno, 3, $1, varNode, $4);
        }
        | type VAR ASSIGN_EQ generalexpression {
            GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
            $$ = newGenericNodeWithChildren(NODE_VARDECLASSIGNMENT, 0, yylineno, 3, $1, varNode, $4);
                }
        | type VAR ASSIGN_EQ arrayliteral {
            GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
            $$ = newGenericNodeWithChildren(NODE_VARDECLASSIGNMENT, 0, yylineno, 3, $1, varNode, $4);    
        }
        | type VAR ASSIGN_EQ getfunctions {
            GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
            $$ = newGenericNodeWithChildren(NODE_VARDECLASSIGNMENT, 0, yylineno, 3, $1, varNode, $4);    
        }
        ;

print:          PRINT unity     {$$ = newGenericNodeWithChildren(NODE_PRINT, 0, yylineno, 1, $2);}  
        |       PRINT literal   {$$ = newGenericNodeWithChildren(NODE_PRINT, 0, yylineno, 1, $2);}
        ;

getfunctions:     GET_INT OPEN_P CLOSE_P          {$$ = newGenericNode(NODE_GET_INT, 0, yylineno);}
                | GET_DOUBLE OPEN_P CLOSE_P       {$$ = newGenericNode(NODE_GET_DOUBLE, 0, yylineno);}
                | GET_STRING OPEN_P CLOSE_P       {$$ = newGenericNode(NODE_GET_STRING, 0, yylineno);}
                ;

foreach:
        VAR DOT FOREACH OPEN_P VAR RIGHT_ARROW foreachbody CLOSE_P 
        {
                GenericNode * varNode = newGenericNode(NODE_VARIABLE_REF, $1, yylineno);
                GenericNode * metaVarNode = newGenericNode(NODE_VARIABLE, $5, yylineno);
                $$ = newGenericNodeWithChildren(NODE_FOREACH, 0, yylineno, 3, varNode, metaVarNode, $7);}
        ; 
foreachbody:
        statement {$$ = newGenericNodeWithChildren(NODE_FOREACHBODY, 0, yylineno, 1, $1);}
        | block {$$ = newGenericNodeWithChildren(NODE_FOREACHBODY, 0, yylineno, 1, $1);}
        ;

block:	OPEN_B inblockstatements  CLOSE_B {
        GenericNode * ibssNode = newGenericNode(NODE_INBLOCKSTATEMENTS, 0, yylineno);
        ibssNode->children = $2;
        $$ = newGenericNodeWithChildren(NODE_BLOCK, 0, yylineno, 1, ibssNode);
        }
        ;

assignment:	VAR ASSIGN_EQ literal	        {       GenericNode * varNode = newGenericNode(NODE_VARIABLE_ASSIGNMENT, $1, yylineno);
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, 0, yylineno, 2, varNode, $3);}
        |	VAR ASSIGN_EQ generaloperation 	{       GenericNode * varNode = newGenericNode(NODE_VARIABLE_ASSIGNMENT, $1, yylineno);
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, 0, yylineno, 2, varNode, $3);}
        |       VAR ASSIGN_EQ generalexpression {       GenericNode * varNode = newGenericNode(NODE_VARIABLE_ASSIGNMENT, $1, yylineno);
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, 0, yylineno, 2, varNode, $3);}
        |       arraccess ASSIGN_EQ generalexpression   {
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, "ARRAY_ELEM_ASSIGNMENT", yylineno, 2, $1, $3);}
        |       arraccess ASSIGN_EQ generaloperation    {
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, "ARRAY_ELEM_ASSIGNMENT", yylineno, 2, $1, $3);}
        |       VAR ASSIGN_EQ getfunctions              {GenericNode * varNode = newGenericNode(NODE_VARIABLE_ASSIGNMENT, $1, yylineno);
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, 0, yylineno, 2, varNode, $3);}
        |       arraccess ASSIGN_EQ getfunctions        {
                                                        $$ = newGenericNodeWithChildren(NODE_ASSIGNMENT, "ARRAY_ELEM_ASSIGNMENT", yylineno, 2, $1, $3);}
        ;

arraccess:      VAR OPEN_BRACK expunity CLOSE_BRACK {   GenericNode * varNode = newGenericNode(NODE_VARIABLE_REF, $1, yylineno);
                                                        $$ = newGenericNodeWithChildren(NODE_ARRAY_ACCESS, "ARRAY_ACCESS", yylineno, 2, varNode, $3);}
                ;
literal:        STRING_LITERAL {$$ = newGenericNode(NODE_STRING_LITERAL, $1, yylineno);}
        ;

arrayliteral:
                OPEN_BRACK numlist CLOSE_BRACK {
                                        GenericNode * childNode = newGenericNode(NODE_NUMLIST,0, yylineno);
                                        childNode->children = $2;
                                        $$ = newGenericNodeWithChildren(NODE_ARRAYLITERAL, 0, yylineno, 1, childNode);}
        ;

numlist:
        numlist COMMA NUMBER_LITERAL    {GenericNode * node = newGenericNode(NODE_LITERAL, $3, yylineno);
                                        $$ = addToNodeList($1,node); }
        | NUMBER_LITERAL                {GenericNode * node = newGenericNode(NODE_LITERAL, $1, yylineno);
                                        $$ = createNodeList(node, yylineno);}
        ;
type:		INT 	{$$ = newGenericNode(NODE_INT,"int", yylineno);}
        | 	STR 	{$$ = newGenericNode(NODE_STR,"char *", yylineno);}
        | 	DOUBLE 	{$$ = newGenericNode(NODE_DOUBLE,"double", yylineno);}
        |       INT_ARR         {$$ = newGenericNode(NODE_ARR_INT,"int[]", yylineno);}
        |       DOUBLE_ARR      {$$ = newGenericNode(NODE_ARR_DOUBLE,"double[]", yylineno);}
        ;

generalexpression:      generalexpression AND expression {$$ = newGenericNodeWithChildren(NODE_G_EXPRESSION, "AND", yylineno, 2, $1, $3);}
        |               generalexpression OR expression {$$ = newGenericNodeWithChildren(NODE_G_EXPRESSION, "OR", yylineno, 2, $1, $3);}
        |               expression                      {$$ = newGenericNodeWithChildren(NODE_G_EXPRESSION, "PLAIN", yylineno, 1, $1);}
        ;


expression: expunity EQ  expunity {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "EQ", yylineno, 2, $1, $3);}
        |   expunity GT  expunity {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "GT", yylineno, 2, $1, $3);}
        |   expunity GE  expunity {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "GE", yylineno, 2, $1, $3);}
        |   expunity LT  expunity {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "LT", yylineno, 2, $1, $3);}
        |   expunity LE  expunity {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "LE", yylineno, 2, $1, $3);}
        |   expunity NE  expunity {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "NE", yylineno, 2, $1, $3);}
        |   NOT expunity          {$$ = newGenericNodeWithChildren(NODE_EXPRESSION, "NOT", yylineno, 1, $2);}
        ;

expunity:       VAR               {$$ = newGenericNode(NODE_VARIABLE_REF, $1, yylineno);}
        |       NUMBER_LITERAL    {$$ = newGenericNode(NODE_LITERAL, $1, yylineno);}
        |       arraccess         {$$ = $1;}
        ;

generaloperation:       operation                        {$$ = newGenericNodeWithChildren(NODE_G_OPERATION, "PLAIN", yylineno, 1, $1);}
        |               operation ADD   generaloperation {$$ = newGenericNodeWithChildren(NODE_G_OPERATION, "ADD", yylineno, 2, $1,$3);}
        |               operation SUBS  generaloperation {$$ = newGenericNodeWithChildren(NODE_G_OPERATION, "SUBS", yylineno, 2, $1,$3);}
        ;


operation:      unity                            {$$ = newGenericNodeWithChildren(NODE_OPERATION, "PLAIN", yylineno, 1, $1);}
        |       unity PROD operation             {$$ = newGenericNodeWithChildren(NODE_OPERATION, "PROD", yylineno, 2, $1, $3);}
        |       unity DIV  operation             {$$ = newGenericNodeWithChildren(NODE_OPERATION, "DIV", yylineno, 2, $1, $3);}
        |       unity CROSS operation            {$$ = newGenericNodeWithChildren(NODE_OPERATION, "CROSS", yylineno, 2, $1, $3);}
        |       unity SPROD operation            {$$ = newGenericNodeWithChildren(NODE_OPERATION, "SPROD", yylineno,2, $1,$3);}
        |       SUBS operation                   {$$ = newGenericNodeWithChildren(NODE_OPERATION, "SUBS", yylineno, 1, $2);       }
        ;


unity:          VAR                             {$$ = newGenericNode(NODE_VARIABLE_REF, $1, yylineno);}
        |       NUMBER_LITERAL                  {$$ = newGenericNode(NODE_LITERAL, $1, yylineno);}
        |       arraccess                       {$$ = $1;}
        ;

exit:   EXIT                                    {$$ = newGenericNode(NODE_EXIT, $1, yylineno);}
        ;
%%

void yyerror(GenericNode ** codeRootNode, char *s) {
        fprintf(stderr, "\033[0;31m");
        if (compilationError == ERROR_NO_ERROR){
        fprintf(stderr, 
                        "######################### COMPILATION ERROR #########################\n"
                        "%s near line %d\n"
                        "######################### COMPILATION ERROR #########################\n"
                        , s, yylineno);
        } else {
        fprintf(stderr, 
                        "######################### COMPILATION ERROR #########################\n"
                        "%s\n"
                        "######################### COMPILATION ERROR #########################\n"
                        , s);
        }
        fprintf(stderr, "\033[0m");
	//printf("-------------------------------------\nError: %s in line %d\n-------------------------------------\n", s, yylineno);
	freeGenericNode(*codeRootNode);
        exit(1);
}

int
main(void) {
	
        // Calling the yyparse
	yyparse(&codeRootNode);

        // Getting the code of the main program
        char * code = translate_program(codeRootNode, &yyerror);
        if (code == NULL){
                return 1;
        }

        // Getting all the headers and printing them
        char * headers = getHeaders();
        printf("%s\n", headers);

        // Getting all the operation functions and printing them
        char * operationFunctions = getOperationFunctions();
        printf("%s\n", operationFunctions);

        // Getting all the input functions and printing them
        char * inputFunctions = getInputFunctions();
        printf("%s\n", inputFunctions);

        // Getting the variable declarations and printing them
        char * declaredVariables = getVarDeclarations();
        printf("%s\n", declaredVariables);

        // Getting all the user functions and printing it
        char * userFunctions = getFunctionDeclarations();
        printf("%s\n", userFunctions);

        // Printing the code
        printf("%s\n", code);
        
        // Liberating the memory
        freeGenericNode(codeRootNode);

        fprintf(stderr, "\033[0;32m");
	fprintf(stderr, "Compilation Successful\n");
        fprintf(stderr, "\033[0m");

	return 0;
}
