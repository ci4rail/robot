FROM python:3.9.12-bullseye
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

# libatlas contains libclas which is required by numpy/scipy
RUN apt-get update && apt-get install -y libatlas-base-dev

# piwheels.org hosts precompiled packages for armv7, currently only compatible with Python 3.9
RUN echo "[global]\nextra-index-url=https://www.piwheels.org/simple" > /etc/pip.conf

RUN cd /tmp && \
    cat /etc/pip.conf && \
    pip3 install --no-cache-dir \
    robotframework==4.1.3 \
    robotframework-pabot==1.11.0 \
    git+https://github.com/ci4rail/SSHLibrary.git@57f25955a73e213a55d2e0e713da54a260a843ca \
    robotframework-mqttlibrary==0.7.1.post3 \
    tinkerforge==2.1.28 \
    paho-mqtt==1.5.1 \
    pyyaml==6.0 \
    scipy==1.8.0 \
    pandas==1.4.2 


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
