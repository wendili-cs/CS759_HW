# Task 3

1. The point-to-point latency: 2.75 ms
    * This is when the array size is very small, the most time is converging to 5.5, which means the time for send & receive twice is 5.5 ms, so the latency is about 2.75 ms.
2. The point-to-point bandwidth: 500 MB/s
    * We can see when sending the largest data, which has `2**25` float data, whose size is `(2**25) * 4 (B) = 134,217,728 (B) = 134 (MB)`.
    * For the transferring time, it is 545 ms, so the time for transfering 134 MB data once would be roughly `270 (ms) = 0.27 (s)`.
    * Therefore, the bandwidth would be `134 (MB) / 0.27 (s) = 497 (MB/s) ~= 500 (MB/s)`.

According to the wiki (https://en.wikipedia.org/wiki/PCI_Express), the throughput rate matches PCIe V2.0 or PCIe V3.0. Maybe Euler runs two MPI program on different nodes, and PCIe V3.0 is the communication version.