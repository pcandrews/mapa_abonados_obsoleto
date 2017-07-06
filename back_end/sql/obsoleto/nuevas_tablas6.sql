/**
 * 	Hacer:
 * 	· Restricciones.
 * 	· Logs.
 * 	· Historico. 
 */

DROP DATABASE IF EXISTS ccc;


CREATE DATABASE IF NOT EXISTS ccc
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_spanish_ci;

/**
 *	Esta tabla solo existe para cargar los datos de forma rapida desde el archivo csv que genera la app de relevamiento.
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
	
	/* Lo genera PHP, desde los archivos */
	ruta_archivo_original VARCHAR(255),
	ruta_archivo_backup VARCHAR(255),

	fecha_y_hora_instalacion DATETIME,

	PRIMARY KEY(id_temp_csv)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE ccc.csv_app_relevamiento LIKE ccc._temp_csv_app_relevamiento;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.personas (
	id_per INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	dni_per INT(11) UNSIGNED NULL UNIQUE,
	cuil_per INT(11) UNSIGNED NULL UNIQUE,
	nombres_per VARCHAR(255),
	apellidos_per VARCHAR(255),
	PRIMARY KEY(id_per)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.abonados (
	id_abo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abo INT(11) NOT NULL UNIQUE,
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(id_abo)	
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.empleados (
	id_emp INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_emp)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * que rehacer esto
 */
CREATE TABLE IF NOT EXISTS ccc.instaladores (
	id_instdr INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_instdr)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.empresas (
	id_empresas INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_empresas)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.coordenadas_gps (
	id_coord_gps INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	lat FLOAT(10,6) NULL,
	lng FLOAT(10,6) NULL,	
	coord_gps_dcml_str VARCHAR(255),
	coord_gps_dcml_pnt POINT,
	coord_gps_sexa_str VARCHAR(255),
	PRIMARY KEY(id_coord_gps)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.direcciones (
	id_dir INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	calle_dir VARCHAR(255),
	numero_dir INT(11),
	dpto_dir VARCHAR(255),
	piso_dir INT(11),
	barrio_dir VARCHAR(255),
	municipio_dir VARCHAR(255),
	zona_dir VARCHAR (255),
	observaciones_dir TEXT,
	PRIMARY KEY(id_dir)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.celulares (
	id_cel INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	nombre_cel VARCHAR(255) UNIQUE,
	mac_cel VARCHAR(255) UNIQUE,
	observaciones_cel TEXT,
	PRIMARY KEY(id_cel)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 	La relacion con el instalador es alimentada desde afuera
 */
CREATE TABLE IF NOT EXISTS ccc.instalaciones_servicios (
	id_inst_serv INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	id_instdr INT(11) UNSIGNED NOT NULL,
	observaciones_inst_serv TEXT,
	fecha_y_hora_inst_serv DATETIME,
	PRIMARY KEY(id_inst_serv)/*,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instaladores (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE*/
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;



/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.facturas (
	id_fact INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_fact)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;












/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.medios_contacto (
	id_med_contct INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	email_med_contct VARCHAR(255),
	numero_cel_med_contct INT(11) UNIQUE,
	numero_fijo_med_contct INT(11) UNIQUE,
	PRIMARY KEY(id_med_contct)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.orden_trabajo (
	id_orden_trab INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_orden_trab)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.linea_celulares (
	id_lin_cel INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	empresa_lin_cel VARCHAR(30),
	servicio_lin_cel VARCHAR(30),
	numero_lin_cel INT(7),
	PRIMARY KEY(id_lin_cel)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.rutas_archivos_instalaciones (
	id_rut_arch_inst INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	csv_rut_arch_inst VARCHAR(255),
	kml_rut_arch_inst VARCHAR(255),
	foto_rut_arch_inst VARCHAR(255),
	PRIMARY KEY(id_rut_arch_inst)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.tiempo (
	id_tmp INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_tmp)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/



























/******************************** Tablas Relacionales ********************************/




/**
 *	Tabla relacional entre personas y abonados
 */
CREATE TABLE IF NOT EXISTS ccc.rel_personas_abonados (
	id_per INT(11) UNSIGNED NOT NULL UNIQUE,
	id_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_abo) REFERENCES ccc.abonados (id_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre personas y empleados
 */
CREATE TABLE IF NOT EXISTS ccc.rel_personas_empleados (
	id_per INT(11) UNSIGNED NOT NULL UNIQUE,
	id_emp INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_emp) REFERENCES ccc.empleados (id_emp) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre coordenadas y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_coordenadas_direcciones (
	id_coord_gps INT(11) UNSIGNED NOT NULL UNIQUE,
	id_dir INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_coord_gps) REFERENCES ccc.coordenadas_gps (id_coord_gps) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direcciones (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre personas y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_personas_direcciones (
	id_per INT(11) UNSIGNED NOT NULL UNIQUE,
	id_dir INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direcciones (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonados_instalaciones_servicios (
	id_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	id_inst_serv INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_abo) REFERENCES ccc.abonados (id_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalaciones_servicios (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonados_facturas (
	id_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	id_fact INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_abo) REFERENCES ccc.abonados (id_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_fact) REFERENCES ccc.facturas (id_fact) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_instalaciones_servicios_celulares (
	id_cel INT(11) UNSIGNED NOT NULL UNIQUE,
	id_inst_serv INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_cel) REFERENCES ccc.celulares (id_cel) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalaciones_servicios (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
/*CREATE TABLE IF NOT EXISTS ccc.rel_instalaciones_instaladores (
	id_instdr INT(11) UNSIGNED NOT NULL UNIQUE,
	id_inst_serv INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instaladores (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalaciones_servicios (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;*/


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.rel_empleados_instaladores (
	id_instdr INT(11) UNSIGNED NOT NULL UNIQUE,
	id_emp INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instaladores (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_emp) REFERENCES ccc.empleados (id_emp)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/