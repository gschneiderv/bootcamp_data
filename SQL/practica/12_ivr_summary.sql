CREATE OR REPLACE TABLE keepcoding.ivr_sumary AS
SELECT detail.calls_ivr_id AS ivr_id
      ,detail.calls_phone_number AS phone_number
      ,detail.calls_ivr_result AS ivr_result
      , CASE
            WHEN STARTS_WITH(calls_vdn_label, 'ATC') THEN 'FRONT'
            WHEN STARTS_WITH(calls_vdn_label, 'TECH') THEN 'TECH'
            WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO'
        END AS vdn_aggregation    
      ,detail.calls_start_date AS start_date
      ,detail.calls_end_date AS end_date
      ,detail.calls_total_duration AS total_duration
      ,detail.calls_customer_segment AS customer_segment
      ,detail.calls_ivr_language As ivr_language
      ,detail.calls_steps_module AS steps_module
      ,detail.calls_module_aggregation AS module_aggregation
      ,MAX(NULLIF(NULLIF(document_type, 'UNKNOWN'), 'DESCONOCIDO')) As document_type
      ,MAX(NULLIF(NULLIF(document_identification,'UNKNOWN'), 'DESCONOCIDO')) AS document_identification
      ,MAX(NULLIF(NULLIF(customer_phone, ''), 'UNKNOWN')) AS customer_phone
      ,MAX(NULLIF(billing_account_id,'UNKNOWN')) AS billing_account_id
      
FROM `keepcoding.ivr_detail` AS detail
JOIN 
ON
GROUP BY calls_ivr_id


