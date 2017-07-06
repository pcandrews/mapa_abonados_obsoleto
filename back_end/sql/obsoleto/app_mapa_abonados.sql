Datos mysql:

usuario: ccc_admin
pass: sanlorenzo


*******************************************************
*******************************************************


SQL:
*******************************************************

Crear usuario con contraseña:

CREATE USER 'ccc_admin' IDENTIFIED BY 'sanlorenzo'


Garantizar privilegios usuario:
*******************************************************
REVOKE ALL PRIVILEGES ON *.* FROM 'ccc_admin'@'%'; GRANT ALL PRIVILEGES ON *.* TO 'ccc_admin'@'%' REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;

Nota: aqui estoy dandole todos los privilegios, seria conveniente restringirlos en el futuro.

*******************************************************
Base de datos:

CREATE DATABASE IF NOT EXISTS app_mapa_abonados
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_spanish_ci


*******************************************************
Privilegios usuario:

GRANT ALL PRIVILEGES ON app_mapa_abonados.* TO ccc_admin@localhost 

//no hace falta, ya q tiene todos los privilegios garantizados, pero para luego si ESTO ES IMPORTANTE.

FLUSH PRIVILEGES; //refrescar todos los privilegios. siempre que haya un cambio de privilegios.


*******************************************************










OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 
OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO OBSOLETO 







Tablas creadas:

CREATE TABLE IF NOT EXISTS app_mapa_abonados.abonados (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
numero_abonado INT,
nombre_abonado VARCHAR(255),
calle_abonado VARCHAR(255),
municipio_abonado VARCHAR(255),
estado_abonado INT,
servicios_abonado VARCHAR(255),
lat_abonado DOUBLE DEFAULT 0,
lon_abonado DOUBLE DEFAULT 0,
punto_gps GEOMETRY,
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci

CREATE TABLE IF NOT EXISTS app_mapa_abonados.instalaciones (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
nombre_dispositivo VARCHAR(255),
mac_dispositivo VARCHAR(255),
codigo_instalación INT,
observaciones_instalacion TEXT,
fecha_instalacion DATETIME,
año_instalacion DATETIME,
mes_instalacion DATETIME,
dia_instalacion DATETIME,
fecha_y_hora_instalacion DATETIME,
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci

CREATE TABLE IF NOT EXISTS app_mapa_abonados.fotos (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
nombre_foto VARCHAR(255),
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci


*******************************************************
Insertar un punto gps desde texto:

INSERT INTO geom VALUES (GeomFromText('POINT(1 1)'));

*******************************************************
EXTRA:

LOAD DATA INFILE '/home/pablo/Proyectos/Apache/MapaAbonados/MapaActual/csv/abonados/abonados_yb.csv' INTO TABLE `abonados_mapa_yb` FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';







*******************************************************
id_celular, mac_celular, numero_abonado, punto_gps, punto_gps2, observaciones_instalacion

estoy usando esta por problemas para llenar la base de datos:
CREATE TABLE IF NOT EXISTS app_mapa_abonados.temp (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
id_celular VARCHAR(255),
mac_celular VARCHAR(255),
numero_abonado VARCHAR(255),
punto_gps VARCHAR(255),
punto_gps2 VARCHAR(255),
observaciones_instalacion TEXT,
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci



Si borro "local" sale el error de proteccion.

LOAD DATA LOCAL INFILE "/home/pablo/uhfApp/csv/movil-61/20160818.csv" 
REPLACE INTO TABLE app_mapa_abonados.temp FIELDS TERMINATED BY '",' 
LINES TERMINATED BY '\n' 
(@v_id_celular, @v_mac_celular, @v_numero_abonado, @v_punto_gps, @v_punto_gps2, @v_observaciones_instalacion) 
SET id_celular = SUBSTR(TRIM(@v_id_celular), 2), 
mac_celular = SUBSTR(TRIM(@v_mac_celular), 2), 
numero_abonado = SUBSTR(TRIM(@v_numero_abonado), 2), 
punto_gps = SUBSTR(TRIM(@v_punto_gps), 2), 
punto_gps2 = SUBSTR(TRIM(@v_punto_gps2), 2), 
observaciones_instalacion = SUBSTR(TRIM(@v_observaciones_instalacion), 2), 
observaciones_instalacion = SUBSTRING(observaciones_instalacion, 1, LENGTH(observaciones_instalacion)-1)

***




esta es la deberia ser:
CREATE TABLE IF NOT EXISTS app_mapa_abonados.temp (
id INT NOT NULL AUTO_INCREMENT UNIQUE,
id_celular VARCHAR(255),
mac_celular VARCHAR(255),
numero_abonado INT,
punto_gps GEOMETRY,
punto_gps2 VARCHAR(255),
observaciones_instalacion TEXT,
PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci




LOAD DATA LOCAL INFILE "/home/pablo/uhfApp/csv/movil-61/20160818.csv" 
REPLACE INTO TABLE app_mapa_abonados.temp FIELDS TERMINATED BY '",' 
LINES TERMINATED BY '\n' 
(@v_id_celular, @v_mac_celular, @v_numero_abonado, @v_punto_gps, @v_punto_gps2, @v_observaciones_instalacion) 
SET id_celular = SUBSTR(TRIM(@v_id_celular), 2), 
mac_celular = SUBSTR(TRIM(@v_mac_celular), 2), 
numero_abonado = SUBSTR(TRIM(@v_numero_abonado), 2), 
punto_gps = SUBSTR(TRIM(@v_punto_gps), 2),
punto_gps = GeomFromText('POINT(SUBSTR(TRIM(@v_punto_gps), 2))'),
punto_gps2 = SUBSTR(TRIM(@v_punto_gps2), 2), 
observaciones_instalacion = SUBSTR(TRIM(@v_observaciones_instalacion), 2), 
observaciones_instalacion = SUBSTRING(observaciones_instalacion, 1, LENGTH(observaciones_instalacion)-1)



esto funciona, carga el dato, pero de una forma q no entiendo:
LOAD DATA LOCAL INFILE "/home/pablo/uhfApp/csv/movil-61/20160818.csv" 
REPLACE INTO TABLE app_mapa_abonados.temp FIELDS TERMINATED BY '",' 
LINES TERMINATED BY '\n' 
(@v_id_celular, @v_mac_celular, @v_numero_abonado, @v_punto_gps, @v_punto_gps2, @v_observaciones_instalacion) 
SET id_celular = SUBSTR(TRIM(@v_id_celular), 2), 
mac_celular = SUBSTR(TRIM(@v_mac_celular), 2), 
numero_abonado = SUBSTR(TRIM(@v_numero_abonado), 2), 
punto_gps = POINT(-26.83542764,-65.20819931),
punto_gps2 = SUBSTR(TRIM(@v_punto_gps2), 2), 
observaciones_instalacion = SUBSTR(TRIM(@v_observaciones_instalacion), 2), 
observaciones_instalacion = SUBSTRING(observaciones_instalacion, 1, LENGTH(observaciones_instalacion)-1)