#!/bin/bash
#folder for process id
mkdir -p /run/mysqld
# Change the ownership of the folder
chown -R mysql:mysql /run/mysqld

# Start the MariaDB service
/etc/init.d/mariadb start


echo "hello"
echo "$MYSQL_DATABASE"
mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -e "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -e "FLUSH PRIVILEGES;"

/etc/init.d/mariadb stop

# Execute the command passed as arguments to the script
exec "$@"