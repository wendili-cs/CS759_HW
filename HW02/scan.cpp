#include <cstddef>

using std::size_t;

// void scan(float arr[], int size, float (*f)(float &, float &), float ret[]) {
//     for (int i = 0; i < size; i++) {
//         ret[i] = i == 0 ? arr[i] : f(ret[i - 1], arr[i]);
//     }
//     return;
// }

void scan(const float *arr, float ret[], std::size_t n) {
    for (size_t i = 0; i < n; i++) {
        ret[i] = i == 0 ? arr[i] : ret[i - 1] + arr[i];
    }
    return;
}