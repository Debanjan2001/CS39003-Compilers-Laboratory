//  arrays (multidimensional) ,  loops and nested loops
int glb1 = 5;

int main()
{
	int i = 0, j = 0, n;
	int sum = 0;
	char bb = '#';
	char esc = "\t";
	int num[5]; // 1D integer array
	int arr2d[25][25]; // 2D integer array

	// do-while
	do {
		sum = sum + num[i];
	} while(i<5);

	// while
	while(i<5) {
		i++;
		++j;
		num[i] = i*j + 2*i + 3*j;
	}
	
	n = glb1 * glb1;
	for(i=0;i<n;i++) {
		for(j=0;j<n;j++)  // nested for loop
			arr2d[i][j] = i*j; // multi dimensional array
	}

	return 0;
}