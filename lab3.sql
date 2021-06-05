USE Cartis;

--Validarea campurilor din tabelul Carti
CREATE OR ALTER FUNCTION ufValidareCarte
(@titlu VARCHAR(100), @an_publicatie INT, @editura VARCHAR(30), @categorie VARCHAR(30), @disp_online BIT, @pret FLOAT)
RETURNS BIT AS
BEGIN
DECLARE @ok BIT=1
IF (@an_publicatie > YEAR(GETDATE()))
	SET @ok=0
IF (@pret <=0)
	SET @ok=0
IF (ISNULL(@titlu,'.')='.')
	SET @ok=0
IF (ISNULL(@editura,'.')='.')
	SET @ok=0
RETURN @ok
END;

--Verificarea functiei dbo.ufValidareCarte
PRINT dbo.ufValidareCarte('Baltagul', 1930, 'Editura Cartea Romaneasca', 'Roman social', 1, 19.5);  --1 (param corecti)
PRINT dbo.ufValidareCarte('Baltagul', 2030, 'Editura Cartea Romaneasca', 'Roman social', 1, 19.5);  --0 (an publicatie)
PRINT dbo.ufValidareCarte('Baltagul', 1930, 'Editura Cartea Romaneasca', 'Roman social', 1, -19.5); --0 (pret)
PRINT dbo.ufValidareCarte(NULL, 1930, 'Editura Cartea Romaneasca', 'Roman social', 1, 19.5);        --0 (titlu)

--Validarea campurilor din tabelul Autori
CREATE OR ALTER FUNCTION ufValidareAutor
(@nume_complet VARCHAR(50), @tara_origine VARCHAR(30), @data_nasterii DATE)
RETURNS BIT AS
BEGIN
DECLARE @ok BIT=1
IF (ISNULL(@nume_complet, '.')='.')
	SET @ok=0
IF(@data_nasterii > GETDATE())
	SET @ok=0
RETURN @ok
END;

--Verificarea functiei dbo.ufValidareAutor
PRINT dbo.ufValidareAutor('Mihail Sadoveanu', 'Romania', '1880-11-05'); --1 (param corecti)
PRINT dbo.ufValidareAutor(NULL, 'Romania', '1880-11-05');               --0 (nume autor)
PRINT dbo.ufValidareAutor('Mihail Sadoveanu', 'Romania', '2080-11-05'); --0 (data nasterii)

--Adaugare enitati in tabelele Carti si Autori
CREATE OR ALTER PROCEDURE uspAdaugaCarteCuAutor
(@titlu VARCHAR(100), @an_publicatie INT, @editura VARCHAR(30), @categorie VARCHAR(30), @disp_online BIT, @pret FLOAT, @nume_complet VARCHAR(50), @tara_origine VARCHAR(30), @data_nasterii DATE)
AS
BEGIN
	PRINT 'Se executa procedura uspAdaugaCarteCuAutor...'
	BEGIN TRY
		BEGIN TRAN Adauga;
		PRINT 'Incepe tranzactia Adauga...'
		DECLARE @id_carte INT
		DECLARE @id_autor INT
		IF (dbo.ufValidareCarte(@titlu, @an_publicatie, @editura, @categorie, @disp_online, @pret) = 1)
			BEGIN
			INSERT INTO Carti(titlu, an_publicatie, editura, categorie, disp_online, pret)
			VALUES(@titlu, @an_publicatie, @editura, @categorie, @disp_online, @pret)
			SET @id_carte = SCOPE_IDENTITY()
			PRINT 'S-a adaugat o entitate in tabelul Carti...'
			END
		ELSE
			BEGIN
			PRINT 'Nu s-a putut adauga cartea...'
			RAISERROR('Una dintre valorile introduse nu este valida',16,1)
			END

		IF (dbo.ufValidareAutor(@nume_complet, @tara_origine, @data_nasterii) = 1)
			BEGIN
			INSERT INTO Autori(nume_complet, tara_origine, data_nasterii)
			VALUES(@nume_complet, @tara_origine, @data_nasterii)
			SET @id_autor = SCOPE_IDENTITY()
			PRINT 'S-a adaugat o entitate in tabelul Autori...'
			END
		ELSE
			BEGIN
			PRINT 'Nu s-a putut adauga autorul...'
			RAISERROR('Una dintre valorile introduse nu este valida',16,1)
			END

		INSERT INTO CartiAutori(id_carte, id_autor)
		VALUES(@id_carte, @id_autor)
		PRINT 'S-a adaugat o entitate in tabelul de legatura CartiAutori...'

		COMMIT TRAN Adauga;
		PRINT 'Tranzactia s-a terminat cu succes...'
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN Adauga;
		PRINT 'S-a facut rollback la tranzactia Adauga...'
	END CATCH
	PRINT 'S-a incheiat executia procedurii uspAdaugaCarteCuAutor.'
