# Copyright 2017 The Openstack-Helm Authors.
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

#---------------#
# Configuration #
#---------------#
IMAGES := \
	ceph-daemon:latest \
	helm:latest \
	helm:ubuntu-v2.1.3 \
	helm:v2.1.3 \
	kolla-builder:latest \
	kube-controller-manager:latest \
	kube-controller-manager:v1.6.2 \
	kvm-manager:latest \
	openvswitch-vswitchd:latest \
	rabbitmq:3.7.0-pre-15 \

DEFAULT_NAMESPACE := quay.io/attcomdev


#-------#
# Setup #
#-------#
escape_colons = $(subst :,\:, $1)

dir_from_image = $(firstword $(subst :, , $1))
DIRS := $(sort $(foreach i, $(IMAGES), $(call dir_from_image, $(i))))

BUILD_TASK_DIRS := $(addprefix build:, $(DIRS))
PUSH_TASK_DIRS := $(addprefix push:, $(DIRS))

BUILD_TASK_IMAGES := $(addprefix build:, $(IMAGES))
PUSH_TASK_IMAGES := $(addprefix push:, $(IMAGES))

.PHONY : all build push $(DIRS) $(call escape_colons, \
	$(BUILD_TASK_DIRS) $(PUSH_TASK_DIRS) $(BUILD_TASK_IMAGES) ($PUSH_TASK_IMAGES))

.SECONDEXPANSION:

# Helpers for run_submake
get_task = $(word 1, $(subst :, , $1))
get_dir  = $(word 2, $(subst :, , $1))
get_tag  = $(word 3, $(subst :, , $1))

run_submake = \
	@if [ -f $(call get_dir, $@)/Makefile ]; then \
		$(MAKE) -C $(call get_dir, $@) $(call get_task, $1) \
			DEFAULT_NAMESPACE=$(DEFAULT_NAMESPACE) \
			DEFAULT_IMAGE=$(call get_dir, $1) \
			DEFAULT_TAG=$(call get_tag, $1) \
		; \
	else \
		$(MAKE) -f ../Makefile.default -C $(call get_dir, $1) $(call get_task, $1) \
			NAMESPACE=$(DEFAULT_NAMESPACE) \
			IMAGE=$(call get_dir, $1) \
			TAG=$(call get_tag, $1) \
		; \
	fi


#-------#
# Rules #
#-------#
all: usage

define usage_text=
Usage:

To build all images:
	make build

To build a specific image:
	make build:<image>[:<tag>]
	make <image>[:<tag>]

To push all images:
	make push

To push a specific image:
	make push:<image>[:<tag>]
endef
export usage_text
help usage:
	@echo "$$usage_text"


build: $(call escape_colons, $(BUILD_TASK_DIRS))

push: $(call escape_colons, $(PUSH_TASK_DIRS))

$(DIRS) : $$(addprefix build\:, $$@)

$(call escape_colons, $(IMAGES)): $$(addprefix build\:, $$@)

$(call escape_colons, $(BUILD_TASK_DIRS)): $$(filter $$@\:%, $$(BUILD_TASK_IMAGES))

$(call escape_colons, $(PUSH_TASK_DIRS)): $$(filter $$@\:%, $$(PUSH_TASK_IMAGES))

$(call escape_colons, $(PUSH_TASK_IMAGES)): $$(patsubst push%,build%, $$@)
	$(call run_submake, $@)

$(call escape_colons, $(BUILD_TASK_IMAGES)):
	$(call run_submake, $@)
