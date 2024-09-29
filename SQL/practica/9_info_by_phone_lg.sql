--Un registro por cada llamada y un flag que indique si la llamada pasa por el step de nombre CUSTOMERINFOBYPHONE.TX y su step_result es OK, quiere decir que hemos podido identificar al cliente a través de su número de teléfono. En ese caso pondremos un 1 en este flag, de lo contrario llevará un 0.

--CREATE OR REPLACE TABLE keepcoding.by_phone AS -- para materializar la tabla
SELECT calls_ivr_id
      , MAX(CASE WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result ='OK' THEN 1
            ELSE 0
            END) AS info_by_phone_lg
  FROM `keepcoding.ivr_detail`
  GROUP BY calls_ivr_id
  ORDER BY  info_by_phone_lg DESC