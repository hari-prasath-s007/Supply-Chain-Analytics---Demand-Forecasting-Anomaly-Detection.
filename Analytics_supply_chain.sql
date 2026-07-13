-------------------------Verify the Data------------------------------------
select * from supply_chain;
-------------------------Check the Number of Records-------------------------
SELECT COUNT(*) FROM SUPPLY_CHAIN;
------------------------Total Sales Quantity-------------------
SELECT SUM(SALES_QUANTITY) AS TOTAL_SALES FROM SUPPLY_CHAIN;
-------------------------Total Revenue--------------------------------
SELECT SUM(REVENUE) AS TOTAL_REVENUE FROM SUPPLY_CHAIN;
-------------------------Average Demand-------------------------------
SELECT AVG(SALES_QUANTITY) AS AVERAGE_DEMAND FROM SUPPLY_CHAIN;
-----------------------Region-wise Sales---------------------------
SELECT
    REGION,
    SUM(SALES_QUANTITY) AS TOTAL_SALES
FROM SUPPLY_CHAIN
GROUP BY REGION
ORDER BY TOTAL_SALES DESC;
-----------------------Region-wise Revenue---------------------
SELECT
    REGION,
    SUM(REVENUE) AS TOTAL_REVENUE
FROM SUPPLY_CHAIN
GROUP BY REGION
ORDER BY TOTAL_REVENUE DESC;
------------------------Product-wise Sales-------------------------
SELECT
    PRODUCT,
    SUM(SALES_QUANTITY) AS TOTAL_SALES
FROM SUPPLY_CHAIN
GROUP BY PRODUCT
ORDER BY TOTAL_SALES DESC;
------------------------Category-wise Revenue--------------------------
SELECT CATEGORY, SUM(REVENUE) AS TOTAL_REVENUE
FROM SUPPLY_CHAIN GROUP BY CATEGORY
ORDER BY TOTAL_REVENUE DESC;
------------------------Warehouse Inventory---------------------------
SELECT WAREHOUSE, SUM(INVENTORY) AS TOTAL_INVENTORY FROM SUPPLY_CHAIN
GROUP BY WAREHOUSE
ORDER BY TOTAL_INVENTORY DESC;
------------------------Supplier Performance-------------------------
SELECT
    SUPPLIER,
    SUM(REVENUE) AS TOTAL_REVENUE,
    AVG(LEAD_TIME_DAYS) AS AVG_LEAD_TIME
FROM SUPPLY_CHAIN
GROUP BY SUPPLIER
ORDER BY TOTAL_REVENUE DESC;
--------------------------Monthly Sales------------------------------
SELECT YEAR,MONTH, SUM(SALES_QUANTITY) AS TOTAL_SALES
FROM SUPPLY_CHAIN GROUP BY YEAR, MONTH ORDER BY YEAR, MONTH;
----------------------------Top 5 Products----------------------------
SELECT *
FROM (
    SELECT
        PRODUCT,
        SUM(REVENUE) AS TOTAL_REVENUE,
        DENSE_RANK() OVER (ORDER BY SUM(REVENUE) DESC) AS RNK
    FROM SUPPLY_CHAIN
    GROUP BY PRODUCT
)
WHERE RNK <= 5;
-------------------Low Inventory Products-----------------------
SELECT PRODUCT, INVENTORY FROM SUPPLY_CHAIN WHERE INVENTORY < 100;
------------------Average Lead Time by Supplier------------------
SELECT
    SUPPLIER,
    AVG(LEAD_TIME_DAYS) AS AVG_LEAD_TIME
FROM SUPPLY_CHAIN
GROUP BY SUPPLIER;
----------------------Revenue by Quarter--------------------------
SELECT
    QUARTER,
    SUM(REVENUE) AS TOTAL_REVENUE
FROM SUPPLY_CHAIN
GROUP BY QUARTER
ORDER BY QUARTER;
------------------------Highest Revenue Region-------------------------
SELECT region,
       total_revenue
FROM (
    SELECT region,
           SUM(revenue) AS total_revenue,
           DENSE_RANK() OVER (
               ORDER BY SUM(revenue) DESC
           ) AS rnk
    FROM supply_chain
    GROUP BY region
)
WHERE rnk = 1;
----------------------Lowest Inventory Warehouse---------------------
SELECT warehouse,
       total_inventory
