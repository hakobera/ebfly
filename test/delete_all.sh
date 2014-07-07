#!/bin/bash

for ss in docker09 docker10 nodejs php54 php55 python26 python27 ruby19 ruby20 ruby20-puma
do
  ./bin/ebfly env delete $ss -a ebfly-test
done

./bin/ebfly app delete ebfly-test
