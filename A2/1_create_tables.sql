DROP TABLE IF EXISTS order_item   CASCADE;
DROP TABLE IF EXISTS orders       CASCADE;
DROP TABLE IF EXISTS customer     CASCADE;
DROP TABLE IF EXISTS product      CASCADE;
DROP TABLE IF EXISTS city         CASCADE;
DROP TABLE IF EXISTS sub_category CASCADE;
DROP TABLE IF EXISTS state        CASCADE;
DROP TABLE IF EXISTS ship_mode    CASCADE;
DROP TABLE IF EXISTS segment      CASCADE;
DROP TABLE IF EXISTS category     CASCADE;
DROP TABLE IF EXISTS region       CASCADE;
DROP TABLE IF EXISTS country      CASCADE;

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

-- These reference the lookups

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

-- Orders and the bridge table for line items

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
