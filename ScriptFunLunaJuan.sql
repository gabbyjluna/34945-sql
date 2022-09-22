/* 
	FN1 fn_calcular_anios -> calcula la diferencias de años entre una fecha 
    y la fecha del momento de ejecucion
		-> recibe una fecha de tipo DATE  
        -> devuelve años de tipo INTEGER
*/
USE `boleteria_db`;
DROP function IF EXISTS `fn_calcular_anios`;

DELIMITER $$
USE `boleteria_db`$$
CREATE FUNCTION `fn_calcular_anios` (fecha date)
RETURNS INTEGER
NO SQL
BEGIN
	declare resultado int;
    set resultado = TIMESTAMPDIFF(year, fecha, now());
RETURN resultado;
END$$

DELIMITER ;

-- prueba de la función
select boleteria_db.fn_calcular_anios('1993-09-10') Años;
-- ---------------------------------------------------------
/*
	FN2 fn_calcular_horas -> calcula la diferencia de horas 
    entre dos horas.
		-> recibe una hora de inicio y una de fin de tipo TIME ambas
        -> devuelve las horas de tipo INTEGER
*/
USE `boleteria_db`;
DROP function IF EXISTS `fn_calcular_horas`;

DELIMITER $$
USE `boleteria_db`$$
CREATE FUNCTION `fn_calcular_horas` (horaini time, horafin time)
RETURNS INTEGER
no sql
BEGIN
	declare horas int;
    set horas = timestampdiff(hour, horaini, horafin);
RETURN horas;
END$$

DELIMITER ;

-- prueba de la función
 select boleteria_db.fn_calcular_horas('06:00:00', '12:00:00') Horas;
-- ---------------------------------------------------------
/*
	FN3 fn_horas_trabajadas_por_periodo_dias -> calcula las horas trabajabadas 
    de un Chofer para un periodo de días
		-> recibe el identificador del Chofer de tipo INTEGER y 
        las fechas desde y hasta del periodo a calcular de tipo DATE
        -> devuelve las horas trabajas de tipo INTEGER
*/
USE `boleteria_db`;
DROP function IF EXISTS `fn_horas_trabajadas_por_periodo_dias`;

DELIMITER $$
USE `boleteria_db`$$
CREATE FUNCTION `fn_horas_trabajadas_por_periodo_dias` (idch int, desde date, hasta date)
RETURNS INTEGER
reads sql data
BEGIN
	declare horas_trabajadas int;
    set horas_trabajadas = (  
		select count(boleteria_db.fn_calcular_horas(t.horaIngreso, t.horaFin)) from turnos as t
        where idChofer = idch
        and t.fecha between desde and hasta
        );
RETURN horas_trabajadas;
END$$

-- prueba de la funcion
select fn_horas_trabajadas_por_periodo_dias(1, '2022-09-01', '2022-09-10') Horas_Trabajadas;

select count(boleteria_db.fn_calcular_horas(t.horaIngreso, t.horaFin)) from turnos as t
where idChofer = 1
and t.fecha between '2022-09-01' and '2022-09-10'
