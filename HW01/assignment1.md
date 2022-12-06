# Task 2
```bash
#!/usr/bin/env bash

echo -e "\n=====Q (a)====="
cd somedir

echo -e "\n=====Q (b)====="
cat sometext.txt

echo -e "\n=====Q (c)====="
head -n 5 sometext.txt

echo -e "\n=====Q (d)====="
tail -n 5 *.txt

echo -e "\n=====Q (e)====="
for i in {0..6}
do
    printf "$i\n"
done
```

# Task 3
Answer to Q3:

1. No, when I use `module list`, it shows that
```
No modules loaded
```

2. Output using `gcc --version`:
```
gcc (GCC) 12.1.1 20220507 (Red Hat 12.1.1-1)
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

3. Output using `module avail cuda`:
```
nvidia/cuda/10.2.2    nvidia/cuda/11.0.3    nvidia/cuda/11.3.1    nvidia/cuda/11.6.0 (D)
```

4. MATLAB is a programming and numeric computing platform. Output using `module avail matlab`:
```
matlab/r2021a    matlab/r2021b (D)
```

# Task 5
Answer to Q5:

1. It starts from the current folder of the Slurm bash file.
2. The `SLURM_JOB_ID` is the job id of this Slurm when we start it.
3. We can use `squeue -u {username}` to track a job list that launched by ourselves. Contents include job id, partition, job name, user name, status, running time, nodes, node list.
4. If we want to cancel a specific job with its job it, we can use `scancel {jobid}`. If we want to cancel all jobs launched by ourselves, we can use `scancel -u {username}`.
5. In this header line, we request a generic resource, and the type of this resource is `gpu`, the number of this type of resources is 1.
6. It submits a job array 10 times, multiple jobs would be executed with identical parameters.