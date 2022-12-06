#include <cuda.h>
#include <stdio.h>

__global__ void task1() {
    int fac = 1;
    for (int i = 1; i <= 1 + threadIdx.x; i++) {
        fac *= i;
    }
    printf("%d!=%d\n", 1 + threadIdx.x, fac);
}

int main() {
    // initialize the number of threads and blocks
    const int numThreads = 8, numBlocks = 1;
    // run the function with no parameter
    task1<<<numBlocks, numThreads>>>();
    cudaDeviceSynchronize();
    return 0;
}