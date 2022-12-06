#include "matmul.cuh"
#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl;

int main(int argc, char *argv[]) {
    // read the input of n and the number of threads per block
    int n = std::atoi(argv[1]), threads_per_block = std::atoi(argv[2]);

    // initialize random functions
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> rand_a(-1.0, 1.0);
    std::uniform_real_distribution<float> rand_b(-1.0, 1.0);

    float *A, *B, *C;

    // initialize the matrices A and B
    A = (float *)malloc(n * n * sizeof(float));
    B = (float *)malloc(n * n * sizeof(float));
    C = (float *)malloc(n * n * sizeof(float));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int idx = i * n + j;
            A[idx] = rand_a(random);
            B[idx] = rand_b(random);
        }
    }

    // allocate space in device
    float *dA, *dB, *dC;
    cudaMalloc((void **)&dA, n * n * sizeof(float));
    cudaMalloc((void **)&dB, n * n * sizeof(float));
    cudaMalloc((void **)&dC, n * n * sizeof(float));

    // copy from host to device
    cudaMemcpy(dA, A, n * n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B, n * n * sizeof(float), cudaMemcpyHostToDevice);

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // run matmul function
    matmul(dA, dB, dC, n, threads_per_block);

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // copy back to the host
    cudaMemcpy(C, dC, n * n * sizeof(float), cudaMemcpyDeviceToHost);

    // release memory in GPU
    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);

    cout << C[n * n - 1] << endl;
    cout << ms << endl;

    return 0;
}