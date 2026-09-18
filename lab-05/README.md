# Lab 5: Databases

I created `lab05`, listed it and switched to it. I practiced `DROP DATABASE` using a separate disposable database.

```bash
psql -X -a -v ON_ERROR_STOP=1 -h 127.0.0.1 -p 5432 -U aidin -d postgres -f lab-05/lab05.sql
```

## Create and switch

The basic SQL command is `CREATE DATABASE lab05;`. [lab05.sql](lab05.sql) checks whether `lab05` exists before creating it, so the script can run again.

```text
\l lab05
\c lab05
```

```sql
SELECT current_database(), current_user;
```

The result is `lab05` and `aidin`. `\c` handles the connection switch itself. I can also start a new session with `psql -d lab05 -U aidin`.

## Drop a disposable database

The script generates a name such as `lab05_delete_demo_12345` from the connection's backend PID. In psql:

```sql
SELECT 'lab05_delete_demo_' || pg_backend_pid() AS demo_db
\gset
CREATE DATABASE :"demo_db";
DROP DATABASE :"demo_db";
```

`\gset` stores the result in a psql variable, and `:"demo_db"` quotes it as an SQL identifier. If the name already exists, `CREATE DATABASE` fails and `ON_ERROR_STOP` stops the script before deletion. A successful run creates and removes its own demo database while keeping `lab05`.

`DROP DATABASE` permanently removes its data. Run it while connected to another database, here `postgres`. It cannot run inside a transaction or while connected to the target; ordinary deletion also fails when other sessions are using that database. See [PostgreSQL's command reference](https://www.postgresql.org/docs/18/sql-dropdatabase.html).

I use short, descriptive lowercase names with underscores. `student_records` fits that convention; spaces, mixed case and reserved words such as `select` make names harder to use.

![Database command results](screenshots/01-database-commands.png)

The [full output](outputs/psql-session.txt) records the commands and connection check. Repeating the script keeps the working database and removes only the disposable one.

[Course document](https://drive.google.com/file/d/1tACFw9v3Um6sak1ZjbQzxRur91qSvJKw/view)
