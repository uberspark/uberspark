#!/usr/bin/env sh

# This script is meant to be sourced from within the Dockerfile to pass in vars.

echo "archive_name: $archive_name"

archive_string_len=${#archive_name}

echo "archive_string_len: $archive_string_len"

archive_dir=$(echo $archive_name | awk -v var=$archive_string_len '{ string=substr($0, 1, var - 4); print string; }' ) &&\

echo "archive_dir: $archive_dir"

cd $archive_dir

echo "PATH: $PATH"

su ubuntu

echo "PATH before mod: $PATH"

echo "PATH=/home/ubuntu/.opam/4.05.0/bin:$PATH" >> /home/ubuntu/.bashrc

PATH=/home/ubuntu/.opam/4.05.0/bin:$PATH
echo "PATH after mod: $PATH"

./configure x86_32-linux
make -j4 all
make install
