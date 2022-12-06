#include <cstddef>
#include <vector>

using std::size_t;

void mmul1(const double *A, const double *B, double *C, const unsigned int n) {
    // A -> [x, y], B -> [y, z], C -> [x, z]
    for (size_t i = 0; i < n; i++) {
        for (size_t j = 0; j < n; j++) {
            for (size_t k = 0; k < n; k++) {
                int idx_C = i * n + j;
                int idx_A = i * n + k, idx_B = k * n + j;
                double prod = A[idx_A] * B[idx_B];
                C[idx_C] = k == 0 ? prod : C[idx_C] + prod;
            }
        }
    }
}

void mmul2(const double *A, const double *B, double *C, const unsigned int n) {
    // A -> [x, y], B -> [y, z], C -> [x, z]
    for (size_t i = 0; i < n; i++) {
        for (size_t k = 0; k < n; k++) {
            for (size_t j = 0; j < n; j++) {
                int idx_C = i * n + j;
                int idx_A = i * n + k, idx_B = k * n + j;
                double prod = A[idx_A] * B[idx_B];
                C[idx_C] = k == 0 ? prod : C[idx_C] + prod;
            }
        }
    }
}

void mmul3(const double *A, const double *B, double *C, const unsigned int n) {
    // A -> [x, y], B -> [y, z], C -> [x, z]
    for (size_t j = 0; j < n; j++) {
        for (size_t k = 0; k < n; k++) {
            for (size_t i = 0; i < n; i++) {
                int idx_C = i * n + j;
                int idx_A = i * n + k, idx_B = k * n + j;
                double prod = A[idx_A] * B[idx_B];
                C[idx_C] = k == 0 ? prod : C[idx_C] + prod;
            }
        }
    }
}

void mmul4(const std::vector<double> &A, const std::vector<double> &B,
           double *C, const unsigned int n) {
    // A -> [x, y], B -> [y, z], C -> [x, z]
    for (size_t i = 0; i < n; i++) {
        for (size_t j = 0; j < n; j++) {
            for (size_t k = 0; k < n; k++) {
                int idx_C = i * n + j;
                int idx_A = i * n + k, idx_B = k * n + j;
                double prod = A[idx_A] * B[idx_B];
                C[idx_C] = k == 0 ? prod : C[idx_C] + prod;
            }
        }
    }
}