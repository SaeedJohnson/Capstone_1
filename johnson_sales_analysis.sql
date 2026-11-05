/*
===========================================================
Project: Capstone 1 - EmporiUm Texas (South Region) Analysis
Author: Saeed Johnson
DATE: 11/05/2026
DATABASE: sample_sales
Territory: Texas (TX) South Region - In store
===========================================================
*/
USE sample_sales;
SHOW TABLES;
DESCRIBE management;
SELECT * FROM management
LIMIT 15;
SELECT state, region
FROM management;
-- Above is how I discovered the region for Texas. The region is South (Florida, South Carolina, Texas).
-- ===========================================================================
-- Sales Manager of the TX sales department wants to know:
/* Q1 Total Revenue overall for sales in TX. Start and End Date that tells the period
 of data coverage.
*/
SELECT SUM(ss.sale_amount)      AS total_revenue,
       COUNT(*)                 AS num_transactions,
       MIN(ss.transaction_date) AS start_date,
       MAX(ss.transaction_date) AS end_date
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
WHERE sl.state = 'Texas';
-- ANSWER: TOTAL REVENUE - '3,417,850.01' (24,212 transactions) START DATE: 2022-01-01 END DATE: 2025-12-31
DESCRIBE store_sales;
/* Describing store_sales showed the date column is Transaction_Date, so I added the MIN and MAX
within the syntax for Q1. Online_Sales is not included because online sales belong to a separate territory. */

-- Q2. Revenue breakdown by year and month for sales in Texas
SELECT YEAR(ss.transaction_date)  AS sales_year,
       MONTH(ss.transaction_date) AS sales_month,
       SUM(ss.sale_amount)        AS total_revenue
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
WHERE sl.state = 'Texas'
GROUP BY sales_year, sales_month
ORDER BY sales_year, sales_month;
-- ANSWER: saved as csv file (48 rows, one for each month)
# Yearly totals for the summary
SELECT YEAR(ss.transaction_date) AS sales_year,
       SUM(ss.sale_amount)       AS total_revenue
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
WHERE sl.state = 'Texas'
GROUP BY sales_year
ORDER BY sales_year;
-- ANSWER: 2022 - 579,864.31 | 2023 - 807,866.79 | 2024 - 809,371.87 | 2025 - 1,220,747.04
-- 2023 grew 39.3%, 2024 was flat (+0.2%), and 2025 grew 50.8%. October 2025 was the biggest month at 168,955.72.

-- Q3. Comparison of Total Revenue for TX and the South Region
SELECT m.state,
       m.region,
       SUM(ss.sale_amount) AS revenue
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
JOIN management m ON sl.state = m.state
WHERE m.region = 'South'
GROUP BY m.state, m.region
ORDER BY revenue DESC;
-- Confirmed which states are in the region with TX:
-- Florida 3,930,187.55 | Texas 3,417,850.01 | South Carolina 648,812.56
/* ANSWER:
Texas Revenue: 3,417,850.01
South Revenue: 7,996,850.12
Texas Share: 42.74 %
*/
SELECT texas_revenue,
       south_revenue,
       ROUND(texas_revenue / south_revenue * 100, 2) AS texas_share_prcnt
FROM (
    SELECT
     (SELECT SUM(ss.sale_amount)
      FROM store_sales ss
      JOIN store_locations sl ON ss.store_id = sl.storeid
      WHERE sl.state = 'Texas')                                AS texas_revenue,
     (SELECT SUM(ss.sale_amount)
      FROM store_sales ss
      JOIN store_locations sl ON ss.store_id = sl.storeid
      JOIN management m ON sl.state = m.state
      WHERE m.region = 'South')                                AS south_revenue
     ) AS totals;
-- Subquery calculates the percentage of revenue TX produces for the South Region.

