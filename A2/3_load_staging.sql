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

SELECT COUNT(*) AS rows_loaded FROM staging_superstore;
