#!/usr/bin/env bash

# show command as it is run
set -x
# exit on error
set -e

USER="$(id -u)"

if [ "0" != "$USER" ]; then
  echo "This script should be run as root. Exiting."
  exit
fi

#lsblk
CMD_OUTPUT="$(file -s /dev/nvme1n1)"

echo "$CMD_OUTPUT"

if [ "/dev/nvme1n1: data" = "$CMD_OUTPUT" ]; then
  echo "No file system present on /dev/nvme1n1."
  echo "Creating file system..."
  mkfs -t xfs /dev/nvme1n1
fi

if [ ! -d "/data" ]; then
  mkdir /data
fi

mount /dev/nvme1n1 /data
mkdir /data/work
chown ubuntu:ubuntu /data/work
