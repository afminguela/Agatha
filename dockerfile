FROM amazoncorretto:23-alpine-jdk

# Instalar herramientas necesarias
RUN apk add --no-cache mysql mysql-client maven

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

# Crear script de inicio
RUN echo '#!/bin/sh\n\
\n\
# Iniciar MySQL\n\
echo "Iniciando MySQL..."\n\
mkdir -p /var/run/mysqld\n\
chown -R mysql:mysql /var/run/mysqld\n\
mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql\n\
mysqld --user=mysql --datadir=/var/lib/mysql &\n\
\n\
# Esperar a que MySQL esté disponible\n\
echo "Esperando a que MySQL esté disponible..."\n\
while ! mysqladmin ping -h localhost --silent; do\n\
    sleep 1\n\
done\n\
\n\
# Crear base de datos HOSPITAL si no existe\n\
echo "Configurando la base de datos..."\n\
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS HOSPITAL;"\n\
\n\
# Importar el archivo SQL\n\
echo "Importando esquema de base de datos..."\n\
mysql -u root -p$MYSQL_ROOT_PASSWORD HOSPITAL < /docker-entrypoint-initdb.d/agatha.sql\n\
\n\
# Iniciar la aplicación Java\n\
echo "Iniciando la aplicación Java..."\n\
java -jar /app/Agatha/target/*.jar\n' > /start.sh

RUN chmod +x /start.sh

# Exponer puertos para la aplicación y MySQL
EXPOSE 8080 3306

# Definir variables de entorno para MySQL
ENV MYSQL_ROOT_PASSWORD=1234
ENV SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/HOSPITAL

# Ejecutar script de inicio
CMD ["java -jar /app/Agatha/target/*.jar"]

