Answer to Q5:

1. It starts from the current folder of the Slurm bash file.
2. The `SLURM_JOB_ID` is the job id of this Slurm when we start it.
3. We can use `squeue -u {username}` to track a job list that launched by ourselves. Contents include job id, partition, job name, user name, status, running time, nodes, node list.
4. If we want to cancel a specific job with its job it, we can use `scancel {jobid}`. If we want to cancel all jobs launched by ourselves, we can use `scancel -u {username}`.
5. In this header line, we request a generic resource, and the type of this resource is `gpu`, the number of this type of resources is 1.
6. It submits a job array 10 times, multiple jobs would be executed with identical parameters.