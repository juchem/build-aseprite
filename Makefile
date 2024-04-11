.PHONY: all image build interactive

all: image

image:
	DOCKER_BUILDKIT=1 docker build \
		-t build-aseprite \
			docker

image-from-scratch:
	DOCKER_BUILDKIT=1 docker build \
		-t build-aseprite \
		--no-cache \
			docker

build: image
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
			build-aseprite

interactive: image
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		--entrypoint bash \
			build-aseprite
