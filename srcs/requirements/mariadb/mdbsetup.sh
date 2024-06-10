#!/bin/bash

# Check if the database exists
DB_EXISTS=$(mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES LIKE '"$MYSQL_DATABASE"';" | grep "$MYSQL_DATABASE" > /dev/null; echo "$?")

# If the database does not exist, create it and the user
if [ $DB_EXISTS -eq 1 ]; then
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $MYSQL_DATABASE;"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
fi

# Execute the command passed as arguments to the script
exec "$@"