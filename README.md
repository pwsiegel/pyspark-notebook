# Running a Jupyter server on a spark cluster

This is a handy collection of bash scripts aimed at simplifying the process of connecting to a Spark cluster with Jupyter.
It is tested with Spark clusters on AWS EC2 running the Amazon Linux 2 AMI, launched using [Flintrock][1].
There are three scripts each of which accomplishes a specific task.

## Configure the OS: `setup-sparknb.sh`

This script installs `jupyterlab`, `pyspark`, `pandas`, and all dependencies (including Python3 and its dependencies).
It uses [Pyenv][2] to make things easier to manage and to keep the system version of Python clean.
It also installs npm and nodejs in case you would like to install `jupyterlab` extensions.

One option is to run the script on the Spark master node once the cluster has been launched, though unless you also install Python3 on the worker nodes you will have a mismatch between Python versions and you may find that RDD's and UDF's will error out.
Instead, it is better to run this script on a clean EC2-instance, create an image, and use the AMI ID of that image in your Flintrock config file.
You may need to delete the file `~/.ssh/authorized_keys` before creating the image to avoid errors when launching Spark clusters with Flintrock.

## SSH into the master node: `flintrock-sparknb.sh`

The strategy for connecting to your Spark cluster via Jupyter is to use SSH port forwarding to connect a port on your local machine to a port on the Spark master, and then run a Jupyter server on the master node over the chosen port.
The command `flintrock login` doesn't support port forwarding at the moment, hence the need for this script.
Example syntax:

`./flintrock-sparknb.sh my-flintrock-cluster-name 8888`

This command assumes that you have already launched a Spark cluster using Flintrock called `my-flintrock-cluster-name` and that you wish to run and connect to the Jupyter server on port 8888.
This script is meant to be used on your local machine; you may find it convenient to create a symlink to this script somewhere on your PATH.

## Run the notebook server: `run-sparknb.sh`

Once you have launched a Spark cluster using an AMI that has `jupyterlab` installed (using `setup-sparknb.sh` or otherwise) and once you have logged into the master node using SSH port forwarding (using `flintrock-sparknb.sh` or otherwise), run this script using the syntax:

`./run-sparknb.sh 8888`

(Replace `8888` with whatever remote port you forwarded to.)
If all is well, you should see output which looks like:

```
    To access the notebook, open this file in a browser:
        file:///run/user/1000/jupyter/nbserver-<some-number>-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/?token=<some-token>
```

Copy and paste the `localhost` URL into a browser, and if all goes well you will be able to access the Jupyter server running on the master node.
In any notebook that you create on this server you will have access to two privileged variables: a `SparkContext` called `sc` and a `SparkSession` called `spark` - you can use the former to create Spark RDD's and the latter to create Spark DataFrames.

Some tips:
1. Check the arguments being passed to `pyspark` in this script before running it.  For instance, the default value `--executor-memory 220G` assumes that you are running your Spark cluster on instances with over 220G of memory, which may or may not be correct.
2. You might want to run this script in a screen session in case your SSH connection dies.  Be warned: if your connection dies or if you close the Jupyter tab in your browser then any jobs you are running will complete but you will lose the output even when you reconnect to the server and reopen your notebook.  For long-running jobs it is best to write the output of the computation to your disk or to S3 in the same cell that initiates the computation so that you can reload the output when you reconnect.
3. If you would like to use a RDD transformation or UDF which requires a special Python dependency, you should be able to install it using `flintrock run-command pip install my-package`.  This of course assumes that Python and `pip` have been installed on all of the workers as well as the master.

[1]: https://github.com/nchammas/flintrock
[2]: https://github.com/pyenv/pyenv
