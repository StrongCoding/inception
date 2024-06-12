FROM debian:bullseye

COPY default.conf /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get install -y nginx

CMD ["nginx", "-g", "daemon off;"]