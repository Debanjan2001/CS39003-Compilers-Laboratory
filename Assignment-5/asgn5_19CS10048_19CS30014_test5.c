
int valTransform(int x) {
    return  x<<2 + x<<3 + ((x>>2) ^ x);
}

int main() {
    int multi_arr[45][45][45];
    int a = 1, r = 2;

    for(int i = 0; i < 45; i++) {
        for(int j = 0; j < 45; j++) {
            for(int k = 0; k < 45; k+=2) {
                int p = 0;
                while(p < i+j) {
                    p += a*r + r + a;
                }
                multi_arr[i][j][k] = p;
            }

            for(int k = 1; k < 45; k+=2) {
                int p = 0;
                do {
                    p += a*r + multi_arr[i][j][k-1];
                }while(p < i+j);

                multi_arr[i][j][k] = p;
            }
        }
    }

    int res = valTransform(multi_arr[4][4][4]);

    return 0;
}