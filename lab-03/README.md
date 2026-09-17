# Lab 3: Basic psql commands

I connected with `psql`, inspected the database and created a table with 12 fictional students. I also ran the lesson's create, insert, select and drop example in a temporary table.

## Run

From the repository root:

```bash
psql -X -U aidin -d postgres -f lab-03/create-database.sql
psql -X -a -v ON_ERROR_STOP=1 -h 127.0.0.1 -p 5432 -U aidin -d lab03 -f lab-03/psql-demo.sql
```

`-h` selects the host, `-p` the port, `-U` the role and `-d` the database. On my local setup, `psql -d lab03` also works because the default role matches my OS username.

## Commands practiced

| Command | Result |
| --- | --- |
| `\l` | List databases |
| `\c lab03` | Switch to `lab03` |
| `\dt` | List tables |
| `\d students` | Show columns, indexes and constraints |
| `\h SELECT` | Display SQL help for `SELECT` |
| `\?` | Display psql command help |
| `\q` | Exit psql |

These commands start with a backslash. SQL statements end with a semicolon. [psql-demo.sql](psql-demo.sql) runs every command above; [lab03.sql](lab03.sql) contains the SQL and also works in pgAdmin Query Tool.

![Table list and students structure](screenshots/01-psql-structure.png)

## Table and results

`students` has an identity primary key, required names and fields, unique emails, an age check of 16 to 100 and an enrollment-year check of 2000 to 2100. Its columns are `student_id`, `full_name`, `email`, `age`, `faculty`, `city` and `enrollment_year`.

The 12 students use fictional names and `example.edu` emails. `ON CONFLICT (email) DO UPDATE` lets me rerun the inserts while keeping one row per sample email.

| Query | Result |
| --- | --- |
| All sample students | 12 rows |
| COMSEH students enrolled since 2024 | Farida Ismailova, Nurai Sadykova and Temirlan Ergeshov |
| Students per faculty | COMSEH 5, SBE 3, LAS 2, MED 2 |
| Five youngest, sorted by age then name | Diana, Kamila, Nurai, Aelita and Farida |

`WHERE` filters records. `GROUP BY` groups them for `COUNT(*)`. `ORDER BY` sorts the result, and `LIMIT` caps its size.

![Query results](screenshots/02-query-results.png)

## Creating and dropping a table

The lesson's two sample rows are Alice, age 21, and Bob, age 23:

```sql
CREATE TEMPORARY TABLE lab03_delete_demo (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
INSERT INTO lab03_delete_demo (name, age) VALUES ('Alice', 21), ('Bob', 23);
SELECT * FROM pg_temp.lab03_delete_demo ORDER BY id;
DROP TABLE pg_temp.lab03_delete_demo;
```

The query returns two rows. `DROP TABLE` then removes this session's temporary table. Qualifying it with `pg_temp` prevents dropping a permanent table with the same name.

![Create, insert, select and drop results](screenshots/03-table-lifecycle.png)

The [full session](outputs/psql-session.txt) includes SQL help, psql help, every query and the final `\q`. I can inspect a table, read query results and remove a disposable table after using it.

[Course document](https://drive.google.com/file/d/1jPfbRCXJYQPcMFPMhifz3LVRFjCeswUB/view)
