/* MUY IMPORTANTE - FALTA HACER LAS RESTRICCIONES */


/**
 *	Primary key: dni.
**/
CREATE TABLE IF NOT EXISTS ccc.personas (
	id_per INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	dni INT(11) NOT NULL UNIQUE,
	nombres VARCHAR(100),
	apellidos VARCHAR(50),
	PRIMARY KEY(dni)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;

/**
 *	Primary key: numero_abo.
 *	Foreing key: dni_abo.
**/
CREATE TABLE IF NOT EXISTS ccc.abonados (
	numero_abo INT(11) NOT NULL UNIQUE,	
	dni_abo INT(11) NOT NULL UNIQUE,
	cant_abo INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(numero_abo),
	FOREIGN KEY (dni_abo) REFERENCES ccc.personas (dni) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * En esta falta informacion para poder hacerla correctamente, realidad el dni deberia ser el 
 * usar metodos mysql para espacio poointfromsting o algo asi y demas
**/
CREATE TABLE IF NOT EXISTS ccc.empleados (
	dni_emp INT (11) NOT NULL UNIQUE,
	cant_emp INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES ccc.personas (dni) 
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


CREATE TABLE IF NOT EXISTS ccc.direcciones (/* MUY IMPORTANTE - FALTA HACER LAS RESTRICCIONES */


/**
 *	Primary key: dni.
**/
CREATE TABLE IF NOT EXISTS ccc.personas (
	id_per INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	dni INT(11) NOT NULL UNIQUE,
	nombres VARCHAR(100),
	apellidos VARCHAR(50),
	PRIMARY KEY(id_per)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;

/**
 *	Primary key: numero_abo.
 *	Foreing key: dni_abo.
**/
CREATE TABLE IF NOT EXISTS ccc.abonados (
	id_per INT(11) NOT NULL UNIQUE,
	numero_abo INT(11) NOT NULL UNIQUE,
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(id_per),
	FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * En esta falta informacion para poder hacerla correctamente, realidad el dni deberia ser el 
 * usar metodos mysql para espacio poointfromsting o algo asi y demas
**/
CREATE TABLE IF NOT EXISTS ccc.empleados (
	id_per INT(11) NOT NULL UNIQUE,
	PRIMARY KEY(id_per),
	FOREIGN KEY (id_per) REFERENCES ccc.personas (dni) 
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


CREATE TABLE IF NOT EXISTS ccc.direcciones (
	id_dir INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	calle VARCHAR(255),
	numero INT(10),
	dpto VARCHAR(3),
	piso INT(3),
	barrio VARCHAR(255),
	municipio VARCHAR(255),
	zona VARCHAR (10),
	detalles TEXT,
	PRIMARY KEY(id_dir)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.lugar (
	id_lug INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	id_coord_gps INT(11) NOT NULL UNIQUE,
	id_dir INT(11) NOT NULL UNIQUE,
	PRIMARY KEY(id_lug),
	FOREIGN KEY (id_coord_gps) REFERENCES ccc.coordenadas_gps (id_coord_gps) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_lug) REFERENCES ccc.direcciones (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;
	municipio VARCHAR(255),
	zona VARCHAR (10),
	detalles TEXT,
	PRIMARY KEY(id_dir)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.lugar (
	id_lug INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_lug)
	FOREIGN KEY (id_lug) REFERENCES ccc.lugar (id_lug) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
	FOREIGN KEY (id_lug) REFERENCES ccc.direcciones (id_dirlug) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


