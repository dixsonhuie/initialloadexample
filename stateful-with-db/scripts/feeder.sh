#!/usr/bin/env bash

set -x

PROJ_DIR="/home/ubuntu/deploy/initialloadexample/stateful-with-db"

export GS_LOOKUP_LOCATORS="localhost:4174"
export GS_LOOKUP_GROUPS="xap-16.2.1"

java -jar $PROJ_DIR/feeder/target/feeder-0.1-jar-with-dependencies.jar \
  --max_objects=7000000

