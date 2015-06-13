#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/common.sh

for ss in $SOLUTION_STACKS
do
  echo "Open $ss"
  bundle exec ./bin/ebfly env open $ss -a ebfly-test
done
