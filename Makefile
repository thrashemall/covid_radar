.PHONY: help

help:
	@echo 'Available targets:'
	@echo '  make docker:push_kernel'
	@echo '  make docker:push'

docker\:push_kernel: export TAG=kernel-2.6.6
docker\:push_kernel:
	echo "Building ${TAG}"
	docker login registry.gitlab.com
	docker build --no-cache -f ./DockerfileKernel.docker -t registry.gitlab.com/alex.shilov.by/covid_radar:${TAG} .
	docker push registry.gitlab.com/alex.shilov.by/covid_radar:${TAG}

# @refs https://gitlab.com/my-wim/wim/container_registry
docker\:push:
	docker login registry.gitlab.com
	docker build --no-cache -f ./Dockerfile -t registry.gitlab.com/alex.shilov.by/covid_radar:latest .
	docker push registry.gitlab.com/alex.shilov.by/covid_radar:latest
