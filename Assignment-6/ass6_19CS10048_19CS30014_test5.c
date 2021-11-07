/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014)
Assignment 6 Testfile:
----------------------
Test to check whether we have successfully written and integrated several parts of a compiler or not
Test 5/6: Testing Arrays, Loops and Integer Arithmetic
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *eP);

int main()
{

  printStr("+------------------+\n");
  printStr("+---- Test 5/6 ----+\n");
  printStr("+------------------+\n");
  printStr("Testing Arrays, Loops and Integer Arithmetic...\n\n");

  printStr("WE HAVE AN ARRAY OF DIMENSION 10.\nWE WILL STORE THE CUBES OF FIRST 10 NATURAL NUMBERS AND PRINT THEM FROM ARRAY...\n");
  int arr[10];
  int i;
  for (i = 1; i <= 10; i++)
  {
    int cube = i * i * i;
    arr[i - 1] = cube;
    printStr("Cube of ");
    printInt(i);
    printStr(" = ");
    printInt(arr[i - 1]);
    printStr("\n");
  }
  printStr("\n");

  printStr("[OK] TEST 5/6 PASSED\n");

  return 0;
}