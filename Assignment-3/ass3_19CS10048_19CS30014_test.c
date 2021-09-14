/************    CS39003    *************
/**********   Assignment - 3   **********
/*****  Debanjan Saha, 19CS30014  *******
/***   Pritkumar Godhani, 19CS10048  ****
/***************************************/
#include<stdio.h>

// Test code

// test : struct
struct my_Struct {
    int x1;
    char y1;
};
// test : typedef
typedef struct my_Struct structure;

int main() {
    // test : single line comment
    // test: int, const, signed, const, various identifer names
    const signed x1 = 234;
    int x2 = 40;
    long _underscore = 234;

    // test : mulitline comment
    /*  all indetifiers name variation have bee tested,
        we now test the floating point constants
        along with float and double */
    float decimal = 2.33;
    float with_positive_exponent = 4.3E2;
    float with_negative_exponent = 5.46E-3;
    double without_integer_part = .234;
    double without_fraction_part = 2456.;

    // test : char, string, enum literals
    char char_literal = '*';
    char string_literal[40] = "This is a string.";
    enum days_of_week{Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday};

    // test : for, continue, ++, %
    for(int _X = 0; _X <= 10; _X ++) {
        if(_X % 2) continue;
        else {
            x2 += 1;
        }
    }

    // test : sizeof
    x2 = sizeof(string_literal);

    // test : do, while, --, >
    do{
        x2--;
    }
    while(x2 > 0);

    // test : switch, case, default, break
    switch(x2) {
        case 0: 
            x2 = 1;
            break;
        default:
            x2 = 0;
    }
    
    // test : &&, ?:, <<
    _underscore = (x2 == 0) ? 1 : 2;
    x2 = _underscore && x1;
    x2 = x2 << 4;
    int *p1 = &x2;
    
}