# SQL-queries

I have begun learning SQL from [Coddy](coddy.tech), and this is where I'll post my progress over time. This repo will contain my micro projects in my quest for proficiency in SQL.

## Earthquake Data Analysis SQL Script

### Overview

This repository contains a SQL script designed to create, populate, and query a database of earthquake events. The script defines a table to store earthquake data, inserts sample records, and then performs a specific analysis to calculate an average "magnitude" indicator for locations that meet certain criteria.

### SQL Script Details

The script performs the following operations:

1.  **Table Creation (`CREATE TABLE`)**:
    It defines a table named `earthquakes` with the following columns:
    * `location` (TEXT, NOT NULL): The name or identifier of the location where the earthquake was recorded.
    * `amplitude` (REAL, NOT NULL): The measured amplitude of the earthquake wave. The units are not specified but should be consistent.
    * `period` (REAL, NOT NULL): The measured period of the earthquake wave. The units are not specified but should be consistent (e.g., seconds).

2.  **Data Insertion (`INSERT INTO`)**:
    Sample data for several earthquake events is inserted into the `earthquakes` table, including their location, amplitude, and period.

3.  **Data Analysis Query (`SELECT ...`)**:
    The script includes a query to analyze the earthquake data. This query calculates a custom average "magnitude" indicator per location based on the following logic:

    * **Formula for Magnitude Indicator**: For each earthquake record, a value is calculated as `((amplitude/period) * (amplitude/period))/period`. This can be thought of as `(amplitude/period)^2 / period`.
        * The term `amplitude/period` could be analogous to a form of wave velocity.
        * Squaring this term (`(amplitude/period)^2`) emphasizes higher energy events.
        * Dividing by `period` again further weights events that have higher energy relative to their duration or those with shorter periods.
    * **Averaging**: The script then calculates the average of these individual values for each location, rounded to two decimal places (`ROUND(AVG(...), 2)`), aliased as `avg_magnitude`.
    * **Filtering Conditions**:
        * `WHERE amplitude >= 1 AND period >= 1`: Only records with an amplitude of 1 or greater AND a period of 1 or greater are included in the calculation. This filters out very low amplitude or very low period events before averaging.
    * **Grouping**: Results are grouped by `location` to provide a per-location average.
    * **Final Output Filter**:
        * `HAVING avg_magnitude > 1`: Only locations where the calculated `avg_magnitude` is greater than 1 are included in the final result set.

### Purpose of the Query

The primary query aims to identify locations that have experienced earthquakes with a significant average "magnitude" indicator, based on the custom formula. This formula prioritizes events where the ratio of amplitude to period is high, and the period itself is also taken into account.

### How to Use

1.  Ensure you have a SQL environment (e.g., SQLite, PostgreSQL, MySQL, SQL Server).
2.  Execute the `CREATE TABLE` statement to set up the `earthquakes` table structure.
3.  Execute the `INSERT INTO` statements to populate the table with the sample data.
4.  Run the `SELECT` query to perform the analysis and retrieve the locations meeting the specified criteria.

### Disclaimer

The `avg_magnitude` calculated in this script is based on a custom formula specific to this analysis. It should not be confused with standard seismological magnitude scales like the Richter scale or Moment Magnitude scale, which have different, well-established formulas and physical bases.

## Shop Data Analysis with Price Adjustment SQL Script

### Overview

This repository contains a SQL script for creating, populating, and querying a database of shop product listings. The script defines a table for items including their price, quantity, category, and listing date. It then performs an analytical query to calculate a "total gain" per category, applying a specific price adjustment for items listed within a defined period.

### SQL Script Details

The script performs the following operations:

1.  **Table Creation (`CREATE TABLE`)**:
    It defines a table named `shop` with the following columns:
    * `price` (INT): The original price of the item.
    * `quantity` (INT): The quantity of the item listed.
    * `category` (VARCHAR(255)): The category the item belongs to.
    * `list_date` (TIMESTAMP): The date and time when the item was listed.

2.  **Data Insertion (`INSERT INTO`)**:
    Sample data for fifteen product listings is inserted into the `shop` table, including their price, quantity, category, and listing date (all in early 2015).

3.  **Data Analysis Query (`SELECT ...`)**:
    The script includes a query to analyze the shop data, calculating a `total_gain` for each product category. This calculation involves a subquery that first adjusts item prices:

    * **Subquery (Price Adjustment Logic)**:
        * **Date Filtering**: The subquery focuses on items where `list_date` is BETWEEN '2015-01-01' AND '2015-03-18'. This includes items listed from the start of January 1, 2015, up to and including March 18, 2015, at 00:00:00Z. (Note: depending on the SQL database, `BETWEEN` with dates/timestamps might include the entire end day or only up to the midnight mark. As written, it typically includes the exact timestamp '2015-03-18T00:00:00Z' if present, but not later times on that day).
        * **Average Price Calculation**: Within this date range, it calculates the average price (`AVG(price)`) of *all* items listed in the *same period* (`'2015-01-01'` AND `'2015-03-18'`).
        * **Price Adjustment**: For each item selected within the date range, its original `price` is increased by this calculated average price. The new effective price is `price + <average_price_in_period>`.
        * The subquery outputs this adjusted price, along with the original `quantity` and `category` for items within the specified date range.

    * **Outer Query (Total Gain Calculation)**:
        * It takes the results from the subquery (i.e., items from the specified period with their adjusted prices).
        * It calculates `total_gain` for each `category` by summing the product of the `adjusted_price` and `quantity` (`SUM(price * quantity)` where `price` is the adjusted price from the subquery).
        * The results are grouped by `category`.
        * Finally, the categories are ordered by `total_gain` in descending order, showing the categories with the highest calculated gain first.

### Purpose of the Query

The primary query aims to identify which product categories generated the highest "total gain" within a specific timeframe ('2015-01-01' to '2015-03-18'), after applying a unique price uplift to each product. This uplift is uniform for all products within the period and is based on the average price of products sold during that same period. This could be used for a what-if scenario or a specific type of performance analysis where a baseline market-driven price increase is hypothesized.

### How to Use

1.  Ensure you have a SQL environment that supports TIMESTAMP data types and standard SQL functions (e.g., SQLite, PostgreSQL, MySQL, SQL Server).
2.  Execute the `CREATE TABLE` statement to set up the `shop` table structure.
3.  Execute the `INSERT INTO` statements to populate the table with the sample data.
4.  Run the `SELECT` query to perform the analysis. The date literals in the query (`'2015-01-01'`, `'2015-03-18'`) are in 'YYYY-MM-DD' format and should be compatible with most SQL systems when comparing against a TIMESTAMP column.

### Note on Calculation

The "total_gain" and the price adjustment mechanism are specific to this script's analytical goals. They represent a custom calculation rather than a standard financial or sales metric. The interpretation of the results should be made in the context of this specific price adjustment logic.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact

For any questions, reach out via itorousa@gmail.com
