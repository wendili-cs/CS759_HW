#include "matmul.cuh"
#include <cuda.h>
#include <iostream>
#include <random>
#include <type_traits>

using std::cout, std::endl, std::atoi;

template <typename T> void init_matrix(T *M, unsigned int n) {
    // initialize random functions
    // std::default_random_engine random(time(NULL));
    // std::uniform_real_distribution<T> rand(-1.0, 1.0);

    int L = 3; // distribuction between [-L, L]
    // initialize the matrix
    for (unsigned int i = 0; i < n; i++) {
        for (unsigned int j = 0; j < n; j++) {
            unsigned int idx = i * n + j;
            // M[idx] = rand(random);
            M[idx] = (T)(rand() % (2 * L + 1) - L);
        }
    }
}

template <typename T>
void carry_test(unsigned int n, unsigned int block_dim,
                void (*mm)(const T *, const T *, T *, unsigned int,
                           unsigned int)) {
    // allocate space in host
    T *A = (T *)malloc(n * n * sizeof(T));
    T *B = (T *)malloc(n * n * sizeof(T));
    T *C = (T *)malloc(n * n * sizeof(T));

    // initialize the matrix
    init_matrix<T>(A, n);
    init_matrix<T>(B, n);
    init_matrix<T>(C, n);

    // allocate space in device
    T *dA, *dB, *dC;
    cudaMalloc((void **)&dA, n * n * sizeof(T));
    cudaMalloc((void **)&dB, n * n * sizeof(T));
    cudaMalloc((void **)&dC, n * n * sizeof(T));

    // copy memory from host to device
    cudaMemcpy(dA, A, n * n * sizeof(T), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B, n * n * sizeof(T), cudaMemcpyHostToDevice);

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // run matmul function
    mm(dA, dB, dC, n, block_dim);

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // copy back the result to the host
    cudaMemcpy(C, dC, n * n * sizeof(T), cudaMemcpyDeviceToHost);

    // release memory in GPU
    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);

    cout << C[0] << endl;
    cout << C[n * n - 1] << endl;
    cout << ms << endl;
}

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]), block_dim = atoi(argv[2]);

    carry_test<int>(n, block_dim, matmul_1);
    carry_test<float>(n, block_dim, matmul_2);
    carry_test<double>(n, block_dim, matmul_3);

    return 0;
}