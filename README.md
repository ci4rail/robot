# robot

![Create Release](https://github.com/siredmar/robot/workflows/Create%20Release/badge.svg?branch=master)

[robot](http://robotframework.org/) in an [unofficial Python 3](https://hub.docker.com/_/python?tab=description) alpine based docker container.

### Why?

1. To run tests in an environment that is well isolated from the host
2. To get started fast when prototyping/developing own Robot Framework libraries
3. To be able to take Robot Framework into use where `sudo` is not available

# Docker image build
## Automated build

The image is automatically build by docker: See https://docs.docker.com/docker-hub/builds/

## Local test builds
Example:
```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1
$ docker buildx build --platform linux/arm/v7  --build-arg ROBOTFRAMEWORK_VERSION=v4.0b3 -t ci4rail/robot .
```