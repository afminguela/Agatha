FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=1234

COPY ./database/agatha.sql /docker-entrypoint-initdb.d/
