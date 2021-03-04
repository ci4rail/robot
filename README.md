# robot

[robot](http://robotframework.org/) in an [unofficial Python 3](https://hub.docker.com/_/python?tab=description) alpine based docker container and a few additional robot libraries installed:
- sshlibrary
- pabot

# Docker image build
## Automated build

The image is automatically build by docker hub: [Repository on docker hub](https://hub.docker.com/repository/docker/ci4rail/robot)

The container is build for 
- linux/amd64
- linux/arm64/v8
- linux/arm/v7
    
## Local test builds
Example:
```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1
$ docker buildx build --platform linux/arm/v7 -t ci4rail/robot-armv7 .
```