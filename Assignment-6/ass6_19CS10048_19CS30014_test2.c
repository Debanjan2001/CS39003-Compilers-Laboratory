/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 Testfile: 
----------------------
TestFile to check whether we have successfully written and integrated several parts of a compiler or not
Test 2/6: testing ReadInt and PrintInt library methods written in assignment-2
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *eP);

int main()
{

    printStr("+------------------+\n");
    printStr("+---- Test 2/6 ----+\n");
    printStr("+------------------+\n");
    printStr("Testing Methods - ReadInt, PrintInt...\n\n");

    int a;
    printStr(">> Enter your desired integer: ");
    int readIntegerFlag;
    a = readInt(&readIntegerFlag);

    if (readIntegerFlag == OK)
    {

        printStr("READING...\nRETURNED FLAG =>[OK]...SUCCESS!\n");
    }
    else
    {
        printStr("UNSUCCESSFUL! TRY AGAIN");
    }

    printStr("The integer obtained from you is: ");
    printInt(a);
    printStr("\n\n");

    printStr("[OK] TEST 2/6 PASSED\n");

    return 0;
}