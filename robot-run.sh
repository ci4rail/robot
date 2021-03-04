#!/bin/bash
#
# Helper to run the robot container similar to the "robot" command 
# Example:
# robot-run -t "My Test" type-tests/testcases

set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

image=ci4rail/robot:latest

docker run -v=`pwd`:/opt/robotframework/tests:Z -t ${image} "${@}"