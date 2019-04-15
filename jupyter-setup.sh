#!/bin/bash

sudo yum -y install git gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
git clone https://github.com/pyenv/pyenv.git "$HOME"/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME"/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME"/.bashrc
echo 'eval "$(pyenv init -)"' >> "$HOME"/.bashrc
source $"HOME"/.bashrc
pyenv install 3.7.2
pyenv global 3.7.2
pip install -r requirements.txt
