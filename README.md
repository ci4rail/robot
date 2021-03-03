# robot

[robot](http://robotframework.org/) in an [unofficial Python 3](https://hub.docker.com/_/python?tab=description) alpine based docker container and many additional robot libraries installed.

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