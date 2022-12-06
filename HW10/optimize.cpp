#include "optimize.h"
#include <cstddef>
#include <iostream>

using std::cout, std::endl;

data_t *get_vec_start(vec *v) { return v->data; }

void optimize1(vec *v, data_t *dest) {
    int length = v->len;
    data_t *d = get_vec_start(v);
    data_t tmp = IDENT;
    for (int i = 0; i < length; i++) {
        tmp = tmp OP d[i];
    }
    *dest = tmp;
}

void optimize2(vec *v, data_t *dest) {
    int length = v->len, limit = length - 1;
    data_t *d = get_vec_start(v);
    data_t x = IDENT;
    int i;
    for (i = 0; i < limit; i += 2) {
        x = (x OP d[i])OP d[i + 1];
    }
    for (; i < length; i++) {
        x = x OP d[i];
    }
    *dest = x;
}

void optimize3(vec *v, data_t *dest) {
    int length = v->len, limit = length - 1;
    data_t *d = get_vec_start(v);
    data_t x = IDENT;
    int i;
    for (i = 0; i < limit; i += 2) {
        x = x OP(d[i] OP d[i + 1]);
    }
    for (; i < length; i++) {
        x = x OP d[i];
    }
    *dest = x;
}

void optimize4(vec *v, data_t *dest) {
    int length = v->len, limit = length - 1;
    data_t *d = get_vec_start(v);
    data_t x0 = IDENT, x1 = IDENT;
    int i;
    for (i = 0; i < limit; i += 2) {
        x0 = x0 OP d[i];
        x1 = x1 OP d[i + 1];
    }
    for (; i < length; i++) {
        x0 = x0 OP d[i];
    }
    *dest = x0 OP x1;
}

void optimize5(vec *v, data_t *dest) {
    int length = v->len, limit = length - 2, limit2 = length - 1;
    data_t *d = get_vec_start(v);
    data_t x0 = IDENT, x1 = IDENT, x2 = IDENT;
    int i;
    for (i = 0; i < limit; i += 3) {
        x0 = x0 OP d[i];
        x1 = x1 OP d[i + 1];
        x2 = x2 OP d[i + 2];
    }
    for (; i < limit2; i += 2) {
        x0 = x0 OP d[i];
        x1 = x1 OP d[i + 1];
    }
    for (; i < length; i++) {
        x0 = x0 OP d[i];
    }
    *dest = x0 OP x1 OP x2;
}