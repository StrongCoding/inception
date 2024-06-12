.phony: all build stop clean fclean prune fprune

all:
	-mkdir /home/$(USER)/data/
	-mkdir /home/$(USER)/data/database_volume
	-mkdir /home/$(USER)/data/shared_volume
	docker-compose -f srcs/docker-compose.yml up -d

build:
	docker-compose -f srcs/docker-compose.yml build

stop:
	docker-compose -f srcs/docker-compose.yml stop

clean:
	docker-compose -f srcs/docker-compose.yml down -v

fclean:
	docker-compose -f srcs/docker-compose.yml down -v --rmi local
	rm -rf /home/$(USER)/data

prune:
	docker system prune --all --force --volumes

fprune: fclean prune