-- update_customer_field
--
-- Updates a single column on a single customer row.
-- Takes three arguments:
--   p_customer_id  the customer's natural ID (e.g. 'CG-12520')
--   p_column_name  which column to change ('customer_name', 'segment_id', or 'is_active')
--   p_new_value    the new value, passed as text and cast by Postgres at execution time
--
-- Why text for the value: customer columns have different types (VARCHAR, INT, BOOLEAN),
-- so we accept text and let Postgres coerce it via the dynamic UPDATE. If someone
-- passes 'maybe' for is_active, Postgres will reject the cast and raise its own error.
--
-- Validation:
--   * column name is checked against an allowed list so callers can't update
--     customer_id (the PK) or anything outside the whitelist
--   * customer_id existence is checked before the UPDATE so we can raise a
--     clear error instead of silently doing nothing
--
-- Example calls:
--   SELECT update_customer_field('CG-12520', 'customer_name', 'Claire G.');
--   SELECT update_customer_field('CG-12520', 'segment_id',    '2');
--   SELECT update_customer_field('CG-12520', 'is_active',     'false');

CREATE OR REPLACE FUNCTION update_customer_field(
    p_customer_id VARCHAR(10),
    p_column_name VARCHAR(50),
    p_new_value   TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    -- Whitelist of columns that callers are allowed to change.
    -- customer_id is intentionally NOT in here because it's the primary key.
    v_allowed_columns TEXT[] := ARRAY['customer_name', 'segment_id', 'is_active'];

    -- Used to confirm the row actually exists before we update.
    v_exists BOOLEAN;
BEGIN
    -- Step 1: make sure the column name is one we actually allow.
    IF NOT (p_column_name = ANY(v_allowed_columns)) THEN
        RAISE EXCEPTION 'Column "%" is not updatable. Allowed columns: %',
                        p_column_name,
                        array_to_string(v_allowed_columns, ', ');
    END IF;

    -- Step 2: make sure the customer exists. If we skipped this, an UPDATE
    -- against a missing PK would just affect 0 rows silently.
    SELECT EXISTS (
        SELECT 1 FROM customer WHERE customer_id = p_customer_id
    ) INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Customer % does not exist', p_customer_id;
    END IF;

    -- Step 3: run the actual update via dynamic SQL.
    -- format() with %I quotes the column name safely (so it's treated as an identifier,
    -- not interpolated text) and %L quotes the values safely (escapes apostrophes etc.),
    -- which protects against SQL injection through the parameters.
    EXECUTE format(
        'UPDATE customer SET %I = %L WHERE customer_id = %L',
        p_column_name, p_new_value, p_customer_id
    );

    -- Friendly confirmation message so the caller knows it worked.
    RAISE NOTICE 'Updated customer %: % set to %',
                 p_customer_id, p_column_name, p_new_value;
END;
$$;
