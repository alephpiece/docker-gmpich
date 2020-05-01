# stage 1: build MPICH with latest spack
ARG GCC_VERSION="9.2.0"
FROM leavesask/gcc:${GCC_VERSION} AS builder

USER root

ARG GCC_VERSION="9.2.0"
ENV GCC_VERSION=${GCC_VERSION}
ARG MPICH_VERSION="3.3.2"
ENV MPICH_VERSION=${MPICH_VERSION}
ARG MPICH_OPTIONS=""
ENV MPICH_OPTIONS=${MPICH_OPTIONS}

# install MPICH
RUN spack install --show-log-on-error -y mpich@${MPICH_VERSION} %gcc@${GCC_VERSION} ${MPICH_OPTIONS}


# stage 2: build the runtime environment
ARG GCC_VERSION
FROM leavesask/gcc:${GCC_VERSION}

LABEL maintainer="Wang An <wangan.cs@gmail.com>"

USER root

ENV SPACK_ROOT=/opt/spack
ENV PATH=${SPACK_ROOT}/bin:$PATH

# copy artifacts from stage 1
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

# initialize spack environment for all users
RUN set -eu; \
      \
      source ${SPACK_ROOT}/share/spack/setup-env.sh; \
      spack load mpich

# install mpi runtime dependencies
RUN set -eu; \
      \
      apt-get update; \
      apt-get install -y \
              openssh-server \
              sudo

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
