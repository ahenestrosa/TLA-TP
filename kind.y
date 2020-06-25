%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
    #include "translation/symboltable.h"
    #include "utility.h"
    #include "node.h"
    #include "translation/translation.h"

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

%token<string> IF ELSE_IF ELSE REPEAT WHILE UNTIL
%token<string> SET TO_BE AS
%token<string> DO THANK_YOU
%token<string> EXECUTE FUNCTION RECEIVING RETURNING RETURN
%token<string> FOREACH RIGHT_ARROW
%token<string> COMMA SEMICOLON DOT
%token<string> INT STR DOUBLE
%token<string> INTEGER
%token<string> EQ GT GE LT LE NE
%token<string> NUMBER_LITERAL STRING_LITERAL
%token<string> VAR
%token<string> ADD SUBS PROD DIV MODULE CROSS
%token<string> AND OR NOT
%token<string> OPEN_B CLOSE_B OPEN_P CLOSE_P OPEN_BRACK CLOSE_BRACK
%token<string> PRINT
%token<string> START END
%token<string> DEFINE PASSING
%token<string> ASSIGN_EQ
%token<string> INT_ARR DOUBLE_ARR

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
%type<node> block funblock
%type<nodelist> inblockstatements
%type<node> inblockstatement
%type<node> funcall fundeclaration function returnstatement funargs funcallargs 
%type<nodelist> arglist funarglist
%type<node> foreach foreachbody
%type<node> assignment vardeclassignment vardeclaration
%type<node> type literal
%type<node> while print
%type<node> elsetrain
%type<node> funarg
%type<node> arrayliteral
%type<nodelist> numlist
%type<node> arg

%%

entrypoint: 	
        START hyperstatements END 	{
        // create node for hyprestatements
        GenericNode * hyperstatements = newGenericNode(NODE_HYPERSTATEMENTS, 0, yylineno);
        hyperstatements->children = $2;
        *codeRootNode = newGenericNodeWithChildren(NODE_ENTRYPOINT, "helloThere\n", yylineno, 1, hyperstatements); $$ = *codeRootNode;

        }
        |       START END       		{
                *codeRootNode = newGenericNode(NODE_ENTRYPOINT, "helloThere\n", yylineno); $$ = *codeRootNode;
                }
        ;

hyperstatements: 	hyperstatement hyperstatements 	{$$ = prependToNodeList($2, $1);}
        |       	hyperstatement 			{$$ = createNodeList($1, yylineno);}
        ;

