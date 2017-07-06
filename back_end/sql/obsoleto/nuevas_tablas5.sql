/**
 * 	Hacer:
 * 	· Restricciones.
 */


/**
 *	Indice general para mantener la relacion entre tablas, sin aparente relacion.
 */
CREATE TABLE IF NOT EXISTS ccc.items (
	id_item INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_item)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.personas (
	id_per INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	id_item INT(11) UNSIGNED NOT NULL UNIQUE,
	dni INT(11) UNSIGNED NULL UNIQUE,
	nombres VARCHAR(255),
	apellidos VARCHAR(255),
	PRIMARY KEY(id_per),
	FOREIGN KEY (id_item) REFERENCES ccc.items (id_item) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;

/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.coordenadas_gps (
	id_coord_gps INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	id_item INT(11) UNSIGNED NOT NULL UNIQUE,
	lat FLOAT(10,6) NULL,
	lng FLOAT(10,6) NULL,
	punto_gps_dcml VARCHAR(255),
	punto_gps_sexa VARCHAR(255),
	PRIMARY KEY(id_coord_gps),
	FOREIGN KEY (id_item) REFERENCES ccc.items (id_item) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/*************************************************************************************************************/


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.abonados (
	id_per INT(11) UNSIGNED NOT NULL UNIQUE,
	numero_abo INT(11) DEFAULT NULL UNIQUE, /* probar con not null*/
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(id_per),
	FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * En esta falta informacion para poder hacerla correctamente, realidad el dni deberia ser el 
 * usar metodos mysql para espacio pooINT(11)fromsting o algo asi y demas
 */
CREATE TABLE IF NOT EXISTS ccc.empleados (
	id_per INT(11) UNSIGNED NOT NULL UNIQUE,
	PRIMARY KEY(id_per),
	FOREIGN KEY (id_per) REFERENCES ccc.personas (dni) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.direcciones (
	id_coord_gps INT(11) UNSIGNED NOT NULL UNIQUE,
	calle VARCHAR(255),
	numero INT(11),
	dpto VARCHAR(255),
	piso INT(11),
	barrio VARCHAR(255),
	municipio VARCHAR(255),
	zona VARCHAR (255),
	detalles TEXT,
	PRIMARY KEY(id_coord_gps),
	FOREIGN KEY (id_coord_gps) REFERENCES ccc.coordenadas_gps (id_coord_gps) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;

/**
 * Esta tabla solo existe para cargar los datos de forma rapida desde el archivo csv que genera la app de relevamiento.
 */
CREATE TABLE IF NOT EXISTS ccc._temp_csv_app_relevamiento (
	id_temp_csv INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	nombre_celular VARCHAR(255),
	mac_celular VARCHAR(255),
	numero_abonado INT(11),
	lat FLOAT(10,6) NULL,
	lng FLOAT(10,6) NULL,	
	coord_gps_dcml_str VARCHAR(255),
	coord_gps_dcml_pnt POINT,
	coord_gps_sexa_str VARCHAR(255),
	observaciones TEXT,
	ruta_archivo_original VARCHAR(255),
	ruta_archivo_backup VARCHAR(255),
	PRIMARY KEY(id_temp_csv)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;