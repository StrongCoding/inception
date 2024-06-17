FROM alpine:3.19

COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN apk update && apk add mariadb mariadb-client bash openrc && \
mkdir -p /run/mysqld && \
chown -R mysql:mysql /run/mysqld && \
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

COPY mdbsetup.sh /tmp/mdbsetup.sh

ENTRYPOINT ["/bin/bash", "/tmp/mdbsetup.sh"]

EXPOSE 3306

#keeps mariadb running
CMD ["mysqld_safe"]