.PHONY: build env run stop clean shell logs

build:
	docker compose build --build-arg DOCKERFILE_PATH=$(DOCKERFILE_PATH)

env:
	sysctl -w vm.max_map_count=1500000

run:
	./make_run.sh

stop:
	docker compose down

clean:
	docker compose down -v
	docker system prune -f

shell:
	docker compose exec deepspeed-training /bin/bash

logs:
	docker compose logs -f
