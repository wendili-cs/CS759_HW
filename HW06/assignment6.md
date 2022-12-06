# Task 1
## (a)
* Level-1 functions perform scalar and vector-based operations.
* Level-2 functions perform matrix-vector operations.
* Level-3 functions perform matrix-matrix operations.

Therefore, I think they group functions based on the input parameters scale. For parameters with smaller scale (scalars, vectors), they are grouped into lower levels. For parameters that require large amount of interactions (matrix-matrix), they are grouped into higher levels.

## (b)
For two examples:
1. `cublas<t>gbmv()` is a function to perform the banded matrix-vector multiplication, which needs specified size of number of rows and columns of the matrix, as well as it assumes the matrix should be banded. Extra optimizations can be added under the assumption that the matrix is sparse.
2. `cublas<t>symv()` is a function to perform the symmetric matrix-vector multiplication. It assumes that the matrix is symmetric. Under this assumption, it says that the function can has an alternate faster implementation using atomics that can be enabled with `cublasSetAtomicsMode()`.

## (f)
The `cuBLAS`-based function runs much faster than tiled matrix multiplication in HW05. I think it is because that `cuBLAS` has many optimization steps compared to our own tiled matrix multiplication, such as insturction-level parallelization, avoiding bank conflicts.

# Task 2
## (c)
The output after command `cuda-memcheck ./task2 1024 1024`:
```
-41.5935
5.31843
========= CUDA-MEMCHECK
========= This tool is deprecated and will be removed in a future release of the CUDA toolkit
========= Please use the compute-sanitizer tool as a drop-in replacement
========= ERROR SUMMARY: 0 errors
```