#include "mpi.h"
#include "reduce.h"
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
    std::uniform_real_distribution<float> rand(-1.0, 1.0);

    // allocate the array
    float *arr = (float *)malloc(n * sizeof(float));
    for (int i = 0; i < n; i++) {
        arr[i] = rand(eng);
        // arr[i] = 1.0;
    }

    // initialize the variables
    float res, global_res;
    int rank;

    // MPI
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // set num of threads in openMP
    omp_set_num_threads(t);

    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();

    // call the reduce function
    res = reduce(arr, 0, n);

    // call the MPI reduce
    MPI_Reduce(&res, &global_res, 1, MPI_FLOAT, MPI_SUM, 0.0, MPI_COMM_WORLD);

    // end timer
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    if (rank == 0) {
        cout << global_res << endl;
        cout << duration_sec.count() << endl;
    }

    MPI_Finalize();
    return 0;
}