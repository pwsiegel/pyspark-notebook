#!/bin/bash
set -eou pipefail

# Disclaimer: this has been tested on the Amazon Linux 2 AMI, and will likely error out in other environments.
# It assumes that you have already installed git; if this is incorrect, execute the command `sudo yum install -y git`.
# TODO: include limits.conf and bashrc, -N flag on ssh to port forward without ssh

# Install python dependencies
sudo yum -y install git gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils

# Install pyenv
git clone https://github.com/pyenv/pyenv.git "$HOME"/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME"/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME"/.bashrc
echo 'eval "$(pyenv init -)"' >> "$HOME"/.bashrc

# ~/.bashrc sources some stuff with unset variables...
set +u
source "$HOME"/.bashrc
set -u

# Install python 3.7.3 and dependencies
pyenv install 3.7.3
pyenv global 3.7.3
pip install -r requirements.txt

# Install node and npm for jupyter plugins
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
sudo yum install -y nodejs

# Install Jupyter plugins
jupyter labextension install @jupyterlab/plotly-extension
jupyter labextension install jupyterlab_vim

# Start a new shell (needed to make jupyter and other stuff work)
exec "$SHELL"
