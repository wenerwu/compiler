res:proj.y proj.lex proj.h
	bison -d proj.y
	flex proj.lex
	gcc -o res proj.c lex.yy.c proj.tab.c

clean:
	rm proj.tab.c proj.tab.h
