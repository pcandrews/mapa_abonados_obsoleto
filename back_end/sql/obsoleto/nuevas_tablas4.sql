/* MUY IMPORTANTE - FALTA HACER LAS RESTRICCIONES */


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
	id_per INT (11) NOT NULL UNIQUE,
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



CREATE TABLE IF NOT EXISTS ccc.lugares (
	id_lug INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_lug)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;





CREATE TABLE IF NOT EXISTS ccc.coordenadas_gps (
	id_lug INT (11) NOT NULL UNIQUE,
	lat FLOAT(10,6) NOT NULL,
	lng FLOAT(10,6) NOT NULL,	
	punto_gps_dcml VARCHAR(255),
	punto_gps_sexa VARCHAR(255),
	PRIMARY KEY(id_lug),
	FOREIGN KEY (id_lug) REFERENCES ccc.lugares (id_lug) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.direcciones (
	id_lug INT (11) NOT NULL UNIQUE,
	calle VARCHAR(255),
	numero INT(10),
	dpto VARCHAR(3),
	piso INT(3),
	barrio VARCHAR(255),
	municipio VARCHAR(255),
	zona VARCHAR (10),
	detalles TEXT,
	PRIMARY KEY(id_lug),
	FOREIGN KEY (id_lug) REFERENCES ccc.lugares (id_lug) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;