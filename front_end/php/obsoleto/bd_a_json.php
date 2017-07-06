<?php

	header('Content-Type: text/html; charset=UTF-8');
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
	header("Content-Type: text/html; charset=UTF-8");
	date_default_timezone_set('America/Argentina/Tucuman');
	setlocale(LC_ALL, 'es-AR');

	require_once("config/config_mapa_abonados.php");

	$bd = new BaseDeDatos("ccc");


	$datos = $bd->leer("numero_abonado, coord_gps_dcml_str","csv_app_relevamiento", "coord_gps_dcml_str != '0.0,0.0' and coord_gps_dcml_str IS NOT NULL");
	
	$datos = $bd->fetch_all("Select numero_abonado, lat, lng FROM csv_app_relevamiento WHERE lat != 0.0 AND lng != 0.0 AND numero_abonado IS NOT NULL AND lat IS NOT NULL AND lng IS NOT NULL");


	//print_r($datos);


	foreach ($datos as $clave => $dato) {
		echo "Numero Abonado: {$dato['numero_abonado']} - Punto: {$dato['lat']} - {$dato['lng']}";
		echo "<br>";

		$lat = $dato['lat'];
		$lng = $dato['lng'];
		$numero_abonado = $dato["numero_abonado"];


		$info_mapa[] =  ["lat" => $lat, "lng" => $lng, "detalles" => $numero_abonado];
   	}


	/*foreach ($datos as $clave => $dato) {
		//echo "Numero Abonado: {$dato["numero_abonado"]} - Punto: {$dato["punto_gps_string"]}";
		//echo "<br>";

		if($dato["coord_gps_dcml_str"] != NULL) {
			$punto = explode(",", $dato["coord_gps_dcml_str"]);
			//print_r($punto);
			$lat = floatval($punto[0]);
			$lng = floatval($punto[1]);
			$numero_abonado = $dato["numero_abonado"];

			//echo "lat ".$lat;
			if($lat != NULL) {
				if($lng != NULL) {
					$info_mapa[] =  ["lat" => $lat, "lng" => $lng, "detalles" => $numero_abonado];
				}
			}
		}
   	}*/

	$bd->cerrar_conexion();
	echo json_encode($info_mapa,JSON_PRETTY_PRINT);

?>