#include "mmul.h"
#include <cuda.h>
#include <iostream>
#include <random>

using std::cout, std::endl, std::atoi;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]), n_tests = atoi(argv[2]);

    // allocate memory for matrices
    float *A, *B, *C;
    cudaMallocManaged(&A, n * n * sizeof(float));
    cudaMallocManaged(&B, n * n * sizeof(float));
    cudaMallocManaged(&C, n * n * sizeof(float));

    // initialize random functions
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> rand(-1.0, 1.0);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int idx = i * n + j;
            A[idx] = rand(random);
            B[idx] = rand(random);
            C[idx] = rand(random);
            // A[idx] = 1.0;
            // B[idx] = 1.0;
            // C[idx] = 1.0;
        }
    }

    // create handle
    cublasStatus_t stat;
    cublasHandle_t handle;
    stat = cublasCreate(&handle);
    if (stat != CUBLAS_STATUS_SUCCESS) {
        printf("CUBLAS initialization failed\n");
        return EXIT_FAILURE;
    }

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // repeatly run mmul function
    for (int i = 0; i < n_tests; i++) {
        mmul(handle, A, B, C, n);
    }

    // get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // destory the handler
    cublasDestroy(handle);

    cout << ms / n_tests << endl;

    return 0;
}