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

---

##  Repository Structure

```text
retail-sales-sql/
├── README.md        # Project setup, database schema, workflow overview
├── schema.sql       # Table DDL definitions with keys and relational constraints
├── queries.sql      # Complete SQL script addressing Q1 through Q46
├── insights.md      # Five executive-level business findings & strategic recommendations
└── screenshots/     # Database verification & key visual query outputs
    ├── 01
    ├── 02
    ├── 03
    └── 04
```





