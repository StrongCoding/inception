all:
	docker-compose -f srcs/docker-compose.yml up -d

build:
	docker-compose -f srcs/docker-compose.yml build

stop:
	docker-compose -f srcs/docker-compose.yml stop
	
clean:
	docker-compose -f srcs/docker-compose.yml down -v

fclean:
	docker-compose -f srcs/docker-compose.yml down -v --rmi local

prune:
	docker system prune --all --force --volumes

fprune: fclean prune