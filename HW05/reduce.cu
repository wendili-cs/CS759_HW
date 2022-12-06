#include <cstddef>
#include <cuda.h>
#include <iostream>
#include <stdio.h>

using std::size_t, std::cout, std::endl;

__global__ void reduce_kernel(float *g_idata, float *g_odata, unsigned int n) {
    // allocate array on shared memory
    extern __shared__ float sdata[];
    size_t tid = threadIdx.x;
    size_t i = blockIdx.x * blockDim.x * 2 + threadIdx.x;
    // first add two global values to one shared memory slot
    sdata[tid] = g_idata[i] + g_idata[i + blockDim.x];
    __syncthreads();

    // apply reduction
    for (size_t s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
            sdata[tid] += sdata[tid + s];
        }
        __syncthreads();
    }

    // write the result back to global memory
    if (tid == 0)
        g_odata[blockIdx.x] = sdata[0];
};

__host__ void reduce(float **input, float **output, unsigned int N,
                     unsigned int threads_per_block) {
    // launch kernel function
    while (N > 1) {
        const int numBlocks =
            (N + 2 * threads_per_block - 1) / (2 * threads_per_block);
        reduce_kernel<<<numBlocks, threads_per_block,
                        threads_per_block * sizeof(float)>>>(
            (float *)input, (float *)output, N);
        cudaDeviceSynchronize();
        // merge the results in blocks
        input = output;
        N = numBlocks;
    }
};