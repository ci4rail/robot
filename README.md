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
- pyvisa
- easy-scpi

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

Note: if the image build fails with wrong hashes for a package, retry on a server with a good network connection. It seems that the error is caused by network issues during download of the package:

```
ERROR: THESE PACKAGES DO NOT MATCH THE HASHES FROM THE REQUIREMENTS FILE. If you have updated the package versions, please update the hashes. Otherwise, examine the package contents carefully; someone may have tampered with them. 207.9 pandas==1.4.2 from https://archive1.piwheels.org/simple/pandas/pandas-1.4.2-cp39-cp39-linux_armv7l.whl#sha256=cc455ba74ca8442f70e48f2c70628b2281e5b345864bf5f1d90b20e7135d7007: 207.9 Expected sha256 cc455ba74ca8442f70e48f2c70628b2281e5b345864bf5f1d90b20e7135d7007 207.9 Got 1a7c13876750a0b029b280da69e3552e78127225a7e1d45140b52e5e001f78ca
```
