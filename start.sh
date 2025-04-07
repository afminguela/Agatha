#!/bin/sh

# Iniciar MySQL
echo "Iniciando MySQL..."
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
mysqld --user=mysql --datadir=/var/lib/mysql &

# Esperar a que MySQL esté disponible
echo "Esperando a que MySQL esté disponible..."
while ! mysqladmin ping -h localhost --silent; do
    sleep 1
done

# Crear base de datos HOSPITAL si no existe
echo "Configurando la base de datos..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS HOSPITAL;"

# Importar el archivo SQL
echo "Importando esquema de base de datos..."
mysql -u root -p$MYSQL_ROOT_PASSWORD HOSPITAL < /docker-entrypoint-initdb.d/agatha.sql

# Iniciar la aplicación Java
echo "Iniciando la aplicación Java..."
java -jar /app.jar
