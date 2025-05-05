--calculation for smart ordering
SELECT
    FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(ORDER_DATE)) AS month, -- Extracts year and month
    SUM(TOTAL_PRICE) AS total_price_sum,
    'bronze_customer_purchase' AS source -- Add a source column to identify the table
FROM 
    `double-reef-187606.aafiyatdb.bronze_customer_purchase`
WHERE 
    CHANNEL IN ('SMART ORDERING', 'SMART_ORDERING')	
GROUP BY 
    month
UNION ALL
SELECT
    FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(ORDER_DATE)) AS month, -- Extracts year and month
    CAST(SUM(TOTAL_PRICE) / 0.56 AS FLOAT64) AS total_price_sum, -- Adjusted revenue calculation
    'cam_purchase' AS source -- Add a source column to identify the table
FROM 
    `double-reef-187606.aafiyatdb.cam_purchase`
GROUP BY
    month
ORDER BY
    month;


--calculation for revenue economy
SELECT
    FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(ORDER_DATE)) AS month, -- Extracts year and month
    CAST(SUM(TOTAL_PRICE) / 0.56 AS FLOAT64) AS revenue_economy 
FROM 
    `double-reef-187606.aafiyatdb.cam_purchase` cp
GROUP BY
    month
ORDER BY
    month;
    

--calculation for smart ordering + revenue economy
WITH smart_ordering AS (
    SELECT
        FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(ORDER_DATE)) AS month, -- Extracts year and month
        SUM(TOTAL_PRICE) AS total_price_sum
    FROM 
        `double-reef-187606.aafiyatdb.bronze_customer_purchase`
    WHERE 
        CHANNEL IN ('SMART ORDERING', 'SMART_ORDERING')	
    GROUP BY 
        month
),
revenue_economy AS (
    SELECT
        FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(ORDER_DATE)) AS month, -- Extracts year and month
        CAST(SUM(TOTAL_PRICE) / 0.56 AS FLOAT64) AS revenue_economy 
    FROM 
        `double-reef-187606.aafiyatdb.cam_purchase`
    GROUP BY
        month
)
SELECT
    so.month,
    COALESCE(so.total_price_sum, 0) + COALESCE(re.revenue_economy, 0) AS total_revenue -- Combines both
FROM
    smart_ordering so
FULL OUTER JOIN
    revenue_economy re
ON
    so.month = re.month
ORDER BY
    so.month;

--Total Sales Agent = Smart Ordering + Revenue Economy
--Total Sales Agent = ....(by month)
