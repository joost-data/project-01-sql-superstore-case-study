-- Schema setup for Superstore
-- ============================

-- Clean slate
DROP TABLE IF EXISTS import_superstore;
DROP TABLE IF EXISTS staging_superstore;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;

-- ------------------------------------------
-- 1) Import table: columns c1..c21 (all TEXT)
-- ------------------------------------------
CREATE TABLE import_superstore (
  c1  TEXT, c2  TEXT, c3  TEXT, c4  TEXT, c5  TEXT,
  c6  TEXT, c7  TEXT, c8  TEXT, c9  TEXT, c10 TEXT,
  c11 TEXT, c12 TEXT, c13 TEXT, c14 TEXT, c15 TEXT,
  c16 TEXT, c17 TEXT, c18 TEXT, c19 TEXT, c20 TEXT,
  c21 TEXT
);

-- ------------------------------------------------
-- 2) Staging table with meaningful column names
-- ------------------------------------------------
CREATE TABLE staging_superstore (
  row_id INTEGER,
  order_id TEXT,
  order_date TEXT,
  ship_date TEXT,
  ship_mode TEXT,
  customer_id TEXT,
  customer_name TEXT,
  segment TEXT,
  country TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  region TEXT,
  product_id TEXT,
  category TEXT,
  sub_category TEXT,
  product_name TEXT,
  sales REAL,
  quantity INTEGER,
  discount REAL,
  profit REAL
);

-- ------------------------------------------
-- 3) Dimension tables
-- ------------------------------------------
CREATE TABLE customers (
  customer_id TEXT PRIMARY KEY,
  customer_name TEXT,
  segment TEXT
);

CREATE TABLE products (
  product_id TEXT PRIMARY KEY,
  category TEXT,
  sub_category TEXT,
  product_name TEXT
);

-- ------------------------------------------
-- 4) Orders table (one row per order)
-- ------------------------------------------
CREATE TABLE orders (
  order_id TEXT PRIMARY KEY,
  order_date TEXT,
  ship_date TEXT,
  ship_mode TEXT,
  country TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  region TEXT,
  customer_id TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ------------------------------------------
-- 5) Fact table: order line items
-- ------------------------------------------
CREATE TABLE order_items (
  row_id INTEGER PRIMARY KEY,
  order_id TEXT,
  product_id TEXT,
  sales REAL,
  quantity INTEGER,
  discount REAL,
  profit REAL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

