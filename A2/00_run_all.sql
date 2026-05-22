-- Runs the whole A2 setup top to bottom: drops, schema, constraints,
-- staging load, populate, and a final row-count check.
--
-- Needs the CSV at C:\Temp\Superstore_Dataset.csv as proper UTF-8.
-- If the file is still in its original spot, run this in PowerShell once first:
--   $bytes = [IO.File]::ReadAllBytes("C:\Users\Recruiter\Documents\DB\Superstore_Dataset.csv")
--   $text  = [Text.Encoding]::GetEncoding("ISO-8859-1").GetString($bytes)
--   [IO.File]::WriteAllText("C:\Temp\Superstore_Dataset.csv", $text, (New-Object Text.UTF8Encoding $false))

-- Start clean.

DROP TABLE IF EXISTS order_item        CASCADE;
DROP TABLE IF EXISTS orders            CASCADE;
DROP TABLE IF EXISTS customer          CASCADE;
DROP TABLE IF EXISTS product           CASCADE;
DROP TABLE IF EXISTS city              CASCADE;
DROP TABLE IF EXISTS sub_category      CASCADE;
DROP TABLE IF EXISTS state             CASCADE;
DROP TABLE IF EXISTS ship_mode         CASCADE;
DROP TABLE IF EXISTS segment           CASCADE;
DROP TABLE IF EXISTS category          CASCADE;
DROP TABLE IF EXISTS region            CASCADE;
DROP TABLE IF EXISTS country           CASCADE;
DROP TABLE IF EXISTS staging_superstore;

-- Tables.

