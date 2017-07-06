SET FOREIGN_KEY_CHECKS=0;

TRUNCATE ccc.personas;
TRUNCATE ccc.abonados;
TRUNCATE ccc.direcciones;
TRUNCATE ccc.coordenadas_gps;
TRUNCATE ccc.instaladores;
TRUNCATE ccc.instalaciones_servicios;
TRUNCATE ccc.celulares;
TRUNCATE ccc.rel_personas_abonados;
TRUNCATE ccc.rel_personas_direcciones;
TRUNCATE ccc.rel_coordenadas_direcciones;


SET FOREIGN_KEY_CHECKS=1;


INSERT INTO ccc.instaladores (
		id_instdr)
VALUES (1);







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
		DECLARE var_observaciones TEXT;
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
		
		DECLARE explicito CURSOR FOR SELECT	 nombre_celular,
											 mac_celular,
											 numero_abonado,
											 lat,
											 lng,
											 coord_gps_dcml_str,
											 coord_gps_dcml_pnt,
											 coord_gps_sexa_str,
											 observaciones,
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
									 var_observaciones,
									 var_ruta_archivo_original,
									 var_ruta_archivo_backup,
									 var_fecha_y_hora_instalacion;
				IF NOT control THEN
					
					#
					# Restriccion: Cantindad de numeros de abonado.
					#
					INSERT INTO ccc.personas (id_per) 
					SELECT NULL
					WHERE var_numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonados);
					SET ultimo_id_per = LAST_INSERT_ID();
					

					#INSERT IGNORE INTO ccc.abonados (numero_abo) 
					#VALUES (var_numero_abonado);   
					
					INSERT IGNORE INTO ccc.abonados (numero_abo) 
					SELECT var_numero_abonado
					WHERE var_numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonados);
					SET ultimo_id_per = LAST_INSERT_ID();
					
					
					
					INSERT INTO ccc.direcciones (id_dir)
					SELECT NULL
					WHERE var_numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonados);
					SET ultimo_id_dir = LAST_INSERT_ID();
					
					
					/***** Tablas Relacionales *****/


					INSERT INTO ccc.rel_personas_abonados (id_per, 
														   numero_abo) 
					SELECT ultimo_id_per, 
						   var_numero_abonado
					WHERE var_numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonados);
					
					
					########################################################################
					########################################################################
					########################################################################
					
					#
					# Restriccion: Cantidad de instalaciones.
					#
					INSERT INTO ccc.instalaciones_servicios (id_inst_serv,
															 id_instdr,
															 observaciones_inst_serv,
															 fecha_y_hora_inst_serv)
					VALUES (NULL,
							var_id_instdr,
							var_observaciones,
							"0001-01-01 01:01:01");
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


				
				
				
				
		
					/***** Tablas Relacionales *****/



					/**
					 * 
					 */
					/*INSERT INTO ccc.rel_personas_direcciones (id_per, 
															  id_dir) 
					VALUES (ultimo_id_per, 
							ultimo_id_dir);*/


					/**
					 * 
					 */
					/*INSERT INTO ccc.rel_coordenadas_direcciones (id_coord_gps, 
																 id_dir) 
					VALUES (ultimo_id_coord_gps, 
							ultimo_id_dir);*/
								
							
					
				END IF;
			UNTIL control END REPEAT;
		CLOSE explicito;
		
	END $$
DELIMITER ;

CALL cargar_csv();