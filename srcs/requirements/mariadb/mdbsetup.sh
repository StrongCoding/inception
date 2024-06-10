#!/bin/bash
#folder for process id
mkdir -p /run/mysqld
# Change the ownership of the folder
chown -R mysql:mysql /run/mysqld

# Start the MariaDB service
/etc/init.d/mariadb start


echo "hello"
echo $( cat /run/secrets/db_password)
echo "bye"
#echo "$MYSQL_DATABASE"
#mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
#mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
#mysql -e "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -e "CREATE DATABASE IF NOT EXISTS $( cat /run/secrets/db_name);"
mysql -e "CREATE USER IF NOT EXISTS '$( cat /run/secrets/db_user)'@'%' IDENTIFIED BY '$( cat /run/secrets/db_password)';"
mysql -e "GRANT ALL ON $( cat /run/secrets/db_name).* TO '$( cat /run/secrets/db_user)'@'%' IDENTIFIED BY '$( cat /run/secrets/db_password)';"
mysql -e "FLUSH PRIVILEGES;"

/etc/init.d/mariadb stop

#Execute the command passed as arguments to the script
exec "$@"