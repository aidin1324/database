# Database labs

Database labs 1 to 15, using the [course documents](https://drive.google.com/drive/folders/1xWdXTM-DHS33Xp8yfGxYs5w5pu1XZqEf).

## Environment

macOS 15 on Apple Silicon, PostgreSQL 18.6 from Homebrew and pgAdmin 4 version 9.17. The server is at `127.0.0.1:5432`, with role `aidin`.

## Labs

- [Lab 1: Introduction to relational databases](lab-01/README.md)
- [Lab 2: Installing PostgreSQL and pgAdmin](lab-02/README.md)
- [Lab 3: Basic psql commands](lab-03/README.md)
- [Lab 4: First SQL query](lab-04/README.md)
- [Lab 5: Databases](lab-05/README.md)
- [Lab 6: Tables and constraints](lab-06/README.md)
- [Lab 7: Primary keys](lab-07/README.md)
- [Lab 8: Foreign keys and relationships](lab-08/README.md)
- [Lab 9: Database design basics](lab-09/README.md)
- [Lab 10: Viewing database and table structure](lab-10/README.md)
- [Lab 11: Basic data operations](lab-11/README.md)
- [Lab 12: Querying data](lab-12/README.md)
- [Lab 13: Aggregate functions](lab-13/README.md)
- [Lab 14: Joining tables](lab-14/README.md)
- [Lab 15: Advanced querying](lab-15/README.md)

## Run the SQL

Run these in psql from the repository root after Lab 2. In pgAdmin's Query Tool, execute complete SQL statements. Backslash commands require psql; Lab 11's CSV import and bulk changes are in `psql-demo.sql`.

```bash
psql -X -U aidin -d postgres -f lab-03/create-database.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d lab03 -f lab-03/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d lab03 -f lab-04/lab04.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-05/lab05.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-06/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-07/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-08/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-09/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-10/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-11/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-12/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-13/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-14/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d postgres -f lab-15/psql-demo.sql
```

Labs 3 and 4 use the same 12 fictional students. Lab 3 drops only a temporary example table. Lab 5 creates and removes a separate demo database. Labs 6 to 9 and 11 to 15 reset their own demo schema in `postgres`. Lab 10 inspects the schema from Lab 9.

Each practical lab has a run log. Images show pgAdmin results or saved psql output. Labs 9 to 15 include unedited captures from local pgAdmin; Lab 10 also shows its ER diagram.

## Document

- [Employment certificate](documents/Справка%20с%20работы.pdf)
