#!/usr/bin/env bash


set -e


source ./my-app-env.sh

HOSTNAME="$(hostname)"

if [ "$COMMAND_HOST" == "$HOSTNAME" ]; then
  echo "Building services (processing units)..."
  ./build.sh

  echo "Finished mvn."
fi

echo "starting grid components..."

#./demo-db/run.sh &> hsqldb.out &
#HSQL_PID=$!
#echo "Started HSQL DB [pid = $HSQL_PID , log = $(pwd)/hsqldb.out]"

#echo "Creating container for mirror service (processing unit)..."
#../gs.sh container create --zone=mirror --memory=256m localhost
#echo "Creating $SPACE_INSTANCES containers for space service (processing unit)..."
#../gs.sh container create --count=$SPACE_INSTANCES --zone=space --memory=512m localhost

# start service grid for space

IS_MANAGER="false"


HOSTS=$(echo $GS_MANAGER_SERVERS | tr "," "\n")

for HOST in $HOSTS; do
  if [ "$HOST" == "$HOSTNAME" ]; then
    IS_MANAGER="true"
  fi
done

if [ "true" == "$IS_MANAGER" ]; then
  export GS_GSC_OPTIONS="$BASE_GS_GSC_OPTIONS $SPACE_GS_GSC_OPTIONS"
  nohup $GS_HOME/bin/gs.sh host run-agent --manager --gsc=$NUM_SPACE_GSC_PER_SERVER > /tmp/grid-console.log 2>&1 &
else
  export GS_GSC_OPTIONS="$BASE_GS_GSC_OPTIONS $SPACE_GS_GSC_OPTIONS"
  nohup $GS_HOME/bin/gs.sh host run-agent           --gsc=$NUM_SPACE_GSC_PER_SERVER > /tmp/grid-console.log 2>&1 &
fi

if [ "$COMMAND_HOST" == "$HOSTNAME" ]; then
  # start gsc for mirror
  export GS_GSC_OPTIONS="$BASE_GS_GSC_OPTIONS $MIRROR_GS_GSC_OPTIONS"
  nohup $GS_HOME/bin/gs.sh host run-agent           --gsc=1 > /tmp/mirror-console.log 2>&1 &
fi


if [ "$COMMAND_HOST" == "$HOSTNAME" ]; then
  echo "sleep..."
  sleep 30s
  echo "Deploying services (processing units)..."
  ./deploy.sh
else
  echo "Running on the second or third node. Skipping deployment.";
fi


echo "Demo start completed."
