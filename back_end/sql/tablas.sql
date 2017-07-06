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
CREATE TABLE IF NOT EXISTS ccc.persona (
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
CREATE TABLE IF NOT EXISTS ccc.abonado (
	numero_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	estado_abo INT(11),
	servicio_abo VARCHAR(255),
	PRIMARY KEY(numero_abo)	
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.empleado (
	id_emp INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_emp)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.direccion (
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
CREATE TABLE IF NOT EXISTS ccc.coordenada_gps (
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
CREATE TABLE IF NOT EXISTS ccc.instalador (
	id_instdr INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	#codigo_intalador???
	PRIMARY KEY(id_instdr)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 	
 */
CREATE TABLE IF NOT EXISTS ccc.instalacion_servicio (
	id_inst_serv INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	id_instdr INT(11) UNSIGNED NOT NULL,
	#codigo_intalacion???
	observacion_inst_serv TEXT, 
	fecha_y_hora_inst_serv DATETIME,
	rut_arch_orig_inst_serv VARCHAR(255),
	rut_arch_bu_inst_serv VARCHAR(255),
	PRIMARY KEY(id_inst_serv),
	FOREIGN KEY (id_instdr) REFERENCES ccc.instalador (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.celular (
	mac_cel VARCHAR(255) NOT NULL,
	nombre_cel VARCHAR(255),
	observacion_cel TEXT,
	PRIMARY KEY(mac_cel, nombre_cel),
    CONSTRAINT id_cel UNIQUE (mac_cel, nombre_cel)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;





###########################################################################################
# Fotos
# 

/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.foto_instalacion (
	id_foto_inst INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abonado_foto_inst INT(11) UNSIGNED NOT NULL,
	rut_arch_orig_foto_inst VARCHAR(255) UNIQUE,
	rut_arch_bu_foto_inst VARCHAR(255) UNIQUE,
	PRIMARY KEY(id_foto_inst)#,
	#FOREIGN KEY (numero_abo) REFERENCES ccc.abonado (numero_abo) 	
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
CREATE TABLE IF NOT EXISTS ccc.kml_instalacion (
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
 *	Tabla relacional entre personas y abonado
 */
CREATE TABLE IF NOT EXISTS ccc.rel_persona_abonado (
	id_per INT(11) UNSIGNED NULL UNIQUE,
	numero_abo INT(11) UNSIGNED NULL UNIQUE,
		FOREIGN KEY (id_per) REFERENCES ccc.persona (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonado (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre personas y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_persona_direccion (
	id_per INT(11) UNSIGNED NOT NULL,
	id_dir INT(11) UNSIGNED NOT NULL,
	FOREIGN KEY (id_per) REFERENCES ccc.persona (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direccion (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre abonado y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonado_direccion (
	numero_abo INT(11) UNSIGNED NULL UNIQUE,
	id_dir INT(11) UNSIGNED NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonado (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direccion (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre coordenadas y direcciones
 */
CREATE TABLE IF NOT EXISTS ccc.rel_coordenada_direccion (
	id_coord_gps INT(11) UNSIGNED NULL,
	id_dir INT(11) UNSIGNED NULL,
	FOREIGN KEY (id_coord_gps) REFERENCES ccc.coordenada_gps (id_coord_gps) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_dir) REFERENCES ccc.direccion (id_dir) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_instalacion_instalador (
	id_instdr INT(11) UNSIGNED NOT NULL,
	id_inst_serv INT(11) UNSIGNED NOT NULL,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instalador (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalacion_servicio (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	Tabla relacional entre personas y empleados
 */
CREATE TABLE IF NOT EXISTS ccc.rel_persona_empleado (
	id_per INT(11) UNSIGNED NOT NULL UNIQUE,
	id_emp INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_per) REFERENCES ccc.persona (id_per) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_emp) REFERENCES ccc.empleado (id_emp) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.rel_empleado_instalador (
	id_emp INT(11) UNSIGNED NOT NULL UNIQUE,
	id_instdr INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (id_emp) REFERENCES ccc.empleado (id_emp)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_instdr) REFERENCES ccc.instalador (id_instdr) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonado_instalacion_servicio (
	numero_abo INT(11) UNSIGNED NOT NULL,
	id_inst_serv INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonado (numero_abo)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalacion_servicio (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_instalacion_servicio_celular (
	id_inst_serv INT(11) UNSIGNED NOT NULL,
    mac_cel VARCHAR(255) NOT NULL,	
    nombre_cel VARCHAR(255),
	FOREIGN KEY (id_inst_serv) REFERENCES ccc.instalacion_servicio (id_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (mac_cel, nombre_cel) REFERENCES ccc.celular (mac_cel,nombre_cel) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;
















/******************************************************************************************/
/************** Todavia no se usan, pero estan listas para usarse. ************************/


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.empresa (
	id_empresa INT(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_empresa)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/**
 * 
 */
CREATE TABLE IF NOT EXISTS ccc.factura (
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
CREATE TABLE IF NOT EXISTS ccc.linea_celular (
	numero_lin_cel INT(11) UNSIGNED NOT NULL UNIQUE,
	empresa_lin_cel VARCHAR(30),
	servicio_lin_cel VARCHAR(30),
	PRIMARY KEY(numero_lin_cel)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


/******************************** Tablas Relacionales ********************************/


/**
 *	
 */
CREATE TABLE IF NOT EXISTS ccc.rel_abonado_factura (
	numero_abo INT(11) UNSIGNED NOT NULL UNIQUE,
	id_fact INT(11) UNSIGNED NOT NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonado (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (id_fact) REFERENCES ccc.factura (id_fact) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;