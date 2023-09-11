#!/usr/bin/env bash


source ./my-app-env.sh

set -x

echo "Undeploying services (processing units)..."

$GS_HOME/bin/gs.sh pu undeploy --drain-mode=NONE space
$GS_HOME/bin/gs.sh pu undeploy --drain-mode=NONE mirror

set +x
