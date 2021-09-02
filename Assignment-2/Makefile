run : a.out
	./a.out

a.out: main.o libass2_19CS30014.a
	gcc -Wall main.o -L. -lass2_19CS30014

main.o: main.c myl.h
	gcc -Wall -c main.c

libass2_19CS30014.a: ass2_19CS30014.o
	ar -rcs libass2_19CS30014.a ass2_19CS30014.o

ass2_19CS30014.o: ass2_19CS30014.c myl.h
	gcc -Wall -c ass2_19CS30014.c

clean: 
	rm a.out main.o  ass2_19CS30014.o libass2_19CS30014.a
	
