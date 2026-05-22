-- q2 - sales up or down each month
-- LAG gives me last month so i can calc % change

WITH monthly AS (
    -- sales per month
    SELECT
        dd.year,
        dd.month,
        TO_CHAR(MAKE_DATE(dd.year, dd.month, 1), 'YYYY-MM') AS month_label,
        SUM(fs.sales) AS monthly_sales
    FROM fact_sales fs
    JOIN dim_date dd ON dd.date_id = fs.order_date_id
    GROUP BY dd.year, dd.month
)
SELECT
    month_label,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(LAG(monthly_sales) OVER (ORDER BY year, month), 2) AS prev_month_sales,
    -- % change. NULLIF so it doesnt blow up on /0
    ROUND(
        (monthly_sales - LAG(monthly_sales) OVER (ORDER BY year, month))
            / NULLIF(LAG(monthly_sales) OVER (ORDER BY year, month), 0) * 100,
        2
    ) AS mom_growth_pct
FROM monthly
ORDER BY year, month;
