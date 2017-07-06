SET FOREIGN_KEY_CHECKS=0;

TRUNCATE `abonados`;
TRUNCATE `celulares`;
TRUNCATE `coordenadas_gps`;
#TRUNCATE `csv_app_relevamiento`;
TRUNCATE `direcciones`;
TRUNCATE `empleados`;
TRUNCATE `empresas`;
TRUNCATE `facturas`;
#TRUNCATE `fotos_instalaciones`;
TRUNCATE `instalaciones_servicios`;
TRUNCATE `instaladores`;
#TRUNCATE `kmls_instalaciones`;
TRUNCATE `linea_celulares`;
TRUNCATE `medios_contacto`;
TRUNCATE `orden_trabajo`;
TRUNCATE `personas`;
TRUNCATE `rel_abonados_direcciones`;
TRUNCATE `rel_abonados_facturas`;
TRUNCATE `rel_abonados_instalaciones_servicios`;
TRUNCATE `rel_coordenadas_direcciones`;
TRUNCATE `rel_empleados_instaladores`;
TRUNCATE `rel_instalaciones_instaladores`;
TRUNCATE `rel_instalaciones_servicios_celulares`;
TRUNCATE `rel_personas_abonados`;
TRUNCATE `rel_personas_direcciones`;
TRUNCATE `rel_personas_empleados`;
#TRUNCATE `_temp_csv_app_relevamiento`;

SET FOREIGN_KEY_CHECKS=1;


# Relacion personas - empleados - instaldores
# Esto se alimenta desde otro punto. Luego hacer la iteracion.
INSERT INTO ccc.personas (id_per) 
VALUES (1);


INSERT INTO ccc.empleados (id_emp)
VALUES (1);


INSERT INTO ccc.rel_personas_empleados (id_emp, 
										id_per) 
VALUES (1, 
		1);    


INSERT INTO ccc.instaladores (id_instdr)
VALUES (1);


INSERT INTO ccc.rel_empleados_instaladores (id_emp, 
											id_instdr) 
VALUES (1, 
		1);


INSERT INTO ccc.facturas (id_fact) 
VALUES (1);
#####


DROP PROCEDURE IF EXISTS cargar_csv;

