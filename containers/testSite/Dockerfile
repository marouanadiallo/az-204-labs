FROM nginx:stable-alpine

LABEL maintainer="Docker Newbee"
WORKDIR /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d

COPY ./*.html .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
