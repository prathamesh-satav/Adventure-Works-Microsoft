# AdventureWorks Manufacturing & Profitability Analysis

## Project Overview
This project is an end-to-end data analytics study of the AdventureWorks manufacturing database. The goal was to transform raw production data into actionable business intelligence to assist the manufacturing management team in optimizing production schedules, improving profit margins, and balancing inventory levels.

The project simulates a real-world analytics workflow: extracting raw CSV data, designing a database schema in PostgreSQL, performing ETL (Extract, Transform, Load) processes using SQL to clean and model the data, and finally building an interactive dashboard in Power BI.

## Business Problem & Objectives
The Manufacturing Manager at AdventureWorks identified potential inefficiencies in the production line and concerns regarding product profitability. The specific business questions addressed in this analysis include:

1.  **Profitability Analysis:** Which product lines (Road, Mountain, Touring) yield the highest profit margins?
2.  **Production Bottlenecks:** Which specific items require the longest manufacturing time, and does this correlate with higher costs?
3.  **Inventory Optimization:** Are we overstocking items that have low profit margins or low sales velocity?
4.  **Make vs. Buy Analysis:** What is the ratio of manufactured components versus purchased components in our inventory?

## Technology Stack
* **Database Engine:** PostgreSQL 16
* **Database Management:** pgAdmin 4
* **Data Transformation (ETL):** SQL (Structured Query Language)
* **Visualization:** Microsoft Power BI Desktop
* **Source Data:** Kaggle (AdventureWorks Sample Database) / CSV Export

## Project Structure
The repository is organized as follows:

* **sql_scripts/**: Contains the SQL source code used to create tables, import data, and perform the ETL process.
* **visuals/**: Screenshots of the final Power BI dashboard and key insights.
* **datasets/**: (Optional) Sample of the raw CSV data used for the analysis.
* **README.md**: Project documentation.

## Methodology

### 1. Database Setup & Staging
To simulate a robust data environment, a local PostgreSQL database was initialized. A "Staging Table" approach was used to handle data ingestion issues common with raw CSV files (such as currency symbols in numeric fields and inconsistent date formats).

* **Step 1:** Created a `raw_products` table using flexible data types (VARCHAR) to ensure 100% data capture during import.
* **Step 2:** Imported the raw `AdventureWorks2019Export.csv` file using the pgAdmin Import tool.

### 2. ETL & Data Cleaning (SQL)
The core engineering work was performed using SQL to transform the raw string data into a clean, analytical dataset (`dim_products`). Key transformation steps included:

* **Data Type Conversion:** Used `CAST` and `REPLACE` functions to strip currency symbols ('$') and commas from cost/price columns, converting them to NUMERIC data types for calculation.
* **Logic Decoding:** Used `CASE` statements to convert binary flags (e.g., MakeFlag: 0/-1) into readable business terms ('Purchased'/'Manufactured').
* **Handling NULLs:** Used `COALESCE` to replace NULL values in the Color column with 'N/A' to ensure data integrity in visualizations.
* **Metric Calculation:** Created a calculated column `Profit_Margin` directly in the database layer (List Price - Standard Cost).

### 3. Data Visualization (Power BI)
The final dashboard was built in Microsoft Power BI Desktop, connected directly to the `adventureworks` PostgreSQL database. The reporting layer focuses on three strategic pillars:

#### A. Key Performance Indicators (KPIs)
* **Average Profit Margin:** Calculated dynamically to track profitability across different product categories.
* **Manufacturing Lead Time:** Tracks the `DaysToManufacture` metric to identify efficiency gaps.
* **Inventory Valuation:** Monitors `SafetyStockLevel` vs. `ListPrice` to identify high-value capital tied up in stock.

#### B. Dashboard Visuals & Configuration
The dashboard consists of three primary visualizations designed to answer the Manager's core questions:

1.  **Profitability by Category (Bar Chart)**
    * **Goal:** Compare profit margins between Road, Mountain, and Touring lines.
    * **X-Axis:** `Product_Category`
    * **Y-Axis:** Average of `Profit_Margin`
    * **Filter:** `Sales_Status` = 'Sellable' (Excluding internal components).

2.  **Production Bottleneck Analysis (Table)**
    * **Goal:** Identify specific products that slow down the manufacturing line.
    * **Fields:** `Name`, `DaysToManufacture`, `Standard_Cost`.
    * **Sorting:** Descending by `DaysToManufacture` (identifying items taking 4+ days).

3.  **Cost vs. Price Correlation (Scatter Plot)**
    * **Goal:** Detect pricing anomalies and low-margin products.
    * **X-Axis:** `Standard_Cost`
    * **Y-Axis:** `List_Price`
    * **Legend:** `Product_Category`
    * **Insight:** outliers below the trendline indicate under-priced products.

#### C. Natural Language Q&A
The dashboard utilizes Power BI's Q&A engine to allow non-technical users to ask questions in plain English. The data model was optimized with synonyms to support queries such as:
* *"Top 5 name by list price"*
* *"Average profit margin by product category"*
* *"Scatter plot of standard cost vs list price"*

## Key Insights & Findings
Based on the analysis of the `dim_products` dataset, the following conclusions were drawn:

1.  **Profitability:** The "Mountain" product line generally maintains a higher average profit margin compared to the "Road" line, suggesting a potential area to focus marketing efforts.
2.  **Bottlenecks:** Specific high-end frames and bottom brackets have a manufacturing lead time of **4 days**, significantly higher than the average of 1 day. These items represent potential bottlenecks in the supply chain.
3.  **Inventory Risks:** Several low-margin components have disproportionately high `SafetyStockLevel` counts (>800 units), indicating capital is tied up in slow-moving or low-value inventory.
4.  **Sales Status:** A significant portion of the "Components" category is marked as "Not Sellable," meaning they are exclusively for internal use. These were filtered out of the revenue analysis to prevent skewed results.

## How to Replicate This Project

### Prerequisites
* **PostgreSQL 16** & **pgAdmin 4** (for database management).
* **Microsoft Power BI Desktop** (for visualization).

### Step-by-Step Execution
1.  **Database Initialization:**
    * Create a new database `adventureworks` in pgAdmin.
    * Execute the `CREATE TABLE` script found in `sql_scripts/data_cleaning.sql`.

2.  **Data Import:**
    * Import `AdventureWorks2019Export.csv` into the `raw_products` table using the pgAdmin Import Tool.
    * *Settings:* Format: CSV, Header: Yes, Delimiter: Comma.

3.  **ETL Process:**
    * Run the transformation script in `sql_scripts/data_cleaning.sql` to generate the `dim_products` table.
    * Verify data with `SELECT * FROM dim_products LIMIT 10;`.

4.  **Dashboard Build:**
    * Connect Power BI to the `localhost` PostgreSQL server.
    * Load the `dim_products` table.
    * Recreate the visuals listed in the "Dashboard Visuals" section above.

## Future Improvements
* **Sales Data Integration:** Connect to the SalesOrderDetail table to weigh profitability by actual sales volume, not just unit margin.
* **Dynamic Restocking:** Create a Python script to automatically flag items that drop below `ReorderPoint`.
