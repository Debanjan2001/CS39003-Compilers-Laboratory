assembly: tinyC libass2_19CS10048.a
	
	@echo "\n------------------- Generating Quads for the test files ---------------\n"

	./tinyC 1 > ass6_19CS10048_19CS30014_quads1.out
	./tinyC 2 > ass6_19CS10048_19CS30014_quads2.out
	./tinyC 3 > ass6_19CS10048_19CS30014_quads3.out
	./tinyC 4 > ass6_19CS10048_19CS30014_quads4.out
	./tinyC 5 > ass6_19CS10048_19CS30014_quads5.out
	./tinyC 6 > ass6_19CS10048_19CS30014_quads6.out
	./tinyC 7 > ass6_19CS10048_19CS30014_quads7.out

	@echo "\n-------------    Generating the object files from assembly code   ---------------\n"

	gcc -c ass6_19CS10048_19CS30014_1.s
	gcc -c ass6_19CS10048_19CS30014_2.s
	gcc -c ass6_19CS10048_19CS30014_3.s
	gcc -c ass6_19CS10048_19CS30014_4.s
	gcc -c ass6_19CS10048_19CS30014_5.s
	gcc -c ass6_19CS10048_19CS30014_6.s
	gcc -c ass6_19CS10048_19CS30014_7.s

	@echo "\n-------------    Compiling the test files   ---------------\n"

	gcc ass6_19CS10048_19CS30014_1.o -o test1 -L. -lass2_19CS10048 -no-pie
	gcc ass6_19CS10048_19CS30014_2.o -o test2 -L. -lass2_19CS10048 -no-pie
	gcc ass6_19CS10048_19CS30014_3.o -o test3 -L. -lass2_19CS10048 -no-pie
	gcc ass6_19CS10048_19CS30014_4.o -o test4 -L. -lass2_19CS10048 -no-pie
	gcc ass6_19CS10048_19CS30014_5.o -o test5 -L. -lass2_19CS10048 -no-pie
	gcc ass6_19CS10048_19CS30014_6.o -o test6 -L. -lass2_19CS10048 -no-pie
	gcc ass6_19CS10048_19CS30014_7.o -o test7 -L. -lass2_19CS10048 -no-pie

libass2_19CS10048.a:
	gcc -c ass2_19CS10048.c
	ar -rcs libass2_19CS10048.a ass2_19CS10048.o

tinyC: lex.yy.o ass6_19CS10048_19CS30014.tab.o ass6_19CS10048_19CS30014_translator.o ass6_19CS10048_19CS30014_target_translator.o
	g++ lex.yy.o ass6_19CS10048_19CS30014.tab.o ass6_19CS10048_19CS30014_translator.o \
	ass6_19CS10048_19CS30014_target_translator.o -lfl -o tinyC

ass6_19CS10048_19CS30014_target_translator.o: ass6_19CS10048_19CS30014_target_translator.cxx
	g++ -c ass6_19CS10048_19CS30014_target_translator.cxx

ass6_19CS10048_19CS30014_translator.o: ass6_19CS10048_19CS30014_translator.cxx ass6_19CS10048_19CS30014_translator.h
	g++ -c ass6_19CS10048_19CS30014_translator.h
	g++ -c ass6_19CS10048_19CS30014_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass6_19CS10048_19CS30014.tab.o: ass6_19CS10048_19CS30014.tab.c
	g++ -c ass6_19CS10048_19CS30014.tab.c

lex.yy.c: ass6_19CS10048_19CS30014.l ass6_19CS10048_19CS30014.tab.h ass6_19CS10048_19CS30014_translator.h
	flex ass6_19CS10048_19CS30014.l

ass6_19CS10048_19CS30014.tab.c: ass6_19CS10048_19CS30014.y
	bison -dtv ass6_19CS10048_19CS30014.y -W

ass6_19CS10048_19CS30014.tab.h: ass6_19CS10048_19CS30014.y
	bison -dtv ass6_19CS10048_19CS30014.y -W


clean:
	@echo "+------------------+"
	@echo "Cleaning Project..."
	@echo "+------------------+"
	@echo ""
	rm -f lex.yy.c\
	   ass6_19CS10048_19CS30014.tab.c\
	   ass6_19CS10048_19CS30014.tab.h\
	   lex.yy.o\
	   ass6_19CS10048_19CS30014.tab.o\
	   ass6_19CS10048_19CS30014.output\
	   ass6_19CS10048_19CS30014_translator.o\
	   test1\
	   test2\
	   test3\
	   test4\
	   test5\
	   test6\
	   test7\
	   tinyC\
	   ass6_19CS10048_19CS30014_target_translator.o\
	   ass6_19CS10048_19CS30014_translator.h.gch\
	   ass6_19CS10048_19CS30014_quads1.out\
	   ass6_19CS10048_19CS30014_quads2.out\
	   ass6_19CS10048_19CS30014_quads3.out\
	   ass6_19CS10048_19CS30014_quads4.out\
	   ass6_19CS10048_19CS30014_quads5.out\
	   ass6_19CS10048_19CS30014_quads6.out\
	   ass6_19CS10048_19CS30014_quads7.out\
	   libass2_19CS10048.a\
	   ass2_19CS10048.o\
	   ass6_19CS10048_19CS30014_1.o\
	   ass6_19CS10048_19CS30014_2.o\
	   ass6_19CS10048_19CS30014_3.o\
	   ass6_19CS10048_19CS30014_4.o\
	   ass6_19CS10048_19CS30014_5.o\
	   ass6_19CS10048_19CS30014_6.o\
	   ass6_19CS10048_19CS30014_7.o\
	   ass6_19CS10048_19CS30014_1.s\
	   ass6_19CS10048_19CS30014_2.s\
	   ass6_19CS10048_19CS30014_3.s\
	   ass6_19CS10048_19CS30014_4.s\
	   ass6_19CS10048_19CS30014_5.s\
	   ass6_19CS10048_19CS30014_6.s\
	   ass6_19CS10048_19CS30014_7.s\
	   
	@echo ""
	@echo "+------+"
	@echo "Done..."
	@echo "+------+"