test: a.out
	./a.out < asgn5_19CS10048_19CS30014_test1.c > asgn5_19CS10048_19CS30014_quads1.out
	@echo "\nTest File 1 Successfully Translated !\n\n"
	./a.out < asgn5_19CS10048_19CS30014_test2.c > asgn5_19CS10048_19CS30014_quads2.out
	@echo "\nTest File 2 Successfully Translated !\n\n"
	./a.out < asgn5_19CS10048_19CS30014_test3.c > asgn5_19CS10048_19CS30014_quads3.out
	@echo "\nTest File 3 Successfully Translated !\n\n"
	./a.out < asgn5_19CS10048_19CS30014_test4.c > asgn5_19CS10048_19CS30014_quads4.out
	@echo "\nTest File 4 Successfully Translated !\n\n"
	./a.out < asgn5_19CS10048_19CS30014_test5.c > asgn5_19CS10048_19CS30014_quads5.out
	@echo "\nTest File 5 Successfully Translated !\n\n"
	

a.out: lex.yy.o y.tab.o asgn5_19CS10048_19CS30014_translator.o
	g++ lex.yy.o y.tab.o asgn5_19CS10048_19CS30014_translator.o -lfl

asgn5_19CS10048_19CS30014_translator.o: asgn5_19CS10048_19CS30014_translator.cxx asgn5_19CS10048_19CS30014_translator.h
	g++ -c asgn5_19CS10048_19CS30014_translator.h
	g++ -c asgn5_19CS10048_19CS30014_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: asgn5_19CS10048_19CS30014.l y.tab.h asgn5_19CS10048_19CS30014_translator.h
	flex asgn5_19CS10048_19CS30014.l

y.tab.c: asgn5_19CS10048_19CS30014.y
	bison -dty asgn5_19CS10048_19CS30014.y -W --report=all

y.tab.h: asgn5_19CS10048_19CS30014.y
	bison -dty asgn5_19CS10048_19CS30014.y -W --report=all

clean: 
	rm lex.yy.c\
	   lex.yy.o\
	   a.out\
	   y.tab.c\
	   y.tab.h\
	   y.tab.o\
	   y.output\
	   asgn5_19CS10048_19CS30014_translator.o\
	   asgn5_19CS10048_19CS30014_translator.h.gch\
	   asgn5_19CS10048_19CS30014_quads1.out\
	   asgn5_19CS10048_19CS30014_quads2.out\
	   asgn5_19CS10048_19CS30014_quads3.out\
	   asgn5_19CS10048_19CS30014_quads4.out\
	   asgn5_19CS10048_19CS30014_quads5.out