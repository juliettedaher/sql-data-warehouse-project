insert into [silver].[erp_cust_az12](cid , bdate,gen)

select 
case when cid like'NAS%' then substring (cid, 4, len(cid))
else cid 
end as cid,

case when bdate >getdate() then NULL
ELSE bdate
end as bdate,

case when upper(trim(gen)) in ('F' ,'Female') then 'female'
     when upper(trim(gen)) in ('M' ,'Male') then 'Male'
     else 'n\a'
     end gen

from [bronze].[erp_cust_az12]
