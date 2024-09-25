
--QUERIES:
--Se verifican las relaciones mediante algunas de las queries propuestas en el diagrama: 

--¿Cuántos alumnos están inscriptos a cada Bootcamp?

 SELECT "name" AS bootcamp_name
     , COUNT(inscription.inscription_id) AS count_inscriptions
 FROM bootcamp
 LEFT
 JOIN inscription
 ON bootcamp.bootcamp_id = inscription.bootcamp_id
 GROUP BY "name"
 ORDER BY count_inscriptions DESC

 
 -- Hay algún módulo que forme parte de todos los bootcamps? (Sabiendo que hay 10 bootcamps en total)

 
SELECT module."name" AS name_module
     , COUNT(*) AS num_bootcamps
FROM bc_module
JOIN "module"
ON bc_module.module_id = "module".module_id
GROUP BY "module"."name"
HAVING COUNT(*) > 1 -- con  COUNT(*) = 10 se obtiene directamente el módulo que forma parte de todos los bootcamps


WITH bootcams_with_module_ids AS (
	SELECT * 
	FROM bootcamp bc 
	JOIN bc_module ON bc.bootcamp_id = bc_module.bootcamp_id
	)

SELECT bc_mod.name, m.name 
FROM module m
LEFT JOIN bootcams_with_module_ids bc_mod
ON m.module_id = bc_mod.module_id