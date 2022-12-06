#include "reduce.h"
#include <cstddef>
#include <omp.h>

float reduce(const float *arr, const size_t l, const size_t r) {
    float sum = 0.0;
#pragma omp parallel
    {
#pragma omp for simd reduction(+ : sum)
        for (size_t i = l; i < r; i++) {
            sum += arr[i];
        }
    }
    return sum;
}