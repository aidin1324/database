-- Work only inside this lab's schema. Rerunning resets its example tables.
CREATE SCHEMA IF NOT EXISTS lab06;
DROP TABLE IF EXISTS lab06.university_students;
DROP TABLE IF EXISTS lab06.students;

CREATE TABLE lab06.students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100),
    grade NUMERIC(5, 2),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    enrolled_on DATE NOT NULL DEFAULT CURRENT_DATE,
    last_seen TIMESTAMP,
    notes TEXT
);

INSERT INTO lab06.students (first_name, last_name, email, faculty, grade, notes)
VALUES
    ('Nurai', 'Sadykova', 'nurai@example.edu', 'Computer Science', 91.50, 'First year'),
    ('Alikhan', 'Omarov', 'alikhan@example.edu', 'Mathematics', 84.00, 'Second year');

ALTER TABLE lab06.students ADD COLUMN date_of_birth DATE;
UPDATE lab06.students SET date_of_birth = DATE '2006-04-12' WHERE email = 'nurai@example.edu';
UPDATE lab06.students SET date_of_birth = DATE '2004-11-03' WHERE email = 'alikhan@example.edu';
ALTER TABLE lab06.students DROP COLUMN notes;
ALTER TABLE lab06.students ALTER COLUMN first_name TYPE TEXT;
ALTER TABLE lab06.students ADD CONSTRAINT grade_range CHECK (grade BETWEEN 0 AND 100);
ALTER TABLE lab06.students RENAME COLUMN email TO email_address;
ALTER TABLE lab06.students RENAME TO university_students;

-- Constraint failures are expected and caught so the full script can finish.
DO $$
BEGIN
    BEGIN
        INSERT INTO lab06.university_students (first_name, last_name, email_address)
        VALUES ('Duplicate', 'Email', 'nurai@example.edu');
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'UNIQUE rejected a duplicate email';
    END;
    BEGIN
        INSERT INTO lab06.university_students (first_name, last_name, email_address, grade)
        VALUES ('Bad', 'Grade', 'bad@example.edu', 120);
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'CHECK rejected a grade above 100';
    END;
    BEGIN
        INSERT INTO lab06.university_students (first_name, last_name, email_address)
        VALUES (NULL, 'Name', 'null@example.edu');
    EXCEPTION WHEN not_null_violation THEN
        RAISE NOTICE 'NOT NULL rejected an empty first name';
    END;
END $$;

SELECT student_id, first_name, last_name, email_address, grade, active, date_of_birth
FROM lab06.university_students ORDER BY student_id;

-- IF EXISTS avoids an error when a disposable table is absent.
DROP TABLE IF EXISTS lab06.test_table;
CREATE TABLE lab06.test_table (id INTEGER PRIMARY KEY);
DROP TABLE lab06.test_table;

CREATE TEMP TABLE lab06_temp (id INTEGER, label TEXT);
INSERT INTO lab06_temp VALUES (1, 'Visible only in this session');
SELECT * FROM lab06_temp;
DROP TABLE pg_temp.lab06_temp;
