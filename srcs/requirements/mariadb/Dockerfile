FROM alpine:3.19

RUN apk update && apk add mariadb mariadb-client bash openrc

COPY mdbsetup.sh /tmp/mdbsetup.sh
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT ["/bin/bash", "/tmp/mdbsetup.sh"]

EXPOSE 3306

#keeps mariadb running
CMD ["mysqld_safe"]