# Superstore Database — Business Template Draft

This file maps 1:1 to the sections in `Business_Template.docx`. Open them side by side and copy each section into the matching place in the template. Tweak any wording that doesn't sound like you.

---

## 1. Business Description

### 1.1 Business background

Superstore is a US-based retailer that sells everyday office and home goods across three categories: Furniture, Office Supplies, and Technology. The customer base is split into three segments — regular Consumers shopping for personal use, Corporate clients buying for their offices, and Home Office workers stocking up on supplies. Orders ship across the country, organized into four sales regions (South, East, West, Central), and customers can choose from four shipping speeds ranging from Same Day delivery to Standard Class. Each order can contain multiple products, and the business tracks quantity sold, sales revenue, and profit on every line.

### 1.2 Problems / Current Situation

At the moment, the entire sales history lives in a single flat CSV file with roughly 5,900 rows and 18 columns. That setup creates real, day-to-day problems:

- **Massive redundancy.** Every order line repeats the customer's name, their city, state, region, country, the product's category and sub-category, the ship mode — over and over. The string "Furniture" alone appears in thousands of rows. "United States" appears in every single row.
- **Update headaches.** If a customer's name changes, you'd have to find and edit every order they've ever placed. Miss one row and your data is inconsistent.
- **No data integrity.** Nothing stops typos. Someone could enter "Standerd Class" instead of "Standard Class" and the file would treat it as a new ship mode. Same goes for category names, segment names, anything textual.
- **Hard to extend.** Adding a new ship mode, a new product category, or a new customer segment means hand-editing many rows. There's no proper place to define them once.
- **Reporting is awkward.** Aggregating sales by region, segment, or category requires carefully filtering text columns. As the order count grows, these queries get slower and more error-prone.

The flat file works as a snapshot, but it's not a foundation you can build a business on.

### 1.3 Benefits of implementing a database / Project Vision

Moving the data into a properly normalized relational database fixes the problems above and unlocks a few new capabilities:

- **Each fact is stored exactly once.** Update a customer's name in one row of the `Customer` table and every order they've ever placed reflects the change automatically.
- **Foreign keys enforce real connections.** Every order belongs to a real customer, every product belongs to a real sub-category, every line item is tied to a real order. No orphan rows.
- **Constraints keep bad data out.** `NOT NULL` ensures required fields are filled. `CHECK` constraints prevent negative quantities and ship dates that fall before the order date. `UNIQUE` keeps lookup values clean.
- **Lookup tables make extension trivial.** Adding a new ship mode is a single-row insert. No find-and-replace across thousands of rows.
- **The schema scales.** The flat file works at 5,900 orders. The relational design will hold up at 5 million.
- **Reporting becomes natural.** Aggregating sales by region, segment, sub-category, or any combination is a clean SQL query against properly indexed tables.

The end goal is a clean, queryable foundation for sales reporting, customer analytics, and inventory tracking — without the duplication and fragility of a flat file.

---

## 2. Model description

### 2.1 Definitions & Acronyms

| Term | Meaning |
|---|---|
| PK | Primary Key — uniquely identifies each row in a table |
| FK | Foreign Key — references the PK of another table |
| 1:M | One-to-many relationship |
| M:M | Many-to-many relationship (resolved with a junction table) |
| NN / NOT NULL | Column must always have a value |
| UNIQUE | No two rows can share the same value (or combination of values) |
| CHECK | A custom rule enforced at the column level (e.g., `quantity > 0`) |
| 3NF | Third Normal Form — every non-key column depends on the PK, the whole PK, and nothing but the PK |
| Junction table | A bridge table that resolves an M:M relationship into two 1:M relationships |
| DECIMAL(p, s) | An exact-precision number with `p` total digits and `s` digits after the decimal point |
| Surrogate key | An invented identifier (usually an auto-incrementing integer) used as a PK in place of a natural key |

### 2.2 Logical Scheme

Embed the file `logical_model.png` here.

Caption: *Logical model of the Superstore retail database. Twelve tables in third normal form. The many-to-many relationship between `Orders` and `Product` is resolved through the `OrderItem` junction table.*

### 2.3 Objects

What follows is one entry per table, with description, columns, key info, relationship notes, and a small example.

---

#### Country

**Description.** Stores the list of countries where Superstore operates. The current dataset contains only "United States," but the table is built to support international expansion without any schema changes.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| country_id | Unique identifier for each country | INT | PK |
| country_name | Country name | VARCHAR(100), NOT NULL, UNIQUE | — |

**Relationships.** One country has many states (1:M with `State`).

**Example.**

| country_id | country_name |
|---|---|
| 1 | United States |

---

#### Region

