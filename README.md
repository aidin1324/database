# Database labs

Database labs 1 to 4, using the [course documents](https://drive.google.com/drive/folders/1xWdXTM-DHS33Xp8yfGxYs5w5pu1XZqEf).

## Environment

macOS 15 on Apple Silicon, PostgreSQL 18.6 from Homebrew and pgAdmin 4 version 9.17. The server is at `127.0.0.1:5432`, with role `aidin`.

## Labs

- [Lab 1: Introduction to relational databases](lab-01/README.md)
- [Lab 2: Installing PostgreSQL and pgAdmin](lab-02/README.md)
- [Lab 3: Basic psql commands](lab-03/README.md)
- [Lab 4: First SQL query](lab-04/README.md)

## Run the SQL

Run these from the repository root after completing the installation in Lab 2:

```bash
psql -X -U aidin -d postgres -f lab-03/create-database.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d lab03 -f lab-03/psql-demo.sql
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d lab03 -f lab-04/lab04.sql
```

Labs 3 and 4 use the same 12 fictional students. Lab 3 drops only a temporary example table.

Each practical lab has a saved command log. Terminal images display excerpts from those logs on a dark background. The pgAdmin image shows the application itself.

## Document

- [Employment certificate](documents/Справка%20с%20работы.pdf)
