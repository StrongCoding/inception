FROM debian:bullseye


RUN apt-get update && apt-get install -y mariadb-server

COPY mdbsetup.sh /tmp/mdbsetup.sh
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf

ENTRYPOINT ["/bin/bash", "/tmp/mdbsetup.sh"]

#keeps mariadb running
CMD ["mysqld_safe"]