**Description.** Sales-region groupings Superstore uses for territory management and reporting. The dataset has four US regions.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| region_id | Unique identifier for each region | INT | PK |
| region_name | Region name | VARCHAR(50), NOT NULL, UNIQUE | — |

**Relationships.** One region groups many states (1:M with `State`).

**Example.**

| region_id | region_name |
|---|---|
| 1 | South |
| 2 | West |
| 3 | East |
| 4 | Central |

---

#### State

**Description.** US states (and, in future, equivalents in other countries). Each state belongs to one country and one sales region.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| state_id | Unique identifier for each state | INT | PK |
| state_name | State name | VARCHAR(50), NOT NULL | — |
| country_id | Country this state belongs to | INT, NOT NULL | FK → Country(country_id) |
| region_id | Sales region this state belongs to | INT, NOT NULL | FK → Region(region_id) |

Plus a composite uniqueness rule: `UNIQUE (state_name, country_id)` — the same state name is allowed in different countries.

**Relationships.** Belongs to one country, belongs to one region, has many cities (1:M with `City`).

**Example.**

| state_id | state_name | country_id | region_id |
|---|---|---|---|
| 1 | Kentucky | 1 | 1 |
| 2 | California | 1 | 2 |

---

#### City

**Description.** The city an order ships to. Each city belongs to exactly one state.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| city_id | Unique identifier for each city | INT | PK |
| city_name | City name | VARCHAR(100), NOT NULL | — |
| state_id | State this city is in | INT, NOT NULL | FK → State(state_id) |

Plus `UNIQUE (city_name, state_id)` — the same city name (e.g., Springfield) can exist in different states.

**Relationships.** Belongs to one state, receives many orders (1:M with `Orders`).

**Example.**

| city_id | city_name | state_id |
|---|---|---|
| 1 | Henderson | 1 |
| 2 | Los Angeles | 2 |

---

#### Category

**Description.** Top-level product categories: Furniture, Office Supplies, Technology.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| category_id | Unique identifier for each category | INT | PK |
| category_name | Category name | VARCHAR(50), NOT NULL, UNIQUE | — |

**Relationships.** One category contains many sub-categories (1:M with `SubCategory`).

**Example.**

| category_id | category_name |
|---|---|
| 1 | Furniture |
| 2 | Office Supplies |
| 3 | Technology |

---

#### SubCategory

**Description.** Mid-level product groupings within a category. Examples: Bookcases, Chairs, and Tables fall under the Furniture category.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| sub_category_id | Unique identifier for each sub-category | INT | PK |
| sub_category_name | Sub-category name | VARCHAR(50), NOT NULL | — |
| category_id | Parent category | INT, NOT NULL | FK → Category(category_id) |

Plus `UNIQUE (sub_category_name, category_id)`.

**Relationships.** Belongs to one category. Contains many products (1:M with `Product`).

**Example.**

| sub_category_id | sub_category_name | category_id |
|---|---|---|
| 1 | Bookcases | 1 |
| 2 | Chairs | 1 |
| 3 | Labels | 2 |

---

#### Product

**Description.** Individual products that Superstore sells. The `product_id` is the natural product code from the source data (e.g., `FUR-BO-10001798`).

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| product_id | Product code from source data | VARCHAR(20) | PK |
| product_name | Full product name | VARCHAR(255), NOT NULL | — |
| sub_category_id | Sub-category this product belongs to | INT, NOT NULL | FK → SubCategory(sub_category_id) |

**Relationships.** Belongs to one sub-category. Appears on many order lines — this is one half of the M:M with `Orders`, resolved through `OrderItem`.

**Example.**

| product_id | product_name | sub_category_id |
|---|---|---|
| FUR-BO-10001798 | Bush Somerset Collection Bookcase | 1 |
| FUR-CH-10000454 | Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back | 2 |

---

#### Segment

**Description.** Customer segment classification: Consumer, Corporate, or Home Office.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| segment_id | Unique identifier for each segment | INT | PK |
| segment_name | Segment name | VARCHAR(50), NOT NULL, UNIQUE | — |

**Relationships.** One segment groups many customers (1:M with `Customer`).

**Example.**

| segment_id | segment_name |
|---|---|
| 1 | Consumer |
| 2 | Corporate |
| 3 | Home Office |

---

#### Customer

**Description.** The people and businesses that place orders. The `customer_id` is the natural code from the source data (e.g., `CG-12520`).

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| customer_id | Customer code from source data | VARCHAR(10) | PK |
| customer_name | Customer's name | VARCHAR(100), NOT NULL | — |
| segment_id | Segment this customer belongs to | INT, NOT NULL | FK → Segment(segment_id) |

**Relationships.** Belongs to one segment. Places many orders (1:M with `Orders`).

