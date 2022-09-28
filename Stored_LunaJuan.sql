/*
	S1 -> El SP enlista de las tablas en base a los parametros recibidos 
		p_criterio -> indica el nombre de la tabla a consultar 
        p_orden la columnas de ordenamiento de la tabla
*/
USE `boleteria_db`;
DROP procedure IF EXISTS `sp_listar_choferes_colectivos_boleterias()`;

USE `boleteria_db`;
DROP procedure IF EXISTS `boleteria_db`.`sp_listar_choferes_colectivos_boleterias()`;
;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_choferes_colectivos_boleterias`(IN p_criterio varchar(20), p_orden varchar(25))
BEGIN
/*
	p_criterio -> la tabla a la que se va a listar
    p_orden -> la columna de la tabla que se va a ordenar
*/
	CASE lcase(trim(p_criterio))
    WHEN 'choferes' THEN
		SET @clausula =  concat(
        "SELECT concat(apellido,  ', ', nombre) as Nombre 
        FROM boleteria_db.choferes order by "
        , p_orden
        );
	WHEN 'colectivos' THEN
		SET @clausula =  concat(
		"SELECT marca Marca, dominio Dominio FROM boleteria_db.colectivos order by "
        , p_orden)
        ;
	WHEN 'boleterias' THEN
		SET @clausula =  concat(
        "SELECT nombre as Nombre, concat(direccion , ' ' , numero , ' - ', ucase(localidad)) as Direccion 
        FROM boleteria_db.boleterias order by "
        , p_orden)
        ; 
	ELSE
    SELECT "Parametro incorrecto" as error_msj;
		END CASE;
	PREPARE ejecutar_query FROM @clausula;
    EXECUTE ejecutar_query;
    DEALLOCATE PREPARE ejecutar_query;
END$$

DELIMITER ;
;

-- prueba del sp
call sp_listar_choferes_colectivos_boleterias('boleterias', 'direccion');

/*
	S2 -> muestra los asientos disponibles
*/
USE `boleteria_db`;
DROP procedure IF EXISTS `sp_ver_asientos`;

USE `boleteria_db`;
DROP procedure IF EXISTS `boleteria_db`.`sp_ver_asientos`;
;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ver_asientos`(nroColectivo int)
BEGIN
select asientos 
from colectivos
inner join asientos as a
on colectivos.id_colectivos = a.id_colectivo
where colectivos.idColectivos = nroColectivos
and a.estado = 0; 
END$$

DELIMITER ;
;

