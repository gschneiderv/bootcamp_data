--Generar el campo billing_account_id: un registro por cada llamada y un sólo cliente identificado para la misma.

SELECT 
   calls_ivr_id
  ,MAX(NULLIF(billing_account_id,'UNKNOWN')) AS billing_account_id
FROM `keepcoding.ivr_detail`
GROUP BY calls_ivr_id
