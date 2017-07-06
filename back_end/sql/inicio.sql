
/**
 * 	Crear usuario con contraseña.
 */
CREATE USER 'ccc_admin' IDENTIFIED BY 'sanlorenzo';


/**
 * 	Garantizar privilegios usuario.
 * 	Nota: aqui estoy dandole todos los privilegios, seria conveniente restringirlos en el futuro.
 */
REVOKE ALL PRIVILEGES ON *.* FROM 'ccc_admin'@'%'; 
GRANT ALL PRIVILEGES ON *.* 
TO 'ccc_admin'@'%' 
REQUIRE NONE WITH GRANT OPTION 
		MAX_QUERIES_PER_HOUR 0 
		MAX_CONNECTIONS_PER_HOUR 0 
		MAX_UPDATES_PER_HOUR 0 
		MAX_USER_CONNECTIONS 0;


/**
 *	Base de datos: 
 */
CREATE DATABASE IF NOT EXISTS ccc
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_spanish_ci;


/**
 *	Privilegios usuario.
 */
GRANT ALL PRIVILEGES ON ccc.* TO ccc_admin@localhost; 


/**
 * 	Refrescar todos los privilegios. siempre que haya un cambio de privilegios.
 */
FLUSH PRIVILEGES;