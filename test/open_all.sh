#!/bin/bash

for ss in docker09 docker10 docker13 nodejs php54 php55 python26 python27 ruby19 ruby20 ruby20-puma ruby21 ruby21-puma
do
  echo "Open $ss"
  bundle exec ./bin/ebfly env open $ss -a ebfly-test
done