FROM (
    SELECT warehouse,
           SUM(inventory) AS total_inventory,
           DENSE_RANK() OVER (
               ORDER BY SUM(inventory)
           ) AS rnk
    FROM supply_chain
    GROUP BY warehouse
)
WHERE rnk = 1;
--------------------Monthly Revenue Trend--------------------------
SELECT
    YEAR,
    MONTH,
    SUM(REVENUE) AS MONTHLY_REVENUE
FROM SUPPLY_CHAIN
GROUP BY YEAR, MONTH
ORDER BY YEAR, MONTH;
--------------------------VIEW VW_SALES_SUMMARY---------------------------
CREATE VIEW VW_SALES_SUMMARY AS
SELECT
    PRODUCT,
    CATEGORY,
    REGION,
    SUM(SALES_QUANTITY) AS TOTAL_SALES,
    SUM(REVENUE) AS TOTAL_REVENUE
FROM SUPPLY_CHAIN
GROUP BY
    PRODUCT,
    CATEGORY,
    REGION;
---------------------------Monthly Sales View------------------------------
CREATE VIEW VW_MONTHLY_SALES AS
SELECT
    YEAR,
    MONTH,
    SUM(SALES_QUANTITY) AS MONTHLY_SALES,
    SUM(REVENUE) AS MONTHLY_REVENUE
FROM SUPPLY_CHAIN
GROUP BY
    YEAR,
    MONTH;
--------------------------Region Performance View-------------------------
CREATE VIEW VW_REGION_PERFORMANCE AS
SELECT
    REGION,
    SUM(SALES_QUANTITY) AS TOTAL_SALES,
    SUM(REVENUE) AS TOTAL_REVENUE,
    AVG(INVENTORY) AS AVG_INVENTORY
FROM SUPPLY_CHAIN
GROUP BY REGION;
-------------------------Inventory Status View-------------------------
CREATE VIEW VW_INVENTORY_STATUS AS
SELECT
    PRODUCT,
    WAREHOUSE,
    INVENTORY,
    CASE
        WHEN INVENTORY < 100 THEN 'Low Stock'
        WHEN INVENTORY BETWEEN 100 AND 300 THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS STOCK_STATUS
FROM SUPPLY_CHAIN;
--------------------------Supplier Performance View---------------------
CREATE VIEW VW_SUPPLIER_PERFORMANCE AS
SELECT
    SUPPLIER,
    AVG(LEAD_TIME_DAYS) AS AVG_LEAD_TIME,
    SUM(REVENUE) AS TOTAL_REVENUE
FROM SUPPLY_CHAIN
GROUP BY SUPPLIER;
----------------------Demand Summary View-------------------------
CREATE VIEW VW_DEMAND_SUMMARY AS
SELECT
    PRODUCT,
    AVG(SALES_QUANTITY) AS AVG_DEMAND,
    MAX(SALES_QUANTITY) AS MAX_DEMAND,
    MIN(SALES_QUANTITY) AS MIN_DEMAND
FROM SUPPLY_CHAIN
GROUP BY PRODUCT;
----------------------Top Products View----------------------------
CREATE VIEW VW_TOP_PRODUCTS AS
SELECT
    PRODUCT,
    SUM(REVENUE) AS TOTAL_REVENUE,
    DENSE_RANK() OVER(ORDER BY SUM(REVENUE) DESC) AS PRODUCT_RANK
FROM SUPPLY_CHAIN
GROUP BY PRODUCT;
---------------------Warehouse Performance View:-------------------
CREATE VIEW VW_WAREHOUSE_PERFORMANCE AS
SELECT
    WAREHOUSE,
    SUM(SALES_QUANTITY) AS TOTAL_SALES,
    AVG(INVENTORY) AS AVG_INVENTORY
FROM SUPPLY_CHAIN
GROUP BY WAREHOUSE;
----------------------Product Category View-------------------------
CREATE VIEW VW_CATEGORY_SUMMARY AS
SELECT
    CATEGORY,
    SUM(REVENUE) AS TOTAL_REVENUE,
    SUM(SALES_QUANTITY) AS TOTAL_SALES
FROM SUPPLY_CHAIN
GROUP BY CATEGORY;
---------------------Executive Dashboard View-------------------------
CREATE VIEW VW_EXECUTIVE_DASHBOARD AS
SELECT
    REGION,
    CATEGORY,
    SUM(REVENUE) AS TOTAL_REVENUE,
    SUM(SALES_QUANTITY) AS TOTAL_SALES,
    AVG(INVENTORY) AS AVG_INVENTORY
FROM SUPPLY_CHAIN
GROUP BY
    REGION,
    CATEGORY;
--------------------Check All Views----------------
SELECT VIEW_NAME FROM USER_VIEWS;