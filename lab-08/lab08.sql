-- All example tables live in this lab's schema.
DROP SCHEMA IF EXISTS lab08 CASCADE;
CREATE SCHEMA lab08;

CREATE TABLE lab08.departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL UNIQUE
);
INSERT INTO lab08.departments VALUES
    (0, 'Unassigned'), (1, 'Restricted'), (2, 'Cascading'),
    (3, 'Nullable'), (4, 'Defaulted'), (5, 'Updated'), (6, 'Combined');

-- Inline, table-level, named, and ALTER TABLE foreign keys.
CREATE TABLE lab08.employee_restrict (
    emp_id INTEGER PRIMARY KEY,
    dept_id INTEGER NOT NULL REFERENCES lab08.departments(dept_id) ON DELETE RESTRICT
);
CREATE TABLE lab08.employee_cascade (
    emp_id INTEGER PRIMARY KEY,
    dept_id INTEGER NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES lab08.departments(dept_id) ON DELETE CASCADE
);
CREATE TABLE lab08.employee_set_null (
    emp_id INTEGER PRIMARY KEY,
    dept_id INTEGER,
    CONSTRAINT fk_nullable_department FOREIGN KEY (dept_id)
        REFERENCES lab08.departments(dept_id) ON DELETE SET NULL
);
CREATE TABLE lab08.employee_set_default (
    emp_id INTEGER PRIMARY KEY,
    dept_id INTEGER NOT NULL DEFAULT 0
);
ALTER TABLE lab08.employee_set_default
    ADD CONSTRAINT fk_default_department FOREIGN KEY (dept_id)
    REFERENCES lab08.departments(dept_id) ON DELETE SET DEFAULT;