hyperstatement:	statement SEMICOLON 	{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |       block   		{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |       ifsentence        	{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |      	while   		{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
        |       function 		{$$ = newGenericNodeWithChildren(NODE_HYPERSTATEMENT, 0, yylineno, 1, $1);}
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
        |       fundeclaration          {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       funcall                 {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       foreach                 {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
        |       print                   {$$ = newGenericNodeWithChildren(NODE_STATEMENT, 0, yylineno, 1, $1);}
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
        ;

print:          PRINT unity     {$$ = newGenericNodeWithChildren(NODE_PRINT, 0, yylineno, 1, $2);}  
        |       PRINT literal   {$$ = newGenericNodeWithChildren(NODE_PRINT, 0, yylineno, 1, $2);}
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

fundeclaration: FUNCTION VAR funargs RETURNING type 
              {GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
               $$ = newGenericNodeWithChildren(NODE_FUNDEC, 0, yylineno, 3, varNode, $3, $5);}
        ;

function:	FUNCTION VAR funargs funblock 
        {GenericNode * varNode = newGenericNode(NODE_VARIABLE, $2, yylineno);
        $$ = newGenericNodeWithChildren(NODE_FUNCTION, 0, yylineno, 3, varNode, $3, $4);}
        ;

funblock:	
                OPEN_B inblockstatements returnstatement CLOSE_B 
                {
                 GenericNode * ibssNode = newGenericNodeWithChildren(NODE_INBLOCKSTATEMENTS, 0, yylineno, 1, $2);
                 $$ = newGenericNodeWithChildren(NODE_FUNBLOCK_RET, 0, yylineno, 2, ibssNode, $3);
                }
        |       OPEN_B inblockstatements CLOSE_B 
                {
                 GenericNode * ibssNode = newGenericNodeWithChildren(NODE_INBLOCKSTATEMENTS, 0, yylineno, 1, $2);
                 $$ = newGenericNodeWithChildren(NODE_FUNBLOCK, 0, yylineno, 1, ibssNode);
                }
        ;

returnstatement:        RETURN generaloperation SEMICOLON {
                        $$ = newGenericNodeWithChildren(NODE_RETURN_STATEMENT, 0, yylineno, 1, $2);}
        |               RETURN generalexpression SEMICOLON {
                        $$ = newGenericNodeWithChildren(NODE_RETURN_STATEMENT, 0, yylineno, 1, $2);}
        ;

funargs:	OPEN_P  CLOSE_P 	{$$ = newGenericNodeWithChildren(NODE_FUNARGS, 0, yylineno, 1, 0);}
        | 	OPEN_P arglist CLOSE_P	{
                                        GenericNode * childNode = newGenericNode(NODE_ARGLIST,0, yylineno);
                                        childNode->children = $2;
                                        $$ = newGenericNodeWithChildren(NODE_FUNARGS, 0, yylineno, 1, childNode);
                                        }
        ;

arglist:	arglist COMMA arg 	{$$ = addToNodeList($1,$3); }
        | 	arg 			{$$ = createNodeList($1, yylineno);}
        ;

arg:	type VAR {GenericNode * node = newGenericNode(NODE_VARIABLE, $2, yylineno);
                  $$ = newGenericNodeWithChildren(NODE_ARG, 0, yylineno, 2, $1, node);}
        ;

funcall:
        VAR funcallargs 
        {GenericNode * varNode = newGenericNode(NODE_VARIABLE, $1, yylineno);
        $$ = newGenericNodeWithChildren(NODE_FUNCALL, 0, yylineno, 2, varNode, $2);
        }
        ;

funcallargs:
                OPEN_P CLOSE_P
                {$$ = newGenericNodeWithChildren(NODE_FUNCALLARGS, 0, yylineno, 1, 0);
                }
        |       OPEN_P funarglist CLOSE_P
                {GenericNode * childNode = newGenericNode(NODE_FUNARGLIST,0, yylineno);
                childNode->children = $2;
                $$ = newGenericNodeWithChildren(NODE_FUNCALLARGS, 0, yylineno, 1, childNode);
        }             
        ;

funarglist:
        funarglist COMMA funarg {$$ = addToNodeList($1,$3);}
        | funarg                {$$ = createNodeList($1, yylineno);}
        ;

funarg:
        VAR              {$$ = newGenericNode(NODE_VARIABLE,$1, yylineno);}
        | STRING_LITERAL {$$ = newGenericNode(NODE_STRING_LITERAL,$1, yylineno);}
        | NUMBER_LITERAL {$$ = newGenericNode(NODE_LITERAL,$1, yylineno);}
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
        ;

generaloperation:       operation                        {$$ = newGenericNodeWithChildren(NODE_G_OPERATION, "PLAIN", yylineno, 1, $1);}
        |               operation ADD   generaloperation {$$ = newGenericNodeWithChildren(NODE_G_OPERATION, "ADD", yylineno, 2, $1,$3);}
        |               operation SUBS  generaloperation {$$ = newGenericNodeWithChildren(NODE_G_OPERATION, "SUBS", yylineno, 2, $1,$3);}
        ;


operation:      unity                            {$$ = newGenericNodeWithChildren(NODE_OPERATION, "PLAIN", yylineno, 1, $1);}
        |       unity PROD operation             {$$ = newGenericNodeWithChildren(NODE_OPERATION, "PROD", yylineno, 2, $1, $3);}
        |       unity DIV  operation             {$$ = newGenericNodeWithChildren(NODE_OPERATION, "DIV", yylineno, 2, $1, $3);}
        |       unity CROSS operation            {$$ = newGenericNodeWithChildren(NODE_OPERATION, "CROSS", yylineno, 2, $1, $3);}
        |       SUBS operation                   {$$ = newGenericNodeWithChildren(NODE_OPERATION, "SUBS", yylineno, 1, $2);       }
        ;


unity:          VAR                             {$$ = newGenericNode(NODE_VARIABLE_REF, $1, yylineno);}
        |       NUMBER_LITERAL                  {$$ = newGenericNode(NODE_LITERAL, $1, yylineno);}
        ;

%%

void yyerror(GenericNode ** codeRootNode, char *s) {
        fprintf(stderr, "\033[0;31m");
	fprintf(stderr, 
                "######################### COMPILATION ERROR #########################\n"
                "%s\n"
                "######################### COMPILATION ERROR #########################\n"
                , s);
        fprintf(stderr, "\033[0m");
	//printf("-------------------------------------\nError: %s in line %d\n-------------------------------------\n", s, yylineno);
	freeGenericNode(*codeRootNode);
        exit(0);
}

int
main(void) {

        #ifdef YYDEBUG
        // yydebug = 1;
        #endif

        /*
	variables = malloc(MAX_VARIABLES * sizeof(VariableToken *));

	if (variables == NULL) {
		printf("Unable to allocate space for the variables\n");
		exit(EXIT_FAILURE);
	}
	memset(variables, '\0', sizeof(VariableToken *) * MAX_VARIABLES);
        */
	
	yyparse(&codeRootNode);

        // printGenericNode(codeRootNode, 0);
        char * code = translate_program(codeRootNode, &yyerror);
        if (code == NULL){
                //freeGenericNode(codeRootNode);
                return 1;
        }

        // Getting all the builtin functions and printing it
        char * headersAndFunctions = getHeadersAndFunctions();
        printf("%s\n", headersAndFunctions);

        // Getting all the user functions and printing it
        char * userFunctions = getFunctionDeclarations();
        printf("%s\n", userFunctions);

        // Printing the code
        printf("%s\n", code);
        
        //freeGenericNode(codeRootNode);
/*

	char * translation = translateToC((Token *)code);
	//We should always call get functions after translateToC
	char * functionsTranslation = getFunctions();
        */

/*
	if (translation == NULL) printf("Error allocating memory for generated C code.\n");
	else {
		printf("#include <stdio.h>\n");
		printf("#include <stdlib.h>\n\n");
		if(functionsTranslation != NULL) {
			printf("%s\n", functionsTranslation);
		}
		printf("int main(int argc, char const *argv[]) {\n");
		printf("%s\n", translation);
		printf("\nreturn 0;\n}");
	}

	if(translation != NULL) {
		free(translation);
	}
	if(functionsTranslation != NULL) {
		free(functionsTranslation);
	}
	freeFunctions();
	freeToken((Token *) code);
	freeVariables();
        */

        fprintf(stderr, "\033[0;32m");
	fprintf(stderr, "Compilation Successful\n");
        fprintf(stderr, "\033[0m");

	return 0;
}