END;

SET NOCOUNT ON;
--executat (tranzactie finalizata cu succes)
EXEC uspAdaugaCarteCuAutor 'Pupaza din Mortii Tei', 2018, 'Editura Vaslui', 'Umor', 1, 38.5, 'Gabriel Dumitriu', 'Romania', '2983-10-19';
--executat (eroare din cauza datei de nastere)
EXEC uspAdaugaCarteCuAutor 'Pupaza din Mortii Tei', 2018, 'Editura Vaslui', 'Umor', 1, 38.5, 'Gabriel Dumitriu', 'Romania', '2056-10-19';
--executat (tranzactie finalizata cu succes)
EXEC uspAdaugaCarteCuAutor 'Baltagul', 1930, 'Editura Cartea Romaneasca', 'Roman social', 1, 19.5, 'Mihail Sadoveanu', 'Romania', '1880-11-05';
--trebuie executat

SELECT * FROM Carti;
SELECT * FROM Autori;
SELECT * FROM CartiAutori;


CREATE OR ALTER PROCEDURE uspAdaugaCarteCuAutorTranzactiiSeparate
(@titlu VARCHAR(100), @an_publicatie INT, @editura VARCHAR(30), @categorie VARCHAR(30), @disp_online BIT, @pret FLOAT, @nume_complet VARCHAR(50), @tara_origine VARCHAR(30), @data_nasterii DATE)
AS
BEGIN 
	PRINT 'Se executa procedura uspAdaugaCarteCuAutorTranzactiiSeparate...'
	DECLARE @id_carte INT
	DECLARE @id_autor INT
	DECLARE @carte_adaugata INT=0
	DECLARE @autor_adaugat INT=0

	BEGIN TRAN AdaugaCarte
	PRINT 'Incepe tranzactia AdaugaCarte...'
	BEGIN TRY
		IF (dbo.ufValidareCarte(@titlu, @an_publicatie, @editura, @categorie, @disp_online, @pret) = 1)
			BEGIN
			INSERT INTO Carti(titlu, an_publicatie, editura, categorie, disp_online, pret)
			VALUES(@titlu, @an_publicatie, @editura, @categorie, @disp_online, @pret)
			SET @id_carte = SCOPE_IDENTITY()
			SET @carte_adaugata=1
			PRINT 'S-a adaugat o entitate in tabelul Carti...'
			PRINT 'Tranzactia AdaugaCarte s-a terminat cu succes...'
			END
		ELSE
			RAISERROR('Una dintre valorile introduse nu este valida',16,1)
		COMMIT TRAN AdaugaCarte
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN AdaugaCarte
		PRINT 'S-a facut rollback la tranzactia AdaugaCarte...'
	END CATCH

	BEGIN TRAN AdaugaAutor
	PRINT 'Incepe tranzactia AdaugaAutor...'
	BEGIN TRY
		IF (dbo.ufValidareAutor(@nume_complet, @tara_origine, @data_nasterii) = 1)
			BEGIN
			INSERT INTO Autori(nume_complet, tara_origine, data_nasterii)
			VALUES(@nume_complet, @tara_origine, @data_nasterii)
			SET @id_autor = SCOPE_IDENTITY()
			SET @autor_adaugat=1
			PRINT 'S-a adaugat o entitate in tabelul Autori...'
			PRINT 'Tranzactia AdaugaAutor s-a terminat cu succes...'
			END
		ELSE
			RAISERROR('Una dintre valorile introduse nu este valida',16,1)
		COMMIT TRAN AdaugaAutor
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN AdaugaAutor
		PRINT 'S-a facut rollback la tranzactia AdaugaAutor...'
	END CATCH

	BEGIN TRAN AdaugaCarteSiAutor
	PRINT 'Incepe tranzactia AdaugaCarteSiAutor...'
	BEGIN TRY
		IF(@carte_adaugata=1 AND @autor_adaugat=1)
			BEGIN
			INSERT INTO CartiAutori(id_carte, id_autor)
			VALUES(@id_carte, @id_autor)
			PRINT 'S-a adaugat o entitate in tabelul de legatura CartiAutori...'
			PRINT 'Tranzactia AdaugaCarteSiAutor s-a terminat cu succes...'
			END
		ELSE
			RAISERROR('Una dintre valorile introduse nu este valida',16,1)
		COMMIT TRAN AdaugaCarteSiAutor
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN AdaugaCarteSiAutor
		PRINT 'S-a facut rollback la tranzactia AdaugaCarteSiAutor...'
	END CATCH

	PRINT 'Se opreste executia procedurii uspAdaugaCarteCuAutorTranzactiiSeparate.'
