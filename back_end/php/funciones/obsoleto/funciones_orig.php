<?php

	/**
	 *	Añadir informacion a base de datos.
	 * 	Crear directorios.
	 * 	Dar permisos directorios.
	 * 	Copiar directorios.
	 * 	Eliminar directorios copiados.
	**/

	header('Content-Type: text/html; charset=UTF-8');
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
	header("Content-Type: text/html; charset=UTF-8");
	date_default_timezone_set('America/Argentina/Tucuman');
	setlocale(LC_ALL, 'es-AR');

	require_once("/home/pablo/Proyectos/Apache/nuevo/PFW/mapa_abonados/back_end/php/config/config.php");



	/**
	 *
	**/
	function ruta_archivo_destino ($rutaOrigenEnv, $rutaOrigenArchivo) {

		////////////////////////////////////////////
		// Hacer Globales en config
		//Directorios origen
		$dirOrigen = "/home/pablo/uhfappTest";

		//Directorios destino
		$dirDestino = "{$dirOrigen}/procesados";
		///////////////////////////////////////////


		$aux = explode("/",$rutaOrigenArchivo);
		$i = count($aux);

		$z = $i-1;
		$y = $i-2;
		$x = $i-3;
		$rutaFinal = $dirDestino."/$aux[$x]/$aux[$y]/$aux[$z]";

		//echo "Ruta final: ".$rutaFinal;
		//echo "<br>";

		return $rutaFinal;
	}

	/**
	 * 
	**/
	function numero_abonados_fotos ($rutaOrigenArchivo) {
		//echo $rutaOrigenArchivo;
		//echo "<br>";

		$protoNumAb = explode("_", $rutaOrigenArchivo);
		//echo $protoNumAb[1];
		//echo "<br>";

		$numAb = explode(".", $protoNumAb[1]);
		//echo $numAb[0];
		//echo "<br>";

		return $numAb[0];
	}

	/**
	 *	Compruebo que se hayan copiado todos los archivos
	**/
	function comprobar_copia_y_borrar_original ($ruta_original, $ruta_destino, $tabla) {
		$bd = new BaseDeDatos("app_mapa_abonados");
		$dir = new Directorio();
		$archivosSinCopiar = array();

		$orinalesArchivos = $bd->columna_a_array($ruta_original, $tabla);
		$copiasArchivos = $bd->columna_a_array($ruta_destino,$tabla);
		for($i=0; $i<count($copiasArchivos); $i++) {
			if(file_exists ( $copiasArchivos[$i] )) {
				//echo $copiasArchivos[$i] . " existe!";
				//echo "<br>";
				//Eliminar original
				$dir->borrar($orinalesArchivos[$i]);
			}
			else {
				//echo $copiasArchivos[$i] . " NO EXISTE!!";
				//echo "<br>";
				$archivosSinCopiar[] = $copiasArchivos[$i];
			}
		}

		return $archivosSinCopiar;
	}

	/**
	 *	De los KML solo guardo el numero de usaurio, el resto puedo ser reconstruido.
	**/
	function kml_a_mysql($ruta_original, $ruta_destino) {
		libxml_use_internal_errors(true);
		$bd = new BaseDeDatos("app_mapa_abonados");
		$contents = file_get_contents($ruta_original);
		$xml = simplexml_load_string($contents);

		for($i=0; $i<count($xml);$i++) {
			//echo "Nombre: {$xml->Placemark[$i]->name}";
			//echo "<br>";
			$numbAb = (int)$xml->Placemark[$i]->name;
			//echo "Obversaciones: {$xml->Placemark[$i]->description}";
			//echo "<br>";
			//echo "Coordenadas: 	{$xml->Placemark[$i]->Point->coordinates}";
			//echo "<br>";
			//echo "<br>";
			//$numbAb = numero_abonado_kml($rutaArchivoOrigen[$i]);
			$bd->query("INSERT INTO app_mapa_abonados._temp_kml (numero_abonado, ruta_original_archivo_kml,ruta_destino_archivo_kml) 
					VALUES ('{$numbAb}','{$ruta_original}','{$ruta_destino}')");
		}
	}

	/**
	 *	
	**/
	function inicio_app_mapa_abonados() {

		////////////////////////////////////////////
		// Hacer Globales en config
		//Directorios origen
		$dirOrigen = "/home/pablo/uhfappTest";
		$dirOrigenCSV = "{$dirOrigen}/csv";
		$dirOrigenFoto = "{$dirOrigen}/jpg";
		$dirOrigenKML = "{$dirOrigen}/kml";

		//Directorios destino
		$dirDestino = "{$dirOrigen}/procesados";
		$dirDestinoCSV = "{$dirDestino}/csv";
		$dirDestinoFoto = "{$dirDestino}/jpg";
		$dirDestinoKML = "{$dirDestino}/kml";
		///////////////////////////////////////////

		$dir = new Directorio();
		$bd = new BaseDeDatos("app_mapa_abonados");


		//Vuelco info en Backup
		/*$dir->copiar($dirOrigenCSV, "{$dirOrigen}/BU/csv");
		$dir->copiar($dirOrigenFoto, "{$dirOrigen}/BU/jpg");
		$dir->copiar($dirOrigenKML, "{$dirOrigen}/BU/kml");*/

		/**
		 *	Las 3 bases de datos temporales, _temp_csv, _temp_kml, _temp_foto, obtienen todos sus datos de forma independiente.
		**/
		$rutaArchivoOrigen = $dir->leer_solo_no_directorios($dirOrigenCSV);
		for($i=0; $i<count($rutaArchivoOrigen); $i++) {

			$rutaArchivoDestino = ruta_archivo_destino($dirOrigenCSV , $rutaArchivoOrigen[$i]);

			//echo $rutaArchivoDestino;
			//echo "<br>";

			$bd->query("LOAD DATA LOCAL INFILE '{$rutaArchivoOrigen[$i]}'
						INTO TABLE app_mapa_abonados._temp_csv FIELDS TERMINATED BY '\",'
						LINES TERMINATED BY '\\n'
						(@v_id_celular, @v_mac_celular, @v_numero_abonado, @v_punto_gps_string, @v_punto_gps2, @v_observaciones_instalacion)
						SET id_celular = SUBSTR(TRIM(@v_id_celular), 2),
							mac_celular = SUBSTR(TRIM(@v_mac_celular), 2),
							numero_abonado = CAST(SUBSTR(TRIM(@v_numero_abonado), 2) AS UNSIGNED),
							punto_gps_string = SUBSTR(TRIM(@v_punto_gps_string), 2),
							punto_gps2 = SUBSTR(TRIM(@v_punto_gps2), 2),
							observaciones_instalacion = SUBSTR(TRIM(@v_observaciones_instalacion), 2),
							observaciones_instalacion = SUBSTRING(observaciones_instalacion, 1, LENGTH(observaciones_instalacion)-1),
							ruta_original_archivo_csv = '{$rutaArchivoOrigen[$i]}',
							ruta_destino_archivo_csv = '{$rutaArchivoDestino}'");
		}

		// No realizar este filtro.
		// Pueden haber datos de abonados que no tengan gps pero si otros datos.
		//$bd->query("DELETE FROM app_mapa_abonados._temp_csv WHERE punto_gps_string = '0.0,0.0' OR punto_gps_string IS NULL");

		$rutaArchivoOrigen = $dir->leer_solo_no_directorios($dirOrigenKML);
		for($i=0; $i<count($rutaArchivoOrigen); $i++) {
			$rutaArchivoDestino = ruta_archivo_destino($dirOrigenCSV , $rutaArchivoOrigen[$i]);
			kml_a_mysql($rutaArchivoOrigen[$i], $rutaArchivoDestino);
		}

		$rutaArchivoOrigen = $dir->leer_solo_no_directorios($dirOrigenFoto);
		for($i=0; $i<count($rutaArchivoOrigen); $i++) {
			$rutaArchivoDestino = ruta_archivo_destino($dirOrigenCSV , $rutaArchivoOrigen[$i]);
	 		$numAb = numero_abonados_fotos($rutaArchivoOrigen[$i]);
			$bd->query("INSERT INTO app_mapa_abonados._temp_foto (numero_abonado, ruta_original_archivo_foto, ruta_destino_archivo_foto) 
						VALUES ({$numAb},'{$rutaArchivoOrigen[$i]}', '{$rutaArchivoDestino}')");
		}

		//print_r($dir->leer_solo_no_directorios($dirOrigenFoto));
		//print_r($dir->lista_interativa($dirOrigenFoto));

		//Falta control
		//Si no hubo errores, continua esto:

		//Creo los directorios destino
		$dir->crear($dirDestino);
		$dir->crear($dirDestinoCSV);
		$dir->crear($dirDestinoFoto);
		$dir->crear($dirDestinoKML);

		//Le otoro los permisos necesarios
		$dir->permisos($dirDestino,0777);

		// Copiar los contenidos el el destino
		$dir->copiar($dirOrigenCSV,$dirDestinoCSV);
		$dir->copiar($dirOrigenFoto,$dirDestinoFoto);
		$dir->copiar($dirOrigenKML,$dirDestinoKML);

		$dir->permisos($dirDestino,0777);

		$comprobar = comprobar_copia_y_borrar_original ("ruta_original_archivo_csv", "ruta_destino_archivo_csv","_temp_csv");

		//Si la long de comprobar es meno a 1, entonces los datos fueron copiados correctamente.
		if(count($comprobar) < 1) {
			//realizar el volcado de datos en las bases de datos principales
			//echo "Todo Bien!";

			$dir->borrar($dirOrigenCSV);
			$dir->borrar($dirOrigenFoto);
			$dir->borrar($dirOrigenKML);

			//Abonados
			//Primero inserto todos los numeros de abonados encontrados (de forma independiente) en todos los archivos
			$bd->query("INSERT IGNORE INTO app_mapa_abonados.abonados (numero_abonado) 
						SELECT DISTINCT app_mapa_abonados._temp_csv.numero_abonado 
						FROM app_mapa_abonados._temp_csv");

			$bd->query("INSERT IGNORE INTO app_mapa_abonados.abonados (numero_abonado) 
						SELECT DISTINCT app_mapa_abonados._temp_kml.numero_abonado 
						FROM app_mapa_abonados._temp_kml");

			$bd->query("INSERT IGNORE INTO app_mapa_abonados.abonados (numero_abonado) 
						SELECT DISTINCT app_mapa_abonados._temp_foto.numero_abonado 
						FROM app_mapa_abonados._temp_foto");

			//Actualizo las categorias.
			$bd->query("UPDATE app_mapa_abonados.abonados
						JOIN app_mapa_abonados._temp_csv 
						ON app_mapa_abonados.abonados.numero_abonado = app_mapa_abonados._temp_csv.numero_abonado 
						SET app_mapa_abonados.abonados.punto_gps_string = app_mapa_abonados._temp_csv.punto_gps_string, 
							app_mapa_abonados.abonados.punto_gps2 = app_mapa_abonados._temp_csv.punto_gps2");
			////

			//Instalaciones
			//Inserto los datos
			$bd->query("INSERT INTO app_mapa_abonados.instalaciones (numero_abonado, id_celular, mac_celular, observaciones_instalacion, ruta_archivo_csv)
						SELECT _temp_csv.numero_abonado, _temp_csv.id_celular, _temp_csv.mac_celular, _temp_csv.observaciones_instalacion, _temp_csv.ruta_destino_archivo_csv 
						FROM app_mapa_abonados._temp_csv");

			//Actualizo los datos de _temp.kml
			$bd->query("UPDATE app_mapa_abonados.instalaciones 
						JOIN app_mapa_abonados._temp_kml 
						ON app_mapa_abonados.instalaciones.numero_abonado = app_mapa_abonados._temp_kml.numero_abonado 
						SET app_mapa_abonados.instalaciones.ruta_archivo_kml = app_mapa_abonados._temp_kml.ruta_destino_archivo_kml");

			//Actualizo la referencia a abonados
			$bd->query("UPDATE app_mapa_abonados.instalaciones 
						JOIN app_mapa_abonados.abonados 
						ON app_mapa_abonados.instalaciones.numero_abonado = app_mapa_abonados.abonados.numero_abonado 
						SET app_mapa_abonados.instalaciones.id_ref_abonados = app_mapa_abonados.abonados.id_mae_abonados 
						WHERE app_mapa_abonados.instalaciones.id_ref_abonados is NULL");
			////

			//Fotos
			//Inserto datos
			$bd->query("INSERT INTO app_mapa_abonados.fotos (numero_abonado, ruta_foto)
						SELECT numero_abonado, ruta_destino_archivo_foto
						FROM app_mapa_abonados._temp_foto");

			//Actualizo la referencia a abonados
			$bd->query("UPDATE app_mapa_abonados.fotos
						JOIN app_mapa_abonados.abonados 
						ON app_mapa_abonados.fotos.numero_abonado = app_mapa_abonados.abonados.numero_abonado 
						SET app_mapa_abonados.fotos.id_ref_abonados = app_mapa_abonados.abonados.id_mae_abonados 
						WHERE app_mapa_abonados.fotos.id_ref_abonados is NULL");
		}
		else{
			echo "Ocurrio un error al intentar copiar los archivos";
		}

		$bd->query("TRUNCATE _temp_csv");
		$bd->query("TRUNCATE _temp_kml");
		$bd->query("TRUNCATE _temp_foto");
	}


	/***************************************************************************************************************/
	/***************************************************************************************************************/
	/***************************************************************************************************************/

	/***** Depurar lo que esta arriba de la 3 barras *****/

	/**
	 * 	Descripcion:
	 * 	Salida:
	 * 	Notas:
	 * 	Actualizar:
	 * 		Agregar logging.
	**/
	function comparar_y_sincronizar() {
		$dir = new Directorio();

		if ($dir->comparar(DIR_ORIGEN,DIR_DESTINO)) { 
			echo "Iguales";
		}
		else {
			echo "Distintos";
			echo "<br>";

			if($dir->sincronizar(DIR_ORIGEN,DIR_DESTINO)) {
				echo "Sincronizacion exitosa";
			}
			else {
				echo "<br>";
				echo "<br>";
				echo "Ocurrio un problema durante la sincronizacion";
				echo "<br>";
				echo "Revisar el log de errores.";
			}
		}

		$dir->permisos(DIR_DESTINO, 0777);
	}

	function indexar_datos() {
		
	} 

?>