Datos mysql:

usuario: ccc_admin
pass: sanlorenzo


*******************************************************
*******************************************************


SQL:
*******************************************************

Crear usuario con contraseña:

CREATE USER 'ccc_admin' IDENTIFIED BY 'sanlorenzo';


Garantizar privilegios usuario:
*******************************************************
REVOKE ALL PRIVILEGES ON *.* FROM 'ccc_admin'@'%'; GRANT ALL PRIVILEGES ON *.* TO 'ccc_admin'@'%' REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;

Nota: aqui estoy dandole todos los privilegios, seria conveniente restringirlos en el futuro.

*******************************************************
Base de datos:

CREATE DATABASE IF NOT EXISTS ccc
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_spanish_ci;


*******************************************************
Privilegios usuario:

GRANT ALL PRIVILEGES ON ccc.* TO ccc_admin@localhost; 

//no hace falta, ya q tiene todos los privilegios garantizados, pero para luego si ESTO ES IMPORTANTE.

FLUSH PRIVILEGES; //refrescar todos los privilegios. siempre que haya un cambio de privilegios.


******************************************************ç

normalizacion 1,2,3 y restricciones

Tablas:

/* MUY IMPORTANTE - FALTA HACER LAS RESTRICCIONES */

CREATE TABLE IF NOT EXISTS ccc.personas (
	dni_per INT(11) NOT NULL UNIQUE,
	nombres_per VARCHAR(100),
	apellidos_per VARCHAR(50),
	PRIMARY KEY(dni_per)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.abonados (
	numero_abo INT(11) NOT NULL UNIQUE,
	dni_abo INT(11) NOT NULL UNIQUE,
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(numero_abo),
	FOREIGN KEY (dni_abo) REFERENCES ccc.personas (dni_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * En esta falta informacion para poder hacerla correctamente, realidad el dni deberia ser el 
**/
CREATE TABLE IF NOT EXISTS ccc.empleados (
	dni_emp INT (11) NOT NULL UNIQUE,
	PRIMARY KEY(dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES ccc.personas (dni_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.coordenadas_gps (
	id_coord_gps INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	lat FLOAT(10,6) NOT NULL,
	lng FLOAT(10,6) NOT NULL,	
	punto_gps_dcml VARCHAR(255),
	punto_gps_sexa VARCHAR(255),
	PRIMARY KEY(id_coord_gps)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.domicilios_abonados (
	id_dom_abo INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abonado_dom_abo INT(11) NOT NULL UNIQUE,
	id_coord_gps_dom_abo INT(11) NOT NULL UNIQUE,
	calle_dom_abo VARCHAR(255),
	numero_dom_abo INT(11),
	dpto_dom_abo VARCHAR(3),
	piso_dom_abo INT(3),
	barrio_dom_abo VARCHAR(255),
	municipio_dom_abo VARCHAR(255),
	zona_ccc_dom_abo VARCHAR (10),
	PRIMARY KEY(id_dom_abo),
	FOREIGN KEY (numero_abonado_dom_abo) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_coord_gps_dom_abo) REFERENCES ccc.coordenadas_gps (id_coord_gps) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.domicilios_empleados (
	id_dom_emp INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	dni_dom_emp INT (11) NOT NULL UNIQUE,
	calle_dom_emp VARCHAR(255),
	numero_dom_emp INT(10),
	dpto_dom_emp VARCHAR(3),
	piso_dom_emp INT(3),
	barrio_dom_emp VARCHAR(255),
	municipio_dom_emp VARCHAR(255),
	zona_ccc_dom_emp VARCHAR (10),
	lat_dom_emp FLOAT(10, 6) NOT NULL,
	lng_dom_emp FLOAT(10, 6) NOT NULL,	
	punto_gps_dcml_dom_emp VARCHAR(255),
	punto_gps_sexa_dom_emp VARCHAR(255),
	PRIMARY KEY(id_dom_emp),
	FOREIGN KEY (dni_dom_emp) REFERENCES ccc.empleados (dni_emp) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.factura_abonado (
	numero_fac_abo INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abonado_fac_abo INT(11) NOT NULL UNIQUE,
	FOREIGN KEY (numero_abonado_fac_abo) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.instalores_servicios (
	dni_instrs_serv INT (11) NOT NULL UNIQUE,
	PRIMARY KEY(dni_instrs_serv),
	FOREIGN KEY (dni_instrs_serv) REFERENCES ccc.empleados (dni_emp) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.orden_trabajo (
	numero_ord_tra INT (11) NOT NULL UNIQUE,
	dni_ord_tra_instrs_serv INT(11) NOT NULL UNIQUE,
	PRIMARY KEY(numero_ord_tra),
	FOREIGN KEY (dni_ord_tra_instrs_serv) REFERENCES instalores_servicios (dni_instrs_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	 nombre_cel_inst_serv era antes id_celular de la tabla instalaciones, el nombre del dispostivo
**/
CREATE TABLE IF NOT EXISTS ccc.celulares_instalaciones_servicios (
	id_cel_inst_serv INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	nombre_cel_inst_serv VARCHAR(255),
	mac_cel_inst_serv VARCHAR(255),
	observaciones_cel_inst_serv TEXT,
	PRIMARY KEY(id_cel_inst_serv)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.instalaciones_servicios (
	numero_inst_serv INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abonado_inst_serv INT(11) NOT NULL UNIQUE,
	id_inst_serv INT(11) NOT NULL UNIQUE,
	dni_instalador_inst_serv INT (11) NOT NULL UNIQUE,
	codigo_inst_serv INT(11),
	observaciones_inst_serv TEXT,
	fecha_y_hora_inst_serv DATETIME,
	PRIMARY KEY(numero_inst_serv),
	FOREIGN KEY (numero_abonado_inst_serv) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.celulares_instalaciones_servicios (id_cel_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (dni_instalador_inst_serv) REFERENCES ccc.instalores_servicios (dni_instrs_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.servicio_celulares (
	id_serv_cel INT(11) NOT NULL UNIQUE,
	empresa_serv_cel VARCHAR(30),
	servicio_serv_cel VARCHAR(30),
	numero_serv_cel INT(7),
	PRIMARY KEY(id_serv_cel),
	FOREIGN KEY (id_serv_cel) REFERENCES ccc.celulares_instalaciones_servicios (id_cel_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.rutas_archivos_instalaciones (
	numero_inst_rut_arch_inst INT(11) NOT NULL UNIQUE,
	csv_rut_arch_inst VARCHAR(255),
	kml_rut_arch_inst VARCHAR(255),
	foto_rut_arch_inst VARCHAR(255),
	PRIMARY KEY(numero_inst_rut_arch_inst),
	FOREIGN KEY (numero_inst_rut_arch_inst) REFERENCES ccc.instalaciones_servicios (numero_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


