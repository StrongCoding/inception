FROM alpine:3.19

RUN apk update && apk add mariadb mariadb-client bash openrc
RUN mkdir -p /run/mysqld && \
# Change the ownership of the folder
chown -R mysql:mysql /run/mysqld && \

# Start the MariaDB service
#mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
mysql_install_db --user=mysql --basedir=/usr --datadir=/var

COPY mdbsetup.sh /tmp/mdbsetup.sh
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT ["/bin/bash", "/tmp/mdbsetup.sh"]

EXPOSE 3306

#keeps mariadb running
CMD ["mysqld_safe"]