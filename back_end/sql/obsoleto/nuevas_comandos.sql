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
LOAD DATA LOCAL INFILE '/home/pablo/20170114.csv'
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
		ruta_archivo_backup = 'yyy';



DROP PROCEDURE IF EXISTS dowhile;

DELIMITER $$
	CREATE PROCEDURE dowhile()
	BEGIN

		DECLARE contador INT DEFAULT 0;
		DECLARE ultimo_id_per INT DEFAULT 0;
		DECLARE ultimo_id_abo INT DEFAULT 0;

		SET contador = (SELECT MAX(id_temp_csv) FROM ccc._temp_csv_app_relevamiento);
		
		SELECT contador;
		WHILE contador > 0 DO

			INSERT INTO ccc.personas (id_per) VALUES (NULL);
			SET ultimo_id_per = LAST_INSERT_ID();

			INSERT INTO ccc.abonados (id_abo, numero_abo) VALUES (NULL,(SELECT numero_abonado FROM ccc._temp_csv_app_relevamiento WHERE id_temp_csv = contador));
			SET ultimo_id_abo = LAST_INSERT_ID();

			INSERT INTO ccc.personas_abonados (id_per, id_abo) VALUES(ultimo_id_per,ultimo_id_abo);

			SET contador = contador - 1;

		END WHILE;
	END $$
DELIMITER ;

CALL dowhile();



*********************************************************************************************************************************



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
		ruta_archivo_backup = 'yyy';

/*INSERT INTO ccc.archivos_csv SELECT * FROM ccc._temp_csv_app_relevamiento;*/

INSERT INTO ccc.archivos_csv (
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


DROP PROCEDURE IF EXISTS dowhile;


DELIMITER $$
	CREATE PROCEDURE dowhile()
	BEGIN

		DECLARE contador INT DEFAULT 1;
		DECLARE num_registros INT DEFAULT 0;
		DECLARE ultimo_id_per INT DEFAULT 0;
		DECLARE ultimo_id_abo INT DEFAULT 0;
		DECLARE ultimo_id_dir INT DEFAULT 0;
		DECLARE ultimo_id_coord_gps INT DEFAULT 0;

		SET num_registros = (SELECT MAX(id_temp_csv) FROM ccc._temp_csv_app_relevamiento);
		
		SELECT contador;
		SELECT num_registros;
		WHILE contador <= num_registros DO

			INSERT INTO ccc.personas (
					id_per) 
			VALUES (NULL);
			SET ultimo_id_per = LAST_INSERT_ID();			
			

			/*			
			INSERT INTO ccc.abonados (
					id_abo, 
					numero_abo) 
			VALUES (
					NULL,
					(SELECT numero_abonado 
					FROM ccc._temp_csv_app_relevamiento 
					WHERE id_temp_csv = contador)
					);
			SET ultimo_id_abo = LAST_INSERT_ID();
			*/

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
					observaciones)	  
			SELECT 	observaciones
			FROM ccc._temp_csv_app_relevamiento
			WHERE id_temp_csv = contador;
			SET ultimo_id_dir = LAST_INSERT_ID();


			/***** Tablas Relacionales *****/

			/**
			 * 
			 */
			INSERT INTO ccc.rel_personas_abonados (
					id_per, id_abo) 
			VALUES(ultimo_id_per,ultimo_id_abo);

			/**
			 * 
			 */
			INSERT INTO ccc.rel_personas_direcciones (
					id_per, id_dir) 
			VALUES(ultimo_id_per,ultimo_id_abo);


			/**
			 * 
			 */
			INSERT INTO ccc.rel_coordenadas_direcciones (
					id_coord_gps, id_dir) 
			VALUES(ultimo_id_coord_gps ,ultimo_id_dir);


			


			SET contador = contador + 1;
		END WHILE;
	END $$
DELIMITER ;

CALL dowhile();



ALTER TABLE ccc._temp_csv_app_relevamiento AUTO_INCREMENT = 1;

/**
 * 
 */
INSERT INTO ccc.personas (
		id_per)
SELECT 	NULL
FROM ccc._temp_csv_app_relevamiento
ORDER BY id_temp_csv ASC;

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
ORDER BY id_temp_csv ASC;

/**
 * 
 */
INSERT INTO ccc.abonados (
		numero_abo)
SELECT 	numero_abonado
FROM ccc._temp_csv_app_relevamiento
ORDER BY id_temp_csv ASC;


INSERT INTO ccc.coordenadas_personas (
		id_coord_gps ,
		id_per) 
FROM ccc.coordenadas_personas, ccc.personas




*********************************************************************************************************************************



/**
 *	Metodo para extraer los POINT almacenados
 */
SELECT ST_AsText(
		coord_gps_dcml_pnt) 
FROM ccc._temp_csv_app_relevamiento;

/**
 *	Obtener el ultimo id del autoincremento ingresado. Puede no coincidir con el valor maximo.
 */
SELECT LAST_INSERT_ID() 
FROM ccc._temp_csv_app_relevamiento;

/**
 *	Mayor valor almacenado
 */
SELECT MAX(
		id_temp_csv) 
FROM ccc._temp_csv_app_relevamiento;

/**
 *	Limpiar tabla
 */
TRUNCATE ccc._temp_csv_app_relevamiento;

/**
 *	Resetea el auto incremento
 */
ALTER TABLE ccc._temp_csv_app_relevamiento AUTO_INCREMENT = 1;


/**
 * 
 */
INSERT INTO ccc.abonados (id_per,numero_abo)
	VALUES (LAST_INSERT_ID(),12345)

/**
 * 
 */
INSERT INTO ccc.personas VALUES (NULL,NULL,NULL,NULL);
INSERT INTO ccc.abonados (id_per,numero_abo)
	VALUES (LAST_INSERT_ID()+1,12345)


*****

INSERT INTO ccc.personas (id_per) VALUES (NULL); 
INSERT INTO ccc.abonados (id_abo, numero_abo) VALUES (NULL, LAST_INSERT_ID());

INSERT INTO ccc.per_abo (id_per, id_abo) VALUES ((SELECT MAX(id_per) FROM ccc.personas),(SELECT MAX(id_abo) FROM ccc.abonados));

UPDATE ccc.personas SET id_per=2 where id_per = 8527

SET contador = contador - 1;

