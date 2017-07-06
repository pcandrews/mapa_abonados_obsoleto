<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<link rel="shortcut icon" type="image/ico" href="http://www.datatables.net/favicon.ico">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
	<title>Información Instalaciones</title>
	<link rel="stylesheet" type="text/css" href="../../media/css/jquery.dataTables.css">
	<link rel="stylesheet" type="text/css" href="../resources/syntax/shCore.css">
	<link rel="stylesheet" type="text/css" href="../resources/demo.css">
	<style type="text/css" class="init"></style>

	<script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script type="text/javascript" language="javascript" src="../../media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" language="javascript" src="../resources/syntax/shCore.js"></script>
	<script type="text/javascript" language="javascript" src="../resources/demo.js"></script>
	<script type="text/javascript" language="javascript" class="init">
		$(document).ready(function() {
			$('#example').DataTable();
		} );
	</script>

</head>
<body class="dt-example">

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

		require_once("config.php");

		$bd = new BaseDeDatos("ccc");
		//$celulares = $bd->fetch_all("SELECT DISTINCT mac_cel FROM ccc.celulares");
		$celulares = $bd->fetch_all("SELECT DISTINCT * FROM ccc.celulares");

		//$celulares = $bd->fetch_all("




	?>

	<div class="container">
		<section>
			<div class="demo-html"></div>
			<?php

				echo "<h2>Cantidad de instalaciones realizadas: </h3>";

				$res = $bd->query("(SELECT COUNT(DISTINCT id_inst_serv) FROM ccc.instalaciones_servicios)");
				$total_instalaciones = $res->fetch_array();
				echo "<h3>Total: {$total_instalaciones[0]}</h3>";

				echo "<h3>Por movil: </h3>";

				foreach ($celulares as $celular) {												
					$res = $bd->query("SELECT COUNT(DISTINCT `id_inst_serv`) 
									   FROM ccc.rel_instalaciones_servicios_celulares 
									   WHERE mac_cel = '{$celular["mac_cel"]}'
									   AND nombre_cel = '{$celular["nombre_cel"]}'");

					$cantidad_instalaciones = $res->fetch_array();
					echo "{$celular["nombre_cel"]}: {$cantidad_instalaciones[0]}";
					echo "<br>";
				}

				echo "<br>";
				echo "<br>";
				echo "<br>";
			
			?>
			<table id="example" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>Celular</th>
						<th>Fecha</th>
						<th>Observaciones</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th>Celular</th>
						<th>Fecha</th>
						<th>Observaciones</th>
					</tr>
				</tfoot>
				<tbody>					
					<?php

						foreach ($celulares as $celular) {												
							$res = $bd->query("SELECT COUNT(DISTINCT `id_inst_serv`) 
											   FROM ccc.rel_instalaciones_servicios_celulares 
											   WHERE mac_cel = '{$celular["mac_cel"]}'
											   AND nombre_cel = '{$celular["nombre_cel"]}'");

							$cantidad_instalaciones = $res->fetch_array();
							//echo "Cantidad de instalaciones realizadas: {$cantidad_instalaciones[0]}";

							$ids_inst = $bd->fetch_all("SELECT id_inst_serv 
														FROM ccc.rel_instalaciones_servicios_celulares
														WHERE mac_cel = '{$celular["mac_cel"]}'
											   			AND nombre_cel = '{$celular["nombre_cel"]}'");

							foreach ($ids_inst as $id_inst) {							
								$instalaciones = $bd->fetch_all("SELECT observacion_inst_serv, fecha_y_hora_inst_serv 
																 FROM ccc.instalaciones_servicios
																 WHERE id_inst_serv = {$id_inst['id_inst_serv']}
																 ORDER BY fecha_y_hora_inst_serv DESC");

								foreach ($instalaciones as $instalacion) {
									echo "<tr>";
									echo "<td>{$celular["nombre_cel"]}</td>";
									echo "<td>{$instalacion["fecha_y_hora_inst_serv"]}</td>";
									echo "<td>{$instalacion["observacion_inst_serv"]}</td>";
									echo "</tr>";
								}
							}
						}

					?>	
				</tbody>
			</table>
		</section>
	</div>
</body>
</html>