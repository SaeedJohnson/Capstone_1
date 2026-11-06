# Capstone 1: Business Analysis with SQL and Excel

**Author:** Saeed Johnson
**Program:** Year Up United Data Analytics Training Academy, Week 4 Capstone
**Territory analyzed:** Texas (in-store), South Region

## Project Description

This project is a sales territory analysis for **EmporiUm**, a fictional student bookstore chain that also sells tech products, art supplies, and other items in stores and online. I played the role of a data analyst for the **Texas sales territory**, which has 11 in-store locations and belongs to the **South region** (Florida, South Carolina, and Texas).

A sales manager asked six questions about the territory. I wrote SQL queries to answer each one, built an Excel PivotChart to visualize one of the results, and wrote a recommendation for where to focus sales attention in the next quarter.

### Questions answered
1. What is Texas's total revenue, and what period does the data cover?
2. What is the revenue breakdown by year and month?
3. How does Texas's revenue compare to the South region?
4. What are the number of transactions per month and the average transaction amount by product category?
5. How do the Texas stores rank by in-store sales performance?
6. Where should the team focus sales attention next quarter?

## Tools Used

| Tool | How I used it |
|---|---|
| **MySQL Workbench** | Loaded the `sample_sales` database and wrote and ran all SQL queries |
| **SQL (MySQL)** | Joins, aggregates (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`), `GROUP BY`, subqueries, and the `RANK()` window function |
| **Microsoft Excel** | Opened the exported CSV results and built the PivotChart |
| **Git and Git Bash** | Version control, with commits made throughout the week |
| **GitHub** | Published the project in the `Capstone_1` repository |
| **Microsoft PowerPoint** | Made the slides for the live presentation |

## Process

1. **Set up the repository.** I created the `Capstone_1` repo on GitHub and cloned it to my computer with Git Bash.
2. **Loaded and explored the data.** I ran `sample_sales.sql` in MySQL Workbench, then used `SHOW TABLES` and `DESCRIBE` to learn the tables and how they connect: `Store_Sales` joins to `Store_Locations` by store ID, `Products` joins to `Inventory_Categories` by category ID, and `Management` links each state to its region.
3. **Wrote the analysis script.** I created `johnson_sales_analysis.sql` with the territory documented at the top and a commented section for each question.
4. **Answered each question with SQL.**
   - Q1: `SUM`, `MIN`, and `MAX`, filtered to Texas
   - Q2: grouped by `YEAR()` and `MONTH()` of the transaction date
   - Q3: joined to `Management` to get all South region states, then used a subquery to calculate Texas's percentage of the region
   - Q4: joined sales, products, and categories to get transactions and average sale per category
   - Q5: ranked stores by revenue with `RANK() OVER`, then checked Dallas, which had unusually low sales
5. **Built the Excel PivotChart.** I exported a query result to CSV, saved it as an `.xlsx` file, and built a PivotChart of revenue by category and year.
6. **Wrote the recommendation** as a comment in the script, based on what the queries showed.
7. **Prepared the video and presentation** to walk through the questions, the PivotChart, and the recommendation.

## Key Findings

- Texas generated **$3,417,850.01** from 24,212 transactions between **January 1, 2022 and December 31, 2025**.
- Revenue grew from about $580K in 2022 to **$1.22M in 2025**, up about 51% in the last year.
- Texas accounts for **42.74%** of the South region's $7,996,850.12 in revenue.
- **Technology & Accessories** makes up about **71.5%** of revenue from only about 22% of transactions.
- **Beaumont** is the top store at about $638K. **Dallas** is last at about $54K and has almost no sales after 2022.

### Recommendation
Focus on **Technology & Accessories** in every store, find out what is going on with the **Dallas** location, and promote **Textbooks** for the spring semester, since they grew only about 11% in 2025 while other categories roughly doubled. October 2025 looks like a one-time spike, so it shouldn't be used as the baseline for next quarter's targets.

## Repository Files

| File | Description |
|---|---|
| `johnson_sales_analysis.sql` | SQL script with the queries, results, and recommendation for all six questions |
| `johnson_territory_chart.xlsx` | Excel PivotChart of revenue by category and year |
| `johnson_texas_presentation.pptx` | Slides for the 5-minute live presentation |
| `README.md` | This file |

## Video Demo

[Add your video link here]

## Notes
- This analysis covers **in-store sales only**. Online sales belong to a separate territory.
- Queries use window functions such as `RANK()`, which require MySQL 8.0 or later.
