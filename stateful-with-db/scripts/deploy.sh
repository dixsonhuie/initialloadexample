#!/usr/bin/env bash

set -x

. ./my-app-env.sh

HOSTNAME="$(hostname)"

if [ "ip-172-31-0-44" == "$HOSTNAME" ]; then 

  if [ "true" == "$SPACE_HA" ]; then 
    echo "Deploying space with ha..."
    if [ "true" == "$MULTI_SERVER" ]; then
      $GS_HOME/bin/gs.sh pu deploy --properties=my-app-values.yaml --zones=space --partitions=${SPACE_PARTITIONS} --ha --max-instances-per-machine=1 space ../target/space-0.1.jar
    else
      $GS_HOME/bin/gs.sh pu deploy --properties=my-app-values.yaml --zones=space --partitions=${SPACE_PARTITIONS} --ha space ../target/space-0.1.jar
    fi
  else
    echo "Deploying space..."
    $GS_HOME/bin/gs.sh pu deploy --properties=my-app-values.yaml --zones=space --partitions=${SPACE_PARTITIONS}      space ../target/space-0.1.jar
  fi

  echo "Deploying mirror..."
  $GS_HOME/bin/gs.sh pu deploy --properties=my-app-values.yaml \
    --zones=mirror --instances=1 -property=space.partitions=${SPACE_PARTITIONS} \
    mirror ../target/mirror-0.1.jar

else
  echo "Running on the second or third node. Skipping deployment.";
fi

set +x
