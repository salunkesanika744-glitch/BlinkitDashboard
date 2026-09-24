-- Blinkit Dashboard SQL Queries
-- Purpose: Data cleaning, KPI calculation, product analysis, outlet analysis,
-- and dashboard-ready queries.
-- Assumed table name: blinkit_data
--
-- Expected columns:
-- Item_Identifier, Item_Weight, Item_Fat_Content, Item_Visibility,
-- Item_Type, Item_MRP, Outlet_Identifier, Outlet_Establishment_Year,
-- Outlet_Size, Outlet_Location_Type, Outlet_Type, Item_Outlet_Sales,
-- Rating

-- =========================================================
-- 1. View complete dataset
-- =========================================================
SELECT *
FROM blinkit_data;


-- =========================================================
-- 2. Check total number of records
-- =========================================================
SELECT COUNT(*) AS total_records
FROM blinkit_data;


-- =========================================================
-- 3. Check NULL values in important columns
-- =========================================================
SELECT
    SUM(CASE WHEN Item_Identifier IS NULL THEN 1 ELSE 0 END) AS null_item_identifier,
    SUM(CASE WHEN Item_Weight IS NULL THEN 1 ELSE 0 END) AS null_item_weight,
    SUM(CASE WHEN Item_Fat_Content IS NULL THEN 1 ELSE 0 END) AS null_fat_content,
    SUM(CASE WHEN Item_Type IS NULL THEN 1 ELSE 0 END) AS null_item_type,
    SUM(CASE WHEN Item_MRP IS NULL THEN 1 ELSE 0 END) AS null_mrp,
    SUM(CASE WHEN Outlet_Identifier IS NULL THEN 1 ELSE 0 END) AS null_outlet,
    SUM(CASE WHEN Item_Outlet_Sales IS NULL THEN 1 ELSE 0 END) AS null_sales
FROM blinkit_data;


-- =========================================================
-- 4. Clean Item Fat Content values
-- =========================================================
SELECT
    Item_Fat_Content,
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat', 'Low Fat') THEN 'Low Fat'
        WHEN Item_Fat_Content IN ('reg', 'Regular') THEN 'Regular'
        ELSE Item_Fat_Content
    END AS cleaned_fat_content
FROM blinkit_data;


-- =========================================================
-- 5. Total Sales
-- =========================================================
SELECT
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data;


-- =========================================================
-- 6. Average Sales
-- =========================================================
SELECT
    ROUND(AVG(Item_Outlet_Sales), 2) AS average_sales
FROM blinkit_data;


-- =========================================================
-- 7. Total Number of Items
-- =========================================================
SELECT
    COUNT(DISTINCT Item_Identifier) AS total_items
FROM blinkit_data;


-- =========================================================
-- 8. Average Customer/Product Rating
-- =========================================================
SELECT
    ROUND(AVG(Rating), 2) AS average_rating
FROM blinkit_data;


-- =========================================================
-- 9. Sales by Item Type
-- =========================================================
SELECT
    Item_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY total_sales DESC;


-- =========================================================
-- 10. Sales by Fat Content
-- =========================================================
SELECT
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat', 'Low Fat') THEN 'Low Fat'
        WHEN Item_Fat_Content IN ('reg', 'Regular') THEN 'Regular'
        ELSE Item_Fat_Content
    END AS Fat_Content,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat', 'Low Fat') THEN 'Low Fat'
        WHEN Item_Fat_Content IN ('reg', 'Regular') THEN 'Regular'
        ELSE Item_Fat_Content
    END
ORDER BY total_sales DESC;


-- =========================================================
-- 11. Sales by Outlet
-- =========================================================
SELECT
    Outlet_Identifier,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Outlet_Identifier
ORDER BY total_sales DESC;


-- =========================================================
-- 12. Sales by Outlet Type
-- =========================================================
SELECT
    Outlet_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY total_sales DESC;


-- =========================================================
-- 13. Sales by Outlet Size
-- =========================================================
SELECT
    Outlet_Size,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY total_sales DESC;


-- =========================================================
-- 14. Sales by Outlet Location Type
-- =========================================================
SELECT
    Outlet_Location_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;


-- =========================================================
-- 15. Sales by Establishment Year
-- =========================================================
SELECT
    Outlet_Establishment_Year,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;


-- =========================================================
-- 16. Average MRP by Item Type
-- =========================================================
SELECT
    Item_Type,
    ROUND(AVG(Item_MRP), 2) AS average_mrp
FROM blinkit_data
GROUP BY Item_Type
ORDER BY average_mrp DESC;


-- =========================================================
-- 17. Top 10 Products by Sales
-- =========================================================
SELECT
    Item_Identifier,
    Item_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Item_Identifier, Item_Type
ORDER BY total_sales DESC
LIMIT 10;


-- =========================================================
-- 18. Top 10 Item Types by Sales
-- =========================================================
SELECT
    Item_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY total_sales DESC
LIMIT 10;


-- =========================================================
-- 19. Sales and Rating by Item Type
-- =========================================================
SELECT
    Item_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
    ROUND(AVG(Rating), 2) AS average_rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY total_sales DESC;


-- =========================================================
-- 20. Outlet Performance Summary
-- =========================================================
SELECT
    Outlet_Identifier,
    Outlet_Size,
    Outlet_Location_Type,
    Outlet_Type,
    COUNT(DISTINCT Item_Identifier) AS number_of_items,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
    ROUND(AVG(Rating), 2) AS average_rating
FROM blinkit_data
GROUP BY
    Outlet_Identifier,
    Outlet_Size,
    Outlet_Location_Type,
    Outlet_Type
ORDER BY total_sales DESC;


-- =========================================================
-- 21. Sales contribution percentage by Outlet Type
-- =========================================================
SELECT
    Outlet_Type,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
    ROUND(
        100.0 * SUM(Item_Outlet_Sales) /
        (SELECT SUM(Item_Outlet_Sales) FROM blinkit_data),
        2
    ) AS sales_percentage
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY total_sales DESC;


-- =========================================================
-- 22. Items with high visibility
-- =========================================================
SELECT
    Item_Identifier,
    Item_Type,
    Item_Visibility,
    Item_Outlet_Sales
FROM blinkit_data
WHERE Item_Visibility > 0.20
ORDER BY Item_Visibility DESC;


-- =========================================================
-- 23. High-selling products
-- =========================================================
SELECT
    Item_Identifier,
    Item_Type,
    ROUND(Item_Outlet_Sales, 2) AS sales
FROM blinkit_data
WHERE Item_Outlet_Sales >
      (SELECT AVG(Item_Outlet_Sales) FROM blinkit_data)
ORDER BY sales DESC;


-- =========================================================
-- 24. Dashboard KPI summary in one query
-- =========================================================
SELECT
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales), 2) AS average_sales,
    COUNT(DISTINCT Item_Identifier) AS total_items,
    COUNT(DISTINCT Outlet_Identifier) AS total_outlets,
    ROUND(AVG(Rating), 2) AS average_rating
FROM blinkit_data;


-- =========================================================
-- 25. Dashboard-ready category summary
-- =========================================================
SELECT
    Item_Type,
    COUNT(DISTINCT Item_Identifier) AS item_count,
    ROUND(AVG(Item_MRP), 2) AS avg_mrp,
    ROUND(AVG(Item_Visibility), 4) AS avg_visibility,
    ROUND(AVG(Rating), 2) AS avg_rating,
    ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY total_sales DESC;
