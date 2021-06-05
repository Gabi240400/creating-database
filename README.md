# creating-database

These are some files containing work I did in Microsoft SQL Server Management Studio. I created a database, populated it, created some queries, functions, stored procedures, views and triggers. In the files prefixed with 'lab4' I created some concurrency problems (dirty reads, unrepeatable reads, phantom reads and deadlock) and also provided solutions for them. By resolving the deadlock, I mean making sure that the transaction that fails (because it's a deadlock victim) is eventually executed.