DELIMITER $$
	CREATE PROCEDURE cargar_csv()
	BEGIN
		DECLARE control BOOLEAN DEFAULT 0;
		
		DECLARE var_nombre_celular VARCHAR(255);
		DECLARE var_mac_celular VARCHAR(255);
		DECLARE var_numero_abonado INT(11) UNSIGNED DEFAULT 0;   
		DECLARE var_lat FLOAT(10,6); 
		DECLARE var_lng FLOAT(10,6);
		DECLARE var_coord_gps_dcml_str VARCHAR(255);
		DECLARE var_coord_gps_dcml_pnt POINT;  
		DECLARE var_coord_gps_sexa_str VARCHAR(255);
		DECLARE var_observacion TEXT;
		DECLARE var_ruta_archivo_original VARCHAR(255);
		DECLARE var_ruta_archivo_backup VARCHAR(255);
		DECLARE var_fecha_y_hora_instalacion DATETIME;
		
		# Este dato tiene que venir desde un lugar que no tengo todavia.
		# En realidad hace falta algun tipo de codigo de cada instalador.
		DECLARE var_id_instdr INT DEFAULT 1;
		
		
		
		DECLARE ultimo_id_per INT DEFAULT 0;
		DECLARE ultimo_id_dir INT DEFAULT 0;
		DECLARE ultimo_id_coord_gps INT DEFAULT 0;
		DECLARE ultimo_id_inst_serv INT DEFAULT 0;
		DECLARE ultimo_id_rut_arch_inst INT DEFAULT 0;


        #Esto tiene q ser incrementado desde algun lugar
        DECLARE ultimo_id_instdr INT DEFAULT 1;
		
		DECLARE explicito CURSOR FOR SELECT	 nombre_celular,
											 mac_celular,
											 numero_abonado,
											 lat,
											 lng,
											 coord_gps_dcml_str,
											 coord_gps_dcml_pnt,
											 coord_gps_sexa_str,
											 observacion,
											 ruta_archivo_original,
											 ruta_archivo_backup,
											 fecha_y_hora_instalacion
									 FROM ccc._temp_csv_app_relevamiento;
									 
		DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET control = 1;
		
		OPEN explicito;
			REPEAT
				FETCH explicito INTO var_nombre_celular,
									 var_mac_celular,
									 var_numero_abonado,
									 var_lat,
									 var_lng,
									 var_coord_gps_dcml_str,
									 var_coord_gps_dcml_pnt,
									 var_coord_gps_sexa_str,
									 var_observacion,
									 var_ruta_archivo_original,
									 var_ruta_archivo_backup,
									 var_fecha_y_hora_instalacion;
				IF NOT control THEN
                
                
					########################################################################
                    ########################################################################
                    ########################################################################		
                    
					#
					# Restriccion: Cantidad de numeros de abonado.
					#
					IF (var_numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonados)) THEN 

						INSERT INTO ccc.personas (id_per) 
						VALUES (NULL);
						SET ultimo_id_per = LAST_INSERT_ID();
						
						INSERT INTO ccc.abonados (numero_abo) 
						VALUES(var_numero_abonado);
						
						INSERT INTO ccc.direcciones (id_dir)
						VALUES(NULL);
						SET ultimo_id_dir = LAST_INSERT_ID();    
						
					
						/***** Tablas Relacionales *****/


						INSERT INTO ccc.rel_personas_abonados (id_per, 
															   numero_abo) 
						VALUES(ultimo_id_per, 
							   var_numero_abonado);
							   
						INSERT INTO ccc.rel_personas_direcciones (id_per, 
																  id_dir) 
						VALUES (ultimo_id_per, 
								ultimo_id_dir);
	
						INSERT INTO ccc.rel_abonados_direcciones (numero_abo, 
																  id_dir) 
						VALUES (var_numero_abonado, 
								ultimo_id_dir);
								
					END IF;

					
					########################################################################
                    ########################################################################
                    ########################################################################
						
					#
					# Restriccion: Cantidad de instalaciones. 
					#
					INSERT INTO ccc.instalaciones_servicios (id_inst_serv,
															 id_instdr,
															 observacion_inst_serv,
															 fecha_y_hora_inst_serv,
                                                             rut_arch_orig_inst_serv, 
															 rut_arch_bu_inst_serv)
					VALUES (NULL,
							var_id_instdr,
							var_observacion,
							var_fecha_y_hora_instalacion,
                            var_ruta_archivo_original,
							var_ruta_archivo_backup);
					SET ultimo_id_inst_serv = LAST_INSERT_ID();
					
			
					INSERT INTO ccc.coordenadas_gps (lat, 
													 lng,
													 coord_gps_dcml_str, 
													 coord_gps_dcml_pnt, 
													 coord_gps_sexa_str)	  
					VALUES(	var_lat, 
							var_lng, 
							var_coord_gps_dcml_str, 
							var_coord_gps_dcml_pnt, 
							var_coord_gps_sexa_str);
					SET ultimo_id_coord_gps = LAST_INSERT_ID();  
                    
                    
					########################################################################
                    ########################################################################
                    ########################################################################
                    
                    
					#
					# Restriccion: Cantidad de telefonos fisicos.
					#
					INSERT IGNORE INTO ccc.celulares (nombre_cel,
													  mac_cel) 
					VALUES (var_nombre_celular,
							var_mac_celular);
					
					
                    ########################################################################
                    ########################################################################
                    ########################################################################
                    
					/***** Tablas Relacionales *****/					
					
					#
					# Restriccion: Cantidad de instalaciones. 
					#
                    INSERT INTO ccc.rel_coordenadas_direcciones (id_coord_gps, 
																 id_dir) 
					VALUES (ultimo_id_coord_gps, 
							(SELECT id_dir FROM ccc.rel_abonados_direcciones WHERE numero_abo = var_numero_abonado));
                            

					INSERT INTO ccc.rel_instalaciones_instaladores (id_inst_serv,
																	id_instdr) 
					VALUES (ultimo_id_inst_serv,
							ultimo_id_instdr);


					INSERT INTO ccc.rel_abonados_instalaciones_servicios (numero_abo,
																		  id_inst_serv)
					VALUES (var_numero_abonado,
							ultimo_id_inst_serv);                         
                    
                    
					INSERT IGNORE INTO ccc.rel_instalaciones_servicios_celulares (id_inst_serv, 
																				  mac_cel) 
					VALUES (ultimo_id_inst_serv,
							var_mac_celular);


				END IF;
			UNTIL control END REPEAT;
		CLOSE explicito;
		
	END $$
DELIMITER ;

CALL cargar_csv();