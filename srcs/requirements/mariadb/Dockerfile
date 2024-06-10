FROM debian:bullseye

COPY mdbsetup.sh /tmp/mdbsetup.sh

RUN apt-get update && apt-get install -y mariadb-server && \
    chmod +x /tmp/mdbsetup.sh
EXPOSE 3306

#ENTRYPOINT ["/bin/bash", "/tmp/mdbsetup.sh"]

#keeps mariadb running
#CMD ["mysqld_safe"]