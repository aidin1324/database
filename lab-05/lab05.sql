\set ON_ERROR_STOP on

-- Laboratory Work 5: Databases
-- Run this file while connected to the postgres database.

-- Create lab05 only when it does not exist.
SELECT 'CREATE DATABASE lab05'
WHERE NOT EXISTS (
    SELECT 1 FROM pg_database WHERE datname = 'lab05'
)
\gexec

-- Each connection has a different backend PID. Stop if this name already exists.
SELECT 'lab05_delete_demo_' || pg_backend_pid() AS demo_db
\gset
CREATE DATABASE :"demo_db";
DROP DATABASE :"demo_db";

-- Show the database and switch to it.
\l lab05
\connect lab05

SELECT current_database() AS current_database,
       current_user AS current_user;
