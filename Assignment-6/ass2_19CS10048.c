/***
 * CS39003 | COMPILERS LABORATORY  
 *
 * Assignment 2 : Creating Custom I/O Library 
 * File : ass2_19CS10048.c [C custom library source file]
 * Author   : Pritkumar Godhani
 * Roll No. : 19CS10048
 ***/

#include "myl.h"

#define BUFF_SIZE 100
#define INT_MIN -2147483648
#define INT_MAX 2147483647

int printStr(char * str) {
	// *** Input string is assumed to be null-character terminated.
	int len_str = 0; // length of the string to be printed
	
	// computing length of str
	while(str[len_str] != '\0') {
		len_str++;
	}

	// syscall to write to stdout 
	__asm__ __volatile__ (
		"movl $1, %%eax \n\t" // operation is write (code = 1)
		"movq $1, %%rdi \n\t" // destination file is STDOUT (code = 1)
		"syscall \n\t"
		:
		:"S"(str), "d"(len_str) // character buffer is str of length len_str
	);

	// return number of characters printed
	return len_str;
}

int printInt(int num) {
	char buffer[BUFF_SIZE], zero = '0';
	int i = 0, j = 0, num_len, k;

	// if num is 0 put zero in buffer
	if(num == 0) {
		buffer[i++] = zero;
		num_len = i;

		return num_len;
	}
	else {
		// if num is negative put the first character as negative sign - and convert num to positive
		if(num < 0) {
			buffer[i++] = '-';
			// range of int : -2^31 to 2^31 - 1
			/* therefore, if num is the lower limit of 32 bit integer, 
			   then its value is one larger than the positive limit 
			   so simple negation will result in overflow */
			if(num == INT_MIN) {
				buffer[i++] = zero + 8;
				num = INT_MAX/10;
			}
			// if num is not -2^31 then negation will work just fine
			else {
				num = -num;
			}
			
		}

		// put the digits starting from least significant digit into the char buffer
		while(num) {
			buffer[i++] = (char)(num%10 + zero);
			num = num/10;
		}

		num_len = i;

		// reverse the digits in the char buffer to human-readable form, starting from most significant digit to least one
		// if number is negative, digits start from index 1, else 0
		if(buffer[0] == '-') j = 1;
		k = num_len - 1;
		// reverse by swapping first char with last, second with second last, and so on
		while(j < k) {
			char temp;
			temp = buffer[j];
			buffer[j] = buffer[k];
			buffer[k] = temp;
			j++;
			k--;
		} 

		// syscall to write to stdout
		__asm__ __volatile__ (
			"movl $1, %%eax \n\t" // operation is write (code = 1)
			"movq $1, %%rdi \n\t" // destination file is STDOUT (code = 1)
			"syscall \n\t"
			:
			:"S"(buffer), "d"(num_len) // character buffer is buffer of length num_len
		);

		return num_len;
	}
	return ERR;
}

int readInt(int * num) {
	char buffer[BUFF_SIZE], zero = '0', nine = '9';
	int num_char_read, i, n = 0, sign = 0;

	// syscall to read from stdin
	__asm__ __volatile__ (
		"movl $0, %%eax \n\t" // operation is read(code = 0)
		"movq $0, %%rdi \n\t" // file to be read is STDIN(code = 0)
		"syscall \n\t"	
		:"=a"(num_char_read) // returns number of characters read in num_char_read
		:"S"(buffer), "d"(sizeof(buffer)) // read a character string in buffer of total size BUFF_SIZE
	);

	// if no characters read, return ERR code
	if(num_char_read < 0) return ERR;

	// newline read at the end is changed to null character and effective length is reduced by 1
	buffer[--num_char_read] = 0x0;

	// ignore trailing whitespaces
	i = num_char_read-1;
	while(i >= 0 && buffer[i--] == ' ');
	num_char_read = i+2; // change num_char_Read to ignore trailing spaces

	// append with a null character at the end
	buffer[num_char_read] = 0x0;

	// ignore whitespaces at the front 
	i = -1;
	while(buffer[++i] == ' ');
	// i points to the index with a non-blankspace character

	// check if string is not exhausted
	if(i < num_char_read) {
		// check if the input num is negative, if yes sign = 1
		if(buffer[i] == '-') {
			i++;
			sign = 1;
			// if string exhausts after reading sign return ERR code
			if(i >= num_char_read) return ERR;
		}

		// iterate through out the read string, if any non-digit is found return ERR code else continue to update the number
		for(; i < num_char_read; i++) {
			if(buffer[i] >= zero && buffer[i] <= nine) {
				n = n*10 + (int)(buffer[i] - zero);
			}
			else return ERR;
		}	

		// if '-' sign was present convert to negative number
		if(sign) n = -n;

		// set the new read value n to the location num
		*num = n;

		// value read successfully
		return OK;
	}
	else {
		// if empty string passed return ERR code
		return ERR;
	}
}

