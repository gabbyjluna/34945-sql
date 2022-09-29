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
---------------------------------------------------------------------------
/*
	S2 -> inserta una boleto nuevo 
		nro_Boleteria -> la boleteria donde se emite el boleto
        nro_Viaje -> el id del viaje al cual pertenecera el boleto
        TipoA -> el tipo de asiento, se ingresa el nombre corto puede ser
        P pasillo o V ventanilla
*/
USE `boleteria_db`;
DROP procedure IF EXISTS `sp_vender_boleto`;

USE `boleteria_db`;
DROP procedure IF EXISTS `boleteria_db`.`sp_vender_boleto`;
;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_vender_boleto`(in nro_Boleteria int, nro_Viaje int, tipoA character)
BEGIN
	-- variables a usar, nro_colectivo guarda el id del colectivo, nro_asiento guarda el id del asiento
	declare nro_colectivo, nro_asiento, nro_boleto int;
    
    -- busca el colectivo de acuerdo al viaje seleccionado
    select v.idColectivo 
    into nro_colectivo 
    from boleteria_db.viajes as v 
    where v.idViajes = nro_Viaje;
    
    -- busca si la posicion indica se encuentra disponible en el colectivo
    if((
    select count(*) from boleteria_db.asientos as a 
    where a.estado = 1 
    and nombreCorto = tipoA 
    and a.idColectivo = nro_colectivo) >=1 ) then
		
        -- guarda el id del primer asiento que encuentra
        select a.idAsientos 
        into nro_asiento 
        from boleteria_db.asientos as a 
        where a.estado = 1 -- estado 1 cuando el asiento esta disponible
        and nombreCorto = tipoA -- nombreCorto P pasillo // V ventanilla
        and a.idColectivo = nro_colectivo 
        limit 1;
        
        -- carga en nro_boleto el nro del boleto a asignar (nroBoleto anterior + 1 )
		select max((bo.nroBoleto)+1) 
        into nro_boleto 
        from boleteria_db.boletos as bo;
        
        -- realiza el insert del boleto
		insert into boleteria_db.boletos (idAsiento, idBoleteria, idViaje, nroBoleto, fecha) 
        values (
			nro_asiento, nro_Boleteria, nro_Viaje, nro_boleto, now() 
		);
        
        -- muestra un mensaje de exito con el nro del boleto creado
        select concat("Se creo el boleto nro ", nro_boleto) as mensaje;
    else 
    
    -- muestra mensaje de error
    select "Posicion no disponible" as error_msg;
    end if;
END$$

DELIMITER ;
;

-- parametros (idBoleteria, idViaje, nombreCorto)
call sp_vender_boleto( 2, 1,'P');
