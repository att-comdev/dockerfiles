.PHONY: build push

TAG=quay.io/attcomdev/rabbitmq:3.7.0-pre-14

all: build push

build:
	sudo docker build -t ${TAG} .

push:
	sudo docker push ${TAG}
