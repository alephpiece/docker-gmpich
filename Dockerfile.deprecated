# stage 1: build MPICH with GCC
ARG BASE_IMAGE="gcc"
ARG BASE_TAG="9.2.0"
ARG GCC_VERSION=latest
FROM ${BASE_IMAGE}:${BASE_TAG} AS builder

LABEL maintainer="Wang An <wangan.cs@gmail.com>"

USER root

# install basic buiding tools
RUN set -eu; \
      \
      apt-get update; \
      apt-get install -y \
              autoconf \
              automake \
              make \
              wget

# stage 1.1: download MPICH source
ARG MPICH_VERSION="3.2.1"
ENV MPICH_VERSION=${MPICH_VERSION}
ENV MPICH_TARBALL="mpich-${MPICH_VERSION}.tar.gz"

WORKDIR /tmp
RUN set -eux; \
      \
      # checksums are not provided due to the build-time arguments MPICH_VERSION
      wget "http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz"; \
      tar -xzf ${MPICH_TARBALL}

# stage 1.2: build and install MPICH
ARG MPICH_OPTIONS="--enable-shared"
ENV MPICH_OPTIONS=${MPICH_OPTIONS}
ENV MPICH_PREFIX="/opt/mpich/${MPICH_VERSION}"

WORKDIR /tmp/mpich-${MPICH_VERSION}
RUN set -eux; \
      \
      ./configure \
                  --prefix=${MPICH_PREFIX} \
                  ${MPICH_OPTIONS} \
      ; \
      make -j "$(nproc)"; \
      make install; \
      \
      rm -rf mpich-${MPICH_VERSION} ${MPICH_TARBALL}


# stage 2: build the runtime environment
ARG BASE_IMAGE
ARG BASE_TAG
FROM ${BASE_IMAGE}:${BASE_TAG}

USER root

# install mpi dependencies
RUN set -eu; \
      \
      apt-get update; \
      apt-get install -y \
              openssh-server \
              sudo

# define environment variables
ARG MPICH_VERSION="3.2.1"
ENV MPICH_VERSION=${MPICH_VERSION}
ENV MPICH_PATH="/opt/mpich/${MPICH_VERSION}"

# copy artifacts from stage 1
COPY --from=builder ${MPICH_PATH} ${MPICH_PATH}

# set environment variables for users
ENV PATH="${MPICH_PATH}/bin:${PATH}"
ENV CPATH="${MPICH_PATH}/include:${CPATH}"
ENV LIBRARY_PATH="${MPICH_PATH}/lib:${LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="${MPICH_PATH}/lib:${LD_LIBRARY_PATH}"

# define environment variables
ARG GROUP_NAME
ENV GROUP_NAME=${GROUP_NAME:-mpi}
ARG GROUP_ID
ENV GROUP_ID=${GROUP_ID:-1000}
ARG USER_NAME
ENV USER_NAME=${USER_NAME:-one}
ARG USER_ID
ENV USER_ID=${USER_ID:-1000}

ENV USER_HOME="/home/${USER_NAME}"

# create the first user
RUN set -eu; \
      \
      groupadd -g ${GROUP_ID} ${GROUP_NAME}; \
      useradd  -m -G ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}; \
      \
      echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# generate ssh keys for root
RUN set -eu; \
      \
      ssh-keygen -f /root/.ssh/id_rsa -q -N ""; \
      mkdir -p ~/.ssh/ && chmod 700 ~/.ssh/

# generate ssh keys for the newly added user
USER ${USER_NAME}

WORKDIR ${USER_HOME}
RUN set -eu; \
      \
      ssh-keygen -f ${USER_HOME}/.ssh/id_rsa -q -N ""; \
      mkdir -p ~/.ssh/ && chmod 700 ~/.ssh/


# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL="https://github.com/alephpiece/docker-mpich"
LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="MPICH docker image" \
      org.label-schema.description="An image for GCC and MPICH" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url=${VCS_URL} \
      org.label-schema.schema-version="1.0"
