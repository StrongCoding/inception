FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

EXPOSE 3306

#keeps mariadb running
CMD ["mysqld_safe"]