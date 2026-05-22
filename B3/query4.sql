-- q4 - running total per category
-- basically a running sum, one per category.
-- UNBOUNDED PRECEDING = add up everything from the start til now

WITH monthly_cat AS (
    -- sum sales per (category, month)
    SELECT
        dp.category_name,
        dd.year,
        dd.month,
        TO_CHAR(MAKE_DATE(dd.year, dd.month, 1), 'YYYY-MM') AS month_label,
        SUM(fs.sales) AS monthly_sales
    FROM fact_sales fs
    JOIN dim_product dp ON dp.product_id = fs.product_id
    JOIN dim_date    dd ON dd.date_id    = fs.order_date_id
    GROUP BY dp.category_name, dd.year, dd.month
)
SELECT
    category_name,
    month_label,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(
        SUM(monthly_sales) OVER (
            PARTITION BY category_name
            ORDER BY year, month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_sales
FROM monthly_cat
ORDER BY category_name, year, month;
