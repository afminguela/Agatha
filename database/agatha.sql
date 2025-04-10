SET FOREIGN_KEY_CHECKS=0;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema HOSPITAL
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `HOSPITAL` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `HOSPITAL` ;

-- -----------------------------------------------------
-- Table `HOSPITAL`.`Instrucciones`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `HOSPITAL`.`Instrucciones` (
  `id_Instrucciones` INT NOT NULL AUTO_INCREMENT,
  `Instrucciones` VARCHAR(1000) NULL,
  PRIMARY KEY (`id_Instrucciones`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HOSPITAL`.`pacientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`pacientes` (
  `idP` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `edad` INT NOT NULL,
  `habitacion` INT NOT NULL,
  `fecha_ingreso` DATE NOT NULL,
  `causa_muerte` VARCHAR(255) NULL DEFAULT NULL,
  `enfermedad` VARCHAR(100) NOT NULL,
  `Alergias` VARCHAR(100) NULL,
  PRIMARY KEY (`idP`))
ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `HOSPITAL`.`personal_medico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`personal_medico` (
  `idPM` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `tipo` VARCHAR(255) NOT NULL,
  `especialidad` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idPM`))
ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `HOSPITAL`.`medicaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`medicaciones` (
  `idM` INT NOT NULL AUTO_INCREMENT,
  `idP` INT NOT NULL,
  `idPM` INT NOT NULL,
  `nombre` VARCHAR(255) NOT NULL,
  `dosis` VARCHAR(255) NULL DEFAULT NULL,
  `fecha_administracion` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`idM`),
  INDEX `idP` (`idP` ASC) VISIBLE,
  INDEX `idPM` (`idPM` ASC) VISIBLE,
  CONSTRAINT `medicaciones_ibfk_1`
    FOREIGN KEY (`idP`)
    REFERENCES `HOSPITAL`.`pacientes` (`idP`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `medicaciones_ibfk_2`
    FOREIGN KEY (`idPM`)
    REFERENCES `HOSPITAL`.`personal_medico` (`idPM`))
ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `HOSPITAL`.`visitas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`visitas` (
  `idV` INT NOT NULL AUTO_INCREMENT,
  `idP` INT NOT NULL,
  `visitante_nombre` VARCHAR(255) NOT NULL,
  `relacion` VARCHAR(255) NULL DEFAULT NULL,
  `fecha_visita` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`idV`),
  INDEX `fk_visitas_pacientes1_idx` (`idP` ASC) VISIBLE,
  CONSTRAINT `fk_visitas_pacientes1`
    FOREIGN KEY (`idP`)
    REFERENCES `HOSPITAL`.`pacientes` (`idP`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `HOSPITAL`.`motivos_visitas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`motivos_visitas` (
  `idMV` INT NOT NULL AUTO_INCREMENT,
  `idV` INT NOT NULL,
  `motivo` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idMV`),
  INDEX `idV` (`idV` ASC) VISIBLE,
  CONSTRAINT `motivos_visitas_ibfk_1`
    FOREIGN KEY (`idV`)
    REFERENCES `HOSPITAL`.`visitas` (`idV`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `HOSPITAL`.`tratamientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`tratamientos` (
  `idT` INT NOT NULL AUTO_INCREMENT,
  `idP` INT NOT NULL,
  `idPM` INT NOT NULL,
  `tipo` VARCHAR(255) NOT NULL,
  `fecha` DATE NOT NULL,
  `detalles` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idT`),
  INDEX `idP` (`idP` ASC) VISIBLE,
  INDEX `idPM` (`idPM` ASC) VISIBLE,
  CONSTRAINT `tratamientos_ibfk_1`
    FOREIGN KEY (`idP`)
    REFERENCES `HOSPITAL`.`pacientes` (`idP`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tratamientos_ibfk_2`
    FOREIGN KEY (`idPM`)
    REFERENCES `HOSPITAL`.`personal_medico` (`idPM`))
ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `HOSPITAL`.`Informe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOSPITAL`.`Informe` (
  `idI` INT NOT NULL AUTO_INCREMENT,
  `idP` INT NOT NULL,
  `idPM` INT NOT NULL,
  `idT` INT NOT NULL,
  `idM` INT NOT NULL,
  `Fecha_Creacion` DATE NOT NULL,
  `detalles` VARCHAR(1000) NOT NULL,
  `Solucion` TINYINT(1) NULL,
  PRIMARY KEY (`idI`),
  INDEX `fk_Informe_pacientes1_idx` (`idP` ASC) VISIBLE,
  INDEX `fk_Informe_personal_medico1_idx` (`idPM` ASC) VISIBLE,
  INDEX `fk_Informe_tratamientos1_idx` (`idT` ASC) VISIBLE,
  INDEX `fk_Informe_medicaciones1_idx` (`idM` ASC) VISIBLE,
  CONSTRAINT `fk_Informe_pacientes1`
    FOREIGN KEY (`idP`)
    REFERENCES `HOSPITAL`.`pacientes` (`idP`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Informe_personal_medico1`
    FOREIGN KEY (`idPM`)
    REFERENCES `HOSPITAL`.`personal_medico` (`idPM`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Informe_tratamientos1`
    FOREIGN KEY (`idT`)
    REFERENCES `HOSPITAL`.`tratamientos` (`idT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Informe_medicaciones1`
    FOREIGN KEY (`idM`)
    REFERENCES `HOSPITAL`.`medicaciones` (`idM`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `HOSPITAL`.`solucion` (
  `id_solucion` INT NOT NULL, 
  `idPM`INT Null,
  `sospechoso` VARCHAR (1000) NULL,
  `Comentario` VARCHAR(1000) NULL,
  PRIMARY KEY (`id_solucion`))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- ---------------------------------------------------------------------------------
-- ---------------------    Inserción de datos -------------------------------------

-- Insercion de Personal medico 

INSERT INTO personal_medico (nombre, tipo, especialidad) VALUES
('Dr. Ricardo Manzano', 'Doctor', 'Cardiología'),
('Dra. Elena Torres', 'Doctora', 'Neurología'),
('Dr. Carlos Ruiz', 'Doctor', 'Oncología'),
('Enfermera Ana López', 'Enfermera', 'Cuidados Intensivos'),
('Enfermero Juan Díaz', 'Enfermero', 'Urgencias'), -- Sospechoso principal
('Dra. Marina Silva', 'Doctora', 'Psiquiatría'),
('Dr. Francisco Mora', 'Doctor', 'Neumología'),
('Dra. Lucía Ramírez', 'Doctora', 'Endocrinología'),
('Enfermera Patricia Vega', 'Enfermera', 'Pediatría'),
('Dr. Alberto Sanz', 'Doctor', 'Cardiología'),
('Enfermero Miguel Ángel', 'Enfermero', 'Cuidados Intensivos'),
('Dra. Sara Jiménez', 'Doctora', 'Neurología'),
('Dr. Pablo Ortiz', 'Doctor', 'Oncología'),
('Enfermera Rosa Martín', 'Enfermera', 'Urgencias'),
('Dr. Javier Luna', 'Doctor', 'Medicina Interna'),
('Enfermero David Gil', 'Enfermero', 'Cardiología'),
('Dra. Carmen Flores', 'Doctora', 'Geriatría'),
('Enfermera Laura Santos', 'Enfermera', 'Oncología'),
('Dr. Andrés Vargas', 'Doctor', 'Medicina General'),
('Enfermero Roberto Núñez', 'Enfermero', 'Neurología');

-- ------------------------------------------------------------------------------------------------------------
-- Insertando pacientes ---------------------------------------------------------------------------------------

INSERT INTO pacientes (nombre, edad, habitacion, fecha_ingreso, causa_muerte, enfermedad, Alergias) VALUES
('Victor Montenegro', 68, 405, '2024-01-15', 'Paro cardíaco', 'Arritmia cardíaca', 'Penicilina'), -- La víctima
('María Gómez', 45, 402, '2024-01-10', NULL, 'Neumonía', NULL),
('José Martínez', 72, 407, '2024-01-12', NULL, 'Diabetes', 'Sulfamidas'),
('Carmen Vega', 55, 404, '2024-01-14', NULL, 'Hipertensión', NULL),
('Antonio Pérez', 62, 401, '2024-01-08', NULL, 'Artritis Reumatoide', 'Ibuprofeno'),
('Isabel Ruiz', 78, 403, '2024-01-09', NULL, 'Alzheimer', NULL),
('Miguel Sánchez', 50, 406, '2024-01-11', NULL, 'Úlcera Gástrica', 'Aspirina'),
('Ana Torres', 35, 408, '2024-01-13', NULL, 'Migraña Crónica', NULL),
('Roberto García', 65, 409, '2024-01-14', 'neumotorax', 'EPOC', 'Látex'),
('Laura Fernández', 42, 410, '2024-01-15', NULL, 'Fibromialgia', NULL),
('Carlos Moreno', 58, 411, '2024-01-12', NULL, 'Parkinson', NULL),
('Patricia López', 48, 412, '2024-01-13', NULL, 'Esclerosis Múltiple', 'Morfina'),
('Juan Díaz', 70, 413, '2024-01-14', 'Paro cardiaco', 'Insuficiencia Cardíaca', NULL),
('Sofia Navarro', 39, 414, '2024-01-15', NULL, 'Lupus', 'Sulfa'),
('Diego Romero', 66, 415, '2024-01-11', NULL, 'Diabetes Tipo 2', NULL),
('Elena Castro', 52, 416, '2024-01-12', NULL, 'Depresión Mayor', NULL),
('Ricardo Jiménez', 61, 417, '2024-01-13', NULL, 'Cáncer de Pulmón', 'Yodo'),
('Marina Ortiz', 44, 418, '2024-01-14', 'Fallo multiorgánico', 'Politraumatismo', NULL),
('Pablo Serrano', 57, 419, '2024-01-15', NULL, 'Hepatitis C', NULL),
('Lucía Martín', 49, 420, '2024-01-10', NULL, 'Asma', 'Penicilina');


-- ----------------------------------------------------------------------------------------
-- Insertando tratamientos  ---------------------------------------------------------------

INSERT INTO tratamientos (idP, idPM, tipo, fecha, detalles) VALUES
(1, 1, 'Revisión cardíaca', '2024-01-12', 'Paciente presenta arritmia severa. Requiere monitoreo constante'), -- Pista importante
(1, 4, 'Administración medicamentos', '2024-01-15', 'Medicación nocturna administrada a las 22:00'), -- Pista mediana
(1, 2, 'Consulta neurológica', '2024-01-14', 'Paciente reporta mareos y confusión'), -- Pista mediana
(1, 6, 'Evaluación psiquiátrica', '2024-01-13', 'Paciente menciona preocupación por documentos confidenciales'), -- Pista importante
(2, 7, 'Terapia respiratoria', '2024-01-15', 'Ejercicios de respiración realizados'),
(3, 8, 'Control glucemia', '2024-01-15', 'Niveles estables'),
(4, 10, 'Control presión', '2024-01-15', 'Presión arterial: 140/90'),
(5, 13, 'Terapia física', '2024-01-15', 'Ejercicios de movilidad'),
(6, 17, 'Evaluación cognitiva', '2024-01-15', 'Test de memoria realizado'),
(7, 15, 'Endoscopia', '2024-01-15', 'Procedimiento sin complicaciones'),
(8, 2, 'Control cefalea', '2024-01-15', 'Disminución del dolor'),
(9, 7, 'Espirometría', '2024-01-15', 'Función pulmonar reducida'),
(10, 6, 'Terapia del dolor', '2024-01-15', 'Aplicación de técnicas de relajación'),
(1, 5, 'Control rutinario', '2024-01-15', 'Paciente inquieto durante la noche'), -- Pista importante
(12, 2, 'Evaluación neurológica', '2024-01-15', 'Progreso favorable'),
(13, 1, 'Ecocardiograma', '2024-01-15', 'Fracción de eyección 45%'),
(14, 8, 'Control autoinmune', '2024-01-15', 'Marcadores elevados'),
(15, 8, 'Control diabetes', '2024-01-15', 'Ajuste de insulina'),
(16, 6, 'Terapia grupal', '2024-01-15', 'Participación activa'),
(17, 3, 'Quimioterapia', '2024-01-15', 'Tercer ciclo completado');


-- ------------------------------------------------------------------------------------------------------
-- Insertando medicaciones ------------------------------------------------------------------------------

INSERT INTO medicaciones (idP, idPM, nombre, dosis, fecha_administracion) VALUES
(1, 4, 'Amiodarona', '200mg', '2024-01-15'),
(1, 5, 'Penicilina', '0.25mg', '2024-01-15'), -- Medicación alterada
(1, 4, 'Warfarina', '5mg', '2024-01-15'),
(2, 9, 'Azitromicina', '500mg', '2024-01-15'),
(3, 11, 'Insulina', '10U', '2024-01-15'),
(4, 14, 'Enalapril', '10mg', '2024-01-15'),
(5, 16, 'Metotrexato', '7.5mg', '2024-01-15'),
(6, 17, 'Donepezilo', '5mg', '2024-01-15'),
(7, 4, 'Omeprazol', '20mg', '2024-01-15'),
(8, 12, 'Sumatriptán', '50mg', '2024-01-15'),
(9, 7, 'Salbutamol', '100mcg', '2024-01-15'),
(10, 14, 'Pregabalina', '75mg', '2024-01-15'),
(11, 2, 'Levodopa', '100mg', '2024-01-15'),
(12, 12, 'Interferón', '44mcg', '2024-01-15'),
(13, 16, 'Furosemida', '40mg', '2024-01-15'),
(14, 8, 'Hidroxicloroquina', '200mg', '2024-01-15'),
(15, 11, 'Metformina', '850mg', '2024-01-15'),
(16, 6, 'Sertralina', '50mg', '2024-01-15'),
(17, 3, 'Cisplatino', '50mg', '2024-01-15'),
(18, 4, 'Alprazolam', '0.5mg', '2024-01-15');

-- ------------------------------------------------------------------------------------------------------
-- Insertando visitas

INSERT INTO visitas (idP, visitante_nombre, relacion, fecha_visita) VALUES
(1, 'Laura Montenegro', 'Hija', '2024-01-14'),
(1, 'Roberto Montenegro', 'Hijo', '2024-01-15'),
(1, 'Antonio Silva', 'Socio de negocios', '2024-01-14'),
(1, 'Persona desconocida', 'No especificada', '2024-01-15'), -- Pista importante
(2, 'Pedro Gómez', 'Esposo', '2024-01-15'),
(3, 'Carmen Martínez', 'Esposa', '2024-01-15'),
(4, 'Luis Vega', 'Hermano', '2024-01-15'),
(5, 'Ana Pérez', 'Hija', '2024-01-15'),
(6, 'José Ruiz', 'Hijo', '2024-01-15'),
(7, 'María Sánchez', 'Esposa', '2024-01-15'),
(8, 'Carlos Torres', 'Esposo', '2024-01-15'),
(9, 'Elena García', 'Hija', '2024-01-15'),
(10, 'Pablo Fernández', 'Esposo', '2024-01-15'),
(11, 'Sara Moreno', 'Hija', '2024-01-15'),
(12, 'Juan López', 'Esposo', '2024-01-15'),
(13, 'Rosa Díaz', 'Esposa', '2024-01-15'),
(14, 'Miguel Navarro', 'Padre', '2024-01-15'),
(15, 'Isabel Romero', 'Esposa', '2024-01-15'),
(16, 'Alberto Castro', 'Hermano', '2024-01-15'),
(17, 'Teresa Jiménez', 'Esposa', '2024-01-15');

-- ------------------------------------------------------------------------------------------------------
-- Insertando motivos de visitas

INSERT INTO motivos_visitas (idV, motivo) VALUES
(1, 'Visita rutinaria, discusión sobre documentos de la empresa'), -- Pista importante
(2, 'Discusión acalorada sobre la herencia familiar'), -- Pista importante
(3, 'Reunión urgente sobre documentos confidenciales de la empresa'), -- Pista importante
(4, 'Visita breve durante cambio de turno'), -- Pista importante
(5, 'Visita de apoyo'),
(6, 'Traer artículos personales'),
(7, 'Consulta sobre tratamiento'),
(8, 'Visita familiar rutinaria'),
(9, 'Acompañamiento durante la cena'),
(10, 'Traer documentación médica'),
(11, 'Visita de ánimo'),
(12, 'Consulta sobre medicación'),
(13, 'Acompañamiento durante pruebas'),
(14, 'Visita post-operatoria'),
(15, 'Consulta con el médico'),
(16, 'Traer cambio de ropa'),
(17, 'Visita de seguimiento'),
(18, 'Acompañamiento familiar'),
(19, 'Consulta sobre alta médica'),
(20, 'Visita pre-operatoria');

-- ------------------------------------------------------------------------------------------------------
-- Insertando de informes

INSERT INTO Informe (idP, idPM, idT, idM, Fecha_Creacion, detalles, Solucion) VALUES
(1, 1, 1, 1, '2024-01-15', 'Paciente encontrado sin vida a las 23:30. Signos de manipulación en el equipo de monitoreo cardíaco.', 0), -- Informe clave
(1, 4, 2, 2, '2024-01-15', 'Durante la ronda nocturna se observó agitación inusual en el paciente. La dosis de medicación parecía correcta según el registro.', 0), -- Informe clave
(1, 6, 4, 1, '2024-01-14', 'Paciente expresó temor por documentos empresariales que podrían comprometer a varios socios.', 0), -- Informe clave
(2, 7, 5, 4, '2024-01-15', 'Evolución favorable de la neumonía', 0),
(3, 8, 6, 5, '2024-01-15', 'Control rutinario de diabetes', 0),
(4, 10, 7, 6, '2024-01-15', 'Ajuste de medicación antihipertensiva', 0),
(5, 13, 8, 7, '2024-01-15', 'Evaluación de dolor articular', 0),
(6, 17, 9, 8, '2024-01-15', 'Seguimiento de tratamiento de Alzheimer', 0),
(7, 15, 10, 9, '2024-01-15', 'Control post-endoscopia', 0),
(8, 2, 8, 10, '2024-01-15', 'Evaluación de frecuencia de migrañas', 0),
(9, 7, 9, 11, '2024-01-15', 'Control de función respiratoria', 0),
(10, 6, 10, 10, '2024-01-15', 'Evaluación de progreso en manejo del dolor', 0),
(11, 2, 11, 11, '2024-01-15', 'Seguimiento de síntomas de Parkinson', 0),
(12, 12, 12, 12, '2024-01-15', 'Control de lesiones por esclerosis múltiple', 0),
(13, 1, 13, 13, '2024-01-15', 'Evaluación de función cardíaca', 0),
(14, 8, 14, 14, '2024-01-15', 'Monitoreo de síntomas de lupus', 0),
(15, 8, 15, 15, '2024-01-15', 'Ajuste de tratamiento para diabetes', 0),
(1, 5, 14, 2, '2024-01-15', 'Observación de comportamiento errático durante la administración de medicamentos nocturnos. El paciente mencionó que la medicación tenía un sabor diferente.', 0), -- Pista importante
(1, 10, 1, 1, '2024-01-14', 'Revisión de historial cardíaco muestra alteraciones inusuales en los últimos registros de ECG', 0), -- Pista importante
(16, 6, 16, 16, '2024-01-15', 'Evaluación de respuesta a antidepresivos', 0),
(17, 3, 17, 17, '2024-01-15', 'Seguimiento post-quimioterapia', 0),
(1, 4, 2, 1, '2024-01-15', 'Se encontró un vial de Digoxina vacío en el contenedor de residuos, con etiqueta parcialmente borrada', 0), -- Pista importante
(18, 6, 18, 18, '2024-01-15', 'Control de niveles de ansiedad', 0),
(19, 15, 19, 19, '2024-01-15', 'Seguimiento de tratamiento antiviral', 0),
(20, 7, 20, 20, '2024-01-15', 'Control de función pulmonar en paciente asmático', 0),
(1, 2, 3, 1, '2024-01-15', 'El paciente reportó haber visto a alguien manipulando su medicación, pero lo atribuyó a su estado de confusión', 0), -- Pista importante
(1, 17, 4, 2, '2024-01-14', 'Durante la evaluación geriátrica, el paciente mostró documentos relacionados con irregularidades financieras en su empresa', 0), -- Pista importante
(1, 5, 14, 2, '2024-01-15', 'Se detectó que el registro de administración de medicamentos fue modificado después de la hora habitual', 0), -- Pista importante
(1, 1, 1, 1, '2024-01-15', 'Análisis post-mortem preliminar sugiere niveles anormalmente altos de Digoxina en sangre', 0), -- Pista crucial
(1, 6, 4, 1, '2024-01-14', 'El paciente solicitó una caja fuerte para guardar documentos importantes, mencionando que "alguien" había intentado acceder a su habitación', 0), -- Pista importante
(1, 4, 2, 2, '2024-01-15', 'Las cámaras de seguridad del pasillo estuvieron fuera de servicio durante 15 minutos coincidiendo con el cambio de turno', 0); -- Pista final

INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('1', '----------  Bienvenidx a Agatha-----------');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('2', 'Para resolver el misterio vas a necesitar aprender algunos comandos de SQL.');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('3', 'El comando SELECT se utiliza para obtener datos de una base de datos. Es el equivalente a decir \"selecciona\" en inglés.');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('4', 'su forma de escribirlo es: SELECT columna_que_quiero FROM nombre_de_tabla_que_consulto;');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('5', '- Para Obtener todos los nombres de una tabla usa: ');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('6', 'SELECT nombre FROM pacientes;');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('7', '- Puedes obtener todos los valores de todas las columnas de una tabla usando *');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('8', 'SELECT * FROM pacientes;');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('9', '- Para filtrar los  usamos WHERE y lo igualamos (= si es un numero , o LIKE \'%nombre%\' si es un nombre) al valor que queremos:');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('10', 'SELECT * FROM pacientes WHERE nombre like \'%Victor%\'; o SELECT * FROM pacientes WHERE idP = 1; ');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('11', '- ORDER BY te permite ordenar los datos alfabéticamente o por valor numérico');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('12', '- Los id son muy utiles, pues son los numeros asignados a cada paciente o médico, usalos');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('13', 'puedes usarlos para filtrar si no recuerdas el nombre. ');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('14', '- Las tablas del hospital ( y los ID, id+primera letra de la tabla)  se llaman: pacientes (idP), personal_medico (idPM), visitas (idV), tratamientos(idT), medicaciones, motivos_visitas, informe e instrucciones');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('15', '- Cuando tengas idea de la solución usa la funcion especial CALL ');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('16', 'CALL el_asesino_es('aqui escribes el nombre el asesino');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('17', '');
INSERT INTO `HOSPITAL`.`Instrucciones` (`id_Instrucciones`, `Instrucciones`) VALUES ('18', '+-+-+-+-+-+-+-+-+-+-+-¡¡Suerte!! -+-+-+-+-+-+-+-+-++-          ');

-- ------------------------------------------------------------------------------------------------------
-- ------------------------------------        Soluciones         ---------------------------------------
-- ------------------------------------------------------------------------------------------------------



-- ------------------------------------------------------------------------------------------------------
-- Insertando de soluciones       -----------------------------------------------------------------

INSERT INTO `HOSPITAL`.`solucion` (`id_solucion`,`idPM`, `sospechoso`,`Comentario`) 
VALUES 
(1,1, 'Dr. Ricardo Manzano', 'Vaya, Fallaste. El culpable sigue suelto.'),
(2,2,'Dra. Elena Torres', 'Vaya, Fallaste. El culpable sigue suelto.'),
(3,3,'Dr. Carlos Ruiz', 'Vaya, Fallaste. El culpable sigue suelto.'),
(4,4,'Enfermera Ana López', 'Vaya, Fallaste. El culpable sigue suelto.'),
(5,5,'Enfermero Juan Díaz', 'Enhorabuena!!!, has cogido al asesino Juan díaz, fue contratado por el socio de Victor para darle una dosis extra de la medicación a la que era alérgico'), -- Sospechoso principal
(6,6,'Dra. Marina Silva', 'Vaya, Fallaste. El culpable sigue suelto.'),
(7,7,'Dr. Francisco Mora', 'Vaya, Fallaste. El culpable sigue suelto.'),
(8,8,'Dra. Lucía Ramírez', 'Vaya, Fallaste. El culpable sigue suelto.'),
(9,9,'Enfermera Patricia Vega', 'Vaya, Fallaste. El culpable sigue suelto.'),
(10,10,'Dr. Alberto Sanz', 'Vaya, Fallaste. El culpable sigue suelto.'),
(11,11,'Enfermero Miguel Ángel', 'Vaya, Fallaste. El culpable sigue suelto.'),
(12,12,'Dra. Sara Jiménez', 'Vaya, Fallaste. El culpable sigue suelto.'),
(13,13,'Dr. Pablo Ortiz', 'Vaya, Fallaste. El culpable sigue suelto.'),
(14,14,'Enfermera Rosa Martín', 'Vaya, Fallaste. El culpable sigue suelto.'),
(15,15,'Dr. Javier Luna', 'Vaya, Fallaste. El culpable sigue suelto.'),
(16,16,'Enfermero David Gil', 'Vaya, Fallaste. El culpable sigue suelto.'),
(17,17,'Dra. Carmen Flores', 'Vaya, Fallaste. El culpable sigue suelto.'),
(18,18,'Enfermera Laura Santos', 'Vaya, Fallaste. El culpable sigue suelto.'),
(19,19,'Dr. Andrés Vargas', 'Vaya, Fallaste. El culpable sigue suelto.'),
(20,20,'Enfermero Roberto Núñez', 'Vaya, Fallaste. El culpable sigue suelto.');


-- ------------------------------------------------------------------------------------------------------------------
-- ------------------------------------  La CALL que resuelve el misterio -------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE el_asesino_es(
in nombre_asesino varchar(100))

BEGIN
    
    SELECT Comentario 
    FROM solucion 
    WHERE sospechoso LIKE CONCAT('%', nombre_asesino, '%');
    
END //

DELIMITER ;
