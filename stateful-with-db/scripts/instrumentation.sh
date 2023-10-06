#!/usr/bin/env bash

set -x
PROJ_DIR="/home/ubuntu/deploy/initialloadexample/stateful-with-db"


JAR_FILE="$PROJ_DIR/instrumentation/target/instrumentation-0.1-jar-with-dependencies.jar"

java -Xms1g -Xmx1g -javaagent:$JAR_FILE  -jar $JAR_FILE
