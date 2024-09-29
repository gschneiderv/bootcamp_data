--Como en el ejercicio anterior queremos tener un registro por cada llamada y dos flags que indiquen si el 
--calls_phone_number tiene una llamada las anteriores 24 horas o en las siguientes 24 horas. En caso afirmativo 
--pondremos un 1 en estos flag, de lo contrario llevará un 0.

--Un registro por cada llamada y dos flags que indiquen si el calls_phone_number tiene una llamada las anteriores 24 horas o en las siguientes 24 horas. En caso afirmativo pondremos un 1 en estos flag, de lo contrario llevará un 0.
CREATE OR REPLACE TABLE keepcoding.repeated_phone_24H AS 
WITH data_numbers_calls 
AS (SELECT calls_ivr_id
          , calls_phone_number
          , LAG(calls_start_date) OVER(PARTITION BY calls_phone_number ORDER BY calls_ivr_id ) AS previous_start_date
          , LEAD(calls_start_date) OVER(PARTITION BY calls_phone_number ORDER BY calls_ivr_id) AS next_start_date
    FROM `keepcoding.ivr_detail`
)

SELECT detail.calls_ivr_id
      ,detail.calls_phone_number
      ,data_num.previous_start_date
      , data_num.next_start_date
      , CASE WHEN data_num.previous_start_date IS NULL THEN 0
             WHEN DATETIME_DIFF(calls_start_date, previous_start_date, HOUR) < 24 THEN 1 
             ELSE 0
        END AS repeated_phone_24H
      , CASE WHEN data_num.next_start_date IS NULL THEN 0
             WHEN DATETIME_DIFF(calls_start_date, next_start_date, HOUR) < 24 THEN 1 
             ELSE 0
        END AS cause_recall_phone_24H
FROM `keepcoding.ivr_detail` AS detail
JOIN data_numbers_calls AS data_num
ON detail.calls_ivr_id = data_num.calls_ivr_id