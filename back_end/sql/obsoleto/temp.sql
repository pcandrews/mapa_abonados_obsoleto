DROP PROCEDURE IF EXISTS dowhile;


DELIMITER $$
	CREATE PROCEDURE dowhile()
	BEGIN

		DECLARE contador INT DEFAULT 1;
		DECLARE cant_abonados INT DEFAULT 0;
		DECLARE ultimo_id_per INT DEFAULT 0;
		DECLARE ultimo_id_abo INT DEFAULT 0;
		DECLARE id_minimo INT DEFAULT 0;

		SET cant_abonados = (SELECT COUNT(DISTINCT numero_abonado) FROM ccc._temp_csv_app_relevamiento);

		

		SELECT contador;
		SELECT cant_abonados;
		SELECT ultimo_id_per;
		SELECT ultimo_id_abo;
		WHILE contador <= cant_abonados DO

			SET id_minimo = (SELECT MIN(id) FROM ccc._temp_csv_app_relevamiento WHERE id > id_minimo);
			#SELECT id_minimo;

			/**
			 * 
			 */
			INSERT INTO ccc.personas (
					id_per) 
			VALUES (NULL);
			SET ultimo_id_per = LAST_INSERT_ID();


			/**
			 * 
			 */
			/*INSERT IGNORE INTO ccc.abonados (
					numero_abo) 
			SELECT DISTINCT numero_abonado 
			FROM ccc._temp_csv_app_relevamiento 
			WHERE id = id_minimo;*/

			/**
			 * 
			 */
			INSERT INTO ccc.abonados (
					numero_abo) 
			SELECT numero_abonado 
			FROM ccc._temp_csv_app_relevamiento 
			WHERE id = id_minimo AND;
			SET ultimo_id_abo = LAST_INSERT_ID();



			/*INSERT INTO ccc.rel_personas_abonados (
					id_per, 
					id_abo) 
			VALUES (ultimo_id_per, ultimo_id_abo );*/	


			#VALUES (ultimo_id_per, (SELECT DISTINCT numero_abonado FROM ccc._temp_csv_app_relevamiento WHERE id = id_minimo));			

			#DELETE FROM ccc._temp_csv_app_relevamiento WHERE id = id_minimo;

			SET contador = contador + 1;

		END WHILE;
	END $$
DELIMITER ;

CALL dowhile();

#guardado en utiles.sql
INSERT IGNORE INTO ccc.abonados (numero_abo) 
SELECT DISTINCT numero_abonado
FROM ccc.csv_app_relevamiento 
WHERE numero_abonado NOT IN (SELECT numero_abo 
							 FROM ccc.abonados);