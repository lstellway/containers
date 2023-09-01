# Run Docker compose commands against the development file
dev-compose = docker-compose --file $$(pwd)/docker-compose.yml $(1)

.PHONY: compose-up
compose-up: docker-context
	@$(call dev-compose, up -d)

.PHONY: compose-down
compose-down: docker-context
	@$(call dev-compose, down)

.PHONY: docker-context
docker-context:
	@echo "-----" \
		&& echo "Current Docker context: \033[0;31m$$(docker context show)\033[0m" \
		&& echo "-----"

.PHONY: build
build:
	docker build -t $(IMAGE_NAME):dev $$(pwd)

.PHONY: run
run:
	@docker run --detach \
		--privileged \
		--name $(IMAGE_NAME) \
		$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: exec
exec:
	@docker exec -it \
		$(IMAGE_NAME) \
		/bin/sh -l

.PHONY: exec-root
exec-root:
	@docker exec -it \
		--user root \
		$(IMAGE_NAME) \
		/bin/sh -l

.PHONY: down
down:
	@docker stop $(IMAGE_NAME)
	@docker rm $(IMAGE_NAME)

.PHONY: logs
logs:
	@docker logs -f $(IMAGE_NAME)

