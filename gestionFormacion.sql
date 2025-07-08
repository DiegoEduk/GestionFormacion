
CREATE DATABASE gestion_formacion CHARACTER SET utf8 COLLATE utf8_general_ci;

USE gestion_formacion;

-- insertar 32 regionales
CREATE TABLE regional(
    cod_regional INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(80)
);

INSERT INTO regional(cod_regional,nombre) VALUES (66, 'REGIONAL RISARALDA');

-- crud completo
CREATE TABLE centro_formacion(
    cod_centro INT UNSIGNED PRIMARY KEY,
    nombre_centro VARCHAR(80),
    cod_regional INT UNSIGNED,
    FOREIGN KEY (cod_regional) REFERENCES regional(cod_regional)
);


INSERT INTO centro_formacion(cod_centro, nombre_centro, cod_regional)
VALUES (9121, 'CENTRO ATENCION SECTOR AGROPECUARIO', 66);

ALTER TABLE programa_formacion MODIFY COLUMN nombre VARCHAR(130);
-- ya está
CREATE TABLE programa_formacion(
    cod_programa INT UNSIGNED,
    la_version TINYINT UNSIGNED,
    nombre VARCHAR(130),
    horas_lectivas INT, -- editables
    horas_productivas INT, -- editables
    PRIMARY KEY (cod_programa, la_version)
);
-- llenar con carga del archivo reporte de juicios de evaluacion
CREATE TABLE competencia(
    cod_competencia INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(160),
    horas INT UNSIGNED -- editable
);
-- llenar con carga del archivo reporte de juicios de evaluacion
CREATE TABLE resultado_aprendizaje(
    cod_resultado INT UNSIGNED PRIMARY KEY,
    nombre  VARCHAR(180),
    cod_competencia INT UNSIGNED,
    FOREIGN KEY (cod_competencia) REFERENCES competencia(cod_competencia)
);
-- llenar con carga del archivo reporte de juicios de evaluacion
CREATE TABLE programa_competencia(
    cod_prog_competencia INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cod_programa INT UNSIGNED,
    la_version TINYINT UNSIGNED,
    cod_competencia INT UNSIGNED,
    FOREIGN KEY (cod_programa, la_version) REFERENCES programa_formacion(cod_programa, la_version),
    FOREIGN KEY (cod_competencia) REFERENCES competencia(cod_competencia)
);

-- archivo PE04 

CREATE TABLE grupo(
    cod_ficha INT UNSIGNED,
    cod_centro INT UNSIGNED,
    cod_programa INT UNSIGNED,
    la_version TINYINT UNSIGNED,
    estado_grupo VARCHAR(30),
    nombre_nivel VARCHAR(40),
    jornada VARCHAR(15),
    fecha_inicio DATE,
    fecha_fin DATE,
    etapa VARCHAR (20),
    modalidad VARCHAR(30),
    responsable VARCHAR(60),
    nombre_empresa VARCHAR(40),
    nombre_municipio VARCHAR(30),
    nombre_programa_especial VARCHAR(60),
    hora_inicio TIME, -- editable
    hora_fin TIME, -- editable
    id_ambiente INT UNSIGNED, -- editable
    PRIMARY KEY (cod_ficha),
    FOREIGN KEY(cod_centro) REFERENCES centro_formacion(cod_centro),
    FOREIGN KEY (cod_programa, la_version) REFERENCES programa_formacion(cod_programa, la_version),
    FOREIGN KEY(id_ambiente) REFERENCES ambiente_formacion(id_ambiente)
);

