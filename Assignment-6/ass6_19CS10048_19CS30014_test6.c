/*----------------------------
CS39003 Compilers Laboratory
Autumn 2021-2022
Authors  : Pritkumar Godhani (19CS10048)
           Debanjan Saha     (19CS30014)
Assignment 6 Testfile:
----------------------
Test to check whether we have successfully written and integrated several parts of a compiler or not
Test 6/6: Testing Algorithmic Problem Solving
------------------------------------------*/

int printInt(int num);
int printStr(char *str);
int readInt(int *eP);

int main()
{

  printStr("+------------------+\n");
  printStr("+---- Test 6/6 ----+\n");
  printStr("+------------------+\n");
  printStr("An Interactive Algorithmic Game using Binary Search...\n\n");

  printStr("Note any favourite number from [1-999] and We will guess it using binary search...\n");
  printStr("Enter any number to start the game : ");
  int dummynum;
  int eP;
  dummynum = readInt(&eP);

  int lo = 0;
  int hi = 1000;
  while (lo < hi)
  {
    int mid = lo + (hi - lo) / 2;
    printStr("\nIs Your Number ");
    printInt(mid);
    printStr("?\nIf this was your number Press 1\nIf your number is less than this guess Press 0\nIf your number is greater than this guess Press 2\n");
    printStr(">> YOUR CHOICE: ");
    int ans;
    ans = readInt(&eP);

    if (ans == 1)
    {
      printStr("YAY! WE GUESSED IT RIGHT\n\n");
      lo = 1000;
      return 0;
    }
    else if (ans == 0)
    {
      hi = mid;
    }
    else
    {
      lo = mid + 1;
    }
  }

  printStr("[OK] TEST 6/6 PASSED\n");

  return 0;
}