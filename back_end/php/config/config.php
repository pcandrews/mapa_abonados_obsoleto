<?php

	/**
	*	Dependecias:
	*	Descripcion:
	*/

	header('Content-Type: text/html; charset=UTF-8'); 
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
 	header("Content-Type: text/html; charset=UTF-8");
 	date_default_timezone_set('America/Argentina/Tucuman');
 	setlocale(LC_ALL, 'es-AR');

 	//estas rutas tienen q estar completas
 	
 	//maquina virtual
 	//require_once("/home/pablo/Proyectos/Apache/nuevo/PFW/pfw/php/config/config.php");
 	//require_once("/home/pablo/Proyectos/Apache/nuevo/PFW/mapa_abonados/back_end/php/funciones/funciones.php");
 	//
 	//defined('DIR_ORIGEN') ? null : define('DIR_ORIGEN', DS.'home'.DS.'pablo'.DS.'uhfapp'.DS);
 	//
 	 	
 	require_once("/home/pablo/Proyectos/Web/PFW/pfw/php/config/config.php");
 	require_once("/home/pablo/Proyectos/Web/PFW/mapa_abonados/back_end/php/funciones/funciones.php");
 
 	//Directorios archivos
	//defined('DIR_ORIGEN') ? null : define('DIR_ORIGEN', SITE_ROOT.DS.'mapa_abonados'.DS.'back_end'.DS.'uhfapp'.DS);
	defined('DIR_ORIGEN') ? null : define('DIR_ORIGEN','/home/pablo/uhfapp/');
	defined('DIR_DESTINO') ? null : define('DIR_DESTINO', SITE_ROOT.DS.'mapa_abonados'.DS.'back_end'.DS.'data'.DS.'backup_uhfapp');
	
?>