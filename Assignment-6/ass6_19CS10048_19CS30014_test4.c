/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 Testfile: 
----------------------
Test to check whether we have successfully written and integrated several parts of a compiler or not
Test 4/6: Testing Recursive Function Calls
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *eP);

int fact(int n)
{
  int ans = 1;
  if (n < 2)
  {
    ans = n;
  }
  else
  {
    ans = n * fact(n - 1);
  }
  return ans;
}

int main()
{

  printStr("+------------------+\n");
  printStr("+---- Test 4/6 ----+\n");
  printStr("+------------------+\n");
  printStr("Testing Recursive Function Calls...\n\n");

  int n;
  int eP;
  printStr("WE WILL BE CALCULATING 'N'-FACTORIAL FOR YOUR INPUT 'N'\n");
  printStr(">> Enter an integer n: ");
  n = readInt(&eP);

  int ans = fact(n);
  printStr("Factorial(");
  printInt(n);
  printStr(") = ");
  printInt(ans);
  printStr("\n\n");

  printStr("[OK] TEST 4/6 PASSED\n");

  return 0;
}