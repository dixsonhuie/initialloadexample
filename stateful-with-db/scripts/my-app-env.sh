#!/usr/bin/env bash

# sla
export SPACE_PARTITIONS="1"

export SPACE_HA="true"

#export MAX_INSTANCES_PER_MACHINE="4"

# this value should be consistent with value in my-app-values.yaml file
export MIRRORED="true"

export COMMAND_HOST="ip-172-31-0-44"

# service grid
export MANAGER_HA="false"
if [ "$MANAGER_HA" == "true" ]; then
  export GS_MANAGER_SERVERS="ip-172-31-0-44,ip-172-31-1-56,ip-172-31-13-91"
else
  export GS_MANAGER_SERVERS="$COMMAND_HOST";
fi

export NUM_SPACE_GSC_PER_SERVER="2"

#export MEMORYXTEND="true"
export CLEAN_WORK_DIR="true"


export GS_HOME="/home/ubuntu/gigaspaces-xap-enterprise-16.2.1"
export GS_CLI_VERBOSE="true"


#export GS_NIC_ADDRESS=$(hostname -i)


#export GS_OPTIONS_EXT="-Dcom.gs.work=/data/work"

export GS_MANAGER_OPTIONS="-Xms1g -Xmx1g"
export GS_GSA_OPTIONS="-Xms512m -Xmx512m"
export GS_WEBUI_OPTIONS="-Xms1g -Xmx1g"
export GS_CLI_OPTIONS="-Xms512m -Xmx512m"

export BASE_GS_GSC_OPTIONS="-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

export SPACE_GS_GSC_OPTIONS="-Dcom.gs.zones=space -Xms12g -Xmx12g"
export MIRROR_GS_GSC_OPTIONS="-Dcom.gs.zones=mirror -Xms1g -Xmx1g"

function display_env_vars() {
  echo "Displaying environment variables:"
  echo "SPACE_PARTITIONS is $SPACE_PARTITIONS"
  echo "SPACE_HA is $SPACE_HA"
  echo "MAX_INSTANCES_PER_MACHINE is $MAX_INSTANCES_PER_MACHINE"
  echo "MANAGER_HA is $MANAGER_HA"
  echo "GS_MANAGER_SERVERS is $GS_MANAGER_SERVERS"
  echo "COMMAND_HOST is $COMMAND_HOST"
  #echo "GS_NIC_ADDRESS is $GS_NIC_ADDRESS"
  #echo "MEMORYXTEND is $MEMORYXTEND"
  echo "CLEAN_WORK_DIR is $CLEAN_WORK_DIR"
  echo "GS_HOME is $GS_HOME"
  echo "GS_CLI_VERBOSE is $GS_CLI_VERBOSE"
  echo "GS_OPTIONS_EXT is $GS_OPTIONS_EXT"
  echo "GS_MANAGER_OPTIONS is $GS_MANAGER_OPTIONS"
  echo "GS_GSA_OPTIONS is $GS_GSA_OPTIONS"
  echo "GS_WEBUI_OPTIONS is $GS_WEBUI_OPTIONS"
  echo "GS_CLI_OPTIONS is $GS_CLI_OPTIONS"
  echo "BASE_GS_GSC_OPTIONS is $BASE_GS_GSC_OPTIONS"
  echo "SPACE_GS_GSC_OPTIONS is $SPACE_GS_GSC_OPTIONS"
  echo "MIRROR_GS_GSC_OPTIONS is $MIRROR_GS_GSC_OPTIONS"
}

#display_env_vars
