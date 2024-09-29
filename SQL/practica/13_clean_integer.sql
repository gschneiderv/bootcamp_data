--Crear una función de limpieza de enteros por la que si entra un null la función devuelva el valor -999999.

 CREATE OR REPLACE FUNCTION keepcoding.clean_integer(p_int INT64) RETURNS INT64 AS
((SELECT IFNULL(p_int, -999999)))