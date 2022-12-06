#define CUB_STDERR // print CUDA runtime errors to console
#include <cub/device/device_reduce.cuh>
#include <cub/util_allocator.cuh>
#include <iostream>
#include <random>
#include <stdio.h>
using namespace cub;
CachingDeviceAllocator g_allocator(true); // Caching allocator for device memory

using std::cout, std::endl, std::atoi;

int main(int argc, char *argv[]) {
    int num_items = atoi(argv[1]);
    // Set up host arrays
    float *h_in = (float *)malloc(num_items * sizeof(float));
    ;

    // initialize random functions
    std::default_random_engine eng(time(NULL));
    std::uniform_real_distribution<float> rand(-1.0, 1.0);

    // initialize the array
    for (int i = 0; i < num_items; i++) {
        h_in[i] = rand(eng);
        // h_in[i] = 1.0;
    }

    // Set up device arrays
    float *d_in = NULL;
    g_allocator.DeviceAllocate((void **)&d_in, sizeof(float) * num_items);

    // Initialize device input
    cudaMemcpy(d_in, h_in, sizeof(float) * num_items, cudaMemcpyHostToDevice);

    // Setup device output array
    float *d_sum = NULL;
    g_allocator.DeviceAllocate((void **)&d_sum, sizeof(float) * 1);

    // Request and allocate temporary storage
    void *d_temp_storage = NULL;
    size_t temp_storage_bytes = 0;
    DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum,
                      num_items);
    g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes);

    // ready for timing
    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // Do the actual reduce operation
    DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum,
                      num_items);

    // Get the elapsed time in milliseconds
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // obtain the sum result
    float gpu_sum;
    cudaMemcpy(&gpu_sum, d_sum, sizeof(float) * 1, cudaMemcpyDeviceToHost);

    cout << gpu_sum << endl;
    cout << ms << endl;

    // Cleanup
    if (d_in)
        g_allocator.DeviceFree(d_in);
    if (d_sum)
        g_allocator.DeviceFree(d_sum);
    if (d_temp_storage)
        g_allocator.DeviceFree(d_temp_storage);

    return 0;
}