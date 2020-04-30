#===============================================================================
# Default User Options
#===============================================================================

# Build-time arguments
BASE_IMAGE     ?= gcc
BASE_TAG       ?= 9.2.0
MPICH_VERSION  ?= 3.2.1
MPICH_OPTIONS  ?= "--enable-shared"

# Image name
DOCKER_IMAGE ?= leavesask/gmpich
DOCKER_TAG   := $(MPICH_VERSION)

#===============================================================================
# Variables and objects
#===============================================================================

# Append a suffix to the tag if the version number of GCC
# is specified
ifneq ($(BASE_TAG),latest)
    DOCKER_TAG := $(DOCKER_TAG)-gcc-$(BASE_TAG)
endif

BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VCS_URL=$(shell git config --get remote.origin.url)

# Get the latest commit
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

#===============================================================================
# Targets to Build
#===============================================================================

.PHONY : docker_build docker_push output

default: build
build: docker_build output
release: docker_build docker_push output

docker_build:
	# Build Docker image
	docker build \
                 --build-arg BASE_IMAGE=$(BASE_IMAGE) \
                 --build-arg BASE_TAG=$(BASE_TAG) \
                 --build-arg MPICH_VERSION=$(MPICH_VERSION) \
                 --build-arg MPICH_OPTIONS=$(MPICH_OPTIONS) \
                 --build-arg BUILD_DATE=$(BUILD_DATE) \
                 --build-arg VCS_URL=$(VCS_URL) \
                 --build-arg VCS_REF=$(GIT_COMMIT) \
                 -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Tag image as latest
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest

	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
