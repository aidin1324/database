-- Laboratory Work 4: First SQL Query
-- Database: lab03

-- All columns and rows.
SELECT *
FROM students
ORDER BY student_id;

-- Selected columns.
SELECT full_name, email
FROM students
ORDER BY full_name ASC;

-- Read two fields from each record.
SELECT student_id, faculty
FROM students
ORDER BY student_id;

-- Match one name.
SELECT full_name, email
FROM students
WHERE full_name = 'Nurai Sadykova';

-- Filter rows with WHERE.
SELECT full_name, faculty, city
FROM students
WHERE faculty = 'COMSEH';

-- Reverse alphabetical order.
SELECT full_name, email
FROM students
ORDER BY full_name DESC;

-- Limit the output to two records.
SELECT full_name, email
FROM students
ORDER BY student_id
LIMIT 2;

-- Sort rows and limit the result.
SELECT full_name, age, faculty
FROM students
ORDER BY age, full_name
LIMIT 5;

/* SQL comments are ignored by PostgreSQL.
   They can explain the purpose of a query. */
