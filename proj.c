#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>//变长参数函数所需的头文件
#include "proj.h"

void printTree(treeNode* node, int level)
{
	
	int i;
	for(i = 0; i < level; i++)
		printf(" ");	
	
	switch(node->nodeType)
	{
		case TYPE_EXP:
			printf("%s: (%d)\n", node->exp_node->expName, node->exp_node->childNum);
			for(i = 0; i < node->exp_node->childNum; i++)
				printTree(node->exp_node->childNode[i], level+1);
			
		break;
		
		case TYPE_TYPE:
			printf("%s\n", node->name);
		break;

		case TYPE_ID:
			printf("ID(%s)\n", node->name);
		break;

		case TYPE_INT:
			printf("%d\n", node->int_val);
		break;		


		case TYPE_DOUBLE:
			printf("%d\n", node->int_val);
		break;


		case TYPE_CHAR:
			printf("%c\n", node->char_val);
		break;

		case TYPE_STRING:
			printf("%s\n", node->name);
		break;

		default:
			printf("ERROR NODE TYPE!%d", node->nodeType);
		break;


	}
}

void yyerror(char *s,...)
{
   
    fprintf(stderr, "parser error near %d, %s\n", yylineno, yytext);
}

treeNode* makeIDNode(char* name)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		return NULL;
	res->nodeType = TYPE_ID;

	strcpy(res->name, name);

	return res;
 
}

treeNode* makeIntNode(int num)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		yyerror("No enough memory!");
	res->nodeType = TYPE_INT;
	strcpy(res->name, "INTVALUE");
	res->int_val = num;
	return res;
}

treeNode* makeDoubleNode(double num)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		yyerror("No enough memory!");
	res->nodeType = TYPE_DOUBLE;
	strcpy(res->name, "DOUBLEVALUE");
	res->double_val = num;
	return res;
}

treeNode* makeCharNode(char c)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		yyerror("No enough memory!");
	res->nodeType = TYPE_CHAR;
	strcpy(res->name, "CHARVALUE");
	res->char_val = c;
	return res;
}

treeNode* makeStringNode(char* str)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		yyerror("No enough memory!");
	res->nodeType = TYPE_STRING;
	strcpy(res->name, str);
	return res;
}

treeNode* makeTypeNode(char* type_name, int typenum)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		yyerror("No enough memory!");
	res->nodeType = TYPE_TYPE;
	strcpy(res->name, type_name);
	res->type_val = typenum;
	return res;
}




treeNode* makeExpNode(char* name, int childNum, ...)
{
	treeNode* res = (treeNode*)malloc(sizeof(treeNode));
	if(!res)
		yyerror("No enough memory!");
	res->nodeType = TYPE_EXP;	

	treeEXPNode* expNode = (treeEXPNode*)malloc(sizeof(treeEXPNode) + (childNum-1)*sizeof(treeNode*));
	expNode->childNum = childNum;
	strcpy(res->name, name);	
	strcpy(expNode->expName, name);	

	//处理变长参量
	va_list	va_l;
	va_start(va_l, childNum);
	int i;	
	for(i = 0; i < childNum; i++)
	{
		expNode->childNode[i] = va_arg(va_l, treeNode*);
	}
	va_end(va_l);

	res->exp_node = expNode;

	return res;
}


//-----table操作-----

symbolItem* insertSymbol(symbolTable* table, char* name)
{
	symbolItem* res = (symbolItem*)malloc(sizeof(symbolItem));
	if(!res)
		yyerror("No enough memory!");	

	//todo!!!!
	return res;
}





