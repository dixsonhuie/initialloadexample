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
export GS_GSC_OPTIONS="$BASE_GS_GSC_OPTIONS $SPACE_GS_GSC_OPTIONS"
nohup $GS_HOME/bin/gs.sh host run-agent --manager --gsc=2 > /tmp/grid-console.log 2>&1 &

if [ "$COMMAND_HOST" == "$HOSTNAME" ]; then
  # start gsc for mirror
  export GS_GSC_OPTIONS="$BASE_GS_GSC_OPTIONS $MIRROR_GS_GSC_OPTIONS"
  nohup $GS_HOME/bin/gs.sh host run-agent --gsc=1 > /tmp/mirror-console.log 2>&1 &
fi

echo "sleep..."

sleep 30s

echo "Deploying services (processing units)..."
./deploy.sh

echo "Demo start completed."
