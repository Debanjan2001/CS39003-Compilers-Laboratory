/*******************************
Name - Debanjan Saha
Roll - 19CS30014
Assignment No. - 2
Semester No.- 5
CS39003
*******************************/
#include "myl.h"

int main(){

    int choice,ret = -1;
    int n = 0;
    float f = 0.0;
    printStr("< Welcome to Debanjan's Toy Library />\n\n");
    printStr("You will be given some choices. Please choose one :-)");



    while(1){

        printStr("\n0. Exit\n1. Read Integer\n2. Print Integer\n3. Read Float\n4. Print Float\n>> Enter your choice: ");
        
        ret = readInt(&choice);

        if( ret == ERR){
            printStr("\nYou have entered a choice which is not an integer! Please Check again\n");
            continue;
        }
        
        if(choice == 0){
            printStr("Bye. Have a good day!\n");
            break;
        } else if(choice == 1){
            printStr(">> Enter The Integer: ");
            ret = readInt(&n);
            if(ret == ERR){
                printStr("\n!! Invalid Integer Provided. Please Check again.\n");
            } else {
                printStr("\n!! Read Integer Successful.\n");
            }
 
        } else if (choice == 2){
            
            printStr("\nYour last given input integer was: ");
            ret = printInt(n);
            printStr("\n");
            printStr("Characters Printed = ");
            printInt(ret);    
            printStr("\n");

        } else if( choice == 3){
            printStr(">> Enter The Float: ");
            ret = readFlt(&f);
            if(ret == ERR){
                printStr("\n!! Invalid Floating Point Number Provided. Please Check again.\n");
            } else {
                printStr("\n!! Read Float Successful.\n");
            }


        } else if( choice == 4){
            printStr("\nYour last given input was: ");
            ret = printFlt(f);
            printStr("\n");
            printStr("Characters Printed = ");
            printInt(ret);    
            printStr("\n");
        } else {
            printStr("\nPlease Check your choice. It is invalid !\n");
        }
    }

    return 0;
}