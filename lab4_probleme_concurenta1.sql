--dirty reads
--cele 2 SELECT-uri vor da rezultate diferite intrucat tranzactia citeste date care nu au fost inca comise bazei de date
BEGIN TRAN SelectClientiNume
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
PRINT 'Se executa tranzactia'
SELECT nume, prenume FROM Clienti WHERE nume='Adam'
COMMIT TRAN SelectClientiNume
PRINT 'Tranzactia a fost comisa'
WAITFOR DELAY '00:00:10'
SELECT nume, prenume FROM Clienti WHERE nume='Adam'

--non-repeatable reads
--cele 2 SELECT-uri vor da rezultate diferite intrucat intre ele s-a comis o alta tranzactie ce a adus schimbari la nivelul tabelului
BEGIN TRAN SelectClienti
PRINT 'Se executa tranzactia'
SELECT * FROM Clienti
WAITFOR DELAY '00:00:10'
SELECT * FROM Clienti
COMMIT TRAN SelectClienti
PRINT 'Tranzactia a fost comisa'

--phantom reads
--cele 2 SELECT-uri vor da rezultate diferite intrucat intre ele s-a comis o alta tranzactie ce a adus adaugari/stergeri la nivelul tabelului
BEGIN TRAN SelectClienti
PRINT 'Se executa tranzactia'
SELECT * FROM Clienti
WAITFOR DELAY '00:00:10'
SELECT * FROM Clienti
COMMIT TRAN SelectClienti
PRINT 'Tranzactia a fost comisa'

--deadlock
--cele 2 tranzactii vor intra in deadlock intrucat ambele asteapta sa acceseze resure blocate de cealalta tranzactie
BEGIN TRAN Deadlock1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET DEADLOCK_PRIORITY HIGH
PRINT 'Se executa tranzactia'
UPDATE Carti 
SET disp_online=1 WHERE pret>50.00
PRINT 'S-a facut update-ul'
UPDATE Clienti
SET data_nasterii='2000-01-01' WHERE nume='Cornea'
PRINT 'S-a facut update-ul'
COMMIT TRAN Deadlock1
PRINT 'Tranzactia a fost comisa'

--refacere tabele la starea lor initiala dupa efectuarea celor 2 tranzactii Deadlock1 si Deadlock2
UPDATE Clienti
SET data_nasterii='2001-06-28' WHERE nume='Cornea'
UPDATE Carti 
SET disp_online=0 WHERE pret>30.00

SELECT * FROM Clienti
SELECT * FROM Carti
