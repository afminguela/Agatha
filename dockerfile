FROM amazoncorretto:23-alpine-jdk as app

# Instalar las dependencias necesarias para MySQL
RUN apk add --no-cache mysql mysql-client

# Crear directorio para datos de MySQL
RUN mkdir -p /var/lib/mysql /var/run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld

# Copiar nuestro archivo SQL de inicialización
COPY ./database/agatha.sql /docker-entrypoint-initdb.d/

# Copiar la aplicación Java
COPY ./Agatha/target/Agatha-0.0.1-SNAPSHOT.jar /app.jar

# Copiar script de inicio personalizado
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponer puertos para la aplicación y MySQL
EXPOSE 8080 3306

# Definir variables de entorno para MySQL
ENV MYSQL_ROOT_PASSWORD=1234
ENV SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/HOSPITAL

# Ejecutar script de inicio
CMD ["/start.sh"]
