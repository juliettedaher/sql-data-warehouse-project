--===============================================================================
--DDL Script: Create Gold Views
--===============================================================================

--customers.gold_view
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

create view gold.dim_customers as 
select 
    row_number() over (order by cst_id) as customer_key ,
    ci.cst_id as customer_id,
    ci.cst_key as customer_number,
    ci.cst_firstname as customer_f_name,
    ci.cst_lastname as customer_l_name,
    ci.cst_marital_status as customer_marital_status,
    ci.cst_create_date as customer_create_date,
    ca.bdate as birthdate,
    case when ci.cst_gndr !='N/A3' then ci.cst_gndr 
      else coalesce (ca.gen,'n\a')
    end as gender,

    la.cntry as country
from [silver].[crm_cust_info] ci left join [silver].[erp_cust_az12] ca 
on ci.cst_key=ca.cid
left join [silver].[erp_loc_a101] la on ci.cst_key=la.cid

--having count(*)>1


---  products view  ---
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

create view gold.dim_products as

select 
 ROW_NUMBER()  over(order by pn.prd_start_dt ,pn.prd_key) as product_key,

pn.prd_id as product_id  ,
pn.prd_key as prodcut_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pn.prd_cost as product_cost ,
pn.prd_line as product_line,
pn.prd_start_dt as product_start_date,
pc.maintenance 

from [silver].[crm_prd_info] pn left join [silver].[erp_px_cat_g1v2] pc 
on pn.cat_id=pc.id
where pn.prd_end_dt is null;


--- sales view  ---
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

create view  gold.fact_sales as 
select 
sd.sls_ord_num as order_number,
 pr.product_key,
 cu.customer_key,
 
 sd.sls_order_dt as order_date,
 sd.sls_ship_dt as shipping_date,
 sd.sls_due_dt as due_date,
 sd.sls_sales as sales_amount,
 sd.sls_quantity as quantity,
 sd.sls_price as price

from silver.crm_sales_details as sd 
left join gold.dim_products as pr
on sd.sls_prd_key=pr.[prodcut_number] 
left join gold.dim_customers as cu
on cu.customer_id=sd.sls_cust_id;
