# Running a Jupyter server on a spark cluster

1. Launch a spark cluster (tested using flintrock with the Amazon Linux 2 AMI)
2. SSH into the master node using the command `ssh -L 8888:localhost:8888 <remote_user>@<remote_host>` (the port 8888 can be whatever is available)
