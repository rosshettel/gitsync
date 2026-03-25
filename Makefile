-include .env
export

IMAGE ?= $(error IMAGE is not set. Export it or pass it: make build IMAGE=registry.example.com/gitsync)
TAG      ?= latest
PLATFORM ?= linux/amd64
REGISTRY := $(firstword $(subst /, ,$(IMAGE)))

.PHONY: login build push release

login:
	docker login $(REGISTRY)

build:
	docker build --platform $(PLATFORM) -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

release: login build push
