/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014) 
Assignment 6 Testfile: 
----------------------
TestFile to check whether we have successfully written and integrated several parts of a compiler or not
Test 3/6: Testing Conditional If-Else and Function Calls and Return from functions
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *eP);

int findMedian(int a, int b, int c)
{
  int ans = -1;
  if (b <= a && a <= c)
  {
    ans = a;
  }
  else if (c <= a && a <= b)
  {
    ans = a;
  }
  else if (a <= b && b <= c)
  {
    ans = b;
  }
  else if (c <= b && b <= a)
  {
    ans = b;
  }
  else if (a <= c && c <= b)
  {
    ans = c;
  }
  else if (b <= c && c <= a)
  {
    ans = c;
  }
  return ans;
}

int main()
{

  printStr("+------------------+\n");
  printStr("+---- Test 3/6 ----+\n");
  printStr("+------------------+\n");
  printStr("Testing Conditional If-Else and Function Call...\n\n");

  int eP;
  int a, b, c;
  printStr("Please Enter 3 Integers\n\n");
  printStr(">> Enter 1st Number: ");
  a = readInt(&eP);
  printStr(">> Enter 2nd Number: ");
  b = readInt(&eP);
  printStr(">> Enter 3rd Number: ");
  c = readInt(&eP);

  printStr("\nMAKING A FUNCTION CALL TO CALCULATE MEDIAN...\n");
  int median = findMedian(a, b, c);
  printStr("SUCCESSFULLY RETURNED FROM THE FUNCTION...\n");

  printStr("Median Of the three numbers is: ");
  printInt(median);
  printStr("\n\n");

  printStr("[OK] TEST 3/6 PASSED\n");

  return 0;
}