int printFlt(float num) {
	int sign = 0, i = 0, len;
	char zero = '0', before_decimal[BUFF_SIZE], after_decimal[7], buffer[BUFF_SIZE];
	
	// append after_decimal with null character
	after_decimal[6] = 0x0;

	// if num is negative sign = 1
	if(num < 0) {
		sign = 1;
		num = -num;
	}

	// extract integer part and decimal part round upto six places after decimal point
	long long integer_part = (long long) num;
	long long fraction_part = (long long) ((num - integer_part) * 1000000 + 0.5);

	// extract the decimal part upto 6 places after decimal
	i = 0;
	while(i < 6 && fraction_part > 0) {
		after_decimal[i++] = (char)(zero + (fraction_part % 10));
		fraction_part /= 10; 
	}
	// put zeros until all six decimal places have been filled
	while(i < 7) {
		after_decimal[i++] = zero;
	}

	// extract the integral part
	i = 0;
	if(integer_part == 0) {
		before_decimal[0] = zero;
		i++;
	}
	while(integer_part > 0) {
		before_decimal[i++] = (char)(zero + (integer_part % 10));
		integer_part /= 10;
	}

	// put the entire number in character buffer, integer part, decimal dot, followed by fractional part
	len = 0;
	i--;
	
	if(sign) buffer[len++] = '-'; // insert negative sign if number was negative
	
	// insert integer part
	for(; i >= 0; i--) {
		buffer[len++] = before_decimal[i];
	}
	
	buffer[len++] = '.'; // insert decimal dot
	
	// insert fractional part
	i = 5;
	for(; i >= 0; i--) {
		buffer[len++] = after_decimal[i];
	}
	
	//append with null character
	buffer[len++] = '\0';

	// syscall to write to stdout
	__asm__ __volatile__(
		"movl $1, %%eax \n\t" // operation is write(code = 1)
		"movq $1, %%rdi \n\t" // destination file is STDOUT(code = 1)
		"syscall \n\t"
		: 	
		:"S"(buffer), "d"(len)	// character buffer is buffer of length len
	);

	// return num of characters printed
	return len;
}

int readFlt(float * num) {
	char buffer[BUFF_SIZE], zero = '0', nine = '9';
	int num_char_read, sign = 0, dot_seen = 0, i;
	double frac_pow = 1;
	float val = 0;
	
	// syscall to read from stdin
	__asm__ __volatile__ (
		"movl $0, %%eax \n\t" // operation is read(code = 0)
		"movq $0, %%rdi \n\t" // file to be read is STDIN(code = 0)
		"syscall \n\t"	
		:"=a"(num_char_read) // returns number of characters read in num_char_read
		:"S"(buffer), "d"(sizeof(buffer)) // read a character string in buffer of total size BUFF_SIZE
	);

	// if no characters read, return ERR code
	if(num_char_read <= 0) return ERR;

	// newline read at the end is changed to null character and effective length is reduced by 1
	buffer[--num_char_read] = 0x0;

	// ignore trailing whitespaces
	i = num_char_read-1;
	while(i >= 0 && buffer[i--] == ' ');
	num_char_read = i+2; // change num_char_Read to ignore trailing spaces
	
	// append with a null character at the end
	buffer[num_char_read] = 0x0;

	// ignore whitespaces at the front 
	i = -1;
	while(buffer[++i] == ' ');
	// i points to the index with a non-blankspace character
	
	// check if string exhausted
	if(i < num_char_read) {
		// check if negative sign is present
		if(buffer[i] == '-') {
			sign = 1;
			i++;
			// check if string exhausted
			if(i >= num_char_read) return ERR;
		}

		// read the numbers and mark dot_seen 1 if decimal point is seen
		for(int j = i; j < num_char_read; j++) {
			char c = buffer[j];
			if(c == '.') {
				if(dot_seen) return ERR;
				dot_seen = 1;
				continue;
			}

			if(c >= zero && c <= nine) {
				if(dot_seen == 1) {
					// store the num of decimal places that have been seen, at the end will divide actual value by frac power to get final ans
					frac_pow = frac_pow * 10;
				} 
				val = val*10.0 + (float)(c - zero);
			}
			else if(c == 'e' || c == 'E') {
				// exponent found 
				// read the exponenet value
				int k = j+1, exp_sign = 0, exp_val = 0;
				if(k >= num_char_read) return ERR;

				// read exp_sign	
				if(buffer[k] == '-') {
					exp_sign = 1;
					k++;
					if(k >= num_char_read) return ERR;
				}
				
				// read the rest of the number as exponent value
				for(; k < num_char_read; k++) {
					if(buffer[k] >= zero && buffer[k] <= nine) {
						exp_val = exp_val*10 + (int)(buffer[k] - zero);
					} else {	
						return ERR;
					}
				}

				// change the frac_pow to the new effective number of decimal places 
				if(exp_sign) {
					while(exp_val--) {
						frac_pow *= 10;
					}
				} else {
					while(exp_val--) {
						frac_pow /= 10;
					}
				}
				break;
			}
			else return ERR;
		}

		// multiply the int value in val with frac_pow to get the decimal point at the correct place
		val = val/frac_pow;

		// negate if sign was present
		if(sign) val = -val;

		// store val at location num
		*num = val;

		// read successful
		return OK;
	}
	else {
		// string exhausted after removing whitespaces
		return ERR;
	}
}
/*
int main() {
	float f = -34.56;
	printFlt(f);
}
*/