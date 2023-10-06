#!/usr/bin/env bash


set -e


source ./my-app-env.sh

HOSTNAME="$(hostname)"

nohup $GS_HOME/bin/gs-webui.sh > /tmp/webui-console.log 2>&1 &

