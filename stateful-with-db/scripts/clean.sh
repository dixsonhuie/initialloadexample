#!/usr/bin/env bash

set -x

source ./my-app-env.sh

CWD="$(pwd)"

function get_work_dir() {
  if [ ! -z "$GS_OPTIONS_EXT" ]; then

    GS_OPTIONS=$(echo $GS_OPTIONS_EXT | tr " " "\n")

    for OPTION in $GS_OPTIONS; do
      #echo "OPTION is: $OPTION"
      # find the key value pair with com.gs.work in it
      WORK_DIR_IS_SET="$(echo "$OPTION" | grep "com.gs.work")"
      if [ ! -z "$WORK_DIR_IS_SET" ]; then
        WORK_DIR=$(echo "$OPTION" | awk -F= '{print $2}');
        echo "$WORK_DIR";
        return
      fi
    done
  fi  
  echo "$GS_HOME/work"
}


echo "$GS_HOME"

if [ -d "$GS_HOME/deploy" ]; then
  echo "Directory $GS_HOME/deploy exists"
  cd "$GS_HOME/deploy"
  DELETE_COUNT=$(ls | grep -v templates | wc -l)
  if [ "$DELETE_COUNT" -gt "0" ]; then
    cd "$GS_HOME/deploy" && ls | grep -v templates | xargs rm -r
  fi
fi


if [ -d "$GS_HOME/logs" ]; then
  echo "Directory $GS_HOME/logs exists"
  rm -r "$GS_HOME/logs/"
fi

if [ "true" == "$CLEAN_WORK_DIR" ]; then
  WORK_DIR="$(get_work_dir)"
  echo "work directory is: $WORK_DIR"

  if [ -d "$WORK_DIR" ]; then
    echo "Directory $WORK_DIR exists"
    rm -r $WORK_DIR/*
  fi
fi # clean work dir

cd "$CWD"

