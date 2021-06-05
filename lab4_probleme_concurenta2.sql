--dirty reads
BEGIN TRAN SchimbaPrenumeClienti
PRINT 'Se executa tranzactia'
UPDATE Clienti
SET prenume='Andrei' WHERE nume='Adam'
PRINT 'S-a facut update-ul'
WAITFOR DELAY '00:00:10'
ROLLBACK TRAN SchimbaPrenumeClienti
PRINT 'S-a facut rollback la tranzactie'

--non-repeatable reads
BEGIN TRAN SchimbaNumeClienti
PRINT 'Se executa tranzactia'
UPDATE Clienti
SET nume='Constantinescu' WHERE prenume='Gabriela'
PRINT 'S-a facut update-ul'
COMMIT TRAN SchimbaNumeClienti
PRINT 'Tranzactia a fost comisa'

--phantom reads
BEGIN TRAN AdaugaClient
PRINT 'Se executa tranzactia'
INSERT INTO Clienti(nume, prenume, data_nasterii)
VALUES('Pop', 'Ioana', '1965-10-10')
PRINT 'S-a facut insert-ul'
COMMIT TRAN AdaugaClient
PRINT 'Tranzactia a fost comisa'

--deadlock
BEGIN TRAN Deadlock2
PRINT 'Se executa tranzactia'
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
UPDATE Clienti
SET data_nasterii='2010-01-01' WHERE nume='Cornea'
PRINT 'S-a facut update-ul'
WAITFOR DELAY '00:00:10'
UPDATE Carti 
SET disp_online=1 WHERE pret>30.00
PRINT 'S-a facut update-ul'
COMMIT TRAN Deadlock2
IF @@TRANCOUNT = 0
PRINT 'Tranzactia a fost comisa'
