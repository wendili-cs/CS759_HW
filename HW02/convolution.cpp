#include "convolution.h"
#include <cstddef>

using std::size_t;

void convolve(const float *w, float *g, std::size_t n, const float *f,
              std::size_t m) {
    for (size_t x = 0; x < n; x++) {
        for (size_t y = 0; y < n; y++) {
            int idx = x * n + y;
            g[idx] = 0.0;
            for (size_t i = 0; i < m; i++) {
                for (size_t j = 0; j < m; j++) {
                    size_t frow = x + i - (m - 1) / 2,
                           fcol = y + j - (m - 1) / 2;
                    bool is_frow_avail = 0 <= frow && frow < n;
                    bool is_fcol_avail = 0 <= fcol && fcol < n;
                    float fval;
                    if (!is_frow_avail && !is_fcol_avail)
                        fval = 0.0;
                    else if (!is_frow_avail || !is_fcol_avail)
                        fval = 1.0;
                    else
                        fval = f[frow * n + fcol];
                    g[idx] += w[i * m + j] * fval;
                }
            }
        }
    }
}