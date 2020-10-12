#!/bin/bash

# author: Amit Vasudevan <amitvasudevan@acm.org>

# turn off command echo, set to -x when debugging
set +x

to_obj=false
output_file=
include_dirs=

while getopts ":I:co:" opt; do
  case ${opt} in
    I )
      include_dirs="${include_dirs} -I ${OPTARG}"
      ;;
    c )
      toobj=true
      ;;
    o )
      output_file=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

echo to_obj=$to_obj
echo output_file=$output_file
echo include_dirs=$include_dirs
