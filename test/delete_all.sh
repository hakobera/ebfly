#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/common.sh

for ss in $SOLUTION_STACKS
do
  bundle exec ./bin/ebfly env delete $ss -a ebfly-test
done

bundle exec ./bin/ebfly app delete ebfly-test
