-- q3 - top 3 customers per region
-- PARTITION BY restarts the ranking for each region
-- then i just keep ranks 1-3

WITH customer_region_sales AS (
    -- sales per customer per region
    SELECT
        dl.region_name,
        dc.customer_name,
        SUM(fs.sales)  AS total_sales,
        SUM(fs.profit) AS total_profit
    FROM fact_sales fs
    JOIN dim_customer dc ON dc.customer_id = fs.customer_id
    JOIN dim_location dl ON dl.location_id = fs.location_id
    GROUP BY dl.region_name, dc.customer_name
),
ranked AS (
    -- rank within each region
    SELECT
        region_name,
        customer_name,
        total_sales,
        total_profit,
        RANK() OVER (PARTITION BY region_name ORDER BY total_sales DESC) AS customer_rank
    FROM customer_region_sales
)
SELECT
    region_name,
    customer_name,
    ROUND(total_sales, 2)  AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    customer_rank
FROM ranked
WHERE customer_rank <= 3
ORDER BY region_name, customer_rank;
