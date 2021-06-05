USE Cartis;

--Validare an publicatie (anul publicarii cartii sa nu fie mai mare decat anul curent)
CREATE OR ALTER FUNCTION ufValidareAnPublicatie
(@an_publicatie INT)
RETURNS BIT AS
BEGIN
DECLARE @ok BIT=1
IF (@an_publicatie > YEAR(GETDATE()))
SET @ok=0
RETURN @ok
END;

PRINT dbo.ufValidareAnPublicatie(2021); --0
PRINT dbo.ufValidareAnPublicatie(2020); --1
PRINT dbo.ufValidareAnPublicatie(2019); --1


--Validare pret (pretul nu are voie sa fie 0 sau negativ)
CREATE OR ALTER FUNCTION ufValidarePret
(@pret FLOAT)
RETURNS BIT AS
BEGIN
DECLARE @ok BIT = 1
IF (@pret <= 0)
SET @ok=0
RETURN @ok
END;

PRINT dbo.ufValidarePret(21.59);  --1
PRINT dbo.ufValidarePret(0);      --0
PRINT dbo.ufValidarePret(-13.12); --0


--Validare cod postal (acesta trebuie sa aiba fix 6 cifre)
CREATE OR ALTER FUNCTION ufValidareCodPostal
(@cod_postal VARCHAR(6))
RETURNS BIT AS
BEGIN
DECLARE @ok BIT = 1
IF(LEN(@cod_postal) <> 6)
SET @ok=0
RETURN @ok
END;

PRINT dbo.ufValidareCodPostal('900565');  --1
PRINT dbo.ufValidareCodPostal('90056');   --0


--Validare nr_carti (nu poate fi 0 sau negativ)
CREATE OR ALTER FUNCTION ufValidareNrCarti
(@nr_carti INT)
RETURNS BIT AS
BEGIN
DECLARE @ok BIT = 1
IF(@nr_carti <= 0)
SET @ok = 0
RETURN @ok
END;

PRINT dbo.ufValidareNrCarti(2);  --1
PRINT dbo.ufValidareNrCarti(0);  --0
PRINT dbo.ufValidareNrCarti(-1); --0

--Procedura care adauga o carte in tabel
CREATE OR ALTER PROCEDURE uspAdaugaCarte
(@titlu VARCHAR(100), @an_publicatie INT, @editura VARCHAR(30), @categorie VARCHAR(30), @disp_online BIT, @pret FLOAT)
AS
BEGIN 
IF (dbo.ufValidareAnPublicatie(@an_publicatie) = 1 AND dbo.ufValidarePret(@pret) = 1)
	INSERT INTO Carti(titlu, an_publicatie, editura, categorie, disp_online, pret)
	VALUES(@titlu, @an_publicatie, @editura, @categorie, @disp_online, @pret)
ELSE
	RAISERROR('Una dintre valorile introduse nu este valida',11,1)
END;


--Procedura care adauga o comanda noua in tabel
CREATE OR ALTER PROCEDURE uspAdaugaComanda
(@id_client INT, @adresa_livrare VARCHAR(100), @cod_postal VARCHAR(6), @metoda_plata VARCHAR(4), @stare_comanda VARCHAR(15))
AS
BEGIN
IF(dbo.ufValidareCodPostal(@cod_postal) = 1)
	INSERT INTO Comenzi(id_client, adresa_livrare, cod_postal, metoda_plata, stare_comanda)
	VALUES(@id_client, @adresa_livrare, @cod_postal, @metoda_plata, @stare_comanda)
ELSE
	RAISERROR('Una dintre valorile introduse nu este valida',11,1)
END;


--Procedura care adauga o carte la o comanda
CREATE OR ALTER PROCEDURE uspAdaugaCarteLaComanda
(@id_comanda INT, @id_carte INT, @nr_carti INT, @pret FLOAT)
AS
BEGIN
IF(dbo.ufValidareNrCarti(@nr_carti) = 1 AND dbo.ufValidarePret(@pret) = 1)
	INSERT INTO CartiComenzi(id_comanda, id_carte, nr_carti, pret)
	VALUES(@id_comanda, @id_carte, @nr_carti, @pret)
ELSE
	RAISERROR('Una dintre valorile introduse nu este valida',11,1)
END;

SELECT * FROM Carti;
EXEC uspAdaugaCarte 'Mitologia nordica',2018,'Arthur Gold','Fantasy',1,49.90; --executat deja
EXEC uspAdaugaCarte 'Buzunarul cu pupici',2020,'Paperback','Fantasy',1,20; --eroare

SELECT * FROM Comenzi;
SELECT * FROM Clienti;
EXEC uspAdaugaComanda 3,'Bd. Tomis 110 Constanta Constanta',900513,'card','in procesare'; --executat deja 
EXEC uspAdaugaComanda 3,'Prelungirea Macului 23 Cumpana Constanta',907105,'cash','in procesare'; --eroare

SELECT * FROM Carti;
SELECT * FROM Comenzi;
SELECT * FROM CartiComenzi;
EXEC uspAdaugaCarteLaComanda 7,5,1,45.5 --executat deja
EXEC uspAdaugaCarteLaComanda 7,14,2,29.9 --eroare