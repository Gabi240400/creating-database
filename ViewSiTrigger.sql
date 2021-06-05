USE Cartis;

--Cartile care sunt scrise de 2 sau mai multi autori
CREATE OR ALTER VIEW vwCartiCuMaiMultiAutori
AS
SELECT CartiSiAutori.titlu FROM
(SELECT Carti.titlu, Autori.nume_complet FROM Carti
INNER JOIN 
CartiAutori ON Carti.id_carte = CartiAutori.id_carte
INNER JOIN 
Autori ON Autori.id_autor = CartiAutori.id_autor) AS CartiSiAutori
GROUP BY CartiSiAutori.titlu
HAVING COUNT(CartiSiAutori.titlu) > 1;

SELECT * FROM vwCartiCuMaiMultiAutori;

CREATE OR ALTER TRIGGER La_inserare_carte 
ON Carti
FOR INSERT
AS
BEGIN
PRINT 'In tabelul Carti s-a efectuat operatia insert la data si ora: ' + CAST(GETDATE() AS VARCHAR)
END;

EXEC uspAdaugaCarte 'Ganduri catre sine insusi',2020,'Humanitas','Etica si morala',1,29;
SELECT * FROM Carti;

CREATE OR ALTER TRIGGER La_stergere_carte
ON Carti
FOR DELETE
AS
BEGIN
PRINT 'In tabelul Carti s-a efectuat operatia delete la data si ora: ' + CAST(GETDATE() AS VARCHAR)
END;

DELETE FROM Carti WHERE titlu='Ganduri catre sine insusi';
SELECT * FROM Carti;
