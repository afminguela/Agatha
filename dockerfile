FROM amazoncorretto:23-alpine-jdk

RUN apk add --no-cache maven

# Copiar y compilar la app
COPY ./Agatha /app/Agatha
WORKDIR /app/Agatha
RUN mvn clean package -DskipTests

# Exponer el puerto
EXPOSE 8080

# Ejecutar el JAR resultante
CMD ["sh", "-c", "java -jar target/*.jar"]


