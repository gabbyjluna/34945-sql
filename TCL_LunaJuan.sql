
SELECT @@AUTOCOMMIT;

-- seteamos el valor 0 para que no se realice el autocommit
SET AUTOCOMMIT = 0;

-- select la DB
use boleteria_db;

-- Desahacer el borrado de datos de la tabla Viajes  
START TRANSACTION;

-- controlamos los viajes que hay en la tabla
select * from viajes;
select count(*) as CantidadRegistros from viajes; -- 23 registros

-- eliminamos los viajes del día 01/09 de las 20:00 en adelante 
delete from viajes where fecha >= '2022-09-01 20:00:00';

-- controlamos que los campos se borraron en esta sesion
select * from viajes;
select count(*) as CantidadRegistros from viajes; -- 19 registros

-- al ejecutar el roolback se deshace la sentencia DELETE
ROLLBACK;

-- se verifica que no se borraron los datos
select * from viajes;
select count(*) as CantidadRegistros from viajes; -- 23 registros


-- Aplicar el borrado de datos de la tabla viaje
START TRANSACTION;

-- controlamos los viajes que hay en la tabla
select * from viajes;
select count(*) as CantidadRegistros from viajes; -- 23 registros

-- eliminamos los viajes del día 01/09 de las 20:00 en adelante 
delete from viajes where fecha >= '2022-09-01 20:00:00';

-- controlamos que los campos se borraron en esta sesion
select * from viajes;
select count(*) as CantidadRegistros from viajes; -- 19 registros

-- Aplicamos la sentecia DELETE 
COMMIT;

-- se verifica que no se borraron los datos
select * from viajes;
select count(*) as CantidadRegistros from viajes; -- 19 registros

-- -------------------------------------------------------------------

-- insert de datos en la tabla Colectivo con SAVEPOINT
START TRANSACTION;

-- consultamos la tabla
select * from Colectivos;
select count(*) from Colectivos; -- 19

-- insertamos los datos en dos conjutnos
insert into Colectivos values( 20, 100 , 'Mercedez Bendz', 'AF258AA');
insert into Colectivos values( 21, 110 , 'Mercedez Bendz', 'AD147SD');
insert into Colectivos values( 22, 115 , 'Mercedez Bendz', 'AF369XZ');
-- hasta aqui se pone un punto con las tres primeras insersiones
SAVEPOINT despues_3;
insert into Colectivos values( 23, 117 , 'Mercedez Bendz', 'AF357SZ');
insert into Colectivos values( 24, 118 , 'Mercedez Bendz', 'AD159CZ');
-- hasta aqui se pone un punto con las dos siguientes insersiones despues del primer punto
SAVEPOINT despues_5;

-- consultamos la tabla
select * from Colectivos;
select count(*) from Colectivos; -- 24

-- deshace el conjunto de datos insertados en hasta el registro 3
ROLLBACK to savepoint despues_3;

-- consultamos la tabla
select * from Colectivos;
select count(*) from Colectivos; -- 22

-- Deshace todos los insert
ROLLBACK;

-- aplicamos 
COMMIT;



