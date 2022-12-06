#include <iostream>
#include <omp.h>
#include <stdio.h>

using std::cout, std::endl;

int fa(int x) {
    int ret = 1;
    for (int i = 2; i <= x; i++) {
        ret *= i;
    }
    return ret;
}

int main() {
#pragma omp parallel num_threads(4)
    {
#pragma omp single
        { printf("Number of threads: %d\n", omp_get_num_threads()); }
        printf("I am thread No. %d\n", omp_get_thread_num());
#pragma omp barrier
#pragma omp for
        for (int i = 1; i <= 8; i++) {
            printf("%d!=%d\n", i, fa(i));
        }
    }

    return 0;
}