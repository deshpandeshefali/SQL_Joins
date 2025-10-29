# Elevate Labs - SQL Developer Internship

## Task 5 - SQL Joins (Inner, Left, Right, Full)

### Objective

The goal is to learn to combine data from multiple tables. 

## Contents

- `task5_sql_mysql.sql` — MySQL script (create schema, sample data, join examples)
- `README.md` — this file documenting the approach.

### Tools Used
*  **MySQL Workbench**: Used to connect to the database, write, and execute the SQL queries[cite: 5].
* **SQL Language**: For writing the queries.

## What this demonstrates
- `INNER JOIN` — return only matching rows in both tables.
- `LEFT JOIN` — all rows from left table + matched rows from right.
- `RIGHT JOIN` — all rows from right table + matched rows from left (MySQL); emulate in SQLite by swapping and using LEFT JOIN.
- `FULL OUTER JOIN` — emulate by unioning `LEFT JOIN` and `RIGHT JOIN` results.
- `CROSS JOIN` — Cartesian product (careful).
- `NATURAL JOIN` — auto-join on columns with same name.
- `SELF JOIN` — join a table to itself (e.g., customers in same city).
- Multi-table joins — combining Customers, Orders, OrderItems, Products.

## Interview Questions (short answers)

1. **Difference between INNER and LEFT JOIN?**  
   INNER returns only rows that match on both sides. LEFT returns all rows from the left table and matched rows from the right (NULL if no match).

2. **What is a FULL OUTER JOIN?**  
   Returns rows when there is a match in one of the tables; rows without matches on either side appear with NULLs. (If DB doesn't support it natively, emulate with `LEFT JOIN` UNION `RIGHT JOIN`.)

3. **Can joins be nested?**  
   Yes. You can nest joins by joining results from earlier joins to other tables (e.g., `(A JOIN B) JOIN C`).

4. **How to join more than 2 tables?**  
   Chain join clauses: `A JOIN B ON ... JOIN C ON ... JOIN D ON ...` — ensure join conditions prevent Cartesian products.

5. **What is a CROSS JOIN?**  
   Cartesian product: every row of A paired with every row of B. Use only when intended.

6. **What is a NATURAL JOIN?**  
   Joins automatically on columns with the same name in both tables. Use with caution — explicit ON is usually safer.

7. **Can you join tables without a foreign key?**  
   Yes — joins are based on matching column values, foreign keys help maintain referential integrity but are not required for the SQL join to execute.

8. **What is a self-join?**  
   A table joined with itself, typically using table aliases to compare rows within the same table.

9. **What causes Cartesian product?**  
   Missing or incorrect `ON` clause in joins (or using explicit CROSS JOIN) causes Cartesian product; results multiply rows.

10. **How to optimize joins?**  
    - Create appropriate indexes (on join columns).  
    - Select only required columns (avoid `SELECT *`).  
    - Use proper join type and join ordering.  
    - Update statistics, avoid functions on join columns, and consider query rewriting and explain plans.

**Author**
**Shefali Deshpande**
