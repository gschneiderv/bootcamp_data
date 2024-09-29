--CREATE OR REPLACE TABLE keepcoding.vdn_agg AS    --esto es para materializar la tabla
SELECT calls_ivr_id 
      , calls_vdn_label     
      , CASE
            WHEN STARTS_WITH(calls_vdn_label, 'ATC') THEN 'FRONT'
            WHEN STARTS_WITH(calls_vdn_label, 'TECH') THEN 'TECH'
            WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO'
          END AS vdn_aggregation
  FROM `keepcoding.ivr_detail`