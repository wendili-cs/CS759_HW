#include <cstddef>
#include <cuda.h>
#include <iostream>

using std::size_t, std::cout, std::endl;

template <typename T>
__global__ void matmul_kernel(const T *A, const T *B, T *C, unsigned int n,
                              unsigned int block_dim) {
    // block index
    int bx = blockIdx.x;
    int by = blockIdx.y;

    // thread index
    int tx = threadIdx.x;
    int ty = threadIdx.y;

    // index of the first/last element in the sub-matrix A
    int aBegin = n * block_dim * by;
    int aEnd = aBegin + n - 1;
    int aStep = block_dim;

    // index of the first/last element in the sub-matrix B
    int bBegin = block_dim * bx;
    int bStep = block_dim * n;

    // sub sum in C
    T Csub = (T)0;

    // allocate array on shared memory
    extern __shared__ int sdata[];
    T *As = (T *)sdata;
    T *Bs = (T *)&As[block_dim * block_dim];
    // __shared__ T As[block_dim][block_dim];
    // __shared__ T Bs[block_dim][block_dim];

    for (int a = aBegin, b = bBegin; a <= aEnd; a += aStep, b += bStep) {
        // load tiles from global
        int idxA = a + n * ty + tx, idxB = b + n * ty + tx;
        As[ty * block_dim + tx] = idxA < n * n ? A[idxA] : (T)0;
        Bs[ty * block_dim + tx] = idxB < n * n ? B[idxB] : (T)0;
        __syncthreads();

        for (int k = 0; k < block_dim; k++) {
            Csub += As[ty * block_dim + k] * Bs[k * block_dim + tx];
        }
        __syncthreads();
    }
    int c = n * block_dim * by + block_dim * bx;
    int idxC = c + n * ty + tx;
    if (idxC < n * n)
        C[idxC] = Csub;
}

__host__ void matmul_1(const int *A, const int *B, int *C, unsigned int n,
                       unsigned int block_dim) {
    dim3 dimBlock(block_dim, block_dim);
    dim3 dimGrid((n + dimBlock.x - 1) / dimBlock.x,
                 (n + dimBlock.y - 1) / dimBlock.y);
    unsigned int ssize = 2 * block_dim * block_dim * sizeof(int);
    matmul_kernel<int><<<dimGrid, dimBlock, ssize>>>(A, B, C, n, block_dim);
    cudaDeviceSynchronize();
}

__host__ void matmul_2(const float *A, const float *B, float *C, unsigned int n,
                       unsigned int block_dim) {
    dim3 dimBlock(block_dim, block_dim);
    dim3 dimGrid((n + dimBlock.x - 1) / dimBlock.x,
                 (n + dimBlock.y - 1) / dimBlock.y);
    unsigned int ssize = 2 * block_dim * block_dim * sizeof(float);
    matmul_kernel<float><<<dimGrid, dimBlock, ssize>>>(A, B, C, n, block_dim);
    cudaDeviceSynchronize();
}

__host__ void matmul_3(const double *A, const double *B, double *C,
                       unsigned int n, unsigned int block_dim) {
    dim3 dimBlock(block_dim, block_dim);
    dim3 dimGrid((n + dimBlock.x - 1) / dimBlock.x,
                 (n + dimBlock.y - 1) / dimBlock.y);
    unsigned int ssize = 2 * block_dim * block_dim * sizeof(double);
    matmul_kernel<double><<<dimGrid, dimBlock, ssize>>>(A, B, C, n, block_dim);
    cudaDeviceSynchronize();
}