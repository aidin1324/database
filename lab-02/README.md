# Lab 2: Installing PostgreSQL and pgAdmin

The course gives separate installation steps for Windows, Ubuntu and macOS. I used the macOS steps with Homebrew.

## Local setup

| Component | Value |
| --- | --- |
| OS | macOS 15, Apple Silicon |
| PostgreSQL | 18.6, `postgresql@18` |
| pgAdmin | 4, version 9.17 |
| Host and port | `127.0.0.1:5432` |
| Maintenance database | `postgres` |
| Role | `aidin`, matching my macOS username |

```bash
brew install postgresql@18
brew services start postgresql@18
brew install --cask pgadmin4
psql -U aidin -d postgres
```

I set a password for the role using `ALTER USER`. The value below is a placeholder; the actual password stays outside this repository.

```sql
ALTER USER aidin WITH PASSWORD '<local password>';
```

PostgreSQL returned `ALTER ROLE`. A check of the role returned `password_set = t`. I then checked the installed versions, service and connection:

```bash
psql --version
brew list --cask --versions pgadmin4
brew services list
pg_isready -h 127.0.0.1 -p 5432
psql -h 127.0.0.1 -p 5432 -U aidin -d postgres
```

The service is `started`, and port 5432 accepts connections. The [recorded checks](outputs/setup-checks.txt) include the active database and role.

![Installed versions and running service](screenshots/01-versions-and-service.png)

## pgAdmin

I registered `Local PostgreSQL 18` under **Servers**, using the host, port, maintenance database and role above. The Object Explorer shows the connected server and its databases.

![Connected local server in pgAdmin](screenshots/02-pgadmin-connection.png)

To run SQL, I select a database, open **Tools > Query Tool**, enter a query and press `F5`. Rows appear in **Data Output**, and notices or errors appear in **Messages**. PostgreSQL stores and processes the data; pgAdmin is the graphical client.

[Course document](https://drive.google.com/file/d/1mHYboT9R0GPQhKh9muFf2Tv6AL_HQzws/view)
