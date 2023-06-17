FROM centos:latest
RUN yum install apache2 -y
RUN yum install unzip -y
ADD https://www.free-css.com/assets/files/free-css-templates/download/page292/settle.zip /var/www/html
WORKDIR /var/www/html/
RUN unzip settle.zip
RUN cp -rvf settle-html/* .
RUN rm  -rf settle.zip
CMD ["httpd-foreground"]
EXPOSE 80
