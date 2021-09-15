run: a.out
	./a.out

a.out:	lex.yy.c 
	gcc lex.yy.c -lfl

lex.yy.c:  ass3_19CS10048_19CS30014.l ass3_19CS10048_19CS30014.c
	flex ass3_19CS10048_19CS30014.l ass3_19CS10048_19CS30014.c

test: ass3_19CS10048_19CS30014_test.c a.out
	./a.out < ass3_19CS10048_19CS30014_test.c

clean:
	rm a.out lex.yy.c