-- Q4. Number of transactions per month. Average transaction amount by product category for TX Sales.
SELECT YEAR(ss.transaction_date)   AS sales_year,
       MONTH(ss.transaction_date)  AS sales_month,
       i.category                  AS category,
       COUNT(*)                    AS num_transactions,
       AVG(ss.sale_amount)         AS avg_transaction
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
JOIN products p ON ss.prod_num = p.prodnum
JOIN inventory_categories i ON p.categoryid = i.categoryid
WHERE sl.state = 'Texas'
GROUP BY sales_month, sales_year, category
ORDER BY sales_year, sales_month, category;
-- ANSWER: saved as csv file (288 rows: 48 months x 6 categories)
# Collecting category performance over the full period for analysis
SELECT i.category                  AS category,
       COUNT(*)                    AS num_transactions,
       AVG(ss.sale_amount)         AS avg_transaction,
       SUM(ss.sale_amount)         AS total_revenue
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
JOIN products p ON ss.prod_num = p.prodnum
JOIN inventory_categories i ON p.categoryid = i.categoryid
WHERE sl.state = 'Texas'
GROUP BY i.category
ORDER BY total_revenue DESC;
/* ANSWER:
Technology & Accessories - 5,219 transactions, avg 468.50, revenue 2,445,117.66
Textbooks                - 3,423 transactions, avg 174.30, revenue 596,616.41
Apparel and Merchandise  - 4,406 transactions, avg 32.32,  revenue 142,403.22
Art Supplies             - 3,787 transactions, avg 31.94,  revenue 120,953.81
Books (General)          - 1,981 transactions, avg 29.50,  revenue 58,436.68
Stationery and Supplies  - 5,396 transactions, avg 10.07,  revenue 54,322.23
Technology & Accessories is 71.5% of revenue from only 21.6% of transactions. */
# Revenue by category and year to see which categories are growing
SELECT i.category                  AS category,
       YEAR(ss.transaction_date)   AS sales_year,
       SUM(ss.sale_amount)         AS total_revenue
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
JOIN products p ON ss.prod_num = p.prodnum
JOIN inventory_categories i ON p.categoryid = i.categoryid
WHERE sl.state = 'Texas'
GROUP BY i.category, sales_year
ORDER BY i.category, sales_year;
-- ANSWER: 2025 vs 2024 growth: Technology +53%, Textbooks only +11%, all other categories more than doubled.

-- Q5 Provide a Ranking of in store sales performance by each store in TX.
SELECT * FROM store_locations WHERE state = 'Texas';
# Texas is an in-store territory so stores are ranked.
SELECT sl.storelocation,
       SUM(ss.sale_amount)         AS total_revenue,
       RANK() OVER (ORDER BY SUM(ss.sale_amount) DESC) AS sales_rank
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
WHERE sl.state = 'Texas'
GROUP BY sl.storelocation, sl.storeid
ORDER BY total_revenue DESC;
/* ANSWER: saved as csv file
1 Beaumont 637,818.90 | 2 Fort Worth 351,772.59 | 3 Desoto 330,720.12 | 4 Cedar Park 312,628.27
5 Baytown 298,163.16 | 6 Denton 298,111.45 | 7 Arlington 292,987.49 | 8 Austin 291,145.00
9 Bacliff 280,714.34 | 10 Georgetown 269,344.64 | 11 Dallas 54,444.05 */
-- =============================================================================
# Quick troubleshooting and run check on the Dallas location due to its unusually low revenue amount.
SELECT *
FROM store_locations
WHERE storelocation = 'Dallas';
SELECT sl.storelocation,
       COUNT(*)                   AS num_transactions,
       AVG(ss.sale_amount)        AS avg_sale,
       SUM(ss.sale_amount)        AS total_revenue,
       MIN(ss.transaction_date)   AS first_sale,
       MAX(ss.transaction_date)   AS last_sale
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
WHERE sl.state = 'Texas'
GROUP BY sl.storelocation
ORDER BY total_revenue DESC;
-- Discovered Dallas has only 430 transactions. It sells regularly only in 2022, then has a single month in
-- Dec 2023 and a single month in Nov 2024, and no sales in 2025. Beaumont, on the other hand, has about
-- twice the transactions of any other store (4,403).

-- Q6 Recommendation for where to focus sales attention in the next quarter.
-- ================ RECOMMENDATION ==================================
/* Focus on Technology & Accessories across all Texas stores, fix the Dallas gap, and push Textbooks
   for the spring semester.
   1) Technology & Accessories is 71.5% of Texas revenue (2.45M) and grew 53% in 2025. Beaumont shows
      what is possible, with about 455K in tech sales alone.
   2) Dallas (store 907) has almost no sales since 2022 (54K total vs. roughly 270K-350K for other stores).
      Find out if it is closed or has a reporting issue. If it is open, it is the biggest recovery opportunity.
   3) Textbooks grew only 11% in 2025 while the rest of the territory grew about 50%. A new semester starts
      in Q1, so targeted textbook promotions can close that gap.
   4) Georgetown is the lowest active store (92.8K in 2025). Compare its product mix to Beaumont's.
   5) October 2025 (168,955.72) looks like a one-time spike, so don't use it as the baseline for Q1 targets. */
