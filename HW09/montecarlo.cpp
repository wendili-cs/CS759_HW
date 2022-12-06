#include <cstddef>
#include <iostream>
#include <omp.h>

using std::cout, std::endl;

int montecarlo(const size_t n, const float *x, const float *y,
               const float radius) {
    int num = 0;
#pragma omp parallel
    {
// #pragma omp single
//         {
//             cout << "num_threads = " << omp_get_num_threads() << endl;
//         }
#pragma omp for simd reduction(+ : num)
        for (size_t i = 0; i < n; i++) {
            if (x[i] * x[i] + y[i] * y[i] <= radius * radius) {
                num++;
            }
        }
    }
    return num;
}