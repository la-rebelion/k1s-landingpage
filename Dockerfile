FROM httpd:alpine3.18
COPY ./public-html/ /usr/local/apache2/htdocs/

# docker build -t adrianescutia/landingpage:0.1.0 -f Dockerfile .