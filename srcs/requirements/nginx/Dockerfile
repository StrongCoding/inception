FROM alpine:3.19

COPY default.conf /etc/nginx/http.d/default.conf

RUN apk update && apk add bash nginx

CMD ["nginx", "-g", "daemon off;"]