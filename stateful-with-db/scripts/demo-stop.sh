#!/usr/bin/env bash

source ./my-app-env.sh


HOSTNAME="$(hostname)"

echo "HOSTNAME is $HOSTNAME"

if [ "$COMMAND_HOST" == "$HOSTNAME" ]; then
  ./undeploy.sh
  sleep 10
else
  echo "Running on second or third node. Skipping undeploy.";
fi


echo "Killing GSCs with zones space, mirror"
#../gs.sh container kill --zones=space,mirror

$GS_HOME/bin/gs.sh host kill-agent --all


#echo "Stopping HSQL DB..."
#./demo-db/shutdown.sh


PIDS=$(ps -ef | grep -v grep | grep java | awk '{print $2}' | wc -l)

if [ "$PIDS" -ne 0 ]; then
  sleep 10

  # check pids again
  PIDS=$(ps -ef | grep -v grep | grep java | awk '{print $2}' | wc -l)
  if [ "$PIDS" -ne 0 ]; then
    ps -ef | grep -v grep | grep java | awk '{print $2}' | xargs kill
  fi
fi

echo "Demo stop completed."
