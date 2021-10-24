/*
    CS39003 : Assignment-5
    Name: Pritkumar Godhani + Debanjan Saha
    Roll: 19CS10048 + 19CS30014
*/

// Test: function calling and conditional statements (ternary / if-else)
int getMaxOfThree(int a, int b, int c)
{
    // if-else test
    int ans = -1;
    if (a >= b)
    {
        if (a >= c)
        {
            ans = a;
        }
        ans = c;
    }

    if (b >= c)
    {
        if (b >= a)
        {
            ans = b;
        }
        ans = a;
    }

    if (c >= a)
    {
        if (c >= b)
        {
            ans = c;
        }
        ans = b;
    }
    return ans;
}

int isEven(int x)
{
    // Ternary expression test
    // return 1 if true else 0
    int ans = (x % 2 == 0 ? 1 : 0);
    return ans;
}

int main()
{
    int a = 5, b = 7, c = -13;
    int mx = getMaxOfThree(a, b, c);

    int num1 = 55;
    int flag1 = isEven(num1);

    int num2 = 48;
    int flag2 = isEven(num2);

    return 0;
}