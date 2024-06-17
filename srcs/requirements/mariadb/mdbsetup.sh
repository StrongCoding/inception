#!/bin/bash

echo "USE mysql;" >> init.sql
echo "FLUSH PRIVILEGES;" >> init.sql
echo "CREATE DATABASE IF NOT EXISTS $( cat /run/secrets/db_name);" >> init.sql
echo "CREATE USER IF NOT EXISTS '$( cat /run/secrets/db_user)'@'%' IDENTIFIED BY '$( cat /run/secrets/db_password)';" >> init.sql
echo "GRANT ALL ON $( cat /run/secrets/db_name).* TO '$( cat /run/secrets/db_user)'@'%' IDENTIFIED BY '$( cat /run/secrets/db_password)';" >> init.sql
echo "FLUSH PRIVILEGES;" >> init.sql


mysqld --user=mysql --bootstrap < init.sql
#Execute the command passed as arguments to the script
rm init.sql
exec "$@"