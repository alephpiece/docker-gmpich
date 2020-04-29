[![Layers](https://images.microbadger.com/badges/image/leavesask/gmpich.svg)](https://microbadger.com/images/leavesask/gmpich)
[![Version](https://images.microbadger.com/badges/version/leavesask/gmpich.svg)](https://hub.docker.com/repository/docker/leavesask/gmpich)
[![Commit](https://images.microbadger.com/badges/commit/leavesask/gmpich.svg)](https://github.com/K-Wone/docker-mpich)
[![License](https://images.microbadger.com/badges/license/leavesask/gmpich.svg)](https://github.com/K-Wone/docker-mpich)
[![Docker Pulls](https://img.shields.io/docker/pulls/leavesask/gmpich?color=informational)](https://hub.docker.com/repository/docker/leavesask/gmpich)
[![Automated Build](https://img.shields.io/docker/automated/leavesask/gmpich)](https://hub.docker.com/repository/docker/leavesask/gmpich)

# Supported tags

- `3.3.2`
- `3.2.1`

# How to use

1. [Install docker engine](https://docs.docker.com/install/)

2. Pull the image
  ```bash
  docker pull leavesask/gmpich:<tag>
  ```

3. Run the image interactively
  ```bash
  docker run -it --rm leavesask/gmpich:<tag>
  ```

# How to build

## make

There are a bunch of build-time arguments you can use to build the GCC-MPICH image.

It is hightly recommended that you build the image with `make`.

```bash
# Build an image for MPICH 3.2.1
make MPICH_VERSION="3.2.1"

# Build and publish the image
make release MPICH_VERSION="3.2.1"
```

Check `Makefile` for more options.

## docker build

As an alternative, you can build the image with `docker build` command.

```bash
docker build \
        --build-arg GCC_VERSION="latest" \
        --build-arg MPICH_VERSION="3.2.1" \
        --build-arg MPICH_OPTIONS="--enable-mpi-cxx" \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        -t my-repo/gmpich:latest .
```

Arguments and their defaults are listed below.

- `GCC_VERSION`: tag (default=`latest`)
  - This is the tag of the base image for all of the stages.
  - The docker repository defaults to `leavesask/gcc`.

- `MPICH_VERSION`: X.X.X (default=`3.2.1`)

- `MPICH_OPTIONS`: option\[=value\] (default=`--enable-mpi-cxx --enable-shared`)
  - Options needed to configure the installation.
  - The default installation path is `/opt/mpich/${MPICH_VERSION}` so that option `--prefix` is unnecessary.

- `GROUP_NAME`: value (default=`mpi`)
- `USER_NAME`: value (default=`one`)
  - A user to be added.
  - This is the default user when the image is started.
