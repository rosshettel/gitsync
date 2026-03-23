-include .env
export

IMAGE ?= $(error IMAGE is not set. Export it or pass it: make build IMAGE=registry.example.com/gitsync)
TAG   ?= latest
REGISTRY := $(firstword $(subst /, ,$(IMAGE)))

.PHONY: login build push release

login:
	docker login $(REGISTRY)

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

release: login build push
