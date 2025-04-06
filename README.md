# Agatha 

Agatha es una WebApp educativa que enseña conceptos básicos de SQL a través de un juego de detectives, diseñada especialmente para ser accesible y adaptada para personas con diversidad funcional.
## 🎯 Objetivo
El objetivo principal es enseñar los conceptos básicos de SQL mediante la gamificación, permitiendo que los usuarios aprendan a realizar consultas en bases de datos de una manera divertida y accesible. El juego está diseñado para ser el punto de entrada perfecto para quienes quieran aprender a consultar bases de datos existentes.

## 👥 Perfil de Usuario
Niños y adolescentes con interés por la informática
Personas que quieren aprender a manejarse con bases de datos
Especialmente adaptado para usuarios con diversidad funcional
No requiere conocimientos previos de programación


## 🎮 Características Principales
Juego conversacional tipo detective cuyo nombre está inspirado en Agatha Christie
Interfaz sencilla y accesible basada en una única pantalla principal
Sistema de notas integrado para seguimiento de pistas
Completamente accesible (puntuación 100 en Lighthouse)
Soporte para lectores de pantalla
Implementación de lectura fácil
Control por teclado y reconocimiento de voz


## 🛠️ Estructura Técnica
### Frontend
HTML5 semántico con etiquetas ARIA
JavaScript vanilla para la lógica del juego
CSS con patrones de accesibilidad WCAG
Interfaz minimalista y enfocada y lo mas realista posible.


### Backend
Java con Spring Boot
Estructura de clases:
QueryRequest: Clase principal (implementa JDBC)
QueryController: Manejo de ejecución de queries
QueryRepository: Repositorio extendido de JDBC


### Base de datos
SQL con estructura relacional
Sistema de validación de consultas
Prevención de inyección SQL


## 📚 Estructura de la Base de Datos
### Tablas Principales
```
-- Estructura básica de las tablas principales
CREATE TABLE Pacientes (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    -- otros campos relevantes
);

CREATE TABLE Personal_Medico (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100),
    -- otros campos relevantes
);

CREATE TABLE Tratamientos (
    id INT PRIMARY KEY,
    id_paciente INT,
    id_medico INT,
    -- otros campos relevantes
);

-- Tablas adicionales para el juego
CREATE TABLE Medicaciones (...);
CREATE TABLE Visitas (...);
CREATE TABLE Motivos_Visitas (...);
CREATE TABLE Instrucciones (...);
CREATE TABLE Informe (...);
CREATE TABLE Solucion (...);
```

## 💻 Instalación y Configuración
### Requisitos Previos
Java JDK 11 o superior
Maven
MySQL
SpringBoot



### Docker compose
Clonar el repositorio:

```
$ git clone <https://github.com/afminguela/Agatha.git>
$ cd Agatha
```

Compilar:

```
$ (cd Agatha; mvn clean install)
```

Ejecutar docker compose:

```
$ docker compose up -d
```

## Instrucciones antiguas

### Pasos de Instalación
Clonar el repositorio:

```
git clone <https://github.com/afminguela/Agatha.git>
cd Agatha
```

### Configurar la base de datos:

```
mysql -u root -p < agatha.sql
```

### Configurar el archivo application.properties:

```
spring.datasource.url=jdbc:mysql://localhost:3306/HOSPITAL
spring.datasource.username=your_username
spring.datasource.password=your_password
```

### Compilar y ejecutar:

```
mvn clean install
java -jar target/Agatha-0.0.1-SNAPSHOT.jar
```

## 🔍 Características de Seguridad
Validación de consultas SQL
Lista blanca de comandos permitidos
Prevención de inyección SQL
Sanitización de entradas
Gestión segura de conexiones a base de datos


## 📊 Métricas y Monitorización
Número de visitas y usuarios activos
Tiempo medio de resolución
Tasa de consultas exitosas vs. fallidas
Puntos de abandono comunes
Satisfacción del usuario


---
# Manual de Instrucciones - Agatha

## 🎮 Guía Detallada de Juego
### 1. Iniciando el Juego
Accede a la interfaz principal
Lee la introducción del caso
Familiarízate con el área de consultas
Revisa las instrucciones iniciales


### 2. Comandos SQL Básicos
Consultas Simples

```
-- Consultar todos los pacientes
SELECT * FROM Pacientes;

-- Buscar un paciente específico
SELECT * FROM Pacientes WHERE id = 1;

-- Ver información específica
SELECT nombre, fecha_ingreso FROM Pacientes;
Consultas con JOIN
-- Relacionar pacientes con sus tratamientos
SELECT p.nombre, t.fecha, t.descripcion
FROM Pacientes p
JOIN Tratamientos t ON p.id = t.id_paciente;

-- Ver visitas médicas
SELECT p.nombre, v.fecha, pm.nombre as doctor
FROM Pacientes p
JOIN Visitas v ON p.id = v.id_paciente
JOIN Personal_Medico pm ON v.id_medico = pm.id;
```

### 3. Sistema de Pistas
El juego proporciona pistas a través de:
Resultados de consultas
Notas del sistema
Conexiones entre tablas
Eventos especiales


### 4. Progresión del Caso
####Fase Inicial
Identificación de la víctima
Recopilación de datos básicos
Análisis del entorno hospitalario

#### Fase de Investigación
Conexión de eventos
Análisis de tratamientos
Estudio de patrones

#### Fase de Resolución
Formulación de hipótesis
Verificación de evidencias
Presentación de conclusiones


### 5. Tips Avanzados
Mantén un registro cronológico de eventos
Dibuja diagramas de relaciones
Utiliza consultas complejas para cruzar información
Verifica alibi y motivos


### 6. :accessibility:  Accesibilidad y Ayudas
#### Comandos de Voz
Se puede usar el reconocimiento de voz para escribir las consultas pero has de tener configurado para inglés y español ya que los nombres de las tablas están en español y los comandos son ingleses. 

#### Atajos de Teclado
Con la tecla enter ejecutas el comando y con las flechas de dirección arriba y abajo te mueves por el historial de comandos introducidos

##  Solución de Problemas
Errores Comunes
### Syntax Error en SQL
Verificar punto y coma al final
Comprobar comillas en strings
Validar nombres de tablas

### No hay Resultados
Verificar condiciones WHERE
Comprobar JOINs
Validar datos de búsqueda

### 📵 Error de Conexión
Verificar conexión a internet
Recargar página
Limpiar caché


## 🎯 Verificación de Victoria
Para comprobar si has resuelto el caso:
-- Formato de verificación
SELECT * FROM Solucion 
WHERE sospechoso = 'nombre_sospechoso';

## 📝 Mantenimiento de Notas
Usa el bloc de notas integrado
Organiza la información por categorías
Mantén un registro de consultas exitosas
Anota patrones y conexiones importantes


## 🤝 Soporte y Comunidad
Toda ayuda es bienvenida 💝 
Reportar bugs en GitHub
Contribuir al proyecto
Compartir estrategias
Sugerir mejoras


## 📑Documentacion del producto disponible en: 

https://afminguela.atlassian.net/wiki/spaces/~7120205090ef6510be47b6ac2b991d62fc6d1e/pages/28868609/TFG-+Agatha+-+Ana+Fernandez+Minguela

## Para ponerte en contacto conmigo:
afminguela@gmail.com


