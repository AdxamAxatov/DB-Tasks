-- B2 star schema. run in superstore_dwh

-- drop old tables
DROP TABLE IF EXISTS fact_sales        CASCADE;
DROP TABLE IF EXISTS dim_customer      CASCADE;
DROP TABLE IF EXISTS dim_product       CASCADE;
DROP TABLE IF EXISTS dim_location      CASCADE;
DROP TABLE IF EXISTS dim_ship_mode     CASCADE;
DROP TABLE IF EXISTS dim_date          CASCADE;


-- dims

CREATE TABLE dim_customer (
    customer_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_code  VARCHAR(10)  NOT NULL UNIQUE,
    customer_name  VARCHAR(100) NOT NULL,
    segment_name   VARCHAR(50)  NOT NULL
);

CREATE TABLE dim_product (
    product_id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_code       VARCHAR(20)  NOT NULL UNIQUE,
    product_name       VARCHAR(255) NOT NULL,
    sub_category_name  VARCHAR(50)  NOT NULL,
    category_name      VARCHAR(50)  NOT NULL
);

CREATE TABLE dim_location (
    location_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_name     VARCHAR(100) NOT NULL,
    state_name    VARCHAR(50)  NOT NULL,
    region_name   VARCHAR(50)  NOT NULL,
    country_name  VARCHAR(100) NOT NULL,
    UNIQUE (city_name, state_name, region_name, country_name)
);

CREATE TABLE dim_ship_mode (
    ship_mode_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ship_mode_name  VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dim_date (
    date_id      INT          PRIMARY KEY,
    full_date    DATE         NOT NULL UNIQUE,
    year         INT          NOT NULL,
    quarter      INT          NOT NULL,
    month        INT          NOT NULL,
    month_name   VARCHAR(10)  NOT NULL,
    day          INT          NOT NULL,
    day_of_week  INT          NOT NULL,
    day_name     VARCHAR(10)  NOT NULL,
    is_weekend   BOOLEAN      NOT NULL
);


-- fact table

CREATE TABLE fact_sales (
    sale_id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id       VARCHAR(20)   NOT NULL,
    order_date_id  INT           NOT NULL REFERENCES dim_date(date_id),
    ship_date_id   INT           NOT NULL REFERENCES dim_date(date_id),
    customer_id    INT           NOT NULL REFERENCES dim_customer(customer_id),
    product_id     INT           NOT NULL REFERENCES dim_product(product_id),
    location_id    INT           NOT NULL REFERENCES dim_location(location_id),
    ship_mode_id   INT           NOT NULL REFERENCES dim_ship_mode(ship_mode_id),
    quantity       INT           NOT NULL,
    sales          DECIMAL(10,2) NOT NULL,
    profit         DECIMAL(10,2) NOT NULL,
    unit_price     DECIMAL(10,2) GENERATED ALWAYS AS (sales / quantity) STORED,
    days_to_ship   INT           NOT NULL
);


-- checks from A1
ALTER TABLE fact_sales
    ADD CONSTRAINT chk_quantity_positive         CHECK (quantity > 0);
ALTER TABLE fact_sales
    ADD CONSTRAINT chk_sales_non_negative        CHECK (sales >= 0);
ALTER TABLE fact_sales
    ADD CONSTRAINT chk_days_to_ship_non_negative CHECK (days_to_ship >= 0);
ALTER TABLE dim_customer
    ADD CONSTRAINT chk_segment_name_valid        CHECK (segment_name IN ('Consumer', 'Corporate', 'Home Office'));
ALTER TABLE dim_location
    ADD CONSTRAINT chk_region_name_valid         CHECK (region_name IN ('South', 'East', 'West', 'Central'));
ALTER TABLE dim_ship_mode
    ADD CONSTRAINT chk_ship_mode_name_valid      CHECK (ship_mode_name IN ('Standard Class', 'Second Class', 'First Class', 'Same Day'));
ALTER TABLE dim_product
    ADD CONSTRAINT chk_product_code_format       CHECK (product_code ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$');
