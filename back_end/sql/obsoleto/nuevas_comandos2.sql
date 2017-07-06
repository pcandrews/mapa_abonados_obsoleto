/**
 * 	Nota: Dada la manera en que la aplicacion guarda la información (inadecuada), 
 *  tuve que implementar una solucion no convencional para poder extraerla del csv.
 *  LOAD DATA no esta permitido en procedimientos almacenados.
 *
 * 	IMPORTANTE:
 * 	
 *	Hay que analizar que pasa cuando se introducen valores unico, pero con informacion nueva, como por ejemplo, una nueva
 *	instalacion en un lugar con un numero de abonado (que es unico) ya almacenado, pero con informacion nueva.
 * 
 */
TRUNCATE ccc._temp_csv_app_relevamiento;
ALTER TABLE ccc._temp_csv_app_relevamiento AUTO_INCREMENT = 1;
LOAD DATA LOCAL INFILE '/home/pablo/20170123.csv'
	INTO TABLE ccc._temp_csv_app_relevamiento
	FIELDS TERMINATED BY '\",'
	LINES TERMINATED BY '\n'
	(@nombre_celular, @mac_celular, @numero_abonado, @coord_gps_dcml, @coord_gps_sexa, @observaciones) 
	SET nombre_celular = SUBSTR(TRIM(@nombre_celular), 2),
		mac_celular = SUBSTR(TRIM(@mac_celular), 2),
		numero_abonado = CAST(SUBSTR(TRIM(@numero_abonado), 2) AS UNSIGNED),
		
		coord_gps_dcml_str = SUBSTR(TRIM(@coord_gps_dcml), 2),
		coord_gps_sexa_str = SUBSTR(TRIM(@coord_gps_sexa), 2),
		lat = CAST(SUBSTRING_INDEX(coord_gps_dcml_str, ',', 1) AS DECIMAL(10,6)),
		lng = CAST(SUBSTRING_INDEX(coord_gps_dcml_str, ',', -1) AS DECIMAL(10,6)),
		coord_gps_dcml_pnt = ST_GeomFromText(CONCAT('POINT(',REPLACE(coord_gps_dcml_str, ',',' '),')')),
		

		observaciones = SUBSTR(TRIM(@observaciones), 2),
		observaciones = SUBSTRING(observaciones, 1, LENGTH(observaciones)-1),
		ruta_archivo_original = 'xxx',
		ruta_archivo_backup = 'yyy',
		fecha_y_hora_instalacion = NOW();

/*INSERT INTO ccc.archivos_csv SELECT * FROM ccc._temp_csv_app_relevamiento;*/

INSERT INTO ccc.csv_app_relevamiento (
		nombre_celular,
		mac_celular,
		numero_abonado,
		lat,
		lng,	
		coord_gps_dcml_str,
		coord_gps_dcml_pnt,
		coord_gps_sexa_str,
		observaciones,
		ruta_archivo_original,
		ruta_archivo_backup)	  
SELECT	nombre_celular,
		mac_celular,
		numero_abonado,
		lat,
		lng,	
		coord_gps_dcml_str,
		coord_gps_dcml_pnt,
		coord_gps_sexa_str,
		observaciones,
		ruta_archivo_original,
		ruta_archivo_backup
FROM ccc._temp_csv_app_relevamiento
ORDER BY id_temp_csv ASC;


INSERT IGNORE INTO ccc.celulares (
		nombre_cel,
		mac_cel) 
SELECT nombre_celular,
		mac_celular
FROM ccc._temp_csv_app_relevamiento
ORDER BY id_temp_csv ASC;



DROP PROCEDURE IF EXISTS dowhile;


