<?php

	header('Content-Type: text/html; charset=UTF-8');
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
	header("Content-Type: text/html; charset=UTF-8");
	date_default_timezone_set('America/Argentina/Tucuman');
	setlocale(LC_ALL, 'es-AR');

	//require_once("config/config_mapa_abonados.php");
	require_once("config/config.php");

	$bd = new BaseDeDatos("ccc");
	$info_mapa = [];
	$fotos  = "";
	$eleminar_del_path_foto = "/home/pablo/Proyectos/Web";

	$datos = $bd->fetch_all("SELECT numero_abonado, lat, lng FROM ccc.csv_app_relevamiento WHERE lat != 0.0 AND lng != 0.0 AND 						 numero_abonado IS NOT NULL AND lat IS NOT NULL AND lng IS NOT NULL");

	//print_r($datos);
	foreach ($datos as $clave => $dato) {
		//echo "Numero Abonado: {$dato['numero_abonado']} - Punto: ({$dato['lat']} , {$dato['lng']})";
		//echo "<br>";

		$lat = floatval($dato['lat']);
		$lng = floatval($dato['lng']);
		$numero_abonado = $dato["numero_abonado"];
		$res = $bd->query("SELECT rut_arch_orig_foto_inst FROM ccc.fotos_instalaciones WHERE numero_abonado_foto_inst = {$numero_abonado}");

		$foto = $res->fetch_array();

		//print_r($foto);
		
		$foto[0] = str_replace($eleminar_del_path_foto , "" , $foto[0]);

		//echo $foto[0];
		//echo "<br>";


		$info_mapa[] =  ["lat" => $lat, "lng" => $lng, "numero_abonado" => $numero_abonado, "foto" => $foto[0]];
   	}

   	//print_r($info_mapa);

	$bd->cerrar_conexion();
	echo json_encode($info_mapa,JSON_PRETTY_PRINT);

?>