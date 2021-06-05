--rezolvare dirty reads
--aceasta problema de concurenta se rezolva prin schimbarea nivelului de izolare la Read Committed
--nivelul de izolare Read Committed este nivelul dafault de izolare al tranzactiilor
BEGIN TRAN SelectClientiNume
PRINT 'Se executa tranzactia'
SELECT nume, prenume FROM Clienti WHERE nume='Adam'
COMMIT TRAN SelectClientiNume
PRINT 'Tranzactia a fost comisa'
WAITFOR DELAY '00:00:10'
SELECT nume, prenume FROM Clienti WHERE nume='Adam'

--rezolvare non-repeatable reads
--aceasta problema de concurenta se rezolva prin schimbarea nivelului de izolare la Repeatable Read
BEGIN TRAN SelectClienti
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
PRINT 'Se executa tranzactia'
SELECT * FROM Clienti
WAITFOR DELAY '00:00:10'
SELECT * FROM Clienti
COMMIT TRAN SelectClienti
PRINT 'Tranzactia a fost comisa'

--rezolvare phantom reads
--aceasta problema de concurenta se rezolva prin schimbarea nivelului de izolare la Serializable
BEGIN TRAN SelectClienti
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
PRINT 'Se executa tranzactia'
SELECT * FROM Clienti
WAITFOR DELAY '00:00:10'
SELECT * FROM Clienti
COMMIT TRAN SelectClienti
PRINT 'Tranzactia a fost comisa'

--rezolvare deadlock
--se rezolva prin setarea prioritatii la deadlock pentru ambele tranzactii
--pentru tranzactia aleasa ca victima se da redo
CREATE OR ALTER PROCEDURE uspVictimaDeadlock
AS
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN
	PRINT 'S-a pornit executia procedurii'
	DECLARE @nr INT=0;
	WHILE @nr < 4
	BEGIN
		BEGIN TRY
		BEGIN TRAN Deadlock2
		SET DEADLOCK_PRIORITY LOW
		PRINT 'Tranzactia a inceput'
		UPDATE Clienti
		SET data_nasterii='2010-01-01' WHERE nume='Cornea'
		PRINT 'S-a facut primul update'
		WAITFOR DELAY '00:00:10'
		UPDATE Carti 
		SET disp_online=1 WHERE pret>30.00
		PRINT 'S-a facut al doilea update'
		COMMIT TRAN Deadlock2
		PRINT 'Tranzactia a reusit'
		SET @nr=4
		END TRY
		BEGIN CATCH
			PRINT 'Tranzactia a fost aleasa ca victima la deadlock'
			PRINT ERROR_MESSAGE()
			IF @@TRANCOUNT = 1
				BEGIN
				SET @nr=@nr+1
				IF @nr < 4
					PRINT CONCAT('S-a incercat tranzactia de ', @nr, ' ori')
				ELSE
					PRINT 'Tranzactia a esuat. Deja s-a incecat de 4 ori tranzactia'
				END
			ROLLBACK TRAN Deadlock2
		END CATCH
	END
END

SET NOCOUNT ON
EXEC uspVictimaDeadlock
