#include <cstddef>
#include <cuda.h>

using std::size_t;

__global__ void matmul_kernel(const float *A, const float *B, float *C,
                              size_t n) {
    size_t idx_C = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx_C < n * n) {
        float tsum = 0.0;
        size_t idx_B = idx_C % n;
        size_t idx_A = idx_C - idx_B;
        for (size_t i = 0; i < n; i++) {
            tsum += A[idx_A + i] * B[idx_B + i * n];
        }
        C[idx_C] = tsum;
    }
};

void matmul(const float *A, const float *B, float *C, size_t n,
            unsigned int threads_per_block) {
    // run matmul kernel function
    const int numBlocks = (n * n + threads_per_block - 1) / threads_per_block;
    matmul_kernel<<<numBlocks, threads_per_block>>>(A, B, C, n);
    cudaDeviceSynchronize();
};