FROM debian:bullseye


RUN apt-get update && apt-get install -y curl php7.4-fpm \
php7.4-mysql \
php7.4-gd \
php7.4-mbstring \
php7.4-xml \
php7.4-zip \
php7.4-curl && \
sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf && \
mkdir -p /run/php && \
mkdir -p /var/www/html && \
chmod -R 755 /var/www/html

COPY wordpressinstall.sh /tmp/wordpressinstall.sh

ENTRYPOINT ["/bin/bash", "/tmp/wordpressinstall.sh"]

CMD ["php-fpm7.4", "-F"]
