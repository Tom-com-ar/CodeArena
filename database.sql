-- Base de datos para CodeArena
-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS codearena;
USE codearena;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol ENUM('usuario', 'admin') DEFAULT 'usuario',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_login TIMESTAMP NULL
);

-- Tabla de problemas
CREATE TABLE problemas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    dificultad ENUM('facil', 'medio', 'dificil') NOT NULL,
    categoria VARCHAR(50),
    entrada_ejemplo TEXT,
    salida_ejemplo TEXT,
    tiempo_limite INT DEFAULT 1000, -- en ms
    memoria_limite INT DEFAULT 256, -- en MB
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de envíos
CREATE TABLE envios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    problema_id INT NOT NULL,
    codigo TEXT NOT NULL,
    lenguaje VARCHAR(50) NOT NULL,
    resultado ENUM('aceptado', 'rechazado', 'tiempo_limite', 'error_compilacion', 'error_ejecucion') NOT NULL,
    tiempo_ejecucion INT, -- en ms
    memoria_usada INT, -- en MB
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (problema_id) REFERENCES problemas(id)
);

-- Tabla de torneos
CREATE TABLE torneos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de participación en torneos
CREATE TABLE participaciones_torneo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    torneo_id INT NOT NULL,
    usuario_id INT NOT NULL,
    puntuacion INT DEFAULT 0,
    posicion INT,
    fecha_participacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (torneo_id) REFERENCES torneos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    UNIQUE KEY unique_participacion (torneo_id, usuario_id)
);

-- Tabla de ranking global
CREATE TABLE ranking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    puntuacion_total INT DEFAULT 0,
    problemas_resueltos INT DEFAULT 0,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    UNIQUE KEY unique_usuario (usuario_id)
);

-- Índices para mejorar rendimiento
CREATE INDEX idx_envios_usuario ON envios (usuario_id);
CREATE INDEX idx_envios_problema ON envios (problema_id);
CREATE INDEX idx_envios_resultado ON envios (resultado);
CREATE INDEX idx_ranking_puntuacion ON ranking (puntuacion_total DESC);