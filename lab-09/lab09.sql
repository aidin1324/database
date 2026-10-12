-- Small library model. Rerunning resets only lab09.
DROP SCHEMA IF EXISTS lab09 CASCADE;
CREATE SCHEMA lab09;

CREATE TABLE lab09.authors (
    author_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);
CREATE TABLE lab09.books (
    book_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    publication_year INTEGER CHECK (publication_year BETWEEN 1450 AND 2100),
    available_copies INTEGER NOT NULL DEFAULT 1 CHECK (available_copies >= 0)
);
CREATE TABLE lab09.book_authors (
    book_id INTEGER NOT NULL REFERENCES lab09.books(book_id),
    author_id INTEGER NOT NULL REFERENCES lab09.authors(author_id),
    PRIMARY KEY (book_id, author_id)
);
CREATE TABLE lab09.membership_tiers (
    tier_id INTEGER PRIMARY KEY,
    tier_name VARCHAR(30) NOT NULL UNIQUE
);
CREATE TABLE lab09.members (
    member_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    tier_id INTEGER NOT NULL REFERENCES lab09.membership_tiers(tier_id),
    membership_date DATE NOT NULL DEFAULT CURRENT_DATE
);
-- Phone numbers get separate rows instead of a comma-separated list.
CREATE TABLE lab09.member_phones (
    member_id INTEGER NOT NULL REFERENCES lab09.members(member_id) ON DELETE CASCADE,
    phone_number VARCHAR(20) NOT NULL,
    phone_type VARCHAR(20) NOT NULL CHECK (phone_type IN ('mobile', 'home')),
    PRIMARY KEY (member_id, phone_number)
);
CREATE TABLE lab09.loans (
    loan_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES lab09.members(member_id),
    book_id INTEGER NOT NULL REFERENCES lab09.books(book_id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (late_fee >= 0),
    CONSTRAINT valid_loan_dates CHECK (due_date >= loan_date AND (return_date IS NULL OR return_date >= loan_date))
);

INSERT INTO lab09.authors (first_name, last_name) VALUES
    ('George', 'Orwell'), ('Aldous', 'Huxley'),
    ('Neil', 'Gaiman'), ('Terry', 'Pratchett');
INSERT INTO lab09.books (title, isbn, publication_year, available_copies) VALUES
    ('Nineteen Eighty-Four', '9780451524935', 1949, 3),
    ('Brave New World', '9780060850524', 1932, 2),
    ('Good Omens', '9780060853983', 1990, 1);
INSERT INTO lab09.book_authors VALUES (1, 1), (2, 2), (3, 3), (3, 4);
INSERT INTO lab09.membership_tiers VALUES (1, 'Standard'), (2, 'Student');
INSERT INTO lab09.members (first_name, last_name, email, tier_id) VALUES
    ('Nurai', 'Sadykova', 'nurai@example.edu', 2),
    ('Alikhan', 'Omarov', 'alikhan@example.edu', 1);
INSERT INTO lab09.member_phones VALUES
    (1, '+996700111222', 'mobile'),
    (1, '+996312555777', 'home');
INSERT INTO lab09.loans (member_id, book_id, loan_date, due_date, return_date, late_fee) VALUES
    (1, 1, DATE '2026-10-01', DATE '2026-10-15', NULL, 0),
    (2, 2, DATE '2026-10-01', DATE '2026-10-04', DATE '2026-10-06', 10.00);

SELECT b.title, a.first_name || ' ' || a.last_name AS author
FROM lab09.books b
JOIN lab09.book_authors ba USING (book_id)
JOIN lab09.authors a USING (author_id)
ORDER BY b.title;
SELECT m.first_name || ' ' || m.last_name AS member, t.tier_name, b.title,
       l.loan_date, l.due_date, l.return_date, l.late_fee
FROM lab09.loans l
JOIN lab09.members m USING (member_id)
JOIN lab09.membership_tiers t USING (tier_id)
JOIN lab09.books b USING (book_id)
ORDER BY l.loan_id;
SELECT m.email, p.phone_number, p.phone_type
FROM lab09.members m JOIN lab09.member_phones p USING (member_id)
ORDER BY p.phone_type;
