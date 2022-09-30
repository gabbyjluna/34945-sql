use boleteria_db;

-- create table Auditoria
create table log_table (
	idLog int not null auto_increment,
    tabla varchar(20),
    accion varchar(20),
    mensaje varchar(100),
    usuario varchar(25),
    fecha datetime,
    primary key (idLog)
);
drop table log_table;
/*
	T1 -> turnos_AFTER_INSERT -> el trigger guarda en la tabla log el usuairio, fecha y hora de quien 
			planifico un horario nuevo que vincule a un chofer y un colectivo.
*/
DROP TRIGGER IF EXISTS `boleteria_db`.`turnos_AFTER_INSERT`;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER = CURRENT_USER TRIGGER `boleteria_db`.`turnos_AFTER_INSERT` AFTER INSERT ON `turnos` FOR EACH ROW
BEGIN
	insert into log_table (tabla, accion, mensaje, usuario, fecha) 
    values (
		'turnos', 
        'Ingresar Valor', 
        concat('El chofer ',new.idChofer,
			' ingresara: ',new.horaIngreso,
			' saldra: ', new.horaFin,
            ' el día: ', new.fecha), 
		user(), now()
    );
END$$
DELIMITER ;

/*
	T2 -> turnos_AFTER_INSERT -> antes de insertar un nuevo horario toma el campo descripcion que hace 
		referencia al nombre del horario y toma la inicial en mayuscula y lo inserta 
        en el campo `nombreCorte` (error de tipeo en el nombre)
*/
DROP TRIGGER IF EXISTS `boleteria_db`.`turnos_AFTER_INSERT`;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `turnos_AFTER_INSERT` AFTER INSERT ON `turnos` FOR EACH ROW BEGIN
	insert into log_table (tabla, accion, mensaje, usuario, fecha) 
    values (
		'turnos', 
        'Ingresar Valor', 
        concat('El chofer ',new.idChofer,
			' ingresara: ',new.horaIngreso,
			' saldra: ', new.horaFin,
            ' el día: ', new.fecha), 
		user(), 
        now()
    );
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS `boleteria_db`.`turnos_BEFORE_INSERT`;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER = CURRENT_USER TRIGGER `boleteria_db`.`turnos_BEFORE_INSERT` BEFORE INSERT ON `turnos` FOR EACH ROW
BEGIN
    set new.nombreCorte =  upper(left(new.descripcion, 1));
END$$
DELIMITER ;

 -- probamos el triggers insertando un nuevo horario
insert into boleteria_db.turnos(idChofer,idColectivo,descripcion,fecha,horaIngreso,horaFin) values(
	1,1,'Mañana','2022-09-29','18:00:00','24:00:00');

-- probamos la tabla para ver el contenido que se inserta
select * from turnos where fecha > '2022-09-20';

-- probamos el log
select * from log_table;

-- -------------------------------------------------------------------------------------------------

/*
	T3 -> tarifas_BEFORE_UPDATE -> al momento de actualizar la tarifa de un viaje, 
    el trigger guarda el importe de la tarifa saliente en una tabla historica de tarifas.
*/

-- se crea tabla de historica_tarifas
create table historica_tarifas (
	idHT int not null auto_increment,
    idold int not null,
    precioOld double not null,
    idRecorrido int not null,
    fechaModificacion datetime,
    primary key (idHT)
);

DROP TRIGGER IF EXISTS `boleteria_db`.`tarifas_BEFORE_UPDATE`;

DELIMITER $$
USE `boleteria_db`$$
CREATE DEFINER = CURRENT_USER TRIGGER `boleteria_db`.`tarifas_BEFORE_UPDATE` BEFORE UPDATE ON `tarifas` FOR EACH ROW
BEGIN
	insert into historica_tarifas (idOld, precioOld, idRecorrido, fechaModificacion)
    values (
		old.idTarifas, 
        old.precio,
        old.idRecorrido,
        now()
    );
END$$
DELIMITER ;

-- prueba 
select * from tarifas where idTarifas = 1;
select * from historica_tarifas;

update tarifas
set precio = 120
where idTarifas = 1;


