-- Se quiere tener un registro por cada llamada y un sólo cliente identificado para la misma (por document_type  & document_identification)

--CREATE OR REPLACE TABLE keepcoding.document_type_ident AS -- para materializar la tabla
SELECT calls_ivr_id
      , MAX(NULLIF(NULLIF(document_type, 'UNKNOWN'), 'DESCONOCIDO')) As document_type
      , MAX(NULLIF(NULLIF(document_identification,'UNKNOWN'), 'DESCONOCIDO')) AS document_identification
FROM `keepcoding.ivr_detail`
GROUP BY calls_ivr_id
ORDER BY document_type DESC, document_identification DESC 
