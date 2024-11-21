
# Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
# Click nbfs://nbhost/SystemFileSystem/Templates/Other/Dockerfile to edit this template

FROM amazoncorretto:23-alpine-jdk 

Workdir /app

COPY target/Agatha-0.0.1-SNAPSHOT.jar  app.jar

EXPOSE 8080

entrypoint ["java" , "-jar" , "/app.jar"]
