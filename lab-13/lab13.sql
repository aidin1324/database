DROP SCHEMA IF EXISTS lab13 CASCADE;
CREATE SCHEMA lab13;
SET search_path=lab13,pg_catalog;
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

SELECT COUNT(*) AS employees,COUNT(email) AS emails,COUNT(DISTINCT department) AS departments FROM employees;
SELECT SUM(salary) AS total_salary,ROUND(AVG(salary),2) AS average_salary,MIN(salary),MAX(salary) FROM employees;
SELECT e.department,SUM(s.amount) AS total_sales FROM sales s JOIN employees e USING(employee_id) GROUP BY e.department;
SELECT department,ROUND(AVG(age),2) AS avg_age,MAX(hire_date) AS latest_hire FROM employees GROUP BY department ORDER BY department;
SELECT department,STRING_AGG(first_name,', ' ORDER BY first_name) AS names,
 ARRAY_AGG(salary ORDER BY salary,employee_id) AS salaries,ARRAY_AGG(first_name ORDER BY last_name) AS names_by_surname
FROM employees GROUP BY department ORDER BY department;
CREATE TABLE employee_skills(employee_id INTEGER REFERENCES employees,skill_name TEXT);
INSERT INTO employee_skills VALUES (1,'SQL'),(1,'Python'),(2,'SQL');
SELECT employee_id,STRING_AGG(skill_name,', ' ORDER BY skill_name) AS skills FROM employee_skills GROUP BY employee_id ORDER BY employee_id;
SELECT department,ROUND(STDDEV(salary),2) AS stddev,ROUND(VARIANCE(salary),2) AS variance FROM employees GROUP BY department ORDER BY department;
SELECT CORR(experience_years,salary) AS experience_salary_correlation FROM employees;
SELECT category,COUNT(*) AS products,SUM(price) AS total_price,AVG(price) AS avg_price FROM products GROUP BY category ORDER BY category;
SELECT EXTRACT(YEAR FROM sale_date) AS year,EXTRACT(QUARTER FROM sale_date) AS quarter,COUNT(*),SUM(amount)
FROM sales GROUP BY 1,2 ORDER BY 1,2;
SELECT CASE WHEN age<30 THEN 'Under 30' WHEN age<=50 THEN '30-50' ELSE 'Over 50' END AS age_group,
 COUNT(*),ROUND(AVG(salary),2) AS avg_salary FROM employees GROUP BY 1 ORDER BY 1;
SELECT department,COUNT(*) FROM employees GROUP BY department HAVING COUNT(*)>5;
CREATE TABLE product_reviews(product_id INTEGER REFERENCES products,rating INTEGER CHECK(rating BETWEEN 1 AND 5));
INSERT INTO product_reviews SELECT 1,5 FROM generate_series(1,10);
INSERT INTO product_reviews VALUES (2,3),(2,5);
SELECT product_id,AVG(rating),COUNT(*) FROM product_reviews GROUP BY product_id HAVING AVG(rating)>4 AND COUNT(*)>=10;
SELECT department,AVG(salary) AS dept_average FROM employees GROUP BY department ORDER BY department;
SELECT employee_id,first_name,department,salary,ROUND(AVG(salary) OVER(PARTITION BY department),2) AS dept_average FROM employees ORDER BY employee_id;
SELECT COUNT(*) AS total_rows,COUNT(email) AS non_null_emails,COUNT(*)-COUNT(email) AS null_emails,
 SUM(bonus) AS total_bonus,AVG(bonus) AS avg_bonus,COUNT(bonus) AS bonuses FROM employees;
SELECT department,COUNT(*) AS employee_count,MIN(salary),MAX(salary),AVG(salary),STDDEV(salary)
FROM employees GROUP BY department ORDER BY AVG(salary) DESC;
SELECT department,COUNT(*) AS employees,COUNT(CASE WHEN salary>50000 THEN 1 END) AS high_earners,
 COUNT(CASE WHEN hire_date>DATE '2023-01-01' THEN 1 END) AS recent_hires,
 ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM employees),2) AS percentage
FROM employees GROUP BY department ORDER BY department;

RESET search_path;
