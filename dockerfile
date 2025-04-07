FROM amazoncorretto:23-alpine-jdk

# Instalar herramientas necesarias
RUN apk add --no-cache mysql mysql-client maven bash

# Crear directorio para datos de MySQL
RUN mkdir -p /var/lib/mysql /var/run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld

# Copiar el código fuente de la aplicación
COPY ./Agatha /app/Agatha
WORKDIR /app/Agatha

# Compilar la aplicación con Maven
RUN mvn clean package -DskipTests

# Copiar el archivo SQL de inicialización
COPY ./database/agatha.sql /docker-entrypoint-initdb.d/

# Variables de entorno para MySQL
ENV MYSQL_ROOT_PASSWORD=1234
ENV SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/HOSPITAL

# Exponer puertos
EXPOSE 8080 3306

# Instrucción de inicio (todo en bash para mayor flexibilidad)
ENTRYPOINT ["/bin/bash", "-c", "\
  echo 'Iniciando MySQL...'; \
  mkdir -p /var/run/mysqld; \
  chown -R mysql:mysql /var/run/mysqld; \
  mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql; \
  mysqld --user=mysql --datadir=/var/lib/mysql & \
  echo 'Esperando a que MySQL esté disponible...'; \
  while ! mysqladmin ping -h localhost --silent; do \
    sleep 1; \
  done; \
  echo 'Configurando base de datos...'; \
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e \"CREATE DATABASE IF NOT EXISTS HOSPITAL;\"; \
  echo 'Importando esquema...'; \
  mysql -u root -p$MYSQL_ROOT_PASSWORD HOSPITAL < /docker-entrypoint-initdb.d/agatha.sql; \
  echo 'Iniciando aplicación Java...'; \
  JAR_FILE=$(find /app/Agatha/target -name \"*.jar\" | head -n 1); \
  if [ -z \"$JAR_FILE\" ]; then \
    echo 'Error: no se encontró el archivo .jar'; \
    exit 1; \
  fi; \
  java -jar \"$JAR_FILE\" \
"]


