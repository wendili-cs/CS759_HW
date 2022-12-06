#include "montecarlo.h"
#include <chrono>
#include <iostream>
#include <omp.h>
#include <random>

using std::cout, std::endl, std::atoi;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]), t = atoi(argv[2]);
    omp_set_num_threads(t);
    float radius = 1.0;

    // initialize random functions
    std::default_random_engine eng(time(NULL));
    std::uniform_real_distribution<float> rand(-radius, radius);

    // initialize x and y
    float *x = (float *)malloc(n * sizeof(float));
    float *y = (float *)malloc(n * sizeof(float));
    for (int i = 0; i < n; i++) {
        x[i] = rand(eng);
        y[i] = rand(eng);
    }

    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();

    // run the montecarlo function
    int num, rep = 10; // rep is number of repeat
    for (int i = 0; i < rep; i++) {
        num = montecarlo(n, x, y, radius);
    }

    // end timer
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    // output the results
    cout << 4 * num / (float)n << endl;
    cout << duration_sec.count() / rep << endl;

    return 0;
}