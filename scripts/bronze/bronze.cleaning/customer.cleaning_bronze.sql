use datawarehouse;
truncate table  silver.crm_cust_info;
select * from silver.crm_cust_info;
select * from bronze.crm_cust_info;
insert into silver.crm_cust_info(
cst_id,
cst_create_date,
cst_firstname,
cst_lastname,
cst_gndr,
cst_marital_status,
cst_key)


select 
cst_id,
cst_create_date,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,

--we removed the unwanted spaces from those 2 columns--
case when UPPER(TRIM(cst_gndr))='F' THEN 'Female'
     when UPPER(TRIM(cst_gndr))='M' THEN 'Male'
     ELSE 'n/a'
END  as cst_gndr,

--data standardazarion and consistency--

case when UPPER(TRIM(cst_marital_status))='S' THEN 'SINGLE'
     when UPPER(TRIM(cst_marital_status))='M' THEN 'MARRIED'
     ELSE 'N/A'
end as cst_marital_status,
cst_key
from(
select *, ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info)

t where flag_last=1
  and cst_id is not null;
