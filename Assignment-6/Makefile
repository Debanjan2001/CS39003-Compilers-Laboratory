tinyC: lex.yy.o ass6_19CS10048_19CS30014.tab.o ass6_19CS10048_19CS30014_translator.o

libass2_19CS30014.a:
	gcc -c ass2_19CS30014.c
	ar -rcs libass2_19CS30014.a ass2_19CS30014.o

ass6_19CS10048_19CS30014_translator.o: ass6_19CS10048_19CS30014_translator.h ass6_19CS10048_19CS30014_translator.cxx 
	g++ -c ass6_19CS10048_19CS30014_translator.h 
	g++ -c ass6_19CS10048_19CS30014_translator.cxx

ass6_19CS10048_19CS30014_target_translator.o: ass6_19CS10048_19CS30014_target_translator.cxx
	g++ -c ass6_19CS10048_19CS30014_target_translator.cxx


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
	rm -f ass6_19CS10048_19CS30014_translator.h.gch\
	ass6_19CS10048_19CS30014_translator.o
	@echo ""
	@echo "+------+"
	@echo "Done..."
	@echo "+------+"