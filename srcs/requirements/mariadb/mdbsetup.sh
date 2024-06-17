#!/bin/bash
#folder for process id
mkdir -p /run/mysqld
# Change the ownership of the folder
chown -R mysql:mysql /run/mysqld

# Start the MariaDB service
#mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

echo "USE mysql;" >> init.sql
echo "FLUSH PRIVILEGES;" >> init.sql
echo "CREATE DATABASE IF NOT EXISTS $( cat /run/secrets/db_name);" >> init.sql
echo "CREATE USER '$( cat /run/secrets/db_user)'@'%' IDENTIFIED BY '$( cat /run/secrets/db_password)';" >> init.sql
echo "GRANT ALL ON $( cat /run/secrets/db_name).* TO '$( cat /run/secrets/db_user)'@'%' IDENTIFIED BY '$( cat /run/secrets/db_password)';" >> init.sql
echo "FLUSH PRIVILEGES;" >> init.sql


mysqld --user=mysql --bootstrap < init.sql
#Execute the command passed as arguments to the script
rm init.sql
exec "$@"