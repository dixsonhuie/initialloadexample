#!/usr/bin/env bash

CWD="$(pwd)"

SCRIPT_DIR="`dirname \"$0\"`"
SCRIPT_DIR="`( cd \"$SCRIPT_DIR\" && pwd )`"

cd $SCRIPT_DIR/..

echo "current working directory is: `(pwd)`";

if [ -e target ]; then
    echo "Purging existing files from target..."
    rm -r target/
fi
mvn clean package
mkdir target
#if [ "$MEMORYXTEND" == "true" ]; then
#  mv space-tiered-storage/target/space-tiered-storage-0.1.jar target/
#else
  mv space/target/space-0.1.jar target/
#fi
mv mirror/target/mirror-0.1.jar target/

cd "$CWD"

sleep 5
