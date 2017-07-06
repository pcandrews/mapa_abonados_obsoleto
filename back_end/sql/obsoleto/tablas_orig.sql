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
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,

	nombre_celular VARCHAR(255),
	mac_celular VARCHAR(255),

	numero_abonado INT(11) UNSIGNED,

	lat FLOAT(10,6) NULL,
	lng FLOAT(10,6) NULL,	
	coord_gps_dcml_str VARCHAR(255),
	coord_gps_dcml_pnt POINT,
	coord_gps_sexa_str VARCHAR(255),

	observacion TEXT,
	
	ruta_archivo_original VARCHAR(255),
	ruta_archivo_backup VARCHAR(255),

	fecha_y_hora_instalacion DATETIME,

	PRIMARY KEY(id)
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
	numero_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(numero_abo)	
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.empleados (
	id_emp INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_emp)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.direcciones (
	id_dir INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	calle_dir VARCHAR(255),
	numero_dir INT(11) UNSIGNED,
	dpto_dir VARCHAR(255),
	piso_dir INT(11) UNSIGNED,
	barrio_dir VARCHAR(255),
	municipio_dir VARCHAR(255),
	zona_dir VARCHAR (255),	
	observacion_dir TEXT, 
	PRIMARY KEY(id_dir)
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
CREATE TABLE IF NOT EXISTS ccc.instaladores (
	id_instdr INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	#codigo_intalador???
	PRIMARY KEY(id_instdr)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 	
 */
CREATE TABLE IF NOT EXISTS ccc.instalaciones_servicios (
	id_inst_serv INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	id_instdr INT(11) UNSIGNED NOT NULL,
	#codigo_intalacion???
	observacion_inst_serv TEXT, 
	fecha_y_hora_inst_serv DATETIME,
	rut_arch_orig_inst_serv VARCHAR(255),
	rut_arch_bu_inst_serv VARCHAR(255),
	PRIMARY KEY(id_inst_serv),
	FOREIGN KEY (id_instdr) REFERENCES ccc.instaladores (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.celulares (
	mac_cel VARCHAR(255) UNIQUE NOT NULL,
	nombre_cel VARCHAR(255) UNIQUE,
	observacion_cel TEXT,
	PRIMARY KEY(mac_cel)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;





###########################################################################################
# Fotos
# 

/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.fotos_instalaciones (
	id_foto_inst INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abonado_foto_inst INT(11) UNSIGNED NOT NULL,
	rut_arch_orig_foto_inst VARCHAR(255) UNIQUE,
	rut_arch_bu_foto_inst VARCHAR(255) UNIQUE,
	PRIMARY KEY(id_foto_inst)#,
	#FOREIGN KEY (numero_abo) REFERENCES ccc.abonados (numero_abo) 	
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


###########################################################################################
###########################################################################################
###########################################################################################


###########################################################################################
# KMLs
# 

/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.kmls_instalaciones (
	id_kml_inst INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abonado_kml_inst INT(11) UNSIGNED,
	observacion_kml_inst TEXT,
	coord_gps_dcml_str_kml_inst VARCHAR(255),
	rut_arch_orig_kml_inst VARCHAR(255),
	rut_arch_bu_kml_inst VARCHAR(255),
	#fecha_y_hora_instalacion DATETIME,
	PRIMARY KEY(id_kml_inst)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


###########################################################################################
###########################################################################################
###########################################################################################









/*************************************************************************************/
/*************************************************************************************/
/*************************************************************************************/

/******************************** Tablas Relacionales ********************************/
/**
 *	Tabla relacional entre personas y abonados
 */
CREATE TABLE IF NOT EXISTS ccc.rel_personas_abonados (
	id_per INT(11) UNSIGNED NULL UNIQUE,
	numero_abo INT(11) UNSIGNED NULL UNIQUE,
		FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre personas y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_personas_direcciones (
	id_per INT(11) UNSIGNED NOT NULL,
	id_dir INT(11) UNSIGNED NOT NULL,
	FOREIGN KEY (id_per) REFERENCES ccc.personas (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direcciones (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre abonados y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonados_direcciones (
	numero_abo INT(11) UNSIGNED NULL UNIQUE,
	id_dir INT(11) UNSIGNED NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direcciones (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre coordenadas y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_coordenadas_direcciones (
	id_coord_gps INT(11) UNSIGNED NULL,
	id_dir INT(11) UNSIGNED NULL,
	FOREIGN KEY (id_coord_gps) REFERENCES ccc.coordenadas_gps (id_coord_gps) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direcciones (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_instalaciones_instaladores (
	id_instdr INT(11) UNSIGNED NOT NULL,
	id_inst_serv INT(11) UNSIGNED NOT NULL,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instaladores (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalaciones_servicios (id_inst_serv) 
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
 *
 */
CREATE TABLE IF NOT EXISTS ccc.rel_empleados_instaladores (
	id_emp INT(11) UNSIGNED NOT NULL UNIQUE,
	id_instdr INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_emp) REFERENCES ccc.empleados (id_emp)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instaladores (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonados_instalaciones_servicios (
	numero_abo INT(11) UNSIGNED NOT NULL,
	id_inst_serv INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonados (numero_abo)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalaciones_servicios (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_instalaciones_servicios_celulares (
	id_inst_serv INT(11) UNSIGNED NOT NULL,
	mac_cel VARCHAR(255) NOT NULL,	
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalaciones_servicios (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (mac_cel) REFERENCES ccc.celulares (mac_cel) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;
















/******************************************************************************************/
/************** Todavia no se usan, pero estan listas para usarse. ************************/


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
CREATE TABLE IF NOT EXISTS ccc.facturas (
	id_fact INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_fact)
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
CREATE TABLE IF NOT EXISTS ccc.linea_celulares (
	numero_lin_cel INT(11) UNSIGNED NOT NULL UNIQUE,
	empresa_lin_cel VARCHAR(30),
	servicio_lin_cel VARCHAR(30),
	PRIMARY KEY(numero_lin_cel)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/******************************** Tablas Relacionales ********************************/


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonados_facturas (
	numero_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	id_fact INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_fact) REFERENCES ccc.facturas (id_fact) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;