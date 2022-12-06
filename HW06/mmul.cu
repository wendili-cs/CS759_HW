#include <cublas_v2.h>
#include <cuda.h>
#include <stdio.h>

void mmul(cublasHandle_t handle, const float *A, const float *B, float *C,
          int n) {
    const float a = 1, b = 2;
    const float *alpha = &a, *beta = &b;
    // do the general matrix multiplication
    cublasStatus_t stat = cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, n, n,
                                      alpha, A, n, B, n, beta, C, n);
    cudaDeviceSynchronize();
    if (stat != CUBLAS_STATUS_SUCCESS) {
        printf("Warning: mmul function failed!");
    }
};