use mysql;

SELECT * FROM user;

-- creacion usuario mediante la sentencia CREATE USER
Create user 'user_reader'@'localhost' identified by 'readerpass'; -- usuario con permiso de lectura, solo podra hacer select
Create user 'user_writer'@'localhost' identified by 'writerpass'; -- usuario con permoso para escribir, podra hacer select, insert y update 

-- test
select * from USER
where USER in ('user_reader', 'user_writer'); -- muestra los usuarios creados y sus persmisos

-- en un princio los usuarios no tienen asignaos permisos

-- otra forma de ver los permisos y comparar con el usuario admin (root)
SHOW GRANTS FOR 'user_reader'@'localhost';
SHOW GRANTS FOR 'user_writer'@'localhost';
SHOW GRANTS FOR 'root'@'localhost';

-- dar permisos a los usuarios nuevos mediante la sentencia GRANT la cual permite a los admin de las bases de datos brindar privilegios a los usuarios
GRANT SELECT ON *.* TO 'user_reader'@'localhost'; -- se asigna permiso de lectura
GRANT ALL ON *.* TO 'user_writer'@'localhost'; -- se asigna todos los permisos

-- quitar permiso mediante la sentencia REVOKE la cual revoca privilegios a los usuarios
REVOKE DELETE ON *.* FROM 'user_writer'@'localhost'; -- se remueve el permiso de borrado

-- ninguno de las usuarios nuevos tienen el permiso de borrado (DELETE)