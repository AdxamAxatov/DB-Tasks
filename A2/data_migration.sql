-- Data migration from the raw Superstore CSV into the normalized schema.
-- Approach 1: load the file into a flat staging table first, then move it into the proper tables using INSERT ... SELECT.
-- CSV at C:\Temp\Superstore_Dataset.csv


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

COPY staging_superstore
FROM 'C:/Temp/Superstore_Dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- Move data into the real tables WHERE clauses skip junk rows

-- Lookups first.

INSERT INTO country (country_name)
SELECT DISTINCT country
FROM staging_superstore
WHERE country IS NOT NULL AND TRIM(country) <> ''
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO region (region_name)
SELECT DISTINCT region
FROM staging_superstore
WHERE region IN ('South', 'East', 'West', 'Central')
ON CONFLICT (region_name) DO NOTHING;

INSERT INTO category (category_name)
SELECT DISTINCT category
FROM staging_superstore
WHERE category IS NOT NULL AND TRIM(category) <> ''
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO segment (segment_name)
SELECT DISTINCT segment
FROM staging_superstore
WHERE segment IN ('Consumer', 'Corporate', 'Home Office')
ON CONFLICT (segment_name) DO NOTHING;

INSERT INTO ship_mode (ship_mode_name)
SELECT DISTINCT ship_mode
FROM staging_superstore
WHERE ship_mode IN ('Standard Class', 'Second Class', 'First Class', 'Same Day')
ON CONFLICT (ship_mode_name) DO NOTHING;

-- reference the lookups

INSERT INTO state (state_name, country_id, region_id)
SELECT DISTINCT s.state, c.country_id, r.region_id
FROM staging_superstore s
JOIN country c ON c.country_name = s.country
JOIN region  r ON r.region_name  = s.region
WHERE s.state IS NOT NULL AND TRIM(s.state) <> ''
ON CONFLICT (state_name, country_id) DO NOTHING;

INSERT INTO sub_category (sub_category_name, category_id)
SELECT DISTINCT s.sub_category, c.category_id
FROM staging_superstore s
JOIN category c ON c.category_name = s.category
WHERE s.sub_category IS NOT NULL AND TRIM(s.sub_category) <> ''
ON CONFLICT (sub_category_name, category_id) DO NOTHING;

-- Cities after their states

INSERT INTO city (city_name, state_id)
SELECT DISTINCT s.city, st.state_id
FROM staging_superstore s
JOIN state st ON st.state_name = s.state
WHERE s.city IS NOT NULL AND TRIM(s.city) <> ''
ON CONFLICT (city_name, state_id) DO NOTHING;


INSERT INTO product (product_id, product_name, sub_category_id)
SELECT DISTINCT ON (s.product_id)
       s.product_id,
       s.product_name,
       sc.sub_category_id
FROM staging_superstore s
JOIN category     cat ON cat.category_name     = s.category
JOIN sub_category sc  ON sc.sub_category_name  = s.sub_category
                       AND sc.category_id       = cat.category_id
WHERE s.product_id ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$'
  AND s.product_name IS NOT NULL AND TRIM(s.product_name) <> ''
ON CONFLICT (product_id) DO NOTHING;

-- Customers

INSERT INTO customer (customer_id, customer_name, segment_id)
SELECT DISTINCT ON (s.customer_id)
       s.customer_id,
       s.customer_name,
       seg.segment_id
FROM staging_superstore s
JOIN segment seg ON seg.segment_name = s.segment
WHERE s.customer_id   IS NOT NULL AND TRIM(s.customer_id)   <> ''
  AND s.customer_name IS NOT NULL AND TRIM(s.customer_name) <> ''
ON CONFLICT (customer_id) DO NOTHING;

-- Orders. One row per unique order_id. Dates parsed from
-- MM/DD/YYYY strings used in the CSV.

INSERT INTO orders (order_id, order_date, ship_date, customer_id, ship_mode_id, city_id)
SELECT DISTINCT ON (s.order_id)
       s.order_id,
       TO_DATE(s.order_date, 'MM/DD/YYYY'),
       TO_DATE(s.ship_date,  'MM/DD/YYYY'),
       s.customer_id,
       sm.ship_mode_id,
       ci.city_id
FROM staging_superstore s
JOIN ship_mode sm ON sm.ship_mode_name = s.ship_mode
JOIN state st     ON st.state_name     = s.state
JOIN city  ci     ON ci.city_name      = s.city AND ci.state_id = st.state_id
WHERE TO_DATE(s.order_date, 'MM/DD/YYYY') <= CURRENT_DATE
  AND TO_DATE(s.ship_date,  'MM/DD/YYYY') >= TO_DATE(s.order_date, 'MM/DD/YYYY')
  AND s.order_id    IS NOT NULL
  AND s.customer_id IS NOT NULL
ON CONFLICT (order_id) DO NOTHING;

-- Only loads where the parent order and product

INSERT INTO order_item (order_id, product_id, quantity, sales, profit)
SELECT s.order_id, s.product_id, s.quantity, s.sales, s.profit
FROM staging_superstore s
JOIN orders  o ON o.order_id   = s.order_id
JOIN product p ON p.product_id = s.product_id
WHERE s.quantity > 0
  AND s.sales   >= 0;


DROP TABLE IF EXISTS staging_superstore;
