# Lab 4: First SQL query

I used the 12 students from Lab 3. SQL keywords use uppercase; table and column names use `snake_case`.

```bash
psql -X -a -v ON_ERROR_STOP=1 -U aidin -d lab03 -f lab-04/lab04.sql
```

| Query | Result |
| --- | --- |
| `SELECT *` | All fields, 12 rows |
| `SELECT full_name, email ... ORDER BY full_name ASC` | Two columns, alphabetically sorted |
| `SELECT student_id, faculty` | Two fields from each record |
| `WHERE full_name = 'Nurai Sadykova'` | 1 row |
| `WHERE faculty = 'COMSEH'` | 5 rows |
| `ORDER BY full_name DESC` | Reverse alphabetical order |
| `ORDER BY student_id LIMIT 2` | First 2 records |
| `ORDER BY age, full_name LIMIT 5` | 5 youngest students |

Each result row is a record; each column is a selected field. The lesson's `ORDER BY;` needs a column, such as `ORDER BY full_name`. Sorting before `LIMIT` makes the chosen rows predictable when the sort keys distinguish them. The script includes `--` and `/* ... */` comments.

![SELECT results](screenshots/01-first-query.png)

![Filtering, sorting and limiting](screenshots/02-filter-sort-limit.png)

[SQL](lab04.sql) · [Full session](outputs/psql-session.txt) · [Course document](https://drive.google.com/file/d/10qSdz8lve4SAzF0mLsQW1yG2oGQPK1aX/view)
