# Retail Sales & Customer Intelligence using PostgreSQL

An end-to-end relational database design, SQL analytics suite, and business intelligence project evaluating 20 months of transaction data for **Duka Smart Electronics**, an electronics retailer operating across 10 Kenyan towns.

---

##  Project Overview

Duka Smart Electronics trades in mobile phones, laptops, home appliances, TVs, and accessories across ten locations including Nairobi, Mombasa, Meru, and Machakos. This project sets up the corporate PostgreSQL database, enforces core retail financial logic across 800 transaction records and 150 accounts, answers 46 business analytics questions using advanced SQL, and translates raw metrics into executive-level strategic recommendations.

### Key Analytical Capabilities Demonstrated
- **Schema & DDL Engineering:** Table design, primary/foreign key relationships, constraints, and data integrity validation.
- **Aggregations & Grouping:** Completed-order sales revenue, average order value (AOV), and cancellation rate computations.
- **Relational Joins:** Multi-table joins and `LEFT JOIN` operations to isolate unengaged account cohorts.
- **Subqueries & CTEs:** Data transformation pipelines using Common Table Expressions (`WITH`) for profit margin matrixes, above-average spender identification, and 90+ day churn tracking.
- **Window Functions:** Recency sequencing (`ROW_NUMBER`), spending ranks (`RANK`, `DENSE_RANK`), cumulative revenue totals, Month-over-Month (MoM) growth percentages (`LAG`), and quartile segmentation (`NTILE`).
- **Database Engineering:** Automated view generation (`monthly_sales_summary`), stored PL/pgSQL function development with zero-value handling (`get_customer_revenue`), and tier segmentation (`CASE` statements).

---
### Core Business Logic
* **Financial Calculations:** All monetary figures (Revenue, Cost, Profit, Margin, Spending) evaluate **Completed** orders only (`WHERE order_status = 'Completed'`).
* **Order Volumes:** Order counts include all records regardless of status (`Completed`, `Pending`, `Cancelled`).
* **Revenue Formula:** $\text{Revenue} = \text{quantity} \times \text{unit\_price} \times \left(1 - \frac{\text{discount}}{100.0}\right)$
* **Cost Formula:** $\text{Cost} = \text{quantity} \times \text{cost\_price}$
* **Profit Formula:** $\text{Profit} = \text{Revenue} - \text{Cost}$
* **Profit Margin %:** $\text{Margin \%} = \frac{\text{Profit}}{\text{NULLIF}(\text{Revenue}, 0)} \times 100.0$
* **Baseline Date:** Analytical recency ("Today") references `MAX(order_date)` in the database (`2026-09-30`) rather than system runtime dates.

---

##  Repository Structure

```text
retail-sales-sql/
├── README.md        # Project setup, database schema, workflow overview
├── schema.sql       # Table DDL definitions with keys and relational constraints
├── queries.sql      # Complete SQL script addressing Q1 through Q46
├── insights.md      # Five executive-level business findings & strategic recommendations
└── screenshots/     # Database verification & key visual query outputs
    ├── 01_verify_data.png
    ├── 02_monthly_sales_summary.png
    ├── 03_customer_function_test.png
    └── 04_management_report.png
```


Step-by-Step Installation
Clone the repository:
git clone [https://github.com/](https://github.com/)<your-username>/retail-sales-sql.git
cd retail-sales-sql
Initialize Database & Load Schemas:
If using psql via terminal, execute the script files in sequence:
# Create database (run while connected to default 'postgres' database)
psql -U postgres -d postgres -f 01_create_database.sql

# Create tables & import data (run connected to 'retail_analytics')
psql -U postgres -d retail_analytics -f 02_create_tables.sql
psql -U postgres -d retail_analytics -f 03_insert_customers.sql
psql -U postgres -d retail_analytics -f 04_insert_orders.sql
psql -U postgres -d retail_analytics -f 05_verify_data.sql
Verify Data Integrity:
Ensure 05_verify_data.sql returns the following exact dataset counts:

Customers: 150

Orders: 800

Orphaned Orders: 0

Date Range: 2025-01-01 to 2026-09-30

Execute Analytical Suite:
Open queries.sql inside your SQL editor and execute queries by section.

---
Section,Focus,Queries,SQL Concepts Applied
Section A,SQL Fundamentals,Q1 – Q10,"SELECT, WHERE, DISTINCT, LIKE/ILIKE, BETWEEN, ORDER BY, LIMIT"
Section B,Aggregation & Grouping,Q11 – Q20,"COUNT, SUM, AVG, MIN/MAX, GROUP BY, HAVING, ROUND, COUNT FILTER"
Section C,Joins & Customer Analytics,Q21 – Q28,"INNER JOIN, LEFT JOIN, zero-spend filtering, multi-level group spending"
Section D,Subqueries & CTEs,Q29 – Q34,"Common Table Expressions (WITH), nested aggregation, date arithmetic"
Section E,Window Functions,Q35 – Q42,"RANK(), ROW_NUMBER(), DENSE_RANK(), SUM() OVER, LAG(), NTILE(4)"
Section F,Business Intelligence & Engineering,Q43 – Q46,"Database Views (CREATE VIEW), PL/pgSQL Stored Functions, CASE segmentation"
---

Once you commit `README.md`, your entire repository structure is complete!
