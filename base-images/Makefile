# Copyright 2017 AT&T Intellectual Property.  All other rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DOCKER_REGISTRY   ?= quay.io
IMAGE_PREFIX      ?= att-comdev
PROXY             ?= http://proxy.foo.com:8000
NO_PROXY          ?= localhost,127.0.0.1,.svc.cluster.local
USE_PROXY         ?= false
PUSH_IMAGE        ?= false
LABEL             ?= commit-id
IMAGE_NAME        := docker-brew-ubuntu-core-xenial buildpack-deps-xenial-curl buildpack-deps-xenial-scm buildpack-deps-xenial python-3.5-xenial python-3.6-xenial
BUILD_DIR         := $(shell mktemp -d)
UBUNTU_BASE_IMAGE ?= ubuntu:16.04

.PHONY: images
#Build all images in the list
images: $(IMAGE_NAME)

docker-brew-ubuntu-core-xenial:
	@echo
	@echo "===== Processing [$@] image ====="
	@make build IMAGE=$(IMAGE_PREFIX)/ubuntu:xenial IMAGE_DIR=docker-brew-ubuntu-core/xenial UBUNTU_BASE_IMAGE=scratch

buildpack-deps-xenial-curl:
	@echo
	@echo "===== Processing [$@] image ====="
	@make build IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial-curl IMAGE_DIR=buildpack-deps/xenial/curl UBUNTU_BASE_IMAGE=$(IMAGE_PREFIX)/ubuntu:xenial

buildpack-deps-xenial-scm:
	@echo
	@echo "===== Processing [$@] image ====="
	@make build IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial-scm IMAGE_DIR=buildpack-deps/xenial/scm UBUNTU_BASE_IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial-curl

buildpack-deps-xenial:
	@echo
	@echo "===== Processing [$@] image ====="
	@make build IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial IMAGE_DIR=buildpack-deps/xenial UBUNTU_BASE_IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial-scm

python-3.5-xenial:
	@echo
	@echo "===== Processing [$@] image ====="
	@make build IMAGE=$(IMAGE_PREFIX)/python:3.5 IMAGE_DIR=python/3.5/xenial UBUNTU_BASE_IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial

python-3.6-xenial:
	@echo
	@echo "===== Processing [$@] image ====="
	@make build IMAGE=$(IMAGE_PREFIX)/python:3.6 IMAGE_DIR=python/3.6/xenial UBUNTU_BASE_IMAGE=$(IMAGE_PREFIX)/buildpack-deps:xenial

.PHONY: build
build:
ifeq ($(USE_PROXY), true)
	docker build -t $(IMAGE) --network=host --label $(LABEL) -f $(IMAGE_DIR)/Dockerfile \
		--build-arg FROM=$(UBUNTU_BASE_IMAGE) \
		--build-arg http_proxy=$(PROXY) \
		--build-arg https_proxy=$(PROXY) \
		--build-arg HTTP_PROXY=$(PROXY) \
		--build-arg HTTPS_PROXY=$(PROXY) \
		--build-arg no_proxy=$(NO_PROXY) \
		--build-arg NO_PROXY=$(NO_PROXY) \
		$(IMAGE_DIR)
else
	docker build -t $(IMAGE) --network=host --label $(LABEL) -f $(IMAGE_DIR)/Dockerfile \
		--build-arg FROM=$(UBUNTU_BASE_IMAGE) \
		$(IMAGE_DIR)
endif
ifeq ($(PUSH_IMAGE), true)
	docker push $(IMAGE)
endif

.PHONY: clean
clean:
	rm -rf build

