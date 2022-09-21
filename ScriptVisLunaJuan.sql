-- V1 -> muestra los datos de los choferes.
create view boleteria_db.vwChoferes as (
select concat( ch.apellido , ", ", ch.nombre ) Nombre, 
	timestampdiff(year, ch.fechaNac, now()) Edad,
    ch.fechaIngr Fecha_de_ingreso,
    timestampdiff(day, ch.fechaIngr, now()) Antiguedad_Dias
	from boleteria_db.choferes as ch 
); 
-- select * from boleteria_db.Turno_Choferes;

-- V2 -> muestra la cantidad de asientos ocupados por colectivo por fecha
create view boleteria_db.vwCantidadAsientosDisponibles as (
select co.nroUnidad Numero_del_Colectivo, 
	count(a.estado) Cantidad_de_asientos_disponibles 
from boleteria_db.colectivos as co 
inner join boleteria_db.asientos as a 
on co.idColectivos = a.idColectivo 
and a.estado = 1 
group by co.nroUnidad
);

-- V3 -> muestra el turno de los choferes y el número de colectivo que anduvieron ese día.
create view boleteria_db.vwTurnoChoferes as (
select concat( ch.apellido , ", ", ch.nombre ) Nombre, 
    co.nroUnidad Numero_del_Colectivo,
    t.descripcion Turno,
    t.fecha Fecha
from boleteria_db.choferes as ch 
inner join boleteria_db.turnos as t
inner join boleteria_db.colectivos as co
on ch.idChoferes = t.idChofer
and co.idColectivos = t.idColectivo
order by t.fecha
); 

-- V4 -> muestra la cantidad de boletos emitidos por boleteria
create view boleteria_db.vwCantidadBoletosXBoleteria as (
select bria.nombre Nombre, concat(bria.direccion, " ", bria.numero) Direccion, count(bol.nroBoleto)
from boleteria_db.boleterias as bria 
inner join boleteria_db.boletos as bol 
on bria.idBoleterias = bol.idBoleteria
group by bria.nombre
);

-- V5 -> muestra las paradas de los recorridos y sus precios
create view boleteria_db.vwPrecioXParadas as (
select re.idRecorridos Recorrido_Nro,
	concat( pa.direccion, " ", pa.numero, " - ", pa.localidad ) Direccion_de_la_Parada,
	t.precio Precio
from boleteria_db.recorridos re 
inner join boleteria_db.paradas as pa 
inner join boleteria_db.tarifas as t
on re.idRecorridos = pa.idRecorrido
and re.idRecorridos = t.idRecorrido
);
