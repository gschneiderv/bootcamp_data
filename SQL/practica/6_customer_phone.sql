--Generar el campo customer_phone

SELECT 
   calls_ivr_id
  ,MAX(NULLIF(NULLIF(customer_phone, ''), 'UNKNOWN')) AS customer_phone
FROM `keepcoding.ivr_detail`
GROUP BY calls_ivr_id
ORDER BY customer_phone DESC