DROP PROCEDURE IF EXISTS dowhile;

DELIMITER $$
	CREATE PROCEDURE dowhile()
	BEGIN

		DECLARE contador INT DEFAULT 1;
		DECLARE cant_abonados INT DEFAULT 0;
		DECLARE numero_abonado_valido INT DEFAULT 0;

		DECLARE ultimo_id_per INT DEFAULT 0;
		DECLARE ultimo_id_dir INT DEFAULT 0;
		DECLARE ultimo_id_coord_gps INT DEFAULT 0;
		
						     #guardad en utiles.sql
		SET cant_abonados = (SELECT COUNT(DISTINCT numero_abonado) FROM ccc._temp_csv_app_relevamiento);

		SELECT contador;
		SELECT cant_abonados;
		SELECT numero_abonado_valido;
		WHILE contador <= cant_abonados DO
                                        
			SET numero_abonado_valido = (SELECT DISTINCT numero_abonado 
										 FROM ccc.csv_app_relevamiento 
										 WHERE numero_abonado NOT IN (SELECT numero_abo FROM ccc.abonados) LIMIT 1);


			INSERT INTO ccc.personas (id_per) 
			VALUES (NULL);
			SET ultimo_id_per = LAST_INSERT_ID();


			INSERT IGNORE INTO ccc.abonados (numero_abo) 
			VALUES (numero_abonado_valido);


			INSERT INTO ccc.direcciones (id_dir)
			VALUES (NULL);
			SET ultimo_id_dir = LAST_INSERT_ID();


			/**
			 * 
			 */
			INSERT INTO ccc.coordenadas_gps (lat, 
											 lng,
											 coord_gps_dcml_str, 
											 coord_gps_dcml_pnt, 
											 coord_gps_sexa_str)	  
			SELECT 	lat, 
					lng, 
					coord_gps_dcml_str, 
					coord_gps_dcml_pnt, 
					coord_gps_sexa_str
			FROM ccc._temp_csv_app_relevamiento
			WHERE numero_abonado = numero_abonado_valido;
			SET ultimo_id_coord_gps = LAST_INSERT_ID();


			/**
			 * 
			 */
			INSERT INTO ccc.instalaciones_servicios (id_instdr,
													 #observaciones_inst_serv,
													 fecha_y_hora_inst_serv)
			SELECT 	NULL,
					#observaciones, enlazar con notas
					fecha_y_hora_instalacion					
			FROM ccc._temp_csv_app_relevamiento
			WHERE id_temp_csv = contador;
			SET ultimo_id_inst_serv = LAST_INSERT_ID();


			/***** Tablas Relacionales *****/


			INSERT INTO ccc.rel_personas_abonados (id_per, 
				 								   numero_abo) 
			VALUES (ultimo_id_per, 
				   	numero_abonado_valido);


			/**
			 * 
			 */
			INSERT INTO ccc.rel_personas_direcciones (id_per, 
													  id_dir) 
			VALUES (ultimo_id_per, 
					ultimo_id_dir);


			/**
			 * 
			 */
			INSERT INTO ccc.rel_coordenadas_direcciones (id_coord_gps, 
														 id_dir) 
			VALUES (ultimo_id_coord_gps, 
				   	ultimo_id_dir);


			SET contador = contador + 1;

		END WHILE;
	END $$
DELIMITER ;

CALL dowhile();


/******************************************************************/
/*EXTRA*/



(SELECT id_abo,numero_abo FROM ccc.abonados ORDER BY id_abo DESC LIMIT 10) ORDER BY id_abo ASC
(SELECT id_abo FROM ccc.abonados ORDER BY id_abo DESC LIMIT 10) ORDER BY id_abo ASC;
(SELECT id_per FROM ccc.personas ORDER BY id_per DESC LIMIT 10) ORDER BY id_per ASC;


