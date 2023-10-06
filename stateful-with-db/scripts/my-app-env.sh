#!/usr/bin/env bash

export MULTI_SERVER="false"
export TIERED_STORAGE="false"
export CLEAN_WORK_DIR="true"

if [ "$MULTI_SERVER" == "true" ]; then
  export SPACE_PARTITIONS="3"
else
  export SPACE_PARTITIONS="1"
fi

export SPACE_HA="true"

export MAX_INSTANCES_PER_MACHINE="1"

#if [ ${SPACE_HA} = true ]; then
#    export SPACE_INSTANCES=$((${SPACE_PARTITIONS}*2))
#else
#    export SPACE_INSTANCES=${SPACE_PARTITIONS}
#fi


export GS_HOME="/home/ubuntu/gigaspaces-xap-enterprise-16.2.1"
export GS_CLI_VERBOSE="true"

if [ "$MULTI_SERVER" == "true" ]; then
  export GS_MANAGER_SERVERS="ip-172-31-0-44,ip-172-31-1-56,ip-172-31-13-91"
else
  export GS_MANAGER_SERVERS="localhost";
fi

export COMMAND_HOST="ip-172-31-0-44"

#export GS_NIC_ADDRESS=$(hostname -i)

export BASE_GS_GSC_OPTIONS="-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

export GS_OPTIONS_EXT="-Dcom.gs.work=/data/work"

export GS_MANAGER_OPTIONS="-Xms1g -Xmx1g"
export GS_GSA_OPTIONS="-Xms512m -Xmx512m"
export GS_WEBUI_OPTIONS="-Xms1g -Xmx1g"
export GS_CLI_OPTIONS="-Xms512m -Xmx512m"

export SPACE_GS_GSC_OPTIONS="-Dcom.gs.zones=space -Xms25g -Xmx25g"
export MIRROR_GS_GSC_OPTIONS="-Dcom.gs.zones=mirror -Xms1g -Xmx1g"

function display_env_vars() {
  echo "Displaying environment variables:"
  echo "GS_HOME is $GS_HOME"
  echo "GS_MANAGER_SERVERS is $GS_MANAGER_SERVERS"
  echo "COMMAND_HOST is $COMMAND_HOST"
  #echo "GS_NIC_ADDRESS is $GS_NIC_ADDRESS"
  echo "MULTI_SERVER is $MULTI_SERVER"
  echo "TIERED_STORAGE is $TIERED_STORAGE"
  echo "CLEAN_WORK_DIR is $CLEAN_WORK_DIR"
  echo "SPACE_PARTITIONS is $SPACE_PARTITIONS"
  echo "SPACE_HA is $SPACE_HA"
  echo "MAX_INSTANCES_PER_MACHINE is $MAX_INSTANCES_PER_MACHINE"
  echo "GS_OPTIONS_EXT is $GS_OPTIONS_EXT"
  echo "BASE_GS_GSC_OPTIONS is $BASE_GS_GSC_OPTIONS"
  echo "GS_MANAGER_OPTIONS is $GS_MANAGER_OPTIONS"
  echo "GS_GSA_OPTIONS is $GS_GSA_OPTIONS"
  echo "GS_WEBUI_OPTIONS is $GS_WEBUI_OPTIONS"
  echo "GS_CLI_OPTIONS is $GS_CLI_OPTIONS"
}

#display_env_vars
