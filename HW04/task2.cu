#include "stencil.cuh"
#include <cstddef>
#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl, std::size_t, std::atoi;

int main(int argc, char *argv[]) {
    // read input of n, R, threads
    size_t n = atoi(argv[1]), R = atoi(argv[2]),
           threads_per_block = atoi(argv[3]);

    // initialize random generator
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> rand_i(-1.0, 1.0);
    std::uniform_real_distribution<float> rand_m(-1.0, 1.0);

    // initialize the image, mask, and output
    float *image, *mask, *output;
    image = (float *)malloc(n * sizeof(float));
    mask = (float *)malloc((2 * R + 1) * sizeof(float));
    output = (float *)malloc(n * sizeof(float));

    // assign the image and mask
    for (size_t i = 0; i < n; i++) {
        image[i] = rand_i(random);
        // image[i] = 2.0;
    }
    for (size_t i = 0; i <= 2 * R; i++) {
        mask[i] = rand_m(random);
        // mask[i] = 0.5;
    }

    // allocate space in device
    float *dImage, *dMask, *dOutput;
    cudaMalloc((void **)&dImage, n * sizeof(float));
    cudaMalloc((void **)&dMask, (2 * R + 1) * sizeof(float));
    cudaMalloc((void **)&dOutput, n * sizeof(float));

    // copy from host to device
    cudaMemcpy(dImage, image, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dMask, mask, (2 * R + 1) * sizeof(float),
               cudaMemcpyHostToDevice);

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // run stencil function
    stencil(dImage, dMask, dOutput, n, R, threads_per_block);

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // copy back to host
    cudaMemcpy(output, dOutput, n * sizeof(float), cudaMemcpyDeviceToHost);

    // release memory in GPU
    cudaFree(dImage);
    cudaFree(dMask);
    cudaFree(dOutput);

    // for DEBUG only
    // for (unsigned int i = 0; i < n; i++) {
    //     cout << output[i] << endl;
    // }
    cout << output[n - 1] << endl;
    cout << ms << endl;

    return 0;
}