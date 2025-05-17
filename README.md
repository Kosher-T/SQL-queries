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
