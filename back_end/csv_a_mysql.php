<pre>

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

	$lista_sincro = array();

	$lista_sincro = sincronizar_directorios();

	//print_r($lista_sincro['csv']);
	//print_r($lista_sincro['jpg']);
	//print_r($lista_sincro['kml']);


	indexar_datos_csv($lista_sincro['csv']);
	indexar_datos_jpg($lista_sincro['jpg']);
	indexar_datos_kml($lista_sincro['kml']);


?>

</pre>