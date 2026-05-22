-- No zero or negative quantities
ALTER TABLE order_item
    ADD CONSTRAINT chk_quantity_positive
    CHECK (quantity > 0);

-- cannot go under zero
ALTER TABLE order_item
    ADD CONSTRAINT chk_sales_non_negative
    CHECK (sales >= 0);

-- cannot ship before it's ordered
ALTER TABLE orders
    ADD CONSTRAINT chk_ship_date_after_order
    CHECK (ship_date >= order_date);

-- cannot place an order in future
ALTER TABLE orders
    ADD CONSTRAINT chk_order_date_not_future
    CHECK (order_date <= CURRENT_DATE);

ALTER TABLE region
    ADD CONSTRAINT chk_region_name_valid
    CHECK (region_name IN ('South', 'East', 'West', 'Central'));

-- Segment need to match three customer types
ALTER TABLE segment
    ADD CONSTRAINT chk_segment_name_valid
    CHECK (segment_name IN ('Consumer', 'Corporate', 'Home Office'));

-- Ship mode need to be one of four options
ALTER TABLE ship_mode
    ADD CONSTRAINT chk_ship_mode_name_valid
    CHECK (ship_mode_name IN ('Standard Class', 'Second Class', 'First Class', 'Same Day'));

ALTER TABLE product
    ADD CONSTRAINT chk_product_id_format
    CHECK (product_id ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$');
