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

The base image is [spack](https://hub.docker.com/r/spack).

## make

There are a bunch of build-time arguments you can use to build the GCC-MPICH image.

It is highly recommended that you build the image with `make`.

```bash
# Build an image for MPICH 3.3.2
make MPICH_VERSION="3.3.2" GCC_VERSION="9.2.0"

# Build and publish the image
make release MPICH_VERSION="3.3.2"
```

Check `Makefile` for more options.

## docker build

As an alternative, you can build the image with `docker build` command.

```bash
docker build \
        --build-arg GCC_VERSION="9.2.0" \
        --build-arg MPICH_VERSION="3.3.2" \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        -t my-repo/gmpich:latest .
```

Arguments and their defaults are listed below.

- `GCC_VERSION`: The version of GCC supported by spack (defaults to `9.2.0`)

- `MPICH_VERSION`: The version of MPICH supported by spack (defaults to `3.3.2`)

- `MPICH_OPTIONS`: Spack variants (defaults to none)

- `GROUP_NAME`: User group (defaults to `mpi`)
- `USER_NAME`: User name (defaults to `one`)
  - This is the default user when the image is started.
