#include "count.cuh"
#include <iostream>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/host_vector.h>
#include <thrust/random.h>

using std::cout, std::endl, std::atoi;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]);
    thrust::host_vector<int> in(n);
    thrust::device_vector<int> values;
    thrust::device_vector<int> counts;

    // initialize random functions
    thrust::default_random_engine eng(time(NULL));
    thrust::uniform_int_distribution<int> rand(0, 500);

    // assign random floats
    thrust::generate(in.begin(), in.end(), [&] { return rand(eng); });

    // transfer data to device
    thrust::device_vector<int> d_in = in;

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // run the count function
    count(d_in, values, counts);

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    cout << values.back() << endl;
    cout << counts.back() << endl;
    cout << ms << endl;

    return 0;
}