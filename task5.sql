-- task5_sql_mysql.sql
-- Creates sample schema + data and demonstrates joins (MySQL)

-- (Optional) create / use a database
CREATE DATABASE IF NOT EXISTS sql_joins_task;
USE sql_joins_task;

-- DROP if exists (safe rerun)
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;

-- 1) Customers table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  CustomerName VARCHAR(100),
  City VARCHAR(50)
);

-- 2) Products table (used for multi-table join)
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Price DECIMAL(10,2)
);

-- 3) Orders table
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT NULL,
  OrderDate DATE,
  OrderAmount DECIMAL(10,2),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 4) OrderItems table (many-to-one relationship to Orders and Products)
CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY,
  OrderID INT,
  ProductID INT,
  Qty INT,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Customers -- include one customer with no orders
INSERT INTO Customers (CustomerID, CustomerName, City) VALUES
(1, 'Asha Patel', 'Mumbai'),
(2, 'Rahul Sharma', 'Pune'),
(3, 'Meera Singh', 'Delhi'),
(4, 'Karan Joshi', 'Bengaluru'); -- no orders for CustomerID=4

-- Insert Products
INSERT INTO Products (ProductID, ProductName, Price) VALUES
(101, 'Handmade Notebook', 150.00),
(102, 'Beaded Bracelet', 250.50),
(103, 'Greeting Card', 40.00);

-- Insert Orders -- include an order with a non-matching CustomerID (NULL or 999)
INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderAmount) VALUES
(1001, 1, '2025-09-01', 340.50),
(1002, 2, '2025-09-05', 250.50),
(1003, 2, '2025-09-08', 40.00),
(1004, NULL, '2025-09-10', 500.00);   -- order without customer recorded    -- order referencing non-existent customer (foreign key will fail if enforced)
-- Note: If your DB enforces FK strictly, remove or modify the 1005 row above. It's included to show join behavior.

-- If FK prevents insertion for 1005, use this instead:
-- INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderAmount) VALUES (1005, NULL, '2025-09-15', 120.00);

-- Insert OrderItems (multi-table join demo)
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Qty) VALUES
(1, 1001, 101, 1),
(2, 1001, 102, 1),
(3, 1002, 102, 1),
(4, 1003, 103, 1),
(5, 1004, 101, 2);

-- ========== JOIN EXAMPLES ==========

-- 1) INNER JOIN: customers who have orders
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate, o.OrderAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID, o.OrderID;

-- 2) LEFT JOIN: all customers, with orders if present
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID;

-- 3) RIGHT JOIN: all orders, with customer info if present
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID;

-- 4) FULL OUTER JOIN (MySQL does not support FULL OUTER JOIN natively).
-- Emulate FULL OUTER by UNION of LEFT and RIGHT minus duplicates:
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID

UNION

SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY CustomerID, OrderID;

-- Alternative FULL OUTER emulation using UNION ALL + filtering duplicates:
-- (Not necessary here; the UNION above is fine for small examples.)

-- 5) CROSS JOIN: Cartesian product (use carefully)
SELECT c.CustomerName, p.ProductName
FROM Customers c
CROSS JOIN Products p
LIMIT 10;

-- 6) NATURAL JOIN example (ONLY when column names match)
-- For demonstration, create two small tables with same column name
DROP TABLE IF EXISTS A;
DROP TABLE IF EXISTS B;
CREATE TABLE A (id INT, val VARCHAR(10));
CREATE TABLE B (id INT, other VARCHAR(10));
INSERT INTO A VALUES (1,'x'),(2,'y');
INSERT INTO B VALUES (1,'foo'),(3,'bar');
-- Natural join will join on column "id"
SELECT * FROM A NATURAL JOIN B;

-- 7) SELF JOIN (find customers who share the same city)
SELECT c1.CustomerID AS C1, c1.CustomerName AS Name1,
       c2.CustomerID AS C2, c2.CustomerName AS Name2, c1.City
FROM Customers c1
JOIN Customers c2 ON c1.City = c2.City AND c1.CustomerID < c2.CustomerID;

-- 8) Joining more than 2 tables: get order details (customer + order + items + product)
SELECT o.OrderID, o.OrderDate, c.CustomerName, oi.OrderItemID, p.ProductName, oi.Qty, p.Price, (oi.Qty * p.Price) AS LineTotal
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
LEFT JOIN Products p ON oi.ProductID = p.ProductID
ORDER BY o.OrderID, oi.OrderItemID;

-- 9) Example: avoid Cartesian product by providing ON conditions:
-- Bad: SELECT * FROM Orders, Customers;  -- THIS causes Cartesian product
-- Good: SELECT * FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 10) Clean up helper tables A,B used for NATURAL demo (optional)
DROP TABLE IF EXISTS A;
DROP TABLE IF EXISTS B;

-- End of script
