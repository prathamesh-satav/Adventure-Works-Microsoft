-- 1. Delete the table if it already exists so we can start fresh
DROP TABLE IF EXISTS dim_products;

-- 2. Create the new clean table
CREATE TABLE dim_products AS
SELECT
    ProductID,
    Name,
    ProductNumber,
    -- Decode Flags: Turn -1/0 into real words
    CASE WHEN MakeFlag = -1 THEN 'Manufactured' ELSE 'Purchased' END AS Make_Buy_Indicator,
    CASE WHEN FinishedGoodsFlag = -1 THEN 'Sellable' ELSE 'Not Sellable' END AS Sales_Status,
    -- Handle Null Colors
    COALESCE(Color, 'N/A') AS Color,
    SafetyStockLevel,
    
    -- Clean Money: Remove '$' and ',' so Power BI can read it as numbers
    CAST(REPLACE(REPLACE(StandardCost, '$', ''), ',', '') AS NUMERIC(10,2)) AS Standard_Cost,
    CAST(REPLACE(REPLACE(ListPrice, '$', ''), ',', '') AS NUMERIC(10,2)) AS List_Price,
    
    -- Calculate Profit Margin (Price - Cost)
    (CAST(REPLACE(REPLACE(ListPrice, '$', ''), ',', '') AS NUMERIC(10,2)) - 
     CAST(REPLACE(REPLACE(StandardCost, '$', ''), ',', '') AS NUMERIC(10,2))) AS Profit_Margin,
    
    DaysToManufacture,
    
    -- Decode Categories for the dashboard
    CASE 
        WHEN ProductLine = 'R' THEN 'Road'
        WHEN ProductLine = 'M' THEN 'Mountain'
        WHEN ProductLine = 'T' THEN 'Touring'
        WHEN ProductLine = 'S' THEN 'Standard'
        ELSE 'Components'
    END AS Product_Category
FROM raw_products;

SELECT * FROM dim_products LIMIT 10;