#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl;

__global__ void task2(int *dA, int a) {
    dA[blockIdx.x * blockDim.x + threadIdx.x] = a * threadIdx.x + blockIdx.x;
}

int main() {
    // initialize the number of threads and blocks
    const int numThreads = 8, numBlocks = 2;
    int hA[numBlocks * numThreads], *dA;

    // allocate the memory
    cudaMalloc((void **)&dA, sizeof(int) * numBlocks * numThreads);

    // generate a random integer
    srand((unsigned)time(NULL));
    const int RANGE = 100;
    int a = rand() % (RANGE + 1);

    // run function with 1 parameter
    task2<<<numBlocks, numThreads>>>(dA, a);
    cudaDeviceSynchronize();

    // copy back to host from device
    cudaMemcpy(hA, dA, sizeof(int) * numBlocks * numThreads,
               cudaMemcpyDeviceToHost);

    // release memory in GPU
    cudaFree(dA);

    for (int i = 0; i < numBlocks * numThreads; i++) {
        cout << hA[i] << " ";
    }
    cout << endl;
    return 0;
}