#!/bin/bash

./bin/ebfly app create ebfly-test

for ss in docker09 docker10 nodejs php54 php55 python26 python27 ruby19 ruby20 ruby20-puma
do
  ./bin/ebfly env create $ss -s $ss -a ebfly-test
done
