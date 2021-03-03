FROM alpine:3.13 AS get_sources
RUN apk update && apk upgrade && \
    apk add --no-cache git
ARG ROBOTFRAMEWORK_VERSION
ENV ROBOTFRAMEWORK_VERSION=${ROBOTFRAMEWORK_VERSION}


RUN mkdir -p /source && cd /source && \
    if [ -z "${ROBOTFRAMEWORK_VERSION}" ]; then \
    echo Cloning master branch; \
    git clone -b master --depth 1 https://github.com/robotframework/robotframework.git; \
    else \
    echo Cloning branch ${ROBOTFRAMEWORK_VERSION}; \
    git clone -b ${ROBOTFRAMEWORK_VERSION} --depth 1 https://github.com/robotframework/robotframework.git; \
    fi #redo

FROM python:3.9.2-alpine3.13
LABEL description="Robot Framework in an alpine based Python 3 docker image"
COPY --from=get_sources /source/robotframework /source/
RUN cd /source/ && python setup.py install && cd / && rm -rf /source
# Dependency versions
ENV AXE_SELENIUM_LIBRARY_VERSION 2.1.6
ENV DATABASE_LIBRARY_VERSION 1.2
ENV DATADRIVER_VERSION 1.0.0
ENV DATETIMETZ_VERSION 1.0.6
ENV FAKER_VERSION 5.0.0
ENV FTP_LIBRARY_VERSION 1.9
ENV IMAP_LIBRARY_VERSION 0.3.8
ENV PABOT_VERSION 1.10.0
ENV REQUESTS_VERSION 0.8.0
ENV SELENIUM_LIBRARY_VERSION 4.5.0
ENV SSH_LIBRARY_VERSION 3.5.1
RUN apk update \
    && apk --no-cache upgrade \
    && apk --no-cache --virtual .build-deps add \
    # Install dependencies for cryptography due to https://github.com/pyca/cryptography/issues/5771
    cargo \
    rust \
    # Continue with system dependencies
    gcc \
    g++ \
    libffi-dev \
    linux-headers \
    make \
    musl-dev \
    openssl-dev \
    which \
    wget \
    && pip3 install \
    --no-cache-dir \
    robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
    robotframework-datadriver==$DATADRIVER_VERSION \
    robotframework-datadriver[XLS] \
    robotframework-datetime-tz==$DATETIMETZ_VERSION \
    robotframework-faker==$FAKER_VERSION \
    robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
    robotframework-imaplibrary2==$IMAP_LIBRARY_VERSION \
    robotframework-pabot==$PABOT_VERSION \
    robotframework-requests==$REQUESTS_VERSION \
    robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
    robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
    axe-selenium-python==$AXE_SELENIUM_LIBRARY_VERSION \
    PyYAML \
    # Clean up buildtime dependencies
    && apk del --no-cache --update-cache .build-deps
ENTRYPOINT [ "/usr/local/bin/robot" ]
CMD [ "--help" ]