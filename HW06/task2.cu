#include "scan.cuh"
#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl, std::atoi;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]), threads_per_block = atoi(argv[2]);
    float *input, *output;
    cudaMallocManaged(&input, n * sizeof(float));
    cudaMallocManaged(&output, n * sizeof(float));

    // initialize random functions
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> rand(-1.0, 1.0);

    for (int i = 0; i < n; i++) {
        input[i] = rand(random);
        // input[i] = 1;
    }

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // run kernel function
    scan(input, output, n, threads_per_block);

    // get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    cout << output[n - 1] << endl;
    cout << ms << endl;

    return 0;
}