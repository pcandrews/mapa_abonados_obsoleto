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
	


	$celulares = $bd->fetch_all("SELECT * FROM celular");
	/*$instalaciones = $bd->fetch_all("SELECT id_inst_serv, observacion_inst_serv, fecha_y_hora_inst_serv 
									 FROM instalaciones_servicios");
	$rel_cel_inst = $bd->fetch_all("SELECT * FROM rel_instalaciones_servicios_celulares");*/
	



	foreach ($celulares as $celular) {
		echo "Movil: {$celular["nombre_cel"]}";
		echo "<br>";


		$res = $bd->query("SELECT COUNT(DISTINCT `id_inst_serv`) 
						   FROM ccc.rel_instalacion_servicio_celular 
						   WHERE mac_cel = '{$celular["mac_cel"]}'");

		$cantidad_instalaciones = $res->fetch_array();

		echo "Cantidad de instalaciones realizadas: {$cantidad_instalaciones[0]}";
		echo "<br>";
		echo "<br>";



		$ids_inst = $bd->fetch_all("SELECT id_inst_serv 
								    FROM ccc.rel_instalacion_servicio_celular
								    WHERE mac_cel = '".$celular['mac_cel']."'");

		foreach ($ids_inst as $id_inst) {
			//echo "<br>";
			//print_r($id_inst);
			//echo $id_inst['id_inst_serv'];
			//echo "<br>";
		
			$instalaciones = $bd->fetch_all("SELECT observacion_inst_serv, fecha_y_hora_inst_serv 
									 	 	 FROM ccc.instalacion_servicio
									 	 	 WHERE id_inst_serv = {$id_inst['id_inst_serv']}
									 	 	 ORDER BY fecha_y_hora_inst_serv DESC");
	
			foreach ($instalaciones as $instalacion) {

				echo "Fecha: {$instalacion["fecha_y_hora_inst_serv"]}";
				echo "<br>";
				echo "Observaciones: {$instalacion["observacion_inst_serv"]}";
				echo "<br>";
				echo "<br>";
				echo "<br>";
			}
		}


		echo "<br>";
		echo "<br>";
		echo "<br>";
		echo "<br>";
		echo "<br>";
		echo "<br>";
		echo "*********************************************************************";
		echo "<br>";
		echo "<br>";

	}




	
	$bd->cerrar_conexion();

?>