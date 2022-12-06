# 相关的常用指令
It is just a note for myself.
## slurm相关
1. 查看job的状态：
```
squeue -u wli548
```
2. 删除在队列中的job：
    * `scancel [jobid]` to cancel a specific job, 
    * `scancel -u [username]` to cancel all jobs launched by you.
3. 执行一个slurm的bash脚本：
```
sbatch xxx.sh
```

## C++相关
1. 编译一个cpp文件
```
g++ xxx.cpp -Wall -O3 -std=c++17 -o xxx
```
2. 执行一个当前目录下编译好了的文件（带传入参数N）
```
./xxx N
```
3. 用clang-format格式化代码
```
clang-format -i *.cpp
clang-format -i *.cu
```