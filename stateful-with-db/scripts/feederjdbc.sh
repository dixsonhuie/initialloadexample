#!/usr/bin/env bash

set -x
PROJ_DIR="/home/ubuntu/deploy/initialloadexample/stateful-with-db"


CLASSPATH="$PROJ_DIR/instrumentation/target/classes"
CLASSPATH="$PROJ_DIR/instrumentation/target/lib/*:$CLASSPATH"

nohup java -Xms1g -Xmx1g -cp $CLASSPATH com.mycompany.app.FeederJdbc >/tmp/feederjdbc.log 2>&1 &
