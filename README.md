# creating-database

These are some files containing work I did in Microsoft SQL Server Management Studio. I created a database named Cartis, populated it, created some queries, functions, stored procedures, views, triggers and transactions. In the files prefixed with 'lab4' I created some concurrency problems (dirty reads, unrepeatable reads, phantom reads and deadlock) and also provided solutions for them. By resolving the deadlock, I mean making sure that the transaction that fails (because it's a deadlock victim) is eventually executed.

The database if for a bookstore with a delivery system. It contains the following main tables: Books, Authors, Clients, Addresses, Orders, Stores and Vouchers. All table and column names are in Romanian.

![diagrama](https://user-images.githubusercontent.com/62253444/120895487-c66c2d80-c625-11eb-96d9-59c78e81b2a8.png)


