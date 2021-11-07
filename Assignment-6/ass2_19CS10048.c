/*******************************
Name - Debanjan Saha + PritKumar Godhani
Roll - 19CS30014 + 19CS10048
Assignment No. - 6
Semester No.- 5
CS39003
*******************************/

#define MAX_INPUT_SIZE 50
#define MAX_OUTPUT_SIZE 300
#define SYS_READ 0
#define STDIN_FILENO 0
#include "myl.h"

int printStr(char *str)
{
	int length = 0;
	while (str[length] != '\0')
	{
		length++;
	}

	// Inline Assembly Code for printing to the OUTPUT STREAM.
	__asm__ __volatile__(
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		: "S"(str), "d"(length));

	return length;
}

int readInt(int *eP)
{
	// Array for getting integer from input stream as a string
	char buffer[MAX_INPUT_SIZE];
	int numCharsRead = 0;
	int isNegative = 0;

	// Inline Assembly Code for getting input from the INPUT STREAM.
	__asm__ __volatile__("syscall" /* Make the syscall. */
						 : "=a"(numCharsRead)
						 : "0"(SYS_READ), "D"(STDIN_FILENO), "S"(buffer), "d"(sizeof(buffer))
						 : "rcx", "r11", "memory", "cc");

	//character at index = numCharsRead - 1 will be '\0'
	int index = numCharsRead - 2;

	// Ignore whitespaces
	while (index >= 0 && buffer[index] == ' ')
	{
		index--;
	}

	int length = index + 1;

	index = 0;
	// Ignore whitespaces
	while (buffer[index] == ' ')
	{
		index++;
	}

	// Check if negative integer is provided
	if (buffer[index] == '-')
	{
		// Negative Check
		isNegative = 1;
		index++;
	}

	int num = 0;
	// Build the integer digit by digit
	// If digit is not valid, return error.
	while (index < length)
	{
		if (!(buffer[index] >= '0' && buffer[index] <= '9'))
		{
			*eP = ERR;
			return 0;
		}
		int digit = buffer[index] - '0';
		num = num * 10 + digit;
		index++;
	}

	// If the input was negative, make the integer negative of itself
	if (isNegative)
	{
		num = -num;
	}

	// Assign the flag to the actual variable.
	*eP = OK;
	return num;
}

int printInt(int num)
{
	// Array for printing integer as a string to output stream
	char buffer[MAX_OUTPUT_SIZE];
	int index = 0, length = 0;

	// Handle 0 Separately
	if (num == 0)
	{
		buffer[index++] = '0';
		length = index;
	}
	else
	{

		// Handle Negative Number
		if (num < 0)
		{
			buffer[index++] = '-';
			num = -num;
		}

		// Store the digits in the character array 'buffer'
		while (num)
		{
			int digit = num % 10;
			buffer[index++] = (char)('0' + digit);
			num /= 10;
		}

		length = index;

		if (buffer[0] == '-')
			index = 1;
		else
			index = 0;

		// We have to reverse the array since it was filled by digits of integer from right to left
		int arr_len = (length - index);
		for (int i = index; i < index + arr_len / 2; i++)
		{
			int idx = length - i - (index == 0);
			char temp = buffer[i];
			buffer[i] = buffer[idx];
			buffer[idx] = temp;
		}
	}

	buffer[length] = '\0';

	// Inline Assembly Code for printing to the OUTPUT STREAM.
	__asm__ __volatile__(
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t" /* Make the syscall. */
		:
		: "S"(buffer), "d"(length)); // $4: write, $1: on stdin
	return length;
}