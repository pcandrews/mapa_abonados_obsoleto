<pre>

<?php
	
	/**
	 *	Este script solo sive para inicializar tablas que no se utilizan todavia.
	 *	Se debe utlizar solo 1 vez, cuando todos los datos esten en cero.
	 *	Retirar del script, todas las tablas que se usen de forma normal.
	 *	Cuando todas las tablas sean utlizadas de forma regualar, este script debe ser eliminado.
	 */
	header('Content-Type: text/html; charset=UTF-8');
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
	header("Content-Type: text/html; charset=UTF-8");
	date_default_timezone_set('America/Argentina/Tucuman');
	setlocale(LC_ALL, 'es-AR');

	require_once("php/config/config.php");

	$bd = new BaseDeDatos("ccc");

	$bd->query("INSERT INTO ccc.persona (id_per) 
				VALUES (1);");


	$bd->query("INSERT INTO ccc.empleado (id_emp)
				VALUES (1);");


	$bd->query("INSERT INTO ccc.rel_persona_empleado (id_emp, 
									id_per) 
				VALUES (1, 
						1);");


	$bd->query("INSERT INTO ccc.instalador (id_instdr)
				VALUES (1);");


	$bd->query("INSERT INTO ccc.rel_empleado_instalador (id_emp, 
										id_instdr) 
				VALUES (1, 
						1);");
	

	$bd->query("INSERT INTO ccc.factura  (id_fact) 
				VALUES (1);");


	$bd->cerrar_conexion();
	
?>

</pre>