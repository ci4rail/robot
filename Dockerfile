# Inspired by https://github.com/ppodgorsek/docker-robot-framework/blob/master/Dockerfile
FROM siredmar/robot:v4.0b3
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

RUN apk update \
    && apk --no-cache upgrade \
    && apk --no-cache --virtual .build-deps add \
    # Continue with system dependencies
    gcc \
    g++ \
    libffi-dev \
    linux-headers \
    make \
    musl-dev \
    openssl-dev \
    which \
    wget

# Don't build rust bindings for cryptography (would fail for armv7)
ENV CRYPTOGRAPHY_DONT_BUILD_RUST 1
RUN pip3 install --no-cache-dir robotframework-sshlibrary==3.5.1

RUN pip3 install --no-cache-dir robotframework-pabot==1.10.0
RUN pip3 install --no-cache-dir tinkerforge==2.1.28
RUN pip3 install PyYAML

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