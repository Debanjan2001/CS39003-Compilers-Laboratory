/*
    CS39003 : Assignment-5
    Name: Pritkumar Godhani + Debanjan Saha
    Roll: 19CS10048 + 19CS30014
*/

// Test: TypeCasting and Pointers

void memoryLessSwap(int *a, int *b) //pointers
{
    *a = *a + *b;
    *b = *a - *b;
    *a = *a - *b;
}

int fltMultToInt(float a, float b)
{
    int result;
    result = a * b; // type casting float -> int
    return result;
}

int main()
{
    int num1 = 0, num2 = 55;
    float flt = 1.57;

    num1 = fltMultToInt(num2, flt);
    memoryLessSwap(&num1, &num2);
    return;
}