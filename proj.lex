%{
#include <stdio.h>
#include "proj.h"
#include "proj.tab.h"
%}

double_num 	[0-9]+\.[0-9]*		
int_num		[1-9][0-9]*|0		
id		[A-Za-z][0-9A-Za-z]*	
character  	'(\\.|[^\\])'
string  	\"(\\.|[^\\"])*\"


%%






[ \t\r]+	{};
[\n]		{yylineno++;};
	
"int"		{yylval.treeNodeType = makeTypeNode(yytext, SYM_INT); return INT;}
"double"	{yylval.treeNodeType = makeTypeNode(yytext, SYM_DOUBLE); return DOUBLE;}
"char"		{yylval.treeNodeType = makeTypeNode(yytext, SYM_CHAR); return CHAR;}
"void"		{yylval.treeNodeType = makeTypeNode(yytext, SYM_VOID); return VOID;}


"if"		{return IF;}
"else"		{return ELSE;}
"for"		{return FOR;}
"while"		{return WHILE;}
"break"		{return BREAK;}

"return"	{return RETURN;}

">="		{return GE;}
">"		{return GT;}
"<="		{return LE;}
"<"		{return LT;}
"=="		{return EQ;}
"!="		{return NE;}
"&&"		{return AND;}
"||"		{return OR;}

"++"		{return PP;}
"--"		{return MM;}

"="		{return '=';}

"+"		{return '+';}
"-"		{return '-';}
"*"		{return '*';}
"/"		{return '/';}
"%"		{return '%';}
"!"		{return '!';}
"&"		{return '&';}

"("		{return '(';}
")"		{return ')';}
"["		{return '[';}
"]"		{return ']';}
"{"		{return '{'; currentLevel++;}
"}"		{return '}'; currentLevel--;}


","		{return ',';}
";"		{return ';';}

{double_num}	{yylval.treeNodeType = makeDoubleNode(atof(yytext)); return NUM;}
{int_num}	{yylval.treeNodeType = makeIntNode(atoi(yytext)); return NUM;}
{id}		{yylval.treeNodeType = makeIDNode(yytext); return ID;}
{character}	{yylval.treeNodeType = makeCharNode(yytext[1]); return CHARACTER;}
{string}	{yylval.treeNodeType = makeStringNode(yytext); return STRING;}


.		yyerror("ERROR CHARACTER!");

%%
int yywrap()
{
 return 1;
}