CREATE TABLE datos_grupo(
    cod_ficha INT UNSIGNED, -- pe04
    num_aprendices_masculinos  TINYINT UNSIGNED,
    num_aprendices_femenino  TINYINT UNSIGNED,
    num_aprendices_no_binario  TINYINT UNSIGNED,
    num_total_aprendices  TINYINT UNSIGNED,
    num_total_aprendices_activos  TINYINT UNSIGNED, -- pe04
    cupo_total  TINYINT UNSIGNED, -- DF14A
    en_transito  TINYINT UNSIGNED,
    induccion  TINYINT UNSIGNED,
    formacion  TINYINT UNSIGNED,
    condicionado  TINYINT UNSIGNED,
    aplazado  TINYINT UNSIGNED,
    retiro_voluntuario  TINYINT UNSIGNED,
    cancelado  TINYINT UNSIGNED,
    cancelamiento_vit_comp  TINYINT UNSIGNED,
    desercion_vit_comp  TINYINT UNSIGNED,
    por_certificar  TINYINT UNSIGNED,
    certificados  TINYINT UNSIGNED,
    traslados  TINYINT UNSIGNED,
    otro  TINYINT UNSIGNED, -- DF14A
    FOREIGN KEY(cod_ficha) REFERENCES grupo(cod_ficha),
    PRIMARY KEY(cod_ficha)
);


CREATE TABLE rol(
    id_rol INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(30)
);

INSERT INTO rol (id_rol, nombre) VALUES 
(1, 'superadmin'),
(2, 'admin'),
(3, 'instructor');

-- crud completo
CREATE TABLE usuario(
    id_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(80),
    identificacion CHAR(12),
    id_rol INT UNSIGNED,
    correo VARCHAR(100) UNIQUE,
    pass_hash VARCHAR(100),
    tipo_contrato VARCHAR(50),
    telefono VARCHAR(15),
    estado BOOLEAN,
    cod_centro INT UNSIGNED,
    FOREIGN KEY(id_rol) REFERENCES rol(id_rol),
    FOREIGN KEY(cod_centro) REFERENCES centro_formacion(cod_centro)
);

-- crud completo
CREATE TABLE grupo_instructor(
    cod_ficha INT UNSIGNED,
    id_instructor INT UNSIGNED,
    PRIMARY KEY (cod_ficha, id_instructor),
    FOREIGN KEY(cod_ficha) REFERENCES grupo(cod_ficha),
    FOREIGN KEY(id_instructor) REFERENCES usuario(id_usuario)
);

-- CRUD completo 2 versiones
CREATE TABLE programacion(
    id_programacion INT UNSIGNED AUTO_INCREMENT,
    id_instructor INT UNSIGNED,
    cod_ficha INT UNSIGNED,
    fecha_programada DATE,
    horas_programadas INT,
    hora_inicio TIME,
    hora_fin TIME,
    cod_competencia INT UNSIGNED,
    cod_resultado INT UNSIGNED,
    id_user INT UNSIGNED,
    PRIMARY KEY(id_programacion),
    FOREIGN KEY(id_instructor) REFERENCES usuario(id_usuario),
    FOREIGN KEY(cod_ficha) REFERENCES grupo(cod_ficha),
    FOREIGN KEY(cod_competencia) REFERENCES competencia(cod_competencia),
    FOREIGN KEY(cod_resultado) REFERENCES resultado_aprendizaje(cod_resultado),
    FOREIGN KEY(id_user) REFERENCES usuario(id_usuario)
);

-- CRUD COMPLETO
CREATE TABLE metas(
    id_meta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    anio YEAR,
    cod_centro INT UNSIGNED,
    concepto VARCHAR(100),
    valor INT UNSIGNED,
    FOREIGN KEY(cod_centro) REFERENCES centro_formacion(cod_centro)
);

-- CRUD COMPLETO o cargar los festivos hasta el 2030
CREATE TABLE festivos(
    festivo DATE PRIMARY KEY
);

-- CRUD COMPLETO
CREATE TABLE ambiente_formacion(
    id_ambiente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_ambiente VARCHAR(40),
    num_max_aprendices TINYINT UNSIGNED,
    municipio VARCHAR(40),
    ubicacion VARCHAR(80),
    cod_centro INT UNSIGNED,
    estado BOOLEAN, -- True Activo   False Inactivo
    FOREIGN KEY(cod_centro) REFERENCES centro_formacion(cod_centro)
);
