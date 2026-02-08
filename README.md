# PL/SQL Window Functions & JOINs Project

**Course:** Database Development with PL/SQL (INSY 8311)  
**Student:** [Ingabire naddy]  
**Student ID:** [29003]  
**Group:** [d]  
**Instructor:** Eric Maniraguha  
**Date:**8 February 2026

---

## Table of Contents
1. [business problem](#business-problem)
2. [Success Criteria](#success-criteria)
3. [Database Schema](#database-schema)
4. [Part A: SQL JOINs](#part-a-sql-joins)
5. [Part B: Window Functions](#part-b-window-functions)
6. [Results Analysis](#results-analysis)
7. [Key Insights](#key-insights)
8. [References](#references)
9. [Academic Integrity Statement](#academic-integrity-statement)

---

## Business Problem

### Business Context
[Describe your company type, department, and industry - e.g., "E-commerce retail company analyzing regional sales performance"]

### Data Challenge
[2-3 sentences explaining the specific problem you're solving]

### Expected Outcome
[What decision or insight will this analysis provide?]

---

## Success Criteria

1. **Top 5 Products per Region** → Using `RANK()` to identify best-performing products by geographic area
2. **Running Monthly Sales Totals** → Using `SUM() OVER()` to track cumulative revenue trends
3. **Month-over-Month Growth** → Using `LAG()/LEAD()` to calculate period-to-period changes
4. **Customer Quartile Segmentation** → Using `NTILE(4)` to categorize customers into value tiers
5. **Three-Month Moving Averages** → Using `AVG() OVER()` to smooth sales trends

---

## Database Schema

### Entity Relationship Diagram
![ER Diagram](screenshots/er_diagram.png)

### Table Structures

#### Table 1: Customers
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    join_date DATE
);
```

#### Table 2: Products
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);
```

#### Table 3: Transactions
```sql
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    transaction_date DATE,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## Part A: SQL JOINs

### 1. INNER JOIN
**Purpose:** Retrieve all valid transactions with customer and product details

```sql
-- SQL Query
SELECT 
    t.transaction_id,
    c.customer_name,
    p.product_name,
    t.total_amount
FROM transactions t
INNER JOIN customers c ON t.customer_id = c.customer_id
INNER JOIN products p ON t.product_id = p.product_id;
```

**Screenshot:**  
![INNER JOIN Results](screenshots/inner_join.png)

**Business Interpretation:**  
[2-3 sentences explaining what the results mean for the business]

---

### 2. LEFT JOIN
**Purpose:** Identify customers who have never made a purchase

```sql
-- SQL Query
SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    t.transaction_id
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL;
```

**Screenshot:**  
![LEFT JOIN Results](screenshots/left_join.png)

**Business Interpretation:**  
[Explain how this helps identify inactive customers for re-engagement campaigns]

---

### 3. RIGHT JOIN
**Purpose:** Detect products with no sales activity

```sql
-- SQL Query
SELECT 
    p.product_id,
    p.product_name,
    t.transaction_id
FROM transactions t
RIGHT JOIN products p ON t.product_id = p.product_id
WHERE t.transaction_id IS NULL;
```

**Screenshot:**  
![RIGHT JOIN Results](screenshots/right_join.png)

**Business Interpretation:**  
[Explain how this identifies underperforming inventory]

---

### 4. FULL OUTER JOIN
**Purpose:** Compare all customers and products including unmatched records

```sql
-- SQL Query
SELECT 
    c.customer_name,
    p.product_name,
    t.total_amount
FROM customers c
FULL OUTER JOIN transactions t ON c.customer_id = t.customer_id
FULL OUTER JOIN products p ON t.product_id = p.product_id;
```

**Screenshot:**  
![FULL OUTER JOIN Results](screenshots/full_outer_join.png)

**Business Interpretation:**  
[Explain comprehensive view of all entities]

---

### 5. SELF JOIN
**Purpose:** Compare customers within the same region

```sql
-- SQL Query
SELECT 
    c1.customer_name AS customer_1,
    c2.customer_name AS customer_2,
    c1.region
FROM customers c1
INNER JOIN customers c2 ON c1.region = c2.region
WHERE c1.customer_id < c2.customer_id;
```

**Screenshot:**  
![SELF JOIN Results](screenshots/self_join.png)

**Business Interpretation:**  
[Explain how this supports regional analysis or peer comparison]

---

## Part B: Window Functions

### Category 1: Ranking Functions

#### ROW_NUMBER()
**Purpose:** Assign unique sequential numbers to products by sales

```sql
-- SQL Query
SELECT 
    product_id,
    product_name,
    total_revenue,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS row_num
FROM product_sales;
```

**Screenshot:**  
![ROW_NUMBER Results](screenshots/row_number.png)

**Interpretation:**  
[Explain the ranking outcome]

---

#### RANK()
**Purpose:** Rank top 5 products per region

```sql
-- SQL Query
SELECT 
    region,
    product_name,
    revenue,
    RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS rank
FROM regional_product_sales
WHERE rank <= 5;
```

**Screenshot:**  
![RANK Results](screenshots/rank.png)

**Interpretation:**  
[Explain regional performance insights]

---

#### DENSE_RANK()
```sql
-- Add your query here
```

#### PERCENT_RANK()
```sql
-- Add your query here
```

---

### Category 2: Aggregate Window Functions

#### SUM() OVER() - Running Total
**Purpose:** Calculate cumulative monthly sales

```sql
-- SQL Query
SELECT 
    month,
    monthly_sales,
    SUM(monthly_sales) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS running_total
FROM monthly_revenue;
```

**Screenshot:**  
![Running Total Results](screenshots/sum_over.png)

**Interpretation:**  
[Explain trend analysis]

---

#### AVG() OVER() - Moving Average
**Purpose:** Calculate 3-month moving average

```sql
-- SQL Query
SELECT 
    month,
    sales,
    AVG(sales) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3m
FROM monthly_sales;
```

**Screenshot:**  
![Moving Average Results](screenshots/avg_over.png)

**Interpretation:**  
[Explain smoothed trends]

---

### Category 3: Navigation Functions

#### LAG() - Previous Period Comparison
**Purpose:** Calculate month-over-month growth

```sql
-- SQL Query
SELECT 
    month,
    sales,
    LAG(sales) OVER (ORDER BY month) AS previous_month_sales,
    sales - LAG(sales) OVER (ORDER BY month) AS mom_change
FROM monthly_sales;
```

**Screenshot:**  
![LAG Results](screenshots/lag.png)

**Interpretation:**  
[Explain growth patterns]

---

#### LEAD() - Next Period Projection
```sql
-- Add your query here
```

---

### Category 4: Distribution Functions

#### NTILE(4) - Customer Segmentation
**Purpose:** Segment customers into quartiles by lifetime value

```sql
-- SQL Query
SELECT 
    customer_id,
    customer_name,
    lifetime_value,
    NTILE(4) OVER (ORDER BY lifetime_value DESC) AS customer_quartile
FROM customer_value;
```

**Screenshot:**  
![NTILE Results](screenshots/ntile.png)

**Interpretation:**  
[Explain how this supports targeted marketing]

---

#### CUME_DIST()
```sql
-- Add your query here
```

---

## Results Analysis

### Descriptive Analysis - What Happened?
[Summarize the key findings from your data - what patterns emerged?]

### Diagnostic Analysis - Why Did It Happen?
[Explain the underlying reasons for the trends you observed]

### Prescriptive Analysis - What Should Be Done?
[Provide actionable recommendations based on your findings]

---

## Key Insights

1. **[First Major Finding]** - [Brief explanation]
2. **[Second Major Finding]** - [Brief explanation]
3. **[Third Major Finding]** - [Brief explanation]

---

## References

1. Oracle Documentation - Window Functions: https://docs.oracle.com/...
2. PostgreSQL Tutorial - JOINs: https://www.postgresql.org/...
3. [Add your actual sources here]

---

## Academic Integrity Statement

"All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation."

**Personal Work Evidence:**

I hereby confirm that:
- All SQL queries were written by me
- All analysis and interpretations are my original work
- I consulted the references listed above for syntax and best practices
- No plagiarism or unauthorized collaboration occurred

**Selected Screenshots Proving Personal Work:**

![Screenshot 1](screenshots/proof_1.png)  
![Screenshot 2](screenshots/proof_2.png)

---

**Signature:** [Your Name]  
**Date:** [Submission Date]

---

> "Whoever is faithful in very little is also faithful in much." — Luke 16:10
