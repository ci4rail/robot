#!/bin/bash
#
# Helper to run the robot container similar to the "robot" command 
# Example:
# robot-run -t "My Test" type-tests/testcases

set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

# pass local user to robot
export ROBOT_TC_USER=${USER}

# pass local IP address to robot
export ROBOT_TC_IP=$(/sbin/ifconfig eth0 | grep -i mask | awk '{print $2}'| cut -f2 -d:)

# pass all ROBOT_* and REBOT_* environment variables to image 
env_file=`mktemp`
function finish {
  rm -rf ${env_file}
}
trap finish EXIT
(env | grep ^R[OE]BOT_.*= > ${env_file} ) || :

image=ci4rail/robot:latest
docker run -v=`pwd`:/opt/robotframework/tests:Z --env-file ${env_file} -u `id -u` -t ${image} "${@}"
