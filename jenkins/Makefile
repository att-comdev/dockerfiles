BUILD_DIR                  := $(shell mktemp -d)
BUILD_CTX                  ?= src/bin

IMAGE_PREFIX               ?= jenkins
IMAGE_TAG                  ?= lts
IMAGE_NAME                 := jenkins
# use this variable for image labels added in internal build process
#LABEL                      ?=
COMMIT                     ?= $(shell git rev-parse HEAD)

DOCKER_REGISTRY            ?= quay.io
PUSH_IMAGE                 ?= false

PROXY                      ?= http://proxy.foo.com:8000
NO_PROXY                   ?= localhost,127.0.0.1,.svc.cluster.local
USE_PROXY                  ?= false

JENKINS_BASE_IMAGE          ?=

IMAGE:=${DOCKER_REGISTRY}/${IMAGE_PREFIX}/$(IMAGE_NAME):${IMAGE_TAG}
IMAGE_DIR:=dockerfiles/$(IMAGE_NAME)


_BASE_IMAGE_ARG := $(if $(JENKINS_BASE_IMAGE),--build-arg FROM="${JENKINS_BASE_IMAGE}" ,)

.PHONY: build
build:
ifeq ($(USE_PROXY), true)
	docker build --network host -t $(IMAGE) \
		--label "org.opencontainers.image.revision=$(COMMIT)" \
		--label "org.opencontainers.image.created=$(shell date --rfc-3339=seconds --utc)" \
		--label "org.opencontainers.image.title=$(IMAGE_NAME)" \
		-f $(IMAGE_DIR)/Dockerfile \
		$(_BASE_IMAGE_ARG) \
		--build-arg http_proxy=$(PROXY) \
		--build-arg https_proxy=$(PROXY) \
		--build-arg HTTP_PROXY=$(PROXY) \
		--build-arg HTTPS_PROXY=$(PROXY) \
		--build-arg no_proxy=$(NO_PROXY) \
		--build-arg NO_PROXY=$(NO_PROXY) \
		--build-arg ctx_base=$(BUILD_CTX) .
else
	docker build --network host -t $(IMAGE) --label $(LABEL) \
		--label "org.opencontainers.image.revision=$(COMMIT)" \
		--label "org.opencontainers.image.created=$(shell date --rfc-3339=seconds --utc)" \
		--label "org.opencontainers.image.title=$(IMAGE_NAME)" \
		-f $(IMAGE_DIR)/Dockerfile \
		$(_BASE_IMAGE_ARG) \
		--build-arg ctx_base=$(BUILD_CTX) .
endif
ifeq ($(PUSH_IMAGE), true)
	docker push $(IMAGE)
endif

