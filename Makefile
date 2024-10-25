include sandbox_env_vars.sh
export

TAG = $(TAG_IMAGE):$(NSO_VERSION)
PLATFORM := $(shell uname -m | sed 's/arm64/arm64/g' | sed 's/x86_64/amd64/g')


all:
	$(MAKE) build
	$(MAKE) run

build:
	$(MAKE) clean
	docker build --build-arg NSO_VERSION=$(NSO_VERSION) --build-arg BASE_IMAGE=$(BASE_IMAGE) --build-arg PLATFORM=$(PLATFORM) --platform linux/$(PLATFORM) --target sandbox_setup --tag $(TAG) .

run:
	$(MAKE) clean
	docker run -itd --platform linux/$(PLATFORM) --rm --name nso -p 22:22 -p 179:179 -p 443:443 -p 2024:2024 -p 4369:4369 -p 8080:8080 -e ADMIN_PASSWORD=admin -u developer $(TAG) --with-package-reload

cli:
	docker exec -it nso /bin/bash

clean: 
	-docker rm --force nso

follow:
	docker logs --follow nso

push:
	$(MAKE) build-sandbox
	docker push $(TAG)

all-sandbox:
	$(MAKE) build-sandbox
	$(MAKE) run-sandbox

build-sandbox:
	docker build --build-arg BASE_IMAGE=$(BASE_IMAGE) --build-arg NSO_VERSION=$(NSO_VERSION) --platform linux/amd64 --no-cache --tag $(TAG) .

run-sandbox:
	$(MAKE) clean-sandbox
	docker compose --profile nso up --wait
	docker compose ps

clean-sandbox:
	-docker compose --profile nso down -v

follow-sandbox:
	docker compose logs --follow NODE-1 NODE-2 NODE-3