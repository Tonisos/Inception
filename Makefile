all: up

up:
	@mkdir -p ${HOME}/data
	@mkdir -p ${HOME}/data/wordpress
	@mkdir -p ${HOME}/data/mariadb
	@sudo sh -c 'echo "127.0.0.1 amontalb.42.fr"' >> /etc/hosts 
	@docker compose -f ./srcs/docker-compose.yml up --detach

down:
	@docker compose -f ./srcs/docker-compose.yml down

build:
	@docker compose -f srcs/docker-compose.yml up --detach --build

logs:
	@docker compose -f srcs/docker-compose.yml logs

clean:
	@docker stop nginx wordpress mariadb 2>/dev/null || true
	@docker rm nginx wordpress mariadb 2>/dev/null || true
	@docker volume rm db wp 2>/dev/null || true
	@docker rmi srcs-nginx srcs-wordpress srcs-mariadb 2>/dev/null || true
	@docker network rm inception_net 2>/dev/null || true
	sudo rm -rf ${HOME}/data
	@sudo sed -i '/127.0.0.1 amontalb.42.fr/d' /etc/hosts 

re: clean all

.PHONY: all up down build clean logs re