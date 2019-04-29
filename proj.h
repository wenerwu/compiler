#include  <stdlib.h>
#include  <string.h> 
#include  <ctype.h>
#include  <string.h>
#include  <stdio.h>

#define BUCKETSIZE 256
#define TABLENUM 256	

extern int yylineno;
extern char *yytext;
void yyerror(char *s,...);

typedef struct symbol_item symbolItem;
typedef struct symbol_table symbolTable;
typedef struct treenode treeNode;
typedef struct treeexpnode treeEXPNode;

symbolTable*	levelTable[TABLENUM];
treeNode*	root;

typedef enum {TYPE_EXP, TYPE_TYPE, TYPE_ID, TYPE_INT, TYPE_DOUBLE, TYPE_CHAR, TYPE_STRING} nodeEnum;
typedef enum {KIND_FUN, KIND_ARG, KIND_VAR} symbolKindEnum;
typedef enum {SYM_INT, SYM_DOUBLE, SYM_CHAR,SYM_VOID} symbolTypeEnum;	 
typedef enum {NONE, EXTERN, CONST} symbolAttributes;


int currentLevel;	
	
//表达式信息
typedef struct treeexpnode{
	char expName[256];
	int childNum;
	
	treeNode* childNode[1];		//根据孩子数扩建
	
};

	
//所有节点都有的
typedef struct treenode{
	int nodeType;				//nodeEnum
		
	char name[256];				//方便生成树的时候不需要找symbol名字,以及string内容
	char* code;				//中间代码

	union{
		
		int int_val;
		double double_val;
		char char_val;
		int type_val;			//symbolTypeEnum		

		symbolItem* symbol;


		treeEXPNode* exp_node;		//只有这个还有孩子
	};


};



//表
typedef struct symbol_table{
	int level;
	symbolItem* bucket[BUCKETSIZE];
};



//每个symbol
typedef struct symbol_item{
	char name[256];
	int kind;		//fun, arg, var	用不到
	int type;		//int, double ... fun怎么办？ 暂时用不到？
	int pointerLevel;	//*a,**a,***a
	int attribute;	//extern, const 用不到
	symbolItem* next;	//同一个hashbucket中的下一个


};


treeNode* makeIDNode(char* name);	//symbol从insertSymbol得到
treeNode* makeIntNode(int num);
treeNode* makeCharNode(char c);
treeNode* makeStringNode(char* str);
treeNode* makeDoubleNode(double num);
treeNode* makeTypeNode(char* type_name, int typenum);
treeNode* makeExpNode(char* name, int childNum, ...);

symbolItem* insertSymbol(symbolTable* table, char* name);