**Example.**

| customer_id | customer_name | segment_id |
|---|---|---|
| CG-12520 | Claire Gute | 1 |
| DV-13045 | Darrin Van Huff | 2 |

---

#### ShipMode

**Description.** Shipping options Superstore offers: Standard Class, Second Class, First Class, Same Day.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| ship_mode_id | Unique identifier for each ship mode | INT | PK |
| ship_mode_name | Name of the shipping option | VARCHAR(50), NOT NULL, UNIQUE | — |

**Relationships.** One ship mode is used on many orders (1:M with `Orders`).

**Example.**

| ship_mode_id | ship_mode_name |
|---|---|
| 1 | Standard Class |
| 2 | Second Class |
| 3 | First Class |
| 4 | Same Day |

---

#### Orders

**Description.** Each row is one order placed by a customer. Stores order date, ship date, who placed it, what shipping speed was used, and where it shipped to. The actual line items (which products, what quantities, prices) live in `OrderItem`.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| order_id | Order code from source data | VARCHAR(20) | PK |
| order_date | Date the order was placed | DATE, NOT NULL | — |
| ship_date | Date the order shipped | DATE, NOT NULL | — |
| customer_id | Customer who placed the order | VARCHAR(10), NOT NULL | FK → Customer(customer_id) |
| ship_mode_id | Shipping option used | INT, NOT NULL | FK → ShipMode(ship_mode_id) |
| city_id | Destination city | INT, NOT NULL | FK → City(city_id) |

Plus `CHECK (ship_date >= order_date)` — a sanity rule preventing impossible dates.

**Relationships.** Belongs to one customer, one ship mode, one city. Contains many line items (1:M with `OrderItem`).

**Example.**

| order_id | order_date | ship_date | customer_id | ship_mode_id | city_id |
|---|---|---|---|---|---|
| CA-2019-152156 | 2019-11-08 | 2019-11-11 | CG-12520 | 2 | 1 |

---

#### OrderItem

**Description.** The junction table that resolves the M:M between `Orders` and `Product`. Each row represents one product line on a specific order, including how many units were sold, the sales amount, and the profit on that line. The line-specific attributes (quantity, sales, profit) live here because they describe the *act of selling* a product on an order — they don't belong to the order alone or the product alone.

| Field Name | Description | Data Type | Key |
|---|---|---|---|
| order_item_id | Unique identifier for each line | INT | PK |
| order_id | Order this line belongs to | VARCHAR(20), NOT NULL | FK → Orders(order_id) |
| product_id | Product on this line | VARCHAR(20), NOT NULL | FK → Product(product_id) |
| quantity | Number of units sold | INT, NOT NULL, CHECK (quantity > 0) | — |
| sales | Sales amount for this line | DECIMAL(10, 2), NOT NULL | — |
| profit | Profit on this line (can be negative for losses) | DECIMAL(10, 2), NOT NULL | — |

**Relationships.** Belongs to one order, references one product. Many `OrderItem` rows per `Order` and many `OrderItem` rows per `Product` together represent the many-to-many relationship between orders and products.

**Example.**

| order_item_id | order_id | product_id | quantity | sales | profit |
|---|---|---|---|---|---|
| 1 | CA-2019-152156 | FUR-BO-10001798 | 2 | 261.96 | 41.91 |
| 2 | CA-2019-152156 | FUR-CH-10000454 | 3 | 731.94 | 219.58 |

---

## Summary of the modeling process (optional closing note)

The starting point was a single flat CSV with 18 columns and ~5,900 rows. The modeling process was:

1. **Identify the core entities** by looking at the nouns in the columns: Order, Customer, Product, Location.
2. **Split hierarchies into separate tables** — Country / Region / State / City for location, and Category / SubCategory / Product for products. Putting hierarchy levels in one table would create transitive dependencies and break 3NF.
3. **Pull repeating short values into lookup tables** — `Segment` and `ShipMode`.
4. **Resolve the many-to-many** between Orders and Products with the `OrderItem` junction table. The line-level attributes (quantity, sales, profit) live on `OrderItem` because they describe the link itself, not either parent.
5. **Pick keys** — kept the natural codes from the dataset for `order_id`, `product_id`, `customer_id`; used surrogate integer IDs for everything else.
6. **Pick data types** — `DATE` for dates, `DECIMAL(10, 2)` for money, `VARCHAR(n)` for text, `INT` for whole-number IDs and counts.
7. **Add constraints** — `NOT NULL` on required columns, `UNIQUE` (single or composite) on lookup names and natural pairs, `CHECK` on quantity and ship date, `FOREIGN KEY` on every reference.

The final design is twelve tables, all in 3NF, with one many-to-many relationship resolved through a junction.
