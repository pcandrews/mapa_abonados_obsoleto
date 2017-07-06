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

	$ruta_orig = "/home/pablo/Proyectos/Web/PFW/mapa_abonados/back_end/uhfapp/kml/movil-61/20160830.kml";
	$ruta_orig = "/home/pablo/Proyectos/Web/PFW/mapa_abonados/back_end/uhfapp/kml/MOVIL_128/20161205.kml";
	$ruta_orig = "/home/pablo/Proyectos/Web/PFW/mapa_abonados/back_end/uhfapp/kml/MOVIL_64/20161107.kml";
	
	$dom = new DOMDocument;
	$contenido = file_get_contents($ruta_orig);
	$dom->loadXML($contenido);
	
	$placemarks = $dom->getElementsByTagName('Placemark');

	//$long = $numeros_abonados->length;

	//echo $long;
	//echo "<br>";
	//echo "<br>";

	foreach ($placemarks as $placemark) {
		$numeros_abonados= $placemark->getElementsByTagName("name");
		$observaciones = $placemark->getElementsByTagName('description');
		$coordenadas = $placemark->getElementsByTagName('coordinates');

		echo $numeros_abonados->item(0)->nodeValue; 
		echo "<br>";
		echo $observaciones->item(0)->nodeValue; 
		echo "<br>";
		echo $coordenadas->item(0)->nodeValue; 
		echo "<br>";
		echo "<br>";
		echo "<br>";
	}

?>

</pre>