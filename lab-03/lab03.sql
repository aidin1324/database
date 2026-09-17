-- Laboratory Work 3
-- Database: lab03
-- Repeat runs keep the same 12 students. Only the temporary demo table is dropped.

CREATE TABLE IF NOT EXISTS students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INTEGER NOT NULL CHECK (age BETWEEN 16 AND 100),
    faculty VARCHAR(40) NOT NULL,
    city VARCHAR(60) NOT NULL,
    enrollment_year INTEGER NOT NULL CHECK (enrollment_year BETWEEN 2000 AND 2100)
);

INSERT INTO students (full_name, email, age, faculty, city, enrollment_year) VALUES
    ('Nurai Sadykova',       'nurai.sadykova@example.edu',       19, 'COMSEH', 'Bishkek',   2025),
    ('Alikhan Omarov',       'alikhan.omarov@example.edu',       21, 'SBE',    'Osh',        2023),
    ('Aelita Toktomusheva',  'aelita.toktomusheva@example.edu',  20, 'LAS',    'Karakol',    2024),
    ('Bekzat Usubaliev',     'bekzat.usubaliev@example.edu',     22, 'COMSEH', 'Naryn',      2022),
    ('Diana Karimova',       'diana.karimova@example.edu',       18, 'MED',    'Bishkek',    2025),
    ('Eldar Akhmedov',       'eldar.akhmedov@example.edu',       23, 'SBE',    'Talas',       2022),
    ('Farida Ismailova',     'farida.ismailova@example.edu',     20, 'COMSEH', 'Osh',        2024),
    ('Ruslan Niyazov',       'ruslan.niyazov@example.edu',       21, 'LAS',    'Jalal-Abad',  2023),
    ('Kamila Turdubekova',   'kamila.turdubekova@example.edu',   19, 'MED',    'Karakol',     2025),
    ('Maksat Asanov',        'maksat.asanov@example.edu',        24, 'COMSEH', 'Bishkek',    2021),
    ('Sabina Kadyrova',      'sabina.kadyrova@example.edu',      22, 'SBE',    'Naryn',       2023),
    ('Temirlan Ergeshov',    'temirlan.ergeshov@example.edu',    20, 'COMSEH', 'Talas',      2024)
ON CONFLICT (email) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    age = EXCLUDED.age,
    faculty = EXCLUDED.faculty,
    city = EXCLUDED.city,
    enrollment_year = EXCLUDED.enrollment_year;

-- Show all students.
SELECT student_id, full_name, faculty, city, enrollment_year
FROM students
ORDER BY student_id;

-- Filter COMSEH students enrolled since 2024.
SELECT full_name, age, city, enrollment_year
FROM students
WHERE faculty = 'COMSEH' AND enrollment_year >= 2024
ORDER BY full_name;

-- Count students by faculty.
SELECT faculty, COUNT(*) AS student_count
FROM students
GROUP BY faculty
ORDER BY student_count DESC, faculty;

-- Show the five youngest students.
SELECT full_name, age, faculty, city
FROM students
ORDER BY age, full_name
LIMIT 5;

-- Run the lesson's create/insert/select/drop example in a temporary table.
CREATE TEMPORARY TABLE lab03_delete_demo (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
INSERT INTO lab03_delete_demo (name, age) VALUES ('Alice', 21), ('Bob', 23);
SELECT * FROM pg_temp.lab03_delete_demo ORDER BY id;
DROP TABLE pg_temp.lab03_delete_demo;