CREATE TABLE country (
    country_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE region (
    region_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE category (
    category_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE segment (
    segment_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    segment_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ship_mode (
    ship_mode_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ship_mode_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE state (
    state_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL,
    country_id INT NOT NULL REFERENCES country(country_id),
    region_id  INT NOT NULL REFERENCES region(region_id),
    UNIQUE (state_name, country_id)
);

CREATE TABLE sub_category (
    sub_category_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sub_category_name VARCHAR(50) NOT NULL,
    category_id       INT NOT NULL REFERENCES category(category_id),
    UNIQUE (sub_category_name, category_id)
);

CREATE TABLE city (
    city_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state_id  INT NOT NULL REFERENCES state(state_id),
    UNIQUE (city_name, state_id)
);

CREATE TABLE product (
    product_id      VARCHAR(20) PRIMARY KEY,
    product_name    VARCHAR(255) NOT NULL,
    sub_category_id INT NOT NULL REFERENCES sub_category(sub_category_id),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE customer (
    customer_id   VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment_id    INT NOT NULL REFERENCES segment(segment_id),
    is_active     BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
    order_id      VARCHAR(20) PRIMARY KEY,
    order_date    DATE NOT NULL,
    ship_date     DATE NOT NULL,
    customer_id   VARCHAR(10) NOT NULL REFERENCES customer(customer_id),
    ship_mode_id  INT NOT NULL REFERENCES ship_mode(ship_mode_id),
    city_id       INT NOT NULL REFERENCES city(city_id),
    days_to_ship  INT GENERATED ALWAYS AS (ship_date - order_date) STORED,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_item (
    order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id      VARCHAR(20) NOT NULL REFERENCES orders(order_id),
    product_id    VARCHAR(20) NOT NULL REFERENCES product(product_id),
    quantity      INT NOT NULL,
    sales         DECIMAL(10,2) NOT NULL,
    profit        DECIMAL(10,2) NOT NULL,
    unit_price    DECIMAL(10,2) GENERATED ALWAYS AS (sales / quantity) STORED
);

-- CHECK constraints. Range checks, allowed-value lists, date sanity, and a regex.

ALTER TABLE order_item
    ADD CONSTRAINT chk_quantity_positive    CHECK (quantity > 0);
ALTER TABLE order_item
    ADD CONSTRAINT chk_sales_non_negative   CHECK (sales >= 0);
ALTER TABLE orders
    ADD CONSTRAINT chk_ship_date_after_order CHECK (ship_date >= order_date);
ALTER TABLE orders
    ADD CONSTRAINT chk_order_date_not_future CHECK (order_date <= CURRENT_DATE);
ALTER TABLE region
    ADD CONSTRAINT chk_region_name_valid    CHECK (region_name IN ('South', 'East', 'West', 'Central'));
ALTER TABLE segment
    ADD CONSTRAINT chk_segment_name_valid   CHECK (segment_name IN ('Consumer', 'Corporate', 'Home Office'));
ALTER TABLE ship_mode
    ADD CONSTRAINT chk_ship_mode_name_valid CHECK (ship_mode_name IN ('Standard Class', 'Second Class', 'First Class', 'Same Day'));
ALTER TABLE product
    ADD CONSTRAINT chk_product_id_format    CHECK (product_id ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$');

-- Staging table for the raw CSV.

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

-- Pull data into the real tables. WHERE clauses skip junk rows
-- (nulls, bad enums, malformed IDs, negative values, etc).
-- ON CONFLICT DO NOTHING handles duplicates.

INSERT INTO country (country_name)
SELECT DISTINCT country FROM staging_superstore
WHERE country IS NOT NULL AND TRIM(country) <> ''
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO region (region_name)
SELECT DISTINCT region FROM staging_superstore
WHERE region IN ('South', 'East', 'West', 'Central')
ON CONFLICT (region_name) DO NOTHING;

INSERT INTO category (category_name)
SELECT DISTINCT category FROM staging_superstore
WHERE category IS NOT NULL AND TRIM(category) <> ''
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO segment (segment_name)
SELECT DISTINCT segment FROM staging_superstore
WHERE segment IN ('Consumer', 'Corporate', 'Home Office')
ON CONFLICT (segment_name) DO NOTHING;

INSERT INTO ship_mode (ship_mode_name)
SELECT DISTINCT ship_mode FROM staging_superstore
WHERE ship_mode IN ('Standard Class', 'Second Class', 'First Class', 'Same Day')
ON CONFLICT (ship_mode_name) DO NOTHING;

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

INSERT INTO city (city_name, state_id)
SELECT DISTINCT s.city, st.state_id
FROM staging_superstore s
JOIN state st ON st.state_name = s.state
WHERE s.city IS NOT NULL AND TRIM(s.city) <> ''
ON CONFLICT (city_name, state_id) DO NOTHING;

INSERT INTO product (product_id, product_name, sub_category_id)
SELECT DISTINCT ON (s.product_id)
       s.product_id, s.product_name, sc.sub_category_id
FROM staging_superstore s
JOIN category     cat ON cat.category_name    = s.category
JOIN sub_category sc  ON sc.sub_category_name = s.sub_category AND sc.category_id = cat.category_id
WHERE s.product_id ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$'
  AND s.product_name IS NOT NULL AND TRIM(s.product_name) <> ''
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO customer (customer_id, customer_name, segment_id)
SELECT DISTINCT ON (s.customer_id)
       s.customer_id, s.customer_name, seg.segment_id
FROM staging_superstore s
JOIN segment seg ON seg.segment_name = s.segment
WHERE s.customer_id   IS NOT NULL AND TRIM(s.customer_id)   <> ''
  AND s.customer_name IS NOT NULL AND TRIM(s.customer_name) <> ''
ON CONFLICT (customer_id) DO NOTHING;

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

INSERT INTO order_item (order_id, product_id, quantity, sales, profit)
SELECT s.order_id, s.product_id, s.quantity, s.sales, s.profit
FROM staging_superstore s
JOIN orders  o ON o.order_id   = s.order_id
JOIN product p ON p.product_id = s.product_id
WHERE s.quantity > 0 AND s.sales >= 0;

-- Row counts.

SELECT 'country'      AS table_name, COUNT(*) AS row_count FROM country
UNION ALL SELECT 'region',       COUNT(*) FROM region
UNION ALL SELECT 'category',     COUNT(*) FROM category
UNION ALL SELECT 'segment',      COUNT(*) FROM segment
UNION ALL SELECT 'ship_mode',    COUNT(*) FROM ship_mode
UNION ALL SELECT 'state',        COUNT(*) FROM state
UNION ALL SELECT 'sub_category', COUNT(*) FROM sub_category
UNION ALL SELECT 'city',         COUNT(*) FROM city
UNION ALL SELECT 'product',      COUNT(*) FROM product
UNION ALL SELECT 'customer',     COUNT(*) FROM customer
UNION ALL SELECT 'orders',       COUNT(*) FROM orders
UNION ALL SELECT 'order_item',   COUNT(*) FROM order_item
ORDER BY table_name;
