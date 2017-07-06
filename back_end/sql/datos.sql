SET FOREIGN_KEY_CHECKS=0;

TRUNCATE `abonado`;
TRUNCATE `celular`;
TRUNCATE `coordenada_gps`;
#TRUNCATE `csv_app_relevamiento`;
TRUNCATE `direccion`;
TRUNCATE `empleado`;
TRUNCATE `empresa`;
TRUNCATE `factura`;
#TRUNCATE `foto_instalacion`;
TRUNCATE `instalacion_servicio`;
TRUNCATE `instalador`;
#TRUNCATE `kml_instalacion`;
TRUNCATE `linea_celular`;
TRUNCATE `medio_contacto`;
TRUNCATE `orden_trabajo`;
TRUNCATE `persona`;
TRUNCATE `rel_abonado_direccion`;
TRUNCATE `rel_abonado_factura`;
TRUNCATE `rel_abonado_instalacion_servicio`;
TRUNCATE `rel_coordenada_direccion`;
TRUNCATE `rel_empleado_instalador`;
TRUNCATE `rel_instalacion_instalador`;
TRUNCATE `rel_instalacion_servicio_celular`;
TRUNCATE `rel_persona_abonado`;
TRUNCATE `rel_persona_direccion`;
TRUNCATE `rel_persona_empleado`;
#TRUNCATE `_temp_csv_app_relevamiento`;

SET FOREIGN_KEY_CHECKS=1;


# Relacion persona - empleados - instaldores
# Esto se alimenta desde otro punto. Luego hacer la iteracion.
INSERT INTO ccc.persona (id_per) 
VALUES (1);


INSERT INTO ccc.empleado (id_emp)
VALUES (1);


INSERT INTO ccc.rel_persona_empleado (id_emp, 
										id_per) 
VALUES (1, 
		1);    


INSERT INTO ccc.instalador (id_instdr)
VALUES (1);


INSERT INTO ccc.rel_empleado_instalador (id_emp, 
											id_instdr) 
VALUES (1, 
		1);


INSERT INTO ccc.factura (id_fact) 
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
					IF (var_numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonado)) THEN 

						INSERT INTO ccc.persona (id_per) 
						VALUES (NULL);
						SET ultimo_id_per = LAST_INSERT_ID();
						
						INSERT INTO ccc.abonado (numero_abo) 
						VALUES(var_numero_abonado);
						
						INSERT INTO ccc.direccion (id_dir)
						VALUES(NULL);
						SET ultimo_id_dir = LAST_INSERT_ID();    
						
					
						/***** Tablas Relacionales *****/


						INSERT INTO ccc.rel_persona_abonado (id_per, 
															   numero_abo) 
						VALUES(ultimo_id_per, 
							   var_numero_abonado);
							   
						INSERT INTO ccc.rel_persona_direccion (id_per, 
																  id_dir) 
						VALUES (ultimo_id_per, 
								ultimo_id_dir);
	
						INSERT INTO ccc.rel_abonado_direccion (numero_abo, 
																  id_dir) 
						VALUES (var_numero_abonado, 
								ultimo_id_dir);
								
					END IF;

					
					########################################################################
                    ########################################################################
                    ########################################################################
						
					#
					# Restriccion: Cantidad de instalacion. 
					#
					INSERT INTO ccc.instalacion_servicio (id_inst_serv,
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
					
			
					INSERT INTO ccc.coordenada_gps (lat, 
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
					INSERT IGNORE INTO ccc.celular (mac_cel,
													  nombre_cel) 
					VALUES (var_mac_celular,
                            var_nombre_celular);
					
					
                    ########################################################################
                    ########################################################################
                    ########################################################################
                    
					/***** Tablas Relacionales *****/					
					
					#
					# Restriccion: Cantidad de instalacion. 
					#
                    INSERT INTO ccc.rel_coordenada_direccion (id_coord_gps, 
																 id_dir) 
					VALUES (ultimo_id_coord_gps, 
							(SELECT id_dir FROM ccc.rel_abonado_direccion WHERE numero_abo = var_numero_abonado));
                            

					INSERT INTO ccc.rel_instalacion_instalador (id_inst_serv,
																	id_instdr) 
					VALUES (ultimo_id_inst_serv,
							ultimo_id_instdr);


					INSERT INTO ccc.rel_abonado_instalacion_servicio (numero_abo,
																		  id_inst_serv)
					VALUES (var_numero_abonado,
							ultimo_id_inst_serv);                         
                    
                    
					INSERT IGNORE INTO ccc.rel_instalacion_servicio_celular (id_inst_serv, 
																				  mac_cel,
																				  nombre_cel) 
					VALUES (ultimo_id_inst_serv,
							var_mac_celular,
                            var_nombre_celular);


				END IF;
			UNTIL control END REPEAT;
		CLOSE explicito;
		
	END $$
DELIMITER ;

CALL cargar_csv();