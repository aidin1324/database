-- Inspect the library schema created in Lab 9.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'lab09' AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT table_name, ordinal_position, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'lab09' AND table_name IN ('books', 'book_authors', 'members', 'loans')
ORDER BY table_name, ordinal_position;

SELECT c.conrelid::regclass AS table_name, c.conname AS constraint_name,
       pg_get_constraintdef(c.oid) AS definition
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
WHERE n.nspname = 'lab09' AND c.contype IN ('p', 'f', 'u', 'c')
ORDER BY table_name, constraint_name;
