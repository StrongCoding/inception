.phony: all build stop clean fclean prune fprune

all:
	-mkdir /home/$(USER)/data/
	-mkdir /home/$(USER)/data/database_volume
	-mkdir /home/$(USER)/data/shared_volume
	docker-compose -f srcs/docker-compose.yml up

build:
	docker-compose -f srcs/docker-compose.yml build

no-cache:
	docker-compose -f srcs/docker-compose.yml build --no-cache

stop:
	docker-compose -f srcs/docker-compose.yml stop

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down -v

fclean:
	docker-compose -f srcs/docker-compose.yml down -v --rmi local
	rm -rf /home/$(USER)/data

prune:
	docker system prune --all --force --volumes

fprune: fclean prune