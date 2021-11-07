int printStr(char *c);
int readInt(int *ep);
int printInt(int i);

int pow(int a,int b){
  int ans;
  if(b==0)ans = 1;
  else if(b==1)ans = a;
  else ans = a*pow(a,b-1);
  return ans;
}

int main() {
  int i,j=5,c;
  int b;
  printStr("      ##########################################\n      ##                                      ##\n      ##         Recursive Function           ##\n      ##          POWER FUNCTION              ##\n      ##                                      ##\n      ##########################################\n      \n");
  
  printStr("      Enter the BASE     : ");
  b = readInt(&i);
  printStr("      Enter the EXPONENT : ");
  b = readInt(&j);
  c=pow(i,j);
  printStr("\n\n      The value of ");
  printInt(i);
  printStr("^");
  printInt(j);
  printStr(" is : ");
  printInt(c);
  printStr("\n");
  return 0;
}