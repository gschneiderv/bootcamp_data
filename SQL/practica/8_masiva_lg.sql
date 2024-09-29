SELECT calls_ivr_id
      ,IF (module_name = 'AVERIA_MASIVA', 1, 0) AS masiva_lg
  FROM `keepcoding.ivr_detail`
QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id  AS NUMERIC) ORDER BY masiva_lg DESC) =1
ORDER BY calls_ivr_id