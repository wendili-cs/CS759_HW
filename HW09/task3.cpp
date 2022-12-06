#include "mpi.h"
#include <chrono>
#include <iostream>
#include <random>

using std::cout, std::endl, std::atoi;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]);

    // declear variables
    int rank, tag = 0, other;
    float *time_cnt = new float[1];
    float send[n], recv[n];
    // send = (float *)malloc(n * sizeof(float));
    // recv = (float *)malloc(n * sizeof(float));
    MPI_Status status;

    // MPI
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // rank of the other one
    other = 1 - rank;

    // initialize random functions
    std::default_random_engine eng(time(NULL));
    std::uniform_real_distribution<float> rand(0.0, 1.0);

    // initialize send array
    for (int i = 0; i < n; i++) {
        send[i] = rand(eng);
    }

    if (rank == 0) {
        // initialize timer
        high_resolution_clock::time_point start;
        high_resolution_clock::time_point end;
        duration<double, std::milli> duration_sec;
        start = high_resolution_clock::now();

        // communicate data
        MPI_Send(send, n, MPI_FLOAT, other, tag, MPI_COMM_WORLD);
        MPI_Recv(recv, n, MPI_FLOAT, other, tag, MPI_COMM_WORLD, &status);

        // end timer
        end = high_resolution_clock::now();
        duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(
            end - start);

        // receive time from rank 1
        MPI_Recv(time_cnt, 1, MPI_FLOAT, other, tag, MPI_COMM_WORLD, &status);

        // output the result
        cout << (*time_cnt + duration_sec.count()) << endl;
    } else if (rank == 1) {
        // initialize timer
        high_resolution_clock::time_point start;
        high_resolution_clock::time_point end;
        duration<double, std::milli> duration_sec;
        start = high_resolution_clock::now();

        // communicate data
        MPI_Recv(recv, n, MPI_FLOAT, other, tag, MPI_COMM_WORLD, &status);
        MPI_Send(send, n, MPI_FLOAT, other, tag, MPI_COMM_WORLD);

        // end timer
        end = high_resolution_clock::now();
        duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(
            end - start);

        // send time to rank 0
        *time_cnt = duration_sec.count();
        MPI_Send(time_cnt, 1, MPI_FLOAT, other, tag, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}