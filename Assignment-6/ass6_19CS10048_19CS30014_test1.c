/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 Testfile: 
----------------------
Test to check whether we have successfully written and integrated several parts of a compiler or not
Simply printing Hello World in our TinyC
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *num_pointer);

int main()
{

    printStr("+------------------+\n");
    printStr("+---- Test 1/6 ----+\n");
    printStr("+------------------+\n");
    printStr("Testing Method PrintStr...\n");
    printStr("Hello World!\n\n");

    printStr("[OK] TEST 1/6 PASSED\n");

    return 0;
}