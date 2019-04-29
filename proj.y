%{
#include <stdio.h>
#include <math.h>
#include "proj.h"
%}

%union{ 
	treeNode* treeNodeType;
	char * op;
};

%token <treeNodeType> ID NUM CHARACTER STRING

%token <treeNodeType> IF ELSE FOR WHILE BREAK RETURN
%token <treeNodeType> INT DOUBLE CHAR VOID


%type <treeNodeType> program
%type <treeNodeType> statement_list statement
%type <treeNodeType> function_def variable_def
%type <treeNodeType> symbol_declare_list symbol_declare_pair symbol_declare_name
%type <treeNodeType> specifier param_list param compound_list compound
%type <treeNodeType> expression 
%type <treeNodeType> variable variable_simple
%type <treeNodeType> if_statement while_statement for_statement 



%left	OR
%left	AND
%left	EQ NE
%left	GT GE LT LE
%left	'+' '-'
%left	'*' '/'
%right	PP MM
%left	'(' ')' '[' ']'


%%

program: 
	statement_list
	{
		$$ = makeExpNode("PROGRAM", 1, $1);
		root = $$;
	}
	;

statement_list:
	statement
	{
		$$ = makeExpNode("STATEMENTLIST", 1, $1);
	}
	| statement_list statement
	{
		$$ = makeExpNode("STATEMENTLIST", 2, $1, $2);
	}
	;

statement:
	compound
	{
		$$ = makeExpNode("STATEMENT", 1, $1);
	}
	|function_def
	{
		$$ = makeExpNode("STATEMENT", 1, $1);
	}
	;
	

variable_def:
	specifier symbol_declare_list
	{
		$$ = makeExpNode("VARIABLEDEF", 2, $1, $2);
	}
	;
	
symbol_declare_list:
	symbol_declare_pair
	{
		$$ = makeExpNode("SYMBOLDECLARELIST", 1, $1);
	}
	| symbol_declare_list ',' symbol_declare_pair
	{
		$$ = makeExpNode("SYMBOLDECLARELIST", 2, $1, $3);
	}
	;

symbol_declare_pair:
	symbol_declare_name
	{
		$$ = makeExpNode("SYMBOLDECLAREPAIR", 1, $1);
	}
	| symbol_declare_name '=' variable
	{
		$$ = makeExpNode("SYMBOLDECLAREPAIR", 2, $1, $3);
	}
	;

symbol_declare_name:
	ID
	{
		$$ = makeExpNode("SYMBOLDECLARENAME", 1, $1);
	}
	| '*' symbol_declare_name
	{
		$$ = makeExpNode("SYMBOLDECLARENAME", 1, $2);
	}
	| symbol_declare_name '[' NUM ']'
	{
		$$ = makeExpNode("SYMBOLDECLARENAME", 1, $1);
	}
	;

function_def:
	specifier symbol_declare_name '(' param_list ')' '{' compound_list '}'
	{
		$$ = makeExpNode("FUNCTION", 4, $1, $2, $4, $7);
	}
	;

specifier:
	INT
	{
		$$ = $1;
	}
	|DOUBLE
	{
		$$ = $1;
	}
	|CHAR
	{
		$$ = $1;
	}
	|VOID
	{
		$$ = $1;
	}
	;

param_list:
	param
	{
		$$ = makeExpNode("PARAMETERLIST", 1, $1);
	}
	|param_list ',' param
	{
		$$ = makeExpNode("PARAMETERLIST", 2, $1, $3);
	}
	|
	{
		$$ = makeExpNode("PARAMETERLIST", 0);
	}
	;

param:
	specifier symbol_declare_name
	{
		$$ = makeExpNode("PARAMETER", 2, $1, $2);
	}
	;

compound_list:
	compound
	{
		$$ = $1;
	}
	|compound_list compound
	{
		$$ = makeExpNode("COMPOUNDLIST", 2, $1, $2);
	}
	|
	{
		$$ = makeExpNode("COMPOUNDLIST", 0);
	}
	;

