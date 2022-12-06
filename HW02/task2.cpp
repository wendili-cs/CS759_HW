#include "convolution.h"
#include <chrono>
#include <iostream>
#include <random>

using std::atoi;
using std::cout;
using std::endl;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

void print_matrix(float *mat, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            int idx = i * cols + j;
            cout << mat[idx] << " ";
        }
        cout << endl;
    }
}

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]), m = atoi(argv[2]);
    float image[n][n], mask[m][m], out[n][n];

    // initialize random function
    std::default_random_engine r1(0), r2(1);
    std::uniform_real_distribution<float> init_image(-10.0, 10.0);
    std::uniform_real_distribution<float> init_mask(-1.0, 1.0);

    // init mask
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < m; j++) {
            mask[i][j] = init_mask(r1);
        }
    }

    // init image
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            image[i][j] = init_image(r2);
        }
    }

    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;

    start = high_resolution_clock::now();
    // print_matrix((float*)image, n, n);
    convolve((float *)mask, (float *)out, n, (float *)image, m);
    // print_matrix((float*)out, n, n);
    end = high_resolution_clock::now();

    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << duration_sec.count() << endl;

    cout << out[0][0] << endl;
    cout << out[n - 1][n - 1] << endl;

    return 0;
}