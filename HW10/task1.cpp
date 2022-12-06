#include "optimize.h"
#include <chrono>
#include <cstddef>
#include <iostream>
#include <random>

using std::cout, std::endl, std::atoi;
using std::chrono::duration;
using std::chrono::high_resolution_clock;

float eval(void (*f)(vec *, data_t *), vec *v, data_t *dest) {
    // initialize timer
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();

    // run the optimize function
    f(v, dest);

    // end timer
    end = high_resolution_clock::now();
    duration_sec =
        std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    return duration_sec.count();
}

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]);

    // initialize the arr of length n
    data_t val;
    data_t *dest = &val;
    vec *v = new vec(n);
    data_t *data = (data_t *)malloc(n * sizeof(data_t));
    for (int i = 0; i < n; i++) {
        data[i] = 1;
    }
    v->data = data;

    float time_cnt;

    // test optimize1
    time_cnt = eval(optimize1, v, dest);
    cout << *dest << endl;
    cout << time_cnt << endl;

    // test optimize2
    time_cnt = eval(optimize2, v, dest);
    cout << *dest << endl;
    cout << time_cnt << endl;

    // test optimize3
    time_cnt = eval(optimize3, v, dest);
    cout << *dest << endl;
    cout << time_cnt << endl;

    // test optimize4
    time_cnt = eval(optimize4, v, dest);
    cout << *dest << endl;
    cout << time_cnt << endl;

    // test optimize5
    time_cnt = eval(optimize5, v, dest);
    cout << *dest << endl;
    cout << time_cnt << endl;

    return 0;
}