DELIMITER $$
	CREATE PROCEDURE dowhile()
	BEGIN

		DECLARE contador INT DEFAULT 1;
		DECLARE num_registros INT DEFAULT 0;
		DECLARE ultimo_id_per INT DEFAULT 0;
		DECLARE ultimo_id_abo INT DEFAULT 0;
		DECLARE ultimo_id_dir INT DEFAULT 0;
		DECLARE ultimo_id_inst_serv INT DEFAULT 0;
		DECLARE ultimo_id_coord_gps INT DEFAULT 0;
		DECLARE ultimo_id_fact INT DEFAULT 0;


		SET num_registros = (SELECT MAX(id_temp_csv) FROM ccc._temp_csv_app_relevamiento);
		
		SELECT contador;
		SELECT num_registros;
		WHILE contador <= num_registros DO

			INSERT INTO ccc.personas (
					id_per) 
			VALUES (NULL);
			SET ultimo_id_per = LAST_INSERT_ID();


			/**
			 * 
			 */
			INSERT INTO ccc.abonados (
					numero_abo) 
			SELECT numero_abonado 
			FROM ccc._temp_csv_app_relevamiento 
			WHERE id_temp_csv = contador;
			SET ultimo_id_abo = LAST_INSERT_ID();


			/**
			 * 
			 */
			INSERT INTO ccc.facturas () 
			SELECT NULL 
			FROM ccc._temp_csv_app_relevamiento 
			WHERE id_temp_csv = contador;
			SET ultimo_id_fact = LAST_INSERT_ID();


			/**
			 * 
			 */
			INSERT INTO ccc.coordenadas_gps (
					lat, 
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
			WHERE id_temp_csv = contador;
			SET ultimo_id_coord_gps = LAST_INSERT_ID();


			INSERT INTO ccc.direcciones (
					observaciones_dir)	  
			SELECT 	observaciones
			FROM ccc._temp_csv_app_relevamiento
			WHERE id_temp_csv = contador;
			SET ultimo_id_dir = LAST_INSERT_ID();








			/*******************************************************/



				/**
				 * 	hay q ver desde donde se alimenta esto. rehacer
				 */
				INSERT INTO ccc.instaladores (
						id_instdr)
				VALUES (NULL);


				/**
				 * 	hay q ver desde donde se alimenta esto.
				 */
				/*INSERT INTO ccc.instalaciones_servicios  (
						id_instdr)
				VALUES (ultimo_id_inst_serv);*/




			/*******************************************************/

			INSERT INTO ccc.instalaciones_servicios (
					id_instdr,
					observaciones_inst_serv,
					fecha_y_hora_inst_serv)
			SELECT 	LAST_INSERT_ID()
					observaciones,
					fecha_y_hora_instalacion					
			FROM ccc._temp_csv_app_relevamiento
			WHERE id_temp_csv = contador;
			SET ultimo_id_inst_serv = LAST_INSERT_ID();






			/***** Tablas Relacionales *****/


			/**
			 * 
			 */
			INSERT INTO ccc.rel_personas_abonados (
					id_per, 
					id_abo) 
			VALUES (
					ultimo_id_per,
					ultimo_id_abo);


			/**
			 * 
			 */
			INSERT INTO ccc.rel_personas_direcciones (
					id_per, 
					id_dir) 
			VALUES (
					ultimo_id_per,
					ultimo_id_abo);


			/**
			 * 
			 */
			INSERT INTO ccc.rel_coordenadas_direcciones (
					id_coord_gps, 
					id_dir) 
			VALUES (
					ultimo_id_coord_gps,
					ultimo_id_dir);


			/**
			 * 
			 */
			INSERT INTO ccc.rel_abonados_instalaciones_servicios (
					id_abo, 
					id_inst_serv) 
			VALUES (
					ultimo_id_abo,
					ultimo_id_inst_serv);

			/**
			 * 
			 */
			/*INSERT INTO ccc.rel_instalaciones_instaladores (
					id_instdr, 
					id_inst_serv) 
			VALUES (
					ultimo_id_abo,
					ultimo_id_inst_serv);*/


			/**
			 * 
			 */
			INSERT INTO ccc.rel_abonados_facturas (
					id_abo, 
					id_fact) 
			VALUES (
					ultimo_id_abo,
					ultimo_id_fact);

			/**
			 * 
			 */
			/*INSERT INTO ccc.rel_empleados_instaladores (
					id_emp, 
					id_instdr) 
			VALUES (
					ultimo_id_inst_serv,
					ultimo_id_inst_serv);*/

			


			/**
			 * 
			 */
			INSERT IGNORE INTO ccc.rel_instalaciones_servicios_celulares (
					id_cel, 
					id_inst_serv) 
			VALUES (
					(
						SELECT id_cel 
						FROM ccc.celulares
						WHERE mac_cel = (
											SELECT mac_celular 
											FROM ccc._temp_csv_app_relevamiento 
											WHERE id_temp_csv = contador)),
					ultimo_id_inst_serv);


			SET contador = contador + 1;


		END WHILE;

	END $$

DELIMITER ;

CALL dowhile();