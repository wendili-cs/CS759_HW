#include <iostream>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/host_vector.h>
#include <thrust/random.h>

using std::cout, std::endl, std::atoi;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]);
    thrust::host_vector<float> arr(n);

    // initialize random functions
    thrust::default_random_engine eng(1234);
    thrust::uniform_real_distribution<float> rand(-1.0, 1.0);

    // assign random floats
    thrust::generate(arr.begin(), arr.end(), [&] { return rand(eng); });

    // transfer data to device
    thrust::device_vector<float> d_arr = arr;

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // apply reduce function
    float res =
        thrust::reduce(d_arr.begin(), d_arr.end(), 0.0, thrust::plus<float>());

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    cout << res << endl;
    cout << ms << endl;

    return 0;
}