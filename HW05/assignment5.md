# Task 2
## d
It turns out that `block_dim=32` would be the best choice. When `block_dim` gets smaller, the computing time will become much larger as `n` gets larger.

## e
For `int` and `float`, the performances are almost the same. But for `double`, it seems to have a constant factor (4) longer than `int` and `float`. I think the reason is that `double` is two times larger than `int` and `float`, which makes the block size larger (2x), and the matrix size its square (4x), so the computing time is also 4 times larger.

## f
The runtime for `n=2**14` from tiled `matmul` in HW05 is 9,015.48 ms, while the runtime from naive `matmul` in HW04 is 96,916.6 ms. By using tiled `matmul`, it has more than `10x` faster than naive `matmul`.

## g
The estimated runtime for `mmul1` in HW02 would be 2,144,535.04 ms, which is much longer than running it on GPU. The performance is 22x times lower than naive `matmul`, and 200x times lower than tiled `matmul`. This is because the total threads in GPU are much higher than it is in the CPU. So the parallel operating ability of GPU is much better than CPU.