-- B2 data migration. csv -> staging -> star schema.
-- csv must be at C:/Temp/Superstore_Dataset.csv

-- staging table (same columns as csv)
DROP TABLE IF EXISTS staging_superstore;

CREATE TABLE staging_superstore (
    order_id      VARCHAR(50),
    order_date    VARCHAR(20),
    ship_date     VARCHAR(20),
    ship_mode     VARCHAR(50),
    customer_id   VARCHAR(20),
    customer_name VARCHAR(100),
    segment       VARCHAR(50),
    country       VARCHAR(100),
    city          VARCHAR(100),
    state         VARCHAR(50),
    region        VARCHAR(50),
    product_id    VARCHAR(50),
    category      VARCHAR(50),
    sub_category  VARCHAR(50),
    product_name  VARCHAR(500),
    sales         NUMERIC(12,4),
    quantity      INT,
    profit        NUMERIC(12,4)
);

-- load csv
COPY staging_superstore
FROM 'C:/Temp/Superstore_Dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');


-- date dim: one row per day
INSERT INTO dim_date (date_id, full_date, year, quarter, month, month_name, day, day_of_week, day_name, is_weekend)
SELECT
    (EXTRACT(YEAR FROM d)::INT * 10000
     + EXTRACT(MONTH FROM d)::INT * 100
     + EXTRACT(DAY FROM d)::INT)  AS date_id,
    d::DATE                       AS full_date,
    EXTRACT(YEAR    FROM d)::INT,
    EXTRACT(QUARTER FROM d)::INT,
    EXTRACT(MONTH   FROM d)::INT,
    TRIM(TO_CHAR(d, 'Month')),
    EXTRACT(DAY     FROM d)::INT,
    EXTRACT(DOW     FROM d)::INT,
    TRIM(TO_CHAR(d, 'Day')),
    EXTRACT(DOW FROM d) IN (0, 6)
FROM generate_series(
    (SELECT MIN(TO_DATE(order_date, 'MM/DD/YYYY')) FROM staging_superstore),
    (SELECT MAX(TO_DATE(ship_date,  'MM/DD/YYYY')) FROM staging_superstore),
    '1 day'::interval
) AS d;


-- customer dim
INSERT INTO dim_customer (customer_code, customer_name, segment_name)
SELECT DISTINCT ON (s.customer_id)
       s.customer_id, s.customer_name, s.segment
FROM staging_superstore s
WHERE s.customer_id   IS NOT NULL AND TRIM(s.customer_id)   <> ''
  AND s.customer_name IS NOT NULL AND TRIM(s.customer_name) <> ''
  AND s.segment       IN ('Consumer', 'Corporate', 'Home Office');


-- product dim
INSERT INTO dim_product (product_code, product_name, sub_category_name, category_name)
SELECT DISTINCT ON (s.product_id)
       s.product_id, s.product_name, s.sub_category, s.category
FROM staging_superstore s
WHERE s.product_id ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$'
  AND s.product_name IS NOT NULL AND TRIM(s.product_name) <> ''
  AND s.category     IS NOT NULL
  AND s.sub_category IS NOT NULL;


-- location dim
INSERT INTO dim_location (city_name, state_name, region_name, country_name)
SELECT DISTINCT s.city, s.state, s.region, s.country
FROM staging_superstore s
WHERE s.city    IS NOT NULL AND TRIM(s.city)    <> ''
  AND s.state   IS NOT NULL AND TRIM(s.state)   <> ''
  AND s.country IS NOT NULL AND TRIM(s.country) <> ''
  AND s.region  IN ('South', 'East', 'West', 'Central');


-- ship mode dim
INSERT INTO dim_ship_mode (ship_mode_name)
SELECT DISTINCT ship_mode
FROM staging_superstore
WHERE ship_mode IN ('Standard Class', 'Second Class', 'First Class', 'Same Day');


-- fact table
INSERT INTO fact_sales (
    order_id, order_date_id, ship_date_id, customer_id, product_id,
    location_id, ship_mode_id, quantity, sales, profit, days_to_ship
)
SELECT
    s.order_id,
    (EXTRACT(YEAR  FROM TO_DATE(s.order_date, 'MM/DD/YYYY'))::INT * 10000
     + EXTRACT(MONTH FROM TO_DATE(s.order_date, 'MM/DD/YYYY'))::INT * 100
     + EXTRACT(DAY   FROM TO_DATE(s.order_date, 'MM/DD/YYYY'))::INT),
    (EXTRACT(YEAR  FROM TO_DATE(s.ship_date,  'MM/DD/YYYY'))::INT * 10000
     + EXTRACT(MONTH FROM TO_DATE(s.ship_date,  'MM/DD/YYYY'))::INT * 100
     + EXTRACT(DAY   FROM TO_DATE(s.ship_date,  'MM/DD/YYYY'))::INT),
    dc.customer_id,
    dp.product_id,
    dl.location_id,
    dsm.ship_mode_id,
    s.quantity,
    s.sales,
    s.profit,
    (TO_DATE(s.ship_date, 'MM/DD/YYYY') - TO_DATE(s.order_date, 'MM/DD/YYYY'))
FROM staging_superstore s
JOIN dim_customer  dc  ON dc.customer_code = s.customer_id
JOIN dim_product   dp  ON dp.product_code  = s.product_id
JOIN dim_location  dl  ON dl.city_name    = s.city
                       AND dl.state_name   = s.state
                       AND dl.region_name  = s.region
                       AND dl.country_name = s.country
JOIN dim_ship_mode dsm ON dsm.ship_mode_name = s.ship_mode
WHERE s.quantity > 0
  AND s.sales   >= 0
  AND TO_DATE(s.order_date, 'MM/DD/YYYY') <= CURRENT_DATE
  AND TO_DATE(s.ship_date,  'MM/DD/YYYY') >= TO_DATE(s.order_date, 'MM/DD/YYYY');


-- drop staging
DROP TABLE IF EXISTS staging_superstore;


-- row counts
SELECT 'dim_customer'   AS table_name, COUNT(*) AS row_count FROM dim_customer
UNION ALL SELECT 'dim_product',   COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_location',  COUNT(*) FROM dim_location
UNION ALL SELECT 'dim_ship_mode', COUNT(*) FROM dim_ship_mode
UNION ALL SELECT 'dim_date',      COUNT(*) FROM dim_date
UNION ALL SELECT 'fact_sales',    COUNT(*) FROM fact_sales
ORDER BY table_name;
