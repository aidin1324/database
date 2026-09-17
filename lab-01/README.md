# Lab 1: Introduction to relational databases

A database stores organized data. A DBMS, such as PostgreSQL, manages it. CRUD means create, read, update and delete. SQL is the language used to request and change data in a relational database.

## Tables and relationships

| Term | Meaning and example |
| --- | --- |
| Table | A set of records, such as `students` |
| Row | One student |
| Column | A field, such as `email` |
| Primary key | A unique, non-null identifier for each row |
| Foreign key | A reference to a unique key in a related table |
| Schema | The structure of tables, columns and relationships; PostgreSQL also uses named schemas to organize objects |
| Query | A request written in SQL |
| Index | A structure that can speed up searches, at the cost of storage and write work |
| Normalization | Separating repeated facts into related tables to reduce duplication and update errors |

One student can have one profile (one-to-one). One faculty can have many students (one-to-many). Students can take many courses, and each course can have many students (many-to-many). An `enrollments` table with student and course foreign keys represents that last relationship.

## SQL and NoSQL

| Aspect | Relational databases | NoSQL databases |
| --- | --- | --- |
| Data | Tables with declared columns and types | Documents, key-value pairs, wide-column records or graphs |
| Queries | SQL, with differences between DBMSs | Product-specific APIs or query languages |
| Scaling | More server capacity; replication and distributed designs are also possible | Many systems distribute data across several servers |
| Transactions and consistency | ACID transactions, subject to isolation and replication settings | Guarantees vary; some provide transactions and strong consistency, others favor eventual consistency |

Document stores such as MongoDB hold nested records. Redis is a key-value store. Cassandra uses a wide-column model, which differs from an analytical columnar database. Neo4j stores nodes and edges for graph queries.

BASE means Basically Available, Soft state and Eventual consistency. In such a design, replicas may temporarily disagree and converge later. ACID and BASE describe different guarantees; the label "NoSQL" alone does not determine them.

I would choose SQL for course enrollments or payments because relationships and transaction rules matter. A document store can fit changing record structures. Distributed NoSQL systems can fit large datasets or geographically spread workloads, depending on the required consistency and query patterns.

## ACID

| Property | Meaning |
| --- | --- |
| Atomicity | All operations in a transaction succeed together, or they roll back |
| Consistency | A successful transaction respects the database's rules and constraints |
| Isolation | Concurrent transactions follow the guarantees of the selected isolation level |
| Durability | Committed changes survive a server failure under the configured durability guarantees |

A money transfer is a useful example: subtracting from one account and adding to another belong in the same transaction.

## PostgreSQL and other DBMSs

POSTGRES began at Berkeley in 1986. SQL support was added in 1994; the PostgreSQL name followed in 1996. See the [project history](https://www.postgresql.org/docs/18/history.html).

PostgreSQL is open source and supports transactions, constraints, JSON/JSONB, XML, custom types, indexes and extensions. Functions and procedures can use PL/pgSQL; other procedural languages need their respective extensions. Replication supports standby servers, while distributed sharding requires additional design or tools. The project has a community that maintains releases and documentation.

| DBMS | Typical fit and tradeoff |
| --- | --- |
| PostgreSQL | A server with extensive SQL and extension support; it needs server administration |
| MySQL | A server commonly used by web applications; supported SQL features differ from PostgreSQL |
| SQLite | An embedded database in a file; convenient for local apps, with different concurrency limits from a database server |
| Oracle Database | A server used for enterprise transactions and analytics; commercial editions involve licensing costs |

For these labs, PostgreSQL lets me practice SQL, table relationships and constraints on my own computer.

[Course document](https://drive.google.com/file/d/1cBOWJijltzRnv3gMqgB5YpzooXFgAG_y/view)
