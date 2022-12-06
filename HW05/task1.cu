#include "reduce.cuh"
#include <cassert>
#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl, std::atoi;

int main(int argc, char *argv[]) {
    // read the array length N and the number of threads per block
    int N = atoi(argv[1]), threads_per_block = atoi(argv[2]);
    // assert the number of threads is 2**n
    assert((threads_per_block & (threads_per_block - 1)) == 0);

    // initialize random functions
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> rand(-1.0, 1.0);

    const int numBlocks =
        (N + 2 * threads_per_block - 1) / (2 * threads_per_block);
    float *input, *output;
    // cudaMallocHost(&input, N * sizeof(float));
    // cudaMallocHost(&output, numBlocks * sizeof(float));
    input = (float *)malloc(N * sizeof(float));
    output = (float *)malloc(numBlocks * sizeof(float));

    // initialize the array
    for (int i = 0; i < N; i++) {
        input[i] = rand(random);
        // input[i] = 1.0;
    }

    // allocate space in device
    float *dInput, *dOutput;
    cudaMalloc((void **)&dInput, N * sizeof(float));
    cudaMalloc((void **)&dOutput, numBlocks * sizeof(float));

    // copy memory from host to device
    cudaMemcpy(dInput, input, N * sizeof(float), cudaMemcpyHostToDevice);

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // run reduce function
    reduce((float **)dInput, (float **)dOutput, N, threads_per_block);

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // copy back the result to the host
    cudaMemcpy(output, dOutput, numBlocks * sizeof(float),
               cudaMemcpyDeviceToHost);

    // DEBUG ONLY
    // for(int i = 0; i < numBlocks; i++)
    //     cout << "output[" << i << "] = " << output[i] << endl;

    // release memory in GPU
    cudaFree(dInput);
    cudaFree(dOutput);

    cout << output[0] << endl;
    cout << ms << endl;

    return 0;
}