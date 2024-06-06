#!/bin/sh
cd /var/www/html

php-fpm7.4 -D

if [ -f ./wp-config.php ]
then
	echo "wordpress already installed"
else
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	wp core download --path=/var/www/html --allow-root
	wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root
	wp core install --url=$WORDPRESS_URL --title="SteveIstCool" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root
	wp user create steve steve@steve.com --role=author --porcelain --allow-root
	wp theme install variations --activate --allow-root
fi

# Execute the command passed as arguments to the script
exec "$@"