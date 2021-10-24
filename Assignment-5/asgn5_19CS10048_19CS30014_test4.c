int computeFib(int n) {
    if(n <= 1) 
        return n;
    
    return computeFib(n-1) + computeFib(n-2);
}

int dpFib(int n) {
    int f[100];
    if(n >= 100) 
        return -1;
    
    f[0] = 0; f[1] = 1;

    for(int _loop = 2; _loop <= n; _loop ++) {
        f[_loop] = f[_loop-1] + f[_loop-2];
    }

    return f[n];
}

int main() {
    int x,y,z,f;
    f = 8;

    if(f == 9) {
        x = 9;
        y = 8;
    }
    else {
        x = 10;
        if(f > 10)
            y = 4;
        else
            y = 2;
    }

    z = computeFib(x+y);
    int a = computeFib(x + 2*y);
    
    if(a != -1 && z != a) {
        f = 100;
    }
    return 0;
}