/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 Testfile: 
----------------------
Test to check whether we have successfully written and integrated several parts of a compiler or not
Test 1/6: Simply printing Hello World in our TinyC using library methods written in assignment-2
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *eP);

int main()
{

    printStr("+------------------+\n");
    printStr("+---- Test 1/6 ----+\n");
    printStr("+------------------+\n");
    printStr("Testing Method PrintStr...\n\n");
    int num_chars = printStr("Hello World!\n");
    printStr("Number of characters printed above(Including newline and exclaimation): ");
    printInt(num_chars);
    printStr("\n\n");
    printStr("[OK] TEST 1/6 PASSED\n");

    return 0;
}