CREATE TABLE lab08.employee_update_cascade (
    emp_id INTEGER PRIMARY KEY,
    dept_id INTEGER NOT NULL REFERENCES lab08.departments(dept_id) ON UPDATE CASCADE
);
CREATE TABLE lab08.employee_combined (
    emp_id INTEGER PRIMARY KEY,
    dept_id INTEGER NOT NULL REFERENCES lab08.departments(dept_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO lab08.employee_restrict VALUES (1, 1);
INSERT INTO lab08.employee_cascade VALUES (2, 2);
INSERT INTO lab08.employee_set_null VALUES (3, 3);
INSERT INTO lab08.employee_set_default VALUES (4, 4);
INSERT INTO lab08.employee_update_cascade VALUES (5, 5);
INSERT INTO lab08.employee_combined VALUES (6, 6);

DO $$
BEGIN
    BEGIN
        INSERT INTO lab08.employee_restrict VALUES (99, 99);
        RAISE EXCEPTION 'Unknown department was accepted on INSERT';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'INSERT rejected an unknown department';
    END;
    BEGIN
        UPDATE lab08.employee_restrict SET dept_id = 99 WHERE emp_id = 1;
        RAISE EXCEPTION 'Unknown department was accepted on UPDATE';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'UPDATE rejected an unknown department';
    END;
    BEGIN
        DELETE FROM lab08.departments WHERE dept_id = 1;
        RAISE EXCEPTION 'Referenced department was deleted';
    EXCEPTION WHEN restrict_violation OR foreign_key_violation THEN
        RAISE NOTICE 'RESTRICT kept a referenced department';
    END;
END $$;

DELETE FROM lab08.departments WHERE dept_id IN (2, 3, 4);
UPDATE lab08.departments SET dept_id = 50 WHERE dept_id = 5;
SELECT 'CASCADE' AS action, COUNT(*) AS children FROM lab08.employee_cascade
UNION ALL SELECT 'SET NULL', COUNT(*) FROM lab08.employee_set_null WHERE dept_id IS NULL
UNION ALL SELECT 'SET DEFAULT', COUNT(*) FROM lab08.employee_set_default WHERE dept_id = 0
UNION ALL SELECT 'ON UPDATE CASCADE', COUNT(*) FROM lab08.employee_update_cascade WHERE dept_id = 50;

UPDATE lab08.departments SET dept_id = 60 WHERE dept_id = 6;
SELECT emp_id, dept_id FROM lab08.employee_combined;
DELETE FROM lab08.departments WHERE dept_id = 60;
SELECT COUNT(*) AS combined_cascade_rows_after_delete FROM lab08.employee_combined;

-- One-to-one: either share the primary key or make a separate foreign key UNIQUE.
CREATE TABLE lab08.users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username TEXT NOT NULL UNIQUE
);
CREATE TABLE lab08.user_profiles (
    user_id INTEGER PRIMARY KEY REFERENCES lab08.users(user_id) ON DELETE CASCADE,
    bio TEXT
);
CREATE TABLE lab08.user_profiles_unique (
    profile_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE REFERENCES lab08.users(user_id) ON DELETE CASCADE,
    bio TEXT
);
INSERT INTO lab08.users (username) VALUES ('nurai'), ('alikhan');
INSERT INTO lab08.user_profiles VALUES (1, 'Student profile');
INSERT INTO lab08.user_profiles_unique (user_id, bio) VALUES (1, 'Student profile');
DO $$
BEGIN
    BEGIN
        INSERT INTO lab08.user_profiles VALUES (1, 'Second profile');
        RAISE EXCEPTION 'Shared primary key accepted a second profile';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'One-to-one key rejected a second profile';
    END;
    BEGIN
        INSERT INTO lab08.user_profiles_unique (user_id, bio) VALUES (1, 'Second profile');
        RAISE EXCEPTION 'UNIQUE foreign key accepted a second profile';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'UNIQUE foreign key rejected a second profile';
    END;
END $$;
SELECT u.username, p.bio AS shared_key_profile, q.bio AS unique_fk_profile
FROM lab08.users u
LEFT JOIN lab08.user_profiles p USING (user_id)
LEFT JOIN lab08.user_profiles_unique q USING (user_id)
ORDER BY u.user_id;

-- One post can have many comments; deleting it also deletes its comments.
CREATE TABLE lab08.blog_posts (post_id INTEGER PRIMARY KEY, title TEXT NOT NULL);
CREATE TABLE lab08.comments (
    comment_id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES lab08.blog_posts(post_id) ON DELETE CASCADE,
    comment_text TEXT NOT NULL
);
INSERT INTO lab08.blog_posts VALUES (1, 'Learning foreign keys');
INSERT INTO lab08.comments VALUES (1, 1, 'First comment'), (2, 1, 'Second comment');
SELECT p.title, c.comment_text
FROM lab08.blog_posts p JOIN lab08.comments c USING (post_id)
ORDER BY c.comment_id;

-- One instructor teaches many courses; students and courses are many-to-many.
CREATE TABLE lab08.instructors (
    instructor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL
);
CREATE TABLE lab08.courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_code VARCHAR(12) NOT NULL UNIQUE,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL CHECK (credits > 0),
    instructor_id INTEGER NOT NULL REFERENCES lab08.instructors(instructor_id)
);
CREATE TABLE lab08.students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);
CREATE TABLE lab08.enrollments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade VARCHAR(2),
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES lab08.students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES lab08.courses(course_id) ON DELETE CASCADE
);
INSERT INTO lab08.instructors (full_name) VALUES ('Dr. Brown');
INSERT INTO lab08.courses (course_code, title, credits, instructor_id) VALUES
    ('CS101', 'Introduction to Programming', 3, 1),
    ('DB201', 'Databases', 4, 1);
INSERT INTO lab08.students (full_name, email) VALUES
    ('Nurai Sadykova', 'nurai@example.edu'),
    ('Alikhan Omarov', 'alikhan@example.edu');
INSERT INTO lab08.enrollments (student_id, course_id, grade) VALUES
    (1, 1, 'A'), (1, 2, 'B+'), (2, 2, 'A-');
DO $$
BEGIN
    BEGIN
        INSERT INTO lab08.enrollments (student_id, course_id, grade) VALUES (1, 1, 'B');
        RAISE EXCEPTION 'Duplicate enrollment was accepted';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'Junction table rejected a duplicate enrollment';
    END;
END $$;

SELECT i.full_name AS instructor, c.course_code, c.title
FROM lab08.instructors i JOIN lab08.courses c USING (instructor_id)
ORDER BY c.course_code;
SELECT s.full_name AS student, c.course_code, c.title, e.grade, e.enrollment_date
FROM lab08.enrollments e
JOIN lab08.students s USING (student_id)
JOIN lab08.courses c USING (course_id)
ORDER BY s.full_name, c.course_code;

-- Students in one course.
SELECT s.full_name AS student, e.grade
FROM lab08.students s
JOIN lab08.enrollments e USING (student_id)
JOIN lab08.courses c USING (course_id)
WHERE c.course_code = 'DB201'
ORDER BY s.full_name;

-- Courses taken by one student.
SELECT c.course_code, c.title, c.credits, e.grade
FROM lab08.courses c
JOIN lab08.enrollments e USING (course_id)
JOIN lab08.students s USING (student_id)
WHERE s.email = 'nurai@example.edu'
ORDER BY c.course_code;
