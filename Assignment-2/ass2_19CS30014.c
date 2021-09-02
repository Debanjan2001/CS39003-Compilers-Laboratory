/*******************************
Name - Debanjan Saha
Roll - 19CS30014
Assignment No. - 2
Semester No.- 5
CS39003
*******************************/

#define MAX_INPUT_SIZE 50
#define MAX_OUTPUT_SIZE 300
#define SYS_READ 0
#define STDIN_FILENO 0
#include "myl.h"

int printStr(char *str){
    int length = 0;
    while(str[length]!='\0'){
        length++;
    }

    // Inline Assembly Code for printing to the OUTPUT STREAM.
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(length)
    );

    return length;
}

int readInt(int *n){
    // Array for getting integer from input stream as a string
    char buffer[MAX_INPUT_SIZE];
    int numCharsRead = 0;
    int isNegative = 0;

    // Inline Assembly Code for getting input from the INPUT STREAM.
    __asm__ __volatile__("syscall" /* Make the syscall. */
        : "=a" (numCharsRead) 
        : "0" (SYS_READ), "D" (STDIN_FILENO), "S" (buffer), "d" (sizeof(buffer))
        : "rcx", "r11", "memory", "cc"
    );
    
    
    //character at index = numCharsRead - 1 will be '\0'
    int index = numCharsRead - 2;

    // Ignore whitespaces
    while(index>=0 && buffer[index]==' '){
        index--;
    }
   
    int length = index+1;
    
    index = 0;
    // Ignore whitespaces
    while(buffer[index] == ' '){
        index++;
    }

    // Check if negative integer is provided
    if(buffer[index] == '-'){
        // Negative Check
        isNegative = 1;
        index++;
    }

    int num = 0;
    // Build the integer digit by digit
    // If digit is not valid, return error.
    while(index<length){
        if(!(buffer[index]>='0' && buffer[index]<='9'))
            return ERR;
        int digit = buffer[index]-'0';
        num = num * 10 + digit;
        index++;
    }

    // If the input was negative, make the integer negative of itself 
    if(isNegative){
        num = -num;
    }

    // Assign the integer to the actual variable.
    *n = num;
    return OK;
}

int printInt(int num){
    // Array for printing integer as a string to output stream
    char buffer[MAX_OUTPUT_SIZE];
	int index=0,length = 0;

    // Handle 0 Separately
	if(num == 0){
        buffer[index++]='0';
        length = index;
    } else {
		
        // Handle Negative Number
        if(num < 0) {
			buffer[index++] = '-';
			num = -num;
        }

        // Store the digits in the character array 'buffer'
		while(num){
			int digit = num % 10;
			buffer[index++] = (char)('0'+digit);
			num /= 10;
		}

	    length = index;
        
		if(buffer[0] == '-') 
            index = 1;
		else 
            index = 0;

        // We have to reverse the array since it was filled by digits of integer from right to left
		int arr_len = (length - index);
        for(int i=index;i<index + arr_len/2;i++){
            int idx = length - i - (index == 0);
            char temp = buffer[i];
            buffer[i] = buffer[idx];
            buffer[idx]  = temp;   
        }
	}

    buffer[length] = '\0';

    // Inline Assembly Code for printing to the OUTPUT STREAM.
	__asm__ __volatile__ (
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"  /* Make the syscall. */
		:
		:"S"(buffer), "d"(length)
	) ; // $4: write, $1: on stdin
	return length;
}

int readFlt(float *f){
    // Array for getting float from input stream as a string
    char buffer[MAX_INPUT_SIZE];
    int numCharsRead = 0;
    int isNegative = 0, isDecimalPoint = 0;

    // Inline Assembly Code for getting input from the INPUT STREAM.
    __asm__ __volatile__("syscall" /* Make the syscall. */
        : "=a" (numCharsRead) 
        : "0" (SYS_READ), "D" (STDIN_FILENO), "S" (buffer), "d" (sizeof(buffer))
        : "rcx", "r11", "memory", "cc"
    );

    //character at index = numCharsRead - 1 will be '\0'
    int index = numCharsRead - 2;
    // Ignore whitespaces
    while(index>=0 && buffer[index]==' '){
        index--;
    }
   
    int length = index+1;
    
    index = 0;
    // Ignore whitespaces
    while(buffer[index] == ' '){
        index++;
    }

    if(buffer[index] == '-'){
        // Negative Check
        isNegative = 1;
        index++;
    }

    float result = 0.0, fractional = 0.0, multiplier = 0.1;
    int integral = 0, exp = 0, isExponential = 0,expSign = 1; 
    
    // Build the floating point number character by character
    while(index<length){
        
        if(buffer[index] == '.'){
            if(isDecimalPoint){
                return ERR;
            }
            isDecimalPoint = 1;
        } else if (buffer[index]>='0' && buffer[index]<='9'){
            int digit = buffer[index] - '0';
            if(isDecimalPoint){
                fractional += multiplier * ((float)digit);
                multiplier *= 0.1; 
            } else {
                integral = integral * 10 + digit;
            }
        } else if (buffer[index] == 'E' || buffer[index] == 'e'){

            isExponential = 1;
            index ++;
            if(buffer[index] == '-'){
                expSign = -1;
                index++;
            }
            for(int i=index;i<length;i++){
                if(!(buffer[i]>='0' && buffer[i]<='9')){
                    return ERR;
                }
                int digit = (int)(buffer[i]-'0');
                exp = exp * 10 + digit;
            }

            break;

        } else {
            return ERR;
        }

        index++ ;
    }
    
    result = fractional + (float)integral;
    
    // In case of 2e-6 type of expressions, you need to multiply or divide by the exponent
    if(isExponential){
        for(int i=0;i<exp;i++){
            if(expSign == 1){
                result *= (float)10.0;
            } else {
                result /= (float)10.0;
            }
        }
    }

    // If negative, multiply by -1
    if(isNegative)
        result *= -1;

    *f = result;
    return OK;
}

int printFlt(float f){
    long long int integral = (long long int)f;
    float fractional = f - (float)integral;
    int length = 0;
    if(f<0){
        length += printStr("-");
        integral = -integral;
        fractional = -fractional;
    }

    int i = 0;
    int integer_arr[MAX_INPUT_SIZE];
    while(integral){
        integer_arr[i++] = integral%10;
        length++;
        integral /= 10;
    }

    if(i==0){
        integer_arr[i++] = 0;
        length++;
    }

    // Print the integer part of the decimal number
    for(int j=i-1;j>=0;j--){
        printInt(integer_arr[j]);
    }

    // Print the decimal point
    length += printStr(".");

    int index = 0;
    char frac_arr[6];

    // Store a precision of 6 floating point digits in a character array
    while (index < 6){
        fractional *= 10;
        int digit = ((int)fractional)%10;
        frac_arr[index++] = (char)('0'+digit); 
    }

    // print the floating digits using the printStr function implemented before
    length += printStr(frac_arr);

    return length;
}



