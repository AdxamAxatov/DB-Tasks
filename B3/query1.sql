-- q1 - top products by profit
-- shows the rank and how much less profit each one made vs the one above
-- RANK = position
-- LAG = grabs the row above so i can subtract

WITH product_profit AS (
    -- sum profit per product
    SELECT
        dp.product_name,
        dp.category_name,
        SUM(fs.profit) AS total_profit,
        SUM(fs.sales)  AS total_sales
    FROM fact_sales fs
    JOIN dim_product dp ON dp.product_id = fs.product_id
    GROUP BY dp.product_name, dp.category_name
)
SELECT
    product_name,
    category_name,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(total_sales,  2) AS total_sales,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank,
    -- prev row profit minus mine = gap
    ROUND(
        LAG(total_profit) OVER (ORDER BY total_profit DESC) - total_profit,
        2
    ) AS gap_to_above
FROM product_profit
ORDER BY total_profit DESC
LIMIT 10;
