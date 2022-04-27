# robot

[robot](http://robotframework.org/) in an official Python 3 debian based docker container and a few additional robot libraries installed:
- sshlibrary
- mqttlibrary
- pabot
- pyyaml
- tinkerforge
- numpy
- scipy
- pandas
- matplotlib

# Docker image build
## Automated build

The image is automatically build by a github workflow on push to main.

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
