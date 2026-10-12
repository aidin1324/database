-- Only the lab11 schema is reset.
DROP SCHEMA IF EXISTS lab11 CASCADE;
CREATE SCHEMA lab11;
CREATE TABLE lab11.students (
 student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL, birth_date DATE
);
INSERT INTO lab11.students (first_name,last_name,birth_date)
VALUES ('Aibek','Sharshenov','2002-05-12') RETURNING *;
INSERT INTO lab11.students (first_name,last_name,birth_date) VALUES
 ('Ainura','Toktomamatova','2001-09-23'),
 ('Bakyt','Mamatov','2003-01-15'), ('Gulzat','Sultanova','2002-07-30') RETURNING *;
UPDATE lab11.students SET birth_date='2002-05-15'
WHERE first_name='Aibek' AND last_name='Sharshenov' RETURNING *;
DELETE FROM lab11.students WHERE first_name='Gulzat' AND last_name='Sultanova' RETURNING *;
DELETE FROM lab11.students WHERE birth_date < DATE '2002-01-01' RETURNING *;
