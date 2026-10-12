DROP SCHEMA IF EXISTS lab14 CASCADE;
CREATE SCHEMA lab14;
SET search_path=lab14,pg_catalog;
CREATE TABLE customers(customer_id INTEGER PRIMARY KEY,name TEXT,email TEXT);
CREATE TABLE orders(order_id INTEGER PRIMARY KEY,customer_id INTEGER REFERENCES customers,order_date DATE,total_amount NUMERIC(10,2));
INSERT INTO customers VALUES (1,'Nurai','nurai@example.edu'),(2,'Alikhan','alikhan@example.edu'),(3,'Aelita','aelita@example.edu');
INSERT INTO orders VALUES (1,1,'2026-10-01',150),(2,1,'2026-10-02',50),(3,2,'2026-10-03',200),(4,NULL,'2026-10-04',25);
-- A nullable FK permits the guest order while still rejecting invalid non-null IDs.
SELECT c.name,o.order_id,o.total_amount FROM customers c INNER JOIN orders o USING(customer_id) ORDER BY o.order_id;
SELECT c.name,o.order_id FROM customers c LEFT JOIN orders o USING(customer_id) ORDER BY c.customer_id,o.order_id;
SELECT c.name,o.order_id FROM customers c RIGHT JOIN orders o USING(customer_id) ORDER BY o.order_id;
SELECT c.name,o.order_id FROM customers c FULL OUTER JOIN orders o USING(customer_id) ORDER BY c.customer_id,o.order_id;
CREATE TABLE products(product_id INTEGER PRIMARY KEY,product_name TEXT,price NUMERIC(10,2));
INSERT INTO products VALUES (1,'Book',50),(2,'Pen',25);
SELECT c.name,p.product_name FROM customers c CROSS JOIN products p ORDER BY c.customer_id,p.product_id;
CREATE TABLE order_items(order_id INTEGER REFERENCES orders,product_id INTEGER REFERENCES products,quantity INTEGER CHECK(quantity>0),PRIMARY KEY(order_id,product_id));
INSERT INTO order_items VALUES (1,1,2),(1,2,2),(2,1,1),(3,1,4),(4,2,1);
SELECT c.name,o.order_id,oi.quantity,p.product_name,p.price FROM customers c
JOIN orders o USING(customer_id) JOIN order_items oi USING(order_id) JOIN products p USING(product_id)
ORDER BY o.order_id,p.product_id;
CREATE TABLE employees(employee_id INTEGER PRIMARY KEY,name TEXT,manager_id INTEGER REFERENCES employees);
INSERT INTO employees VALUES (1,'Director',NULL),(2,'Manager',1),(3,'Assistant',2);
SELECT e.name AS employee,m.name AS manager FROM employees e LEFT JOIN employees m ON e.manager_id=m.employee_id ORDER BY e.employee_id;
SELECT c.name,o.order_date,o.total_amount FROM customers c JOIN orders o USING(customer_id)
WHERE o.order_date>=DATE '2024-01-01' AND o.total_amount>100 ORDER BY o.order_id;
CREATE TABLE user_profiles(customer_id INTEGER PRIMARY KEY REFERENCES customers,phone TEXT);
INSERT INTO user_profiles VALUES (1,'sample-phone');
SELECT c.name,p.phone FROM customers c LEFT JOIN user_profiles p USING(customer_id) ORDER BY c.customer_id;
CREATE TABLE authors(author_id INTEGER PRIMARY KEY,author_name TEXT);
CREATE TABLE books(book_id INTEGER PRIMARY KEY,title TEXT,publication_year INTEGER,author_id INTEGER REFERENCES authors);
INSERT INTO authors VALUES (1,'George Orwell');
INSERT INTO books VALUES (1,'Animal Farm',1945,1),(2,'Nineteen Eighty-Four',1949,1);
SELECT a.author_name,b.title,b.publication_year FROM authors a JOIN books b USING(author_id) ORDER BY a.author_name,b.publication_year;
CREATE TABLE students(student_id INTEGER PRIMARY KEY,student_name TEXT);
CREATE TABLE courses(course_id INTEGER PRIMARY KEY,course_name TEXT);
CREATE TABLE enrollments(student_id INTEGER REFERENCES students,course_id INTEGER REFERENCES courses,enrollment_date DATE,grade TEXT,PRIMARY KEY(student_id,course_id));
INSERT INTO students VALUES (1,'Nurai'),(2,'Alikhan');
INSERT INTO courses VALUES (1,'Database'),(2,'Programming');
INSERT INTO enrollments VALUES (1,1,'2026-10-01','A'),(1,2,'2026-10-01',NULL),(2,1,'2026-10-01','B');
SELECT s.student_name,c.course_name,e.grade FROM students s JOIN enrollments e USING(student_id)
JOIN courses c USING(course_id) WHERE e.grade IS NOT NULL ORDER BY s.student_name,c.course_name;
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
-- The composite PK already indexes order_items(order_id,product_id).
SELECT c.name FROM customers c LEFT JOIN orders o USING(customer_id) WHERE o.order_id IS NULL;
SELECT o.order_id FROM customers c RIGHT JOIN orders o USING(customer_id) WHERE c.customer_id IS NULL;
SELECT c.name,o.order_id FROM customers c FULL JOIN orders o USING(customer_id) WHERE c.customer_id IS NULL OR o.order_id IS NULL;
EXPLAIN (ANALYZE,BUFFERS) SELECT c.name,o.order_id FROM customers c JOIN orders o USING(customer_id);
RESET search_path;
