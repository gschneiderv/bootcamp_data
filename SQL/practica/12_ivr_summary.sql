CREATE OR REPLACE TABLE keepcoding.ivr_sumary AS

WITH masiva_lg 
  AS(SELECT calls_ivr_id
        ,IF (module_name = 'AVERIA_MASIVA', 1, 0) AS masiva_lg
      FROM `keepcoding.ivr_detail`
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id  AS NUMERIC) ORDER BY masiva_lg DESC) =1
  ORDER BY calls_ivr_id)
  , phone_info
  AS (SELECT calls_ivr_id
            , MAX(CASE WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result ='OK' THEN 1
                  ELSE 0
                  END) AS info_by_phone_lg
        FROM `keepcoding.ivr_detail`)
  , dni_info
  AS (SELECT calls_ivr_id
      , MAX(CASE WHEN step_name = 'CUSTOMERINFOBYDNI.TX' AND step_result ='OK' THEN 1
            ELSE 0
            END) AS info_by_dni_lg
        FROM `keepcoding.ivr_detail`)
  , dni_info
  AS (  





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
LEFT
JOIN  masiva_lg
ON detail.calls_ivr_id = masiva.calls_ivr_id
LEFT
JOIN phone_info
ON detail.calls_ivr_id = phone_info.calls_ivr_id
LEFT
JOIN phone_info
ON detail.calls_ivr_id = dni_info.calls_ivr_id
LEFT 
JOIN `keepcoding.repeated_phone_24H` As repeat_24
ON detail.calls_ivr_id = repeat_24.calls_ivr_id
GROUP BY calls_ivr_id


