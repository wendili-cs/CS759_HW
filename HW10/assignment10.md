# Task 2
## (d)
There is much latency in MPI transmission between two different machines. Even `n` is 10^7 range, there is too much difference so that the total time in OpenMP + MPI still seems to be larger than pure OpenMP. I test `n` in 10^8 and 10^9 range, and find only in such a large level, we can see significant improvment in OpenMP + MPI. The results are shown in the table below.

| Method | Array Length | Time (ms)|
|---| ----- | ------- |
|OpenMP+MPI|10^8|8.6633|
|OpenMP|10^8|15.0731|
|OpenMP+MPI|10^9|70.7029|
|OpenMP|10^9|133.458|

So to conclude, if the array size is small (several kilobytes), we can choose pure OpenMP, because in MPI the latency between different computing nodes is relative large in such a case. If the array size is extremely large (several gigabytes), we can combine OpenMP with MPI. At this time, the latency is just a small cost compared to the large data processing time.