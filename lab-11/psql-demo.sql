\set ON_ERROR_STOP on
\pset pager off
\ir lab11.sql
-- Client-side COPY reads the CSV from the repository, not the server filesystem.
\copy lab11.students(first_name,last_name,birth_date) FROM 'lab-11/students.csv' WITH (FORMAT csv, HEADER true)
SELECT * FROM lab11.students ORDER BY student_id;
UPDATE lab11.students SET last_name='Bekov' WHERE last_name IN ('Uulu','Isakov') RETURNING *;
DELETE FROM lab11.students WHERE student_id IN (2,3,5) RETURNING *;
SELECT * FROM lab11.students ORDER BY student_id;
