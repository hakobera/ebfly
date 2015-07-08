#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/common.sh

bundle exec ./bin/ebfly app create ebfly-test

for ss in $SOLUTION_STACKS
do
  echo ""
  bundle exec ./bin/ebfly env create $ss -s $ss -a ebfly-test
done
