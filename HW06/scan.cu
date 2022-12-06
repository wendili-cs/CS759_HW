#include <cmath>
#include <cublas_v2.h>
#include <cuda.h>
#include <stdio.h>

__global__ void HillisSteele_scan_kernel(float *g_odata, const float *g_idata,
                                         unsigned int n, int shift) {
    // allocate shared memroy
    extern volatile __shared__ float temp[];

    int thid = threadIdx.x;
    int pout = 0, pin = 1;
    if (thid >= n)
        temp[thid] = 0;
    else {
        float first_ele = (shift == 0) ? 0 : g_odata[shift - 1];
        temp[thid] = (thid == 0) ? first_ele : g_idata[shift + thid - 1];
    }
    __syncthreads();

    for (int offset = 1; offset < n; offset <<= 1) {
        pout = 1 - pout;
        pin = 1 - pout;

        if (thid >= offset) {
            temp[pout * n + thid] =
                temp[pin * n + thid] + temp[pin * n + thid - offset];
        } else {
            temp[pout * n + thid] = temp[pin * n + thid];
        }
        __syncthreads();
    }
    if (thid < n)
        g_odata[shift + thid] = g_idata[shift + thid] + temp[pout * n + thid];
}

__host__ void scan(const float *input, float *output, unsigned int n,
                   unsigned int threads_per_block) {
    const int numBlocks = (n + threads_per_block - 1) / threads_per_block;
    for (int i = 0; i < numBlocks; i++) {
        int shift = i * threads_per_block;
        int len =
            (threads_per_block > n - shift) ? n - shift : threads_per_block;
        // printf("len:%d\n", len);
        HillisSteele_scan_kernel<<<1, threads_per_block,
                                   2 * threads_per_block * sizeof(float)>>>(
            output, input, len, shift);
        cudaDeviceSynchronize();
    }
    cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess) {
        // printf(cudaGetErrorString(error));
    }
}
