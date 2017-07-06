CREATE TABLE IF NOT EXISTS ccc.factura_abonado (
	numero_fac_abo INT (11) NOT NULL AUTO_INCREMENT UNIQUE,
	numero_abo INT(11) NOT NULL UNIQUE,
	FOREIGN KEY (numero_abo) REFERENCES ccc.abonados (numero_abo) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.instalores_servicios (
	dni_emp INT (11) NOT NULL UNIQUE,
	PRIMARY KEY(dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES ccc.empleados (dni_emp) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.orden_trabajo (
	numero_ord_tra INT (11) NOT NULL UNIQUE,
	dni_emp INT(11) NOT NULL UNIQUE,
	PRIMARY KEY(numero_ord_tra),
	FOREIGN KEY (dni_emp) REFERENCES instalores_servicios (dni_emp) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.linea_celulares (
	id_cel INT(11) NOT NULL UNIQUE,
	empresa_lin_cel VARCHAR(30),
	servicio_lin_cel VARCHAR(30),
	numero_lin_cel INT(7),
	PRIMARY KEY(id_cel),
	FOREIGN KEY (id_cel) REFERENCES ccc.celulares (id_cel) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.rutas_archivos_instalaciones (
	numero_inst_serv INT(11) NOT NULL UNIQUE,
	csv_rut_arch_inst VARCHAR(255),
	kml_rut_arch_inst VARCHAR(255),
	foto_rut_arch_inst VARCHAR(255),
	PRIMARY KEY(numero_inst_serv),
	FOREIGN KEY (numero_inst_serv) REFERENCES ccc.instalaciones_servicios (numero_inst_serv) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.tiempo (
	id_tmp INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	PRIMARY KEY(id_tmp)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;


CREATE TABLE IF NOT EXISTS ccc.personas_contacto (
	id_per_con INT(11) NOT NULL AUTO_INCREMENT UNIQUE,
	email_personas_contacto VARCHAR(255),
	PRIMARY KEY(id_tmp)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_spanish_ci;