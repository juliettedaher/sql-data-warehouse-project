use datawarehouse;
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_cost,
    prd_start_dt,
    prd_end_dt,
    prd_line,
    
    prd_nm
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- your category
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,  -- extract prd_key
    ISNULL(prd_cost, 0) AS prd_cost,                -- replace NULL with 0
    CAST(prd_start_dt AS date) AS prd_start_dt,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS date) AS prd_end_dt,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'MOUNTAIN'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'OTHER SALES'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'ROAD'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'TOURING'
    END AS prd_line,
    prd_nm
FROM bronze.crm_prd_info;
