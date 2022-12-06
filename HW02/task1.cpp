#include "scan.h"
#include <chrono>
#include <iostream>
#include <random>
// Provide some namespace shortcuts
using std::cout;
using std::endl;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

float add(float &a, float &b) { return a + b; }

const int MAX_N = 2000000000;
float *arr;

int main(int argc, char *argv[]) {
    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;

    // initialize random function
    std::default_random_engine random(time(NULL));
    std::uniform_real_distribution<float> uni_rand(-1.0, 1.0);

    // initialize the array
    int n = std::atoi(argv[1]);
    n = std::min(n, MAX_N);

    arr = (float *)malloc(n * sizeof(float));
    for (int i = 0; i < n; i++) {
        arr[i] = uni_rand(random);
    }

    start = high_resolution_clock::now();
    scan(arr, arr, n);
    end = high_resolution_clock::now();

    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << duration_sec.count() << endl;
    cout << arr[0] << endl;
    cout << arr[n - 1] << endl;

    return 0;
}