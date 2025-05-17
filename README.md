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

## Bean Data Analysis SQL Project

This project contains a SQL script for creating a table named `beans`, populating it with sample data, and then running a complex query to analyze this data. The primary goal of the query is to identify bean brands that exhibit consistent density under specific conditions related to their diameter and shade.

### Table of Contents

- [Database Schema](#database-schema)
- [Sample Data](#sample-data)
- [Query Explanation](#query-explanation)
- [How to Use](#how-to-use)
- [Contributing](#contributing)

### Database Schema

The script first defines a table named `beans` with the following columns:

* `brand`: VARCHAR(50) - The brand name of the bean.
* `density`: DECIMAL(4, 3) - The density of the bean. This is a decimal number with a precision of 4 digits in total, with 3 digits after the decimal point.
* `diameter_wide`: DECIMAL(4, 3) - The wider diameter measurement of the bean. This is a decimal number with a precision of 4 digits in total, with 3 digits after the decimal point.
* `shade`: VARCHAR(10) - The shade description of the bean (e.g., 'light', 'dark', 'semi-dark').

### Sample Data

The script then inserts 16 rows of sample data into the `beans` table, representing different beans with their respective brands, densities, diameters, and shades.

Brands included in the sample data:
* Shllips
* Stevenspus
* Hadelia
* Gorazora

### Query Explanation

The core of this project is the `SELECT` statement, which performs an analysis to find bean brands with a low standard deviation in density under certain conditions. Let's break down the query:

1.  **Innermost Subquery (Calculating Averages):**
    * `(SELECT AVG(density) FROM beans)`: Calculates the average density of all beans in the table.
    * `(SELECT AVG(diameter_wide) FROM beans)`: Calculates the average wider diameter of all beans in the table.

2.  **Filtering Conditions (Inner `SELECT` statement's `WHERE` clause):**
    The query first filters the beans based on the following criteria:
    * `diameter_wide > (SELECT AVG(diameter_wide) FROM beans)`: It only considers beans whose wider diameter is greater than the average wider diameter of all beans.
    * And either of these conditions must be met:
        * `shade = 'light' AND (density/diameter_wide) > 0.1`: If the bean shade is 'light', its density to wider diameter ratio must be greater than 0.1.
        * `shade = 'dark'`: Or, the bean shade is 'dark' (no additional ratio condition for dark beans).

3.  **Calculating Standard Deviation (`STD`):**
    * `ROUND(((SUM((density - (SELECT AVG(density) FROM beans)) * (density - (SELECT AVG(density) FROM beans)))) / COUNT(density)), 3) AS STD`
    * This part of the query calculates a measure of dispersion for the `density` of the filtered beans for each `brand`.
    * It calculates the sum of the squared differences between each bean's density and the overall average density of *all* beans (as calculated in the innermost subquery).
    * This sum is then divided by the count of beans *within that filtered group for the brand*.
    * The result is rounded to 3 decimal places and aliased as `STD`.
    * **Note:** This is a custom calculation for dispersion. While it's labeled `STD` (Standard Deviation), the formula used here is more akin to a population variance calculation if `(SELECT AVG(density) FROM beans)` were the mean of the *current group* rather than the *overall population*. However, it's using the overall average density as the central point for measuring deviation. If the intention is a true standard deviation for the *filtered group*, the `AVG(density)` within the `STD` calculation should ideally be from the filtered beans for that brand, or a standard deviation aggregate function (like `STDDEV_POP` or `STDDEV_SAMP`, depending on the SQL dialect) should be used on the `density` of the filtered beans. As written, it measures how much the density of the *filtered beans for a brand* deviates from the *overall average density of all beans*.

4.  **Grouping:**
    * `GROUP BY brand`: The results are then grouped by `brand`, so the `STD` is calculated for each distinct bean brand that has beans meeting the filtering criteria.

5.  **Filtering Groups (`HAVING` clause):**
    * `HAVING STD < 0.1`: Only brands where the calculated `STD` (as defined above) is less than 0.1 are included in the final result. This selects brands with relatively low variation in density among their qualifying beans, according to the custom `STD` metric.

6.  **Ordering:**
    * `ORDER BY STD ASC`: The final results are ordered by the calculated `STD` in ascending order, meaning brands with the lowest `STD` (most consistent density according to the metric) will appear first.

**In summary, the query aims to identify bean brands that have beans which:**
* Are wider than average.
* AND are either:
    * 'light' in shade with a density/diameter_wide ratio > 0.1.
    * 'dark' in shade.
* AND exhibit a low variation (custom `STD` < 0.1) in their density when compared to the overall average density of all beans.

### How to Use

1.  **Database Setup:** Ensure you have a SQL database system (e.g., PostgreSQL, MySQL, SQLite, SQL Server) running.
2.  **Connect to Database:** Connect to your database using a SQL client or interface.
3.  **Run the Script:** Execute the provided SQL code. This will:
    * Create the `beans` table.
    * Insert the sample data into the table.
    * Run the analysis query and display the results.

The output will be a table showing the `brand` and its calculated `STD` for brands that meet all the specified criteria.

### Modifying the Query

The `STD` calculation in the query is a custom one. Depending on the specific SQL dialect you are using (e.g., PostgreSQL, MySQL, SQL Server, Oracle), there might be built-in functions for standard deviation (like `STDDEV_SAMP()` for sample standard deviation or `STDDEV_POP()` for population standard deviation) that you might prefer to use for a more standard statistical measure.

If you intend to calculate the standard deviation of density *for each group of filtered beans* around *that group's own average density*, the `STD` calculation would need to be adjusted. For example, in PostgreSQL or MySQL, you might replace the custom `STD` calculation with `ROUND(STDDEV_POP(density), 3) AS STD` and remove the reliance on the overall `AVG(density)` from the outer select for this specific calculation (though it's still used in the filtering).

### Contributing

Contributions to this project are welcome (though I can't imagine what you'd want to change)! If you have suggestions for improving the query, adding more complex analyses, or refining the dataset, please feel free to:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/YourFeature`).
3.  Commit your changes (`git commit -m 'Add some feature'`).
4.  Push to the branch (`git push origin feature/YourFeature`).
5.  Open a Pull Request.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact

For any questions, reach out via itorousa@gmail.com
