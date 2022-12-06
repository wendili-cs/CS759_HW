# Task 1 (d)

Compare the `matmul` on `CUDA` scaling results with `scan` on CPU, I think there are two differences:

1. In `log2` scale, the plot of time-consuming and array length in `scan` on CPU is a straight line, while it in `matmul` on GPU is not a straight line when `n` is small, which means performing computing on GPU may have a constant-value burden (initialize GPU for computing, etc.). So for larger data scales, using GPU has higher benefits.
2. The number of threads in each block seems does not affect the computing time too much, but the number of threads used in the CPU may not. This is because GPU has many blocks so that even only a few threads in each block can also process the task with good parallelization.

# Task 2 (d)

Compare the `stencil` on `CUDA` scaling results with `scan` on CPU, I think:

1. The programs run on GPU can be much faster than CPU at the same scale, maybe a hundred times faster than that.
2. If the matrix length is small, the difference above is not so clear, as we need to copy data from main memory to GPU global memory, and from GPU global memory to GPU shared memory. So GPU computing is better to be used in large-scale cases.