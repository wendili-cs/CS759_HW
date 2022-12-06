#include "matmul.h"
#include <assert.h>
#include <chrono>
#include <cstddef>
#include <iostream>
#include <random>
#include <vector>

using std::cout;
using std::endl;
using std::size_t;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

const unsigned int n = 1024;
double A[n][n], B[n][n], C[n][n];
std::vector<double> vA(n *n), vB(n *n);

void init_matrix(double *M, const unsigned int rows, const unsigned int cols) {
    std::default_random_engine r(time(0));
    std::uniform_real_distribution<double> init(-1.0, 1.0);
    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            M[i * cols + j] = init(r);
        }
    }
}

void assign_vec(std::vector<double> &V, double *M, const unsigned int rows,
                const unsigned int cols) {
    assert(V.size() == rows * cols);
    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            V[i * cols + j] = M[i * cols + j];
        }
    }
}

int main(int argc, char *argv[]) {
    init_matrix((double *)A, n, n);
    init_matrix((double *)B, n, n);

    cout << n << endl;

    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;

    start = high_resolution_clock::now();
    mmul1((double *)A, (double *)B, (double *)C, n);
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << duration_sec.count() << endl;
    cout << C[n - 1][n - 1] << endl;

    start = high_resolution_clock::now();
    mmul2((double *)A, (double *)B, (double *)C, n);
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << duration_sec.count() << endl;
    cout << C[n - 1][n - 1] << endl;

    start = high_resolution_clock::now();
    mmul3((double *)A, (double *)B, (double *)C, n);
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << duration_sec.count() << endl;
    cout << C[n - 1][n - 1] << endl;

    assign_vec(vA, (double *)A, n, n);
    assign_vec(vB, (double *)B, n, n);
    start = high_resolution_clock::now();
    mmul4(vA, vB, (double *)C, n);
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << duration_sec.count() << endl;
    cout << C[n - 1][n - 1] << endl;

    return 0;
}