compound:
	variable_def ';'
	{
		$$ = makeExpNode("COMPOUND", 1, $1);
	}
	| expression ';'	
	{
		$$ = makeExpNode("COMPOUND", 1, $1);
	}
	| if_statement		
	{
		$$ = makeExpNode("COMPOUND", 1, $1);
	}
	| while_statement	
	{
		$$ = makeExpNode("COMPOUND", 1, $1);
	}
	| for_statement		
	{
		$$ = makeExpNode("COMPOUND", 1, $1);
	}
	| ';'
	{
		$$ = makeExpNode("COMPOUND", 0);
	}
	;


expression:
	variable
	{
		$$ = $1;
	}	
	| PP expression
	{
		$$ = makeExpNode("PLUSPLUS", 1, $2);
	}	
	| expression PP
	{
		$$ = makeExpNode("PLUSPLUS", 1, $1);
	}
	| MM expression
	{
		$$ = makeExpNode("MINUSMINUS", 1, $2);
	}
	| expression MM
	{
		$$ = makeExpNode("MINUSMINUS", 1, $1);
	}	
	| '(' expression ')'
	{
		$$ = $2;
	}
	| expression '+' expression
	{
		$$ = makeExpNode("PLUS", 2, $1, $3);
	}
	| expression '-' expression
	{
		$$ = makeExpNode("MINUS", 2, $1, $3);
	}
	| expression '*' expression
	{
		$$ = makeExpNode("MULTIPLY", 2, $1, $3);
	}
	| expression '/' expression
	{
		$$ = makeExpNode("DIVIDE", 2, $1, $3);
	}
	| expression '%' expression
	{
		$$ = makeExpNode("MOD", 2, $1, $3);
	}
	| expression '=' expression
	{
		$$ = makeExpNode("ASSIGN", 2, $1, $3);
	}
	| expression EQ expression
	{
		$$ = makeExpNode("EQUAL", 2, $1, $3);
	}
	| expression NE expression
	{
		$$ = makeExpNode("NOTEQUAL", 2, $1, $3);
	}
	| expression GT expression
	{
		$$ = makeExpNode("GREATERTHAN", 2, $1, $3);
	}
	| expression GE expression
	{
		$$ = makeExpNode("GREATEREQUAL", 2, $1, $3);
	}
	| expression LT expression
	{
		$$ = makeExpNode("LESSTHAN", 2, $1, $3);
	}
	| expression LE expression
	{
		$$ = makeExpNode("LESSEQUAL", 2, $1, $3);
	}
	| expression AND expression
	{
		$$ = makeExpNode("AND", 2, $1, $3);
	}
	| expression OR expression
	{
		$$ = makeExpNode("OR", 2, $1, $3);
	}
	;


variable:
	variable_simple
	{
		$$ = makeExpNode("VARIABLE", 1, $1);
	}
	| '-' variable_simple
	{
		$$ = makeExpNode("MINUS_VARIABLE", 1, $2);
	}
	| '*' variable_simple
	{
		$$ = makeExpNode("USEADDRESS_VARIABLE", 1, $2);
	}
	| '&' variable_simple
	{
		$$ = makeExpNode("GETADDRESS_VARIABLE", 1, $2);
	}
	| '!'variable_simple
	{
		$$ = makeExpNode("NOT_VARIABLE", 1, $2);
	}
	;

variable_simple:
	ID	{$$ = $1;}
	| NUM	{$$ = $1;}
	| CHARACTER	{$$ = $1;}
	| STRING	{$$ = $1;}
	| ID '[' NUM ']' {$$ = $1;}	
	;

if_statement:
	IF '(' expression ')' '{' compound_list '}' ELSE '{' compound_list '}'
	{
		$$ = makeExpNode("IF", 3, $3, $6, $10);
	}
	| IF '(' expression ')' '{' compound_list '}'
	{
		$$ = makeExpNode("IF", 2, $3, $6);
	}
	;
	
while_statement:
	WHILE '(' expression ')' '{' compound_list '}'
	{
		$$ = makeExpNode("WHILE", 2, $3, $6);
	}
	;

for_statement:
	FOR '(' expression ';' expression ';' expression ';' ')'  '{' compound_list '}'
	{
		$$ = makeExpNode("FOR", 4, $3, $5, $7, $11);
	}
	;




 	
%%






int main(void)
{
    
	yyparse();
	printTree(root, 0);
	printf("parse succeeded.\n");
	return 0;
}

