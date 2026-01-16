-- Load Superstore CSV into normalized tables
-- ==========================================

-- 1) Clear staging + dimensions + facts (in case rerun)
DELETE FROM staging_superstore;
DELETE FROM customers;
DELETE FROM products;
DELETE FROM orders;
DELETE FROM order_items;

-- 2) Move from import_superstore (c1..c21) into staging_superstore
-- IMPORTANT: This mapping assumes the CSV column order is:
-- 1 Row ID
-- 2 Order ID
-- 3 Order Date
-- 4 Ship Date
-- 5 Ship Mode
-- 6 Customer ID
-- 7 Customer Name
-- 8 Segment
-- 9 Country
-- 10 City
-- 11 State
-- 12 Postal Code
-- 13 Region
-- 14 Product ID
-- 15 Category
-- 16 Sub-Category
-- 17 Product Name
-- 18 Sales
-- 19 Quantity
-- 20 Discount
-- 21 Profit

INSERT INTO staging_superstore (
  row_id, order_id, order_date, ship_date, ship_mode,
  customer_id, customer_name, segment,
  country, city, state, postal_code, region,
  product_id, category, sub_category, product_name,
  sales, quantity, discount, profit
)
SELECT
  CAST(c1 AS INTEGER),
  c2,
  c3,
  c4,
  c5,
  c6,
  c7,
  c8,
  c9,
  c10,
  c11,
  c12,
  c13,
  c14,
  c15,
  c16,
  c17,
  CAST(c18 AS REAL),
  CAST(c19 AS INTEGER),
  CAST(c20 AS REAL),
  CAST(c21 AS REAL)
FROM import_superstore
-- Skip header row if it got imported as data
WHERE c1 != 'Row ID';

-- 3) Populate customers
INSERT OR IGNORE INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM staging_superstore
WHERE customer_id IS NOT NULL;

-- 4) Populate products
INSERT OR IGNORE INTO products (product_id, category, sub_category, product_name)
SELECT DISTINCT product_id, category, sub_category, product_name
FROM staging_superstore
WHERE product_id IS NOT NULL;

-- 5) Populate orders (unique order_id)
INSERT OR IGNORE INTO orders (
  order_id, order_date, ship_date, ship_mode,
  country, city, state, postal_code, region, customer_id
)
SELECT DISTINCT
  order_id, order_date, ship_date, ship_mode,
  country, city, state, postal_code, region, customer_id
FROM staging_superstore
WHERE order_id IS NOT NULL;

-- 6) Populate order_items
INSERT OR IGNORE INTO order_items (
  row_id, order_id, product_id, sales, quantity, discount, profit
)
SELECT
  row_id, order_id, product_id, sales, quantity, discount, profit
FROM staging_superstore
WHERE row_id IS NOT NULL;

