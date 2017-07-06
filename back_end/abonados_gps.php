<?php
	
	/**
	 * 
	 */
	header('Content-Type: text/html; charset=UTF-8');
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
	header("Content-Type: text/html; charset=UTF-8");
	date_default_timezone_set('America/Argentina/Tucuman');
	setlocale(LC_ALL, 'es-AR');

	require_once("php/config/config.php");


	$bd = new BaseDeDatos("ccc");
	$archivo = 'data/abonados_gps/abonados_gps.csv';

	$filas = $bd->query("SELECT numero_abonado, lat, lng FROM csv_app_relevamiento");
	
	/*
	print_r($filas);	
	echo "<br>";
	echo "<br>";
	echo "<br>";
	echo "<br>";
	echo "<br>";

	$fet = $bd->fetch_array($filas);
	print_r($fet);

	$filas = $bd->fetch_all("SELECT numero_abonado, coord_gps_dcml_str FROM csv_app_relevamiento");
	print_r($filas);

	echo "<br>";
	echo "<br>";
	echo "<br>";
	echo "<br>";
	echo "<br>";
	*/

	$fp = fopen($archivo, 'w');

	foreach ($filas as $val) {
		fputcsv($fp, $val);
	}

	fclose($fp);

	if (file_exists($archivo)) {			
		header('Content-Description: File Transfer');
		header("Content-type: text/csv");
		header('Content-Disposition: attachment; filename='.basename($archivo));
		header('Content-Transfer-Encoding: binary');
		header('Expires: 0');
		header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
		ob_end_clean();
		readfile($archivo);
		unlink($archivo);
	}
	else {
		echo "Ocurrio un error durante la creación del archivo";
		echo "<br>";
	}
?>