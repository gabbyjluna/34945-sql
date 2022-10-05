drop schema Boleteria_DB;
create schema Boleteria_DB;
use Boleteria_DB;

create table choferes (
	idChoferes int not null,
   	dni int,
   	apellido varchar(50),
   	nombre varchar(50),
   	fechaNac date,
   	fechaIngr date,
   	primary key (idChoferes)
);

create table colectivos (
	idColectivos int not null,
   	nroUnidad int, -- nro de la unidad
   	marca varchar(50), -- especifica la marca del vehiculo
   	dominio varchar(15), -- numero de registro del vehiculo
   	index(nroUnidad),
   	primary key(idColectivos)
);
    
create table turnos (
	idTurnos int not null,
        idChofer int not null,
        idColectivo int not null,
        descripcion varchar(50),
        nombreCorte varchar(2),
        fecha date,
        horaIngreso time,
        horaFin time,
        foreign key(idChofer) references choferes(idChoferes),
        foreign key(idColectivo) references colectivos(idColectivos),
        primary key(idTurnos)
);
    
create table asientos (
	idAsientos int not null,
        idColectivo int not null,
        numero int,
        lado varchar(10), -- puede ser ventanilla o pasillo
        nombreCorto varchar(2), -- pasillo -> p / ventanilla -> v / centro C
	estado int default 0, -- disponible -> 0 / ocupado -> 1
        foreign key(idColectivo) references colectivos(idColectivos),
        primary key(idAsientos)
);
    
create table boleterias (
	idBoleterias int not null,
        nombre varchar(500), -- nombre de la sucursal 
        direccion varchar(100),
        numero int,
        localidad varchar(150),
        primary key(idBoleterias)
);
    
create table recorridos (
	idRecorridos int not null,
        sentido int, -- 0 o 1
        descripcion varchar(150),
        recorrido varchar(8000),
        primary key(idRecorridos)
);
    
create table paradas (
	idParadas int not null,
        idRecorrido int not null,
        direccion varchar(100),
        numero int,
        localidad varchar(25),
        foreign key(idRecorrido) references recorridos(idRecorridos),
        primary key(idParadas)
);
    
create table tarifas (
	idTarifas int not null,
        idRecorrido int not null,
        precio double,
        foreign key(idRecorrido) references recorridos(idRecorridos),
        primary key(idTarifas)
);

create table viajes (
	idViajes int not null,
	idColectivo int not null,
        idRecorrido int not null,
        fecha datetime,
        foreign key(idRecorrido) references recorridos(idRecorridos),
	foreign key(idColectivo) references colectivos(idColectivos),
        primary key(idViajes)
);
    
create table boletos (
	idBoletos int not null,
        idAsiento int not null,
        idBoleteria int not null,
        idViaje int not null,
        nroBoleto int,
        fecha datetime,
        foreign key(idAsiento) references asientos(idAsientos),
        foreign key(idBoleteria) references boleterias(idBoleterias),
        foreign key(idViaje) references viajes(idViajes),
        primary key(idBoletos)
);
    
-- drop schema Boleteria_DB;
    
