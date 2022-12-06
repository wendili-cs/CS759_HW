#include "vscale.cuh"
#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl;

float *a, *b, *da, *db;

int main(int argc, char **argv) {
    // initialize random functions
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> rand_a(-10.0, 10.0);
    std::uniform_real_distribution<float> rand_b(-1.0, 1.0);

    // initialize the array
    int n = std::atoi(argv[1]);
    a = (float *)malloc(n * sizeof(float));
    b = (float *)malloc(n * sizeof(float));
    for (int i = 0; i < n; i++) {
        a[i] = rand_a(random);
        b[i] = rand_b(random);
    }

    // allocate the memory
    cudaMalloc((void **)&da, sizeof(float) * n);
    cudaMalloc((void **)&db, sizeof(float) * n);

    // copy from host to device
    cudaMemcpy(da, a, sizeof(float) * n, cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, sizeof(float) * n, cudaMemcpyHostToDevice);

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    // run vscale function
    const int numThreads = 512, numBlocks = (n + numThreads - 1) / numThreads;
    vscale<<<numBlocks, numThreads>>>(da, db, n);
    cudaDeviceSynchronize();

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    // Get the elapsed time in milliseconds
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // copy back to host from device
    cudaMemcpy(b, db, sizeof(float) * n, cudaMemcpyDeviceToHost);

    // release memory in GPU
    cudaFree(da);
    cudaFree(db);

    cout << ms << endl;
    cout << b[0] << endl;
    cout << b[n - 1] << endl;
    return 0;
}