#include "cluster.h"
#include <algorithm>
#include <chrono>
#include <cstddef>
#include <iostream>
#include <omp.h>
#include <random>

using std::cout, std::endl, std::atoi;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]), t = atoi(argv[2]);

    // initialize random functions
    std::default_random_engine eng(time(NULL));
    std::uniform_real_distribution<float> rand(0.0, n);

    // initialize the arr of length n with floating numbers in [0, n]
    float *arr = (float *)malloc(n * sizeof(float));
    for (int i = 0; i < n; i++) {
        arr[i] = rand(eng);
    }
    std::sort(arr, arr + n);

    // initialize the centers of length t
    float *centers = (float *)malloc(t * sizeof(float));
    for (int i = 0; i < t; i++) {
        centers[i] = (2 * i + 1) * n / (float)(2 * t);
        // cout << "center[" << i << "] = " << centers[i] << endl;
    }

    // allocate dists
    float *dists = (float *)malloc(t * sizeof(float));
    for (int i = 0; i < t; i++) {
        dists[i] = 0.0;
    }

    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();

    // run the cluster function
    cluster(n, t, arr, centers, dists);

    // end timer
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    // determine the maximum value and its index
    int max_idx = std::max_element(dists, dists + t) - dists;
    float max_val = dists[max_idx];

    // output the results
    cout << max_val << endl;
    cout << max_idx << endl;
    cout << duration_sec.count() << endl;

    return 0;
}