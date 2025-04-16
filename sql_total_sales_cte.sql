
--to find customer's owner id 
SELECT 
	 cust_name,
	 order_date,
	 order_status,
	 owner_id
FROM 
	 `double-reef-187606.aafiyatdb.smart_ordering` as so
LEFT JOIN 
	 `double-reef-187606.aafiyatdb.ownership_journey` as oj
	ON 
	  so.CUST_ID = oj.customer_id
WHERE 
	 order_date = '2023-09-30 12:59:17.000';



--calculating total sales by month using CTE
WITH monthly_sales_cte AS (
    SELECT 
        DATE_TRUNC(CAST(month AS DATE), MONTH) AS sales_month, 
        SUM(MTD_SALES) AS total_monthly_sales
    FROM 
        `double-reef-187606.aafiyatdb.month sales hourly record`
    GROUP BY 
        sales_month
)
SELECT 
    sales_month, 
    total_monthly_sales
FROM 
    monthly_sales_cte;
