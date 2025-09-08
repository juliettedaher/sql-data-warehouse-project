use datawarehouse;

INSERT INTO silver.crm_sales_details (
    sls_cust_id,
    sls_ord_num,
    sls_prd_key,
    sls_quantity,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_price
)
SELECT 
    sls_cust_id,
    sls_ord_num,
    sls_prd_key,
    sls_quantity,

    CASE 
        WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS varchar) AS date)
    END AS sls_order_dt,

    case 
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS varchar) AS date)
    END AS sls_ship_dt,

    CASE 
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS varchar) AS date)
    END AS sls_due_dt,


    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details;


--SELECT DISTINCT
--    sls_sales,
--    sls_quantity,
--    sls_price
--FROM silver.crm_sales_details
--WHERE sls_sales != sls_quantity * sls_price
--OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
--OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
--ORDER BY sls_sales, sls_quantity, sls_price;


--SELECT *
--FROM silver.crm_sales_details
--WHERE sls_sales != sls_quantity * ABS(sls_price)
--   OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
--   OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
--ORDER BY sls_sales, sls_quantity, sls_price;
