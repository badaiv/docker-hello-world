FROM nginx:mainline-alpine
RUN rm /etc/nginx/conf.d/*
ADD helloworld.conf /etc/nginx/conf.d/
ADD index.html nginx.png /usr/share/nginx/html/