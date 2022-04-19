FROM python:3.10.4-bullseye
LABEL description="Robot Framework in docker image with some robot libraries"

# Set the reports directory environment variable
ENV ROBOT_REPORTS_DIR /opt/robotframework/reports

# Set the tests directory environment variable
ENV ROBOT_TESTS_DIR /opt/robotframework/tests

# Setup the timezone to use, defaults to UTC
ENV TZ UTC

# Define the default user who'll run the tests
ENV ROBOT_UID 1000
ENV ROBOT_GID 1000

# RUN apk update \
#     && apk --no-cache upgrade \
#     && apk --no-cache --virtual .build-deps add \
#     # Continue with system dependencies
#     gcc \
#     g++ \
#     libffi-dev \
#     linux-headers \
#     make \
#     musl-dev \
#     openssl-dev \
#     which \
#     wget \
#     git
#RUN apt-get update && apt install git


# Don't build rust bindings for cryptography (would fail for armv7)
# This flag is only recognized up to cryptography==3.4.8!
#    cryptography==3.4.8  \

#ENV CRYPTOGRAPHY_DONT_BUILD_RUST 1
RUN pip3 install --no-cache-dir \
    robotframework==4.1.3 \
    git+https://github.com/ci4rail/SSHLibrary.git@57f25955a73e213a55d2e0e713da54a260a843ca \
    robotframework-pabot==1.11.0 \
    robotframework-mqttlibrary==0.7.1.post3 \
    tinkerforge==2.1.28 \
    paho-mqtt==1.5.1 \
    pyyaml==6.0 

RUN TARGETPLATFORM 

RUN if [ ${TARGETPLATFORM} = "linux/arm/v7" ] ; then \
    cd /tmp \
    wget https://www.piwheels.org/simple/scipy/scipy-1.8.0-cp39-cp39-linux_armv7l.whl \
    pip install scipy-1.8.0-cp39-cp39-linux_armv7l.whl \
    else \
    pip3 install --no-cache-dir scipy==1.8.0 ; \
    fi

RUN pip3 install --no-cache-dir  pandas==1.4.2

# Create the default report and work folders with the default user to avoid runtime issues
# These folders are writeable by anyone, to ensure the user can be changed on the command line.
RUN mkdir -p ${ROBOT_REPORTS_DIR} \
    && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_REPORTS_DIR} 

# Allow any user to write logs
RUN chmod ugo+w /var/log \
    && chown ${ROBOT_UID}:${ROBOT_GID} /var/log

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

USER ${ROBOT_UID}:${ROBOT_GID}

WORKDIR ${ROBOT_TESTS_DIR}
ENTRYPOINT [ "/usr/local/bin/robot" ]
CMD [ "--help" ]
