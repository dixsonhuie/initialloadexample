#!/usr/bin/env bash

PROJ_DIR="/home/ubuntu/deploy/initialloadexample/stateful-with-db"

export GS_LOOKUP_LOCATORS="localhost:4174"
export GS_LOOKUP_GROUPS="xap-16.2.1"


#java -Xms1g -Xmx1g -jar $PROJ_DIR/feeder/target/feeder-0.1-jar-with-dependencies.jar \
#  -spaceName demo -numThreads 4 -sleepInterval 5000 \
#  -writeChunkSize 5000 \
#  -maxObjects 524288000 \
#  -numberOfSites 3 \
#  -site 1


nohup java -Xms1g -Xmx1g -jar $PROJ_DIR/feeder/target/feeder-0.1-jar-with-dependencies.jar \
  -spaceName demo -numThreads 3 -sleepInterval 5 \
  -writeChunkSize 10000 \
  -maxObjects 7000000 \
  -numberOfPartitions 1 \
  -partitionId 1 \
>/tmp/feeder.log 2>&1 &


#  -startId 1553310 \
