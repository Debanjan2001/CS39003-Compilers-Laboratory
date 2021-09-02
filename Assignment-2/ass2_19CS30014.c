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
    char buffer[MAX_INPUT_SIZE];
    int numCharsRead = 0;
    int isNegative = 0;
    __asm__ __volatile__("syscall" /* Make the syscall. */
        : "=a" (numCharsRead) 
        : "0" (SYS_READ), "D" (STDIN_FILENO), "S" (buffer), "d" (sizeof(buffer))
        : "rcx", "r11", "memory", "cc"
    );
    
    
    //character at index = numCharsRead - 1 will be '\0'
    int index = numCharsRead - 2;
    while(index>=0 && buffer[index]==' '){
        index--;
    }
   
    int length = index+1;
    
    index = 0;
    while(buffer[index] == ' '){
        index++;
    }

    /*
        Number of characters in a signed integer cant exceed 11
        Range is => -2147483648 (11 chars) to +2147483647
    */
    if(length - index > 11)
        return ERR;

    if(buffer[index] == '-'){
        // Negative Check
        isNegative = 1;
        index++;
    }

    int num = 0;
    while(index<length){
        if(!(buffer[index]>='0' && buffer[index]<='9'))
            return ERR;
        int digit = buffer[index]-'0';
        num = num * 10 + digit;
        index++;
    }

    if(isNegative){
        num = -num;
    }

    *n = num;
    return OK;
}

int printInt(int num){
    char buffer[MAX_OUTPUT_SIZE];
	int index=0,length = 0;

	if(num == 0){
        buffer[index++]='0';
        length = index;
    } else {
		
        if(num < 0) {
			buffer[index++] = '-';
			num = -num;
        }

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

		for(int i=index;i<length/2;i++){
            char temp = buffer[i];
            buffer[i] = buffer[length - i - 1];
            buffer[length - i - 1]  = temp;   
        }
	}

	__asm__ __volatile__ (
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buffer), "d"(length)
	) ; // $4: write, $1: on stdin
	return length;
}

int readFlt(float *f){
    char buffer[MAX_INPUT_SIZE];
    int numCharsRead = 0;
    int isNegative = 0, isDecimalPoint = 0;
    __asm__ __volatile__("syscall" /* Make the syscall. */
        : "=a" (numCharsRead) 
        : "0" (SYS_READ), "D" (STDIN_FILENO), "S" (buffer), "d" (sizeof(buffer))
        : "rcx", "r11", "memory", "cc"
    );

    //character at index = numCharsRead - 1 will be '\0'
    int index = numCharsRead - 2;
    while(index>=0 && buffer[index]==' '){
        index--;
    }
   
    int length = index+1;
    
    index = 0;
    while(buffer[index] == ' '){
        index++;
    }

    if(buffer[index] == '-'){
        // Negative Check
        isNegative = 1;
        index++;
    }

    float result = 0.0, fractional = 0.0, multiplier = 0.1;
    int integral = 0;
    

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
        } else {
            return ERR;
        }

        index++ ;
    }
    
    result = fractional + (float)integral;

    if(isNegative)
        result *= -1;

    *f = result;
    return OK;
}

int printFlt(float f){
    int integral = (int)f;
    float fractional = f - (float)integral;
    int length = 0;
    if(f<0){
        length += printStr("-");
        integral = -integral;
        fractional = -fractional;
    }

    length += printInt(integral) + printStr(".");

    int index = 0;
    char frac_arr[6];
    while (index < 6){
        fractional *= 10;
        int digit = ((int)fractional)%10;
        frac_arr[index++] = (char)('0'+digit); 
    }

    length += printStr(frac_arr);

    return length;
}



