int main() {
    int arr[10];
    int n = 10;
    arr[0] = 0;
    for(int i = 1; i < n; i++) {
        arr[i] = arr[i-1] + i;
    }
    int res = arr[n-1];
    return res;
}
