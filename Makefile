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

test: build
	@echo "Testing"
	# Some basic tests
	docker run --rm -i hadolint/hadolint < "${DOCKERFILE}"
	docker run --rm -v "$$PWD:/mnt" koalaman/shellcheck:stable **/*.sh
	# Its team dependent but I find monitors these days are quite large so default max line length of 80 is too short
	docker run --rm -v "$$PWD:/yaml" sdesbure/yamllint yamllint -d "{extends: relaxed, rules: {line-length: {max: 120}}}"  **/*.yaml
	docker run --rm -v  "$$PWD/k8s:/k8s" garethr/kubeval k8s/*.yaml
	#docker scan not working out of the box with my instance of TravisCI
	#docker scan "${IMAGE}"

run:
	# Used for running locally
	@echo "Run container"
	docker run --rm -it --name litecoin litecoin

deploy:
	kubectl apply -f k8s

destroy:
	kubectl delete -f k8s