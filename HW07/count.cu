#include <thrust/device_vector.h>
#include <thrust/pair.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>
#include <thrust/unique.h>

typedef thrust::device_vector<int>::iterator iter;

void count(const thrust::device_vector<int> &d_in,
           thrust::device_vector<int> &values,
           thrust::device_vector<int> &counts) {
    thrust::device_vector<int> sorted_in = d_in;
    // sort data on device
    thrust::sort(thrust::device, sorted_in.begin(), sorted_in.end());

    // allocate values and counts
    counts = thrust::device_vector<int>(sorted_in.size());
    values = thrust::device_vector<int>(sorted_in.size());

    // ones for reduce_by_key
    thrust::device_vector<int> ones(sorted_in.size(), 1);

    // call reduce by key
    thrust::pair<iter, iter> new_end;
    new_end =
        thrust::reduce_by_key(sorted_in.begin(), sorted_in.end(), ones.begin(),
                              values.begin(), counts.begin());
    values.erase(thrust::get<0>(new_end), values.end());
    counts.erase(thrust::get<1>(new_end), counts.end());
}