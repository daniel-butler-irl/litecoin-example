DOCKERFILE=image/Dockerfile
DOCKER_CONTEXT=image/
IMAGE=litecoin
REGISTRY=dannyeb

ifndef BUILD_DATE
  override BUILD_DATE:=$(shell /bin/date "+%Y%m%d-%H%M%S")
endif

build:
	@echo "Building"
	docker build -f "${DOCKERFILE}" --progress=plain --no-cache -t "${IMAGE}" "${DOCKER_CONTEXT}"

docker-login:
	@if [ -z "$${DOCKER_USERNAME}" ]; then echo "Error: DOCKER_USERNAME is undefined"; exit 1; fi
	@if [ -z "$${DOCKER_PASSWORD}" ]; then echo "Error: DOCKER_PASSWORD is undefined"; exit 1; fi
	@echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

push: docker-login
	@echo "Pushing"
	docker tag "${IMAGE}" "${REGISTRY}/${IMAGE}:$(BUILD_DATE)"
	docker push "${REGISTRY}/${IMAGE}:$(BUILD_DATE)"

test:
	@echo "Testing"
	# Some basic tests
	docker run --rm -i hadolint/hadolint < "${DOCKERFILE}"
	docker run --rm -v "$$PWD:/mnt" koalaman/shellcheck:stable **/*.sh
	docker scan "${IMAGE}" --exclude-base

run:
	# Used for running locally
	@echo "Run container"
	docker run --rm -it --name litecoin litecoin