END;

--nu se insereaza date in niciun tabel din cauza validarilor facute (pret negativ si data nasterii eronata)
--deja executat
EXEC uspAdaugaCarteCuAutorTranzactiiSeparate 'Pupaza din Mortii Tei', 2018, 'Editura Vaslui', 'Umor', 1, -38.5, 'Gabriel Dumitriu', 'Romania', '2983-10-19';

--inserarea cartii esueaza (din cauza pretului negativ)
--se face inserarea autorului
--inserarea in tabelul de legatura esueaza (din cauza ca nu a fost introdusa cartea)
--deja executat
EXEC uspAdaugaCarteCuAutorTranzactiiSeparate 'Pupaza din Mortii Tei', 2018, 'Editura Vaslui', 'Umor', 1, -38.5, 'Mihai Eminescu', 'Romania', '1850-01-15';

--se insereaza entitati in toate cele 3 tabele (toti parametrii sunt valizi)
--deja executat
EXEC uspAdaugaCarteCuAutorTranzactiiSeparate 'Sub aceeasi stea', 2013, 'Trei', 'Modern', 0, 36, 'John Green', 'SUA', '1977-08-24';

--se insereaza entitati in toate cele 3 tabele (toti parametrii sunt valizi)
--trebuie executat
EXEC uspAdaugaCarteCuAutorTranzactiiSeparate 'Ion', 2017, 'Eduard', 'Clasici', 1, 13, 'Liviu Rebreanu', 'Romania', '1885-11-27';

--se face inserarea cartii
--inserarea autorului esueaza (din cauza datei nasterii)
--inserarea in tabelul de legatura esueaza (din cauza ca autorul nu a fost introdus)
--trebuie executat
EXEC uspAdaugaCarteCuAutorTranzactiiSeparate 'Enigma Otiliei', 2017, 'Cartex', 'Bibliografie scolara', 1, 19.20, 'George Calinescu', 'Romania', '2099-06-19';

--se face inserarea cartii
--inserarea autorului esueaza (din cauza datei nasterii)
--inserarea in tabelul de legatura esueaza (din cauza ca autorul nu a fost introdus)
--deja executat
EXEC uspAdaugaCarteCuAutorTranzactiiSeparate 'Pulbere de stele', 2015, 'Arthur', 'Carti pentru copii', 0, 39.90, 'Neil Gaiman', 'Regatul Unit al Marii Britanii', '2060-11-10';