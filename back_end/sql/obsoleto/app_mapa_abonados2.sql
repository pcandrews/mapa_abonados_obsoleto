Estas y solo estas son las tablas que estoy utilizando.
Reemplazar en app_mapa_abonados.sql 

Tablas creadas:

CREATE TABLE IF NOT EXISTS app_mapa_abonados.abonados (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
numero_abonado INT(11) UNIQUE,
nombre_abonado VARCHAR(255),
calle_abonado VARCHAR(255),
municipio_abonado VARCHAR(255),
estado_abonado INT(11),
servicios_abonado VARCHAR(255),
punto_gps_string VARCHAR(255),
lat_abonado DOUBLE DEFAULT 0,
lon_abonado DOUBLE DEFAULT 0,
punto_gps GEOMETRY,
punto_gps2 VARCHAR(255),
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci

id_celular, mac_celular, numero_abonado, punto_gps, punto_gps2, observaciones_instalacion

LOAD DATA LOCAL INFILE \"{$archivos_csv[$i]}\" 
REPLACE INTO TABLE app_mapa_abonados.abonados FIELDS TERMINATED BY '\",' 
LINES TERMINATED BY '\\n' 
(@dummy, @dummy, @v_numero_abonado, @v_punto_gps_string, @v_punto_gps2, @dummy) 
SET numero_abonado = CAST(SUBSTR(TRIM(@v_numero_abonado), 2) AS UNSIGNED), 
	punto_gps_string = SUBSTR(TRIM(@v_punto_gps_string), 2), 
	punto_gps2 = SUBSTR(TRIM(@v_punto_gps2), 2)

***

CREATE TABLE IF NOT EXISTS app_mapa_abonados.instalaciones (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
numero_abonado INT(11),
id_celular VARCHAR(255),
mac_celular VARCHAR(255),
codigo_instalación INT(11),
observaciones_instalacion TEXT,
fecha_instalacion DATETIME,
año_instalacion DATETIME,
mes_instalacion DATETIME,
dia_instalacion DATETIME,
fecha_y_hora_instalacion DATETIME,
FOREIGN KEY (numero_abonado) REFERENCES app_mapa_abonados.abonados (numero_abonado)
ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci

id_celular, mac_celular, numero_abonado, punto_gps, punto_gps2, observaciones_instalacion

LOAD DATA LOCAL INFILE \"{$archivos_csv[$i]}\" 
REPLACE INTO TABLE app_mapa_abonados.instalaciones FIELDS TERMINATED BY '\",' 
LINES TERMINATED BY '\\n' 
(@v_id_celular, @v_mac_celular, @v_numero_abonado, @dummy, @dummy, @v_observaciones_instalacion) 
SET id_celular = SUBSTR(TRIM(@v_id_celular), 2), 
	mac_celular = SUBSTR(TRIM(@v_mac_celular), 2), 
	numero_abonado = CAST(SUBSTR(TRIM(@v_numero_abonado), 2) AS UNSIGNED),
	observaciones_instalacion = SUBSTR(TRIM(@v_observaciones_instalacion), 2), 
	observaciones_instalacion = SUBSTRING(observaciones_instalacion, 1, LENGTH(observaciones_instalacion)-1)

***

CREATE TABLE IF NOT EXISTS app_mapa_abonados.fotos (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
numero_abonado INT(11),
ruta_foto VARCHAR(255),
FOREIGN KEY (numero_abonado) REFERENCES app_mapa_abonados.abonados (numero_abonado)
ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci

INSERT INTO app_mapa_abonados.fotos (ruta_foto, numero_abonado) 
VALUES ('{$archivos_jpg[$i]}',(SELECT DISTINCT numero_abonado FROM app_mapa_abonados.abonados WHERE numero_abonado=$aux))

***