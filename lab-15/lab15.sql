DROP SCHEMA IF EXISTS lab15 CASCADE;
CREATE SCHEMA lab15;
SET search_path=lab15,pg_catalog;
CREATE TABLE employees (
 employee_id INTEGER PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
 department TEXT, department_id INTEGER, salary NUMERIC(10,2), email TEXT,
 age INTEGER, hire_date DATE, experience_years INTEGER, bonus NUMERIC(10,2), manager_id INTEGER
);
INSERT INTO employees VALUES
 (1,'Alice','Adams','Engineering',3,120000,'alice@example.edu',45,'2020-01-10',15,5000,NULL),
 (2,'Bob','Brown','Engineering',3,90000,'bob@example.edu',32,'2022-05-01',8,NULL,1),
 (3,'Cara','Cole','Sales',5,70000,NULL,29,'2024-02-01',5,1000,1),
 (4,'Dan','Davis','Sales',5,50000,'dan@example.edu',24,'2024-06-01',2,0,3),
 (5,'Eve','Evans','Support',7,40000,'eve@example.edu',52,'2023-05-01',20,NULL,1),
 (6,'Ben','Baker','Sales',5,70000,'ben@example.edu',31,'2021-03-01',7,1500,3),
 (7,'Ana','Ali','Sales',5,60000,'ana@example.edu',27,'2024-03-01',4,NULL,3),
 (8,'Max','Mills','Sales',5,55000,'max@example.edu',35,'2022-04-01',10,500,3),
 (9,'Zoe','Zane','Sales',5,65000,'zoe@example.edu',41,'2020-09-01',12,NULL,3);
CREATE TABLE products (product_id INTEGER PRIMARY KEY, product_name TEXT, category TEXT, price NUMERIC(10,2));
INSERT INTO products VALUES (1,'Strawberry','Fruit',20),(2,'Blueberry','Fruit',50),(3,'Notebook','Stationery',10),(4,'Pen','Stationery',2);
CREATE TABLE sales (sale_id INTEGER PRIMARY KEY, employee_id INTEGER REFERENCES employees, amount NUMERIC(10,2), sale_date DATE);
INSERT INTO sales VALUES (1,3,1200,'2025-01-10'),(2,3,800,'2025-03-20'),(3,4,500,'2025-04-01'),(4,6,1500,'2026-01-20');

-- Scalar, row and table subqueries.
SELECT first_name,salary FROM employees WHERE salary>(SELECT AVG(salary) FROM employees) ORDER BY employee_id;
SELECT first_name FROM employees WHERE (department,salary)=(SELECT department,salary FROM employees WHERE employee_id=3) ORDER BY employee_id;
SELECT department,avg_salary FROM (SELECT department,AVG(salary) AS avg_salary FROM employees GROUP BY department) d WHERE avg_salary>60000 ORDER BY department;
WITH regional_sales AS (SELECT e.department_id,SUM(s.amount) AS total FROM sales s JOIN employees e USING(employee_id) GROUP BY e.department_id)
SELECT * FROM regional_sales WHERE total>1000 ORDER BY department_id;
WITH RECURSIVE org_chart AS (
 SELECT employee_id,first_name,manager_id,0 AS depth,ARRAY[employee_id] AS path FROM employees WHERE manager_id IS NULL
 UNION ALL
 SELECT e.employee_id,e.first_name,e.manager_id,o.depth+1,o.path||e.employee_id
 FROM employees e JOIN org_chart o ON e.manager_id=o.employee_id WHERE NOT e.employee_id=ANY(o.path)
) SELECT employee_id,first_name,manager_id,depth FROM org_chart ORDER BY path;
CREATE TABLE warehouse_1(product_id INTEGER,product_name TEXT,quantity INTEGER);
CREATE TABLE warehouse_2(LIKE warehouse_1);
INSERT INTO warehouse_1 VALUES (1,'Book',0),(2,'Pen',3);
INSERT INTO warehouse_2 VALUES (1,'Book',0),(3,'Pencil',5);
SELECT product_name FROM warehouse_1 UNION SELECT product_name FROM warehouse_2 ORDER BY 1;
SELECT product_name FROM warehouse_1 UNION ALL SELECT product_name FROM warehouse_2 ORDER BY 1;
SELECT product_id FROM warehouse_1 WHERE quantity=0 INTERSECT SELECT product_id FROM warehouse_2 WHERE quantity=0;
SELECT product_name FROM warehouse_1 EXCEPT SELECT product_name FROM warehouse_2;
SELECT first_name,department,salary,
 ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC,employee_id) AS row_number,
 RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank,
 DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM employees ORDER BY department,salary DESC,employee_id;
SELECT employee_id,first_name,
 SUM(salary) OVER(PARTITION BY department) AS department_salary,
 ROUND(AVG(salary) FILTER(WHERE experience_years>5) OVER(),2) AS experienced_average,
 LAG(salary) OVER(ORDER BY employee_id) AS previous_salary,
 LEAD(salary) OVER(ORDER BY employee_id) AS next_salary,
 SUM(salary) OVER(ORDER BY employee_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_salary
FROM employees ORDER BY employee_id;
CREATE TABLE annual_sales(product_name TEXT,year INTEGER,sales_amount NUMERIC);
INSERT INTO annual_sales VALUES ('Book',2022,100),('Book',2023,150),('Book',2024,200),('Pen',2022,20),('Pen',2023,30),('Pen',2024,40);
CREATE VIEW pivoted_sales AS SELECT product_name,
 SUM(CASE WHEN year=2022 THEN sales_amount ELSE 0 END) AS year_2022,
 SUM(CASE WHEN year=2023 THEN sales_amount ELSE 0 END) AS year_2023,
 SUM(CASE WHEN year=2024 THEN sales_amount ELSE 0 END) AS year_2024 FROM annual_sales GROUP BY product_name;
SELECT * FROM pivoted_sales ORDER BY product_name;
SELECT product_name,2022 AS year,year_2022 AS amount FROM pivoted_sales
UNION ALL SELECT product_name,2023,year_2023 FROM pivoted_sales
UNION ALL SELECT product_name,2024,year_2024 FROM pivoted_sales ORDER BY product_name,year;
CREATE TABLE priorities(product_name TEXT,status TEXT);
INSERT INTO priorities VALUES ('Book','Low Priority'),('Pen','High Priority'),('Pencil','Medium Priority');
SELECT * FROM priorities ORDER BY CASE status WHEN 'High Priority' THEN 1 WHEN 'Medium Priority' THEN 2 WHEN 'Low Priority' THEN 3 ELSE 4 END,product_name;
CREATE INDEX idx_employee_department_salary ON employees(department,salary);
ANALYZE employees;
EXPLAIN SELECT first_name,salary FROM employees WHERE department='Sales' AND salary>60000;
EXPLAIN (ANALYZE,BUFFERS) SELECT first_name,salary FROM employees WHERE department='Sales' AND salary>60000 ORDER BY salary DESC,employee_id LIMIT 10;

RESET search_path;
